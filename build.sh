#!/bin/bash

l_docker_image_base_name="nexucis/ci-checkfiles"
l_initial_path=${PWD}
l_default_tag="dev-master"
l_default_alpine_tag="alpine-dev-master"

copyBashScript(){
    docker_distrib=$1
    if [ -z "${docker_distrib}" ]; then
       echo "No distrib pass in parameter, I can't copy the script to the right folder"
       exit 1
    fi

    cp -r encoding docker/${docker_distrib}/
    cp -r eol docker/${docker_distrib}/
}

build(){
    docker_distrib=$1
    docker_tag=$2
    if [ -z "${docker_distrib}" ]; then
       echo "No distrib pass in parameter, I can't build the targeting images"
       exit 1
    fi

    if [ -z "${docker_tag}" ]; then
       echo "No tag pass in parameter, I can't build the targeting images"
       exit 1
    fi

    copyBashScript ${docker_distrib}

    cd docker/${docker_distrib}/
    docker build -t ${l_docker_image_base_name}:${docker_tag} ./
    if [ $? != 0 ]; then
        echo "something wrong with the docker's command"
        exit 1
    fi

    cd ${l_initial_path}
}

buildUbuntu(){
    build "ubuntu" ${l_default_tag}
    exit $?
}

buildAlpine(){
    build "alpine" ${l_default_alpine_tag}
    exit $?
}

# Pull the given tag
getDockerImage(){
    l_initial_tag=$1
    if [ -z "${l_initial_tag}" ]; then
       echo "if you want to get an image, you need to provide the corresponding tag"
       exit 1
    fi

    docker pull ${l_docker_image_base_name}:${l_initial_tag}
    exit $?
}

# Tag the image from an existing tag
tag(){
    l_initial_tag=$1
    l_target_tag=$2

    # check that the image exists, pull if not
    if [[ "$(docker images -q ${l_docker_image_base_name}:${l_initial_tag} 2> /dev/null)" == "" ]]; then
        echo "image ${l_docker_image_base_name}:${l_initial_tag} does not exist, I need to pull it"
        getDockerImage l_initial_tag
    fi

    docker tag ${l_docker_image_base_name}:${l_initial_tag}  ${l_docker_image_base_name}:${l_target_tag}
    exit $?
}

# Push the given tag
push(){
    l_initial_tag=$1

    if [ -z "${l_initial_tag}" ]; then
        l_initial_tag=${l_default_tag}
    fi

    docker push ${l_docker_image_base_name}:${l_initial_tag}
    exit $?
}

# Connect to docker hub
connect(){
    docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}
    exit $?
}

function help {
    echo "-p or --push to push a docker image to the registry
--build-ubuntu to build a docker image from the ubuntu distribution
--build-alpine to build a docker image from the alpine distribution
-c or --connect to connect to the registry
-t or --tag to tag a docker image from another docker image"
}

case $1 in
    -c|--connect)
    connect
    shift
    ;;
    -p|--push)
    push $2
    shift
    ;;
    --build-ubuntu)
    buildUbuntu
    shift
    ;;
    --build-alpine)
    buildAlpine
    shift
    ;;
    -t|--tag)
    tag $2 $3
    shift
    ;;
    *)
    help
    ;;
esac