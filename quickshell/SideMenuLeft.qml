import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

PanelWindow {
    id: root

    // Just this binding directly
    property bool open: false
    property int panelWidth: 600

    margins {
        top: 20
        bottom: 20
        left: 20
    }


    anchors {
        top: true;
        bottom: true;
        left: true
    }

    width: root.panelWidth
    color: "transparent"
    exclusionMode: ExclusionMode.Normal
    mask: Region {
        item: root.open ? contentRect : null
    }

    // main penal boxa
    Rectangle {
        id: contentRect
        radius : 12

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            leftMargin: root.open ? 0 : -root.panelWidth
        }



        width: root.panelWidth
        color: "#1a000000"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            // Flyout popup, anchored to this bar's screen
            MusicPlayer {
                id: flyout
                visible: root.flyoutOpen
                Layout.alignment: Qt.AlignTop
            }

            Item { Layout.fillHeight: true }
        }

        Behavior on anchors.leftMargin {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }
    }
}