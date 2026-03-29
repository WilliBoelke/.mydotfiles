import qs.services
import Quickshell
import QtQuick

Text {
    property string icon: ""
    property int size : 14
    property color mColor: ThemeService.active.accent

    anchors.centerIn: parent
    color:  mColor
    font.pixelSize: size
    text: icon
}
