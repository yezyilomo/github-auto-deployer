const fs = require('fs');
const http = require('http');
const yaml = require('js-yaml');
const shell = require('shelljs');
const createHandler = require('github-webhook-handler');


// We avoid to hardcode the secret in the code, 
// You should provide it with an ENV variable before running this script
const MY_SECRET = process.env.MY_SECRET;

// Get application directory
const APP_DIR = process.env.APP_DIR;

// Get deployment scripts file
const DEPLOYMENT_FILE = process.env.DEPLOYMENT_FILE;

// Get host if not provided us "0.0.0.0" as the default
const HOST = process.env.HOST || "0.0.0.0";

// Get port if not provided us 6767 as the default
const PORT = process.env.PORT || 6767;

var handler = createHandler({ path: '/', secret: MY_SECRET });

http.createServer(function (req, res) {
    handler(req, res, function (err) {
        let pathname = "/";

        try {
            // Using a static base avoids malformed Host header crashes
            pathname = new URL(req.url, 'http://localhost').pathname;
        } catch {
            // Handle malformed URLs (e.g., return a 400 Bad Request)
            res.writeHead(400);
            return res.end('Bad Request');
        }

        if (pathname === "/" && req.method === "GET") {
            console.log(`${APP_DIR}/index.html`)
            fs.readFile(`${APP_DIR}/index.html`, function (err, data) {
                if (err) {
                    res.writeHead(500, { 'Content-Type': 'text/plain' });
                    return res.end('Internal Server Error');
                }

                res.writeHead(200, {
                    'Content-Type': 'text/html', 'Content-Length': data.length
                });
                res.end(data);
            });
        }
        else {
            console.log("No request handler found for " + pathname);
            res.writeHead(404, { "Content-Type": "text/plain" });
            res.end("404 Not found");
        }
    })
}).listen(PORT, HOST);


function repoConfig(configFilePath, repo) {
    const fileContents = fs.readFileSync(configFilePath, 'utf8');
    const config = yaml.loadAll(fileContents)[0];
    if (config[repo] !== undefined) {
        return config[repo];
    }
    return undefined; // No config for given repository
}

function getConfig(configObj, configName) {
    const configVal = configObj.find(config => config[configName]);

    if (configVal !== undefined) {
        return configVal[configName];
    }
    const DEFAULT_CONFIG = {
        "directory": [undefined],  // Default repository's directory
        "get_changes": ["git pull origin $(git branch --show-current)"],  // Pull from the current branch
        "script": ["deployment.sh"],  // Default deployment script name
    }
    return DEFAULT_CONFIG[configName]
}


handler.on('pull_request', function (event) {
    const repository = event.payload.repository.name;
    const action = event.payload.action;
    const isMerged = event.payload.pull_request.merged;

    console.log('Received a Pull Request for %s to %s', repository, action);
    // The action `closed` on pull_request event means it is either merged or declined
    if (action === 'closed' && isMerged) {
        // Read deployment repository configuration
        const config = repoConfig(DEPLOYMENT_FILE, repository);

        console.log("Loaded repository configurations");
        console.log(config);

        if (config !== undefined) {
            // We should run deployment scripts
            const directory = getConfig(config, "directory")[0];
            if (directory === undefined) {
                console.log('Directory is not configured for %s repository.', repository);
                return
            }

            const deploymentScriptName = getConfig(config, "script")[0];
            const getChanges = getConfig(config, "get_changes");

            console.log('Deploying %s...', repository);
            console.log('Getting changes command: %s', getChanges);

            const preDeploymentCommands = [
                `cd ${directory}`,  // Go to repository directory
                ...getChanges  // Get latest changes from GitHub
            ];
            shell.exec(preDeploymentCommands.join(" && "));  // Run pre-deployment commands

            const runDeploymentScript = `cd ${directory} && bash ${deploymentScriptName}`;
            shell.exec(runDeploymentScript);  // Run deployment script

            console.log('Deployment of %s is done.', repository);
        }
        else {
            console.log('No configuration for %s repository.', repository);
        }
    }
});

handler.on('error', function (err) {
    console.error('Error:', err.message)
})