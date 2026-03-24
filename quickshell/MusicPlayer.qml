import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Effects
import qs.decoratives

Card {
    id: musicPlayer

    property int cardPadding: 6
    property int cardSpacing: 6
    property int emptyStateBottomPadding: 4
    property int headerTopPadding: 4
    property int mediaRowSpacing: 10
    property int outerPadding: 12
    property int sectionSpacing: 12

    implicitHeight: contentCol.implicitHeight + (outerPadding * 2)
    implicitWidth: parent.width
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
            Text {
                color: "#d55c1b"
                font.pixelSize: 20
                font.weight: Font.Bold
                text: "Now Playing"
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
                    layer.effect: MultiEffect {
                        shadowBlur: 1
                        shadowColor: "#80000000"
                        shadowEnabled: true
                        shadowHorizontalOffset: 0
                        shadowVerticalOffset: 4
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
                                                size: 24,
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
                                                size: 24,
                                                enabled: player.canGoNext
                                            }
                                        ]

                                        delegate: Text {
                                            required property var modelData

                                            font.family: "JetBrainsMono Nerd Font"
                                            font.pixelSize: modelData.size
                                            font.weight: Font.Bold
                                            leftPadding: 12
                                            rightPadding: 12
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
    }
}