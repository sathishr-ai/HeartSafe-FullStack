module.exports = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) {
    return res.status(401).json({
      success: false,
      message: "No token provided"
    });
  }

  const token = authHeader.split(" ")[1];

  if (!token || !token.startsWith("token_")) {
    return res.status(401).json({
      success: false,
      message: "Invalid token"
    });
  }

  next();
};
