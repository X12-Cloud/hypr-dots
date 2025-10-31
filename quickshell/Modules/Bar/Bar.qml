import QtQuick
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: panel

    implicitHeight: 40
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right

    Rectangle {
        id: bar
        anchors.fill: parent
        color: "#1a1a1a"
        radius: 15
        border.color: "#333333"
        border.width:3

        Row {
            id: workspacesrow

            anchors {
                // left.parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 16
            }
            spacing: 8

            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    width: 32
                    height: 24
                    radius: 15
                    color: modelData.active ? "#4a9eff" : "#333333"
                    border.color: "#555555"
                    border.width: 2

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + modelData.id)
                    }

                    Text {
                        text: modelData.id
                        anchors.centerIn: parent
                        color: modelData.active ? "#ffffff" : "#cccccc"
                        font.pixelSize: 12
                        font.family: "Inter, sans-serif"
                    }
                }
            }

            Text {
                visible: Hyprland.workspaces.length === 0
                text: "No workspaces"
                color: "#ffffff"
                font.pixelSize: 12
            }
        }
    }
}

