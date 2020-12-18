// debug
alert("Open the debug console!");


function onResponse(response) {
  console.log("Received " + response);
  browser.notifications.create({
    "type": "basic",
    "iconUrl": browser.extension.getURL("link.png"),
    "title": "Generated Alt-Text",
    "message": response
  });
  // Add copying of the best choice when clicking on the notification.
  browser.notifications.onClicked.addListener(() => navigator.clipboard.writeText(response));
}

function onError(error) {
  console.log(`Error: ${error}`);
}

function onCreated(error) {
  console.log("Created: " + error);
}

browser.contextMenus.create({
  title: "Get Kalt Text",
  documentUrlPatterns: ["*://*/*"],
  contexts: ["image"],
  onclick(info, tab) {
    console.log("Sending request to content: " + info);
    var message = info.srcUrl;
    var imageLength = message.length;
    browser.notifications.create({
        "type": "basic",
        "iconUrl": browser.extension.getURL("link.png"),
        "title": "Generating K Alt Text For: " + "..." + message.slice(imageLength - 10, imageLength),
        "message": message
    });
    captions = caption(message);

  }
});



var home = "/home/nihliphobe/";
var im2txt_path = home + "im2txt/";
var checkpoint_path = im2txt_path + "im2txt/model/Hugh/train/newmodel.ckpt-2000000";
var vocab_path = im2txt_path + "im2txt/data/Hugh/word_counts.txt";
var input_path = im2txt_path + "im2txt/data/images/";
var binary_path = im2txt_path + "bazel-bin/im2txt/run_inference";


function caption(url) {
  console.log("Sending: " + url);
  var sending = browser.runtime.sendNativeMessage(
    "im2txt",
    url);
  sending.then(onResponse, onError);
};
