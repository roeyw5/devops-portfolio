apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: infra-apps
  namespace: ${namespace}
spec:
  project: default
  source:
    repoURL: "${repo_url}"
    targetRevision: HEAD
    path: ${infra_path}
  destination:
    server: "https://kubernetes.default.svc"
    namespace: ${infra_namespace}
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
      - ServerSideApply=true