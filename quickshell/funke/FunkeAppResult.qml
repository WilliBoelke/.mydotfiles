import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Effects
import qs.services
import qs.decoratives

InteractableCard {
    id: root

    property var app


    signal launched()


    implicitHeight: appContentRow.implicitHeight + 24

    Row {
        id: appContentRow
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Item {
            width: 32
            height: 32
            anchors.verticalCenter: parent.verticalCenter
            IconImage {
                anchors.fill: parent
                source: "image://icon/" + root.app.icon
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 0.7
                    colorizationColor: ThemeService.active.accent
                }
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2
            Text {
                text: root.app.name
                color: ThemeService.active.accent
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 16
                font.weight: Font.ExtraBold
            }
            Text {
                text: root.app.comment
                color: "#faa42F"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.launched()
    }
}

