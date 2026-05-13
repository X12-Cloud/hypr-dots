import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 130
    radius: 20
    color: "#2C2C2E"
    clip: true

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: "transparent"
        clip: true

        Image {
            id: bgArt
            anchors.fill: parent
            source: {
                if (localProcs.trackArt === "") return "images/default_art.jpg";
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

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 25

            Rectangle {
                width: 40; height: 40; radius: 20
                color: prevMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.2) : "transparent"
                Text { anchors.centerIn: parent; text: "󰒮"; font.pointSize: 18; color: "white" }
                MouseArea {
                    id: prevMouse; anchors.fill: parent; hoverEnabled: true
                    onClicked: localProcs.run(localProcs.mediaPrev)
                }
            }

            Rectangle {
                width: 50; height: 50; radius: 25
                color: Qt.rgba(1, 1, 1, 0.4) //"#ffffff"
                scale: playMouse.pressed ? 0.9 : (playMouse.containsMouse ? 1.05 : 1.0)
                Behavior on scale { NumberAnimation { duration: 100 } }
                Text {
                    anchors.centerIn: parent
                    text: localProcs.isPlaying ? "󰏤" : "󰐊"
                    font.pointSize: 22
                    color: transparent
                }
                MouseArea {
                    id: playMouse; anchors.fill: parent; hoverEnabled: true
                    onClicked: localProcs.run(localProcs.mediaToggle)
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
