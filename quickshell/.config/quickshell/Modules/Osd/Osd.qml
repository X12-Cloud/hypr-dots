import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: osdWindow

    // Floating overlay layout
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.margins.top: 55
    anchors.top: true
    exclusionMode: ExclusionMode.Ignore

    width: 210
    height: 48
    color: "transparent"
    visible: false

    property var shellContext: null
    property string iconText: "\ue028"
    property real currentValue: 0.0
    property string titleText: "Volume"

    property real lastVolume: -1.0
    property real lastBrightness: -1.0

    Timer {
        id: hideTimer
        interval: 1500
        repeat: false
        onTriggered: osdWindow.visible = false
    }

    function show(icon, val, title) {
        osdWindow.iconText = icon
        osdWindow.currentValue = val
        osdWindow.titleText = title
        osdWindow.visible = true
        hideTimer.restart()
    }

    // Polling processes for audio and brightness changes
    Timer {
        interval: 150
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!getVolProc.running) getVolProc.running = true
            if (!getBrightnessProc.running) getBrightnessProc.running = true
        }
    }

    Process {
        id: getVolProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}'"]
        stdout: SplitParser {
            onRead: (data) => {
                let parsed = parseFloat(data.trim()) || 0.0
                if (osdWindow.lastVolume >= 0 && Math.abs(osdWindow.lastVolume - parsed) > 0.001) {
                    osdWindow.show("\ue050", parsed, "Volume")
                }
                osdWindow.lastVolume = parsed
            }
        }
    }

    Process {
        id: getBrightnessProc
        command: ["sh", "-c", "cur=$(brightnessctl get); max=$(brightnessctl max); echo \"$cur||$max\""]
        stdout: SplitParser {
            onRead: (data) => {
                let parts = data.trim().split("||")
                if (parts.length === 2) {
                    let cur = parseInt(parts[0]) || 0
                    let max = parseInt(parts[1]) || 1
                    let ratio = cur / max

                    if (osdWindow.lastBrightness >= 0 && Math.abs(osdWindow.lastBrightness - ratio) > 0.001) {
                        osdWindow.show("\ue0d8", ratio, "Brightness")
                    }
                    osdWindow.lastBrightness = ratio
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: height / 2
        color: shellContext ? shellContext.surfacePill : "#121824"
        border.color: shellContext ? shellContext.borderPill : "#1E293B"
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 10

            Text {
                text: osdWindow.iconText
                font.family: "Material Symbols Rounded"
                font.pointSize: 15
                color: shellContext ? shellContext.accentNormal : "#8AB4F8"
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: osdWindow.titleText
                        font.pointSize: 8.5
                        font.weight: Font.Bold
                        color: shellContext ? shellContext.textPrimary : "#E2E8F0"
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: Math.round(osdWindow.currentValue * 100) + "%"
                        font.pointSize: 8.5
                        color: shellContext ? shellContext.textMuted : "#94A3B8"
                    }
                }

                // Progress Track
                Rectangle {
                    Layout.fillWidth: true
                    height: 5
                    radius: height / 2
                    color: shellContext ? Qt.rgba(shellContext.textMuted.r, shellContext.textMuted.g, shellContext.textMuted.b, 0.2) : "#1F314A"

                    // Progress Fill Bar
                    Rectangle {
                        width: parent.width * Math.min(Math.max(osdWindow.currentValue, 0.0), 1.0)
                        height: parent.height
                        radius: height / 2
                        color: shellContext ? shellContext.accentNormal : "#8AB4F8"

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }
    }
}
