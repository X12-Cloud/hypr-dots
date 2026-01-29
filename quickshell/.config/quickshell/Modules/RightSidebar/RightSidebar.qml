import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications

PanelWindow {
    id: sidebar
    anchors.right: true
    anchors.top: true
    anchors.bottom: true
    width: 360
    color: "#1C1C1E"
    visible: false

    Behavior on visible { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // Notifications Card
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 450
            radius: 28
            color: "#2C2C2E"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 24
                spacing: 16

                Text {
                    text: "Notifications"
                    color: "#E6E1E5"
                    font.pointSize: 22
                    font.family: "sans-serif"
                    font.weight: Font.Normal
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true

                    ListView {
                        id: notifView
                        model: Notifications.notifications
                        spacing: 12
                        delegate: Rectangle {
                            width: notifView.width
                            height: 72
                            radius: 12
                            color: "#3A3A3C"

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 16

                                Text {
                                    text: "◆" // Placeholder for an icon
                                    color: "#CAC4D0"
                                    font.pointSize: 24
                                }

                                ColumnLayout {
                                    spacing: 2

                                    Text {
                                        text: model.summary
                                        color: "#E6E1E5"
                                        font.pointSize: 16
                                        font.weight: Font.Medium
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: model.body
                                        color: "#CAC4D0"
                                        font.pointSize: 14
                                        wrapMode: Text.Wrap
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignCenter
                    visible: Notifications.notifications.length === 0
                    text: "No new notifications"
                    color: "#999999"
                    font.pointSize: 14
                }
            }
        }

        // Extra Area Card
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 28
            color: "#2C2C2E"

            Text {
                anchors.centerIn: parent
                text: "More Controls"
                color: "#999999"
                font.pointSize: 16
            }
        }
    }
}
