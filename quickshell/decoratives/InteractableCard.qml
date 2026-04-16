import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property bool active: false
    // Content slot
    default property alias content: contentItem.data

        signal
    clicked

    // Style from IconButton
    border.color: active ? Qt.rgba(1, 0.45, 0, 0.9) : mouseArea.containsMouse ? Qt.rgba(1, 0.45, 0, 0.55) : Qt.rgba(1, 1, 1, 0.12)
    border.width: 1
    color: active ? Qt.rgba(1, 0.4, 0, 0.35) : mouseArea.containsMouse ? Qt.rgba(1, 0.4, 0, 0.18) : Qt.rgba(1, 1, 1, 0.07)
    radius: 12

    // Height/width should be set by parent or content

    Behavior on border
    .
    color {
        ColorAnimation {
            duration: 150
        }
    }
    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Item {
        id: contentItem

        anchors.fill: parent
    }
    MouseArea {
        id: mouseArea

        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        propagateComposedEvents: true

        onClicked: mouse => {
            mouse.accepted = false;
            root.clicked();
        }
    }
}

