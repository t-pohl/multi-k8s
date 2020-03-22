# tag the images with latest + current git SHA (passed as env var)
docker build -t pohltho/multi-client:latest -t pohltho/multi-client:"$SHA" -f ./client/Dockerfile ./client
docker build -t pohltho/multi-server:latest -t pohltho/multi-server:"$SHA" -f ./server/Dockerfile ./server
docker build -t pohltho/multi-worker:latest -t pohltho/multi-worker:"$SHA" -f ./worker/Dockerfile ./worker

# push all the tagged images to docker hub
docker push pohltho/multi-client:latest
docker push pohltho/multi-server:latest
docker push pohltho/multi-worker:latest
docker push pohltho/multi-client:"$SHA"
docker push pohltho/multi-server:"$SHA"
docker push pohltho/multi-worker:"$SHA"

# apply k8s settings for cluster
kubectl apply -f ./k8s

# explicitly set the container images to the newest built images identified by git SHA
kubectl set image deployments/client-deployment client=pohltho/multi-client:"$SHA"
kubectl set image deployments/server-deployment server=pohltho/multi-server:"$SHA"
kubectl set image deployments/worker-deployment worker=pohltho/multi-worker:"$SHA"
