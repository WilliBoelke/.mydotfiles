pragma Singleton
import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Qt.labs.platform

/**
 This Service pulls the CPU stats from `proc/stat`
 and exposes them to the UI.
 */
Singleton {
    id: cpuService

    property int cpuUsage: 0
    property var history: []
    readonly property string metricsPath: StandardPaths.writableLocation(StandardPaths.HomeLocation).toString().replace("file://", "") + "/.local/share/quickshell/metrics/cpu.log"
    property int prevActive: 0
    property int prevTotal: 0

    FileView {
        id: procStats

        path: "/proc/stat"
    }
    FileView {
        id: cpuLog

        path: metricsPath
    }

    //  poll the CPU stats every 2 seconds
    Timer {
        interval: 2000
        repeat: true
        running: true

        // reload the CPU stats
        onTriggered: {
            procStats.reload();
            const line = procStats.text().split("\n")[0];
            const fields = line.trim().split(/\s+/);

            // adding up all the columns, filtering colum 0 which contains the "cpu" label.
            const thisTotal = fields.slice(1).reduce((a, b) => a + parseInt(b), 0);

            // usage calculations
            const thisIdle = parseInt(fields[4]) + parseInt(fields[5]);
            const thisActive = thisTotal - thisIdle;
            const usagePercent = (thisActive - prevActive) / (thisTotal - prevTotal) * 100;

            cpuService.cpuUsage = usagePercent.toFixed(0);
            cpuService.prevTotal = thisTotal;
            cpuService.prevActive = thisActive;

            // lets write this to a file
            appendProcess.running = true;

            // lets also now read  the last 300 lines ( which should be the last 5 minutes )
            cpuLog.reload();
            const historyLines = cpuLog.text().split("\n");
            cpuService.history = historyLines.slice(-300).map(line => {
                const parts = line.split(",");
                return {
                    timestamp: parseInt(parts[0]),
                    usage: parseInt(parts[1])
                };
            });
        }
    }
    Process {
        id: appendProcess

        command: ["bash", "-c", `echo "${Date.now()},${cpuService.cpuUsage}" >> ${metricsPath}`]
    }
}