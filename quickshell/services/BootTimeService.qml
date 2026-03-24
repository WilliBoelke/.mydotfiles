pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: bootTimeService

    property string bootTime: ""

    FileView {
        id: procStat

        path: "/proc/stat"
    }
    Timer {
        interval: 60000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            procStat.reload();
            const lines = procStat.text().split("\n");
            const btimeLine = lines.find(l => l.startsWith("btime"));
            if (btimeLine) {
                const timestamp = parseInt(btimeLine.split(" ")[1]);
                const date = new Date(timestamp * 1000);
                bootTimeService.bootTime = date.toLocaleString(Qt.locale(), "dd.MM.yyyy HH:mm");
            }
        }
    }
}