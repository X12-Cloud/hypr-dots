import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Hyprland

PanelWindow {
    id: panel

    // --- Anchor Configuration ---
    anchors {
        left: true
        top: true
        right: true
    }

    implicitHeight: 50 // Slightly taller panel for M3 aesthetic

    // --- Date/Time Properties and Logic ---
    property string currentTime: ""

    Timer {
        id: timeUpdater
        interval: 1000 // 1 second
        running: true
        repeat: true
        onTriggered: {
            var now = new Date();
            // Format: Month Day, Year | H:MM:SS AM/PM (e.g., Oct 31, 2025 | 10:24:48 PM)
            currentTime = Qt.formatDate(now, "MMM d, yy | ") + Qt.formatTime(now, "h:mm:ss AP"); // now.getHours() + " : " + now.getMinutes() 
        }
    }
    Component.onCompleted: {
        timeUpdater.triggered();
    }
    // -----------------------------------------------------------------

    Rectangle {
        id: bar
        anchors.fill: parent

        // M3 Color: Surface Container (The main background color)
        color: "#1C1B1F"
        radius: 0
        border.width: 0 // No border for a cleaner M3 look

        Row {
            id: workspacesrow

            // Workspaces on the Left (Material padding)
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 12
            }
            spacing: 8

            Repeater {
                model: Hyprland.workspaces

                Rectangle {
                    width: 30 // Wider button
                    height: 30 // Taller button
                    radius: 100 // M3 rounded corners

                    // M3 Color: Primary Container for active, Surface Container Low for inactive
                    color: modelData.active ? "#EADDFF" : "#201F24"
                    border.width: 0 // No borders

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch("workspace " + modelData.id)
                    }

                    Text {
                        // M3 Color: On Primary Container for active, On Surface for inactive
                        text: modelData.id
                        anchors.centerIn: parent
                        color: modelData.active ? "#21005D" : "#E6E1E5"
                        font.pixelSize: 14 // Slightly larger font
                        font.family: "Roboto, sans-serif" // Roboto or Inter for M3 feel
                    }
                }
            }

            Text {
                visible: Hyprland.workspaces.length === 0
                text: "No workspaces"
                color: "#E6E1E5" // M3 On Surface
                font.pixelSize: 14
            }
        }

        // ---------------- Date and Time Widget (Far Right) ----------------
        Text {
            id: timeDisplay

            text: panel.currentTime

            // Anchors to place it on the far right (Material padding)
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 12
            }

            // M3 Color: On Surface
            color: "#E6E1E5"
            font.pixelSize: 14
            font.family: "Roboto, sans-serif"
        }
    }
}
