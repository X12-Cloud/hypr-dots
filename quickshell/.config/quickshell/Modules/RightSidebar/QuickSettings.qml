import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: 28
    color: "#2C2C2E"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 24

        GridLayout {
            columns: 2
            rowSpacing: 12
            columnSpacing: 12
            Layout.fillWidth: true

            // Shared component for buttons to avoid repetition
            component ToggleButton : Rectangle {
                property string icon: ""
                property string label: ""
                property bool isActive: false
                property var onTrigger: null

                Layout.fillWidth: true
                Layout.preferredHeight: 85
                radius: 20
                color: mouse.containsMouse ? "#4A4A4C" : "#3A3A3C"
                Behavior on color { ColorAnimation { duration: 150 } }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Text {
                        text: parent.parent.icon
                        color: parent.parent.isActive ? "#D6BEFA" : "#E6E1E5"
                        font.pointSize: 22
                        Layout.alignment: Qt.AlignCenter 
                    }
                    Text {
                        text: parent.parent.label
                        color: "#CAC4D0"
                        font.pointSize: 10
                        font.weight: Font.Medium
                        Layout.alignment: Qt.AlignCenter 
                    }
                }

                MouseArea {
                    id: mouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: if (parent.onTrigger) parent.onTrigger()
                }
            }

            ToggleButton {
                icon: "󰖩"
                label: "WiFi" // TODO: make it show the curent network ur connected to
                isActive: wifiToggle.running
                onTrigger: () => { wifiToggle.running = true }
            }

            ToggleButton {
                icon: "󰂯"
                label: "BT"
                onTrigger: () => { btManager.running = true }
            }
        }

        // Volume control
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 12

            RowLayout {
                Text { text: "󰕾"; color: "#D6BEFA"; font.pointSize: 18 }
                Text { text: "Volume"; color: "#E6E1E5"; font.pointSize: 12; font.weight: Font.DemiBold }
                Item { Layout.fillWidth: true }
                Text { text: Math.round(volSlider.value * 100) + "%"; color: "#CAC4D0"; font.pointSize: 11 }
            }

            Slider {
                id: volSlider
                Layout.fillWidth: true
                from: 0
                to: 1
                value: 0.5 // TODO: fetch initial volume with a process on start

                background: Rectangle {
                    x: volSlider.leftPadding
                    y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 12
                    width: volSlider.availableWidth
                    height: implicitHeight
                    radius: 6
                    color: "#3A3A3C"

                    Rectangle {
                        width: volSlider.visualPosition * parent.width
                        height: parent.height
                        color: "#D6BEFA"
                        radius: 6
                    }
                }

                handle: Rectangle {
                    x: volSlider.leftPadding + volSlider.visualPosition * (volSlider.availableWidth - width)
                    y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                    implicitWidth: 20
                    implicitHeight: 20
                    radius: 10
                    color: volSlider.pressed ? "#FFFFFF" : "#E6E1E5"
                    border.color: "#D6BEFA"
                    border.width: 2

                    Behavior on scale { NumberAnimation { duration: 100 } }
                    scale: volSlider.hovered ? 1.2 : 1.0
                }

                onValueChanged: {
                    if (pressed) {
                        volumeSetter.updateVol(value.toFixed(2))
                    }
                }
            }
        }
    }
}
