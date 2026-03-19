const errorHandler = (err, req, res, next) => {
  const status = err.status || err.statusCode || 500;
  const message = err.message || 'Internal Server Error';
  
  console.error(`[ERROR] ${status}: ${message}`);
  
  res.status(status).json({
    success: false,
    message: message,
    status: status
  });
};

module.exports = { errorHandler };
