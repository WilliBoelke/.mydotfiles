import QtQuick
import qs.services

Text {
    property color mColor: ThemeService.active.accent
    font.family: "Agave Nerd Font"

    color: mColor
    font.pixelSize: 19
    font.weight: Font.Bold
}
