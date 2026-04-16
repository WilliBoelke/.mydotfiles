import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Hyprland
import qs.widgets
import qs.menus
import qs.services

PanelWindow {
    id: topBar

    property bool sideMenuLeftOpen: false

    // Flyout open state lives here so bar and flyout share it
    property bool sideMenuRightOpen: false

    signal toggleSideLeftMenu
    signal toggleSideRightMenu

    color: "transparent"
    implicitHeight: 44

    anchors {
        left: true
        right: true
        top: true
    }

    Rectangle {
        anchors.fill: parent
        color: ThemeService.active.bgBase

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16

            QuickSettingsWidget {
            }
            PowerStateMenu {
            }
            Item {
                Layout.fillWidth: true
            }
            WorkspacesWidget {
                Layout.alignment: Qt.AlignHCenter
                screen: root.screen
            }
            Item {
                Layout.fillWidth: true
            }
            TrayMenu {
                window: topBar
            }
            Row {
                spacing: 12

                StatsCardCompact {
                    Layout.fillWidth: true
                    accentColor: "#52E9EB"
                    history: CpuService.history
                    unit: "%"
                    value: CpuService.cpuUsage
                }
                StatsCardCompact {
                    Layout.fillWidth: true
                    accentColor: "#E10C05"
                    history: MemService.history
                    unit: "%"
                    value: MemService.memUsage
                }
                StatsCardCompact {
                    Layout.fillWidth: true
                    accentColor: "#DCD4DD"
                    history: NvidiaGpuService.history
                    unit: "%"
                    value: NvidiaGpuService.gpuUsage
                }
                StatsCardCompact {
                    Layout.fillWidth: true
                    accentColor: "#d55c1b"
                    history: CpuService.history
                    unit: "%"
                    value: CpuService.cpuUsage
                }
            }
        }
    }
}
