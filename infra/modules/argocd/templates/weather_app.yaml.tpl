apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: weather-app
  namespace: ${namespace}
spec:
  project: default
  source:
    repoURL: "${repo_url}"
    targetRevision: HEAD
    path: ${app_path}
  destination:
    server: "https://kubernetes.default.svc"
    namespace: ${app_namespace}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - ServerSideApply=true