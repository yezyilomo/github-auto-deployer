const fs = require('fs');
const http = require('http');
const yaml = require('js-yaml');
const shell = require('shelljs');
const createHandler = require('github-webhook-handler');


// We avoid to hardcode the secret in the code, 
// You should provide it with an ENV variable before running this script
const MY_SECRET = process.env.MY_SECRET;

// Deployment scripts file
const DEPLOYMENT_FILE = process.env.DEPLOYMENT_FILE;

// Port is default on 6767
const PORT = process.env.PORT || 6767;

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
    // Read deployment scripts
    const repository = event.payload.repository.name;
    const action = event.payload.action;

    console.log('Received a Pull Request for %s to %s', repository, action);
    // The action of closed on pull_request event means either it is merged or declined
    if (action === 'closed') {
        // Read deployment scripts
        const fileContents = fs.readFileSync(DEPLOYMENT_FILE, 'utf8');
        const scripts = yaml.safeLoadAll(fileContents)[0];

        if (scripts[repository] !== undefined){
            // We should run deployment scripts
            console.log('Deploying %s...', repository);
            shell.exec(scripts[repository].join(" && "));
            console.log('Deployment of %s is done.', repository);
        }
        else{
            console.log('No deployment scripts for %s repository.', repository);
        }
    }
});