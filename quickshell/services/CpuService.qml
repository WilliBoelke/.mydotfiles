pragma Singleton
import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
/**
 This Service pulls the CPU stats from `proc/stat`
 and exposes them to the UI.
 */
Singleton {
    id: cpuService

    property int cpuUsage: 0
    property int prevTotal: 0
    property int prevActive: 0

    FileView {
        id: procStats
        path: "/proc/stat"
    }

    //  poll the CPU stats every 2 seconds
    Timer{
        interval: 2000;
        running: true;
        repeat: true
        // reload the CPU stats
        onTriggered: {
            procStats.reload()
            const line = procStats.text().split("\n")[0]
            const fields = line.trim().split(/\s+/)

            // adding up all the columns, filtering colum 0 which contains the "cpu" label.
            const thisTotal = fields.slice(1).reduce((a, b) => a + parseInt(b), 0)

            // usage calculations
            const thisIdle = parseInt(fields[4]) + parseInt(fields[5]);
            const thisActive = thisTotal - thisIdle;
            const usagePercent =  (thisActive - prevActive) / (thisTotal - prevTotal) * 100

            cpuService.cpuUsage = usagePercent.toFixed(0)
            cpuService.prevTotal = thisTotal
            cpuService.prevActive = thisActive
        }


    }


}