#!/bin/sh

if [ -z "$KAFKA_PORT" ]; then
    KAFKA_PORT=9092
    echo "advertised port: $KAFKA_PORT"
fi
sed -r -i "s/port=(.*)/\1=$KAFKA_PORT/g" $KAFKA_HOME/config/server.properties
sed -r -i "s|#(listeners)=(.*)|\1=PLAINTEXT://0.0.0.0:$KAFKA_PORT|g" $KAFKA_HOME/config/server.properties

if [ ! -z "$KAFKA_HOST" ]; then
    echo "advertised listeners: PLAINTEXT://$KAFKA_HOST:9092"
    sed -r -i "s|#(advertised.listeners)=(.*)|\1=PLAINTEXT://$KAFKA_HOST:$KAFKA_PORT|g" $KAFKA_HOME/config/server.properties
fi

# Set the broker id
if [ ! -z "$BROKER_ID" ]; then
    echo "broker id: $BROKER_ID"
    sed -r -i "s/(broker.id)=(.*)/\1=$BROKER_ID/g" $KAFKA_HOME/config/server.properties
fi

# Set the zookeeper connect from the environment variable 
if [ ! -z "$ZOOKEEPER_CONNECT" ]; then
    echo "zookeeper connect: $ZOOKEEPER_CONNECT"
    sed -r -i "s/(zookeeper.connect)=(.*)/\1=$ZOOKEEPER_CONNECT/g" $KAFKA_HOME/config/server.properties
fi

# Allow specification of log retention policies
if [ ! -z "$LOG_RETENTION_HOURS" ]; then
    echo "log retention hours: $LOG_RETENTION_HOURS"
    sed -r -i "s/(log.retention.hours)=(.*)/\1=$LOG_RETENTION_HOURS/g" $KAFKA_HOME/config/server.properties
fi
if [ ! -z "$LOG_RETENTION_BYTES" ]; then
    echo "log retention bytes: $LOG_RETENTION_BYTES"
    sed -r -i "s/#(log.retention.bytes)=(.*)/\1=$LOG_RETENTION_BYTES/g" $KAFKA_HOME/config/server.properties
fi

# Configure the default number of log partitions per topic
if [ ! -z "$NUM_PARTITIONS" ]; then
    echo "default number of partition: $NUM_PARTITIONS"
    sed -r -i "s/(num.partitions)=(.*)/\1=$NUM_PARTITIONS/g" $KAFKA_HOME/config/server.properties
fi

# Enable/disable auto creation of topics
if [ ! -z "$AUTO_CREATE_TOPICS" ]; then
    echo "auto.create.topics.enable: $AUTO_CREATE_TOPICS"
    echo "auto.create.topics.enable=$AUTO_CREATE_TOPICS" >> $KAFKA_HOME/config/server.properties
fi

# Configure the default number of log partitions per topic
if [ ! -z "$DELETE_TOPIC_ENABLE" ]; then
    echo "delete.topic.enable: $DELETE_TOPIC_ENABLE"
    sed -r -i "s/(delete.topic.enable)=(.*)/\1=$DELETE_TOPIC_ENABLE/g" $KAFKA_HOME/config/server.properties
fi

# Run Kafka
$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
