import QtQuick
import QtQuick.Layouts
import qs.decoratives

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

        Text {
            Layout.alignment: Qt.AlignHCenter
            color: infoCard.accentColor
            font.pixelSize: 16
            font.weight: Font.Bold
            text: infoCard.value
        }
        Text {
            Layout.alignment: Qt.AlignHCenter
            color: infoCard.accentColor
            font.pixelSize: 10
            text: infoCard.title
        }
    }
}