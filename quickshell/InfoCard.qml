import QtQuick
import QtQuick.Layouts
import qs.decoratives
import qs.texts

Card {
    id: infoCard

    property color accentColor: "#ffffff"
    property string title: ""
    property string value: ""

    implicitHeight: contentCol.implicitHeight + 24
    implicitWidth: contentCol.implicitWidth + 24

    ColumnLayout {
        id: contentCol

        anchors.centerIn: parent
        spacing: 4

        TextLarge {
            Layout.alignment: Qt.AlignHCenter
            text: infoCard.value
        }
        TextSmall {
            Layout.alignment: Qt.AlignHCenter
            text: infoCard.title
        }
    }
}