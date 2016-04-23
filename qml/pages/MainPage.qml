import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: page
    objectName: "mainPage"

    SilicaFlickable {
        id: flick
        anchors.fill: page
        contentHeight: content.height

        PullDownMenu {
            MenuItem {
                text: "Close overlay"
                onClicked: viewHelper.closeOverlay()
            }
            MenuItem {
                text: "About"
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        Column {
            id: content
            width: parent.width

            PageHeader {
                title: "Tux-Chara"
            }

            CharaModel {
                id: charaModel
            }

            ComboBox {
                id: charaSelector
                property string defaultValue: "tux2.png"
                label: qsTr("Character:")
                labelMargin: Theme.paddingMedium
                menu: ContextMenu {
                    Repeater {
                        width: parent.width
                        model: charaModel
                        delegate: MenuItem {
                            text: model.name
                            Image {
                                id: menuIcon
                                source: model.icon
                                anchors.right: parent.right
                                anchors.verticalCenter: parent.verticalCenter
                                width: height
                                height: parent.height
                            }
                            onClicked: {
                                viewHelper.character = icon
                                viewHelper.characterMsg = defaultText
                            }
                        }
                    }
                }
                // This somehow resets the whole thing on start. Some odd race condition I don't get
//                onCurrentItemChanged: {
//                    viewHelper.character = charaModel.get(currentIndex).icon
//                    viewHelper.characterMsg = charaModel.get(currentIndex).defaultText
//                }
                Component.onCompleted: {
                    for (var i = 0; i < charaModel.count; i++) {
                        if (charaModel.get(i).icon == viewHelper.character) {
                            currentIndex = i
                            viewHelper.character = charaModel.get(i).icon
                            viewHelper.characterMsg = charaModel.get(i).defaultText
                            break
                        }
                    }
                }

            }
            AnimatedImage {
                width: Theme.iconSizeExtraLarge
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                source: "charas/tux-construction2.gif"
                playing: true
            }

            Label {
                text: "Work in Progress"
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.secondaryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
