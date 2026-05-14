import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: 28
    color: "#2C2C2E"

    Procs { id: localProcs }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        // Volume control
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            Slider {
                id: volSlider
                Layout.fillWidth: true
                Layout.preferredHeight: 36
                from: 0
                to: 1
                value: localProcs.currentVolume

                background: Rectangle {
                    x: volSlider.leftPadding
                    y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: parent.height
                    width: volSlider.availableWidth
                    height: implicitHeight
                    radius: 12
                    color: "#3A3A3C"

                    Rectangle {
                        width: volSlider.visualPosition * parent.width
                        height: parent.height
                        color: "#D6BEFA"
                        radius: 10
                    }
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 0
                        Text {
                            id: volIcon
                            text: volSlider.value > 0 ? "󰕾" : "󰝟"
                            font.pointSize: 16
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                            Layout.leftMargin: 16
                            color: volSlider.visualPosition > 0.15 ? "#2C2C2E" : "#E6E1E5"
                            z: 2
                        }
                        Item { Layout.fillWidth: true }
                        Text {
                            text: Math.round(volSlider.value * 100) + "%"
                            color: volSlider.visualPosition > 0.85 ? "#2C2C2E" : "#CAC4D0"
                            font.pointSize: 11
                        }
                    }
                }


                handle: Rectangle {
                    x: volSlider.leftPadding + volSlider.visualPosition * (volSlider.availableWidth - width)
                    y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                    implicitWidth: 10
                    implicitHeight: 50
                    radius: 10
                    color: "#D6BEFA"
                    border.color: volSlider.pressed ? "#FFFFFF" : "#E6E1E5"
                    border.width: 2

                    Behavior on scale { NumberAnimation { duration: 100 } }
                    scale: volSlider.hovered ? 1.2 : 1.0
                }

                onValueChanged: {
                    if (pressed) {
                        localProcs.volumeSetter.updateVol(value.toFixed(2))
                    }
                }
            }
        }

        component WidePillButton : Rectangle {
            property string icon: ""
            property string title: ""
            property string label: ""
            property bool isActive: false
            property var onTrigger: null
            property var onLongPress: null

            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: 20
            color: isActive ? "#D6BEFA" : (mouseWide.containsMouse ? "#4A4A4C" : "#3A3A3C")
            Behavior on color { ColorAnimation { duration: 150 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 10

                Text {
                    font.family: "Font Awesome 6 Free"
                    text: parent.parent.icon
                    color: parent.parent.isActive ? "#2C2C2E" : "#E6E1E5"
                    font.pointSize: 18
                    Layout.alignment: Qt.AlignVCenter
                }

                ColumnLayout {
                    spacing: 0
                    Layout.alignment: Qt.AlignVCenter
                    Text {
                        text: parent.parent.parent.title
                        color: parent.parent.parent.isActive ? "#2C2C2E" : "#E6E1E5"
                        font.pointSize: 9
                        font.weight: Font.Bold
                    }
                    Text {
                        text: parent.parent.parent.label
                        color: parent.parent.parent.isActive ? "#2C2C2E" : "#CAC4D0"
                        font.pointSize: 7.5
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }

            MouseArea {
                id: mouseWide; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                Timer {
                    id: lpTimerWide; interval: 500
                    onTriggered: { if (parent.pressed && parent.parent.onLongPress) parent.parent.onLongPress() }
                }
                onPressed: lpTimerWide.start()
                onReleased: lpTimerWide.stop()
                onClicked: if (parent.onTrigger) parent.onTrigger()
            }
        }

        component SquareButton : Rectangle {
            property string icon: ""
            property bool isActive: false
            property var onTrigger: null

            Layout.preferredWidth: 60
            Layout.preferredHeight: 60
            radius: 20
            color: isActive ? "#D6BEFA" : (mouseSquare.containsMouse ? "#4A4A4C" : "#3A3A3C")
            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: parent.icon
                color: parent.isActive ? "#2C2C2E" : "#E6E1E5"
                font.pointSize: 18
            }

            MouseArea {
                id: mouseSquare; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                onClicked: if (parent.onTrigger) parent.onTrigger()
            }
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            WidePillButton {
                icon: localProcs.currentSsid.includes("Wired") ? "󰈀" : "󰖩"
                title: "Network"
                label: localProcs.currentSsid
                isActive: localProcs.currentSsid !== "No WiFi" && localProcs.currentSsid !== "Disconnected"
                onTrigger: () => { localProcs.run(localProcs.wifiToggle) }
                onLongPress: () => { localProcs.run(localProcs.wifiManager) }
            }

            WidePillButton {
                icon: localProcs.currentBtDevice !== "Disconnected" ? "\ue1a8" : "\ue1a7"
                title: "Bluetooth"
                label: localProcs.currentBtDevice !== "Disconnected" ? localProcs.currentBtDevice : "Not connected"
                isActive: localProcs.currentBtDevice !== "Disconnected"
                onTrigger: () => { localProcs.run(localProcs.btManager) }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            WidePillButton {
                icon: "󰓃"
                title: "EasyEffects"
                label: "Active"
                isActive: true
            }
            SquareButton {
                icon: localProcs.isNightLightActive ? "󰖔" : "󰖙"
                isActive: localProcs.isNightLightActive
                onTrigger: () => { localProcs.run(localProcs.nightLightToggle) }
            }
            SquareButton {
                icon: localProcs.isDndActive ? "󰂛" : "󰂚"
                isActive: localProcs.isDndActive
                onTrigger: () => {
                    localProcs.dndToggle()
                    localProcs.run(localProcs.dndToggle)
                }
            }
        }

        MediaPlayer { id: mediaPlayer }
    }
}
