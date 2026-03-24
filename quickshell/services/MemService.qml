pragma Singleton
import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Qt.labs.platform

/**
 This Service pulls the Memory stats from `proc/meminfo`
 and exposes them to the UI.
 */
Singleton {
    id: memService

    property var history: []
    property int memUsage: 0
    readonly property string metricsPath: StandardPaths.writableLocation(StandardPaths.HomeLocation).toString().replace("file://", "") + "/.local/share/quickshell/metrics/mem.log"

    FileView {
        id: procMem

        path: "/proc/meminfo"
    }
    FileView {
        id: memLog

        path: metricsPath
    }

    //  poll the Mem stats every 2 seconds
    Timer {
        interval: 2000
        repeat: true
        running: true

        // reload the CPU stats
        onTriggered: {
            procMem.reload();
            const line = procMem.text().split("\n")[0];
            // We need the first 2 lines from proc/meminfo
            // MemTotal:       65751528 kB
            // MemFree:        49583892 kB
            // MemAvailable is more accurate than MemFree for "used" calculation.
            // MemFree = literally unused RAM
            // MemAvailable = free + reclaimable cache (what htop uses)
            const totalMem = parseInt(line.split(":")[1].trim().split(" ")[0]);
            const availableMem = parseInt(procMem.text().split("\n")[2].split(":")[1].trim().split(" ")[0]);

            const usedMem = totalMem - availableMem;
            const usagePercent = (usedMem / totalMem) * 100;
            memService.memUsage = usagePercent.toFixed(0);
            // lets write this to a file
            appendProcess.running = true;
            // lets also now read  the last 300 lines ( which should be the last 5 minutes )
            memLog.reload();
            const historyLines = memLog.text().split("\n");
            memService.history = historyLines.slice(-300).map(line => {
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

        command: ["bash", "-c", `echo "${Date.now()},${memService.memUsage}" >> ${metricsPath}`]
    }
}