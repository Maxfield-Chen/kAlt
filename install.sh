#!/bin/bash

function loring () {
    printf "=====================\n"
    printf "$1\n"
    printf "=====================\n"
}

# Make sure that you have docker, wget, and python before you run this, okay?
# This script is meant to be ran from the directory that it shipped in, if you move
# it, then you'll have a lot of paths to update. Your call.
if ! hash docker &> /dev/null
then
    loring "Looks like you don't have docker, but that's no problem friend, I'll just go ahead and grab it for you. My treat, I insist."
    wget -O - https://get.docker.com/ | bash
fi

if ! hash python3 &> /dev/null
then
    loring "You don't seem to have python3 installed there partner. Go take a gander around https://www.python.org/. \n Now you come back real soon, you hear?"
    exit -1
fi

function getModel () {
    loring "Fetching us a prebuilt model so we don't have to sit on our butts."
    loring "That said, it's a quarter gig, so this may take a moment..."
    wget "https://maxfieldchen.com/raw/im2txt_model_parameters.tar.gz"
    loring "Done!, hopefully you're still with me."
}

# If the model is not already here, download it.
[ -f "./im2txt_model_parameters.tar.gz" ] || getModel

# Builds docker image / container

loring "Building the AI jail now..."
docker build . -t kalt && \
docker build ./containers/ -t caption
loring "AI's are secure. Probably."

# Linux by default, how about that...
nativeManifestPath='/usr/lib/mozilla/native-messaging-hosts/'
manifestName='im2txt.json'

if [ "$(uname)" == "Darwin" ]; then
    nativeManifestPath='/Library/Application Support/Mozilla/NativeMessagingHosts/'
fi

# Installs native trampoline and manifest files
# Python script will call the caption docker container
mkdir -p "$nativeManifestPath"
chmod +x ./go.sh
cp ./go.sh $nativeManifestPath
cp ./run_inference_wrapper.py $nativeManifestPath

# Set the path for the native file now that we know our platform
python -c "import sys; lines = sys.stdin.read(); print lines.replace('FIXME', \"$nativeManifestPath/go.sh\")" < im2txt.json > "$nativeManifestPath$manifestName"

loring "Install the manifest.json file to your browser."

exit 0
