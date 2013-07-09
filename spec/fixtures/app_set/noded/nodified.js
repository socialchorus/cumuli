var http = require('http');

var port = process.env.PORT;

http.createServer(function(request, response) {
  console.log('Looping in node:', request.method, request.url, '\n');
}).listen(port);
