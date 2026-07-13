import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "./../"

Rectangle {
    id: root
    Layout.fillWidth: true
    implicitHeight: mainContentLayout.implicitHeight + 32
    radius: 24
    color: "transparent" // "#161F30"
    clip: true

    property alias active: root.visible
    property var shellContext: null 

    function formatTime(microseconds) {
        let totalSeconds = Math.floor(microseconds / 1000000);
        let minutes = Math.floor(totalSeconds / 60);
        let seconds = totalSeconds % 60;
        return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds);
    }

    // Blurred Backdrop Artwork Stack
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
        id: mainContentLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 18
        spacing: 14

        RowLayout {
            Layout.fillWidth: true

            Rectangle {
                height: 22
                width: deviceText.implicitWidth + 28
                radius: 11
                color: root.shellContext ? root.shellContext.surfacePill : "#0C1625"
                border.color: root.shellContext ? root.shellContext.borderPill : "#1F314A"
                border.width: 1

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 6
                    Text {
                        font.family: "Material Symbols Rounded"
                        text: localProcs.currentBtDevice !== "Disconnected" ? "\ue1a8" : "\uf01f"
                        font.pointSize: 9
                        color: root.shellContext ? root.shellContext.accentNormal : "#8AB4F8"
                    }
                    Text {
                        id: deviceText
                        text: localProcs.currentBtDevice !== "Disconnected" ? localProcs.currentBtDevice : "Speakers"
                        color: root.shellContext ? root.shellContext.textPrimary : "#E2E8F0"
                        font.pointSize: 8
                        font.weight: Font.Medium
                    }
                }
            }
            Item { Layout.fillWidth: true }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    Layout.fillWidth: true
                    text: localProcs.trackTitle !== "" ? localProcs.trackTitle : "Not Playing"
                    color: root.shellContext ? root.shellContext.textPrimary : "#E2E8F0"
                    font.pointSize: 14
                    font.weight: Font.Bold
                    font.family: "sans-serif"
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }
                Text {
                    Layout.fillWidth: true
                    text: localProcs.trackArtist !== "" ? localProcs.trackArtist : "Media Source"
                    color: root.shellContext ? root.shellContext.textMuted : "#64748B"
                    font.pointSize: 10
                    font.family: "sans-serif"
                    elide: Text.ElideRight
                }
            }

            // Inline Navigation Control Group
            RowLayout {
                spacing: 8
                Layout.alignment: Qt.AlignVCenter

                // Previous Track Button
                Rectangle {
                    width: 36; height: 36
                    radius: 12
                    color: prevMouse.containsMouse ? "#1F314A" : "transparent"

                    Behavior on color { ColorAnimation { duration: 180 } }
                    scale: prevMouse.pressed ? 0.92 : 1.0
                    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

                    Text { 
                        anchors.centerIn: parent 
                        text: "\ue045" 
                        font.pointSize: 16 
                        color: prevMouse.containsMouse ? (root.shellContext ? root.shellContext.accentNormal : "#8AB4F8") : "#E2E8F0"
                        font.family: "Material Symbols Rounded"
                        Behavior on color { ColorAnimation { duration: 140 } }
                    }
                    MouseArea {
                        id: prevMouse; anchors.fill: parent; hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: localProcs.run(localProcs.mediaPrev)
                    }
                }

                // Play/Pause Button
                Rectangle {
                    id: playSquircle
                    width: 46; height: 46
                    radius: 18
                    color: root.shellContext ? root.shellContext.accentNormal : "#8AB4F8"

                    scale: playMouse.pressed ? 0.90 : (playMouse.containsMouse ? 1.06 : 1.0)
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

                    Text {
                        anchors.centerIn: parent
                        text: localProcs.isPlaying ? "\ue034" : "\ue037"
                        font.pointSize: 20
                        font.family: "Material Symbols Rounded"
                        color: "#050B14"
                    }
                    MouseArea {
                        id: playMouse; anchors.fill: parent; hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: localProcs.run(localProcs.mediaToggle)
                    }
                }

                // Next Track Button
                Rectangle {
                    width: 36; height: 36
                    radius: 12
                    color: nextMouse.containsMouse ? "#1F314A" : "transparent"

                    Behavior on color { ColorAnimation { duration: 180 } }
                    scale: nextMouse.pressed ? 0.92 : 1.0
                    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

                    Text { 
                        anchors.centerIn: parent 
                        text: "\ue044" 
                        font.pointSize: 16 
                        color: nextMouse.containsMouse ? (root.shellContext ? root.shellContext.accentNormal : "#8AB4F8") : "#E2E8F0"
                        font.family: "Material Symbols Rounded"
                        Behavior on color { ColorAnimation { duration: 140 } }
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
                    color: "#1F314A"

                    Rectangle {
                        width: trackProgress.visualPosition * parent.width
                        height: parent.height
                        color: root.shellContext ? root.shellContext.accentNormal : "#8AB4F8"
                        radius: 3
                    }
                }

                handle: Rectangle {
                    x: trackProgress.leftPadding + trackProgress.visualPosition * (trackProgress.availableWidth - width)
                    y: trackProgress.topPadding + trackProgress.availableHeight / 2 - height / 2
                    implicitWidth: 4
                    implicitHeight: 12
                    radius: 2
                    color: "#E2E8F0"
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: formatTime(localProcs.trackPosUs)
                    color: root.shellContext ? root.shellContext.textMuted : "#64748B"
                    font.pointSize: 8
                }
                Item { Layout.fillWidth: true }
                Text {
                    text: formatTime(localProcs.trackLengthUs)
                    color: root.shellContext ? root.shellContext.textMuted : "#64748B"
                    font.pointSize: 8
                }
            }
        }
    }
}
