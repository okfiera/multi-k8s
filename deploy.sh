# Build images and set tags (latest tag, and unique $SHA tag)
docker build -t sincronize/multi-client:latest -t sincronize/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t sincronize/multi-server:latest -t sincronize/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t sincronize/multi-worker:latest -t sincronize/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# Upload images with latest tag
docker push sincronize/multi-client:latest
docker push sincronize/multi-server:latest
docker push sincronize/multi-worker:latest

# Upload images with $SHA tag
docker push sincronize/multi-client:$SHA
docker push sincronize/multi-server:$SHA
docker push sincronize/multi-worker:$SHA

# Apply configuration files in Kubernetes
kubectl apply -f k8s

# Update deployment images unique tag (with $SHA label)
kubectl set image deployments/client-deployment client=sincronize/multi-client:$SHA
kubectl set image deployments/server-deployment server=sincronize/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=sincronize/multi-worker:$SHA