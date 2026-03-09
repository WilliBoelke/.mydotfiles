pragma Singleton
import QtQuick

QtObject {
    // Accent
    readonly property color accent: "#d55c1b"
    readonly property color accentA10: "#1ad55c1b"
    readonly property color accentA20: "#33d55c1b"
    readonly property color accentA30: "#4dd55c1b"

    // Neutrals
    readonly property color white: "#ffffff"
    readonly property color whiteA08: "#15ffffff"
    readonly property color whiteA12: "#20ffffff"
    readonly property color whiteA20: "#33ffffff"

    readonly property color black: "#000000"
    readonly property color blackA10: "#1a000000"
    readonly property color blackA20: "#33000000"
    readonly property color blackA30: "#4d000000"

    readonly property color gray900: "#333333"
    readonly property color gray800: "#444444"
    readonly property color gray700: "#555555"
    readonly property color gray600: "#666666"
    readonly property color gray300: "#aaaaaa"

    // System
    readonly property color green: "#46a86a"
    readonly property color red: "#e10c05"
    readonly property color yellow: "#a3a304"
    readonly property color blue: "#52e9eb"
    readonly property color purple: "#610a61"


    // Text
    readonly property color textPrimary: accent
    readonly property color textSecondary: gray300
    readonly property color textMuted: gray600
    readonly property color textDisabled: gray800

    // Backgrounds
    readonly property color bgPanel: blackA10
    readonly property color bgCard: whiteA08
    readonly property color bgCardHover: whiteA12
    readonly property color bgButton: "#381807"
    readonly property color bgButtonHover: accentA20
    readonly property color bgMediaCardPlaying: "#22d55c1b"
    readonly property color bgImagePlaceholder: gray900

    // Hover/active surfaces
    readonly property color hoverSurface: whiteA12
    readonly property color hoverSurfaceStrong: whiteA20
    readonly property color activeSurface: accentA20
}

