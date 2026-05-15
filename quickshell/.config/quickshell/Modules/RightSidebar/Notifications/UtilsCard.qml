import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../"

Item {
    id: utilsCard
    Procs { id: sysProcs }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        Text {
            text: "System Status"
            color: "#E6E1E5"
            font.pointSize: 16
            font.weight: Font.Medium
        }

        GridLayout {
            columns: 2
            rows: 2
            rowSpacing: 12
            columnSpacing: 12
            Layout.fillWidth: true
            Layout.fillHeight: true

            // --- CPU Card ---
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 16
                color: "#3A3A3C"
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Text { text: "󰻠"; font.pointSize: 24; color: "#D6BEFA"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "CPU"; color: "#CAC4D0"; font.pointSize: 10; Layout.alignment: Qt.AlignHCenter }
                    Text { 
                        text: sysProcs.cpuUsage + "%"
                        color: "white"; font.pointSize: 14; font.bold: true
                        Layout.alignment: Qt.AlignHCenter 
                    }
                }
            }

            // --- RAM Card ---
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 16
                color: "#3A3A3C"
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Text { text: "󰍛"; font.pointSize: 24; color: "#D6BEFA"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "RAM"; color: "#CAC4D0"; font.pointSize: 10; Layout.alignment: Qt.AlignHCenter }
                    Text { 
                        text: sysProcs.memUsage + "%"
                        color: "white"; font.pointSize: 14; font.bold: true
                        Layout.alignment: Qt.AlignHCenter 
                    }
                }
            }

            // --- Temp Card ---
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 16
                color: "#3A3A3C"
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Text { text: "󰏈"; font.pointSize: 24; color: "#D6BEFA"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Temp"; color: "#CAC4D0"; font.pointSize: 10; Layout.alignment: Qt.AlignHCenter }
                    Text { 
                        text: sysProcs.cpuTemp + "°C"
                        color: "white"; font.pointSize: 14; font.bold: true
                        Layout.alignment: Qt.AlignHCenter 
                    }
                }
            }

            // --- Storage Card ---
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 16
                color: "#3A3A3C"
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Text { text: "󰋊"; font.pointSize: 24; color: "#D6BEFA"; Layout.alignment: Qt.AlignHCenter }
                    Text { text: "Disk"; color: "#CAC4D0"; font.pointSize: 10; Layout.alignment: Qt.AlignHCenter }
                    Text { 
                        text: sysProcs.diskUsage + "%"
                        color: "white"; font.pointSize: 14; font.bold: true
                        Layout.alignment: Qt.AlignHCenter 
                    }
                }
            }
        }

        Item { Layout.preferredHeight: 10 }
    }
}
