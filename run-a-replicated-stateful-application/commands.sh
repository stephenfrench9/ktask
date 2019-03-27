# Deploy mysql
kubectl create -f mysql-configmap.yaml
kubectl create -f mysql-services.yaml
kubectl create -f mysql-statefulset.yaml
kubectl get pods -l app=mysql --watch
# Sending client traffic
kubectl run mysql-client --image=mysql:5.7 -i --rm --restart=Never --\
	mysql -h mysql-0.mysql # there is some end of file issue here.
# doesnt work, I am missing lots of configuration files somewhere to set up the password
# I am unable to start the client container.
CREATE DATABASE test;
CREATE TABLE test.messages (message VARCHAR(250));
INSERT INTO test.messages VALUES ('hello');

kubectl run mysql-client --image=mysql:5.7 -i -t --rm --restart=Never --\
	mysql -h mysql-read -e "SELECT * FROM test.messages" # I find the same error here. Again, unable to start the mysql client container
kubectl run mysql-client-loop --image=mysql:5.7 -i -t --rm --restart=Never --\
	bash -ic "while sleep 1; do mysql -h mysql-read -e 'SELECT @@server_id,NOW()'; done"
# Simulating Pod and Node downtime
kubectl exec mysql-2 -c mysql -- mv /usr/bin/mysql /usr/bin/mysql.off
kubectl get pod mysql-2
kubectl exec mysql-2 -c mysql -- mv /usr/bin/mysql.off /usr/bin/mysql
kubectl delete pod mysql-2
kubectl get pod mysql-2 -o wide
export node=$(kubectl get pod mysql-2 -o wide | awk 'FNR == 2 {print $7}')
echo $node
kubectl drain $node --force --delete-local-data --ignore-daemonsets #pod/mysql-0 and pod/mysql-2 evicted. node/ip-172-20-61-177... evicted
kubectl get pod mysql-2 -o wide --watch
kubectl uncordon $node
kubectl get pods # We see that the pods are back up and running, much younger. Did they wait until the uncordon command to restart?
# Scaling the number of slaves
kubectl scale statefulset mysql  --replicas=5
kubectl get pods -l app=mysql --watch
kubectl run mysql-client --image=mysql:5.7 -i -t --rm --restart=Never --\ # This mysql client fails, again, I need MYSQL_ROOT_PASSWORD specified
	mysql -h mysql-3.mysql -e "SELECT * FROM test.messages" # The container immediatley exits.
kubectl scale statefulset mysql --replicas=3
kubectl get pvc -l app=mysql
kubectl delete pvc data-mysql-3
kubectl delete pvc data-mysql-4 # as I delete the claims, the accompanying volumes are deleted.
# Cleaning Up
kubectl delete pod mysql-client-loop --now
kubectl delete statefulset mysql
kubectl get pods -l app=mysql
kubectl delete configmap,service,pvc -l app=mysql # The persistent volume claims are deleted when I run this. As is the service and the configmap.
# I guess everything that has a label of app=mysql must be deleted. app=mysql must be deleted.

# My client containers didn't launch because of password problems. The replicated database itself had no problem launching. Scaling the database worked.
# I was able to shut down a node and the database survived, though I didnt try using it. 
