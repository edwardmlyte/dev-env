# IntelliJ
_This is a guide for executing IntelliJ using a docker container. The container image is maintained by [rycus86](https://hub.docker.com/r/rycus86/intellij-idea/)_

## overview
The intention of executing [IntelliJ](https://www.jetbrains.com/idea/) through a docker container is to enable an easier upgrade path with minimal user maintenance.

## prerequisites
You'll need:
- [Docker](https://www.docker.com/), see [Docker for MacOS](https://hub.docker.com/editions/community/docker-ce-desktop-mac).
- [XQuartz](https://www.xquartz.org/)

## run
To execute IntelliJ, perform the following:
```
$ git clone https://github.com/cagiti/dev-env
$ cd dev-env
$ git checkout java
$ ./intellij
```
## support
The execution of this IntelliJ container has only been verified on **MacOS**.
