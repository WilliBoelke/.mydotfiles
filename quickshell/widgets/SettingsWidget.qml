import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
import qs.controls
import QtQuick.Controls
import Quickshell.Io

Item {
    id: root

    implicitHeight: container.implicitHeight
    implicitWidth: container.implicitWidth

    Rectangle {
        id: container

        property int outerPadding: 12

        color: "#1a000000"
        implicitHeight: contentCol.implicitHeight + (outerPadding * 2)
        radius: 12
        width: parent.width

        ColumnLayout {
            id: contentCol

            anchors.margins: 12

            anchors {
                fill: parent
                margins: outerPadding
            }
            RowLayout {
                Layout.fillWidth: true

                Text {
                    color: "#d55c1b"
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    text: "Settings"
                    topPadding: 4
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 12
                VolumeWidget {
                    id: volumeWidget
                    Layout.fillWidth: true
                }
                BluetoothWidget {
                    Layout.fillWidth: true
                }
                RowLayout {
                    spacing: 12
                    IconButton {
                        Layout.fillWidth: true
                        iconText: "󰺶"
                        title: "GameMode"
                        subtitle: "Improve performance for games"
                        active: GameModeService.enabled
                        onClicked: {
                            gameModeProcess.running = true;
                        }
                    }
                    IconButton {
                        Layout.fillWidth: true
                        iconText: "\uf1e6"
                        title: ""
                        subtitle: "View and manage notifications"
                        onClicked: {
                            Notifications.showCenter = true;
                        }
                    }
                }
            }

        }
    }
    Process {
        id: gameModeProcess

        command: ["sh", "-c", "~/.config/hypr/scripts/gamemode.sh"]
    }
}
