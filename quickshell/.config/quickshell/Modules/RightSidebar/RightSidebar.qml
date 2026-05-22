import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications 0.0
import "./../"

PanelWindow {
    id: sidebar
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: active ? ExclusionMode.Exclusive : ExclusionMode.Ignore
    WlrLayershell.margins.top: 50
    WlrLayershell.margins.right: 5
    WlrLayershell.margins.bottom: 5
    anchors.right: true
    anchors.top: true
    anchors.bottom: true
    width: 420
    color: "transparent"
    visible: active || sidebarContent.opacity > 0
    mask: Region { item: sidebarContent }

    property bool active: false
    Procs { id: localProcs }

    Rectangle {
        id: sidebarContent
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width
        color: "#1C1C1E"
        radius: 20
        x: sidebar.active ? 0 : sidebar.width

        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutBack
                easing.overshoot: 0.5
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                Layout.leftMargin: 8
                Layout.topMargin: 8
                spacing: 10
                Text {
                    font.family: "Font Awesome 6 Free" // "Material Symbols Rounded"
                    text: "\uf17c"
                    color: "#FFFFFF"
                    font.pointSize: 14
                    Layout.alignment: Qt.AlignVCenter
                }
                Text {
                    text: localProcs.uptime
                    color: "#E6E1E5"
                    font.pointSize: 12
                    font.weight: Font.Bold
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                }
                Item { Layout.fillWidth: true }
                Rectangle {
                    width: 32
                    height: 32
                    radius: 16
                    color: reloadMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : "transparent"
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        anchors.centerIn: parent
                        font.family: "Material Symbols Rounded"
                        text: "\ue5d5"
                        color: "#FFFFFF"
                        font.pointSize: 14
                    }

                    MouseArea {
                        id: reloadMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Quickshell.reload()
                    }
                }
            }
            QuickSettings {
                id: settingsCard
                Layout.fillWidth: true
                Layout.preferredHeight: sidebar.height * 0.16
            }
            MediaPlayer {
                id: mediaPlayerSmall
                Layout.fillWidth: true
                visible: true
            }
            NotificationList {
                id: notifCard
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
