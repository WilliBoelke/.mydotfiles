pragma Singleton
import Quickshell
import QtQuick
import qs.themes
import qs.services

Singleton
{
    id: themeService

    property QtObject active: GameModeService.enabled ? gameModeTheme : defaultTheme

    ThemeDefault {
        id: defaultTheme

    }
    ThemeGameMode {
        id: gameModeTheme

    }
}