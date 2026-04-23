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

        signal
    toggleSideLeftMenu
        signal
    toggleSideRightMenu

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
                    history: CpuService.history
                    unit: "%"
                    value: CpuService.cpuUsage
                }
                StatsCardCompact {
                    Layout.fillWidth: true
                    history: MemService.history
                    unit: "%"
                    value: MemService.memUsage
                }
                StatsCardCompact {
                    Layout.fillWidth: true
                    history: NvidiaGpuService.history
                    unit: "%"
                    value: NvidiaGpuService.gpuUsage
                }
                StatsCardCompact {
                    Layout.fillWidth: true
                    history: CpuService.history
                    unit: "%"
                    value: CpuService.cpuUsage
                }
            }
        }
    }
}
