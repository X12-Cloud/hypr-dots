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

    property var shellContext: null

    Procs { id: localProcs }

    Rectangle {
        id: root
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        radius: 24
        
        // Deep blue background color matching the other widget
        color: mediaWindow.shellContext ? mediaWindow.shellContext.surfacePill : "#161F30"
        clip: true

        y: mediaWindow.active ? 0 : -mediaWindow.height
        Behavior on y {
            id: rootYAnim
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

        // Ambient Background Art Backdrop
        Rectangle {
            anchors.fill: parent
            radius: 24
            color: "#0C1625" // Deep dark blue background base
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
            anchors.margins: 16
            spacing: 12

            // Big Square Album Art Frame (Original vertical layout)
            Rectangle {
                id: artFrame
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: width 
                radius: 16
                color: "#0C1625"
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
                        if (localProcs.trackArt === "") return "";
                        if (localProcs.trackArt.startsWith("/")) return "file://" + localProcs.trackArt;
                        return localProcs.trackArt;
                    }
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    cache: false
                }

                // Bluetooth/Output Device Chip
                Rectangle {
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 12
                    height: 22
                    width: deviceText.implicitWidth + 28
                    radius: 11
                    color: mediaWindow.shellContext ? mediaWindow.shellContext.surfacePill : "#0C1625"
                    border.color: mediaWindow.shellContext ? mediaWindow.shellContext.borderPill : "#1F314A"
                    border.width: 1

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 6
                        Text {
                            font.family: "Material Symbols Rounded"
                            text: localProcs.currentBtDevice !== "Disconnected" ? "\ue1a8" : "\uf01f"
                            font.pointSize: 9
                            color: mediaWindow.shellContext ? mediaWindow.shellContext.accentNormal : "#8AB4F8"
                        }
                        Text {
                            id: deviceText
                            text: localProcs.currentBtDevice !== "Disconnected" ? localProcs.currentBtDevice : "Speakers"
                            color: mediaWindow.shellContext ? mediaWindow.shellContext.textPrimary : "#E2E8F0"
                            font.pointSize: 8
                            font.weight: Font.Medium
                        }
                    }
                }
            }

            // Track Info
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4
                Layout.topMargin: 4

                Text {
                    Layout.fillWidth: true
                    text: localProcs.trackTitle !== "" ? localProcs.trackTitle : "Not Playing"
                    color: mediaWindow.shellContext ? mediaWindow.shellContext.textPrimary : "#E2E8F0"
                    font.pointSize: 13
                    font.weight: Font.Bold
                    wrapMode: Text.WordWrap
                    maximumLineCount: 1
                    elide: Text.ElideRight
                }
                Text {
                    Layout.fillWidth: true
                    text: localProcs.trackArtist !== "" ? localProcs.trackArtist : "Media Source"
                    color: mediaWindow.shellContext ? mediaWindow.shellContext.textMuted : "#64748B"
                    font.pointSize: 10
                    elide: Text.ElideRight
                }
            }

            // Progress Slider
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Slider {
                    id: trackProgress
                    Layout.fillWidth: true
                    Layout.preferredHeight: 6
                    from: 0
                    to: 100
                    value: localProcs.percentage
                    enabled: false

                    background: Rectangle {
                        x: trackProgress.leftPadding
                        y: trackProgress.topPadding + trackProgress.availableHeight / 2 - height / 2
                        width: trackProgress.availableWidth
                        height: 6
                        radius: 3
                        color: mediaWindow.shellContext ? mediaWindow.shellContext.borderPill : "#1F314A"

                        Rectangle {
                            width: trackProgress.visualPosition * parent.width
                            height: parent.height
                            color: mediaWindow.shellContext ? mediaWindow.shellContext.accentNormal : "#8AB4F8"
                            radius: 3
                        }
                    }
                    handle: Rectangle {
                        x: trackProgress.leftPadding + trackProgress.visualPosition * (trackProgress.availableWidth - width)
                        y: trackProgress.topPadding + trackProgress.availableHeight / 2 - height / 2
                        implicitWidth: 4
                        implicitHeight: 12
                        radius: 2
                        color: mediaWindow.shellContext ? mediaWindow.shellContext.textPrimary : "#E2E8F0"
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: formatTime(localProcs.trackPosUs)
                        color: mediaWindow.shellContext ? mediaWindow.shellContext.textMuted : "#64748B"
                        font.pointSize: 8
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: formatTime(localProcs.trackLengthUs)
                        color: mediaWindow.shellContext ? mediaWindow.shellContext.textMuted : "#64748B"
                        font.pointSize: 8
                    }
                }
            }

            Item { Layout.fillHeight: true }

            // Navigation Controls
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 24 
                Layout.bottomMargin: 8

                // Previous Track Button
                Rectangle {
                    width: 44; height: 44; radius: 22
                    color: prevMouse.containsMouse 
                           ? (mediaWindow.shellContext ? mediaWindow.shellContext.borderPill : "#1F314A") 
                           : "transparent"
                    
                    Behavior on color { ColorAnimation { duration: 180 } }
                    scale: prevMouse.pressed ? 0.92 : 1.0
                    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

                    Text { 
                        anchors.centerIn: parent 
                        text: "\ue045" 
                        font.pointSize: 20 
                        color: prevMouse.containsMouse 
                               ? (mediaWindow.shellContext ? mediaWindow.shellContext.accentNormal : "#8AB4F8") 
                               : (mediaWindow.shellContext ? mediaWindow.shellContext.textPrimary : "#E2E8F0")
                        font.family: "Material Symbols Rounded" 
                        Behavior on color { ColorAnimation { duration: 140 } }
                    }
                    MouseArea {
                        id: prevMouse; anchors.fill: parent; hoverEnabled: true
                        onClicked: localProcs.run(localProcs.mediaPrev)
                    }
                }

                // Play/Pause Squircle Button
                Rectangle {
                    id: playSquircle
                    width: 64; height: 64
                    radius: 20 // Adjusted to make it a perfect squircle matching the landscape vibe
                    color: mediaWindow.shellContext ? mediaWindow.shellContext.accentNormal : "#8AB4F8"
                    
                    scale: playMouse.pressed ? 0.92 : (playMouse.containsMouse ? 1.05 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 100 } }
                    
                    Text {
                        anchors.centerIn: parent
                        text: localProcs.isPlaying ? "\ue034" : "\ue037"
                        font.pointSize: 28
                        font.family: "Material Symbols Rounded"
                        color: mediaWindow.shellContext ? mediaWindow.shellContext.surfacePill : "#050B14"
                    }
                    MouseArea {
                        id: playMouse; anchors.fill: parent; hoverEnabled: true
                        onClicked: localProcs.run(localProcs.mediaToggle)
                    }
                }

                // Next Track Button
                Rectangle {
                    width: 44; height: 44; radius: 22
                    color: nextMouse.containsMouse 
                           ? (mediaWindow.shellContext ? mediaWindow.shellContext.borderPill : "#1F314A") 
                           : "transparent"

                    Behavior on color { ColorAnimation { duration: 180 } }
                    scale: nextMouse.pressed ? 0.92 : 1.0
                    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

                    Text { 
                        anchors.centerIn: parent 
                        text: "\ue044" 
                        font.pointSize: 20 
                        color: nextMouse.containsMouse 
                               ? (mediaWindow.shellContext ? mediaWindow.shellContext.accentNormal : "#8AB4F8") 
                               : (mediaWindow.shellContext ? mediaWindow.shellContext.textPrimary : "#E2E8F0")
                        font.family: "Material Symbols Rounded" 
                        Behavior on color { ColorAnimation { duration: 140 } }
                    }
                    MouseArea {
                        id: nextMouse; anchors.fill: parent; hoverEnabled: true
                        onClicked: localProcs.run(localProcs.mediaNext)
                    }
                }
            }
        }
    }
}
