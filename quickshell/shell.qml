import Quickshell
import QtQuick

ShellRoot {
    FloatingWindow {
        visible: true
        width: 200
        height: 100
        Text {
            anchors.centerIn: parent
            text: "Hello Quickshell!"
            color: "#d55c1b"
            font.pixelSize: 18
        }
    }
}