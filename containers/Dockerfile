# Download And Analyze A User Provided Image Using KALT

FROM kalt

VOLUME "/var/log/kalt"

WORKDIR /usr/src/kalt/Im2txt/

# Source URL of the file to run through the engine
ENV kalt = "https://maxfieldchen.com/images/profile.jpg"

#Run the engine to generate captions
ENTRYPOINT wget $kalt -O im2txt/data/images/toParse.jpeg; bazel-bin/im2txt/run_inference --checkpoint_path="im2txt/model/Hugh/train/newmodel.ckpt-2000000" --vocab_file="im2txt/data/Hugh/word_counts.txt" --input_files="im2txt/data/images/toParse.jpeg"
