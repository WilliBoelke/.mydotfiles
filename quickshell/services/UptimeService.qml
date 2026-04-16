pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Singleton
{
    id: uptimeService

    property string uptime: ""

    FileView {
        id: uptimeFile

        path: "/proc/uptime"
    }
    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            uptimeFile.reload();
            const seconds = parseFloat(uptimeFile.text().split(" ")[0]);

            const days = Math.floor(seconds / 86400);
            const hours = Math.floor((seconds % 86400) / 3600);
            const minutes = Math.floor((seconds % 3600) / 60);
            const secondsLeft = Math.floor(seconds % 60);

            uptimeService.uptime = `${days}d ${hours}h ${minutes}m ${secondsLeft}s`;
        }
    }
}