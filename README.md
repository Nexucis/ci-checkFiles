CI-CheckFiles
=============
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](./LICENSE)

1. [Overview](#overview) 
2. [Getting Started](#getting-started)
3. [Do the same in continuous integration](#do-the-same-in-continuous-integration)
   1. [Circle-CI](#circle-ci)
   2. [Gitlab-CI](#gitlab-ci)
   3. [Travis-ci](#travis-ci)
4. [Run the script without docker](#run-the-script-without-docker)
5. [Contributions](#contributions)
6. [License](#license)

## Overview

This project provides a docker images with two scripts to check the encoding file and the end-of-line of the file in a project. This image can be used in a continuous integration system like **circle-ci** or **gitlab-ci**. 

The image is available on [docker hub](https://hub.docker.com/r/nexucis/ci-checkfiles/)

## Getting Started

### Check encoding
The tool who does the job (named **checkEncoding**), tooks as a first parameter the encoding target to check. 
As the tool uses [uchardet](https://www.freedesktop.org/wiki/Software/uchardet/), we can have all supported encoding by uchardet.

As the second parameter, the tool takes all files that you want to check. It can take a regex too.

For example, you want to check if the files of your current project (let's say a Java project build with maven) is encoding in utf-8, you could use the tool like this: 

```bash
docker run --rm -v ${PWD}:/var/workspace/project nexucis/ci-checkfiles /bin/bash -c "cd /var/workspace/project && checkEncoding utf-8 *.md *.java *.xml"
``` 

### Check end-of-line
For the moment, the tool (named **checkEOL**) checks only if the files have an UNIX end-of-line.

The tool takes only one thing : the kind of document that you want to check.

If we use the same example used in the "Check encoding" section, we could use the tool like this:

```bash
docker run --rm -v ${PWD}:/var/workspace/project nexucis/ci-checkfiles /bin/bash -c "cd /var/workspace/project && checkEOL *.md *.java *.xml"
``` 

## Do the same in continuous integration

This image is designed to work in a continuous integration system. So you could use it to check your project in a easy way.

### Circle-CI

The example below shows a simple circle-ci configuration files **.circleci/config.yml** who shows how to use the two tools describe in a previous section

```yaml
version: 2
jobs:
  analyze_eol:
    docker:
      - image: nexucis/ci-checkfiles:dev-master
    working_directory: ~/repo
    steps:
      - checkout
      - run: checkEOL *.cmd *.php *.md *.xml
      
  analyze_encoding_utf8:
    docker:
      - image: nexucis/ci-checkfiles:dev-master
    working_directory: ~/repo
    steps:
      - checkout
      - run: checkEncoding utf-8 *.cmd *.php *.md *.xml
      
workflows:
  version: 2
  build_and_analyze:
    jobs:
      - analyze_eol
      - analyze_encoding_utf8
```
If you want to learn more about circle-ci please read [the official documentation](https://circleci.com/docs/2.0/)

### Gitlab-ci
Same example but with Gitlab-ci .

```yaml
stages:
  - analyze

analyze_eol:
  stage: analyze
  image: nexucis/ci-checkfiles:dev-master
  script:
    - checkEOL *.md *.java *.xml *.json *.ts *.js

analyze_encoding_utf8:
  stage: analyze
  image: nexucis/ci-checkfiles:dev-master
  script:
    - checkEncoding utf-8 *.md *.java *.xml *.json *.ts *.js
```

### Travis-CI

If you want to use it with tracis, you can do something like this :

```yaml
sudo: required

language: java

services:
  - docker

script:
  - docker run --rm -v ${PWD}:/var/workspace/project nexucis/ci-checkfiles /bin/bash -c "cd /var/workspace/project && checkEOL *.md *.java *.xml"
  - docker run --rm -v ${PWD}:/var/workspace/project nexucis/ci-checkfiles /bin/bash -c "cd /var/workspace/project && checkEncoding utf-8 *.md *.java *.xml"
```

*The example below is based on the [official documentation](https://docs.travis-ci.com/user/docker/) when we want to use docker with travis-ci*

## Run the script without docker
Docker bothering you ? You think that is overkill to use docker to run just two tiny script ? Here is the way to use it without docker.

### checkEncoding

#### Must have

* a bash in version 4 to run this script

```bash
bash --version
```

* uchardet installed
  
```bash
sudo apt-get update && apt-get install uchardet libuchardet-dev
```

> uchardet can be installed on Fedora, Gentoo and mac. Please see [the official documentation](https://www.freedesktop.org/wiki/Software/uchardet/) to learn about it

#### Installation

* Install the script in a `bin` directory : 

```bash
curl -s -XGET https://raw.githubusercontent.com/Nexucis/ci-checkFiles/master/encoding/encoding_if.sh > /usr/bin/encoding_if
curl -s -XGET https://raw.githubusercontent.com/Nexucis/ci-checkFiles/master/encoding/checkEncoding.sh > /usr/bin/checkEncoding
chmod +x /usr/bin/checkEncoding /usr/bin/encoding_if
```

* Use it and enjoy : 

```bash
cd /var/workspace/project && checkEncoding ascii *.java
```

### CheckEOL

#### Must have

* dos2unix with a version >= 7.1

> Tips : 
>>dos2unix with this version is available on ubuntu 17.10

>> gitbash (at least last version, maybe older too) has dos2unix in 7.4.0

#### Installation

* Install the script in a `bin` directory : 

```bash
curl -s -XGET https://raw.githubusercontent.com/Nexucis/ci-checkFiles/master/eol/eol_if.sh > /usr/bin/eol_if
curl -s -XGET https://raw.githubusercontent.com/Nexucis/ci-checkFiles/master/eol/checkEOL.sh > /usr/bin/checkEOL
chmod +x /usr/bin/eol_if /usr/bin/checkEOL
```

* Use it and enjoy : 

```bash
cd /var/workspace/project && checkEOL *.java
```

## Contributions
If you want to improve this image, feel free to use the Issue section or to send a pull request. Both of them will be appreciated.

## License
[MIT](./LICENSE)
