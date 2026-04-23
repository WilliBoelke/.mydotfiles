import QtQuick
import QtQuick.Controls
import qs.services

Slider {
    id: root
    height: 12

    readonly property string icon: {
        if (root.value <= 0.0)
            return "󰝟";
        if (root.value < 0.5)
            return "󰖀";
        return "󰕾";
    }

    background: Rectangle {
        border.width: 1
        color: ThemeService.active.accentDark
        height: 12
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
            color: ThemeService.active.accent
            radius: 12
            height: parent.height - 6
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