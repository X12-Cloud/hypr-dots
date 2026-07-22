import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import "./../"

Rectangle {
    id: settingsRoot
    Layout.fillWidth: true
    implicitHeight: mainCol.implicitHeight + 20
    radius: 18
    color: shellContext ? shellContext.surfacePill : "#1C1C1E"
    property var shellContext: null

    Procs { id: localProcs }

    ColumnLayout {
        id: mainCol
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 10
        spacing: 8

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 6
            RowLayout {
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
                        radius: 18
                        color: shellContext ? shellContext.borderPill : "#252528"

                        Rectangle {
                            width: volSlider.visualPosition * parent.width
                            height: parent.height
                            color: settingsRoot.shellContext ? settingsRoot.shellContext.accentNormal : "#8AB4F8"
                            radius: 18
                        }
                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 16
                            anchors.rightMargin: 16
                            spacing: 0
                            Item { Layout.fillWidth: true }
                            Text {
                                text: Math.round(volSlider.value * 100) + "%"
                                color: volSlider.visualPosition > 0.85 ? "#2C2C2E" : (settingsRoot.shellContext ? settingsRoot.shellContext.textMuted : "#CAC4D0")
                                font.pointSize: 11
                            }
                        }
                    }

                    handle: Rectangle {
                        x: (volSlider.leftPadding + volSlider.visualPosition * (volSlider.availableWidth - width)) - 10
                        y: volSlider.topPadding + volSlider.availableHeight / 2 - height / 2
                        implicitWidth: 36
                        implicitHeight: 36
                        radius: 18
                        color: "transparent"
                        border.color: volSlider.pressed ? "#FFFFFF" : (settingsRoot.shellContext ? settingsRoot.shellContext.textPrimary : "#E6E1E5")
                        border.width: 0

                        Behavior on scale { NumberAnimation { duration: 100 } }
                        scale: volSlider.hovered ? 1.1 : 1.0
                    }

                    onValueChanged: {
                        if (pressed) {
                            localProcs.volumeSetter.updateVol(value.toFixed(2))
                        }
                    }
                }
                Rectangle {
                    Layout.preferredWidth: 36
                    Layout.preferredHeight: 36
                    radius: 18
                    color: volBtn.containsMouse ? "#2A2A2C" : (shellContext ? shellContext.borderPill : "#252528")
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Text {
                        id: volIcon1
                        text: volSlider.value > 0 ? "\ue050" : "\ue04f"
                        font.pointSize: 16
                        font.family: "Material Symbols Rounded"
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: settingsRoot.shellContext ? settingsRoot.shellContext.textPrimary : "#E6E1E5"
                    }
                    MouseArea {
                        id: volBtn; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            let savedVal = volSlider.value;
                            if (volSlider.value != 0) {
                                localProcs.volumeSetter.updateVol(0)
                                volSlider.value = 0
                            } else {
                                let restoreVal = savedVal > 0 ? savedVal : 0.5
                                localProcs.volumeSetter.updateVol(restoreVal)
                                volSlider.value = restoreVal
                            }
                        }
                    }
                }
            }
        }

        component WidePillButton : Rectangle {
            id: pillRoot
            property var shellContext: null
            property string icon: ""
            property string title: ""
            property string label: ""
            property bool isActive: false
            property var onTrigger: null
            property var onLongPress: null

            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: pillRoot.isActive ? 20 : 30
            color: mouseWide.containsMouse ? "#2A2A2C" : (shellContext ? shellContext.borderPill : "#252528")
            Behavior on color { ColorAnimation { duration: 150 } }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 14
                spacing: 10

                Rectangle {
                    id: iconContainer
                    Layout.preferredWidth: 50
                    Layout.preferredHeight: 50
                    radius: pillRoot.isActive ? 20 : 30
                    color: pillRoot.isActive 
                           ? (pillRoot.shellContext ? pillRoot.shellContext.accentNormal : "#8AB4F8")
                           : "#2C2C2E"
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        anchors.centerIn: parent
                        font.family: "Material Symbols Rounded"
                        text: pillRoot.icon
                        color: pillRoot.isActive ? "#2C2C2E" : (pillRoot.shellContext ? pillRoot.shellContext.textPrimary : "#E6E1E5")
                        font.pointSize: 18
                    }
                }

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        text: pillRoot.title
                        color: pillRoot.shellContext ? pillRoot.shellContext.textPrimary : "#E6E1E5"
                        font.pointSize: 9.5
                        font.weight: Font.Bold
                    }
                    Text {
                        text: pillRoot.label
                        color: pillRoot.shellContext ? pillRoot.shellContext.textMuted : "#CAC4D0"
                        font.pointSize: 8
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }
            }

            MouseArea {
                id: mouseWide; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                Timer {
                    id: lpTimerWide; interval: 500
                    onTriggered: { if (parent.pressed && pillRoot.onLongPress) pillRoot.onLongPress() }
                }
                onPressed: lpTimerWide.start()
                onReleased: lpTimerWide.stop()
                onClicked: if (pillRoot.onTrigger) pillRoot.onTrigger()
            }
        }

        component SquareButton : Rectangle {
            id: squareRoot
            property var shellContext: null
            property string icon: ""
            property bool isActive: false
            property var onTrigger: null

            Layout.preferredWidth: 60
            Layout.preferredHeight: 60
            radius: squareRoot.isActive ? 20 : 30
            color: squareRoot.isActive
                   ? (squareRoot.shellContext ? squareRoot.shellContext.accentNormal : "#8AB4F8") 
                   : (mouseSquare.containsMouse ? "#2A2A2C" : (shellContext ? shellContext.borderPill : "#252528"))
            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: squareRoot.icon
                color: squareRoot.isActive ? "#2C2C2E" : (squareRoot.shellContext ? squareRoot.shellContext.textPrimary : "#E6E1E5")
                font.pointSize: 18
                font.family: "Material Symbols Rounded"
            }

            MouseArea {
                id: mouseSquare; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                onClicked: if (squareRoot.onTrigger) squareRoot.onTrigger()
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            WidePillButton {
                shellContext: settingsRoot.shellContext
                icon: localProcs.currentSsid.includes("Wired") ? "\ue8be" : "\ue63e"
                title: "Wi-Fi"
                label: localProcs.currentSsid
                isActive: localProcs.currentSsid !== "No WiFi" && localProcs.currentSsid !== "Disconnected"
                onTrigger: () => { localProcs.run(localProcs.wifiToggle) }
                onLongPress: () => { localProcs.run(localProcs.wifiManager) }
            }
            WidePillButton {
                shellContext: settingsRoot.shellContext
                icon: localProcs.currentBtDevice !== "Disconnected" ? "\ue1a8" : "\ue1a7"
                title: "Bluetooth"
                label: localProcs.currentBtDevice !== "Disconnected" ? localProcs.currentBtDevice : "Not connected"
                isActive: localProcs.currentBtDevice !== "Disconnected"
                onTrigger: () => { localProcs.run(localProcs.btManager) }
            }
            SquareButton {
                shellContext: settingsRoot.shellContext
                icon: "\uefef"
                isActive: localProcs.keepSysAwake
                onTrigger: () => {
                    localProcs.toggleSystemAwake()
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            WidePillButton {
                shellContext: settingsRoot.shellContext
                icon: "\uf003"
                title: "Sound Devices"
                label: localProcs.currentSinkName
                isActive: true
            }
            SquareButton {
                shellContext: settingsRoot.shellContext
                icon: localProcs.isNightLightActive ? "\uf03d" : "\ue430"
                isActive: localProcs.isNightLightActive
                onTrigger: () => {
                    localProcs.execNLToggle()
                }
            }
            SquareButton {
                shellContext: settingsRoot.shellContext
                icon: localProcs.isDndActive ? "\ueffb" : "\ue643"
                isActive: localProcs.isDndActive
                onTrigger: () => {
                    localProcs.dndToggle()
                }
            }
        }
    }
}
