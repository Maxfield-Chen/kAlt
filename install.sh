#!/bin/bash
# Do make sure that you have docker and python before you run this, okay?
if ! command docker &> /dev/null
then
    wget -O - https://get.docker.com/ | bash
fi

# Builds docker image / container

docker build . -t kalt && \
docker build ./containers/ -t caption

# Linux by default, how about that...
nativeManifestPath='~/.mozilla/native-messaging-hosts/'

if [ "$(uname)" == "Darwin" ]; then
    nativeManifestPath='~/Library/Application Support/Mozilla/NativeMessagingHosts/'
fi


# Installs native trampoline
# First the "go.sh" script will be called, then "run_inference_wrapper.py"
# Finally that python script will call the caption docker container
# Both of these setup scripts will be stored in the native manifest path.
cp ./go.sh $nativeManifestPath
cp ./run_inference_wrapper.py $nativeManifestPath
cp ./im2txt.json $nativeManifestPath

echo "Well All Right There Partner! Install The manifest.json File In This Here Folder Right To Your Darn Did Browser You'll Be Off To The Races! Yell At maxfieldchen@Gmail.com if this thing gives you any troubles. He probably won't listen, but it will be therapeutic for you."

#Sample usage
#docker run caption -e image_URL=https://maxfieldchen.com/images/profile.jpg --mount type=volume,target=/var/log/kalt/
