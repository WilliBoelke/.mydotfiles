import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
import QtQuick.Effects

Drawer {
    direction: "left"

    Repeater {
        model: SystemTray.items

        delegate: Item {
            required property SystemTrayItem modelData

            Layout.preferredHeight: 20
            Layout.preferredWidth: 20

            IconImage {
                anchors.fill: parent
                layer.enabled: true
                source: modelData.icon

                layer.effect: MultiEffect {
                    brightness: 0.0
                    colorization: 1.0
                    colorizationColor: ThemeService.active.accent
                    saturation: 0.000001
                }
            }
            QsMenuAnchor {
                id: menuAnchor

                anchor.window: topBar
                menu: modelData.menu
            }
            MouseArea {
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent

                onClicked: {
                    if (modelData.hasMenu)
                        menuAnchor.open();
                    else
                        modelData.activate();
                }
            }
        }
    }
}
