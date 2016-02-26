# Docker Backblaze B2 command line tool image

[![andreausu/backblaze-b2](http://dockeri.co/image/andreausu/backblaze-b2)](https://registry.hub.docker.com/u/andreausu/backblaze-b2/)

Docker image for the official Backblaze B2 command line tool ([Backblaze/B2_Command_Line_Tool](https://github.com/Backblaze/B2_Command_Line_Tool))

## Supported tags and respective `Dockerfile` links

-	[`0.4.0`, `0.4`, `0`, `latest` (*Dockerfile*)](https://github.com/andreausu/docker-backblaze-b2/blob/master/Dockerfile)

## How to use it

Before you can use any endpoint you have to perform the authorization by using the `authorize_account` command that will create the `/root/.b2_account_info` file that will be needed every time you perform actions on B2.
This docker image can do that for you, plus refresh the authorization token every time that the authorization fails if you just define the `B2_ACCOUNT_ID` and `B2_APPLICATION_KEY` environment variables.

So you can use B2 just by passing the `B2_ACCOUNT_ID` and `B2_APPLICATION_KEY` environment variables to the `docker run` command, eg:

```
docker run --rm -v $PWD:/root -e B2_ACCOUNT_ID=your-account-id -e B2_APPLICATION_KEY=your-application-key andreausu/backblaze-b2 list_buckets
```

You can see all the available commands by running:

```
docker run --rm andreausu/backblaze-b2
```

## Additional commands

This docker image provides some useful additional commands you can use:

- `upload_file_replace` this will upload a file and then immediately delete all previous versions of that file

Usage:

```
docker run --rm -v $PWD:/root -e B2_ACCOUNT_ID=your-account-id -e B2_APPLICATION_KEY=your-application-key andreausu/backblaze-b2 upload_file_replace bucketName localFilePath remoteFilePath
```

## Build and update process

This image is automatically built at every push of this repository and every time that the `python:2.7-slim` base image gets updated in order to ensure that bugfixes and security updates are immediately applied.
