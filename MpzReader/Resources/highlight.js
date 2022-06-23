function mpz_objToRange(rangeStr) {
    range = document.createRange();
    range.setStart(document.querySelector('[data-key="' + rangeStr.startKey + '"]').childNodes[rangeStr.startTextIndex], rangeStr.startOffset);
    range.setEnd(document.querySelector('[data-key="' + rangeStr.endKey + '"]').childNodes[rangeStr.endTextIndex], rangeStr.endOffset);
    return range;
}

function mpz_rangeToObj(range) {
    return {
        startKey: range.startContainer.parentNode.dataset.key,
        startTextIndex: Array.prototype.indexOf.call(range.startContainer.parentNode.childNodes, range.startContainer),
        endKey: range.endContainer.parentNode.dataset.key,
        endTextIndex: Array.prototype.indexOf.call(range.endContainer.parentNode.childNodes, range.endContainer),
        startOffset: range.startOffset,
        endOffset: range.endOffset
    }
}

function mpz_getSelectText(defaultColor) {
    var range = document.getSelection().getRangeAt(0);
    if (range.toString() == "") {
        return;
    }
    let id = "id-" + Date.now() + "-" + Math.floor(Math.random() * 10);
    let data = {
        range: mpz_rangeToObj(range),
        text: range.toString(),
        id: id,
        color: defaultColor
    };
    mpz_highlightRange(range, data.color, data.id);
    data["frame"] = getRectForId(id);
    let rangeStr = JSON.stringify(data);
    console.log(rangeStr);
    return rangeStr
}

function getRectForId(id) {
    let rect = document.getElementById(id).getBoundingClientRect();
    return "{{" + rect.left + "," + rect.top + "}, {" + rect.width + "," + rect.height + "}}";
}

function mpz_highlightRangeStr(base64Message) {
    let data = JSON.parse(atob(base64Message));
    console.log("mpz_highlightRangeStr", data)
    let range = mpz_objToRange(JSON.parse(data.range));
    mpz_highlightRange(range, data.bgColor, data.id);
}

function mpz_highlightRange(range, bgColor, id) {
    if (mpz_isElementExsist(id)) {
        mpz_updateHighlight(id, bgColor);
        return;
    }
    console.log("mpz_highlightRange 1");
    document.designMode = 'on';
    console.log("mpz_highlightRange 2");
    var sel = getSelection();
    console.log("mpz_highlightRange 3");
    sel.removeAllRanges();
    console.log("mpz_highlightRange 4");
    sel.addRange(range);
    console.log("mpz_highlightRange 5");
    document.execCommand('hiliteColor', false, 'fffff1');
    console.log("mpz_highlightRange 6");
    $('span').filter(function() {
        var color = $(this).attr('style');
        if (color) {
            color = color.toLowerCase()
            if (color.replace(/\s/g, '') == "background-color:rgb(255,255,241);" || color == "#fffff1" || color.replace(/\s/g, '').includes('255,255,241')) {
                $(this).attr('style', 'background-color: ' + bgColor + ' !important');
                $(this).attr('id', id);
                $(this).addClass('c-highlight');
                $(this).addClass(id);
            }
        }
    });
    console.log("mpz_highlightRange 7");
    document.designMode = 'off';
}

function mpz_updateHighlight(id, color) {
    $('.' + id).attr('style', 'background-color: ' + color + ' !important');
}

function mpz_isElementExsist(id) {
    return $('#' + id).length >= 1;
}


(function initializeHightlights() {
    // document.designMode = 'on';
    var key = 0;

    function addKey(element) {
        if (element.children.length > 0) {
            Array.prototype.forEach.call(element.children, function(each, i) {
                each.dataset.key = key++;
                addKey(each)
            });
        }
    };
    addKey(document.body);
    console.log("finish adding keys")
})();

function mpz_deleteHighlight(id) {
    $('.' + id).each(function() {
        $(this).css('background-color', '');
        $(this).removeClass('c-highlight');
    });
}

var getRectForSelectedText = function(elm) {
    if (typeof elm === "undefined") elm = window.getSelection().getRangeAt(0);
    var rect = elm.getBoundingClientRect();
    return "{{" + rect.left + "," + rect.top + "}, {" + rect.width + "," + rect.height + "}}";
}

function tapp() {}

(function() {
    $(document).on('touchend', '.c-highlight', function() {
        console.log("did tap");
        let id = $(this).attr('id');
        let frame = getRectForId(id);
        let data = {
            id: id,
            frame: frame
        };
        console.log(data);
        window.webkit.messageHandlers.didTapOnHighlight.postMessage(JSON.stringify(data));
    });
})();
