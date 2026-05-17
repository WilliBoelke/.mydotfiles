import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import qs.services
import qs.decoratives

PanelWindow {
    id: funkeLauncher

    // --- position ---
    anchors {
        bottom: true
    }
    exclusionMode: ExclusionMode.Ignore

    // --- dimensions ---
    width: 1200
    implicitHeight: queryString ? 780 : 44
    color: "transparent"

    // --- properties ---
    property bool open: false
    property var screen
    property var queryString
    property var resultApps: []
    property var resultFiles: []
    property var resultDirs: []
    property var resultWeb: []

    // --- layer config ---
    WlrLayershell.namespace: "funke"
    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    WlrLayershell.screen: screen


    // --- helpers ---
    function cancelWebSearch() {
        webSearchDebounce.stop()
        procFunkeWebSearch.running = false
        resultWeb = []
    }


    function activeColumnLength() {
        if (funkeResults.currentY === 0) return resultFiles.length + resultDirs.length
        if (funkeResults.currentY === 1) return resultApps.length
        if (funkeResults.currentY === 2) return resultWeb.length
        return 0
    }


    function launch(command) {
        procLaunch.command = command
        procLaunch.running = true
        open = false
    }


    // --- lifecycle ---
    onOpenChanged: {
        if (open) {
            input.forceActiveFocus()
        } else {
            cancelWebSearch()
            input.text = ""
            resultApps = []
            resultFiles = []
            resultDirs = []
        }
    }

    onQueryStringChanged: {
        if (!queryString) {
            cancelWebSearch()
            resultApps = []
            resultFiles = []
            resultDirs = []
        } else {
            lineCanvas.requestPaint()
        }
    }

    // --- focus grab ---
    HyprlandFocusGrab {
        id: focusGrab
        windows: [funkeLauncher]
        active: funkeLauncher.open
        onCleared: funkeLauncher.open = false
    }

    // --- shortcuts ---
    GlobalShortcut {
        appid: "quickshell"
        name: "toggleFunke"
        onPressed: {
            if (funkeLauncher.screen.name === Hyprland.focusedMonitor?.name)
                funkeLauncher.open = !funkeLauncher.open
        }
    }

    // --- timers ---
    Timer {
        id: webSearchDebounce
        interval: 1500
        repeat: false
        onTriggered: {
            if (funkeLauncher.queryString && funkeLauncher.queryString.length > 4)
                procFunkeWebSearch.running = true
        }
    }

    // --- processes ---
    Process {
        id: procFunkeSearch
        command: ["fk", "query", funkeLauncher.queryString, "--apps", "--files", "--dirs"]
        stdout: StdioCollector {
            onStreamFinished: {
                let result = JSON.parse(text)
                funkeLauncher.resultApps = result.apps
                funkeLauncher.resultFiles = result.files
                funkeLauncher.resultDirs = result.dirs
                procFunkeSearch.running = false
            }
        }
    }

    Process {
        id: procFunkeWebSearch
        command: ["fk", "query", funkeLauncher.queryString, "--web"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    funkeLauncher.resultWeb = JSON.parse(text).web
                } catch (e) {
                    funkeLauncher.resultWeb = []
                }
                procFunkeWebSearch.running = false
            }
        }
    }

    Process {
        id: procLaunch
        stdout: StdioCollector {
            onStreamFinished: procLaunch.running = false
        }
    }

    // --- content ---
    Item {
        anchors.fill: parent

        // --- line canvas ---
        Canvas {
            id: lineCanvas
            anchors.fill: parent
            z: 4
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                return

                var r = 16
                var origin = funkeSearch.mapToItem(lineCanvas, funkeSearch.width / 2, 0)
                var appLeft = appColumn.mapToItem(lineCanvas, -16, 0)

                var p0x = origin.x, p0y = origin.y
                var horzY = p0y - 6
                var p2x = appLeft.x, p2y = horzY

                ctx.strokeStyle = ThemeService.active.accent
                ctx.lineWidth = 2
                ctx.beginPath()
                ctx.moveTo(p0x, p0y)
                ctx.lineTo(p0x, horzY + r)
                ctx.quadraticCurveTo(p0x, horzY, p0x - r, horzY)
                ctx.lineTo(p2x + r, horzY)
                ctx.quadraticCurveTo(p2x, horzY, p2x, horzY - r)
                ctx.lineTo(p2x, appLeft.y)
                ctx.stroke()
            }
        }

        // --- layout ---
        Column {
            anchors.fill: parent

            // --- results panel ---
            Rectangle {
                id: funkeResults
                property int currentX: 0
                property int currentY: 1
                width: parent.width
                implicitHeight: parent.height - 44
                color: ThemeService.active.bgBase
                visible: open

                Item {
                    anchors.fill: parent
                    anchors.margins: 16

                    Row {
                        anchors.fill: parent
                        spacing: 16

                        // --- files + dirs ---
                        Card {
                            width: (parent.width - 32) / 3
                            height: parent.height

                            Flickable {
                                anchors.fill: parent
                                anchors.margins: 12
                                clip: true
                                contentHeight: fileColumn.implicitHeight
                                contentWidth: width

                                Column {
                                    id: fileColumn
                                    width: parent.width
                                    spacing: 12
                                    property bool columnActive: funkeResults.currentY === 0

                                    Repeater {
                                        model: funkeLauncher.resultFiles
                                        delegate: FunkeFileResult {
                                            width: parent.width
                                            externalActive: index === funkeResults.currentX && fileColumn.columnActive
                                            file: modelData
                                            onLaunched: funkeLauncher.launch(["gio", "open", modelData.path])
                                        }
                                    }

                                    Repeater {
                                        model: funkeLauncher.resultDirs
                                        delegate: FunkeFileResult {
                                            width: parent.width
                                            externalActive: index === funkeResults.currentX && fileColumn.columnActive
                                            file: modelData
                                            onLaunched: funkeLauncher.launch(["gio", "open", modelData.path])
                                        }
                                    }
                                }
                            }
                        }

                        // --- apps ---
                        Card {
                            width: (parent.width - 32) / 3
                            height: parent.height

                            Flickable {
                                id: appResultsSection
                                anchors.fill: parent
                                anchors.margins: 12
                                clip: true
                                contentHeight: appColumn.implicitHeight
                                contentWidth: width

                                Column {
                                    id: appColumn
                                    width: parent.width
                                    spacing: 12
                                    property bool columnActive: funkeResults.currentY === 1

                                    Repeater {
                                        id: resultRepeater
                                        model: funkeLauncher.resultApps
                                        delegate: FunkeAppResult {
                                            width: parent.width
                                            active: index === funkeResults.currentX && appColumn.columnActive
                                            app: modelData
                                            onLaunched: funkeLauncher.launch(
                                                ["bash", "-c", modelData.exec.replace(/%[a-zA-Z]/g, "").trim() + " &disown"]
                                            )
                                        }
                                    }
                                }
                            }
                        }

                        // --- web ---
                        Card {
                            width: (parent.width - 32) / 3
                            height: parent.height

                            Flickable {
                                anchors.fill: parent
                                anchors.margins: 12
                                clip: true
                                contentHeight: webColumn.implicitHeight
                                contentWidth: width

                                Column {
                                    id: webColumn
                                    width: parent.width
                                    spacing: 12
                                    property bool columnActive: funkeResults.currentY === 2

                                    Repeater {
                                        id: resultWebRepeater
                                        model: funkeLauncher.resultWeb
                                        delegate: FunkeWebResult {
                                            width: parent.width
                                            externalActive: index === funkeResults.currentX && webColumn.columnActive
                                            result: modelData
                                            onLaunched: funkeLauncher.launch(["gio", "open", modelData.url])
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // --- search bar ---
            Rectangle {
                id: funkeSearch
                width: parent.width
                implicitHeight: 44
                color: "transparent"

                Rectangle {
                    width: open ? 600 : 100
                    implicitHeight: 32
                    anchors.centerIn: parent
                    color: "transparent"
                    border.color: ThemeService.active.accent
                    border.width: 2
                    radius: 16

                    Text {
                        anchors.centerIn: parent
                        text: "/search"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 16
                        color: ThemeService.active.accent
                        visible: !open
                    }

                    TextInput {
                        id: input
                        anchors.fill: parent
                        anchors.margins: 12
                        color: "#ffaa42"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 15
                        selectionColor: Qt.rgba(213, 92, 27, 0.4)
                        selectedTextColor: "#ffaa42"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        visible: open

                        onTextChanged: {
                            funkeResults.currentX = 0
                            if (text.length > 0) {
                                funkeLauncher.queryString = text
                                procFunkeSearch.running = true
                                if (text.length > 4) webSearchDebounce.restart()
                                else cancelWebSearch()
                            } else {
                                funkeLauncher.queryString = undefined
                                procFunkeSearch.running = false
                                cancelWebSearch()
                            }
                        }

                        Keys.onDownPressed: {
                            webSearchDebounce.stop()
                            procFunkeWebSearch.running = false
                            funkeResults.currentX = Math.min(funkeResults.currentX + 1, activeColumnLength() - 1)
                        }
                        Keys.onUpPressed: {
                            webSearchDebounce.stop()
                            procFunkeWebSearch.running = false
                            funkeResults.currentX = Math.max(funkeResults.currentX - 1, 0)
                        }
                        Keys.onTabPressed: {
                            funkeResults.currentY = (funkeResults.currentY + 1) % 3
                            funkeResults.currentX = 0
                        }
                        Keys.onReturnPressed: {
                            if (funkeResults.currentY === 0) {
                                const item = funkeLauncher.resultFiles.concat(funkeLauncher.resultDirs)[funkeResults.currentX]
                                if (item) funkeLauncher.launch(["gio", "open", item.path])
                            } else if (funkeResults.currentY === 1) {
                                const app = funkeLauncher.resultApps[funkeResults.currentX]
                                if (app) funkeLauncher.launch(["bash", "-c", app.exec.replace(/%[a-zA-Z]/g, "").replace(/\s+--\s*$/, "").trim(), "&", "disown"])
                            } else if (funkeResults.currentY === 2) {
                                const web = funkeLauncher.resultWeb[funkeResults.currentX]
                                if (web) funkeLauncher.launch(["gio", "open", web.url])
                            }
                            cancelWebSearch()  // cancel AFTER reading the result
                        }
                    }

                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                        }
                    }
                    Behavior on border
                    .
                    color {
                        ColorAnimation {
                            duration: 150
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: funkeLauncher.open = !funkeLauncher.open
                    }
                }
            }
        }
    }
}
