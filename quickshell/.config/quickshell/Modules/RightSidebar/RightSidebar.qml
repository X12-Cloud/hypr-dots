import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications 0.0

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
    width: 360
    color: "transparent" // "#1C1C1E"
    visible: true

    //mask: sidebarContent.x < 360 ? sidebarContent : null

    property bool active: false

    Rectangle {
        id: sidebarContent
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width
        color: "#1C1C1E"
        radius: 30
        x: sidebar.active ? 0 : sidebar.width

        Behavior on x {
            NumberAnimation {
                duration: 500
                easing.type: Easing.OutBack
                easing.overshoot: 0.5
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16
            NotificationList { id: notifCard }
            QuickSettings { id: settingsCard }
        }
    }
}
