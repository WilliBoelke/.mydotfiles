import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Hyprland

Row {
    id: workspaceWidget

    property int monitorIndex: Quickshell.screens.indexOf(screen)
    required property var screen
    property int wsOffset: monitorIndex * 5

    Layout.alignment: Qt.AlignCenter
    height: 50
    spacing: 10


    /**
     * Repeater over the workspaces. this filters workspaces per monitor,
     * so each monitor only shows workspaces from itself
     */
    Repeater {
        model: 5 // num of workspaces
        delegate: Rectangle {
            property bool isActive: workspace !== undefined && workspace !== null && workspace.monitor?.activeWorkspace?.id === wsId
            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === wsId)
            property int wsId: wsOffset + index + 1

            /**
             * Those indices appear to change. i hardcode it "for now" but its really not nice
             */
            property int wsOffset: {
                if (screen.name === "DP-1")
                    return 0;
                if (screen.name === "DP-2")
                    return 5;
                if (screen.name === "DP-3")
                    return 10;
                return 0;
            }

            color: isActive ? "#d55c1b" : "#381807"
            height: 18
            radius: 12.5
            width: isActive ? 36 : 18
            // add glow / shadow when active


            Behavior on width {
                NumberAnimation {
                    duration: 200

                }
            }
            Behavior on color {
                ColorAnimation {
                    duration: 200
                }
            }


            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: Hyprland.dispatch("workspace " + wsId)
            }
        }
    }
}
