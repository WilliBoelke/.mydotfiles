import QtQuick
import QtQuick.Layouts

Rectangle {
    id: infoCard
    color: "#1a000000"
    radius: 6

    property string title: ""
    property string value: ""
    property color accentColor: "#ffffff"

    implicitHeight: contentCol.implicitHeight + 24
    implicitWidth: contentCol.implicitWidth + 24

    ColumnLayout {
        id: contentCol
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: infoCard.value
            color: infoCard.accentColor
            font.pixelSize: 16
            font.weight: Font.Bold
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: infoCard.title
            color: infoCard.accentColor
            font.pixelSize: 10
            Layout.alignment: Qt.AlignHCenter
        }
    }
}