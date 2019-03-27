# Use a strategic merge patch to update a deployment
kubectl create -f deployment-patch.yaml # container name patch-demo-ctr
kubectl get pods # I dont see the container name anywhere
kubectl patch deployment patch-demo --patch "$(cat patch-file-containers.yaml)"
kubectl get deployment patch-demo --output yaml # I see my new container. I see dedicated test team (from original)
kubectl get pods # the pods are running successfullly
kubectl get pods --output=jsonpath={.items..metadata.name}
export pod=$(kubectl get pods --output=jsonpath={.items..metadata.name}) # the flag is output, not jsonpath
# export pod=$(kubectl get pods --selector=app=nginx --output=jsonpath={.items..metadata.name}) # need to run 'source o 4'
echo $pod
kubectl get pods $pod --output yaml # It appears that one is the original pod and one is from the patch. What pods are present? What containers are
# present in those pods? Why do two pods show up when I ask to look at just the one pod? What images are these pods belonging to? What deployment version?
kubectl patch deployment patch-demo --patch "$(cat patch-file-tolerations.yaml)" # do my pods refresh? I see 4 pods total that are brand new. 2 old pods.
# eventually, the 2 old pods disappear and I am left with only the new pods. 
kubectl get deployment patch-demo --output yaml # I see that in spec.template.spec my toleration key:value has changed.
# Use a JSON merge patch to update a deployment
kubectl patch deployment patch-demo --type merge --patch "$(cat patch-file-2.yaml)"
kubectl get deployment patch-demo --output yaml # I see that there is only one type of container in my deployment now. Probably because of the type.
# Pods are shutdown and new pods are started.
export pod=$(kubectl get pods --output=jsonpath={.items..metadata.name})
echo $pod
kubectl get pods
kubectl get pods $pod --output yaml
#I see two pods. They both have the same type of container. The containers share a name with the patch that created them (or the last patch?)
# Both pods have three tolerations, one of which was added by a previous patch.
# Alternate forms of the kubectl patch command
kubectl patch deployment patch-demo --patch "$(cat patch-file.json)"
# Did my pods change? Well, some are terminating, and some are starting. I am starting more new ones than I am shutting down old ones.
# The pod names changed.
# Did the annotation on my pods change? I think it did. The annotation on my pods now say the patch from which they were created.
# Did the generation of my deployment change? yes, went up by one.

# Does the patch have a name? Or does just the new containers have a name?

# There is only ever one deployment. This deployment has its mark. The deployment always has a generation. It tells me how many replicas it insists on.
# The deployment tells me the images that are present. The deployment tells me its toleration.

# The deployment also gives me a little bit of a timeline about itself.

# Desired format:
# Concept and command, check properties of the deployment and containers.
# Release a patch
# Concept and command, check properites of the deployment and containers.

# Tough thing: Does the name belong to the patch or the deployment? To the containers associated with the new patch? To the images associated with the
# new patch?
