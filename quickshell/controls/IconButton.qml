import QtQuick
import QtQuick.Layouts
import qs.decoratives

InteractableCard {
    id: root

    property bool active: false
    property string iconText: ""
    property string subtitle: ""
    property string title: ""

    height: 64
    width: 220

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
}