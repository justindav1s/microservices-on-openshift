## Flux2 Multi-tenancy setup


https://github.com/fluxcd/flux2-multi-tenancy/tree/main


https://toolkit.fluxcd.io/guides/installation/



#### Deleting resources with stubborn Finalizers

oc  api-resources --verbs=list --namespaced -o name | xargs -n 1 oc get --show-kind --ignore-not-found -n flux-system


oc get kustomization flux-system -n flux-system -o json > kustomization.json
remove finalizers
then
curl -k -H "Content-Type: application/json" -H "Authorization: Bearer $(oc whoami -t)" -X PUT --data-binary @kustomization.json $(oc whoami --show-server)/apis/kustomize.toolkit.fluxcd.io/v1beta1/namespaces/flux-system/kustomizations/flux-system

oc get helmrepository jd-repo -n flux-system -o json > helmrepository.json
curl -k -H "Content-Type: application/json" -H "Authorization: Bearer $(oc whoami -t)" -X PUT --data-binary @helmrepository.json $(oc whoami --show-server)/apis/source.toolkit.fluxcd.io/v1beta1/namespaces/flux-system/helmrepositories/jd-repo

flux bootstrap github \
  --owner=justindav1s \
  --repository=flux2-ops \
  --path=clusters/ocp1 \
  --personal

flux create tenant team1 \
--with-namespace=team1-dev \
--with-namespace=team1-e2e \
--with-namespace=team1-staging \
--with-namespace=team1-production \
--export > team1-rbac.yaml

for environment in dev e2e staging production
do
flux create source git team1 \
    --namespace=team1-$environment \
    --url=https://github.com/justindav1s/team1-apps-$environment \
    --branch=master \
    --export > team1-apps-$environment-sync.yaml
done

for environment in dev e2e staging production
do
flux create kustomization team1 \
    --namespace=team1-$environment \
    --service-account=team1 \
    --source=GitRepository/team1 \
    --path="./" \
    --export >> team1-apps-$environment-sync.yaml
done    

flux create tenant team2 \
--with-namespace=team2-dev \
--with-namespace=team2-e2e \
--with-namespace=team2-staging \
--with-namespace=team2-production \
--export > team2-rbac.yaml

for environment in dev e2e staging production
do
flux create source git team2 \
    --namespace=team2-$environment \
    --url=https://github.com/justindav1s/team2-apps-$environment \
    --branch=master \
    --export > team2-apps-$environment-sync.yaml
done 

for environment in dev e2e staging production
do
flux create kustomization team2 \
    --namespace=team2-$environment \
    --service-account=team2 \
    --source=GitRepository/team2 \
    --path="./" \
    --export >> team2-apps-$environment-sync.yaml
done 
