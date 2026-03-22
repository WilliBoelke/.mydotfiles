import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.widgets
import qs.services

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

    // Track whether content should be loaded:
    // - Immediately on open
    // - Delayed unload after close animation finishes
    property bool contentLoaded: false

    onOpenChanged: {
        if (open) {
            contentLoaded = true
        } else {
            unloadTimer.start()
        }
    }

    Timer {
        id: unloadTimer
        interval: 300  // slightly longer than the 250ms close animation
        onTriggered: {
            if (!root.open)
                root.contentLoaded = false
        }
    }

    // main penal boxa
    Rectangle {
        id: contentRect

        color: ThemeService.active.bgBase
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
        Loader {
            anchors.fill: parent
            active: root.contentLoaded
            sourceComponent: Flickable {
                anchors.fill: parent
                clip: true
                contentWidth: width
                contentHeight: menuColumn.implicitHeight + 24

                ColumnLayout {
                    id: menuColumn

                    spacing: 12
                    width: parent.width - 24
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
}