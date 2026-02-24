import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts




Rectangle    {
    color: "#1a000000"
    radius: 6
    id: musicPlayer
    property int outerPadding: 12
    implicitWidth: parent.width
    implicitHeight: contentCol.implicitHeight + (outerPadding * 2)


    onVisibleChanged: {
        if (visible) {
            for (var i = 0; i < Mpris.players.values.length; i++) {
                var p = Mpris.players.values[i]
                console.log(i, p.identity, p.dbusName, p.trackTitle, p.playbackState)
            }
        }
    }


    Rectangle    {
        width: parent.width
        height: contentCol.implicitHeight + (outerPadding * 2)
        color: "transparent"

    Column {
        id: contentCol
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: outerPadding
        }
        spacing: 12

        // Header
        Text {
            text: "Now Playing"
            color: "#d55c1b"
            font.pixelSize: 24
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
                        bottom: parent.bottom
                        margins: 10
                    }
                    spacing: 6

                    // Player name + art row
                    RowLayout {
                        id : playerRow
                        width: playerCard.width
                        spacing: 10

                        Rectangle {
                            Layout.preferredWidth: 120
                            Layout.preferredHeight: 120
                            Layout.maximumWidth: 120
                            Layout.maximumHeight: 120
                            Layout.alignment: Qt.AlignVCenter
                            radius: 12

                            color: "#333"
                            layer.enabled: true

                            Image {
                                anchors.fill: parent
                                source: player.trackArtUrl ?? ""
                                fillMode: Image.PreserveAspectCrop
                                visible: source !== ""
                            }
                        }

                        Column {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                text: player.trackTitle || "Unknown title"
                                color: "#d55c1b"
                                font.pixelSize: 18
                                font.weight: Font.Bold
                                elide: Text.ElideRight
                                width: parent.width
                            }

                            Text {
                                text: player.trackArtist || ""
                                color: "#aaaaaa"
                                font.pixelSize: 16
                                elide: Text.ElideRight
                                width: parent.width
                            }
                            Text {
                                text: player.identity || player.dbusName || ""
                                color: "#666"
                                font.pixelSize: 16
                            }

                            // Controls
                            RowLayout {
                                width: parent.width

                                Item { Layout.fillWidth: true }

                                Repeater {
                                    model: [
                                        {
                                            label: "⏮",
                                            action: function() { player.previous()},
                                            size: 18,
                                            enabled: player.canGoPrevious
                                        },

                                        {
                                            label: player.isPlaying ? "⏸" : "▶",
                                            action: function() {player.togglePlaying()},
                                            enabled: player.canTogglePlaying,
                                            size: 24
                                        },
                                        {
                                            label: "⏭", action: function() { player.next() },
                                            size: 18,
                                            enabled: player.canGoNext
                                        }
                                    ]

                                    delegate: Text {
                                        required property var modelData
                                        text: modelData.label
                                        color: modelData.enabled ? "#ffffff" : "#444"
                                        font.pixelSize: modelData.size
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