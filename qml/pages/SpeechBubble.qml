import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: speechBubble
    width: parent.width
    height: words.text.length > 90 ? parent.height / 1.5 : parent.height / 2

    property string post: "I have nothing to say."
    property alias _words: words
    property QtObject target
    property alias defaultButton: defaultBtn

    Image {
        id: bubbleImage
        source: "img/speech-bubble.png"
        anchors.fill: parent
        sourceSize.width: width
        sourceSize.height: height
        rotation: {
            if (verticalFlip) return 180
            else return 0
        }
        mirror: {
            if (horizontalFlip) return true
            else false
        }
    }

    Label {
        id: words
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: verticalFlip ? parent.height/2.45 :Theme.paddingLarge * 4  // roughly 3/4 is the bubble itself

        width: parent.width * 0.75
//        height: bubbleImage.height * 2/8
        text: post
        wrapMode: Text.Wrap
        truncationMode: TruncationMode.Fade
        color: "black"
    }

    Button {  // Why is that not clickable ?
        id: defaultBtn
        text: "Test"
        anchors.top: words.bottom
        anchors.topMargin: Theme.paddingMedium
        anchors.horizontalCenter: parent.horizontalCenter
        color: "black"
        onClicked: {
            console.debug("defaultBtn clicked")
            words.text = "defaultBtn clicked"
        }
        visible: false
    }

    property bool horizontalFlip: {
        if (rotationSensor.reading.orientation == 1 || rotationSensor.reading.orientation == 2) {
            if (!verticalFlip) {
                if (target.x + (target.width/2) > parent.width / 2) return true
                else return false
            }
            else {
                if (target.x + (target.width/2) > parent.width / 2) return false
                else return true
            }
        }
        else {
            if (!verticalFlip) {
                if (target.y + (target.width/2) > parent.height / 2) return false
                else return true
            }
            else {
                if (target.y + (target.width/2) > parent.height / 2) return true
                else return false
            }
        }
    }
    property bool verticalFlip: {
        if (rotationSensor.reading.orientation == 1 || rotationSensor.reading.orientation == 2) {
            if (target.y - height > 0) return false
            else return true
        }
        else
        {
            if (target.x - width/2 > 0) return false
            else return true
        }
    }
    y: {
        if (rotationSensor.reading.orientation == 1 || rotationSensor.reading.orientation == 2) {
            if (target.y - height > 0) return target.y - height
            else return target.y + target.height
        }
        else
        {
            if (target.y - (height/1.12) > 0) return target.y - height
            else return target.y + target.height
        }
    }
}

