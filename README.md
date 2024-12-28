# github-auto-deployer
Automate deployments from GitHub to your server using Webhooks

## Getting started
First Login to your server(Where you want to deploy to)

`git clone https://github.com/yezyilomo/github-auto-deployer`

`cd github-auto-deloyer`

`bash install.sh`

Running `install.sh` script should install all required dependencies and create `app.conf` and `deployment.yml` files in your folder, now open these two created files and finish setting up few things as explained below.

Add Webhook Secret from the repository you want to deploy and put it on `<Put Your Webhook Secret Here>`  in `github-auto-deployer/app.conf` file.

To add a webhook go to Your GitHub repository > Settings > Webhooks > Add Webhook, Here you have to 
- Add your server URL(The one pointing to github-auto-deployer service e.g https://yourserveraddress.com:6767)
- Add Content type(Use application/json)
- Add the Webhook secret
- And finally you will have to specify events you would like to trigger this webhook, here you can select(check) Pull requests, this will trigger your webhook only when you create a pull request or merge(close) it, but the deployment will be done only when you merge your PR to the main branch.

Configure the way to deploy your repository on `github-auto-deployer/deployment.yml` file. E.g

```yaml
# deployment.yml

my_repository:  # Repository Name(Should match the one on GitHub)
  - directory:  # Repository's working directory 
      - /path/to/my_repository/
  - get_changes:  # Commands to get new changes(git pull origin $current-branch is the default)
      - git pull origin main
  - script:  # script name to run during deployment(deployment.sh is the default)
      - deployment.sh
```

Add `deployment.sh` file to your repository, this is a script to run when deploying your project. E.g

```bash
# deployment.sh

npm install
npm run build
```

To start deployment service run `start.sh` script i.e

`bash start.sh`

:tada: That's it.. :tada: 

Your service will be running on port 6767 by default, You can try to access it with https://yourserveraddress.com:6767, If you want to run on another port you can specify it with `PORT` option in `app.conf` file.


More options
- `update.sh`: This script is used to update GitHub auto deployer, it gets latest changes and install them without changing your configuration files(`app.conf` and `deployment.yml`)

- To allow deployment service to start automatically when your server is rebooted use `pm2 startup`, check https://pm2.keymetrics.io/docs/usage/startup/ for more details on pm2 Startup script.

**Note:** If your repository is private you should add deploy key to it for your server to be able to pull changes without requiring your GitHub credentials. If you want to know how to generate and add deploy key to your GitHub repository visit https://developer.github.com/v3/guides/managing-deploy-keys/#deploy-keys.