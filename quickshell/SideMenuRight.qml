import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
import qs.widgets
import Quickshell.Io

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
        right: true
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

        Behavior on anchors.rightMargin {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        anchors {
            bottom: parent.bottom
            right: parent.right
            rightMargin: root.open ? 0 : -root.panelWidth
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

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        StatsCard {
                            Layout.fillWidth: true
                            history: CpuService.history
                            title: "CPU"
                            unit: "%"
                            value: CpuService.cpuUsage
                        }
                        StatsCard {
                            Layout.fillWidth: true
                            history: MemService.history
                            title: "RAM"
                            unit: "%"
                            value: MemService.memUsage
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        StatsCard {
                            Layout.fillWidth: true
                            history: NvidiaGpuService.history
                            title: "GPU"
                            unit: "%"
                            value: NvidiaGpuService.gpuUsage
                        }
                        StatsCard {
                            Layout.fillWidth: true
                            history: CpuService.history
                            title: "CPU"
                            unit: "%"
                            value: CpuService.cpuUsage
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        InfoCard {
                            Layout.fillWidth: true
                            accentColor: "#d55c1b"
                            title: "Uptime"
                            value: UptimeService.uptime
                        }
                    }
                    Notifications {
                        Layout.fillWidth: true
                    }
                    UpdateWidget {
                        Layout.fillWidth: true
                    }
                }
            }
        }
        Process {
            id: btopProcess

            command: ["kitty", "--hold", "btop"]
        }
    }
}
