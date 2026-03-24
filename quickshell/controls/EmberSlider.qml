import QtQuick
import QtQuick.Controls

Slider {
    id: root

    readonly property string icon: {
        if (root.value <= 0.0)
            return "󰝟";
        if (root.value < 0.5)
            return "󰖀";
        return "󰕾";
    }

    background: Rectangle {
        border.color: root.hovered ? "#8CFF7300" : "#1FFFFFFF"
        border.width: 1
        color: root.hovered ? Qt.rgba(1, 0.45, 0, 0.55) : Qt.rgba(1, 1, 1, 0.12)
        height: parent.height
        radius: 12
        width: parent.availableWidth

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

        Rectangle {
            color: root.pressed ? "#381807" : "#381807"
            radius: 10
            width: (parent.width - 4) * parent.parent.visualPosition

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }

            anchors {
                bottom: parent.bottom
                left: parent.left
                margins: 2
                top: parent.top
            }
        }
    }
    handle: Rectangle {
        height: 0
        visible: false
        width: 0
    }
}