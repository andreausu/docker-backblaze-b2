# Docker Backblaze B2 command line tool image

Docker image for the official Backblaze B2 command line tool (https://github.com/Backblaze/B2_Command_Line_Tool)

## Supported tags and respective `Dockerfile` links

-	[`0.3.9`, `0.3`, `0`, `latest` (*Dockerfile*)](https://github.com/primait/docker-filebeat/blob/master/Dockerfile)

## Build and update process

This image is automatically built at every push of this repository and every time that the `python:2.7-slim` base image gets updated in order to ensure that bugfixes and security updates are immediately applied.

## Run

First, you need to authorize your account.
This will create the `.b2_account_info` file that will be needed every time you perform actions on B2.

`docker run --rm -v $PWD/.b2_account_info:/root/.b2_account_info andreausu/backblaze-b2 authorize_account accountId applicationKey`

Then you can perform all the other operations, eg:

`docker run --rm -v $PWD/.b2_account_info:/root/.b2_account_info andreausu/backblaze-b2 list_buckets`

You can see all the available commands by running:

`docker run --rm andreausu/backblaze-b2`

## Working with an etcd or consul cluster (CoreOS, Kubernetes, Docker Swarm)

If you need to use the B2 command line tool from a cluster, chances are that you can't easily use the default file based auth method, but you instead would like to have those info encrypted and stored into your distributed K/V store of choice.
In order to do that you could do something like this:

The first command is a one-off, so you could run it from your laptop:

`docker run --rm -v $PWD/.b2_account_info:/root/.b2_account_info andreausu/backblaze-b2 authorize_account accountId applicationKey`

Now encrypt and store the config in the K/V store, using for example [crypt](https://xordataexchange.github.io/crypt/):

`crypt set -keyring pubring.gpg /secrets/backblaze-b2 $PWD/.b2_account_info`

Every time that you need to use B2 just get the config and temporarily store it in a file, eg:

```
$ crypt get -secret-keyring secring.gpg /secrets/backblaze-b2 > $PWD/.b2_account_info
$ docker run --rm -v $PWD/.b2_account_info:/root/.b2_account_info andreausu/backblaze-b2 list_buckets
$ rm $PWD/.b2_account_info
```
