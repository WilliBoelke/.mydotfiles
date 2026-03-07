import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: musicPlayer
    visible: Mpris.players.values.length > 0
    property int outerPadding: 12

    color: "#1a000000"
    implicitHeight: contentCol.implicitHeight + (outerPadding * 2)
    implicitWidth: parent.width
    radius: 6

    onVisibleChanged: {
        if (visible) {
            for (var i = 0; i < Mpris.players.values.length; i++) {
                var p = Mpris.players.values[i];
                console.log(i, p.identity, p.dbusName, p.trackTitle, p.playbackState);
            }
        }
    }

    Rectangle {
        color: "transparent"
        height: contentCol.implicitHeight + (outerPadding * 2)
        width: parent.width

        Column {
            id: contentCol

            spacing: 12

            anchors {
                left: parent.left
                margins: outerPadding
                right: parent.right
                top: parent.top
            }

            // Header
            Text {
                color: "#d55c1b"
                font.pixelSize: 20
                font.weight: Font.Bold
                text: "Now Playing"
                topPadding: 4
            }

            // One card per player
            Repeater {
                model: Mpris.players.values.filter(p => !p.dbusName.includes("playerctld"))

                delegate: Rectangle {
                    id: playerCard

                    required property var modelData
                    property var player: modelData

                    color: player.isPlaying ? "#22d55c1b" : "#15ffffff"
                    height: playerCol.implicitHeight + 16
                    radius: 6
                    width: contentCol.width

                    Column {
                        id: playerCol

                        spacing: 6

                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                            margins: 10
                            right: parent.right
                            top: parent.top
                        }

                        // Player name + art row
                        RowLayout {
                            id: playerRow

                            spacing: 10
                            width: playerCard.width

                            Rectangle {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.maximumHeight: 120
                                Layout.maximumWidth: 120
                                Layout.preferredHeight: 120
                                Layout.preferredWidth: 120
                                color: "#333"
                                layer.enabled: true
                                radius: 12

                                Image {
                                    anchors.fill: parent
                                    fillMode: Image.PreserveAspectCrop
                                    source: player.trackArtUrl ?? ""
                                    visible: source !== ""
                                }
                            }
                            Column {
                                Layout.fillWidth: true
                                spacing: 2

                                Text {
                                    color: "#d55c1b"
                                    elide: Text.ElideRight
                                    font.pixelSize: 18
                                    font.weight: Font.Bold
                                    text: player.trackTitle || "Unknown title"
                                    width: parent.width
                                }
                                Text {
                                    color: "#aaaaaa"
                                    elide: Text.ElideRight
                                    font.pixelSize: 16
                                    text: player.trackArtist || ""
                                    width: parent.width
                                }
                                Text {
                                    color: "#666"
                                    font.pixelSize: 16
                                    text: player.identity || player.dbusName || ""
                                }

                                // Controls
                                RowLayout {
                                    width: parent.width

                                    Item {
                                        Layout.fillWidth: true
                                    }
                                    Repeater {
                                        model: [
                                            {
                                                label: "⏮",
                                                action: function () {
                                                    player.previous();
                                                },
                                                size: 18,
                                                enabled: player.canGoPrevious
                                            },
                                            {
                                                label: player.isPlaying ? "⏸" : "▶",
                                                action: function () {
                                                    player.togglePlaying();
                                                },
                                                enabled: player.canTogglePlaying,
                                                size: 24
                                            },
                                            {
                                                label: "⏭",
                                                action: function () {
                                                    player.next();
                                                },
                                                size: 18,
                                                enabled: player.canGoNext
                                            }
                                        ]

                                        delegate: Text {
                                            required property var modelData

                                            color: modelData.enabled ? "#ffffff" : "#444"
                                            font.pixelSize: modelData.size
                                            leftPadding: 8
                                            rightPadding: 8
                                            text: modelData.label

                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                enabled: modelData.enabled

                                                onClicked: modelData.action()
                                            }
                                        }
                                    }
                                    Item {
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        Text {
            bottomPadding: 4
            color: "#555"
            font.pixelSize: 12
            text: "No players active"
            visible: Mpris.players.values.length === 0
        }
    }
}