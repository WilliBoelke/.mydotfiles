import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import qs.decoratives

Card{
    id: musicWidget

    // Pick the active player: first playing one, or just first available
    property var activePlayer: {
        for (var i = 0; i < Mpris.players.values.length; i++) {
            if (Mpris.players.values[i].isPlaying)
                return Mpris.players.values[i];
        }
        return Mpris.players.values.length > 0 ? Mpris.players.values[0] : null;
    }

    property bool sideMenuOpen: false
    signal toggleSideMenu

    implicitHeight: parent.height
    implicitWidth: row.implicitWidth + 16

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: root.toggleSideMenu()
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 24

        // Album art
        Rectangle {
            color: "transparent"
            height: 28
            radius: 4
            visible: root.activePlayer !== null
            width: 28

            Image {
                anchors.fill: parent
                anchors.margins: 0
                fillMode: Image.PreserveAspectCrop
                layer.effect: null  // rounded clipping via parent Rectangle
                layer.enabled: true
                source: root.activePlayer?.trackArtUrl ?? ""
                visible: source !== ""
            }

            // Fallback icon when no art
            Text {
                anchors.centerIn: parent
                color: "#d55c1b"
                text: "♪"
                visible: root.activePlayer?.trackArtUrl === "" || root.activePlayer?.trackArtUrl === undefined
            }
        }

        // Track info
        Column {
            spacing: .5
            visible: root.activePlayer !== null

            Text {
                color: "#C35A24"
                elide: Text.ElideRight
                font.pixelSize: 14
                font.weight: Font.Medium
                text: root.activePlayer?.trackTitle ?? "Nothing playing"
                width: Math.min(implicitWidth, 160)
            }
            Text {
                color: "#C35A24"
                elide: Text.ElideRight
                font.pixelSize: 12
                text: root.activePlayer?.trackArtist ?? ""
                width: Math.min(implicitWidth, 160)
            }
        }

        // Play/pause button
        Text {
            color: root.flyoutOpen ? "#d55c1b" : "#ffffff"
            font.pixelSize: 14
            text: root.activePlayer?.isPlaying ? "⏸" : "▶"
            visible: root.activePlayer !== null

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    mouse.accepted = true;  // prevent bubbling to toggleFlyout
                    root.activePlayer?.togglePlaying();
                }
            }
        }

        // No players fallback
        Text {
            visible: root.activePlayer === null
        }
    }
}