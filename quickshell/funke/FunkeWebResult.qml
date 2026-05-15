import QtQuick
import qs.services
import qs.decoratives

InteractableCard {
    id: root

    property var result
    property bool externalActive: false


    signal launched()


    neutral: true
    active: externalActive || root.hovered
    implicitHeight: webContentColumn.implicitHeight + 24

    Column {
        id: webContentColumn
        anchors.fill: parent
        anchors.margins: 12
        spacing: 4

        Text {
            text: root.result.title
            width: parent.width
            color: ThemeService.active.accent
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 15
            font.weight: Font.ExtraBold
            font.underline: root.active
            wrapMode: Text.WordWrap
        }
        Text {
            text: root.result.snippet
            width: parent.width
            color: "#faa42F"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 11
            wrapMode: Text.WordWrap
        }
    }

    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onClicked: mouse => {
            mouse.accepted = false
            root.launched()
        }
    }
}

