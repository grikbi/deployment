#!/bin/bash

set -x 
# set up terminal colors
NORMAL=$(tput sgr0)
RED=$(tput bold && tput setaf 1)
GREEN=$(tput bold && tput setaf 2)
YELLOW=$(tput bold && tput setaf 3)

DEPLOY_PATH=$PWD

# variables
NAMESPACE=farrion
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

gc() {
  retval=$?
  exit $retval
}

trap gc EXIT SIGINT

start_minikube() {
    # Check whether minikube is already running
    minikube status
    if [ $? -ne 0 ]
    then
        # Start the minikube if not running
        minikube start --memory="4096mb" --disk-size="40gb"
    fi
}

check_prerequisites() {
    # Check whether minikube exists
    which minikube
    if [ $? -ne 0 ]
    then
        printf "%s*** ERROR ***\n" "${RED}"
        printf "minikube does not exist or not available in the path.\n"
        printf "please install minikube or add the corresponding path.\n%s" "${NORMAL}"
        exit 1
    fi
    which docker
    if [ $? -ne 0 ]
    then
        printf "%s*** ERROR ***\n" "${RED}"
        printf "docker does not exist or not available in the path.\n"
        printf "please install docker or add the corresponding path.\n%s" "${NORMAL}"
        exit 1
    fi
    which kompose
    if [ $? -ne 0 ]
    then
        printf "%s*** ERROR ***\n" "${RED}"
        printf "kompose does not exist or not available in the path.\n"
        printf "please install kompose or add the corresponding path.\n%s" "${NORMAL}"
        exit 1
    fi
    
    # Start the minikube if all pre-reqs are successfull
    start_minikube

    # Set the docker environment variable for minikube
    # This is needed to work with local built images
    eval $(minikube docker-env)
}

namespace_context() {
    # Check whether codeready-analytics namespace exists or not
    kubectl get namespace | grep ${NAMESPACE}
    if [ $? -ne 0 ]
    then
        # Create the namespace
        kubectl create namespace ${NAMESPACE}
        if [ $? -ne 0 ]
        then
            printf "%s*** ERROR ***\n" "${RED}"
            printf "namespace creation failed.\n%s" "${NORMAL}"
            exit 1
        fi
    fi
    # Use the recently namespace as a current context
    kubectl config set-context --current --namespace=${NAMESPACE}
    if [ $? -ne 0 ]
    then
        printf "%s*** ERROR ***\n" "${RED}"
        printf "namespace context change failed.\n%s" "${NORMAL}"
        exit 1
    fi
}

build_images_locally() {
    pushd ${SCRIPT_DIR}/..
    # Build license insights with a specific tag. 
    # This tag should be same as in docker-compose.yaml file. Else minikube deployments will not succeed.
    TAG="local/license-insights:local"
    docker build -t ${TAG} license-insights/
    popd
}

create_minikube_templates() {
    # Create the kube template files from docker-compose
    pushd ${SCRIPT_DIR}/..
    kompose convert -o templates
    popd
}

minikube_deploy() {
    pushd ${SCRIPT_DIR}/..
    # Deploy using kubectl
    # Sequence is important
    # 0. Deploy Local S3
    printf "%sDeploy s3-local \n%s" "${YELLOW}" "${NORMAL}"
    kubectl create -f $DEPLOY_PATH/templates/s3-local-service.yaml -f $DEPLOY_PATH/templates/s3-local-deployment.yaml
    printf "%sWait for s3-local to be up \n%s" "${YELLOW}" "${NORMAL}"
    kubectl rollout status deployment/s3-local
    # 0. Deploy Postgresql
    printf "%sDeploy postgresql \n%s" "${YELLOW}" "${NORMAL}"
    kubectl create -f $DEPLOY_PATH/templates/postgres-service.yaml -f $DEPLOY_PATH/templates/postgres-deployment.yaml
    printf "%sWait for postgres to be up \n%s" "${YELLOW}" "${NORMAL}"
    kubectl rollout status deployment/postgres
    # 1. Deploy DynamoDB
    printf "%sDeploy dynamodb \n%s" "${YELLOW}" "${NORMAL}"
    kubectl create -f $DEPLOY_PATH/templates/dynamodb-service.yaml -f $DEPLOY_PATH/templates/dynamodb-deployment.yaml
    printf "%sWait for dynamodb to be up \n%s" "${YELLOW}" "${NORMAL}"
    kubectl rollout status deployment/dynamodb
    # 2. Deploy Gremlin HTTP
    printf "%sDeploy Gremlin Http\n%s" "${YELLOW}" "${NORMAL}"
    kubectl create -f $DEPLOY_PATH/templates/gremlin-http-service.yaml -f $DEPLOY_PATH/templates/gremlin-http-deployment.yaml
    printf "%sWait for gremlin-http to be up \n%s" "${YELLOW}" "${NORMAL}"
    kubectl rollout status deployment/gremlin-http
    # 3. Deploy License Insights
    printf "%sDeploy License Insights\n%s" "${YELLOW}" "${NORMAL}"
    kubectl create -f $DEPLOY_PATH/templates/license-insights-service.yaml -f $DEPLOY_PATH/templates/license-insights-deployment.yaml
    # 4. Patch license-insights to pull image locally
    # kubectl patch -f templates/license-insights-deployment.yaml --patch "$(cat templates/patch.imagepull.never)"
    printf "%sWait for license-insights to be up \n%s" "${YELLOW}" "${NORMAL}"
    kubectl rollout status deployment/license-insights
    # 5. Deploy Pypi insights service
    printf "%sDeploy Pypi insights service\n%s" "${YELLOW}" "${NORMAL}"
    kubectl create -f $DEPLOY_PATH/templates/pypi-insights-service.yaml -f $DEPLOY_PATH/templates/pypi-insights-deployment.yaml
    printf "%sWait for pypi-insights to be up \n%s" "${YELLOW}" "${NORMAL}"
    kubectl rollout status deployment/pypi-insights
    # 6. Deploy Coreapi Async worker
    printf "%sDeploy Coreapi Async worker\n%s" "${YELLOW}" "${NORMAL}"
    kubectl create -f $DEPLOY_PATH/templates/coreapi-async-worker-service.yaml -f $DEPLOY_PATH/templates/coreapi-async-worker-deployment.yaml
    
    printf "%sYou can access the services at the below URL%s" "${GREEN}" "${NORMAL}"
    minikube service list --namespace ${NAMESPACE}
    popd
}

check_prerequisites
printf "Opening your minikube dashboard now"
nohup minikube dashboard 1>./minikube.log 2>./minikube.err &
namespace_context
# build_images_locally
# create_minikube_templates
minikube_deploy
