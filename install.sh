#!/bin/bash

# Make sure that you have docker, wget, and python before you run this, okay?
# This script is meant to be ran from the directory that it shipped in, if you move
# it, then you'll have a lot of paths to update. Your call.
if ! hash docker &> /dev/null
then
    printf "Looks like you don't have docker, but that's no problem friend, I'll just go ahead and grab it for you. My treat, I insist.\n"
    wget -O - https://get.docker.com/ | bash
fi

if ! hash python3 &> /dev/null
then
    printf "You don't seem to have python3 installed there partner. Go take a gander around https://www.python.org/. \n Now you come back real soon, you hear?\n"
    exit -1
fi

function getModel () {
    printf "Fetching us a prebuilt model so we don't have to sit on our butts.\n"
    printf "That said, it's a quarter gig, so this may take a moment...\n"
    wget "https://maxfieldchen.com/raw/im2txt_model_parameters.tar.gz"
    printf "Done!, hopefully you're still with me.\n"
}

# If the model is not already here, download it.
[ -f "./im2txt_model_parameters.tar.gz" ] || getModel

# Builds docker image / container

printf "Building the AI jail now...\n"
docker build . -t kalt && \
docker build ./containers/ -t caption
printf "AI's are secure. Probably.\n"

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

printf "=====================\n"
printf "Install the manifest.json file to your browser.\n"
printf "=====================\ n"

exit 0
