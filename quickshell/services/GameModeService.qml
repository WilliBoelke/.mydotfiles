pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io
import Qt.labs.platform

/**
 This servucie checks if the gamemode is enabled or no. And sets the enabled property accordingly.
 */
Singleton
{
    id: gameModeService

    property bool enabled: false

    FileView {
        id: gameModeFlag

        path: StandardPaths.writableLocation(StandardPaths.HomeLocation).toString().replace("file://", "") + "/.cache/hyprland/gamemode-enabled"
        printErrors: false
        watchChanges: true

        onFileChanged: this.reload()
        onLoadFailed: gameModeService.enabled = false
        onLoaded: gameModeService.enabled = true
    }
}