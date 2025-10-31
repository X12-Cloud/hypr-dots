import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: panel
    anchors {
        left: true
	top: true
	right: true
    }
    //anchors: [top, left, right]
    //x: 0
    //y: 0
    implicitWidth: Screen.width
    implicitHeight: 40

    Rectangle {
        id: bar
        anchors.fill: parent
        color: "#1a1a1a"
        radius: 0
        border.color: "#333333"
        border.width: 1

        Row {
            id: workspacesrow

            anchors {
                left: parent.left
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

