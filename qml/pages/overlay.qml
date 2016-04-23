import QtQuick 2.1
import Sailfish.Silica 1.0
import QtSensors 5.0

Item {
    id: root

    width: Screen.width
    height: Screen.height

    property string chara: viewHelper.character
    property string charaPost: viewHelper.characterMsg
    property int settingsViewIsActive: 1

    onCharaChanged: {
        if (bubble.opacity != 1.0) bubble.opacity = 1.0
    }

    Connections {
        target: viewHelper
        onApplicationRemoval: {
            removalOverlay.opacity = 1.0
        }
        // Hide when lipstick app drawer is shown or lockscreen or other app except for settingsView
        //
        // Dbus :
        // dest=(null destination) serial=14626 path=/com/jolla/lipstick; interface=com.jolla.lipstick; member=coverstatus
        // coverstatus = 2 == Home
        // coverstatus = 0 == App Drawer / LockScreen / Other App in foreground
        onCoverStatusChanged: {
            if (viewHelper.coverStatus == 0 && settingsViewIsActive == 0) viewHelper.hideOverlay();
            else if (viewHelper.coverStatus == 2 || settingsViewIsActive == 1) viewHelper.unhideOverlay();
        }
        onSettingsActiveChanged: {
            settingsViewIsActive = viewHelper.settingsActive
            if (settingsViewIsActive == 1) viewHelper.unhideOverlay();  // Just to make sure
        }
    }

    OrientationSensor {
        id: rotationSensor
        active: true
        property bool hack: if (reading.orientation) _getOrientation(reading.orientation)
        property int sensorAngle: 0
        property int angle: sensorAngle
        function _getOrientation(value) {
            switch (value) {
            case 1:
                sensorAngle = 0
                break
            case 2:
                sensorAngle = 180
                break
            case 3:
                sensorAngle = -90
                break
            case 4:
                sensorAngle = 90
                break
            default:
                return false
            }
            return true
        }
    }

    MouseArea {
        id: touchArea

        x: viewHelper.lastXPos
        y: viewHelper.lastYPos

        width: Theme.itemSizeLarge
        height: Theme.itemSizeLarge

        drag.target: touchArea
        drag.minimumX: 0
        drag.maximumX: root.width - touchArea.width
        drag.minimumY: 0
        drag.maximumY: root.height - touchArea.height

        onDoubleClicked: {
            viewHelper.hideShowToggle();
            //Qt.quit()
        }
        onClicked: {
            if (bubble.opacity == 1.0) bubble.opacity = 0
            else bubble.opacity = 1.0
        }
        onReleased: {
            if (bubble.opacity = 1.0) viewHelper.setTouchRegion(Qt.rect(bubble.x, bubble.y, bubble.width+width, bubble.height+height), false)
            else viewHelper.setTouchRegion(Qt.rect(x, y, width, height))
        }

        Item {
            id: iconItem
            anchors.fill: parent
            property int deltaAngle: 0
            rotation: rotationSensor.angle + deltaAngle
            Behavior on rotation {
                SmoothedAnimation { duration: 500 }
            }
            AnimatedImage {
                id: mainIcon
                anchors.centerIn: parent
                anchors.fill: parent
                source: chara
            }
        }
    }
    SpeechBubble {
        id: bubble
        property int deltaAngle: 0
        rotation: rotationSensor.angle + deltaAngle
        Behavior on rotation {
            SmoothedAnimation { duration: 500 }
        }
        Behavior on opacity {
            FadeAnimation { duration: 600 }
        }
        onOpacityChanged: {
            if (opacity == 1.0) {
                if (showTime.running) showTime.restart()
                else showTime.start()
            }
            else if (opacity == 0) {
                viewHelper.setTouchRegion(Qt.rect(touchArea.x, touchArea.y, touchArea.width, touchArea.height))
            }
        }
        anchors.horizontalCenter: parent.horizontalCenter
        target: touchArea
        opacity: 0

        Timer {
            id: showTime
            interval: 3000;
            onTriggered: bubble.opacity = 0
        }

        post: charaPost
        Component.onCompleted: {
            opacity = 1.0
        }
    }
}
