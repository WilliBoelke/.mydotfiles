import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
    id: drawer

    readonly property real arrowWidth: 14
    readonly property real closedWidth: arrowWidth + sidePadding * 2

    // Public API
    property string direction: "right"
    default property alias drawerItems: drawerContent.data
    property bool expanded: false
    readonly property real gapAfterArrow: 10
    readonly property real openWidth: closedWidth + gapAfterArrow + drawerContent.implicitWidth

    // Layout constants
    readonly property real sidePadding: 6

    clip: true
    color: "transparent"
    implicitHeight: 20
    implicitWidth: expanded ? openWidth : closedWidth
    radius: 6

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    MouseArea {
        acceptedButtons: Qt.NoButton
        anchors.fill: parent
        hoverEnabled: true

        onContainsMouseChanged: drawer.expanded = containsMouse
    }

    // Arrow
    Text {
        anchors.verticalCenter: parent.verticalCenter
        color: ThemeService.active.accent
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 20
        font.weight: Font.Bold
        text: direction === "left" ? "\uf104" : "\uf105"
        x: direction === "left" ? drawer.implicitWidth - sidePadding - arrowWidth / 2 - implicitWidth / 2 : sidePadding + arrowWidth / 2 - implicitWidth / 2
    }

    // Content
    RowLayout {
        id: drawerContent

        anchors.verticalCenter: parent.verticalCenter
        layoutDirection: direction === "left" ? Qt.RightToLeft : Qt.LeftToRight
        opacity: expanded ? 1 : 0
        spacing: 12
        x: direction === "left" ? drawer.implicitWidth - sidePadding - arrowWidth - gapAfterArrow - implicitWidth : sidePadding + arrowWidth + gapAfterArrow

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }
    }
}