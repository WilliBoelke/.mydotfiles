import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services

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
            spacing: 12

            anchors {
                fill: parent
                margins: outerPadding
            }
            RowLayout {
                width: parent.width

                Text {
                    color: "#d55c1b"
                    font.pixelSize: 20
                    font.weight: Font.Bold
                    text: "Settings"
                    topPadding: 4
                }
            }

            ColumnLayout {
                VolumeWidget {
                    id: volumeWidget
                    Layout.fillWidth: true
                }
            }

        }
    }
}
