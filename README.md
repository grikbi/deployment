# Dependency Analytics Platform

This repository handles the entire deployment of dependency analytics platform.
This platform can be divided into three main categories

1. **Online Workflow**

    Online workflow consists of three main features where a developer can interact with the backend API's

    - **Component Analyses**

      This API flags any package/library/dependency having security issue. For the request payload and response, you can use [this swagger spec](http://127.0.0.1:32000/api/v1/component-analyses)

    - **Stack Analyses**

      This API generates a report based on developers' manifest file. Current supported manifest files are `pom.xml (java - maven)`, `requirements.txt(python)` and `package.json(node)`

2. **Offline Workflow**

    Offline workflow of any analytics platform where it helps gather the data, normalise and pre-process the data in required format. We use Python Celery framework to gather the data from different 3rd party API's

3. **Model Retraining Workflow**

    Retraining workflow helps to build different models and put them into use. It also helps make current models more accurate over time when trained with more data.

Current scope of this project is online workflow for phase 1. We will slowly add other workflows to this project.

## **Install Prerequisites**

This platform requires certain pre-requisites as part of the deployment process. It requires

- [Docker](https://docs.docker.com/install)
- [Minikube](https://kubernetes.io/docs/tasks/tools/install-minikube) (local k8s cluster)
- [Skaffold](https://skaffold.dev/docs/getting-started/#installing-skaffold) (automatic deploy of developer changes on minikube)

Once all the pre-requisites are installed, you can run `deploy.sh` and it will build and deploy all the necessary services locally.

## **Deploy Dependency Analytics Platform**

There are two ways where dependency analytics platform can be installed.

1. Deploy Platform Locally

    User can deploy this platform locally by invoking `deploy.sh` script from the root directory

2. Develop Continuous

    A developer can develop or make changes to the codebase in a continuous way without creating and deploying the new images manually. They can invoke `develop.sh` script from the root directory

### **List of Services**

Developer can always check the list of services running locally to the cluster using `minikube service list`

- Core API Server

  Main front-ending service that exposes `component-analyses` and `stack-analyses` endpoints. You can access swagger spec of this service at `http://127.0.0.1:32000/docs`

- Core API Async Worker

  Main online backend service that collects stack related information from graph database and generate companion recommendations for a given stack. You can access swagger spec of this service at `http:127.0.0.1:9000/docs`

- License Insights Service

  This service gives license level insights around any license conflicts or presence of restrictive licenses and also provide a cumulative license for the given stack. You can access swagger spec of this service at `http:127.0.0.1:6162/docs`

- Node Insights Service

  This service provides companion recommendations for node ecosystem in terms of what other dependencies can be used along with the user stack to complement current development. You can access swagger spec of this service at `http:127.0.0.1:6005/docs`

- Python Insights Service

  This service provides companion recommendations for python ecosystem in terms of what other dependencies can be used along with the user stack to complement current development. You can access swagger spec of this service at `http:127.0.0.1:6006/docs`

- Gremlin HTTP Service

  This service provides access to graph database which is the main front-ending database. Graph database comes with some sample data for both node and python ecosystems.

- DynamoDB Local Service

  This service is a local alternative for AWS DynamoDB NoSQL Database.

- Minio Local Service

  This service is a local alternative for AWS S3 Object Storage.

