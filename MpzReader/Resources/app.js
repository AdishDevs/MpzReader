
(function() {
    window.webkit.messageHandlers.didLoad.postMessage(JSON.stringify({}));
})();



function handleImageClick(image) {
    window.webkit.messageHandlers.didClickImage.postMessage(image.src);
}
