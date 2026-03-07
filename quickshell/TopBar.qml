import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Hyprland

PanelWindow {
    id: root

    property bool sideMenuLeftOpen: false

    // Flyout open state lives here so bar and flyout share it
    property bool sideMenuRightOpen: false

    signal toggleSideLeftMenu
    signal toggleSideRightMenu

    color: "#1a000000"
    implicitHeight: 40

    anchors {
        left: true
        right: true
        top: true
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12

        // Left: music widget
        QuickSettingsWidget {

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

        // Left: music widget
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
