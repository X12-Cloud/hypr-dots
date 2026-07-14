import QtQuick
import QtQuick.Window
import Quickshell
import Quickshell.Hyprland
import "./../"

PanelWindow {
    id: panel
    anchors { left: true; top: true; right: true }
    implicitHeight: 45
    color: "transparent"
    property var shellContext: null

    Procs { id: localProcs }

    // ---------------- Date/Time Logic ----------------
    property string currentTimeDate: ""
    property string currentTimeClock: ""

    Timer {
        id: timeUpdater
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var now = new Date();
            currentTimeDate = Qt.formatDate(now, "MMM d, yy");
            currentTimeClock = Qt.formatTime(now, "h:mm:ss AP");
        }
    }
    Component.onCompleted: timeUpdater.triggered()

    // ------------------- Main Bar --------------------
    Rectangle {
        id: bar
        anchors.fill: parent

        color: shellContext ? shellContext.bgBase : "#161618"
        clip: true
        radius: 30

        border.color: shellContext ? shellContext.borderPill : "#252528"
        border.width: 1

        anchors.topMargin: 3
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 0

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
                    width: modelData.active ? 32 : 28 

                    color: modelData.active 
                           ? (panel.shellContext ? panel.shellContext.accentNormal : "#8AB4F8")
                           : (panel.shellContext ? panel.shellContext.surfacePill : "#1C1C1E")

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

                        color: modelData.active 
                               ? (panel.shellContext ? panel.shellContext.bgBase : "#161618") 
                               : (panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5")

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
                color: panel.shellContext ? panel.shellContext.textMuted : "#CAC4D0"
                font.pixelSize: 14
            }
        }

        // ---------------- System Status Clusters (Far Right) ----------------
        Row {
            id: systemControlsGroup
            spacing: 8
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 12
            }

            // Clock/Date Capsule
            Rectangle {
                id: timeContainer
                radius: 30
                height: 32
                color: shellContext ? shellContext.surfacePill : "#1C1C1E"
                border.color: shellContext ? shellContext.borderPill : "#252528"
                border.width: 1
                width: timeLayout.implicitWidth + 24

                Row {
                    id: timeLayout
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        text: panel.currentTimeDate
                        color: panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5"
                        font.pixelSize: 14
                        font.family: "Inter, Roboto, sans-serif"
                        font.weight: Font.Medium
                    }
                    Text {
                        text: "|"
                        color: panel.shellContext ? panel.shellContext.borderPill : "#252528"
                        font.pixelSize: 14
                        font.family: "Inter, Roboto, sans-serif"
                    }
                    Text {
                        text: panel.currentTimeClock
                        color: panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5"
                        font.pixelSize: 14
                        font.family: "Inter, Roboto, sans-serif"
                        font.weight: Font.Medium
                    }
                }
            }

            // Status Tray
            Rectangle {
                id: statusTrayContainer
                radius: 30
                height: 32

                color: sideBarMouse.containsMouse 
                       ? (shellContext ? shellContext.borderPill : "#252528") 
                       : (shellContext ? shellContext.surfacePill : "#1C1C1E")

                border.color: shellContext ? shellContext.borderPill : "#252528"
                border.width: 1

                Behavior on color { ColorAnimation { duration: 150 } }
                width: statusTrayLayout.implicitWidth + 24

                MouseArea {
                    id: sideBarMouse
                    anchors.fill: parent
                    onClicked: rightSidebar.active = !rightSidebar.active
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }

                Row {
                    id: statusTrayLayout
                    anchors.centerIn: parent
                    spacing: 12

                    // WiFi Icon
                    Text {
                        font.family: "Material Symbols Rounded"
                        text: localProcs.currentSsid !== "No WiFi" ? "\ue63e" : "\ue642"
                        font.pixelSize: 16

                        // Turns textMuted when disconnected
                        color: localProcs.currentSsid !== "No WiFi" 
                               ? (panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5") 
                               : (panel.shellContext ? panel.shellContext.textMuted : "#CAC4D0")
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Bluetooth Icon
                    Text {
                        font.family: "Material Symbols Rounded"
                        text: localProcs.currentBtDevice !== "Disconnected" ? "\ue1a7" : "\ue1a9"
                        font.pixelSize: 16
                        color: localProcs.currentBtDevice !== "Disconnected" 
                               ? (panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5") 
                               : (panel.shellContext ? panel.shellContext.textMuted : "#CAC4D0")
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // Volume Block (Icon + Percentage)
                    Row {
                        spacing: 4
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            font.family: "Material Symbols Rounded"
                            text: localProcs.currentVolume === 0 ? "\ue04f" : (localProcs.currentVolume < 0.4 ? "\ue04d" : "\ue050")
                            font.pixelSize: 16
                            color: panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            text: Math.round(localProcs.currentVolume * 100) + "%"
                            color: panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5"
                            font.pixelSize: 12
                            font.family: "Inter, Roboto, sans-serif"
                            font.weight: Font.Medium
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }

        // ---------------- Media Capsule (Far Left) ----------------
        Rectangle {
            id: mediaBar
            radius: 30
            height: 32
            color: shellContext ? shellContext.surfacePill : "#1C1C1E"
            border.color: shellContext ? shellContext.borderPill : "#252528"
            border.width: 1
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 12
            }
            width: 200
            visible: true

            MouseArea {
                anchors.fill: parent
                onClicked: mediaPlayerBig.active = !mediaPlayerBig.active
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
            }

            Text {
                id: mediaContent
                text: localProcs.isPlaying ? localProcs.trackTitle : "Nothing Playing"
                anchors.centerIn: parent
                width: parent.width - 24
                horizontalAlignment: Text.AlignHCenter

                // Media title highlighted with accentNormal if active, else textPrimary
                color: localProcs.isPlaying 
                       ? (panel.shellContext ? panel.shellContext.accentNormal : "#8AB4F8") 
                       : (panel.shellContext ? panel.shellContext.textMuted : "#CAC4D0")

                font.pixelSize: 14
                elide: Text.ElideRight
                font.family: "Inter, Roboto, sans-serif"
            }
        }
    }
}
