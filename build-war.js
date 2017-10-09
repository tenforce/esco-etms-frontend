var fs = require('fs');
var path = require('path');
var archiver =  require('archiver');

var archive = archiver('zip')
var output = fs.createWriteStream('client.war');

archive.pipe(output);
archive.on('error', function(err) { throw err });
archive.on('entry', function(entry) {
  console.log('Added:', entry.name);
});

archive.directory('dist', '/');
archive.finalize();
