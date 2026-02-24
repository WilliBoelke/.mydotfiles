import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
PanelWindow {
    id: root

    // Just this binding directly
    property bool open: false
    property int panelWidth: 600

    margins {
        top: 20
        bottom: 20
        right: 20
    }

    anchors {
        top: true;
        bottom: true;
        right: true
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
            right: parent.right
            rightMargin: root.open ? 0 : -root.panelWidth
        }

        width: root.panelWidth
        color: "#1a000000"

        Behavior on anchors.rightMargin {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutCubic
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12


            StatsCard {
                accentColor: "#3D7F75"
                title: "CPU"
                value: CpuService.cpuUsage
                Layout.fillWidth : true
            }

            Notifications {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

        }


    }
}