

#!/bin/bash



# Set the Spark application name and memory allocation

SPARK_APP_NAME=${SPARK_APPLICATION_NAME}

SPARK_DRIVER_MEMORY=${DRIVER_MEMORY}

SPARK_EXECUTOR_MEMORY=${EXECUTOR_MEMORY}



# Check the available system memory

TOTAL_MEMORY=$(free -m | awk '/^Mem:/{print $2}')

USED_MEMORY=$(free -m | awk '/^Mem:/{print $3}')

AVAILABLE_MEMORY=$((TOTAL_MEMORY - USED_MEMORY))

echo "Total memory: ${TOTAL_MEMORY}MB"

echo "Used memory: ${USED_MEMORY}MB"

echo "Available memory: ${AVAILABLE_MEMORY}MB"



# Check if the requested memory allocation exceeds the available memory

if [[ $((SPARK_DRIVER_MEMORY + SPARK_EXECUTOR_MEMORY)) -gt $AVAILABLE_MEMORY ]]; then

    echo "Insufficient memory allocation for the Spark application"

    exit 1

fi



# Run the Spark application with the specified memory allocation

spark-submit --name ${SPARK_APP_NAME} --driver-memory ${SPARK_DRIVER_MEMORY} --executor-memory ${SPARK_EXECUTOR_MEMORY} ${PATH_TO_SPARK_APP}