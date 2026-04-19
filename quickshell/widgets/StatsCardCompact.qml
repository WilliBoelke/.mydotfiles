import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.decoratives

Card {
    id: compactStatsCard

    property color accentColor: "#ffffff"
    property var history: []
    property string unit: ""
    property int value: 0

    implicitHeight: 30
    implicitWidth: 120

    RowLayout {
        id: row

        anchors.fill: parent
        anchors.margins: 4
        spacing: 6

        Text {
            Layout.alignment: Qt.AlignVCenter
            color: "#ffaa42"
            font.pixelSize: 11
            font.weight: Font.Bold
            text: `${compactStatsCard.value}${compactStatsCard.unit}`
        }
        Canvas {
            id: miniGraph

            Layout.fillWidth: true
            height: row.height  // explicit, not Layout.fillHeight

            onHeightChanged: if (height > 0 && compactStatsCard.history.length > 1)
                requestPaint()
            onPaint: {
                const ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                const data = compactStatsCard.history;
                if (!data || data.length < 2)
                    return;

                const pad = 2;
                const toX = i => pad + (i / (data.length - 1)) * (width - 2 * pad);
                const toY = v => (height - pad) - (v / 100) * (height - 2 * pad);
                const points = data.map((item, i) => ({
                    x: toX(i),
                    y: toY(item.usage)
                }));

                // Fill under line
                const gradient = ctx.createLinearGradient(0, 0, 0, height);
                gradient.addColorStop(0, "#ffaa42");
                gradient.addColorStop(1, "transparent");

                ctx.beginPath();
                ctx.moveTo(points[0].x, points[0].y);
                points.slice(1).forEach(p => ctx.lineTo(p.x, p.y));
                ctx.lineTo(points[points.length - 1].x, height - pad);
                ctx.lineTo(points[0].x, height - pad);
                ctx.closePath();
                ctx.fillStyle = gradient;
                ctx.globalAlpha = 0.35;
                ctx.fill();

                // Line
                ctx.globalAlpha = 1.0;
                ctx.strokeStyle = "#ffaa42";
                ctx.lineWidth = 1.5;
                ctx.lineCap = "round";
                ctx.lineJoin = "round";
                ctx.beginPath();
                ctx.moveTo(points[0].x, points[0].y);
                points.slice(1).forEach(p => ctx.lineTo(p.x, p.y));
                ctx.stroke();
            }

            // Repaint whenever size or data becomes valid
            onWidthChanged: if (width > 0 && compactStatsCard.history.length > 1)
                requestPaint()

            Connections {
                function onHistoryChanged() {
                    if (miniGraph.width > 0 && miniGraph.height > 0)
                        miniGraph.requestPaint();
                }


                target: compactStatsCard
            }
        }
    }
}