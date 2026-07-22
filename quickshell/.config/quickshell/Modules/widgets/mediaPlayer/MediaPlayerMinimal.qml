import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "./../../"

PanelWindow {
    id: mediaDesktopWidget
    
    WlrLayershell.layer: WlrLayer.Bottom
    WlrLayershell.margins.bottom: 40
    WlrLayershell.margins.left: 40

    anchors.bottom: true
    anchors.left: true

    width: 360
    height: 120
    color: "transparent"

    property var shellContext: null

    Procs { id: localProcs }

    Rectangle {
        id: root
        anchors.fill: parent
        radius: 16
        color: shellContext ? shellContext.surfacePill : "#121824"
        opacity: 0.85
        clip: true

        function formatTime(microseconds) {
            let totalSeconds = Math.floor(microseconds / 1000000);
            let minutes = Math.floor(totalSeconds / 60);
            let seconds = totalSeconds % 60;
            return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds);
        }

        Rectangle {
            anchors.fill: parent
            radius: 24
            color: "#0C1625"
            clip: true

            Image {
                id: bgArt
                anchors.fill: parent
                source: {
                    if (localProcs.trackArt === "") return "../images/blackhole.jpg";
                    return localProcs.trackArt.startsWith("/") ? "file://" + localProcs.trackArt : localProcs.trackArt;
                }
                fillMode: Image.PreserveAspectCrop
                opacity: 0.22
                asynchronous: true
                cache: false
            }
        }


        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: localProcs.currentBtDevice !== "Disconnected" ? localProcs.currentBtDevice : "Speakers"
                    color: root.shellContext ? root.shellContext.textMuted : "#94A3B8"
                    font.pointSize: 8
                    font.weight: Font.Medium
                    font.family: "sans-serif"
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "Media"
                    color: root.shellContext ? root.shellContext.textMuted : "#64748B"
                    font.pointSize: 8
                    font.weight: Font.Medium
                    font.family: "sans-serif"
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        Layout.fillWidth: true
                        text: localProcs.trackTitle !== "" ? localProcs.trackTitle : "Nothing Playing"
                        color: root.shellContext ? root.shellContext.textPrimary : "#E2E8F0"
                        font.pointSize: 11
                        font.weight: Font.Bold
                        font.family: "sans-serif"
                        elide: Text.ElideRight
                        maximumLineCount: 1
                    }

                    Text {
                        Layout.fillWidth: true
                        text: localProcs.trackArtist !== "" ? localProcs.trackArtist : "Paused"
                        color: root.shellContext ? root.shellContext.textMuted : "#64748B"
                        font.pointSize: 9
                        font.family: "sans-serif"
                        elide: Text.ElideRight
                    }
                }

                RowLayout {
                    spacing: 6
                    Layout.alignment: Qt.AlignVCenter

                    Rectangle {
                        width: 30; height: 30
                        radius: 8
                        color: prevMouse.containsMouse ? "#1F314A" : "transparent"
                        scale: prevMouse.pressed ? 0.90 : (prevMouse.containsMouse ? 1.08 : 1.0)

                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

                        Text {
                            anchors.centerIn: parent
                            text: "\ue045"
                            font.pointSize: 14
                            color: prevMouse.containsMouse 
                                ? (root.shellContext ? root.shellContext.accentNormal : "#8AB4F8")
                                : (root.shellContext ? root.shellContext.textPrimary : "#E2E8F0")
                            font.family: "Material Symbols Rounded"

                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                        MouseArea {
                            id: prevMouse; anchors.fill: parent; hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: localProcs.run(localProcs.mediaPrev)
                        }
                    }

                    Rectangle {
                        width: 34; height: 34
                        radius: 10
                        color: root.shellContext ? root.shellContext.accentNormal : "#8AB4F8"
                        scale: playMouse.pressed ? 0.90 : (playMouse.containsMouse ? 1.08 : 1.0)

                        Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

                        Text {
                            anchors.centerIn: parent
                            text: localProcs.isPlaying ? "\ue034" : "\ue037"
                            font.pointSize: 16
                            font.family: "Material Symbols Rounded"
                            color: "#050B14"
                        }
                        MouseArea {
                            id: playMouse; anchors.fill: parent; hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: localProcs.run(localProcs.mediaToggle)
                        }
                    }

                    Rectangle {
                        width: 30; height: 30
                        radius: 8
                        color: nextMouse.containsMouse ? "#1F314A" : "transparent"
                        scale: nextMouse.pressed ? 0.90 : (nextMouse.containsMouse ? 1.08 : 1.0)

                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

                        Text {
                            anchors.centerIn: parent
                            text: "\ue044"
                            font.pointSize: 14
                            color: nextMouse.containsMouse 
                                ? (root.shellContext ? root.shellContext.accentNormal : "#8AB4F8")
                                : (root.shellContext ? root.shellContext.textPrimary : "#E2E8F0")
                            font.family: "Material Symbols Rounded"

                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                        MouseArea {
                            id: nextMouse; anchors.fill: parent; hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: localProcs.run(localProcs.mediaNext)
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Slider {
                    id: trackProgress
                    Layout.fillWidth: true
                    Layout.preferredHeight: 4
                    from: 0
                    to: 100
                    value: localProcs.percentage
                    enabled: false

                    background: Rectangle {
                        x: trackProgress.leftPadding
                        y: trackProgress.topPadding + trackProgress.availableHeight / 2 - height / 2
                        width: trackProgress.availableWidth
                        height: 3
                        radius: 2
                        color: "#1F314A"

                        Rectangle {
                            width: trackProgress.visualPosition * parent.width
                            height: parent.height
                            color: root.shellContext ? root.shellContext.accentNormal : "#8AB4F8"
                            radius: 2
                        }
                    }

                    handle: Item { visible: false }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: root.formatTime(localProcs.trackPosUs)
                        color: root.shellContext ? root.shellContext.textMuted : "#64748B"
                        font.pointSize: 7
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: root.formatTime(localProcs.trackLengthUs)
                        color: root.shellContext ? root.shellContext.textMuted : "#64748B"
                        font.pointSize: 7
                    }
                }
            }
        }
    }
}
