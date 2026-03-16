import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects
import SddmComponents 2.0

Item {
    id: root

    height: Screen.height
    width: Screen.width

    Component.onCompleted: passwordField.forceActiveFocus()

    // Background
    Image {
        id: wallpaper

        anchors.fill: parent
        cache: true
        fillMode: Image.PreserveAspectCrop
        source: Qt.resolvedUrl("wallpaper.png")
    }
    GaussianBlur {
        anchors.fill: wallpaper
        deviation: 24
        radius: 64
        samples: 128
        source: wallpaper
    }
    // Dark overlay
    Rectangle {
        anchors.fill: parent
        color: "#1e282c"
        opacity: 0.5
    }

    // Clock
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.25
        spacing: 8

        Text {
            id: clock

            anchors.horizontalCenter: parent.horizontalCenter
            color: config.accent
            font.family: config.clockFont
            font.pointSize: 64
            font.weight: Font.ExtraBold
            text: Qt.formatTime(new Date(), "hh:mm")

            Timer {
                interval: 1000
                repeat: true
                running: true

                onTriggered: clock.text = Qt.formatTime(new Date(), "hh:mm")
            }
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            color: config.accent
            font.family: config.clockFont
            font.pointSize: 24
            font.weight: Font.ExtraBold
            text: Qt.formatDate(new Date(), "dddd, dd MMMM yyyy")
        }
    }

    // Login box
    // Login box
    Rectangle {
        id: loginBox

        anchors.centerIn: parent
        border.color: passwordField.activeFocus ? "#E9643A" : "transparent"
        border.width: 1
        color: "#401e282c"
        height: 52
        layer.enabled: true
        radius: 12
        width: 320

        layer.effect: DropShadow {
            color: "#40000000"
            horizontalOffset: 0
            radius: 16
            samples: 32
            verticalOffset: 4
        }

        TextField {
            id: passwordField

            anchors.centerIn: parent
            color: "#ffffff"
            echoMode: TextInput.Password
            font.family: config.font
            font.pointSize: config.fontSize
            height: parent.height
            horizontalAlignment: TextInput.AlignHCenter
            placeholderText: "···"
            placeholderTextColor: "#60ffffff"
            width: parent.width - 24

            background: Item {
            }

            Keys.onReturnPressed: sddm.login(userModel.lastUser, passwordField.text, sessionModel.lastIndex)
        }
    }

    // Error message
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: loginBox.bottom
        anchors.topMargin: 12
        color: "#E9643A"
        font.family: config.font
        font.pointSize: 10
        text: sddm.lastError
        visible: sddm.lastError !== ""
    }
    Connections {
        target: sddm

        onLoginFailed: {
            passwordField.text = "";
            passwordField.forceActiveFocus();
        }
    }
}