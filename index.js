const fs = require("fs");
const http = require('http');
const yaml = require('js-yaml');
const shell = require('shelljs');
const createHandler = require('github-webhook-handler');


// We avoid to hardcode the secret in the code, 
// You should provide it with an ENV variable before running this script
const MY_SECRET = process.env.MY_SECRET;

// Deployment config file
const CONF_FILE = process.env.CONF_FILE;

// Port is default on 6767
const PORT = process.env.PORT || 6767;

let fileContents = fs.readFileSync(CONF_FILE, 'utf8');
let scripts = yaml.safeLoadAll(fileContents)[0];

var handler = createHandler({ path: '/', secret: MY_SECRET });

http.createServer(function (req, res) {
    handler(req, res, function (err) {
        res.statusCode = 404
        res.end('No such location')
    })
}).listen(PORT);

handler.on('error', function (err) {
    console.error('Error:', err.message)
})

handler.on('pull_request', function (event) {
    const repository = event.payload.repository.name;
    const action = event.payload.action;

    console.log('Received a Pull Request for %s to %s', repository, action);
    // the action of closed on pull_request event means either it is merged or declined
    if (scripts[repository] !== undefined && action === 'closed') {
        // we should deploy now
        console.log('Deploying %s...', repository);
        shell.exec(scripts[repository].join(" && "));
    }
});