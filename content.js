console.log("Content Script Active.");

/*
Add the image to the web page by:
* Removing every node in the document.body
* Inserting the selected image
*/
function injectImage(message, sender, sendResponse) {
    console.log("We are trying to inject an image");
    removeEverything();
    insertImage(message);
}

/*
Remove every node under document.body
*/
function removeEverything() {
    while (document.body.firstChild) {
        document.body.firstChild.remove();
    }
}

/*
Given a URL to an image, create and style an iframe containing an
IMG node pointing to that image, then insert the node into the document.
*/
function insertImage(imageURL) {
    const insertImage = document.createElement("img");
    insertImage.setAttribute("src", imageURL);
    insertImage.setAttribute("style", "width: 100vw; height: 100vh;");
    document.body.appendChild(insertImage);
}

/*
Assign injectImage() as a listener for messages from the extension.
*/
browser.runtime.onMessage.addListener(injectImage);
