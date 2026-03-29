import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services
import QtQuick.Effects

Drawer {
    property var window: null
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

                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
                anchor.window: window
                menu: modelData.menu
            }
            MouseArea {
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                anchors.fill: parent

                onClicked: {
                    if (modelData.hasMenu) {
                        var pos = parent.mapToItem(null, 0, 0);
                        menuAnchor.anchor.rect.x = pos.x;
                        menuAnchor.anchor.rect.y = pos.y;
                        menuAnchor.anchor.rect.width = parent.width;
                        menuAnchor.anchor.rect.height = parent.height;
                        openTimer.start();
                    } else {
                        modelData.activate();
                    }
                }
            }
            Timer {
                id: openTimer

                interval: 200
                repeat: false

                onTriggered: {
                        console.log("opening at rect:", menuAnchor.anchor.rect.x, menuAnchor.anchor.rect.y);
                        menuAnchor.open();
                    }

            }
        }
    }
}
