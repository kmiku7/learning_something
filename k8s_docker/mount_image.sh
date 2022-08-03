# mount-image.sh IMAGE-NAME MOUNT-PATH

IMAGE_NAME=$1
MOUNT_DIR=$2

LOWER_DIR_LIST=$(docker image inspect "${IMAGE_NAME}" | jq -r .[0].GraphDriver.Data.LowerDir)
UPPER_DIR=$(docker image inspect "${IMAGE_NAME}" | jq -r .[0].GraphDriver.Data.UpperDir)
WORK_DIR=$(docker image inspect "${IMAGE_NAME}" | jq -r .[0].GraphDriver.Data.WorkDir)

mkdir -p "${MOUNT_DIR}"
mount -t overlay -o \
    lowerdir="${LOWER_DIR_LIST}",upperdir="${UPPER_DIR}",workdir="${WORK_DIR}" \
    overlay "${MOUNT_DIR}"
