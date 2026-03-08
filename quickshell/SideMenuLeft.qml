import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.widgets

PanelWindow {
    id: root

    // Just this binding directly
    property bool open: false
    property int panelWidth: 600

    color: "transparent"
    exclusionMode: ExclusionMode.Normal
    width: root.panelWidth

    mask: Region {
        item: root.open ? contentRect : null
    }

    margins {
        bottom: 20
        left: 20
        top: 20
    }
    anchors {
        bottom: true
        left: true
        top: true
    }

    // main penal boxa
    Rectangle {
        id: contentRect

        color: "#1a000000"
        radius: 12
        width: root.panelWidth

        Behavior on anchors.leftMargin {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        anchors {
            bottom: parent.bottom
            left: parent.left
            leftMargin: root.open ? 0 : -root.panelWidth
            top: parent.top
        }
        Flickable {
            id: menuScroll

            anchors.fill: parent
            clip: true
            contentWidth: width
            contentHeight: menuColumn.implicitHeight + 24

            ColumnLayout {
                id: menuColumn

                spacing: 12
                width: menuScroll.width - 24
                x: 12
                y: 12

                // Flyout popup, anchored to this bar's screen
                MusicPlayer {
                    id: flyout

                    Layout.fillWidth: true
                    visible: root.flyoutOpen
                }

                SettingsWidget {
                    id: volumeWidget
                    Layout.fillWidth: true
                }
            }
        }
    }
}