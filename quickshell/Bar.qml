import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris


PanelWindow {
    id: root
    color: "#2ecc1a1a"
    anchors { bottom: true; left: true; right: true }
    implicitHeight: 40

    // Flyout open state lives here so bar and flyout share it
    property bool flyoutOpen: false

    RowLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 0

        // Left: music widget
        MusicWidget {
            flyoutOpen: root.flyoutOpen
            onToggleFlyout: root.flyoutOpen = !root.flyoutOpen
        }

        Item { Layout.fillWidth: true }

        // Right: placeholder for notifications later
        Text {
            text: "🔔"
            color: "#888"
            rightPadding: 8
        }
    }



    // Flyout popup, anchored to this bar's screen
    MusicFlyout {
        id: flyout
        visible: root.flyoutOpen
        parentBar: root
    }
}