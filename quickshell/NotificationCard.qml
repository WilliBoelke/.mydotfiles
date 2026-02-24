import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts


Rectangle {
    id: root

    required property var notif
    property bool showDismiss: true
    property bool showTime: true
    property bool showActions: true
    property bool compact: false
    property int padding: 12
    property color backgroundColor: "#15ffffff"
    property int cardRadius: 6

    signal dismissRequested()

    radius: root.cardRadius
    color: root.backgroundColor
    implicitHeight: contentCol.implicitHeight + (root.padding * 2)

    ColumnLayout {
        id: contentCol
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: root.padding
        }
        spacing: 6

        // Top row: icon + title + time + dismiss
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            IconImage {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                Layout.maximumWidth: 20
                Layout.maximumHeight: 20
                source: Quickshell.iconPath(root.notif?.appIcon ?? "", "")
                visible: source !== ""
            }

            Text {
                Layout.fillWidth: true
                text: root.notif?.summary ?? ""
                color: "#ffffff"
                font.pixelSize: 12
                font.weight: Font.Medium
                elide: Text.ElideRight
                textFormat: Text.PlainText
            }

            Text {
                text: root.notif?.time
                    ? Qt.formatDateTime(new Date(root.notif.time * 1000), "hh:mm")
                    : ""
                color: "#555"
                font.pixelSize: 10
                visible: root.showTime && text !== ""
            }

            Text {
                text: "✕"
                color: "#555"
                font.pixelSize: 11
                visible: root.showDismiss

                MouseArea {
                    anchors.fill: parent
                    onClicked: root.dismissRequested()
                    cursorShape: Qt.PointingHandCursor
                }
            }
        }

        // Body
        Text {
            Layout.fillWidth: true
            text: root.notif?.body ?? ""
            color: "#aaaaaa"
            font.pixelSize: 11
            wrapMode: Text.WordWrap
            maximumLineCount: root.compact ? 3 : 4
            elide: Text.ElideRight
            textFormat: Text.PlainText
            visible: text !== ""
        }

        // Action buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: root.showActions && root.notif?.actions && root.notif.actions.length > 0

            Repeater {
                model: root.notif?.actions ?? []

                delegate: Rectangle {
                    required property var modelData
                    property var action: modelData

                    height: 24
                    implicitWidth: actionLabel.implicitWidth + 16
                    radius: 4
                    color: "#22d55c1b"

                    Text {
                        id: actionLabel
                        anchors.centerIn: parent
                        text: action.text ?? ""
                        color: "#d55c1b"
                        font.pixelSize: 11
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: action.invoke()
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }
}
