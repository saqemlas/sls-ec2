# EC2

## Info

This stack deploys the minimal needed to run an EC2 instance accessible on the internet; networking, monitoring, alerting are all included.

Resources included are...
- Network: vpc, acl, subnet, routetable & routes, internet gateway, elastic ip, security group, ssh key pair.
- Monitoring: cloudwatch agent install on the ec2 for cloudwatch metrics and logs.
- Alerting: sns for notifications and cloudwatch alarms for memory, cpu, disk, system status usage.

## Scripts

An example path might be `~/.ssh/ec2_app`.

### Generate SSH Keys
```bash
ssh-keygen -t <rsa|ed25519> -m PEM -b 4096 -C <email|test@email.com> -f <path|~/.ssh/ec2_app> -P ""
chmod 400 <path|~/.ssh/ec2_app>
```

- Add public key to infra/files/ directory as `ec2_app.pub`


## Development

### Install:
```
yarn install
```

### Deploy:
```
yarn run deploy
```

### SSH into Ingest Server
```bash
bash scripts/get_ssh_command.sh --path ~/.ssh/ec2_app
```

- Copy the output and ssh into instance.

### Access in Browser
```bash
bash scripts/get_public_ip.sh
```

- Copy the output into browser.

### Remove:
```
yarn run remove
```
