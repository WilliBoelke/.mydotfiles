pragma Singleton
import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Qt.labs.platform


/**
 This Service pulls the GPU utilization using nvidia-smi
 and exposes them to the UI.
 */
Singleton {
    id: gpuService

    readonly property string metricsPath: StandardPaths.writableLocation(StandardPaths.HomeLocation).toString().replace("file://", "")  + "/.local/share/quickshell/metrics/gpu.log"
    property int gpuUsage: 0
    property var history: []

    FileView {
        id: gpuLog
        path: metricsPath

    }

    //  poll the GPU stats every 2 seconds
    Timer{
        interval: 2000;
        running: true;
        repeat: true
        // reload the CPU stats
        onTriggered: {
            nvidiaSmi.running = true

            // lets write this to a file
            appendProcess.running = true
            gpuLog.reload();
            const historyLines = gpuLog.text().split("\n")
            gpuService.history = historyLines.slice(-300).map(line => {
                const parts = line.split(",")
                return {
                    timestamp: parseInt(parts[0]),
                    usage: parseInt(parts[1])
                }
            });

        }
    }


    Process {
        id: appendProcess
        command: ["bash", "-c", `echo "${Date.now()},${gpuService.gpuUsage}" >> ${metricsPath}`]
    }

    Process {
        id: nvidiaSmi
        command: ["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"]
        stdout: StdioCollector {
            onStreamFinished: {
                gpuService.gpuUsage = parseInt(text)
                nvidiaSmi.running = false
            }
        }
    }

}