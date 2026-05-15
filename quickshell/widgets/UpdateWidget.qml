import QtQuick
import QtQuick.Layouts
import qs.decoratives
import qs.services
import qs.texts

CollapsibleCard {
    id: updateWidget

    Layout.fillWidth: true
    expanded: false
    maxHeight: 200

    body: ColumnLayout {
        spacing: 4
        width: parent.width
        Repeater {
            model: UpdateService.updates

            delegate: InteractableCard {
                Layout.fillWidth: true
                Layout.preferredHeight: 48

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    Text {
                        Layout.fillWidth: true
                        color: ThemeService.active.accent
                        font.weight: Font.Bold
                        font.pixelSize: 14
                        text: modelData.package
                    }
                    Text {
                        color: ThemeService.active.accentLight
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        text: modelData.version
                    }
                    Text {
                        color: ThemeService.active.accentLight
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        text: "→"
                    }
                    Text {
                        color: ThemeService.active.action
                        font.pixelSize: 14
                        font.weight: Font.Bold
                        text: modelData.newVersion
                    }
                }
            }
        }
    }

    header: Item {
        width: parent.width
        implicitHeight: 48

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 4
            anchors.rightMargin: 4
            spacing: 10


            // --- label ---
            TextH1 {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                text: UpdateService.updates.length + " updates available"
            }

            // --- refresh button ---
            InteractableCard {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredHeight: 36
                Layout.preferredWidth: 36

                onClicked: {
                    updateWidget.toggle()
                    UpdateService.checkUpdates()
                }


                Icon {
                    anchors.centerIn: parent
                    icon: "󰚰"
                    size: 16
                }
            }
        }
    }

    Timer {
        interval: 0
        repeat: false
        running: true

        onTriggered: UpdateService.checkUpdates()
    }
}