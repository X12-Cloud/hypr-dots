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
        property int workspaceCount: 9
        property bool lightMode: false

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
        property string backgroundImage: "/home/x12/Pictures/wallpapers/2054-3840x2160-desktop-4k-firewatch-background.jpg"
        property string placeholderImage: "../images/blackhole.jpg"

        // Custom apps
        property var customApps: [
            { name: "Stupid", exec: "~/bin/stupid-script.sh", icon: "foot" },
        ]
    }

    property alias globalDnd: store.globalDnd
    property alias workspaceCount: store.workspaceCount
    property alias customApps: store.customApps
    property alias backgroundImage: store.backgroundImage
    property alias placeholderImage: store.placeholderImage
    property alias lightMode: store.lightMode // <-- Expose via Alias Entry

    // Color aliases
    property alias bgBase: store.bgBase
    property alias surfacePill: store.surfacePill
    property alias borderPill: store.borderPill
    property alias accentNormal: store.accentNormal
    property alias textPrimary: store.textPrimary
    property alias textMuted: store.textMuted

    property alias errorAccent: store.errorAccent
    property alias errorSurface: store.errorSurface
}
