import QtQuick
import qs.services

Rectangle {
    id: cardRect

    border.color: mouseArea.containsMouse ? ThemeService.active.cardBorderHover : ThemeService.active.cardBorder
    border.width: 1
    color: ThemeService.active.bgCard
    height: implicitHeight
    radius: 11

    // --- Interaction ---
    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
    }
}