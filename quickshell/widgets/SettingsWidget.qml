import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
import qs.controls
import QtQuick.Controls
import Quickshell.Io
import qs.decoratives

Item {
    id: root

    implicitHeight: container.implicitHeight
    implicitWidth: container.implicitWidth

    Card {
        id: container

        property int outerPadding: 12

        implicitHeight: contentCol.implicitHeight + (outerPadding * 2)
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
                RowLayout {
                    spacing: 12

                    IconButton {
                        Layout.fillWidth: true
                        active: GameModeService.enabled
                        iconText: "󰺶"
                        subtitle: "Improve performance for games"
                        title: "GameMode"

                        onClicked: {
                            gameModeProcess.running = true;
                        }
                    }
                    IconButton {
                        Layout.fillWidth: true
                        iconText: "\uf1e6"
                        subtitle: "View and manage notifications"
                        title: ""

                        onClicked: {
                            Notifications.showCenter = true;
                        }
                    }
                }
                RowLayout {
                    spacing: 12

                    IconButton {
                        Layout.fillWidth: true
                        active: GameModeService.enabled
                        iconText: "\uf011"
                        subtitle: "System shutdown"
                        title: "Shutdown"

                        onClicked: {
                            procShutdown.running = true;
                        }
                    }
                    IconButton {
                        Layout.fillWidth: true
                        iconText: "\udb81\udf09"
                        subtitle: "System reboot"
                        title: "Reboot"

                        onClicked: {
                            procReboot.running = true;
                        }
                    }
                    IconButton {
                        Layout.fillWidth: true
                        iconText: "\uf08b"
                        subtitle: "Logout user"
                        title: "Logout"

                        onClicked: {
                            procLogout.running = true;
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
    Process {
        id: procShutdown

        command: ["sh", "-c", "~/.config/hypr/scripts/power.sh shutdown"]
    }
    Process {
        id: procReboot

        command: ["sh", "-c", "~/.config/hypr/scripts/power.sh reboot"]
    }
    Process {
        id: procLogout

        command: ["sh", "-c", "~/.config/hypr/scripts/power.sh lock"]
    }
    Process {
        id: procHibernate

        command: ["sh", "-c", "~/.config/hypr/scripts/power.sh hibernate"]
    }
}
