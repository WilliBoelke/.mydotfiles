import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.widgets
import qs.consts

Rectangle {
    id: root

    property color backgroundColor: hoverArea.containsMouse ?  "#20ffffff" : "#15ffffff"
    property int cardRadius: 6
    property bool compact: false
    required property var notif
    property int padding: 12
    property bool showActions: true
    property bool showDismiss: true
    property bool showTime: true

    signal dismissRequested

    color: root.backgroundColor
    implicitHeight: contentCol.implicitHeight + (root.padding * 2)
    radius: root.cardRadius

    MouseArea {
        id: hoverArea

        anchors.fill: parent
        hoverEnabled: true  // critical — without this containsMouse never updates
    }

    ColumnLayout {
        id: contentCol
        spacing: 6

        anchors {
            left: parent.left
            margins: root.padding
            right: parent.right
            top: parent.top
        }



        // Top row: icon + title + time + dismiss
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            IconImage {
                Layout.maximumHeight: 20
                Layout.maximumWidth: 20
                Layout.preferredHeight: 20
                Layout.preferredWidth: 20
                source: Quickshell.iconPath(root.notif?.appIcon ?? "", "")
                visible: source !== ""
            }
            Text {
                Layout.fillWidth: true
                color: Colors.accent
                elide: Text.ElideRight
                font.pixelSize: 12
                font.weight: Font.Bold
                text: root.notif?.summary ?? ""
                textFormat: Text.PlainText
            }
            Text {
                color: "#555"
                font.pixelSize: 10
                text: root.notif?.time ? Qt.formatDateTime(new Date(root.notif.time * 1000), "hh:mm") : ""
                visible: root.showTime && text !== ""
            }
            Text {
                color: "#555"
                font.pixelSize: 11
                text: "✕"
                visible: root.showDismiss

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked: root.dismissRequested()
                }
            }
        }

        // Body
        Text {
            Layout.fillWidth: true
            color: "#aaaaaa"
            elide: Text.ElideRight
            font.pixelSize: 11
            maximumLineCount: root.compact ? 3 : 4
            text: root.notif?.body ?? ""
            textFormat: Text.PlainText
            visible: text !== ""
            wrapMode: Text.WordWrap
        }

        // Action buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 6
            visible: root.showActions && root.notif?.actions && root.notif.actions.length > 0

            Repeater {
                model: root.notif?.actions ?? []

                delegate: BarButton {
                    property var action: modelData
                    required property var modelData

                    label: action.text ?? ""

                    onClicked: action.invoke()
                }
            }
        }
    }
}
