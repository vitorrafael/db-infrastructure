# Creating "lanchonete-database" in PostgreSQL RDS from EKS

1. Deploy a PostgreSQL client Pod in your EKS cluster by creating a manifest (`psql-pod.yaml`) with the following content and applying it via `kubectl apply -f psql-pod.yaml`:

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: psql-client
     labels:
       app: psql-client
   spec:
     containers:
       - name: psql-client
         image: postgres:14
         stdin: true
         tty: true
         env:
           - name: PGPASSWORD
             value: "<your-rds-password>" # Replace with your RDS password
     restartPolicy: Never


Access the Pod using `kubectl exec -it psql-client -- /bin/bash`.

Inside the Pod, connect to your RDS instance with the command:

```bash
psql -h <rds-endpoint> -U <rds-username> -d postgres
Replace <rds-endpoint> with your RDS endpoint and <rds-username> with your RDS username.
```

Once connected, create the lanchonete-database using:

``` sql
CREATE DATABASE "lanchonete-database";
```