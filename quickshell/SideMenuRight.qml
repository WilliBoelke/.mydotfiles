import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
import Quickshell.Io

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
        right: 20
        top: 20
    }
    anchors {
        bottom: true
        right: true
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

        color: "#1a000000"
        radius: 12
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

                    RowLayout {
                        Layout.fillWidth: true

                        StatsCard {
                            Layout.fillWidth: true
                            accentColor: "#52E9EB"
                            history: CpuService.history
                            title: "CPU"
                            unit: "%"
                            value: CpuService.cpuUsage
                        }
                        StatsCard {
                            Layout.fillWidth: true
                            accentColor: "#E10C05"
                            history: MemService.history
                            title: "RAM"
                            unit: "%"
                            value: MemService.memUsage
                        }
                    }
                    RowLayout {
                        Layout.fillWidth: true

                        StatsCard {
                            Layout.fillWidth: true
                            accentColor: "#DCD4DD"
                            history: NvidiaGpuService.history
                            title: "GPU"
                            unit: "%"
                            value: NvidiaGpuService.gpuUsage
                        }
                        StatsCard {
                            Layout.fillWidth: true
                            accentColor: "#d55c1b"
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
                        InfoCard {
                            Layout.fillWidth: true
                            accentColor: "#d55c1b"
                            title: "Boottime"
                            value: BootTimeService.bootTime
                        }
                    }
                    Notifications {
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
