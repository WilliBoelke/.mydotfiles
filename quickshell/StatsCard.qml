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
                        strokeColor: statsCard.accentColor
                        strokeWidth: 6

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
                        color: statsCard.accentColor
                        font.pixelSize: 20
                        font.weight: Font.Bold
                        text: `${statsCard.value} ${statsCard.unit}`
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        color: statsCard.accentColor
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

                    height: parent.height
                    width: parent.width

                    onPaint: {
                        const ctx = getContext("2d");
                        ctx.clearRect(0, 0, width, height);
                        ctx.lineWidth = 2;
                        ctx.lineCap = "round";
                        ctx.lineJoin = "round";

                        // Extract RGB from Qt color for alpha-aware gradient
                        const c = statsCard.accentColor;
                        const rgb = `${Math.round(c.r * 255)}, ${Math.round(c.g * 255)}, ${Math.round(c.b * 255)}`;

                        const topPoints = statsCard.history.map((item, index) => ({
                                    x: width * (index / statsCard.history.length),
                                    y: height / 2 - (height / 2 * (item.usage / 100))
                                }));

                        const bottomPoints = [...topPoints].reverse().map(item => ({
                                    x: item.x,
                                    y: height - item.y
                                }));

                        // Gradient: transparent at top/bottom edges, accent at vertical center
                        const gradient = ctx.createLinearGradient(0, 0, 0, height);
                        gradient.addColorStop(0, `rgba(${rgb}, 0)`);
                        gradient.addColorStop(0.5, `rgba(${rgb}, 0.35)`);
                        gradient.addColorStop(1, `rgba(${rgb}, 0)`);

                        // Filled lens between the two lines
                        ctx.beginPath();
                        topPoints.forEach((p, i) => i === 0 ? ctx.moveTo(p.x, p.y) : ctx.lineTo(p.x, p.y));
                        bottomPoints.forEach(p => ctx.lineTo(p.x, p.y));
                        ctx.closePath();
                        ctx.fillStyle = gradient;
                        ctx.fill();

                        // Top line
                        ctx.strokeStyle = `rgba(${rgb}, 1)`;
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