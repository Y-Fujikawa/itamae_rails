# itamae_rails
## Introduction
Provisioning to Server used Itamae

## Usage
Bundle install

```
$ bundle install
```

Copy and rename node.json.sample to node.json

```
$ cp node/node.json.sample node/node.json
```

Create SHA256 user password

```
$ gem install unix-crypt
$ mkunixcrypt -s "salt"
Enter password:
Verify password:
$6$salt$...
```

Created password rewrite node.json and set ssh key

```json
 "user": {
    "name": "sample",
    "password": "sample", # rewrite
    "ssh_key": "sample"   # Set your ssh key
  }
```

Execute provision

Host
```
bundle exec itamae ssh -h [IP Address] -i [SSH Private Key file] -j nodes/node.json recipes/recipe.rb
```

Vagrant
```
bundle exec itamae ssh --vagrant -j nodes/node.json recipes/recipe.rb
```

### Test (Vagrant Only)
Add ssh config
```
Host vagrant.local
  HostName 192.168.33.20
  Port 22
  User www
  IdentityFile ~/.ssh/[SSH Private Key file]
```

Setting sudo
```
vagrant ssh

visudo
www   ALL=(ALL)       ALL
```

Run
```
SUDO_PASSWORD=[Input Password] rake spec
```
