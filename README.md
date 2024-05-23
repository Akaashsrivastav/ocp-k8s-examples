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
















### Commands for my learning
echo <akash> | base64 -- for incripted anything(like-name,link etc)
echo <YWthc2gK> | base64 -d  -- for decripted anything
sudo vi /etc/hosts -- for adding hosts
oc apply -k k8s-manifests/base/ --dry-run=client -o yaml -- for check customize file working properly 
oc apply -k k8s-manifests/base/ --dry-run=client -o yaml -n observability-zaga -- for check customize file working properly using namespace(-n)
oc project -- to seeing in which project/namespace,we are working
oc project <namespace/projectname> -- to switching one project to another project