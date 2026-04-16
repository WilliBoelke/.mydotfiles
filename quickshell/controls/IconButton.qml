import QtQuick
import QtQuick.Layouts
import qs.decoratives
import qs.services


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
            color: ThemeService.active.accent
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
                color: ThemeService.active.accent
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                font.weight: Font.ExtraBold
                text: root.title
            }
            Text {
                Layout.fillWidth: true
                color: ThemeService.active.accent
                elide: Text.ElideRight
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 10
                text: root.subtitle
            }
        }
    }
}