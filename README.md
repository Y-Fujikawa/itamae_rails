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
