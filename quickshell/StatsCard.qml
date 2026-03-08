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
    property string unit: ""
    property var history: []
    property color accentColor: "#ffffff"
    property int squareSize: statsCard.width * 0.35

    implicitHeight: squareSize

    onHistoryChanged: {
        if (statsCard.visible && statsCard.width > 0)
            graphCanvas.requestPaint()
    }

    onVisibleChanged: {
        if (visible && history.length > 0)
            graphCanvas.requestPaint()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: btopProcess.running = true
        cursorShape: Qt.PointingHandCursor
    }

    ColumnLayout {
        id: contentCol
        spacing: 6
        anchors.fill: parent

        // Layout
        RowLayout {
            Layout.preferredHeight: squareSize
            Layout.fillWidth: true
            Component.onCompleted: console.log("row width:", width, "row height:", height)

            Rectangle {
                Layout.preferredWidth: squareSize
                Layout.preferredHeight: squareSize
                color: "transparent"
                Shape {
                    width: squareSize
                    height: squareSize
                    anchors.centerIn: parent
                    id : arcShape
                    ShapePath {
                        strokeWidth: 6
                        strokeColor: statsCard.accentColor
                        fillColor: "transparent"

                        PathAngleArc {
                            id: arc
                            centerX: squareSize / 2
                            centerY: squareSize / 2
                            radiusX: squareSize / 3
                            radiusY: squareSize / 3
                            startAngle: -90
                            sweepAngle: (statsCard.value / 100) * 360
                        }
                    }

                }
                Shape {
                    width: squareSize
                    height: squareSize
                    anchors.centerIn: parent
                    id : arcShapeBg
                    ShapePath {
                        strokeWidth: 6
                        strokeColor: "#1a000000"
                        fillColor: "transparent"
                        PathAngleArc {
                            id: arcbg
                            centerX: squareSize / 2
                            centerY: squareSize / 2
                            radiusX: squareSize / 3
                            radiusY: squareSize / 3
                            startAngle: -90
                            sweepAngle: 360
                        }
                    }

                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 0

                    Text {
                        text: `${statsCard.value} ${statsCard.unit}`
                        color: statsCard.accentColor
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: `${statsCard.title}`
                        color: statsCard.accentColor
                        font.pixelSize: 10
                        font.weight: Font.Bold
                        Layout.alignment: Qt.AlignHCenter
                    }
                }

            }
            Rectangle {
                color: "transparent"
                Layout.preferredHeight: squareSize
                Layout.preferredWidth: squareSize * 1.5
                anchors.margins: 12
                Canvas {
                    id: graphCanvasa
                    width: parent.width
                    height: parent.height

                    onPaint: {
                        const ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.lineWidth = 2
                        ctx.lineCap = "round"
                        ctx.lineJoin = "round"
                        ctx.shadowBlur = 5
                        ctx.shadowColor = statsCard.accentColorGr

                        // gradient from center outward
                        const gradient = ctx.createLinearGradient(0, 0, 0, height)
                        gradient.addColorStop(0, statsCard.accentColor)
                        gradient.addColorStop(0.5, "transparent")
                        gradient.addColorStop(1, statsCard.accentColor)

                        // build top and bottom paths
                        const topPoints = statsCard.history.map((item, index) => ({
                            x: width * (index / statsCard.history.length),
                            y: height / 2 - (height / 2 * (item.usage / 100))
                        }))

                        const bottomPoints = [...topPoints].reverse().map(item => ({
                            x: item.x,
                            y: height - item.y
                        }))


                        // draw filled shape
                        ctx.beginPath()
                        topPoints.forEach((p, i) => i === 0 ? ctx.moveTo(p.x, p.y) : ctx.lineTo(p.x, p.y))
                        bottomPoints.forEach(p => ctx.lineTo(p.x, p.y))
                        ctx.closePath()
                        ctx.fillStyle = gradient
                        ctx.fill()

                        // draw lines on top
                        ctx.strokeStyle = statsCard.accentColor
                        ctx.beginPath()
                        topPoints.forEach((p, i) => i === 0 ? ctx.moveTo(p.x, p.y) : ctx.lineTo(p.x, p.y))
                        ctx.stroke()

                        ctx.beginPath()
                        bottomPoints.forEach((p, i) => i === 0 ? ctx.moveTo(p.x, p.y) : ctx.lineTo(p.x, p.y))
                        ctx.stroke()
                    }
                }
            }
        }
    }

}