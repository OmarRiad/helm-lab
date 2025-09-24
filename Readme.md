# Helm Lab

## Goal: Practice creating and using a named template ( _helpers.tpl ) for reusable YAML blocks (Kubernetes resource settings).

### Define Template: Edit templates/_helpers.tpl 
- Define a named template (e.g., `"myapp.containerResources"`)
- Inside the define , generate the standard Kubernetes `resources:` block(limits & requests).
    ```bash
    {{- define "myapp.containerResources" -}}
    resources:
    requests:
        cpu: {{ .Values.resources.requests.cpu }}
        memory: {{ .Values.resources.requests.memory }}
    limits:
        cpu: {{ .Values.resources.limits.cpu }}
        memory: {{ .Values.resources.limits.memory }}
    {{- end -}}
    ```
- Use `{{ .Values.resources... }}` to access the values defined in
`values.yaml`
### Include Template:

```bash
{{- include "myapp.containerResources" . | nindent 8 }}
```

### Test (Default): Run `helm template .`
```bash
omar@omar-Inspiron-5482:~/Desktop/ITI/Helm/mychart$ helm template .
---
# Source: mychart/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
name: nginx
labels:
    app: nginx
    app.kubernetes.io/name: myapp
    app.kubernetes.io/instance: release-name
spec:
replicas: 1
selector:
    matchLabels:
    app: nginx
    app.kubernetes.io/name: myapp
    app.kubernetes.io/instance: release-name
template:
    metadata:
    labels:
        app: nginx
        app.kubernetes.io/name: myapp
        app.kubernetes.io/instance: release-name
    spec:
    containers:
    - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
        resources:
        requests:
            cpu: 100m
            memory: 128Mi
        limits:
            cpu: 200m
            memory: 256Mi
```
### Test (Override): 
- Create an override file `override-resources.yaml`:
    ```bash
  resources:
    limits:
      memory: 256Mi # Override only memory limit
    requests: # Let's override CPU request too
      cpu: 75m
    ```
- Run `helm template . -f override-resources.yaml`
    ```bash
    omar@omar-Inspiron-5482:~/Desktop/ITI/Helm/mychart$ helm template . -f override-resources.yaml 
    ---
    # Source: mychart/templates/deployment.yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: nginx
    labels:
        app: nginx
        app.kubernetes.io/name: myapp
        app.kubernetes.io/instance: release-name
    spec:
    replicas: 1
    selector:
        matchLabels:
        app: nginx
        app.kubernetes.io/name: myapp
        app.kubernetes.io/instance: release-name
    template:
        metadata:
        labels:
            app: nginx
            app.kubernetes.io/name: myapp
            app.kubernetes.io/instance: release-name
        spec:
        containers:
        - name: nginx
            image: nginx:latest
            ports:
            - containerPort: 80
            resources:
            requests:
                cpu: 75m
                memory: 128Mi
            limits:
                cpu: 200m
                memory: 256Mi
    ```