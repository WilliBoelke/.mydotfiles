import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    implicitWidth: row.implicitWidth + 16
    implicitHeight: parent.height

    property bool flyoutOpen: false
    signal toggleFlyout()

    // Pick the active player: first playing one, or just first available
    property var activePlayer: {
        for (var i = 0; i < Mpris.players.values.length; i++) {
            if (Mpris.players.values[i].isPlaying)
                return Mpris.players.values[i]
        }
        return Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.toggleFlyout()
        cursorShape: Qt.PointingHandCursor
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 8

        // Album art
        Rectangle {
            width: 28
            height: 28
            radius: 4
            color: "transparent"
            visible: root.activePlayer !== null

            Image {
                anchors.fill: parent
                anchors.margins: 0
                source: root.activePlayer?.trackArtUrl ?? ""
                fillMode: Image.PreserveAspectCrop
                layer.enabled: true
                layer.effect: null  // rounded clipping via parent Rectangle
                visible: source !== ""
            }

            // Fallback icon when no art
            Text {
                anchors.centerIn: parent
                text: "♪"
                color: "#d55c1b"
                visible: root.activePlayer?.trackArtUrl === "" || root.activePlayer?.trackArtUrl === undefined
            }
        }

        // Track info
        Column {
            visible: root.activePlayer !== null
            spacing: 1

            Text {
                text: root.activePlayer?.trackTitle ?? "Nothing playing"
                color: "#ffffff"
                font.pixelSize: 12
                font.weight: Font.Medium
                elide: Text.ElideRight
                width: Math.min(implicitWidth, 160)
            }

            Text {
                text: root.activePlayer?.trackArtist ?? ""
                color: "#aaaaaa"
                font.pixelSize: 10
                elide: Text.ElideRight
                width: Math.min(implicitWidth, 160)
            }
        }

        // Play/pause button
        Text {
            visible: root.activePlayer !== null
            text: root.activePlayer?.isPlaying ? "⏸" : "▶"
            color: root.flyoutOpen ? "#d55c1b" : "#ffffff"
            font.pixelSize: 14

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mouse.accepted = true  // prevent bubbling to toggleFlyout
                    root.activePlayer?.togglePlaying()
                }
                cursorShape: Qt.PointingHandCursor
            }
        }

        // No players fallback
        Text {
            visible: root.activePlayer === null
        }
    }
}