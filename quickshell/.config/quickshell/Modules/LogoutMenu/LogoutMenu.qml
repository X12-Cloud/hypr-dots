import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: logoutWindow

    anchors.left: true
    anchors.right: true
    anchors.top: true
    anchors.bottom: true

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    visible: true
    color: "#80000000"

    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Escape) {
            logoutWindow.destroy();
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
        height: 320
        color: "#1C1C1E"
        radius: 24
        border.color: "#2C2C2E"
        border.width: 1

        // Prevent background clicks from closing the menu when clicking the box
        MouseArea { anchors.fill: parent }

        GridLayout {
            id: grid
            anchors.fill: parent
            anchors.margins: 24
            columns: 3
            rows: 3

            Repeater {
                model: [
                    { icon: "\ue8ac", name: "Shutdown", color: "#E94A4A" },
                    { icon: "\ue5d5", name: "Reboot", color: "#4ADE80" },
                    { icon: "\uea60", name: "Suspend", color: "#60A5FA" },
                    { icon: "\ue897", name: "Lock", color: "#FBBF24" },
                    { icon: "\ue9ba", name: "Log Out", color: "#A78BFA" },
                    { icon: "\ue5cd", name: "Cancel", color: "#9CA3AF" }
                ]

                delegate: Rectangle {
                    id: gridItem
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    color: itemMouse.containsMouse ? modelData.color : "#2C2C2E"
                    radius: itemMouse.containsMouse ? height / 2 : 16

                    Behavior on radius {
                        NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                    }
                    Behavior on color {
                        ColorAnimation { duration: 140 }
                    }

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            font.family: "Material Symbols Rounded"
                            text: modelData.icon
                            color: itemMouse.containsMouse ? "#1C1C1E" : "#E6E1E5"
                            font.pointSize: 18
                            Layout.alignment: Qt.AlignHCenter

                            Behavior on color { ColorAnimation { duration: 140 } }
                        }

                        Text {
                            text: modelData.name
                            color: itemMouse.containsMouse ? "#1C1C1E" : "#9CA3AF"
                            font.pointSize: 9
                            font.weight: Font.Medium
                            Layout.alignment: Qt.AlignHCenter
                            visible: itemMouse.containsMouse // Only shows label on hover to keep it minimal

                            Behavior on color { ColorAnimation { duration: 140 } }
                        }
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            console.log("Clicked option: " + modelData.name);
                            // will place the actual shell logic handlers here later
                        }
                    }
                }
            }
        }
    }
}
