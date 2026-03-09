import QtQuick
import QtQuick.Layouts
import qs.consts

Rectangle {
    id: drawer

    // "left" or "right" – direction the drawer expands towards
    property string direction: "right"

    // The items to show when expanded – pass as children of drawerContent
    default property alias drawerItems: drawerContent.data

    // Internal
    property bool expanded: false

    readonly property real arrowWidth: 14
    readonly property real sidePadding: 6
    readonly property real gapAfterArrow: 10
    readonly property real expandedContentWidth: drawerContent.implicitWidth
    readonly property real closedWidth: arrowWidth + sidePadding * 2
    readonly property real openWidth: closedWidth + gapAfterArrow + expandedContentWidth

    color: "transparent"
    radius: 6
    height: 24
    implicitHeight: 20
    implicitWidth: closedWidth
    clip: true
    width: closedWidth

    Behavior on width {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    MouseArea {
        id: hoverArea
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        hoverEnabled: true

        onContainsMouseChanged: {
            drawer.expanded = containsMouse;
        }
    }

    states: [
        State {
            name: "open"
            when: drawer.expanded
            PropertyChanges {
                target: drawer
                width: drawer.openWidth
            }
        }
    ]

    // Arrow – always visible
    Text {
        id: arrowIcon
        anchors.verticalCenter: parent.verticalCenter
        x: drawer.direction === "left"
            ? drawer.width - sidePadding - arrowWidth / 2 - implicitWidth / 2
            : sidePadding + arrowWidth / 2 - implicitWidth / 2
        color: Colors.accent
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 20
        font.weight: Font.Bold
        text: drawer.direction === "left" ? "\uf104" : "\uf105"
    }

    Row {
        id: drawerContent
        anchors.verticalCenter: parent.verticalCenter
        x: drawer.direction === "left"
            ? drawer.width - sidePadding - arrowWidth - gapAfterArrow - drawerContent.implicitWidth
            : sidePadding + arrowWidth + gapAfterArrow
        layoutDirection: drawer.direction === "left" ? Qt.RightToLeft : Qt.LeftToRight
        spacing: 12
        opacity: drawer.expanded ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }
}
