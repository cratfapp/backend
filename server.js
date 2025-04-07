// const {app} = require('./app.js');
// const connectDB = require('./dbconnection.js');
// const port = 3001;
// // connectDB()
// app.listen(port, () => {
//     console.log(`API server running on http://localhost:${port}`);
//   });


const http = require('http');
const port = process.env.PORT || 8080;

// Create simple HTTP server
const server = http.createServer((req, res) => {
  // Health check endpoint
  if (req.url === '/health') {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('OK');
    return;
  }

  // Default response
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('🚀 Deployment Successful!');
});

// Start server
server.listen(port, '0.0.0.0', () => {
  console.log(`Server running at http://0.0.0.0:${port}`);
});

// Handle shutdown gracefully
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
  });
});