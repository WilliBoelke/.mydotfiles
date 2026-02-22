import Quickshell
import QtQuick
import Quickshell.Hyprland

ShellRoot {



    Variants {
        model: Quickshell.screens

        delegate: Component {
            Bar {
                required property var modelData
                screen: modelData
            }
        }
    }

    Variants {
        model: Quickshell.screens

        delegate: Component {
            SideMenu {
                required property var modelData
                screen: modelData
                open: NotificationService.sideMenuOpen
            }
        }
    }


    Variants {
        model: Quickshell.screens
        delegate: Component {
            NotificationToast {
                required property var modelData
                screen: modelData
            }
        }
    }



    GlobalShortcut {
        appid: "quickshell"
        name: "toggleSideMenu"
        onPressed: {
            // Find the focused monitor name
            var focusedName = Hyprland.focusedMonitor?.name ?? ""

            // send a tets notification to the notification service
            console.log("toggleSideMenu pressed for screen: " + focusedName)

            // Emit a signal that SideMenu instances can listen to
            NotificationService.toggleSideMenuForScreen(focusedName)
        }
    }
}