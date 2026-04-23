import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import qs.services
import Quickshell.Io

PanelWindow {
    id: funkeLauncher


    // --- position --- //

    anchors {
        bottom: true
    }

    exclusionMode: ExclusionMode.Ignore


    // --- dimensions --- //alias

    width: 600
    implicitHeight: resultApps.length > 0 ? 400 : 44

    // --- visuals --- //

    color: "transparent"


    // --- properties --- //

    property bool open: false
    property var screen


    // --- search results --- //

    property var queryString
    property var resultApps: []



    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    WlrLayershell.screen: screen

    HyprlandFocusGrab {
        id: focusGrab
        windows: [funkeLauncher]
        active: funkeLauncher.open
        onCleared: funkeLauncher.open = false
    }

    onOpenChanged: {
        if (open) {
            input.forceActiveFocus()
        } else {
            input.text = ""
            funkeLauncher.resultApps = []
        }
    }

    onQueryStringChanged: {
        if(queryString === "" || queryString === undefined) {
            resultApps = []

        }
    }

    // --- Keyboard shortcuts ---

    GlobalShortcut {
        appid: "quickshell"
        name: "toggleFunke"
        onPressed: {
            if (funkeLauncher.screen.name === Hyprland.focusedMonitor?.name) {
                funkeLauncher.open = !funkeLauncher.open
            }
        }
    }




    // --- processes --- //

    /**
     * Uses funkes fk query 'query' command to
     * search for applications and open them when the user submits a search.
     */
    Process {
        id: procFunkeAppSearch

        command: ["fk", "query", funkeLauncher.queryString]
        stdout: StdioCollector {
            onStreamFinished: {
                funkeLauncher.resultApps = JSON.parse(text)
                procFunkeAppSearch.running = false
            }
        }
    }

    Process {
        id: procFunkeAppOpen
        command: ["bash", "-c", modelData.exec.replace(/%[a-zA-Z]/g, "").trim() + " &disown"]
        stdout: StdioCollector {
            onStreamFinished: {
                procFunkeAppOpen.running = false
                funkeLauncher.open = false
            }
        }

    }



    // --- content --- //

    Column {
        anchors.fill: parent

        // --- results ---

        Rectangle {
            id: funkeResults
            property int currentIndex: undefined
            width: parent.width
            implicitHeight: parent.height - 44
            color: ThemeService.active.bgBase
            visible: open
            Column {
                width: parent.width
                height: parent.height
                Repeater {
                    id: resultRepeater
                    model: funkeLauncher.resultApps
                    delegate: Rectangle {

                        width: parent.width
                        implicitHeight: 40
                        color: index === funkeResults.currentIndex ? ThemeService.active.accent : ThemeService.active.bgBase
                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: 12
                            text: modelData.name
                            color: "#ffffff"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                procFunkeAppOpen.command = ["bash", "-c", modelData.exec.replace(/%[a-zA-Z]/g, "").trim() + " &disown"]
                                procFunkeAppOpen.running = true
                            }
                        }

                    }

                }
            }


        }


        // --- search bar ---

        Rectangle {
            width: 600
            implicitHeight: 44
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            id: funkeSearch

            // Subtle glow
            layer.enabled: true
            layer.effect: null


            Rectangle {
                width: open ? 600 : 100
                implicitHeight: 32
                anchors.centerIn: parent
                color: "transparent"
                border.color: ThemeService.active.accent
                border.width: 2
                radius: 16

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "/search"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                    color: ThemeService.active.accent
                    visible: !open
                    // center
                    horizontalAlignment: Text.AlignHCenter
                }

                TextInput {
                    id: input
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width - 40
                    color: "#ffaa42"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 15
                    selectionColor: Qt.rgba(213, 92, 27, 0.4)
                    selectedTextColor: "#ffaa42"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.fill: parent
                    onTextChanged: {
                        console.log("text changed", text)
                        if (text.length > 0) {
                            funkeLauncher.queryString = text
                            procFunkeAppSearch.running = true
                        } else if (text.length === 0) {
                            funkeLauncher.queryString = undefined
                            procFunkeAppSearch.running = false
                        }
                    }
                    visible: open

                    // -- keyboad control for navigating results -- //

                    Keys.onDownPressed: {
                        console.log("down")
                        funkeResults.currentIndex = Math.min(funkeResults.currentIndex + 1, funkeLauncher.resultApps.length - 1)
                    }
                    Keys.onUpPressed: {
                        console.log("up")
                        funkeResults.currentIndex = Math.max(funkeResults.currentIndex - 1, 0)
                    }
                    Keys.onReturnPressed: {
                        console.log("enter")
                        if (funkeResults.currentIndex !== undefined) {
                            const app = funkeLauncher.resultApps[funkeResults.currentIndex]
                            procFunkeAppOpen.command = ["bash", "-c", app.exec.replace(/%[a-zA-Z]/g, "").trim() + " &disown"]
                            procFunkeAppOpen.running = true
                        }
                    }
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 200
                    }
                }
                Behavior on border.color {
                    ColorAnimation {
                        duration: 150
                    }
                }
                Behavior on color {
                    ColorAnimation {
                        duration: 150
                    }
                }


                /*
                 Notice click for focus
                 */
                MouseArea {
                    anchors.fill: funkeSearch

                    onClicked: funkeLauncher.open = !funkeLauncher.open
                }
            }

        }
    }
}