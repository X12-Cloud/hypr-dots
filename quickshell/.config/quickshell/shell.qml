import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Notifications 0.0
import "./Modules/Bar"
import "./Modules/RightSidebar" as RS

ShellRoot {
    Loader { active: true; sourceComponent: Bar{} }

    RS.RightSidebar { id: rightSidebar }

    NotificationServer {
        id: notificationsService; 
        keepOnReload: true;
        onNotification: (n) => {
            n.tracked = true
            console.log("Summary: " + n.summary)
            console.log("Body: " + n.body)
        }
    }

    GlobalShortcut {
        name: "toggle-sidebar"
        description: "Toggle right sidebar"
        onPressed: { rightSidebar.active = !rightSidebar.active }
    }
}
