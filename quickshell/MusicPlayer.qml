import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Effects
import qs.decoratives
import qs.services
import qs.texts

Card {
    id: musicPlayer

    property int cardPadding: 6
    property int cardSpacing: 6
    property int emptyStateBottomPadding: 4
    property int headerTopPadding: 4
    property int mediaRowSpacing: 10
    property int outerPadding: 12
    property int sectionSpacing: 12

    property bool hasPlayers: Mpris.players.values.length > 0
    implicitHeight: contentCol.implicitHeight + (outerPadding * 2)

    visible: Mpris.players.values.length > 0
    onVisibleChanged: {
        if (visible) {
            for (var i = 0; i < Mpris.players.values.length; i++) {
                var p = Mpris.players.values[i];
            }
        }
    }

    Rectangle {
        color: "transparent"
        height: contentCol.implicitHeight + (outerPadding * 2)
        width: parent.width

        Column {
            id: contentCol

            spacing: sectionSpacing

            anchors {
                left: parent.left
                margins: outerPadding
                right: parent.right
                top: parent.top
            }

            // Header
            TextH1 {
                text: "Now Playing " + Mpris.players.values.length
                topPadding: headerTopPadding
            }

            // One card per player
            Repeater {
                model: Mpris.players.values.filter(p => !p.dbusName.includes("playerctld"))

                delegate: Rectangle {
                    id: playerCard

                    property color backgroundColor: hoverArea.containsMouse ? "#20ffffff" : "#15ffffff"
                    required property var modelData
                    property var player: modelData

                    color: backgroundColor
                    height: playerCol.implicitHeight + (cardPadding * 2)
                    layer.enabled: true
                    radius: 12
                    width: contentCol.width

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                        }
                    }


                    MouseArea {
                        id: hoverArea

                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                    }
                    Column {
                        id: playerCol

                        spacing: cardSpacing

                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                            margins: cardPadding
                            right: parent.right
                            top: parent.top
                        }

                        // Player name + art row
                        RowLayout {
                            id: playerRow

                            spacing: mediaRowSpacing
                            width: playerCard.width

                            ClippingRectangle {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.maximumHeight: 120
                                Layout.maximumWidth: 120
                                Layout.preferredHeight: 120
                                Layout.preferredWidth: 120
                                color: "transparent"
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
                                spacing: 6

                                RowLayout {
                                    width: parent.width

                                    TextLarge {
                                        elide: Text.ElideRight
                                        text: player.trackTitle || "Unknown title"
                                        width: parent.width
                                    }
                                }
                                TextSmall {
                                    elide: Text.ElideRight
                                    text: `${player.trackArtist} - ${player.trackAlbum}`
                                    width: parent.width
                                }

                                // --- spacing ---
                                Item {
                                    width: parent.width
                                    height: 12
                                }

                                // Controls
                                RowLayout {
                                    width: parent.width
                                    spacing: 0

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    Rectangle {
                                        id: previous
                                        Layout.preferredWidth: 40
                                        Layout.preferredHeight: 40
                                        Layout.alignment: Qt.AlignVCenter
                                        color: "transparent"
                                        opacity: player.canGoPrevious ? 1.0 : 0.3

                                        Icon {
                                            anchors.centerIn: parent
                                            icon: "⏮"
                                            size: 24
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            enabled: player.canGoPrevious
                                            onClicked: player.previous()
                                        }
                                    }

                                    Item {
                                        Layout.preferredWidth: 8
                                    }

                                    Rectangle {
                                        id: playPause
                                        Layout.preferredWidth: 40
                                        Layout.preferredHeight: 40
                                        Layout.alignment: Qt.AlignVCenter
                                        color: "transparent"
                                        opacity: player.canTogglePlaying ? 1.0 : 0.3

                                        Icon {
                                            anchors.centerIn: parent
                                            icon: player.isPlaying ? "⏸" : "▶"
                                            size: 32
                                        }

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            enabled: player.canTogglePlaying
                                            onClicked: player.togglePlaying()
                                        }
                                    }

                                    Item {
                                        Layout.preferredWidth: 8
                                    }

                                    Rectangle {
                                        id: next
                                        Layout.preferredWidth: 40
                                        Layout.preferredHeight: 40
                                        Layout.alignment: Qt.AlignVCenter
                                        color: "transparent"
                                        opacity: player.canGoNext ? 1.0 : 0.3

                                        Icon {
                                            anchors.centerIn: parent
                                            icon: "⏭"
                                            size: 24
                                        }
                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            enabled: player.canGoNext
                                            onClicked: player.next()
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
    }
}