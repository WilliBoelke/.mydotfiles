import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.widgets
import qs.services

PanelWindow {
    id: root

    // Track whether content should be loaded:
    // - Immediately on open
    // - Delayed unload after close animation finishes
    property bool contentLoaded: false

    // Just this binding directly
    property bool open: false
    property int panelWidth: 600

    color: "transparent"
    exclusionMode: ExclusionMode.Normal
    width: root.panelWidth

    mask: Region {
        item: root.open ? contentRect : null
    }

    onOpenChanged: {
        if (open) {
            contentLoaded = true;
        } else {
            unloadTimer.start();
        }
    }

    anchors {
        bottom: true
        left: true
        top: true
    }
    Timer {
        id: unloadTimer

        interval: 300  // slightly longer than the 250ms close animation

        onTriggered: {
            if (!root.open)
                root.contentLoaded = false;
        }
    }

    // main penal boxa
    Rectangle {
        id: contentRect
        color: ThemeService.active.bgBase
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
            active: root.contentLoaded
            anchors.fill: parent

            sourceComponent: Flickable {
                anchors.fill: parent
                clip: true
                contentHeight: menuColumn.implicitHeight + 24
                contentWidth: width

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
                    }
                    SettingsWidget {
                        id: volumeWidget

                        Layout.fillWidth: true
                    }
                    BluetoothWidget {
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}