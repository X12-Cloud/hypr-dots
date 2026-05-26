import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "./../../"

Item {
    id: utilsCard

    property var shellContext: null

    Procs { id: sysProcs }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        Text {
            text: "System Analytics"
            color: "#E6E1E5"
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
            color: cpuMouse.containsMouse ? "#424245" : "#323234"
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
                        color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#D6BEFA"
                    }

                    Text { text: "CPU"; color: "#E6E1E5"; font.pointSize: 11; font.weight: Font.Medium }
                    Item { Layout.fillWidth: true }
                    Text { text: Math.round(sysProcs.cpuUsage) + "%"; color: "#E6E1E5"; font.pointSize: 11; font.bold: true }
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
                        color: "#222224"

                        Rectangle {
                            width: (sysProcs.cpuUsage / 100) * parent.width
                            height: parent.height
                            radius: 2.5
                            color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#D6BEFA"
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Text { 
                            text: "Clock Speed: " + (sysProcs.cpuFreq ? sysProcs.cpuFreq : "Dynamic") 
                            color: "#CAC4D0"
                            font.pointSize: 9
                        }
                        Item { Layout.fillWidth: true }
                        Text { 
                            text: "Load Avg: " + (sysProcs.loadAvg ? sysProcs.loadAvg : "Nominal")
                            color: "#CAC4D0"
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
            color: memMouse.containsMouse ? "#424245" : "#323234"
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
                        color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#D6BEFA"
                    }

                    Text { text: "RAM"; color: "#E6E1E5"; font.pointSize: 11; font.weight: Font.Medium }
                    Item { Layout.fillWidth: true }
                    Text { text: Math.round(sysProcs.memUsage) + "%"; color: "#E6E1E5"; font.pointSize: 11; font.bold: true }
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
                        color: "#222224"

                        Rectangle {
                            width: (sysProcs.memUsage / 100) * parent.width
                            height: parent.height
                            radius: 2.5
                            color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#D6BEFA"
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Text { 
                            text: "Available Cache: " + (sysProcs.memBuffers ? sysProcs.memBuffers : "Optimized")
                            color: "#CAC4D0"
                            font.pointSize: 9
                        }
                        Item { Layout.fillWidth: true }
                        Text { 
                            text: "Swap Use: " + (sysProcs.swapUsage ? sysProcs.swapUsage + "%" : "0%")
                            color: "#CAC4D0"
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
            color: tempMouse.containsMouse ? "#424245" : "#323234"
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
                        color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#D6BEFA"
                    }

                    Text { text: "Thermal Status"; color: "#E6E1E5"; font.pointSize: 11; font.weight: Font.Medium }
                    Item { Layout.fillWidth: true }
                    Text { text: Math.round(sysProcs.cpuTemp) + "°C"; color: "#E6E1E5"; font.pointSize: 11; font.bold: true }
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
                        color: "#222224"

                        Rectangle {
                            width: Math.min((sysProcs.cpuTemp / 100), 1) * parent.width
                            height: parent.height
                            radius: 2.5
                            color: sysProcs.cpuTemp > 75 ? "#FF8989" : (utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#D6BEFA")
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Text { 
                            text: "Governor: " + (sysProcs.cpuGovernor ? sysProcs.cpuGovernor : "Performance")
                            color: "#CAC4D0"
                            font.pointSize: 9
                        }
                        Item { Layout.fillWidth: true }
                        Text { 
                            text: sysProcs.cpuTemp > 80 ? "Throttling Risk" : "Stable"
                            color: sysProcs.cpuTemp > 80 ? "#FF8989" : "#CAC4D0"
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
            color: diskMouse.containsMouse ? "#424245" : "#323234"
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
                        color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#D6BEFA"
                    }

                    Text { text: "Storage Pool"; color: "#E6E1E5"; font.pointSize: 11; font.weight: Font.Medium }
                    Item { Layout.fillWidth: true }
                    Text { text: Math.round(sysProcs.diskUsage) + "%"; color: "#E6E1E5"; font.pointSize: 11; font.bold: true }
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
                        color: "#222224"

                        Rectangle {
                            width: (sysProcs.diskUsage / 100) * parent.width
                            height: parent.height
                            radius: 2.5
                            color: utilsCard.shellContext ? utilsCard.shellContext.accentNormal : "#D6BEFA"
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Text { 
                            text: "I/O State: " + (sysProcs.diskIO ? sysProcs.diskIO : "Idle")
                            color: "#CAC4D0"
                            font.pointSize: 9
                        }
                        Item { Layout.fillWidth: true }
                        Text { 
                            text: "Mount: " + (sysProcs.diskMountPoint ? sysProcs.diskMountPoint : "[ / ]")
                            color: "#CAC4D0"
                            font.pointSize: 9
                        }
                    }
                }
            }
            MouseArea { id: diskMouse; anchors.fill: parent; hoverEnabled: true }
        }

        Item { Layout.fillHeight: true }
    }
}
