# itamae_rails
## Usage
Bundle install

```
$ bundle install
```

Copy and rename node/node.json.sample

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
    "name": "www",
    "password": "sample", # rewrite
    "ssh_key": "sample"   # Set your ssh key
  }
```

Execute provision

```
bundle exec itamae ssh --vagrant -j nodes/node.json recipes/recipe.rb
```
