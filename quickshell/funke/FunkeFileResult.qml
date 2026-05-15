import QtQuick
import qs.services
import qs.decoratives

InteractableCard {
    id: root

    property var file
    property bool externalActive: false


    signal launched()


    neutral: true
    active: externalActive || root.hovered
    implicitHeight: fileContentColumn.implicitHeight + 24

    Column {
        id: fileContentColumn
        anchors.fill: parent
        anchors.margins: 6
        spacing: 4

        Text {
            text: root.file.name
            color: ThemeService.active.accent
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 15
            font.weight: Font.ExtraBold
            font.underline: root.active
            wrapMode: Text.WordWrap
        }
        Text {
            text: root.file.path
            color: "#faa42F"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 11
            font.underline: root.active
            elide: Text.ElideLeft
            width: parent.width
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

