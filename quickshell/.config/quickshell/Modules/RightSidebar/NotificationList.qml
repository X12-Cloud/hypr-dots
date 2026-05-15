import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: 400
    radius: 28
    color: "#2C2C2E"

    Procs { id: localProcs }

    opacity: localProcs.isDndActive ? 0.6 : 1.0
    Behavior on opacity { NumberAnimation { duration: 250 } }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        RowLayout {
            Text { text: "Notifications"; color: "#E6E1E5"; font.pointSize: 20; font.family: "sans-serif" }
            Item { Layout.fillWidth: true }
            Rectangle {
                id: clearBtn
                width: 80
                height: 32
                radius: 12
                color: clearMouse.pressed ? "#4A4A4C" : (clearMouse.containsMouse ? "#3A3A3C" : "#2C2C2E")
                border.color: "#3A3A3C"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "Clear All"
                    color: clearMouse.containsMouse ? "#D6BEFA" : "#CAC4D0"
                    font.pointSize: 9
                    font.weight: Font.Medium
                }

                MouseArea {
                    id: clearMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        const entries = notificationsService.trackedNotifications;
                        for (var i = entries.length - 1; i >= 0; i--) {
                            entries[i].dismiss();
                        }
                    }
                }

                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: notifView.count > 0 ? 0 : 1
            ScrollView {
                clip: true
                ListView {
                    id: notifView
                    model: notificationsService.trackedNotifications
                    spacing: 10
                    delegate: Rectangle {
                        width: notifView.width
                        height: 72
                        radius: 12
                        color: "#3A3A3C"

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 16
                            spacing: 16

                            Rectangle {
                                width: 48
                                height: 48
                                radius: 10
                                color: "#2C2C2E"
                                Layout.alignment: Qt.AlignVCenter

                                Image {
                                    id: notifIcon
                                    anchors.centerIn: parent
                                    width: 32
                                    height: 32
                                    fillMode: Image.PreserveAspectFit
                                    source: {
                                        if (!modelData.icon) return "";
                                        if (modelData.icon.startsWith("/") || modelData.icon.startsWith("file://")) {
                                            return modelData.icon.startsWith("/") ? "file://" + modelData.icon : modelData.icon;
                                        }
                                        return "icon://" + modelData.icon;
                                    }
                                    Text {
                                        anchors.centerIn: parent
                                        text: "󰵅"
                                        color: "#D6BEFA"
                                        font.pointSize: 18
                                        visible: notifIcon.status !== Image.Ready
                                    }
                                }
                            }
                            ColumnLayout {
                                spacing: 2
                                Text {
                                    text: modelData.summary;
                                    color: "#E6E1E5"; font.pointSize: 14;
                                    font.weight: Font.Medium;
                                    elide: Text.ElideRight;
                                    Layout.fillWidth: true
                                }
                                Text {
                                    text: modelData.body;
                                    color: "#CAC4D0";
                                    font.pointSize: 12;
                                    elide: Text.ElideRight;
                                    Layout.fillWidth: true 
                                }
                            }
                            Text {
                                text: "󰅖"
                                font.pointSize: 16
                                color: "#FFFFFF"
                                Layout.alignment: Qt.AlignTop
                                opacity: dismissMouse.containsMouse ? 1.0 : 0.3
                                Behavior on opacity { NumberAnimation { duration: 150 } }

                                MouseArea {
                                    id: dismissMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: modelData.dismiss()
                                }
                            }
                        }
                    }
                }
            }
            ColumnLayout {
                spacing: 12
                Layout.fillWidth: true
                Layout.fillHeight: true

                Item { Layout.fillWidth: true }
                Item { Layout.fillHeight: true }

                Text {
                    Layout.alignment: Qt.AlignCenter
                    text: localProcs.isDndActive ? "\ueffb" : "\ue7f6"
                    font.pointSize: 48
                    font.family: "Material Symbols Rounded"
                    color: "#4A4A4C"
                }

                Text {
                    Layout.alignment: Qt.AlignCenter
                    text: localProcs.isDndActive ? "Do Not Disturb is on" : "No Notifications"
                    font.pointSize: 14
                    font.family: "sans-serif"
                    color: "#4A4A4C"
                    opacity: 0.8
                }

                Item { Layout.fillHeight: true }
            }
        }
    }
}
