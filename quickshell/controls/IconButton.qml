import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property bool active: false
    property string iconText: ""
    property string subtitle: ""
    property string title: ""

    signal clicked

    border.color: active ? Qt.rgba(1, 0.45, 0, 0.9) : mouseArea.containsMouse ? Qt.rgba(1, 0.45, 0, 0.55) : Qt.rgba(1, 1, 1, 0.12)
    border.width: 1
    color: active ? Qt.rgba(1, 0.4, 0, 0.35) : mouseArea.containsMouse ? Qt.rgba(1, 0.4, 0, 0.18) : Qt.rgba(1, 1, 1, 0.07)
    height: 64
    radius: 12

    // --- Dimensions ---
    width: 220

    Behavior on border.color {
        ColorAnimation {
            duration: 150
        }
    }
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    // --- Layout: icon | title + subtitle ---
    RowLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 12

        // Icon
        Text {
            Layout.alignment: Qt.AlignVCenter
            color: "#FF7F00"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 22
            text: root.iconText
        }

        // Title + Subtitle
        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            spacing: 2

            Text {
                color: "#FFFFFF"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 13
                font.weight: Font.Medium
                text: root.title
            }
            Text {
                Layout.fillWidth: true
                color: "#AAAAAA"
                elide: Text.ElideRight
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 10
                text: root.subtitle
            }
        }
    }

    // --- Interaction ---
    MouseArea {
        id: mouseArea

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: root.clicked()
    }
}