#!/bin/bash
# Starts the Arduino IDE using the docker image.
# see also: ...

# extract version from Dockerfile
version=$(grep 'ENV ARDUINO_IDE_VERSION' Dockerfile | awk '{print $(NF)}')
docker build . -t tombenke/darduino:v$version


# add current available arduino TTY's
extra=""
for n in $(ls /dev/ttyACM*) ; do
	extra="-v $n:$n $extra"
done
for n in $(ls /dev/ttyUSB*) ; do
	extra="-v $n:$n $extra"
done

#    -v /dev/ttyACM0:/dev/ttyACM0 \
#    -v /dev/ttyUSB0:/dev/ttyUSB0 \
docker run \
    -it \
    --rm \
    --network=host \
    --privileged \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev:/dev \
    -v $HOME/topics:/topics \
    -v $HOME/topics/arduino:/home/developer/Arduino \
    --name arduino \
    $extra \
    tombenke/darduino:v$version \
    arduino

