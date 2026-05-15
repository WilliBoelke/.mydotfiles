import QtQuick
import qs.services

Text {
    property color mColor: ThemeService.active.accentLight
    font.family: "Agave Nerd Font"

    color: mColor
    font.pixelSize: 14
    font.weight: Font.Bold
}
