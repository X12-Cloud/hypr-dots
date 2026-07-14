// ShellSettings.qml
import QtQuick
import QtCore

Item {
    id: settings

    Settings {
        id: store
        category: "Shell"
        location: "file:///home/x12/.config/quickshell/quickshell.conf"

        // --- Persistent States ---
        property bool globalDnd: false

        // --- Colors ---
        property string bgBase: "#161618"
        property string surfacePill: "#1C1C1E"
        property string borderPill: "#252528"
        property string accentNormal: "#8AB4F8"
        property string textPrimary: "#E6E1E5"
        property string textMuted: "#CAC4D0"

        property string errorAccent: "#FFB4AB"
        property string errorSurface: "#3A1E1E"

        // --- Paths & Assets ---
        property string backgroundImage: ""
        property string placeholderImage: "../images/blackhole.jpg"

        // Custom apps
        property var customApps: [
            { name: "Stupid", exec: "~/bin/stupid-script.sh", icon: "foot" },
        ]
    }

    property alias globalDnd: store.globalDnd
    property var customApps: store.customApps
    property alias backgroundImage: store.backgroundImage
    property alias placeholderImage: store.placeholderImage

    // Color exports
    readonly property color bgBase: store.bgBase
    readonly property color surfacePill: store.surfacePill
    readonly property color borderPill: store.borderPill
    readonly property color accentNormal: store.accentNormal
    readonly property color textPrimary: store.textPrimary
    readonly property color textMuted: store.textMuted

    readonly property color errorAccent: store.errorAccent
    readonly property color errorSurface: store.errorSurface
}
