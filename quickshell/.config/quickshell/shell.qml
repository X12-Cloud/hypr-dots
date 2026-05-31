import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Notifications 0.0
import "./Modules/Bar"
import "./Modules/RightSidebar" as RS
import "./Modules/MediaPlayer" as MP
import "./Modules/Lock/" as LS

ShellRoot {
    id: root

    // Colours
    readonly property color bgBase: "#050B14"
    readonly property color surfacePill: "#0C1625"
    readonly property color borderPill: "#1F314A"
    readonly property color accentNormal: "#8AB4F8" // "#D6BEFA"
    readonly property color textPrimary: "#E2E8F0"
    readonly property color textMuted: "#64748B"

    readonly property color errorAccent: "#F2B8B5"
    readonly property color errorSurface: "#2C161A"

    Loader { active: true; sourceComponent: Bar{ shellContext: root } }

    property bool globalDnd: false
    RS.RightSidebar { id: rightSidebar; shellContext: root; }
    MP.MediaPlayerBig { id: mediaPlayerBig; shellContext: root; }

    property bool isLocked: false
    Loader {
        active: root.isLocked
        sourceComponent: LS.LockScreen {}
    }

    NotificationServer {
        id: notificationsService;
        keepOnReload: true;
        onNotification: (n) => {
            n.tracked = true
            n.timestamp = new Date()
        }
    }

    function createLogoutMenu() {
        let component = Qt.createComponent("Modules/LogoutMenu/LogoutMenu.qml");
        if (component.status === Component.Ready) {
            component.createObject(null, { "shellContext": root });
        } else {
            console.log("Error: " + component.errorString());
        }
    }

    GlobalShortcut {
        name: "toggle_sidebar"
        description: "Toggle right sidebar"
        onPressed: { rightSidebar.active = !rightSidebar.active }
    }
    GlobalShortcut {
        name: "toggle_logout"
        description: "Toggle logout menu"
        onPressed: { root.createLogoutMenu() }
    }
}
