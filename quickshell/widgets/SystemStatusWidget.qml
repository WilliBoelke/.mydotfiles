import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.decoratives

/**
 * SystemStatusWidget
 *
 * A bar widget with three displays states, which change based on current system events.
 *
 *   "default"     — Bell icon + unread count. Stationary, always visible
 *                   unless another state is active.
 *
 *   "notifying"   — Incoming notification (summary + appName + icon).
 *                   Auto-dismisses after 10 s; middle-click dismisses early.
 *                   Slides in from the right, slides out to the right.
 *
 *   "load"        — (placeholder) High system-load readout.
 *                   Reserved for future implementation.
 *
 * Architecture notes
 * ------------------
 * • The Card itself is the sizing root. Its `implicitWidth` is driven by
 *   whichever content item is currently active via a Behavior-animated
 *   `targetWidth` property — the card grows/shrinks smoothly between states.
 *
 * • All three content items live at the same anchored position inside the
 *   card. Visibility + opacity are controlled exclusively through `states`
 *   and `transitions` — no manual `x` arithmetic, no ScriptAction sequencing.
 *
 * • The notification slides in/out horizontally using an `x` transform on
 *   the notification item itself (not on a shared container), so the default
 *   content is never accidentally dragged along.
 *
 * • `clip: true` on the card keeps the slide animation tidy.
 *
 * Public API
 * ----------
 *   signal toggleSideMenu          — emitted on left-click anywhere
 *   property bool sideMenuOpen     — caller reflects side-menu state here
 */
Card {
    id: root

    // ── Public API ──────────────────────────────────────────────────────────

    property bool sideMenuOpen: false
        signal toggleSideMenu

    // ── Internal state ──────────────────────────────────────────────────────

    // Resolved from the notification service; null when nothing is pending.
    readonly property var lastNotification: {
        var notifs = NotificationService.trackedNotifications.values;
        return notifs.length > 0 ? notifs[notifs.length - 1] : null;
    }

    // The three widget states.  Add "load" here later.
    readonly property string stateDefault:    "default"
    readonly property string stateNotifying:  "notifying"

    // Active display state — drives all visibility and sizing below.
    property string activeState: stateDefault


    function enterNotifying() {
        state = "notifying";
        targetWidth = notifyingContentWidth;
        dismissTimer.restart();
        progressBar.width = targetWidth - 16;
        timerProgress.from = targetWidth - 16;
        timerProgress.restart();
    }

    function enterDefault() {
        dismissTimer.stop();
        timerProgress.stop();
        state = "default";
        targetWidth = defaultContentWidth;
    }

    // ── Sizing ──────────────────────────────────────────────────────────────

    // Each content item exposes its natural width via these properties.
    // The card width animates between them when activeState changes.
    readonly property real defaultContentWidth:      defaultContent.implicitWidth  + 48
    readonly property real notifyingContentWidth:    notifyingContent.implicitWidth + 16

    property real targetWidth: defaultContentWidth

    implicitHeight: parent.height
    implicitWidth: targetWidth

    Behavior on implicitWidth {
        NumberAnimation {
            duration: 260
            easing.type: Easing.InOutCubic
        }
    }

    radius: 4
    clip: true

    // ── Reactions ───────────────────────────────────────────────────────────

    onLastNotificationChanged: {
        if (lastNotification !== null) {
            activeState = stateNotifying;
            root.enterNotifying()
            targetWidth = notifyingContentWidth;
            dismissTimer.restart();
            // Wait for card resize to settle, then start progress from full width
            progressBar.width = root.targetWidth - 16;
            timerProgress.from = root.targetWidth - 16;
            timerProgress.to = 0;
            timerProgress.restart();
        }
    }

    // ── Dismiss timer (10 s) ────────────────────────────────────────────────

    Timer {
        id: dismissTimer
        interval: 5000
        onTriggered: root.dismissNotification()
    }

    function dismissNotification() {
        dismissTimer.stop();
        timerProgress.stop();
        activeState = stateDefault;
        root.enterDefault()
        targetWidth = defaultContentWidth;
    }

    // ── Interaction ─────────────────────────────────────────────────────────

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onClicked: mouse => {
            if (mouse.button === Qt.MiddleButton && root.activeState === root.stateNotifying) {
                root.lastNotification?.dismiss();
                root.dismissNotification();
            } else if (mouse.button === Qt.LeftButton) {
                root.toggleSideMenu();
            }
        }
    }

    // ── Content items ────────────────────────────────────────────────────────
    //
    // Both items share the same anchor box.  Opacity + x-offset are animated
    // by the `states` block at the bottom.  Starting values here represent
    // the "off" (hidden) position so the first transition plays correctly.

    // ── 1. Default state content ─────────────────────────────────────────────

    RowLayout {
        id: defaultContent
        anchors.centerIn: parent
        spacing: 8

        opacity: 0          // controlled by states/transitions
        x: -8               // slides in from the left when becoming active

        // Bell / notification-count block
        RowLayout {
            spacing: 24

            Text {
                color: "#C35A24"
                elide: Text.ElideRight
                font.pixelSize: 14
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignRight
                text: `${NotificationService.trackedNotifications.values.length}`
            }

            Text {
                color: "#C35A24"
                elide: Text.ElideRight
                font.pixelSize: 14
                font.weight: Font.Medium
                horizontalAlignment: Text.AlignRight
                text: `${UpdateService.updates.length}`
            }
        }
    }

    // --- 2. Notifying state content ---1

    RowLayout {
        id: notifyingContent
        anchors.centerIn: parent
        spacing: 24
        opacity: 0
        x: width


        // Text block: summary + app name
        ColumnLayout {
            id: notificationText
            spacing: 4

            // Title
            RowLayout {
                id: titleRow
                spacing: 8
                Text {
                    color: "#C35A24"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    text: root.lastNotification?.summary ?? ""
                }
                Text {
                    color: "#cd893b"
                    font.pixelSize: 12
                    text: root.lastNotification?.appName ?? ""
                }
            }

            RowLayout {
                id: bodyRow
                width: 100
                Text {
                    width: 100
                    wrapMode: Text.WordWrap
                    color: "#d55c1b"
                    font.pixelSize: 12
                    text: root.lastNotification?.body ?? ""
                }
            }
        }

        // App icon (Nerd Font glyph fallback)
        Rectangle {
            color: "transparent"
            height: 28
            width: 28
            radius: 4
            layer.enabled: true

            Text {
                anchors.centerIn: parent
                color: "#d55c1b"
                font.pixelSize: 24
                text: "󰎟"
                visible: (root.lastNotification?.appIcon ?? "") === ""
            }
        }

        Rectangle {
            id: progressBar
            parent: root          // ← reparent to card for geometry
            anchors.bottom: root.bottom
            anchors.left: root.left
            height: 1
            radius: 1
            color: "#4ac6ca"
            width: root.implicitWidth - 16
            visible: root.activeState === root.stateNotifying

            NumberAnimation {
                id: timerProgress
                target: progressBar
                property: "width"
                duration: dismissTimer.interval
                easing.type: Easing.Linear
            }
        }
    }



    // ── State machine ─────────────────────────────────────────────────
    //
    // `states` declaratively owns opacity and x for both content items.
    // `transitions` animates the change between them.
    // Nothing else should touch these two properties on these two items.

    state: root.activeState

    states: [
        State {
            name: "default"
            PropertyChanges { target: defaultContent;   opacity: 1; x: 0        }
            PropertyChanges { target: notifyingContent; opacity: 0; x: notifyingContent.width }
        },
        State {
            name: "notifying"
            PropertyChanges { target: defaultContent;   opacity: 0; x: -8       }
            PropertyChanges { target: notifyingContent; opacity: 1; x: 0        }
        }
    ]

    transitions: [
        // Default  →  Notifying:  notification slides in from right
        Transition {
            from: "default"; to: "notifying"
            SequentialAnimation {
                // Fade out default content quickly
                NumberAnimation { target: defaultContent;   property: "opacity"; duration: 120; easing.type: Easing.InQuad }
                // Then slide + fade in notification content
                ParallelAnimation {
                    NumberAnimation { target: notifyingContent; property: "x";       duration: 260; easing.type: Easing.OutCubic }
                    NumberAnimation { target: notifyingContent; property: "opacity"; duration: 200; easing.type: Easing.OutQuad }
                }
            }
        },
        // Notifying  →  Default:  notification slides out to right, default fades in
        Transition {
            from: "notifying"; to: "default"
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: notifyingContent; property: "x";       duration: 240; easing.type: Easing.InCubic }
                    NumberAnimation { target: notifyingContent; property: "opacity"; duration: 180; easing.type: Easing.InQuad }
                }
                NumberAnimation { target: defaultContent; property: "opacity"; duration: 160; easing.type: Easing.OutQuad }
            }
        }
    ]
}