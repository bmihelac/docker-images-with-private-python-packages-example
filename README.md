# Examples for building docker images with private python packages

This is repository for accompanying [Medium](https://medium.com/@bmihelac/examples-for-building-docker-images-with-private-python-packages-6314440e257c)
article.

Installing private python packages into Docker container can be tricky because
container does not have access to private repositories and you do not want to
leave trace of private ssh key in docker images.

Here are two methods that can be used.

## 1. Build docker image with intermediate image

This method passes private ssh key to intermediate docker image that would be
deleted after creating image.

```bash
docker build --force-rm -t test-multi-stage-builds --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)" .
```

Description of `Dockerfile`:

1. create intermediate image
2. download python packages to intermediate image
3. create new image
4. copy python packages from intermediate image
5. install downloaded packages

Command arguments:

`--force-rm` - forces deleting intermediate images, even if build fails
`-t test-multi-stage-builds` - image name
`--build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)"` - set build-time variable
    so private repository can be accessed from intermediate image

## 2. Build docker image with deploy keys

This method depends on adding deploy/access key to every private repository.
It would be possible to access repository from container until key is revoked.

```bash
docker build -t test-with-deploy-keys --build-arg SSH_PRIVATE_KEY="$(cat ./deploy_key)" -f Dockerfile-deploykeys .
```

## docker-compose example

Here is an example of passing private key to `docker-compose build`.

```bash
docker-compose build --build-arg SSH_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)"
```
