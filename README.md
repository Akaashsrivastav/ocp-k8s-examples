# Openshift/Kubernetes examples

## Basic objects to deploy application using

NOte: Openshift environment is used for these examples
      Use either oc / kubectl     

### Pod -
     A Pod is smallest unit of kubernetes deployment and also group of one or more containers, with shared storage and network resources, and a specification for how to run the containers.

### Deployment -
     Using Deployment object we describe how to create or modify pods that hold a containerized application by defining the desired state of a particular component.
     I create a deployment.yaml file for simple python-hello-world app using-
     * oc apply -f deployment.yaml

### Service -
    Now i create a Services to assigned an IP address and port for our python-hello-world app using-
    * oc apply -f service.yaml

### Secret -
    Using this object we can provides a mechanism to hold sensitive information such as passwords,dockercfg files, private source repository credentials etc.In my case i just secret endpoint name in incripted form and then apply using -
    * oc apply -f secret.yaml
### Ingress -
    This object defines the rules for how to route incoming requests for our apps.In my case i allow 5000 port for incoming port and then apply using -
    * oc apply -f ingress.yaml

### Statefulset -
    A StatefulSet manages Pods that are based on an identical container spec and are commonly used for stateful applications like databases, where each pod requires stable, unique network identifiers, persistent storage, and ordered deployment and scaling.

### Replicaset -
    A ReplicaSet's purpose is to maintain a stable set of replica Pods running at any given time.I also created 2 replicas of our python app using -
    * oc apply -f k8s-manifests/python-hello-world/replicaset.yaml
       - For checking replicaset deployed i used -
       * oc get rs
       - I also check the state of the ReplicaSet using -
       * oc describe rs/py-demo-replica

### ReplicationController -
    A ReplicationController ensures that a specified number of pod replicas are running at any one time. In my case i create one ReplicationController object for our python-demo project and apply using -
    * oc apply -f k8s-manifests/python-hello-world/replicationC.yaml
      - oc describe replicationcontrollers/py-demo-replica  (Check for status of replicationcontroller)


## Understanding  RBAC permissions
### Service Account -
    Service accounts are different from user accounts, which are authenticated human users in the cluster. By default, user accounts don't exist in the Kubernetes API server; instead, the API server treats user identities as blurred data. 
    I created a simple service account for my understanding and apply using-
    * oc apply -f k8s-manifests/nginx-sa.yaml 
    * oc get serviceaccounts or oc gat sa    (For seeing the service account)

    Now using built-in Kubernetes ClusterRole called “view” that allows viewing all resources. I create a RoleBinding for my Service Account using -
    * oc create rolebinding nginx-sa-readonly \
          --clusterrole=view \
          --serviceaccount=default:nginx-serviceaccount \
          --namespace=learning-space

    Now for our py-demo app I assign this service account and then deploy the application.


## Understanding secure routes with SSL, TLS in HTTPS
### SSL(Secure Sockets Layer)
    Secure Sockets Layer certificates, sometimes called digital certificates, are used to establish an encrypted connection between a browser or user’s computer and a server or website. It prevents hackers from seeing or stealing any information transferred, including personal or financial data.

### TLS(Transport Layer Security)
    TLS is an updated, more secure version of SSL. 

### HTTPS (Hyper Text Protocol Secure)
    HTTPS appears in the URL when a website is secured by an SSL/TLS certificate.Users can view the details of the certificate, including the issuing authority and the corporate name of the website owner, by clicking the lock symbol on the browser bar.


##  HorizontalPodAutoScalers
    HorizontalPodAutoscaler controls the scale of a Deployment and its ReplicaSet.
    In my case i created a Horizontalpodautoscaler for our py-demo app with both scaleup and scaledown behavior and applying -
    * oc apply -f k8s-manifests/python-hello-world/hpa.yaml 
    For Checking HPA is set up correctly and is monitoring your deployment -
    * oc get hpa  ----- The result is -
    [asrivastav@akashs ocp-k8s-examples]$ oc get hpa
    NAME      REFERENCE            TARGETS         MINPODS   MAXPODS   REPLICAS   AGE
    py-demo   Deployment/py-demo   <unknown>/50%   1         5         2          6m24s


##  Tekton basics
### Task/TaskRun 
#### Steps
      A step is an operation in a CI/CD workflow, such as running some unit tests for a Python web app, or the compilation of a Java program.
#### Tasks 
    A task is a collection of steps in order. Tekton runs a task in the form of a Kubernetes pod, where each step becomes a running container in the pod.
#### TaskRun
    taskRun is a specific execution of a task. TaskRuns are also available when you choose to run a task outside a pipeline, with which you may view the specifics of each step execution in a task.
#### Pipeline
     A pipeline is a collection of tasks in order. Tekton collects all the tasks, connects them in a directed acyclic graph (DAG), and executes the graph in sequence. In other words, it creates a number of Kubernetes pods and ensures that each pod completes running successfully as desired. 
#### pipelineRun
     As its name implies, is a specific execution of a pipeline.

     * I create a simple tekton task and apply-
       - oc apply -f k8s-manifests/tekton-manifests/hello-world.yaml
     * Now I create a taskRun to run the hello-world task -
       - oc apply -f k8s-manifests/tekton-manifests/hello-world-run.yaml 
     * Now for Verify that everything worked correctly:-
       - oc get taskrun hello-task-run
     * To see the log -
       - oc logs --selector=tekton.dev/taskRun=hello-task-run

     * I create a pipeline using hello-world task and creating a new task like- goodbye task then apply this pipeline -
      - oc apply -f k8s-manifests/tekton-manifests/hello-goodbye-pipeline.yaml
     * Now i run the pipeline using -
      - oc apply -f k8s-manifests/tekton-manifests/hello-goodbye-pipeline-run.yaml 
     * To see the logs of pipeline -
      - tkn pipelinerun logs hello-goodbye-run -f -n learning-space
     * To see all run pipeline -
      - oc get pipelinerun -A

### Tekton Triggers
     Tekton Triggers is a Tekton component that allows you to detect and extract information from events from a variety of sources and autocratically instantiate and execute TaskRuns and PipelineRuns based on that information.

    * EventListener - listens for events at a specified port on your Kubernetes cluster.
    * Trigger - specifies what happens when the EventListener detects an event.
    * TriggerTemplate - specifies a blueprint for the resource, such as a TaskRun or PipelineRun when your EventListener detects an event.

### ArgoCD
    Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.which continuously monitors running applications and compares the current, live state against the desired target state (as specified in the Git repo). 
#### ArgoProject
    Projects provide a logical grouping of applications, which is useful when Argo CD is used by multiple teams. Projects provide the following features:-
    restrict what may be deployed (trusted Git source repositories)
    restrict where apps may be deployed to (destination clusters and namespaces)
    restrict what kinds of objects may or may not be deployed (e.g. RBAC, CRDs, DaemonSets, NetworkPolicy etc...)
    defining project roles to provide application RBAC (bound to OIDC groups and/or JWT tokens)

    * argocd proj create myproject -d https://kubernetes.default.svc,mynamespace -s https://github.com/       argoproj/argocd-example-apps.git ----- For creating project

    * argocd app set guestbook-default --project myproject ----- For assigning app to a project

#### ArgoCD Sync Policy
    This policy defines how and when ArgoCD should apply changes from the repository to the Kubernetes cluster. Essentially, it’s a set of rules and behaviors that control the update process of your applications, ensuring that your live applications reflect the desired state defined in your Git repository.

####  Roles and permission management
    The RBAC feature enables restriction of access to Argo CD resources. Argo CD does not have its own user management system and has only one built-in user admin. The admin user is a superuser and it has unrestricted access to the system. 

    Argo CD has two pre-defined roles but RBAC configuration allows defining roles and groups (see below).
    role:readonly - read-only access to all resources
    role:admin - unrestricted access to all resources


### Docker args, environment variable
    ARG is only available during the build of a Docker image (RUN etc), not after the image is created and containers are started from it (ENTRYPOINT, CMD). You can use ARG values to set ENV values to work around that.
    ENV values are available to containers, but also to the commands of your Dockerfile which run during an image build, starting with the line where they are introduced.

  
### Helm
    - Helm is a tool that automates the creation, packaging, configuration, and deployment of Kubernetes applications by combining your       configuration files into a single reusable package.
    - Helm is a handy tool that maintains a single deployment YAML file with version information. This file lets you set up and manage a complex Kubernetes cluster with a few commands.
    
#### Helm charts
    A Helm chart is a package that contains all the necessary resources to deploy an application to a Kubernetes cluster. This includes YAML configuration files for deployments, services, secrets, and config maps that define the desired state of your application.

    - Configs
          The config contains application configurations that you usually store in a YAML file. Resources in the Kubernetes cluster are deployed based on these values.
    -Releases
          A running instance of a chart is known as a release. When you run the helm install command, it pulls the config and chart files and deploys all the Kubernetes resources.

#### Helm Commands
    * helm repo  -- To interact with chart repository 
    * helm repo list  -- To see all the repos
    * helm repo add <name> <url>  -- For add repo
    * helm repo remove <Name>   -- For removing repo
    * helm search  -- For finding chart (For example- helm search repo <chart>)
    * helm show  -- Information about chart (For example- helm show <value|chart|readme|all|> <chartName>)
    * helm install -- For install package (For example- helm install <ReleaseName> <chartName>)
        -- Wait until all subjects are ready (For example- helm install mychart stable tomcat --wait --timeout 10s)
    * helm create -- For creating a new chart with given name (For example- helm create helloworld)
    * helm delete -- For deleting a new chart with given name (For example- helm create helloworld)









