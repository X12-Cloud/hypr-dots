import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "./../../"

Item {
    id: utilsCard

    property var shellContext: null

    Procs { id: sysProcs }

    ScrollView {
        id: scroll
        anchors.fill: parent
        clip: true

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        ColumnLayout {
            width: scroll.availableWidth
            spacing: 10

            Text {
                text: "System Analytics"
                color: utilsCard.shellContext ? utilsCard.shellContext.textPrimary : "#E6E1E5"
                font.pointSize: 14
                font.weight: Font.DemiBold
                Layout.bottomMargin: 2
            }

            // --- CPU Card ---
            Rectangle {
                id: cpuCard
                Layout.fillWidth: true
                Layout.preferredHeight: cpuMouse.containsMouse ? 94 : 56
                radius: 16
                color: cpuMouse.containsMouse 
                    ? (utilsCard.shellContext ? utilsCard.shellContext.borderPill : "#252528") 
                    : (utilsCard.shellContext ? utilsCard.shellContext.surfacePill : "#1C1C1E")
                clip: true 

                Behavior on Layout.preferredHeight { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 150 } }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Text { 
                            text: "memory"
                            font.family: "Material Symbols Rounded"
                            font.pointSize: 20
                            color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#8AB4F8"
                        }

                        Text { 
                            text: "CPU"
                            color: utilsCard.shellContext ? utilsCard.shellContext.textPrimary : "#E6E1E5"
                            font.pointSize: 11
                            font.weight: Font.Medium 
                        }
                        Item { Layout.fillWidth: true }
                        Text { 
                            text: Math.round(sysProcs.cpuUsage) + "%"
                            color: utilsCard.shellContext ? utilsCard.shellContext.textPrimary : "#E6E1E5"
                            font.pointSize: 11
                            font.bold: true 
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        opacity: cpuMouse.containsMouse ? 1.0 : 0.0
                        visible: opacity > 0.0
                        Behavior on opacity { NumberAnimation { duration: 120 } }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 5
                            radius: 2.5
                            color: utilsCard.shellContext ? utilsCard.shellContext.bgBase : "#161618"

                            Rectangle {
                                width: (sysProcs.cpuUsage / 100) * parent.width
                                height: parent.height
                                radius: 2.5
                                color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#8AB4F8"
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { 
                                text: "Clock Speed: " + (sysProcs.cpuFreq ? sysProcs.cpuFreq : "Dynamic") 
                                color: utilsCard.shellContext ? utilsCard.shellContext.textMuted : "#CAC4D0"
                                font.pointSize: 9
                            }
                            Item { Layout.fillWidth: true }
                            Text { 
                                text: "Load Avg: " + (sysProcs.loadAvg ? sysProcs.loadAvg : "Nominal")
                                color: utilsCard.shellContext ? utilsCard.shellContext.textMuted : "#CAC4D0"
                                font.pointSize: 9
                            }
                        }
                    }
                }
                MouseArea { id: cpuMouse; anchors.fill: parent; hoverEnabled: true }
            }

            // --- RAM Card ---
            Rectangle {
                id: memCard
                Layout.fillWidth: true
                Layout.preferredHeight: memMouse.containsMouse ? 94 : 56
                radius: 16
                color: memMouse.containsMouse 
                    ? (utilsCard.shellContext ? utilsCard.shellContext.borderPill : "#252528") 
                    : (utilsCard.shellContext ? utilsCard.shellContext.surfacePill : "#1C1C1E")
                clip: true

                Behavior on Layout.preferredHeight { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 150 } }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Text { 
                            text: "memory_alt"
                            font.family: "Material Symbols Rounded"
                            font.pointSize: 20
                            color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#8AB4F8"
                        }

                        Text { 
                            text: "RAM"
                            color: utilsCard.shellContext ? utilsCard.shellContext.textPrimary : "#E6E1E5"
                            font.pointSize: 11
                            font.weight: Font.Medium 
                        }
                        Item { Layout.fillWidth: true }
                        Text { 
                            text: Math.round(sysProcs.memUsage) + "%"
                            color: utilsCard.shellContext ? utilsCard.shellContext.textPrimary : "#E6E1E5"
                            font.pointSize: 11
                            font.bold: true 
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        opacity: memMouse.containsMouse ? 1.0 : 0.0
                        visible: opacity > 0.0
                        Behavior on opacity { NumberAnimation { duration: 120 } }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 5
                            radius: 2.5
                            color: utilsCard.shellContext ? utilsCard.shellContext.bgBase : "#161618"

                            Rectangle {
                                width: (sysProcs.memUsage / 100) * parent.width
                                height: parent.height
                                radius: 2.5
                                color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#8AB4F8"
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { 
                                text: "Available Cache: " + (sysProcs.memBuffers ? sysProcs.memBuffers : "Optimized")
                                color: utilsCard.shellContext ? utilsCard.shellContext.textMuted : "#CAC4D0"
                                font.pointSize: 9
                            }
                            Item { Layout.fillWidth: true }
                            Text { 
                                text: "Swap Use: " + (sysProcs.swapUsage ? sysProcs.swapUsage + "%" : "0%")
                                color: utilsCard.shellContext ? utilsCard.shellContext.textMuted : "#CAC4D0"
                                font.pointSize: 9
                            }
                        }
                    }
                }
                MouseArea { id: memMouse; anchors.fill: parent; hoverEnabled: true }
            }

            // --- Temp Card ---
            Rectangle {
                id: tempCard
                Layout.fillWidth: true
                Layout.preferredHeight: tempMouse.containsMouse ? 94 : 56
                radius: 16
                color: tempMouse.containsMouse 
                    ? (utilsCard.shellContext ? utilsCard.shellContext.borderPill : "#252528") 
                    : (utilsCard.shellContext ? utilsCard.shellContext.surfacePill : "#1C1C1E")
                clip: true

                Behavior on Layout.preferredHeight { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 150 } }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Text { 
                            text: "device_thermostat"
                            font.family: "Material Symbols Rounded"
                            font.pointSize: 20
                            color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#8AB4F8"
                        }

                        Text { 
                            text: "Thermal Status"
                            color: utilsCard.shellContext ? utilsCard.shellContext.textPrimary : "#E6E1E5"
                            font.pointSize: 11
                            font.weight: Font.Medium 
                        }
                        Item { Layout.fillWidth: true }
                        Text { 
                            text: Math.round(sysProcs.cpuTemp) + "°C"
                            color: utilsCard.shellContext ? utilsCard.shellContext.textPrimary : "#E6E1E5"
                            font.pointSize: 11
                            font.bold: true 
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        opacity: tempMouse.containsMouse ? 1.0 : 0.0
                        visible: opacity > 0.0
                        Behavior on opacity { NumberAnimation { duration: 120 } }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 5
                            radius: 2.5
                            color: utilsCard.shellContext ? utilsCard.shellContext.bgBase : "#161618"

                            Rectangle {
                                width: Math.min((sysProcs.cpuTemp / 100), 1) * parent.width
                                height: parent.height
                                radius: 2.5
                                color: sysProcs.cpuTemp > 75 
                                    ? (utilsCard.shellContext ? utilsCard.shellContext.errorAccent : "#FFB4AB") 
                                    : (utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#8AB4F8")
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { 
                                text: "Governor: " + (sysProcs.cpuGovernor ? sysProcs.cpuGovernor : "Performance")
                                color: utilsCard.shellContext ? utilsCard.shellContext.textMuted : "#CAC4D0"
                                font.pointSize: 9
                            }
                            Item { Layout.fillWidth: true }
                            Text { 
                                text: sysProcs.cpuTemp > 80 ? "Throttling Risk" : "Stable"
                                color: sysProcs.cpuTemp > 80 
                                    ? (utilsCard.shellContext ? utilsCard.shellContext.errorAccent : "#FFB4AB") 
                                    : (utilsCard.shellContext ? utilsCard.shellContext.textMuted : "#CAC4D0")
                                font.pointSize: 9
                                font.weight: sysProcs.cpuTemp > 80 ? Font.Bold : Font.Normal
                            }
                        }
                    }
                }
                MouseArea { id: tempMouse; anchors.fill: parent; hoverEnabled: true }
            }

            // --- Storage Card ---
            Rectangle {
                id: diskCard
                Layout.fillWidth: true
                Layout.preferredHeight: diskMouse.containsMouse ? 94 : 56
                radius: 16
                color: diskMouse.containsMouse 
                    ? (utilsCard.shellContext ? utilsCard.shellContext.borderPill : "#252528") 
                    : (utilsCard.shellContext ? utilsCard.shellContext.surfacePill : "#1C1C1E")
                clip: true

                Behavior on Layout.preferredHeight { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                Behavior on color { ColorAnimation { duration: 150 } }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 14
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Text { 
                            text: "hard_drive"
                            font.family: "Material Symbols Rounded"
                            font.pointSize: 20
                            color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#8AB4F8"
                        }

                        Text { 
                            text: "Storage Pool"
                            color: utilsCard.shellContext ? utilsCard.shellContext.textPrimary : "#E6E1E5"
                            font.pointSize: 11
                            font.weight: Font.Medium 
                        }
                        Item { Layout.fillWidth: true }
                        Text { 
                            text: Math.round(sysProcs.diskUsage) + "%"
                            color: utilsCard.shellContext ? utilsCard.shellContext.textPrimary : "#E6E1E5"
                            font.pointSize: 11
                            font.bold: true 
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6
                        opacity: diskMouse.containsMouse ? 1.0 : 0.0
                        visible: opacity > 0.0
                        Behavior on opacity { NumberAnimation { duration: 120 } }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 5
                            radius: 2.5
                            color: utilsCard.shellContext ? utilsCard.shellContext.bgBase : "#161618"

                            Rectangle {
                                width: (sysProcs.diskUsage / 100) * parent.width
                                height: parent.height
                                radius: 2.5
                                color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#8AB4F8"
                            }
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Text { 
                                text: "I/O State: " + (sysProcs.diskIO ? sysProcs.diskIO : "Idle")
                                color: utilsCard.shellContext ? utilsCard.shellContext.textMuted : "#CAC4D0"
                                font.pointSize: 9
                            }
                            Item { Layout.fillWidth: true }
                            Text { 
                                text: "Mount: " + (sysProcs.diskMountPoint ? sysProcs.diskMountPoint : "[ / ]")
                                color: utilsCard.shellContext ? utilsCard.shellContext.textMuted : "#CAC4D0"
                                font.pointSize: 9
                            }
                        }
                    }
                }
                MouseArea { id: diskMouse; anchors.fill: parent; hoverEnabled: true }
            }
        }
    }
}
