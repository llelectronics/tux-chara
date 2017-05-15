import QtQuick 2.1
import Sailfish.Silica 1.0

ApplicationWindow
{
    _defaultPageOrientations: Orientation.All
    _allowedOrientations: Orientation.All
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("../cover/CoverPage.qml")
    property string appicon: "img/icon.png"
    property string appname: "Tux-Chara"
    property string version: "0.7"
}


