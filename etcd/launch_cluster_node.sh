

# Create custom network
# docker network create --driver bridge custom-etcd-network --subnet 172.122.0.0/16 --gateway 172.122.0.1

DATA_BASE_PATH="PLEASE FILL THIS PART"
TOKEN=test-cluster-token
CLUSTER_STATE=new
NAME_1=etcd-demo-cluster-1
NAME_2=etcd-demo-cluster-2
NAME_3=etcd-demo-cluster-3
HOST_1=172.122.0.141
HOST_2=172.122.0.142
HOST_3=172.122.0.143
HOST_DATA_PATH_1=${DATA_BASE_PATH}/instance-1
HOST_DATA_PATH_2=${DATA_BASE_PATH}/instance-2
HOST_DATA_PATH_3=${DATA_BASE_PATH}/instance-3
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380


INSTANCE_INDEX=3


THIS_NAME="NAME_${INSTANCE_INDEX}"
THIS_IP="HOST_${INSTANCE_INDEX}"
THIS_HOST_DATA_PATH="HOST_DATA_PATH_${INSTANCE_INDEX}"

docker run \
        -P -d \
        --name "${!THIS_NAME}.host" \
        --ip ${!THIS_IP} \
        --network custom-etcd-network \
        --mount type=bind,source=${!THIS_HOST_DATA_PATH},destination=/etcd-data \
        quay.io/coreos/etcd:v3.4.19 \
        /usr/local/bin/etcd \
        --name ${!THIS_NAME} \
        --data-dir /etcd-data \
        --listen-client-urls http://${!THIS_IP}:2379 \
        --advertise-client-urls http://${!THIS_IP}:2379 \
        --listen-peer-urls http://${!THIS_IP}:2380 \
        --initial-advertise-peer-urls http://${!THIS_IP}:2380 \
        --initial-cluster ${CLUSTER} \
        --initial-cluster-token ${TOKEN} \
        --initial-cluster-state ${CLUSTER_STATE} \
        --log-level info \
        --logger zap \
        --log-outputs stderr
