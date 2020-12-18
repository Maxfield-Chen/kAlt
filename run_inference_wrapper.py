import json
import os
import sys
import struct
import subprocess
from subprocess import Popen

input_file = "toParse.jpeg"
home = "/home/nihliphobe/"
im2txt_path = home + "im2txt/"
checkpoint_path = im2txt_path + "im2txt/model/Hugh/train/newmodel.ckpt-2000000"
vocab_path = im2txt_path + "im2txt/data/Hugh/word_counts.txt"
input_path = im2txt_path + "im2txt/data/images/"
binary_path = im2txt_path + "bazel-bin/im2txt/run_inference"

# Read a message from stdin and decode it.
def get_message():
    raw_length = sys.stdin.buffer.read(4)

    if not raw_length:
        sys.exit(0)
    message_length = struct.unpack('=I', raw_length)[0]
    message = sys.stdin.buffer.read(message_length).decode("utf-8")
    return json.loads(message)


# Encode a message for transmission, given its content.
def encode_message(message_content):
    encoded_content = json.dumps(message_content).encode("utf-8")
    encoded_length = struct.pack('=I', len(encoded_content))
    #  use struct.pack("10s", bytes), to pack a string of the length of 10 characters
    return {'length': encoded_length, 'content': struct.pack(str(len(encoded_content))+"s",encoded_content)}


# Send an encoded message to stdout.
def send_message(encoded_message):
    sys.stdout.buffer.write(encoded_message['length'])
    sys.stdout.buffer.write(encoded_message['content'])
    sys.stdout.buffer.flush()

def get_alt(file_name):
    process = subprocess.run([binary_path, "--checkpoint_path=" + checkpoint_path, "--vocab_file=" + vocab_path, "--input_files=" + input_path + file_name], stdout=subprocess.PIPE, encoding='utf-8')
    output = process.stdout
    start_offset = output.find('0)')
    end_offset = output.find('(p')
    return (output[start_offset + 2:end_offset - 2])

while True:
    url = get_message()
    process = subprocess.run(["wget", url, "-O", input_path + input_file])
    captions = get_alt(input_file)
    send_message(encode_message(captions))
