import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

PopupWindow {
    id: flyout
    // These must be set by Bar.qml when it instantiates this
    property var parentBar: null


    implicitWidth: 600
    implicitHeight: contentCol.implicitHeight + 24
    color: "#aa000000"

    anchor.window: parentBar ?? null
    // Position: bottom-left of the bar, popup grows upward
    anchor.rect.x: 0
    anchor.rect.y: 0          // y=0 relative to bar = top of bar
    anchor.edges: Edges.Top   // attach popup's top edge to anchor point
    anchor.gravity: Edges.Top // popup grows upward from that point


    onVisibleChanged: {
        if (visible) {
            for (var i = 0; i < Mpris.players.values.length; i++) {
                var p = Mpris.players.values[i]
                console.log(i, p.identity, p.dbusName, p.trackTitle, p.playbackState)
            }
        }
    }



    Column {
        id: contentCol
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 12
        }
        spacing: 12

        Text {
            text: "Players"
            color: "#d55c1b"
            font.pixelSize: 11
            font.weight: Font.Bold
            topPadding: 4
        }

        // One card per player
        Repeater {
            model:  Mpris.players.values.filter(p => !p.dbusName.includes("playerctld"))

            delegate: Rectangle {
                required property var modelData
                property var player: modelData
                id : playerCard
                width: contentCol.width
                height: playerCol.implicitHeight + 16
                radius: 6
                color: player.isPlaying ? "#22d55c1b" : "#15ffffff"

                Column {
                    id: playerCol
                    anchors {
                        left: parent.left
                        right: parent.right
                        top: parent.top
                        margins: 10
                    }
                    spacing: 6

                    // Player name + art row
                    RowLayout {
                        id : playerRow
                        width: playerCard.width
                        spacing: 10

                        Rectangle {
                            Layout.preferredWidth: 56
                            Layout.preferredHeight: 56
                            Layout.maximumWidth: 56
                            Layout.maximumHeight: 56
                            Layout.alignment: Qt.AlignVCenter
                            radius: 6
                            color: "#333"
                            layer.enabled: true

                            Image {
                                anchors.fill: parent
                                source: player.trackArtUrl ?? ""
                                fillMode: Image.PreserveAspectCrop
                                visible: source !== ""
                            }

                            Text {
                                anchors.centerIn: parent
                                text: "♪"
                                color: "#d55c1b"
                                font.pixelSize: 20
                                visible: (player.trackArtUrl ?? "") === ""
                            }
                        }

                        Column {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: player.trackTitle || "Unknown title"
                                color: "#ffffff"
                                font.pixelSize: 13
                                font.weight: Font.Medium
                                elide: Text.ElideRight
                                width: parent.width
                            }
                            Text {
                                text: player.trackArtist || ""
                                color: "#aaaaaa"
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                width: parent.width
                            }
                            Text {
                                text: player.identity || player.dbusName || ""
                                color: "#666"
                                font.pixelSize: 10
                            }
                        }

                    }

                    // Controls
                    RowLayout {
                        width: parent.width

                        Item { Layout.fillWidth: true }

                        Repeater {
                            model: [
                                { label: "⏮", action: function() { player.previous() }, enabled: player.canGoPrevious },
                                { label: player.isPlaying ? "⏸" : "▶", action: function() { player.togglePlaying() }, enabled: player.canTogglePlaying },
                                { label: "⏭", action: function() { player.next() }, enabled: player.canGoNext }
                            ]

                            delegate: Text {
                                required property var modelData
                                text: modelData.label
                                color: modelData.enabled ? "#ffffff" : "#444"
                                font.pixelSize: 18
                                leftPadding: 8
                                rightPadding: 8

                                MouseArea {
                                    anchors.fill: parent
                                    enabled: modelData.enabled
                                    onClicked: modelData.action()
                                    cursorShape: Qt.PointingHandCursor
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }
                    }
                }
            }
        }

        Text {
            visible: Mpris.players.values.length === 0
            text: "No players active"
            color: "#555"
            font.pixelSize: 12
            bottomPadding: 4
        }
    }
}