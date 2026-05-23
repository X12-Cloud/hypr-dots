import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Notifications 0.0
import "./Modules/Bar"
import "./Modules/RightSidebar" as RS
import "./Modules/MediaPlayer" as MP

ShellRoot {
    id: root

    Loader { active: true; sourceComponent: Bar{} }

    RS.RightSidebar { id: rightSidebar; shellContext: root; }
    MP.MediaPlayerBig { id: mediaPlayerBig }

    NotificationServer {
        id: notificationsService;
        keepOnReload: true;
        onNotification: (n) => {
            n.tracked = true
        }
    }

    function createLogoutMenu() {
        let component = Qt.createComponent("Modules/LogoutMenu/LogoutMenu.qml");
        if (component.status === Component.Ready) {
            component.createObject(null);
        } else {
            console.log("Error: " + component.errorString());
        }
    }

    GlobalShortcut {
        name: "toggle-sidebar"
        description: "Toggle right sidebar"
        onPressed: { rightSidebar.active = !rightSidebar.active }
    }
}
