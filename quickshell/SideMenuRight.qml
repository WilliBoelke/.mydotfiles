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

    margins {
        top: 20
        bottom: 20
        right: 20
    }

    anchors {
        top: true;
        bottom: true;
        right: true
    }



    width: root.panelWidth
    color: "transparent"
    exclusionMode: ExclusionMode.Normal
    mask: Region {
        item: root.open ? contentRect : null
    }


    // main penal boxa
    Rectangle {
        id: contentRect
        radius : 12

        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: root.open ? 0 : -root.panelWidth
        }

        width: root.panelWidth
        color: "#1a000000"

        Behavior on anchors.rightMargin {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12


            RowLayout {

                        StatsCard {
                            accentColor: "#52E9EB"
                            title: "CPU"
                            unit: "%"
                            value: CpuService.cpuUsage
                            history: CpuService.history
                            Layout.fillWidth : true
                        }

                StatsCard {
                    accentColor: "#E10C05"
                    title: "RAM"
                    unit: "%"
                    value: MemService.memUsage
                    history: MemService.history
                    Layout.fillWidth : true
                }

            }
            RowLayout {
                StatsCard {
                    accentColor: "#DCD4DD"
                    title: "GPU"
                    unit: "%"
                    value: CpuService.cpuUsage
                    history: CpuService.history
                    Layout.fillWidth : true
                }
                StatsCard {
                    accentColor: "#E5790C"
                    title: "CPU"
                    unit: "%"
                    value: CpuService.cpuUsage
                    history: CpuService.history
                    Layout.fillWidth : true
                }

            }
            Notifications {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

        }

        Process {
            id: btopProcess
            command: ["kitty", "--hold", "btop"]
        }
    }
}


