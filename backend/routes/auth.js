const express = require('express');
const router = express.Router();
const User = require('../models/User');

// Initialize default users in MongoDB on first run
const initializeDefaultUsers = async () => {
  try {
    const defaultUsers = [
      { username: 'Sathish', password: 'password123', role: 'doctor' },
      { username: 'Jaipreethika', password: 'password123', role: 'nurse' },
      { username: 'admin', password: 'admin123', role: 'admin' }
    ];

    for (const userData of defaultUsers) {
      const existingUser = await User.findOne({ username: userData.username });
      if (!existingUser) {
        await User.create(userData);
        console.log(`✓ Created default user: ${userData.username}`);
      }
    }
  } catch (error) {
    console.error('Error initializing default users:', error.message);
  }
};

// Initialize users when this module loads
initializeDefaultUsers();

// Login endpoint
router.post('/login', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({
      success: false,
      message: 'Username and password are required'
    });
  }

  try {
    // Find user in MongoDB
    const user = await User.findOne({ username });

    if (!user || user.password !== password) {
      return res.status(401).json({
        success: false,
        message: 'Invalid username or password'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Login successful',
      token: `token_${username}_${Date.now()}`,
      user: { username, role: user.role }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error during login: ' + error.message
    });
  }
});

// Register endpoint
router.post('/register', async (req, res) => {
  const { username, password, role } = req.body;

  if (!username || !password) {
    return res.status(400).json({
      success: false,
      message: 'Username and password are required'
    });
  }

  try {
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(409).json({
        success: false,
        message: 'Username already exists'
      });
    }

    const newUser = await User.create({
      username,
      password,
      role: role || 'nurse' // Default role
    });

    res.status(201).json({
      success: true,
      message: 'Registration successful',
      user: { username: newUser.username, role: newUser.role }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error during registration: ' + error.message
    });
  }
});

// Logout endpoint
router.post('/logout', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Logout successful'
  });
});

module.exports = router;