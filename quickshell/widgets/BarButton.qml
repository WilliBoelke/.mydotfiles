import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Widgets

Rectangle {
    id: barButton

    property color accentColor: "#d55c1b"
    property color bgColor: "#381807"
    property string icon: ""
    property string label: ""
    property int value: 0

        signal
    clicked

    color: barButton.value > 0 ? barButton.accentColor : barButton.bgColor
    height: 32
    implicitWidth: buttonLayout.implicitWidth + 16
    radius: 6

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: barButton.clicked()
    }
    Row {
        id: buttonLayout

        anchors.centerIn: parent
        spacing: 6

        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: barButton.accentColor
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 14
            font.weight: Font.Bold
            text: barButton.icon
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            color: barButton.accentColor
            font.pixelSize: 14
            font.weight: Font.Bold
            text: barButton.label
        }
    }
}
