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
      














echo <akash> | base64 -- for incripted anything(like-name,link etc)
echo <YWthc2gK> | base64 -d  -- for decripted anything
sudo vi /etc/hosts -- for adding hosts
oc apply -k k8s-manifests/base/ --dry-run=client -o yaml -- for check customize file working properly 
oc apply -k k8s-manifests/base/ --dry-run=client -o yaml -n observability-zaga -- for check customize file working properly using namespace(-n)
oc project -- to seeing in which project/namespace,we are working
oc project <namespace/projectname> -- to switching one project to another project