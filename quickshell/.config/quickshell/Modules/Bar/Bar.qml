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
            currentTimeDate = Qt.formatDate(now, "ddd, d/MM");
            currentTimeClock = Qt.formatTime(now, "h:mm AP");
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

        // ---------------- Arch Logo (Far Left) ----------------
        Rectangle {
            id: archLogoContainer
            radius: 15
            height: 32
            width: 36
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 12
            }

            color: archMouse.containsMouse ? (shellContext ? shellContext.surfacePill : "#1C1C1E") : "transparent"
            Behavior on color { ColorAnimation { duration: 150 } }

            MouseArea {
                id: archMouse
                anchors.fill: parent
                onClicked: {
                    shellContext.createLauncher()
                }
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
            }

            Text {
                id: archIcon
                anchors.centerIn: parent
                font.family: "JetBrainsMono Nerd Font, Inter, sans-serif"
                text: "\uf303" 
                font.pixelSize: 16

                // Uses the accent color if hovering
                color: archMouse.containsMouse
                        ? (panel.shellContext ? panel.shellContext.accentNormal : "#8AB4F8")
                        : (panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5")

                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }

        // ------------- Center Layout -------------
        Row {
            id: centerLayoutGroup
            anchors.centerIn: parent
            spacing: 5

            // Media Capsule
            Rectangle {
                id: mediaBar
                radius: 14
                height: 32
                color: shellContext ? shellContext.surfacePill : "#1C1C1E"
                width: 200
                visible: true

                MouseArea {
                    anchors.fill: parent
                    onClicked: mediaPlayerSmall.active = !mediaPlayerSmall.active
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }

                Row {
                    id: mediaLayout
                    anchors.centerIn: parent
                    width: parent.width - 20
                    spacing: 12

                    Rectangle {
                        id: iconBg
                        width: 24
                        height: 24
                        radius: 999
                        anchors.verticalCenter: parent.verticalCenter

                        color: panel.shellContext 
                               ? (panel.shellContext.bgBase.hslLightness < 0.5
                                   ? Qt.lighter(panel.shellContext.bgBase, 1.2)
                                   : Qt.darker(panel.shellContext.bgBase, 1.1))
                               : "#252528"

                        Behavior on color { ColorAnimation { duration: 200 } }

                        Text {
                            id: mediaIcon
                            anchors.centerIn: parent
                            font.family: "Material Symbols Rounded"
                            text: "\ue405"
                            font.pixelSize: 14

                            color: localProcs.isPlaying 
                                    ? (panel.shellContext ? panel.shellContext.accentNormal : "#8AB4F8") 
                                    : (panel.shellContext ? panel.shellContext.textMuted : "#CAC4D0")
                        }
                    }

                    Text {
                        id: mediaContent
                        text: localProcs.isPlaying ? localProcs.trackTitle : "Nothing Playing"
                        anchors.verticalCenter: parent.verticalCenter

                        width: parent.width - iconBg.width - parent.spacing

                        color: localProcs.isPlaying 
                               ? (panel.shellContext ? panel.shellContext.accentNormal : "#8AB4F8") 
                               : (panel.shellContext ? panel.shellContext.textMuted : "#CAC4D0")

                        font.pixelSize: 13
                        elide: Text.ElideRight
                        font.family: "Inter, Roboto, sans-serif"
                        font.weight: Font.Medium
                    }
                }
            }

            // Workspace Container
            Rectangle {
                id: workspaceCapsule
                height: 32
                width: workspacesRow.width + 20
                radius: 14

                color: panel.shellContext 
                       ? (panel.shellContext.bgBase.hslLightness < 0.5
                           ? Qt.lighter(panel.shellContext.bgBase, 1.25)
                           : Qt.darker(panel.shellContext.bgBase, 1.15))
                       : "#1C1C1E"

                border.color: panel.shellContext ? panel.shellContext.borderPill : "#252528"
                border.width: 0

                Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 200 } }

                Row {
                    id: workspacesRow
                    anchors.centerIn: parent
                    spacing: 8

                    Repeater {
                        model: panel.shellContext && panel.shellContext.workspaceCount !== undefined 
                               ? panel.shellContext.workspaceCount 
                               : 9

                        Rectangle {
                            id: pill

                            property int wsId: index + 1
                            property var ws: Hyprland.workspaces.values.find(function(w) { return w.id === wsId })

                            property bool isOccupied: ws !== undefined
                            property bool isActive: ws ? ws.active : false

                            radius: 15
                            height: 26
                            width: 26

                            color: isActive 
                                   ? (panel.shellContext ? panel.shellContext.accentNormal : "#8AB4F8")
                                   : (panel.shellContext ? panel.shellContext.surfacePill : "#1C1C1E")

                            opacity: isActive ? 1.0 : (isOccupied ? 0.8 : 0.35)
                            scale: isActive ? 1.12 : 1.0
                            border.width: 0

                            Behavior on color { ColorAnimation { duration: 200; easing.type: Easing.OutCubic } }
                            Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack } }
                            Behavior on opacity { NumberAnimation { duration: 180 } }

                            MouseArea {
                                id: workspaceMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Hyprland.dispatch('workspace ${wsId}')
                            }

                            Text {
                                anchors.centerIn: parent
                                text: isActive ? wsId : "•"

                                color: isActive 
                                       ? (panel.shellContext ? panel.shellContext.bgBase : "#161618") 
                                       : (panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5")

                                font.pixelSize: isActive ? 13 : 18
                                font.family: "Inter, Roboto, sans-serif"

                                opacity: isActive || isOccupied ? 1.0 : 0.5
                                Behavior on opacity { NumberAnimation { duration: 180 } }
                            }
                        }
                    }

                    Text {
                        visible: Hyprland.workspaces.length === 0
                        text: "No workspaces"
                        color: panel.shellContext ? panel.shellContext.textMuted : "#CAC4D0"
                        font.pixelSize: 14
                    }
                }
            }

            // Unified Clock, Date & Utility Capsule
            Rectangle {
                id: timeContainer
                radius: 14
                height: 32
                color: shellContext ? shellContext.surfacePill : "#1C1C1E"
                width: timeLayout.implicitWidth + 24

                Row {
                    id: timeLayout
                    anchors.centerIn: parent
                    spacing: 12

                    Row {
                        spacing: 8
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            text: panel.currentTimeClock
                            color: panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5"
                            font.pixelSize: 14
                            font.family: "Inter, Roboto, sans-serif"
                            font.weight: Font.Medium
                        }
                        Text {
                            text: "•"
                            color: panel.shellContext ? panel.shellContext.textMuted : "#CAC4D0"
                            font.pixelSize: 14
                            font.family: "Inter, Roboto, sans-serif"
                        }
                        Text {
                            text: panel.currentTimeDate
                            color: panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5"
                            font.pixelSize: 14
                            font.family: "Inter, Roboto, sans-serif"
                            font.weight: Font.Medium
                        }
                    }

                    Item {
                        width: 12
                        height: 1
                    }

                    // --- SCREENSHOT BUTTON ---
                    Text {
                        id: screenshotBtn
                        font.family: "Material Symbols Rounded"
                        text: "\ue412"
                        font.pixelSize: 16
                        color: screenshotMouse.containsMouse 
                               ? (panel.shellContext ? panel.shellContext.accentNormal : "#8AB4F8")
                               : (panel.shellContext ? panel.shellContext.textMuted : "#CAC4D0")
                        anchors.verticalCenter: parent.verticalCenter

                        Behavior on color { ColorAnimation { duration: 150 } }

                        MouseArea {
                            id: screenshotMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                // Triggers the grim | satty | wl-copy process defined in Procs.qml
                                localProcs.run(localProcs.screenshotSelect);
                            }
                        }
                    }

                    // --- BRIGHTNESS BUTTON ---
                   Text {
                        id: brightnessBtn
                        font.family: "Material Symbols Rounded"
                        text: "\ue518"
                        font.pixelSize: 16
                        color: brightnessMouse.containsMouse 
                               ? (panel.shellContext ? panel.shellContext.accentNormal : "#8AB4F8")
                               : (panel.shellContext ? panel.shellContext.textMuted : "#CAC4D0")
                        anchors.verticalCenter: parent.verticalCenter

                        Behavior on color { ColorAnimation { duration: 150 } }

                        MouseArea {
                            id: brightnessMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            acceptedButtons: Qt.LeftButton | Qt.RightButton

                            onClicked: (mouse) => {
                                if (mouse.button === Qt.LeftButton) {
                                    localProcs.brightnessUp();
                                } else if (mouse.button === Qt.RightButton) {
                                    localProcs.brightnessDown();
                                }
                            }

                            onWheel: (wheel) => {
                                if (wheel.angleDelta.y > 0) {
                                    localProcs.brightnessUp();
                                } else if (wheel.angleDelta.y < 0) {
                                    localProcs.brightnessDown();
                                }
                            }
                        }
                    }
                }
            }
        }

        // ---------------- Status Tray (Far Right) ----------------
        Rectangle {
            id: statusTrayContainer
            radius: 15
            height: 32
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: 12
            }

            color: sideBarMouse.containsMouse ? (shellContext ? shellContext.surfacePill : "#1C1C1E") : "transparent"

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

                Text {
                    font.family: "Material Symbols Rounded"
                    text: localProcs.currentSsid !== "No WiFi" ? "\ue63e" : "\ue642"
                    font.pixelSize: 16

                    color: localProcs.currentSsid !== "No WiFi" 
                           ? (panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5")
                           : (panel.shellContext ? panel.shellContext.textMuted : "#CAC4D0")
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    font.family: "Material Symbols Rounded"
                    text: localProcs.currentBtDevice !== "Disconnected" ? "\ue1a7" : "\ue1a9"
                    font.pixelSize: 16
                    color: localProcs.currentBtDevice !== "Disconnected" 
                           ? (panel.shellContext ? panel.shellContext.textPrimary : "#E6E1E5") 
                           : (panel.shellContext ? panel.shellContext.textMuted : "#CAC4D0")
                    anchors.verticalCenter: parent.verticalCenter
                }

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
}
