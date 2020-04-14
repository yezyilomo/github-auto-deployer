const fs = require('fs');
const url = require("url");
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

// Get port if not provided us 6767 as the default
const PORT = process.env.PORT || 6767;

var handler = createHandler({ path: '/', secret: MY_SECRET });

http.createServer(function (req, res) {
    let pathname = url.parse(req.url).pathname;
    handler(req, res, function (err) {
        if (req.url === "/" && req.method === "GET"){
            console.log(`${APP_DIR}/index.html`)
            fs.readFile(`${APP_DIR}/index.html`,function (err, data){
                res.writeHead(200, {'Content-Type': 'text/html','Content-Length': data.length});
                res.write(data);
                res.end();
            });
        }
        else {
            console.log("No request handler found for " + pathname);
            res.writeHead(404, {"Content-Type": "text/plain"});
            res.write("404 Not found");
            res.end();
        }
    })
}).listen(PORT);

handler.on('error', function (err) {
    console.error('Error:', err.message)
})


function repoConfig(configFilePath, repo){
    const fileContents = fs.readFileSync(configFilePath, 'utf8');
    const config = yaml.safeLoadAll(fileContents)[0];
    if (config[repo] !== undefined){
        return config[repo][0];
    }
    return undefined; // No config for given repository
}

function getConfig(configObj, configName){
    if (configObj[configName] !== undefined){
        return configObj[configName][0]
    }
    const DEFAULT_CONFIG = {
        "branch": "master",
        "strategy": "pull",
        "script": "deployment.sh"
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

        if (config !== undefined){
            // We should run deployment scripts
            const directory = getConfig(config, "directory");
            if (directory === undefined){
                console.log('Directory is not configured for %s repository.', repository);
                return
            }
            
            const branch = getConfig(config, "branch");
            const script = getConfig(config, "script");
            const strategy = getConfig(config, "strategy");
            const strategies = {
                "pull": `git pull origin ${branch}`,
                "fetch-merge": `git fetch origin ${branch} && git merge`
            }
            const strategyCommand = strategies[strategy];
            const commands = [`cd ${directory}`, strategyCommand];
            
            console.log('Deploying %s...', repository);
            shell.exec(commands.join(" && "));
            const deploymentScript = `${directory.replace(/\/$/, "")}/${script}`
            shell.exec(deploymentScript)
            console.log('Deployment of %s is done.', repository);
        }
        else{
            console.log('No configuration for %s repository.', repository);
        }
    }
});