import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import qs.decoratives

Card {
    id: statsCard
    property color accentColor: "#ffffff"
    property var history: []
    property int squareSize: statsCard.width * 0.35
    property string title: ""
    property string unit: ""
    property int value: 0

    implicitHeight: squareSize

    onHistoryChanged: {
        if (statsCard.visible && statsCard.width > 0)
            graphCanvas.requestPaint();
    }
    onVisibleChanged: {
        if (visible && history.length > 0)
            graphCanvas.requestPaint();
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: btopProcess.running = true
    }
    ColumnLayout {
        id: contentCol

        anchors.fill: parent
        spacing: 6

        // Layout
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: squareSize

            Component.onCompleted: console.log("row width:", width, "row height:", height)

            Rectangle {
                Layout.preferredHeight: squareSize
                Layout.preferredWidth: squareSize
                color: "transparent"

                Shape {
                    id: arcShape

                    anchors.centerIn: parent
                    height: squareSize
                    width: squareSize

                    ShapePath {
                        fillColor: "transparent"
                        strokeColor: "#f9a742"
                        strokeWidth: 4

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
                    id: arcShapeBg

                    anchors.centerIn: parent
                    height: squareSize
                    width: squareSize

                    ShapePath {
                        fillColor: "transparent"
                        strokeColor: "#1a000000"
                        strokeWidth: 6

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
                        Layout.alignment: Qt.AlignHCenter
                        color: "#d55c1b"
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        text: `${statsCard.value} ${statsCard.unit}`
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        color: "#d55c1b"
                        font.pixelSize: 10
                        font.weight: Font.Bold
                        text: `${statsCard.title}`
                    }
                }
            }
            Rectangle {
                Layout.preferredHeight: squareSize
                Layout.preferredWidth: squareSize * 1.5
                anchors.margins: 12
                color: "transparent"

                Canvas {
                    id: graphCanvas

                    anchors.fill: parent
                    width: parent.width

                    onPaint: {
                        const ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);
                        ctx.lineWidth = 1;
                        ctx.lineCap = "round";
                        ctx.lineJoin = "round";

                        const window = 3;
                        // smoothing the graphs by using a 3-point moving average over all the data pointsc
                        const smoothed = statsCard.history.map((_, i, arr) => {
                            const half = Math.floor(window / 2);
                            const start = Math.max(0, i - half);
                            const end = Math.min(arr.length - 1, i + half);
                            const sum = arr.slice(start, end + 1).reduce((acc, v) => acc + v.usage, 0);
                            return sum / (end - start + 1);
                        });

                        const topPoints = smoothed.map((usage, index) => ({
                                    x: width * (index / smoothed.length),
                                    y: height / 2 - (height / 2 * (usage / 100))
                                }));

                        const bottomPoints = [...topPoints].reverse().map(item => ({
                                    x: item.x,
                                    y: height - item.y
                                }));


                        const grad = ctx.createLinearGradient(0, 0, 0, height);
                        grad.addColorStop(0,   "rgba(255, 170, 66, 0.6)");
                        grad.addColorStop(0.5, "rgba(255, 170, 66, 0.1)");
                        grad.addColorStop(1,   "rgba(255, 170, 66, 0.6)");

                        ctx.fillStyle = grad;
                        ctx.beginPath();
                        topPoints.forEach((p, i) => i === 0 ? ctx.moveTo(p.x, p.y) : ctx.lineTo(p.x, p.y));
                        bottomPoints.forEach(p => ctx.lineTo(p.x, p.y));
                        ctx.closePath();
                        ctx.fill();

                        // Top line
                        ctx.strokeStyle = "#ffaa42";
                        ctx.beginPath();
                        topPoints.forEach((p, i) => i === 0 ? ctx.moveTo(p.x, p.y) : ctx.lineTo(p.x, p.y));
                        ctx.stroke();

                        // Bottom line
                        ctx.beginPath();
                        bottomPoints.forEach((p, i) => i === 0 ? ctx.moveTo(p.x, p.y) : ctx.lineTo(p.x, p.y));
                        ctx.stroke();
                    }
                }
            }
        }
    }
}