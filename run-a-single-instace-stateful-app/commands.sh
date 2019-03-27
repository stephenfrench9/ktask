# Deploy MySQL
kubectl create -f mysql-pv.yaml # I got a 20Gib volume and a claim. Where is that 20GB? Local? cloud?
kubectl create -f mysql-deployment.yaml
kubectl describe deployment mysql
kubectl get pods -l app=mysql
kubectl describe pvc mysql-pv-claim
# Accessing the MySQl instance
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -h mysql -ppassword
# This appears to be a pod that you ssh into, and then get a mysql command line prompt at.
# I can't figure out what commands to type in to operate the database. It is pretty unresponsive to my commands
# Deleting the deployment
kubectl delete deployment,svc mysql
kubectl delete pvc mysql-pv-claim
kubectl delete pv mysql-pv-volume

#The mysql container successfully launches. The client also launches and gives my a working terminal to interact with the database.
#I could add daata, then shutdown the client, then addd more data.
