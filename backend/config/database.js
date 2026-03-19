const mongoose = require("mongoose");

const connectDB = async () => {
  try {
    const mongoURI =
      process.env.MONGO_URI || "mongodb://127.0.0.1:27017/heartsafe";

    await mongoose.connect(mongoURI);

    console.log("✅ MongoDB connected");
    console.log(`📊 Database: heartsafe`);
    
    // Initialize collections if they don't exist
    await initializeCollections();
    
  } catch (error) {
    console.error("❌ MongoDB connection failed:", error.message);
    process.exit(1);
  }
};

// Initialize collections
const initializeCollections = async () => {
  try {
    const db = mongoose.connection.db;
    
    // Get list of existing collections
    const collections = await db.listCollections().toArray();
    const collectionNames = collections.map(col => col.name);
    
    console.log("\n📋 Initializing collections...");
    
    // Create collections if they don't exist
    if (!collectionNames.includes('users')) {
      await db.createCollection('users');
      console.log("✓ Created 'users' collection");
    }
    
    if (!collectionNames.includes('predictions')) {
      await db.createCollection('predictions');
      console.log("✓ Created 'predictions' collection");
    }
    
    if (!collectionNames.includes('followups')) {
      await db.createCollection('followups');
      console.log("✓ Created 'followups' collection");
    }
    
    if (!collectionNames.includes('reports')) {
      await db.createCollection('reports');
      console.log("✓ Created 'reports' collection");
    }
    
    console.log("✅ All collections ready!\n");
    
  } catch (error) {
    console.error("⚠️  Warning initializing collections:", error.message);
    // Don't exit - collections will be created on first insert
  }
};

module.exports = connectDB;
