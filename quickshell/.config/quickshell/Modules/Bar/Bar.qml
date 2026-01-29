import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: panel
    anchors { left: true; top: true; right: true }
    implicitHeight: 45

    // ---------------- Date/Time Logic ----------------
    property string currentTime: ""

    Timer {
        id: timeUpdater
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var now = new Date();
            currentTime = Qt.formatDate(now, "MMM d, yy  |  ")
                        + Qt.formatTime(now, "h:mm:ss AP");
        }
    }
    Component.onCompleted: timeUpdater.triggered()

    // ------------------- Main Bar --------------------
    Rectangle {
        id: bar
        anchors.fill: parent
        color: "#1C1B1F"  // M3 surface
        clip: true
        border.width: 0

        Row {
            id: workspacesRow
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
                leftMargin: 12
            }
            spacing: 8

            // ---------------- Workspace Pills ----------------
            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    id: pill
                    radius: 999
                    height: 30
                    width: modelData.active ? 46 : 30
                    color: modelData.active ? "#EADDFF" : "#201F24"
                    scale: modelData.active ? 1.12 : 1.0
                    border.width: 0

                    Behavior on width { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
                    Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack } }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + modelData.id)
                    }

                    Text {
                        anchors.centerIn: parent
                        text: modelData.id
                        color: modelData.active ? "#21005D" : "#E6E1E5"
                        font.pixelSize: 14
                        font.family: "Roboto, sans-serif"
                        opacity: modelData.active ? 1.0 : 0.75
                        Behavior on opacity { NumberAnimation { duration: 180 } }
                    }
                }
            }

            // Show this if no workspaces
            Text {
                visible: Hyprland.workspaces.length === 0
                text: "No workspaces"
                color: "#E6E1E5"
                font.pixelSize: 14
            }
        }

        // ---------------- Time Widget (Clickable) ----------------
        Rectangle {
            id: timeContainer
            radius: 10
            height: 32
            color: "#2C2C2E"  // translucent grey
            border.width: 0
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 12
            }
            width: timeDisplay.contentWidth + 24

            MouseArea {
                anchors.fill: parent
                onClicked: rightSidebar.visible = !rightSidebar.visible
		hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
            }

            Text {
                id: timeDisplay
                text: panel.currentTime
                anchors.centerIn: parent
                color: "#ECECEC"
                font.pixelSize: 16
                font.family: "Inter, Roboto, sans-serif"
            }
        }
    }
}
