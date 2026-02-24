
import Quickshell
import QtQuick
import QtQuick.Layouts

import QtQuick.Shapes

Rectangle {
    id: statsCard
    color: "#1a000000"
    radius: 6

    property int value: 0
    property string title: ""
    property color accentColor: "#ffffff"
    property int squareSize: statsCard.width * 0.25

    implicitHeight: squareSize + 12 + 24

    Component.onCompleted: console.log("width:", statsCard.width, "squareSize:", squareSize)
    onWidthChanged: console.log("width changed:", width, "squareSize:", squareSize)
    ColumnLayout {
        id: contentCol
        spacing: 12
        anchors.fill: parent

        // title
        Text {
            text: statsCard.title
            color: statsCard.accentColor
            font.pixelSize: 24
            font.weight: Font.Bold
            topPadding: 4
        }

        // Layout
        RowLayout {
            Layout.preferredHeight: squareSize
            Layout.fillWidth: true

            Component.onCompleted: console.log("row width:", width, "row height:", height)
            Rectangle {
                Layout.preferredWidth: squareSize
                Layout.preferredHeight: squareSize
                color: "transparent"

                Text {
                    text: statsCard.value
                    color: statsCard.accentColor
                    font.pixelSize: 24
                    font.weight: Font.Bold
                    topPadding: 4
                }

            }
            Rectangle {
                Layout.fillWidth: true
                color: "transparent"
                Layout.preferredHeight: squareSize
            }
        }


    }
}