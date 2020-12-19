# Download And Analyze A User Provided Image Using KALT

FROM kalt

VOLUME "/var/log/kalt"

WORKDIR /usr/src/kalt/Im2txt/

# Source URL of the file to run through the engine
ENV input_URL = "https://phoenixnap.com/kb/wp-content/uploads/2020/02/list-locally-stored-images.png"

# Fetch The User's Image If Their So Keen
RUN wget $input_URL -O im2txt/data/images/toParse.jpeg; exit 0;

#Run the engine to generate captions
ENTRYPOINT bazel-bin/im2txt/run_inference --checkpoint_path="im2txt/model/Hugh/train/newmodel.ckpt-2000000" --vocab_file="im2txt/data/Hugh/word_counts.txt" --input_files="im2txt/data/images/toParse.jpeg" 
