import QtQuick
import Quickshell
import QtQuick.Controls


PanelWindow {
    id: sidebar
    anchors.right: true
    anchors.top: true
    anchors.bottom: true
    width: 320
    color: "#1C1B1F"
    visible: false

    // Animate opacity
    Behavior on visible {
        NumberAnimation { duration: 200 }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        Text { text: "Notifications"; color: "white"; font.pixelSize: 20 }
        Rectangle { width: parent.width; height: 1; color: "#444" }

        Repeater {
            model: 3
            Rectangle {
                width: parent.width
                height: 60
                radius: 12
                color: "#2A292E"

                Text {
                    anchors.centerIn: parent
                    color: "#ddd"
                    text: "Notification " + (index + 1)
                }
            }
        }
    }
}

