import QtQuick

QtObject {

    // =========================================================
    // PRIMITIVES — edit here to change the theme
    // =========================================================

    readonly property color _accent: "#d55c1b"
    readonly property color _accentDark: "#381807"
    readonly property color _black: "#000000"
    readonly property color _blue: "#52e9eb"
    readonly property color _gray300: "#aaaaaa"
    readonly property color _gray600: "#666666"
    readonly property color _gray700: "#3a3a3a"
    readonly property color _gray800: "#2a2a2a"
    readonly property color _gray900: "#1a1a1a"

    // System colors
    readonly property color _green: "#46a86a"
    readonly property color _red: "#e10c05"
    readonly property color _white: "#ffffff"
    readonly property color _yellow: "#a3a304"

    // =========================================================
    // SEMANTIC TOKENS — use these in components
    // =========================================================

    // --- Accent ---
    readonly property color accent: _accent
    readonly property color accentDark: _accentDark
    readonly property color accentFaint: Qt.rgba(0.835, 0.361, 0.106, 1)
    readonly property color accentSubtle: Qt.rgba(0.835, 0.361, 0.106, 1)

    // --- Surfaces (blur-dependent in default theme) ---
    readonly property color bgBase: "#191a1c" // panels, sidebars

    // --- Buttons ---
    readonly property color bgButton: "#381807"
    readonly property color bgButtonActive: accentSubtle
    readonly property color bgButtonHover: accentSubtle
    readonly property color bgCard: "#1e1f22"
    readonly property color bgImagePlaceholder: _gray900

    // --- Specials ---
    readonly property color bgMediaPlaying: Qt.rgba(0.835, 0.361, 0.106, 1)
    readonly property color bgOverlay: Qt.rgba(0, 0, 0, 0.40)  // modals, overlays

    readonly property color borderAccent: Qt.rgba(1, 0.45, 0.1, 1)
    readonly property color borderButton: Qt.rgba(1, 0.45, 0.1, 1)
    readonly property color borderButtonHover: Qt.rgba(1, 0.45, 0.1, 1)

    // --- Generic interactive surfaces ---
    readonly property color borderSubtle: Qt.rgba(1, 1, 1, 1)
    readonly property color cardBorder: "#26282b"
    readonly property color cardBorderHover: "#43454a"
    readonly property color statusBlue: _blue

    // --- Status ---
    readonly property color statusGreen: _green
    readonly property color statusRed: _red
    readonly property color statusYellow: _yellow
    readonly property color textAccent: _accent
    readonly property color textDisabled: "#555555"
    readonly property color textMuted: _gray600

    // --- Text ---
    readonly property color textPrimary: _white
    readonly property color textSecondary: _gray300
}