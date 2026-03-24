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
    implicitHeight: 40

    anchors {
        left: true
        right: true
        top: true
    }
    margins {
        bottom: 0
        left: 20
        right: 20
        top: 6
    }
    Rectangle {
        anchors.fill: parent
        color: ThemeService.active.bgBase
        radius: 12

        RowLayout {
            anchors.fill: parent
            anchors.margins: 12

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
            }
            Row {
                spacing: 12

                BarButton {
                    accentColor: "#d55c1b"
                    icon: "audio-volume-high"
                    label: "100%"

                    onClicked: console.log("volume clicked")
                }
            }
        }
    }
}
