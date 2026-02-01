import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications

PanelWindow {
    id: sidebar
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.margins.top: 45 
    anchors.right: true
    anchors.top: true
    anchors.bottom: true
    width: 360
    color: "#1C1C1E"
    visible: false

    Behavior on visible { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

Process { 
    id: wifiToggle
    command: ["/bin/sh", "-c", "nmcli radio wifi | grep -q enabled && nmcli radio wifi off || nmcli radio wifi on"] 
}

Process { 
    id: btToggle
    command: ["/bin/sh", "-c", "bluetoothctl show | grep -q 'Powered: yes' && bluetoothctl power off || bluetoothctl power on"] 
}

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // Notifications Card
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 450
            radius: 28
            color: "#2C2C2E"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                Text {
                    text: "Notifications"
                    color: "#E6E1E5"
                    font.pointSize: 22
                    font.family: "sans-serif"
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    ListView {
                        id: notifView
                        model: Notifications.notifications
                        spacing: 12
                        delegate: Rectangle {
                            width: notifView.width
                            height: 72
                            radius: 12
                            color: "#3A3A3C"

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 16
                                Text { text: "◆"; color: "#CAC4D0"; font.pointSize: 24 }
                                ColumnLayout {
                                    spacing: 2
                                    Text { text: model.summary; color: "#E6E1E5"; font.pointSize: 14; font.weight: Font.Medium; elide: Text.ElideRight }
                                    Text { text: model.body; color: "#CAC4D0"; font.pointSize: 12; elide: Text.ElideRight; Layout.fillWidth: true }
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 28
            color: "#2C2C2E"

            GridLayout {
                anchors.fill: parent
                anchors.margins: 24
                columns: 2
                rowSpacing: 16
                columnSpacing: 16

                // Wifi Button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    radius: 20
                    color: "#3A3A3C"
                    
                    ColumnLayout {
                        anchors.centerIn: parent
                        Text { text: "󰖩"; color: "#E6E1E5"; font.pointSize: 24; Layout.alignment: Qt.AlignCenter }
                        Text { text: "WiFi"; color: "#CAC4D0"; font.pointSize: 11; Layout.alignment: Qt.AlignCenter }
                    }

                    MouseArea {
			anchors.fill: parent
		        hoverEnabled: true
    		        cursorShape: Qt.PointingHandCursor
                        onClicked: wifiToggle.run()
                    }
                }

                // Bluetooth Button
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
                    radius: 20
                    color: "#3A3A3C"

                    ColumnLayout {
                        anchors.centerIn: parent
                        Text { text: "󰂯"; color: "#E6E1E5"; font.pointSize: 24; Layout.alignment: Qt.AlignCenter }
                        Text { text: "BT"; color: "#CAC4D0"; font.pointSize: 11; Layout.alignment: Qt.AlignCenter }
                    }

                    MouseArea {
			anchors.fill: parent
		        hoverEnabled: true
    		        cursorShape: Qt.PointingHandCursor
                        onClicked: btToggle.run()
                    }
                }
            }
        }
    }
}
