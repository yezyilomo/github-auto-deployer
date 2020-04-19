# github-auto-deployer
Automate deployments from GitHub to your server using Webhooks

## Getting started
First Login to your server(Where you want to deploy to)

`git clone https://github.com/yezyilomo/github-auto-deployer`

`cd github-auto-deloyer`

`bash install.sh`

Running `install.sh` script should create `.github-auto-deployer` directory on your home directory, now go to that directory and finish setting up few things as explained below.

Add Webhook Secret from the repository you want to deploy and put it on `<Your Webhook Secret>`  in `.github-auto-deployer/app.conf` file.

To add a webhook go to Your GitHub repository > Settings > Webhooks > Add Webhook, Here you have to 
- Add your server URL(The one pointing to github-auto-deployer service e.g https://yourserveraddress.com:6767)
- Add Content type(Use application/json)
- Add the Webhook secret
- And finally you will have to specify events you would like to trigger this webhook, here you can select(check) Pull requests, this will trigger your webhook only when you create a pull request or merge(close) it, but the deployment will be done only when you merge your PR to master branch.

Configure the way to deploy your repository on `.github-auto-deployer/deployment.yml` file. E.g

```yaml
my_repository:  # Repository Name(Should match the one on GitHub)
  - directory:  # Repository's working directory 
      - /path/to/my_repository/
  - get_changes:  # Commands to get new changes(git pull origin master is the default)
      - git pull origin master
  - script:  # script name to run during deployment(deployment.sh is the default)
      - deployment.sh
```

Run `start.sh` script i.e

`bash start.sh`

That's it..

Your service will be running on port 6767 by default, You can try to access it with https://yourserveraddress.com:6767, If you want to run on another port you can specify it with `PORT` option in `app.conf` file.

NOTE: All configurations should be done on `~/.github-auto-deployer` directory which is created after running `install.sh` script, You should change nothing on the directory of cloned repository.

More options
- `update.sh`: This script is used to update GitHub auto deployer, it gets latest changes and install them without changing your configuration files(`app.conf` and `deployment.yml`)

- `uninstall.sh`: This is used to uninstall GitHub auto deloyer, it basically deletes the `~/.github-auto-deployer` directory.

- To allow deployment service to start automatically when your server is rebooted use `pm2 startup`, check https://pm2.keymetrics.io/docs/usage/startup/ for more details on pm2 Startup script.