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

            width: grid.implicitWidth + 32
            height: grid.implicitHeight + 32
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
                columnSpacing: 14
                rowSpacing: 14

                Repeater {
                    model: [
                        { icon: "\ue8ac", name: "Shutdown",     color: "#E94A4A", isAction: true },
                        { icon: "\uf053", name: "Reboot",       color: "#4ADE80", isAction: true },
                        { icon: "\uef44", name: "Suspend",      color: "#60A5FA", isAction: true },
                        { icon: "\uf45e", name: "Task Manager", color: "#A78BFB", isAction: true },
                        { icon: "\ue897", name: "Lock",          color: "#FBBF24", isAction: true },
                        { icon: "\ue9ba", name: "Log Out",      color: "#A78BFA", isAction: true },
                        { icon: "\uf724", name: "Hibernate",    color: "#60A5FA", isAction: true },
                        { icon: "\ue5cd", name: "Cancel",       color: "#9CA3AF", isAction: false }
                    ]

                    delegate: Rectangle {
                        Layout.preferredWidth: 72
                        Layout.preferredHeight: 72

                        id: gridItem
                        color: itemMouse.containsMouse ? modelData.color : "#2C2C2E"
                        radius: itemMouse.containsMouse ? height / 2 : 16

                        Behavior on radius { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                        Behavior on color { ColorAnimation { duration: 120 } }

                        Process {
                            id: localCmd
                            command: {
                                if (modelData.name === "Shutdown") return ["systemctl", "poweroff"];
                                if (modelData.name === "Reboot") return ["systemctl", "reboot"];
                                if (modelData.name === "Suspend") return ["systemctl", "suspend"];
                                if (modelData.name === "Lock") return ["hyprlock"];
                                if (modelData.name === "Log Out") return ["hyprctl", "dispatch", "exit"];
                                if (modelData.name === "Hibernate") return ["systemctl", "hibernate"];
                                if (modelData.name === "Task Manager") return ["sh", "-c", "btop"];
                                return [];
                            }
                        }

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 2

                            Text {
                                font.family: "Material Symbols Rounded"
                                text: modelData.icon
                                color: itemMouse.containsMouse ? "#1C1C1E" : "#E6E1E5"
                                font.pointSize: 20
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
                                Behavior on color { ColorAnimation { duration: 120 } }
                            }
                        }

                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                if (modelData.isAction) {
                                    localCmd.running = false;
                                    localCmd.running = true;
                                }
                                logoutWindow.destroy();
                            }
                        }
                    }
                }
            }
        }
    }
}
