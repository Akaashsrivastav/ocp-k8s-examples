# Openshift/Kubernetes examples

## Basic objects to deploy application using

NOte: Openshift environment is used for these examples
      Use either oc / kubectl     

### Pod -
     A Pod is smallest unit of kubernetes deployment and also group of one or more containers, with shared storage and network resources, and a specification for how to run the containers.















echo <akash> | base64 -- for incripted anything(like-name,link etc)
echo <YWthc2gK> | base64 -d  -- for decripted anything
sudo vi /etc/hosts -- for adding hosts
oc apply -k k8s-manifests/base/ --dry-run=client -o yaml -- for check customize file working properly 
oc apply -k k8s-manifests/base/ --dry-run=client -o yaml -n observability-zaga -- for check customize file working properly using namespace(-n)
oc project -- to seeing in which project/namespace,we are working
oc project <namespace/projectname> -- to switching one project to another project