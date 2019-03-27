kubectl run nginx --image=nginx --replicas=2
kubectl expose deployment nginx --port=80
kubectl get svc,pod
kubectl run busybox --rm -ti --image=busybox /bin/sh
# Use kubectl to create a NetworkPolicy from the above nginx-policy.yaml file:
kubectl apply -f nginx-policy.yaml
kubectl run busybox --rm -ti --image=busybox /bin/sh
kubectl run busybox --rm -ti --labels="access=true" --image=busybox /bin/sh
