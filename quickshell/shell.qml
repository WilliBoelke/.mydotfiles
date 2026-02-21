import Quickshell
import QtQuick

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        delegate: Component {
            Bar {
                required property var modelData
                screen: modelData
            }
        }
    }
}