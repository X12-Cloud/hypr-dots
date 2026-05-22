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

            width: 320
            height: 220
            color: "#1C1C1E"
            radius: 24
            border.color: "#2C2C2E"
            border.width: 1

            MouseArea { anchors.fill: parent }

            GridLayout {
                id: grid
                anchors.fill: parent
                anchors.margins: 16
                columns: 3
                rows: 2
                columnSpacing: 12
                rowSpacing: 12

                Repeater {
                    model: [
                        { icon: "\ue8ac", name: "Shutdown", color: "#E94A4A", isAction: true },
                        { icon: "\uf053", name: "Reboot",    color: "#4ADE80", isAction: true },
                        { icon: "\uef44", name: "Suspend",   color: "#60A5FA", isAction: true },
                        { icon: "\ue897", name: "Lock",      color: "#FBBF24", isAction: true },
                        { icon: "\ue9ba", name: "Log Out",   color: "#A78BFA", isAction: true },
                        { icon: "\ue5cd", name: "Cancel",    color: "#9CA3AF", isAction: false }
                    ]

                    delegate: Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Process {
                            id: localCmd
                            command: {
                                if (modelData.name === "Shutdown") return ["systemctl", "poweroff"];
                                if (modelData.name === "Reboot") return ["systemctl", "reboot"];
                                if (modelData.name === "Suspend") return ["systemctl", "suspend"];
                                if (modelData.name === "Lock") return ["hyprlock"];
                                if (modelData.name === "Log Out") return ["hyprctl", "dispatch", "exit"];
                                return [];
                            }
                        }

                        Rectangle {
                            id: gridItem
                            width: Math.min(parent.width, parent.height)
                            height: width
                            anchors.centerIn: parent
                            color: itemMouse.containsMouse ? modelData.color : "#2C2C2E"
                            radius: itemMouse.containsMouse ? height / 2 : 16

                            Behavior on radius { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                            Behavior on color { ColorAnimation { duration: 120 } }

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4

                                Text {
                                    font.family: "Material Symbols Rounded"
                                    text: modelData.icon
                                    color: itemMouse.containsMouse ? "#1C1C1E" : "#E6E1E5"
                                    font.pointSize: 18
                                    Layout.alignment: Qt.AlignHCenter
                                    Behavior on color { ColorAnimation { duration: 120 } }
                                }

                                Text {
                                    text: modelData.name
                                    color: itemMouse.containsMouse ? "#1C1C1E" : "#9CA3AF"
                                    font.pointSize: 8.5
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
}
