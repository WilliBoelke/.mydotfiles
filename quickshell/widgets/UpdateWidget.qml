import QtQuick
import QtQuick.Layouts
import qs.decoratives
import qs.services

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
                    anchors.margins: 10
                    spacing: 8

                    Text {
                        Layout.fillWidth: true
                        color: ThemeService.active.textPrimary
                        font.pixelSize: 13
                        text: modelData.package
                    }
                    Text {
                        color: ThemeService.active.textSecondary
                        font.pixelSize: 12
                        text: modelData.version
                    }
                    Text {
                        color: ThemeService.active.accent
                        font.pixelSize: 12
                        text: "→ " + modelData.newVersion
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

            // --- expand toggle ---
            InteractableCard {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredHeight: 36
                Layout.preferredWidth: 36

                onClicked: updateWidget.toggle()

                Icon {
                    anchors.centerIn: parent
                    icon: updateWidget.expanded ? "󰅀" : "󰅂"
                    size: 16
                }
            }

            // --- label ---
            Text {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                color: "#d55c1b"
                font.pixelSize: 15
                font.weight: Font.Bold
                text: UpdateService.updates.length + " updates available"
            }

            // --- refresh button ---
            InteractableCard {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredHeight: 36
                Layout.preferredWidth: 36

                onClicked: UpdateService.checkUpdates()

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