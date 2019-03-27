export pod=$(kubectl get pods --output=jsonpath={.items[0]..metadata.name})
export deployment=$(kubectl get deployment --output=jsonpath={.items[0]..metadata.name})
export service=$(kubectl get services --output=jsonpath={.items[1]..metadata.name})

for p in 0 1 2; do kubectl get po web-$p --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'; echo; done
# get pod, get deployment
# can I search the jsonpath output of deployments like I can pods? 

kubectl get deployment history
# the revisions to my deployment

kubectl get pod $pods --o yaml
kubectl get deployment $deployment --o yaml
# examine pods and deployments.
# What marks are on the pods? On the deployments? (app: nginx) Does someone own this mark?
# What revision is this deployment?
# Can I output jsonpath to describe a single pod? Can I search the jsonpath?

kubectl get pod $pods --o yaml | grep containers | awk 'FN==1 {print $1}'
# Containers in the pod?

kubectl get deployment $deployment -o yaml | grep labels -C 4
# What marks are associated with this deployment

