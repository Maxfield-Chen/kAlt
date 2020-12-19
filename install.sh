#!/bin/bash

# Make sure that you have docker, wget, and python before you run this, okay?
# This script is meant to be ran from the directory that it shipped in, if you move
# it, then you'll have a lot of paths to update. Your call.
if ! command docker &> /dev/null
then
    wget -O - https://get.docker.com/ | bash
    echo "Looks like you don't have docker, but that's no problem friend, I'll just go ahead and grab it for you. My treat, I insist."
fi

if ! command python &> /dev/null
then
    echo "You don't seem to have python installed there partner. Go take a gander around https://www.python.org/. Now you come back real soon, you hear?"
    exit -1
fi

function getModel () {
    echo "Fetching us a prebuilt model so we don't have to sit on our butts."
    echo "That said, it's a quarter gig, so this may take a moment..."
    wget "https://maxfieldchen.com/raw/im2txt_model_parameters.tar.gz"
    echo "Done!, hopefully you're still with me."
}

# If the model is not already here, download it.
[ -f "./im2txt_model_parameters.tar.gz" ] || getModel

# Builds docker image / container

echo "Building the AI jail now..."
docker build . -t kalt && \
docker build ./containers/ -t caption
echo "AI's are secure. Probably."

# Linux by default, how about that...
nativeManifestPath='~/.mozilla/native-messaging-hosts/'
manifestName='im2txt.json'

if [ "$(uname)" == "Darwin" ]; then
    nativeManifestPath='~/Library/Application Support/Mozilla/NativeMessagingHosts/'
fi

# Installs native trampoline and manifest files
# Python script will call the caption docker container
echo "Now we just need to shuffle some files around..."
cp ./run_inference_wrapper.py $nativeManifestPath

# Set the path for the native file now that we know our platform
python -c "import sys; lines = sys.stdin.read(); print lines.replace('FIXME', \"$nativeManifestPath$manifestName\")" < im2txt.json > "$nativeManifestPath$manifestName"


echo "Well All Right There Partner! Install The manifest.json File In This Here Folder Right To Your Darn Did Browser. You'll Be Off To The Races!"

echo "Yell At maxfieldchen@gmail.com if this thing gives you any troubles. He probably won't listen, but it may be therapeutic for you."

exit 0
