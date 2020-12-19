# Set up a docker container so that we can run imtxt with as little hassle as possible.

FROM python:3.6.9

WORKDIR /usr/src/kalt

COPY im2txt_model_parameters.tar.gz .

# Setup pre-trained model
RUN apt-get update && apt-get install -y tar zip wget npm python3-pip && \
    wget https://github.com/HughKu/Im2txt/archive/master.zip &&  \
    unzip master.zip && mv Im2txt-master Im2txt && \
    mkdir -p Im2txt/im2txt/model/Hugh/train && \
    # Extract pre-built mode
    tar xvzf im2txt_model_parameters.tar.gz && \
    #Move model to the right places
    mkdir -p Im2txt/im2txt/model/Hugh/train && \
    mv modelParameters/* Im2txt/im2txt/model/Hugh/train/ && \
    #Install build requirements
    npm install -g @bazel/bazelisk && \
    bazelisk

#Build AI engine
WORKDIR /usr/src/kalt/Im2txt/
RUN pip3 install --no-cache-dir -r requirement.txt
WORKDIR /usr/src/kalt/Im2txt/im2txt/
RUN bazel build run_inference
