import QtQuick
import qs.services

Rectangle {
    id: cardRect

    border.color:  ThemeService.active.cardBorder
    border.width: 1
    color: ThemeService.active.bgCard
    height: implicitHeight
    radius: 11
}