import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import qs.services
import qs.decoratives
import Quickshell.Widgets
import QtQuick.Effects

PanelWindow {
    id: funkeLauncher

    // --- position ---
    anchors {
        bottom: true
    }
    exclusionMode: ExclusionMode.Ignore

    // --- dimensions ---
    width: 1200
    implicitHeight: (queryString) ? 780 : 44

    // --- visuals ---
    color: "transparent"

    // --- properties ---
    property bool open: false
    property var screenresultsWeb
    property var queryString
    property var resultApps: []
    property var resultFiles: []
    property var resultDirs: []
    property var resultWeb: []

    function cancelWebSearch() {
        webSearchDebounce.stop()
        procFunkeWebSearch.running = false
        resultWeb = []
    }

    WlrLayershell.namespace: "funke"
    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    WlrLayershell.screen: screen

    // --- focus grab ---
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
            cancelWebSearch()
            input.text = ""
            resultApps = []
            resultFiles = []
            resultDirs = []
        }
    }

    onQueryStringChanged: {
        if (queryString === "" || queryString === undefined) {
            cancelWebSearch()
            resultApps = []
            resultFiles = []
            resultDirs = []
        } else {
            lineCanvas.requestPaint()
        }
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

    // --- processes ---

    Timer {
        id: webSearchDebounce
        interval: 1500
        repeat: false
        onTriggered: {
            procFunkeWebSearch.running = false
            procFunkeWebSearch.running = true
        }
    }

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
                console.log("web search finished", text)
                let result = JSON.parse(text)

                funkeLauncher.resultWeb = result.web
                procFunkeWebSearch.running = false
            }
        }
    }

    Process {
        id: procFunkeAppOpen
        stdout: StdioCollector {
            onStreamFinished: {
                procFunkeAppOpen.running = false
                procFunkeAppOpen.command = []
                funkeLauncher.open = false
            }
        }
    }

    // --- content ---

    Item {
        anchors.fill: parent

        // canvas layer — fills everything, no layout impact
        Canvas {
            id: lineCanvas
            anchors.fill: parent
            z: 4
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                return;
                var r = 16

                // p0: search bar top-center (start)
                var origin  = funkeSearch.mapToItem(lineCanvas, funkeSearch.width/2, 0)
                // appLeft.x: x of the vertical line along the app column; appLeft.y: top of app column (end)
                var appLeft = appColumn.mapToItem(lineCanvas, -16, 0)

                var p0x = origin.x,   p0y = origin.y        // start: search bar
                var horzY = p0y - 6                         // y of horizontal segment
                var p1x = p0x,        p1y = horzY           // corner 1: up → left
                var p2x = appLeft.x,  p2y = horzY           // corner 2: left → up
                var p3x = appLeft.x,  p3y = appLeft.y       // end: top of app column

                ctx.strokeStyle = ThemeService.active.accent
                ctx.lineWidth = 2
                ctx.beginPath()
                ctx.moveTo(p0x, p0y)
                ctx.lineTo(p1x, p1y + r)                          // straight up, stop before corner 1
                ctx.quadraticCurveTo(p1x, p1y, p1x - r, p1y)     // round corner 1
                ctx.lineTo(p2x + r, p2y)                          // straight left, stop before corner 2
                ctx.quadraticCurveTo(p2x, p2y, p2x, p2y - r)     // round corner 2
                ctx.lineTo(p3x, p3y)                               // straight up to end
                ctx.stroke()
            }
        }

        Column {
            anchors.fill: parent
            // --- results panel ---
            Rectangle {
                id: funkeResults
                property int currentIndex: -1
                width: parent.width
                implicitHeight: parent.height - 44
                color: ThemeService.active.bgBase
                visible: open

                // outer padding
                Item {
                    anchors.fill: parent
                    anchors.margins: 16

                    Row {
                        anchors.fill: parent
                        spacing: 16

                        // --- left column: files + dirs ---
                        Column {
                            width: (parent.width - 32) / 3  // 32 = 2 gaps of 16
                            height: parent.height
                            spacing: 12

                            // Files
                            Card {
                                width: parent.width
                                height: (parent.height - 12) / 2  // 12 = gap between cards

                                Flickable {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    clip: true
                                    contentHeight: fileColumn.implicitHeight
                                    contentWidth: width

                                    Column {
                                        id: fileColumn
                                        width: parent.width
                                        spacing: 8


                                        Repeater {
                                            model: funkeLauncher.resultFiles
                                            delegate: InteractableCard {
                                                neutral: true
                                                width: parent.width
                                                implicitHeight: 48
                                                Column {
                                                    anchors.fill: parent
                                                    anchors.margins: 8
                                                    spacing: 4
                                                    Text {
                                                        text: modelData.name
                                                        color: "#faa42F"
                                                        font.family: "JetBrainsMono Nerd Font"
                                                        font.pixelSize: 13
                                                        font.weight: Font.Bold
                                                        elide: Text.ElideRight
                                                        width: parent.width - 12
                                                    }
                                                    Text {
                                                        text: modelData.path
                                                        color: ThemeService.active.accent
                                                        font.family: "JetBrainsMono Nerd Font"
                                                        font.pixelSize: 10
                                                        elide: Text.ElideLeft
                                                        width: parent.width
                                                        wrapMode: Text.WordWrap
                                                    }
                                                }
                                                MouseArea {
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        procFunkeAppOpen.command = ["xdg-open", modelData.path, "&", "disown"]
                                                        procFunkeAppOpen.running = true
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            // Dirs
                            Card {
                                width: parent.width
                                height: (parent.height - 12) / 2

                                Flickable {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    clip: true
                                    contentHeight: dirColumn.implicitHeight
                                    contentWidth: width

                                    Column {
                                        id: dirColumn
                                        width: parent.width
                                        spacing: 8


                                        Repeater {
                                            model: funkeLauncher.resultDirs
                                            delegate: InteractableCard {
                                                neutral: true
                                                width: parent.width
                                                implicitHeight: 48
                                                Column {
                                                    anchors.fill: parent
                                                    anchors.margins: 8
                                                    spacing: 2
                                                    Text {
                                                        text: modelData.name
                                                        color: ThemeService.active.accent
                                                        font.family: "JetBrainsMono Nerd Font"
                                                        font.pixelSize: 13
                                                        font.weight: Font.Bold
                                                        elide: Text.ElideRight
                                                        width: parent.width
                                                    }
                                                    Text {
                                                        text: modelData.path
                                                        color: "#faa42F"
                                                        font.family: "JetBrainsMono Nerd Font"
                                                        font.pixelSize: 10
                                                        elide: Text.ElideLeft
                                                        width: parent.width
                                                    }
                                                }
                                                MouseArea {
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        procFunkeAppOpen.command = ["xdg-open", modelData.path]
                                                        procFunkeAppOpen.running = true
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        // --- center column: apps ---
                        Card {
                            width: (parent.width - 32) / 3
                            height: parent.height


                            Flickable {
                                anchors.fill: parent
                                anchors.margins: 12
                                clip: true
                                contentHeight: appColumn.implicitHeight
                                contentWidth: width
                                id: appResultsSection
                                Column {
                                    id: appColumn
                                    width: parent.width
                                    spacing: 12

                                    Repeater {
                                        id: resultRepeater
                                        model: funkeLauncher.resultApps
                                        delegate: InteractableCard {
                                            width: parent.width
                                            active: index === funkeResults.currentIndex
                                            implicitHeight: appContentRow.implicitHeight + 24

                                            Row {
                                                id: appContentRow
                                                anchors.fill: parent
                                                anchors.margins: 12
                                                spacing: 12

                                                Item {
                                                    width: 32
                                                    height: 32
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    IconImage {
                                                        anchors.fill: parent
                                                        source: "image://icon/" + modelData.icon
                                                        layer.enabled: true
                                                        layer.effect: MultiEffect {
                                                            colorization: 0.7
                                                            colorizationColor: ThemeService.active.accent
                                                        }
                                                    }
                                                }

                                                Column {
                                                    anchors.verticalCenter: parent.verticalCenter
                                                    spacing: 2
                                                    Text {
                                                        text: modelData.name
                                                        color: ThemeService.active.accent
                                                        font.family: "JetBrainsMono Nerd Font"
                                                        font.pixelSize: 16
                                                        font.weight: Font.ExtraBold
                                                    }
                                                    Text {
                                                        text: modelData.comment
                                                        color: "#faa42F"
                                                        font.family: "JetBrainsMono Nerd Font"
                                                        font.pixelSize: 12
                                                    }
                                                }
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
                        }

                        // --- right column: web placeholder ---
                        Card {
                            width: (parent.width - 32) / 3
                            height: parent.height

                            Flickable {
                                anchors.fill: parent
                                anchors.margins: 12
                                clip: true
                                contentHeight: appColumn.implicitHeight
                                contentWidth: width

                                Column {
                                    id: webColumn
                                    width: parent.width
                                    spacing: 12

                                    Repeater {
                                        id: resultWebRepeater
                                        model: funkeLauncher.resultWeb
                                        delegate: InteractableCard {
                                            neutral: true
                                            width: parent.width
                                            active: index === funkeResults.currentIndex
                                            implicitHeight: webContentRow.implicitHeight + 24

                                            Column {
                                                id: webContentRow
                                                anchors.fill: parent
                                                anchors.margins: 12
                                                spacing: 4

                                                Text {
                                                    text: modelData.title
                                                    width: parent.width
                                                    color: ThemeService.active.accent
                                                    font.family: "JetBrainsMono Nerd Font"
                                                    font.pixelSize: 15
                                                    font.weight: Font.ExtraBold
                                                    wrapMode: Text.WordWrap
                                                }
                                                Text {
                                                    text: modelData.snippet
                                                    width: parent.width
                                                    color: "#faa42F"
                                                    font.family: "JetBrainsMono Nerd Font"
                                                    font.pixelSize: 11
                                                    wrapMode: Text.WordWrap
                                                }
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
                        verticalAlignment: Text.AlignVCenter
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
                            if (text.length > 0) {
                                funkeLauncher.queryString = text
                                procFunkeSearch.running = true
                            } else {
                                funkeLauncher.queryString = undefined
                                procFunkeSearch.running = false
                            }
                            if (text.length > 4) {
                                webSearchDebounce.restart()
                            } else {
                                funkeLauncher.cancelWebSearch()
                            }
                        }

                        Keys.onDownPressed: {
                            funkeResults.currentIndex = Math.min(funkeResults.currentIndex + 1, funkeLauncher.resultApps.length - 1)
                            webSearchDebounce.restart()
                        }
                        Keys.onUpPressed: {
                            funkeResults.currentIndex = Math.max(funkeResults.currentIndex - 1, 0)
                            webSearchDebounce.restart()
                        }
                        Keys.onReturnPressed: {
                            funkeLauncher.cancelWebSearch()
                            if (funkeResults.currentIndex >= 0) {
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

                    MouseArea {
                        anchors.fill: parent
                        onClicked: funkeLauncher.open = !funkeLauncher.open
                    }
                }
            }
        }
    }
}