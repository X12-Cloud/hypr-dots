import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 160
    radius: 20
    color: "#2C2C2E"
    clip: true

    function formatTime(microseconds) {
        let totalSeconds = Math.floor(microseconds / 1000000);
        let minutes = Math.floor(totalSeconds / 60);
        let seconds = totalSeconds % 60;

        let paddedSeconds = seconds < 10 ? "0" + seconds : seconds;
        let paddedMinutes = minutes < 10 ? "0" + minutes : minutes;

        return paddedMinutes + ":" + paddedSeconds;
    }

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: "transparent"
        clip: true

        Image {
            id: bgArt
            anchors.fill: parent
            source: {
                if (localProcs.trackArt === "") return "images/blackhole.jpg";
                if (localProcs.trackArt.startsWith("/")) return "file://" + localProcs.trackArt;
                return localProcs.trackArt;
            }
            fillMode: Image.PreserveAspectCrop
            opacity: 0.25
            asynchronous: true
            cache: false

            onStatusChanged: {
                if (status === Image.Error) {
                    console.log("Image Error: " + source + " | Status: " + status)
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.2
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            Item { Layout.fillWidth: true }
            Rectangle {
                height: 18
                width: deviceText.implicitWidth + 30
                radius: 9
                color: "#D6BEFA"
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 4
                    Text {
                        font.family: "Material Symbols Rounded" // "Font Awesome 6 Free"
                        text: localProcs.currentBtDevice !== "Disconnected" ? "\uf293" : "\uf025"
                        //font.styleName: "Solid"
                        font.pointSize: 8
                        color: "#000000"
                    }
                    Text {
                        id: deviceText
                        text: localProcs.currentBtDevice !== "Disconnected" ? localProcs.currentBtDevice : "Speakers"
                        color: "#000000"
                        font.pointSize: 7
                        font.weight: Font.Medium
                    }
                }
            }
        }

        RowLayout {
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                Text {
                    Layout.fillWidth: true
                    text: localProcs.trackTitle
                    color: "white"
                    font.pointSize: 11
                    font.weight: Font.Bold
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }
                Text {
                    Layout.fillWidth: true
                    text: localProcs.trackArtist
                    color: "#CAC4D0"
                    font.pointSize: 9
                    elide: Text.ElideRight
                }
            }
            Rectangle {
                width: 50; height: 50; radius: 20
                color: "#D6BEFA"
                scale: playMouse.pressed ? 0.9 : (playMouse.containsMouse ? 1.05 : 1.0)
                Behavior on scale { NumberAnimation { duration: 100 } }
                Text {
                    anchors.centerIn: parent
                    text: localProcs.isPlaying ? "󰏤" : "󰐊"
                    font.pointSize: 22
                    color: "#000000"
                }
                MouseArea {
                    id: playMouse; anchors.fill: parent; hoverEnabled: true
                    onClicked: localProcs.run(localProcs.mediaToggle)
                }
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 0

            Rectangle {
                width: 40; height: 40; radius: 20
                color: prevMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.2) : "transparent"
                Text { anchors.centerIn: parent; text: "󰒮"; font.pointSize: 18; color: "white" }
                MouseArea {
                    id: prevMouse; anchors.fill: parent; hoverEnabled: true
                    onClicked: localProcs.run(localProcs.mediaPrev)
                }
            }
            /* RowLayout {
                Layout.fillWidth: true
                Text {
                    text: formatTime(localProcs.trackPosUs)
                    color: "#CAC4D0"
                    font.pointSize: 9
                }
                Text {
                    text: formatTime(localProcs.trackLengthUs)
                    color: "#CAC4D0"
                    font.pointSize: 9
                }
            } */
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
                    implicitWidth: 10
                    implicitHeight: 10
                    radius: 20
                    color: "#D6BEFA"
                    border.color: trackProgress.pressed ? "#FFFFFF" : "#E6E1E5"
                    border.width: 2

                    Behavior on scale { NumberAnimation { duration: 100 } }
                    scale: trackProgress.hovered ? 1.2 : 1.0
                }
            }
            Rectangle {
                width: 40; height: 40; radius: 20
                color: nextMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.2) : "transparent"
                Text { anchors.centerIn: parent; text: "󰒭"; font.pointSize: 18; color: "white" }
                MouseArea {
                    id: nextMouse; anchors.fill: parent; hoverEnabled: true
                    onClicked: localProcs.run(localProcs.mediaNext)
                }
            }
        }
    }
}
