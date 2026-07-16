import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Notifications 0.0
import "./Modules/Bar"
import "./Modules/RightSidebar" as RS
import "./Modules/MediaPlayer" as MP
import "./Modules/Lock/" as LS
import "./Modules/Settings/" as ST

ShellRoot {
    id: root

    ShellSettings {
        id: persistentSettings
    }

    property var customAppModel: persistentSettings.customApps

    property bool lightMode: persistentSettings.lightMode

    // Colours
    readonly property color bgBase: persistentSettings.bgBase
    readonly property color surfacePill: persistentSettings.surfacePill
    readonly property color borderPill: persistentSettings.borderPill
    readonly property color accentNormal: persistentSettings.accentNormal
    readonly property color textPrimary: persistentSettings.textPrimary
    readonly property color textMuted: persistentSettings.textMuted

    readonly property color errorAccent: persistentSettings.errorAccent
    readonly property color errorSurface: persistentSettings.errorSurface

    // Dnd and workspaces
    property alias globalDnd: persistentSettings.globalDnd
    property int workspaceCount: persistentSettings.workspaceCount

    // Images
    property alias backgroundImage: persistentSettings.backgroundImage
    property alias placeholderImage: persistentSettings.placeholderImage

    property alias settingsApp: settingsApp

    Loader { active: true; sourceComponent: Bar { shellContext: root } }
    RS.RightSidebar { id: rightSidebar; shellContext: root; }
    MP.MediaPlayerBig { id: mediaPlayerBig; shellContext: root; }

    ST.SettingsApp {
        id: settingsApp
        visible: false
    }

    property bool isLocked: false
    Loader {
        active: root.isLocked
        sourceComponent: LS.LockScreen {}
    }

    NotificationServer {
        id: notificationsService
        keepOnReload: true
        onNotification: (n) => {
            n.tracked = true
            n.timestamp = new Date()
            notificationsService.trackedNotifications.insert(0, n)
        }
    }

    function createLauncher() {
        let component = Qt.createComponent("Modules/Launcher/Menu.qml");
        if (component.status === Component.Ready) {
            component.createObject(null, { "shellContext": root });
        } else {
            console.log("Error: " + component.errorString());
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
        name: "open_launcher"
        description: "Open application launcher"
        onPressed: { root.createLauncher() }
    }
    GlobalShortcut {
        name: "toggle_logout"
        description: "Toggle logout menu"
        onPressed: { root.createLogoutMenu() }
    }
}
