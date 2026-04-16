import QtQuick
import QtQuick.Layouts
import qs.decoratives

Card {
    id: collapsibleCard

    property Component body
    property bool expanded: false
    property Component header
    property int maxHeight: 10000
    height: outerLayout.implicitHeight + 16
    width: parent.width


    function toggle() {
        collapsibleCard.expanded = !collapsibleCard.expanded
    }

    ColumnLayout {
        id: outerLayout

        spacing: collapsibleCard.expanded ? 12 : 0
        width: parent.width - 16
        anchors.centerIn: parent

        // Header — always visible, click toggles expansion


        Loader {
            id: headerLoader

            Layout.fillWidth: true
            Layout.preferredHeight: headerLoader.implicitHeight
            sourceComponent: collapsibleCard.header
        }


        // Body — animates in/out via implicitHeight
        Rectangle {
            id: body
            Layout.fillWidth: true
            clip: true
            color: "transparent"
            height: implicitHeight
            implicitHeight: collapsibleCard.expanded ? bodyLoader.implicitHeight > maxHeight ? maxHeight : bodyLoader.implicitHeight : 0

            Behavior on implicitHeight {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.OutCubic
                }
            }

            Flickable {
                anchors.fill: parent
                clip: true
                contentHeight: bodyLoader.implicitHeight
                contentWidth: width
                Loader {
                    id: bodyLoader

                    sourceComponent: collapsibleCard.body
                    width: parent.width
                }
            }
        }
    }
}

