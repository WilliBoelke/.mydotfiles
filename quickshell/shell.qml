import Quickshell
import QtQuick
import QtQuick.Layouts

ShellRoot {
    // Create one bar instance per monitor
    Variants {
        model: Quickshell.screens

        PanelWindow {
            // The screen this variant is assigned to
            property var screen: modelData
            anchors {
                bottom: true
                left: true
                right: true
            }
            implicitHeight: 40
            color: "#cc1a1a2e"  // dark, semi-transparent

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 8

                // Left: music player placeholder
                Text {
                    text: "♪ Music"
                    color: "#d55c1b"
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignVCenter
                }

                // Center spacer
                Item { Layout.fillWidth: true }

                // Right: notification placeholder
                Text {
                    text: "🔔"
                    color: "#ffffff"
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }
    }
}