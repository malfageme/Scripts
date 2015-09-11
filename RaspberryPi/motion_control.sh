#!/usr/bin/ksh


ST_SERVER=**SERVER**
ST_SERVER_PATH=**PATH**
MOTION_DATA_DIR=**PATH**
MOUNTED_FILE=${MOTION_DATA_DIR}/mounted_flag

MOTION_PATH=~/mmal
MOTION_EXEC=motion_mmal
MOTION_CFG=motion_mmalcam.conf
MOTION_CMD="${MOTION_PATH}/${MOTION_EXEC} -n -c ${MOTION_PATH}/${MOTION_CFG}"

MOUNT_CMD="sudo mount ${ST_SERVER}:${ST_SERVER_PATH} ${MOTION_DATA_DIR}"
UMOUNT_CMD="sudo umount -f ${MOTION_DATA_DIR}"

# Check for filesystem mounted
#
if [ ! -r ${MOUNTED_FILE} ]; then
    echo "Data directory not accessible"
    if [[ $(mount | grep "${ST_SERVER_PATH} on ${MOTION_DATA_DIR}") ]]; then
        echo "Data directory already mounted"
        echo "Unmounting first..."
        $UMOUNT_CMD
    fi
    echo "Now mounting..."
    $MOUNT_CMD
    res=$?
    if [ $res -eq 0 ]; then
        echo "Mounting successful"
    else
        echo "Error mounting data dir: ${res}"
    fi
fi

num_proc=`ps -ef |grep motion-mmal | grep -v grep | wc -l`
num_sockets=`netstat -an | grep :8081 | wc -l`

if [ ${num_proc} -lt 1 -o ${num_sockets} -lt 1 ]; then
    echo "Process not detected"
    ps -ef |grep ${MOTION_EXEC} | grep -v grep | awk '{print $2}'| xargs kill
    echo "Launching motion process..."
    nohup ${MOTION_CMD} 
    nohup ${MOTION_CMD} 1>/dev/null 2>&1 </dev/null &
fi


