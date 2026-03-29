pragma Singleton
import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Qt.labs.platform

Singleton {
    id: updateService

    property var updates: []

    function checkUpdates() {
        checUpdateProcess.running = true;
    }

    Process {
        id: checUpdateProcess

        command: ["bash", "-c", `checkupdates`]

        stdout: StdioCollector {
            id: stdoutCollector
            onStreamFinished:  {

                const result = [];

                const lines = stdoutCollector.text.split("\n");
                lines.forEach(line => {

                    line = line.trim();
                    if (line.length === 0) return;

                    const lnArr = line.split(" ");
                    result.push({
                        package: lnArr[0],
                        version: lnArr[1],
                        newVersion: lnArr[3]
                    });
                });
                console.log(result);
                updateService.updates = result;
            }
        }
    }
}