import QtQuick
import qs.services

Rectangle {
    id: cardRect

    border.color: mouseArea.containsMouse ? ThemeService.active.borderCardHovered : ThemeService.active.borderCard
    border.width: 1
    color: ThemeService.active.bgCard
    radius: 11

    // --- Interaction ---
    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
    }
}