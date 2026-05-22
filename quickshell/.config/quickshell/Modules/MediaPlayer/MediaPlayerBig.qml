import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import "./../"

PanelWindow {
    id: mediaWindow
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.margins.top: 12
    WlrLayershell.margins.left: 12
    anchors.left: true
    anchors.top: true
    width: 320
    height: 500
    color: "transparent"
    visible: active || rootYAnim.running || root.y > -mediaWindow.height
    mask: Region { item: root }

    property bool active: false

    Procs { id: localProcs }

    Rectangle {
        id: root
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        radius: 24
        color: "#1C1B1F"
        clip: true

        y: mediaWindow.active ? 0 : -mediaWindow.height
        Behavior on y {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutBack
                easing.overshoot: 0.5
            }
        }

        function formatTime(microseconds) {
            let totalSeconds = Math.floor(microseconds / 1000000);
            let minutes = Math.floor(totalSeconds / 60);
            let seconds = totalSeconds % 60;

            let paddedSeconds = seconds < 10 ? "0" + seconds : seconds;
            let paddedMinutes = minutes < 10 ? "0" + minutes : minutes;

            return paddedMinutes + ":" + paddedSeconds;
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            Rectangle {
                id: artFrame
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: width 
                radius: 16
                color: "#141218"
                clip: true

                Image {
                    id: ambientBg
                    anchors.fill: parent
                    source: {
                        if (localProcs.trackArt === "") return "../images/blackhole.jpg";
                        if (localProcs.trackArt.startsWith("/")) return "file://" + localProcs.trackArt;
                        return localProcs.trackArt;
                    }
                    fillMode: Image.PreserveAspectCrop
                    opacity: 0.15
                    asynchronous: true
                }

                Image {
                    id: mediaArt
                    anchors.fill: parent
                    source: {
                        if (localProcs.trackArt === "") return "";                          if (localProcs.trackArt.startsWith("/")) return "file://" + localProcs.trackArt;
                        return localProcs.trackArt;
                    }
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: false
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 12
                    height: 22
                    width: deviceText.implicitWidth + 24
                    radius: 11
                    color: "#D6BEFA"

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 4
                        Text {
                            font.family: "Material Symbols Rounded"
                            text: localProcs.currentBtDevice !== "Disconnected" ? "\ue1a8" : "\uf01f"
                            font.pointSize: 8
                            color: "#000000"
                        }
                        Text {
                            id: deviceText
                            text: localProcs.currentBtDevice !== "Disconnected" ? localProcs.currentBtDevice : "Speakers"
                            color: "#000000"
                            font.pointSize: 8
                            font.weight: Font.Medium
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                Layout.topMargin: 4

                Text {
                    Layout.fillWidth: true
                    text: localProcs.trackTitle
                    color: "white"
                    font.pointSize: 13
                    font.weight: Font.Bold
                    wrapMode: Text.WordWrap
                    maximumLineCount: 1
                    elide: Text.ElideRight
                }
                Text {
                    Layout.fillWidth: true
                    text: localProcs.trackArtist
                    color: "#CAC4D0"
                    font.pointSize: 10
                    elide: Text.ElideRight
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

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
                        implicitWidth: 200
                        implicitHeight: parent.height
                        width: trackProgress.availableWidth
                        height: implicitHeight
                        radius: 12
                        color: "#3A3A3C"

                        Rectangle {
                            width: trackProgress.visualPosition * parent.width
                            height: parent.height
                            color: "#D6BEFA"
                            radius: 6
                        }
                    }
                    handle: Rectangle {
                        x: trackProgress.leftPadding + trackProgress.visualPosition * (trackProgress.availableWidth - width)
                        y: trackProgress.topPadding + trackProgress.availableHeight / 2 - height / 2
                        implicitWidth: 6
                        implicitHeight: 16
                        radius: 3
                        color: "#D6BEFA"
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: formatTime(localProcs.trackPosUs)
                        color: "#CAC4D0"
                        font.pointSize: 8
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: formatTime(localProcs.trackLengthUs)
                        color: "#CAC4D0"
                        font.pointSize: 8
                    }
                }
            }

            Item { Layout.fillHeight: true }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 24 
                Layout.bottomMargin: 8

                Rectangle {
                    width: 44; height: 44; radius: 22
                    color: prevMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : "transparent"
                    Text { anchors.centerIn: parent; text: "\ue045"; font.pointSize: 20; color: "white"; font.family: "Material Symbols Rounded" }
                    MouseArea {
                        id: prevMouse; anchors.fill: parent; hoverEnabled: true
                        onClicked: localProcs.run(localProcs.mediaPrev)
                    }
                }

                Rectangle {
                    width: 64; height: 64; radius: 32
                    color: "#D6BEFA"
                    scale: playMouse.pressed ? 0.92 : (playMouse.containsMouse ? 1.05 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 100 } }
                    Text {
                        anchors.centerIn: parent
                        text: localProcs.isPlaying ? "\ue034" : "\ue037"
                        font.pointSize: 28
                        font.family: "Material Symbols Rounded"
                        color: "#000000"
                    }
                    MouseArea {
                        id: playMouse; anchors.fill: parent; hoverEnabled: true
                        onClicked: localProcs.run(localProcs.mediaToggle)
                    }
                }

                Rectangle {
                    width: 44; height: 44; radius: 22
                    color: nextMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.1) : "transparent"
                    Text { anchors.centerIn: parent; text: "\ue044"; font.pointSize: 20; color: "white"; font.family: "Material Symbols Rounded" }
                    MouseArea {
                        id: nextMouse; anchors.fill: parent; hoverEnabled: true
                        onClicked: localProcs.run(localProcs.mediaNext)
                    }
                }
            }
        }
    }
}
