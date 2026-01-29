# TODO

## Media Player

This is the code for the media player that was removed from `RightSidebar.qml`.

```qml
/* =========================
   MEDIA PLAYER (WORKING)
==========================*/
Rectangle {
    id: mediaArea
    width: parent.width
    radius: 12
    color: "#2A292E"
    border.width: 1
    border.color: "#444"
    height: implicitHeight

    property var player: Mpris.getPlayer("spotify")

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        Text {
            text: "Media"
            color: "white"
            font.pixelSize: 15
            font.bold: true
        }

        // -------- Fallback --------
        Text {
            visible: !mediaArea.player
            text: "No media playing"
            color: "#aaa"
            font.pixelSize: 13
        }

        // -------- Real media info --------
        Column {
            visible: !!mediaArea.player
            spacing: 8

            // album art
            Rectangle {
                width: parent.width
                height: parent.width * 0.55
                radius: 8
                color: "#444"

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: mediaArea.player
                            ? mediaArea.player.metadata["mpris:artUrl"]
                            : ""
                    visible: mediaArea.player
                             && mediaArea.player.metadata["mpris:artUrl"] !== undefined
                }
            }

            Text {
                text: mediaArea.player
                        ? mediaArea.player.metadata["xesam:title"]
                        : ""
                color: "white"
                font.pixelSize: 14
                font.bold: true
                elide: Text.ElideRight
            }

            Text {
                text: mediaArea.player
                        ? mediaArea.player.metadata["xesam:artist"]
                        : ""
                color: "#bbb"
                font.pixelSize: 12
                elide: Text.ElideRight
            }

            // Controls
            Row {
                spacing: 14
                visible: !!mediaArea.player

                Rectangle {
                    width: 32; height: 32; radius: 8
                    color: "#3B393F"
                    Text { anchors.centerIn: parent; text: "⏮"; color: "white" }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: mediaArea.player.previous()
                    }
                }

                Rectangle {
                    id: playBtn
                    width: 32; height: 32; radius: 8
                    color: "#3B393F"
                    Text {
                        anchors.centerIn: parent
                        text: mediaArea.player && mediaArea.player.playbackStatus === "Playing" ? "⏸" : "▶"
                        color: "white"
                        id: playLabel
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (mediaArea.player.playbackStatus === "Playing")
                                mediaArea.player.pause()
                            else
                                mediaArea.player.play()
                        }
                    }

                    Connections {
                        target: mediaArea.player
                        function onPlaybackStatusChanged() {
                            playLabel.text =
                                mediaArea.player.playbackStatus === "Playing"
                                ? "⏸" : "▶"
                        }
                    }
                }

                Rectangle {
                    width: 32; height: 32; radius: 8
                    color: "#3B393F"
                    Text { anchors.centerIn: parent; text: "⏭"; color: "white" }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: mediaArea.player.next()
                    }
                }
            }
        }
    }
}
```
