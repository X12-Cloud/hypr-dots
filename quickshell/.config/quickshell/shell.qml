import QtQuick
import Quickshell
import Quickshell.Hyprland
import "./Modules/Bar"
import "./Modules/RightSidebar" as RS

ShellRoot {
    Loader { active: true; sourceComponent: Bar{} }

    RS.RightSidebar { id: rightSidebar }

    // Optional shortcut via Hyprland global shortcut
    GlobalShortcut {
        name: "toggle-sidebar"
        description: "Toggle right sidebar"
        onPressed: { rightSidebar.visible = !rightSidebar.visible }
    }
}
