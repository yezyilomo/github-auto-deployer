# github-auto-deployer
Automated GitHub deployment using Webhooks

#Getting started

`git clone https://github.com/yezyilomo/github-auto-deployer`

`cd github-auto-deloyer`

`bash install.sh`

Running install.sh script should create .github-auto-deployer on your home directory, now go to that directory and finish setting up few things as explained below.

Add Webhook Secret from the repository you want to deploy and put it on <Your Webhook Secret> in `.github-auto-deployer/start.sh` file. To add a webhook go to Your GitHub repository > Settings > Webhooks > Add Webhook, Here you have to add your server URL(The one pointing to github-auto-deployer service e.g https://yourserveraddress.com:6767) and the Webhook secret, you will also have to specify events you would like to trigger this webhook, Here you can select(check) Pull requests, this will trigger your webhook only when you create a pull request or merge(close) it, but the deployment will be done only when you merge your PR to master branch.

Write your deployment scripts on `.github-auto-deployer/deployment.yml` file.

Run `start.sh` script i.e

`bash start.sh`

That's it..

Your service will be running on port 6767 by default, You can try to access it with https://yourserveraddress.com:6767, If you want to run on another port you can specify it with `PORT` option in `start.sh` script

NOTE: All configurations should be done on `~/.github-auto-deployer` directory which is created after running `install.sh` script, You should change nothing on the directory of cloned repository.