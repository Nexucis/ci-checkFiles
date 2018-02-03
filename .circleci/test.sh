#!/bin/bash

l_docker_image_base_name="nexucis/ci-checkfiles"
l_docker_holding_volume="container-holding-volume"

createSharedVolume(){
    docker create -v /var/workspace/project --name ${l_docker_holding_volume} alpine:3.4 /bin/true
    if [ $? != 0 ]; then
       echo "something wrong with the docker create cmd"
       exit 1
    fi
    docker cp ./ ${l_docker_holding_volume}:/var/workspace/project
    if [ $? != 0 ]; then
        echo "something wrong with the docker's command"
        exit 1
    fi
}

removeSharedVolume(){
    docker rm ${l_docker_holding_volume}
    if [ $? != 0 ]; then
        echo "something wrong with the docker's command"
        exit 1
    fi
}

testCheckEOLFailedExpected(){
    docker_tag=$1
    if [ -z "${docker_tag}" ]; then
       echo "No tag pass in parameter, I can't perform the test"
       exit 1
    fi
    createSharedVolume
    result=0
    docker run --volumes-from ${l_docker_holding_volume} ${l_docker_image_base_name}:${docker_tag} /bin/bash -c "cd /var/workspace/project && checkEOL *.test"
    if [ $? != 0 ]; then
        echo "Good the check failed"
    else
        echo "this test must fail"
        result=1
    fi

    echo "removing shared volume and shared container"
    removeSharedVolume
    exit ${result}
}

testCheckEOLSuccessExpected(){
    docker_tag=$1
    if [ -z "${docker_tag}" ]; then
       echo "No tag pass in parameter, I can't perform the test"
       exit 1
    fi
    createSharedVolume
    result=0
    echo "Starting test ..."
    docker run --volumes-from ${l_docker_holding_volume} ${l_docker_image_base_name}:${docker_tag} /bin/bash -c "cd /var/workspace/project && checkEOL *.md *.sh Dockerfile"
    if [ $? == 0 ]; then
        echo "Good the check is success"
    else
        echo "this test must not fail"
        result=1
    fi

    echo "removing shared volume and shared container"
    removeSharedVolume
    exit ${result}
}


testCheckEncodingFailedExpected(){
    docker_tag=$1
    if [ -z "${docker_tag}" ]; then
       echo "No tag pass in parameter, I can't perform the test"
       exit 1
    fi
    createSharedVolume
    result=0
    docker run --volumes-from ${l_docker_holding_volume} ${l_docker_image_base_name}:${docker_tag} /bin/bash -c "cd /var/workspace/project && ls file-test/ && checkEncoding utf-8 *.test"
    if [ $? != 0 ]; then
        echo "Good the check failed"
    else
        echo "this test must fail"
        result=1
    fi

    echo "removing shared volume and shared container"
    removeSharedVolume
    exit ${result}
}

testCheckEncodingSuccessExpected(){
    docker_tag=$1
    if [ -z "${docker_tag}" ]; then
       echo "No tag pass in parameter, I can't perform the test"
       exit 1
    fi
    createSharedVolume
    result=0
    docker run --volumes-from ${l_docker_holding_volume} ${l_docker_image_base_name}:${docker_tag} /bin/bash -c "cd /var/workspace/project && checkEncoding utf-8 *.md *.sh Dockerfile"
    if [ $? == 0 ]; then
        echo "Good the check is success"
    else
        echo "this test must not fail"
        result=1
    fi

    echo "removing shared volume and shared container"
    removeSharedVolume
    exit ${result}
}

case $1 in
    --test-eol-failed)
    testCheckEOLFailedExpected $2
    ;;
    --test-eol-success)
    testCheckEOLSuccessExpected $2
    ;;
    --test-encoding-failed)
    testCheckEncodingFailedExpected $2
    ;;
    --test-encoding-success)
    testCheckEncodingSuccessExpected $2
    ;;
    *)
    ;;
esac