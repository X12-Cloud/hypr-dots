import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: logoutWindow

    anchors.left: true
    anchors.right: true
    anchors.top: true
    anchors.bottom: true

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: WlrLayershell.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    visible: true
    color: "#80000000"

    // 1. ADD THIS: Holds the reference to your ShellRoot
    property var shellContext: null

    Process {
        id: processCmd
    }

    Item {
        id: rootScope
        anchors.fill: parent
        Component.onCompleted: rootScope.forceActiveFocus()

        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
                logoutWindow.destroy();
                event.accepted = true;
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: logoutWindow.destroy()
        }

        Rectangle {
            id: menuBox
            anchors.centerIn: parent

            width: grid.implicitWidth + 24
            height: grid.implicitHeight + 24
            color: "#1C1C1E"
            radius: 24
            border.color: "#2C2C2E"
            border.width: 1

            MouseArea { anchors.fill: parent }

            GridLayout {
                id: grid
                anchors.centerIn: parent
                columns: 4
                rows: 2
                columnSpacing: 12
                rowSpacing: 12

                Repeater {
                    // 2. UPDATE THE MODEL: Distinguish system commands from internal actions
                    model: [
                        { icon: "\ue8ac", name: "Shutdown",  color: "#E94A4A", type: "cmd", target: ["systemctl", "poweroff"] },
                        { icon: "\uf053", name: "Reboot",    color: "#4ADE80", type: "cmd", target: ["systemctl", "reboot"] },
                        { icon: "\uef44", name: "Suspend",   color: "#60A5FA", type: "cmd", target: ["systemctl", "suspend"] },
                        { icon: "\uf45e", name: "Btop",      color: "#A78BFB", type: "cmd", target: ["hyprctl", "dispatch", "exec", "foot -e btop"] },
                        { icon: "\ue897", name: "Lock",      color: "#FBBF24", type: "lock", target: "" },
                        { icon: "\ue9ba", name: "Log Out",   color: "#A78BFA", type: "cmd", target: ["hyprctl", "dispatch", "exit"] },
                        { icon: "\uf724", name: "Hibernate", color: "#60A5FA", type: "cmd", target: ["systemctl", "hibernate"] },
                        { icon: "\ue5cd", name: "Cancel",    color: "#9CA3AF", type: "cancel", target: "" }
                    ]

                    delegate: Rectangle {
                        Layout.preferredWidth: 86
                        Layout.preferredHeight: 86

                        id: gridItem
                        color: itemMouse.containsMouse ? modelData.color : "#2C2C2E"
                        radius: itemMouse.containsMouse ? height / 2 : 16

                        Behavior on radius { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                        Behavior on color { ColorAnimation { duration: 120 } }

                        ColumnLayout {
                            anchors.centerIn: parent
                            width: parent.width - 8
                            spacing: 2

                            Text {
                                font.family: "Material Symbols Rounded"
                                text: modelData.icon
                                color: itemMouse.containsMouse ? "#1C1C1E" : "#E6E1E5"
                                font.pointSize: 22
                                Layout.alignment: Qt.AlignHCenter
                                Behavior on color { ColorAnimation { duration: 120 } }
                            }

                            Text {
                                text: modelData.name
                                color: itemMouse.containsMouse ? "#1C1C1E" : "#9CA3AF"
                                font.pointSize: 8
                                font.weight: Font.Medium
                                Layout.alignment: Qt.AlignHCenter
                                visible: itemMouse.containsMouse
                                maximumLineCount: 1
                                elide: Text.ElideRight
                                Behavior on color { ColorAnimation { duration: 120 } }
                            }
                        }

                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            // 3. UPDATE CLICK LOGIC: Trap the lock action and trigger ShellRoot
                            onClicked: {
                                if (modelData.type === "cmd") {
                                    processCmd.command = modelData.target;
                                    processCmd.running = true;
                                    logoutWindow.destroy();
                                } else if (modelData.type === "lock") {
                                    if (logoutWindow.shellContext !== null) {
                                        logoutWindow.shellContext.isLocked = true;
                                    }
                                    logoutWindow.destroy(); // Close the menu out of the way
                                } else {
                                    logoutWindow.destroy();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
