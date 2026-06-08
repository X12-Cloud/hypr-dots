import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "Notifications/"
import "./../"

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 400
    radius: 18
    color: "#2C2C2E" 
    property bool showUtils: false
    property var shellContext: null

    Procs { id: localProcs }

    function formatRelativeTime(timestamp) {
        if (!timestamp) return "now";

        let date = new Date(timestamp);
        let now = new Date();
        let diffMs = now - date;

        if (diffMs < 0) diffMs = 0; 

        let diffMins = Math.floor(diffMs / 60000);
        if (diffMins < 1) return "just now";
        if (diffMins < 60) return diffMins + "m";

        let diffHours = Math.floor(diffMins / 60);
        if (diffHours < 24) return diffHours + "h";

        let diffDays = Math.floor(diffHours / 24);
        return diffDays + "d";
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.topMargin: 12
        anchors.bottomMargin: 20
        anchors.leftMargin: 12 
        anchors.rightMargin: 12
        spacing: 16

        // Top Header Bar
        RowLayout {
            Layout.fillWidth: true
            spacing: 4

            Rectangle {
                id: clearBtn
                width: 48; height: 36; radius: 20
                color: clearMouse.pressed ? "#5A5A5C" : (clearMouse.containsMouse ? "#4A4A4C" : "#3A3A3C")
                border.color: "#3A3A3C"; border.width: 1
                visible: !showUtils

                Text {
                    anchors.centerIn: parent
                    text: "\ue0b8"
                    font.family: "Material Symbols Rounded"
                    font.pointSize: 15
                    color: clearMouse.containsMouse ? (root.shellContext ? root.shellContext.accentNormal : "#D6BEFA") : "#CAC4D0"
                }
                MouseArea {
                    id: clearMouse
                    anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        notifView.clearAllRequested();
                    }
                }
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            Rectangle {
                id: headerPill
                Layout.fillWidth: true
                height: 36
                radius: 20
                color: "#3A3A3C"

                Text {
                    anchors.centerIn: parent
                    text: root.showUtils ? "System Utils" : (notifView.count > 0 ? notifView.count + " notifications" : "No notifications")
                    color: "#E6E1E5"
                    font.pointSize: 11
                    font.family: "sans-serif"
                    font.weight: Font.Medium
                }
            }

            // View Switcher Toggle
            Rectangle {
                width: 48; height: 36; radius: 20
                color: switchMouse.pressed ? "#5A5A5C" : (switchMouse.containsMouse ? "#4A4A4C" : "#3A3A3C")
                border.color: "#3A3A3C"; border.width: 1
                Text {
                    anchors.centerIn: parent
                    text: root.showUtils ? "notification_multiple" : "memory"
                    font.family: "Material Symbols Rounded"
                    font.pointSize: 15
                    color: switchMouse.containsMouse ? (root.shellContext ? root.shellContext.accentNormal : "#D6BEFA") : "#CAC4D0"
                }
                MouseArea {
                    id: switchMouse
                    anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                    onClicked: root.showUtils = !root.showUtils
                }
                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }

        StackLayout {
            Layout.fillWidth: true; Layout.fillHeight: true
            currentIndex: showUtils ? 2 : (notifView.count > 0 ? 0 : 1)

            ScrollView {
                clip: true
                ListView {
                    id: notifView
                    model: notificationsService.trackedNotifications
                    spacing: 8
                    opacity: shellContext && shellContext.globalDnd ? 0.6 : 1.0
                    Behavior on opacity { NumberAnimation { duration: 250 } }

                    signal clearAllRequested()

                    delegate: Rectangle {
                        id: notifItem
                        width: notifView.width

                        property bool isExpanded: false
                        property string relativeTime: root.formatRelativeTime(modelData.timestamp)

                        Connections {
                            target: notifView
                            function onClearAllRequested() {
                                modelData.dismiss();
                            }
                        }

                        Timer {
                            interval: 30000
                            running: true
                            repeat: true
                            onTriggered: notifItem.relativeTime = root.formatRelativeTime(modelData.timestamp)
                        }

                        height: isExpanded ? 104 : 56
                        radius: 14
                        color: "#3A3A3C"
                        border.color: "#4A4A4C"
                        border.width: 1

                        Behavior on height { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            width: 3
                            height: parent.height * 0.5
                            radius: 1.5
                            color: root.shellContext ? root.shellContext.accentNormal : "#D6BEFA"
                        }

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14; anchors.rightMargin: 12; anchors.topMargin: 8; anchors.bottomMargin: 8
                            spacing: 6

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 12

                                Rectangle {
                                    width: 36; height: 36; radius: 8; color: "#2C2C2E"
                                    Layout.alignment: Qt.AlignVCenter

                                    Image {
                                        id: notifIcon
                                        anchors.centerIn: parent
                                        width: 24; height: 24
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
                                            color: root.shellContext ? root.shellContext.accentNormal : "#D6BEFA"
                                            font.pointSize: 14
                                            visible: notifIcon.status !== Image.Ready
                                        }
                                    }
                                }

                                ColumnLayout {
                                    spacing: 1
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 6
                                        Text {
                                            text: modelData.summary
                                            color: "#E6E1E5"; font.pointSize: 12; font.weight: Font.SemiBold
                                            font.family: "sans-serif"; elide: Text.ElideRight; Layout.fillWidth: true
                                        }
                                        Text {
                                            text: notifItem.relativeTime
                                            color: "#CAC4D0"; font.pointSize: 9; opacity: 0.6
                                            Layout.rightMargin: 4
                                        }
                                    }

                                    Text {
                                        text: modelData.body
                                        color: "#CAC4D0"; font.pointSize: 10; font.family: "sans-serif"
                                        elide: Text.ElideRight; Layout.fillWidth: true
                                        maximumLineCount: notifItem.isExpanded ? 2 : 1
                                        wrapMode: notifItem.isExpanded ? Text.WordWrap : Text.NoWrap
                                    }
                                }

                                Rectangle {
                                    id: expandBtn
                                    width: 24; height: 24; radius: 12
                                    color: expandMouse.containsMouse ? "#4A4A4C" : "transparent"
                                    Layout.alignment: Qt.AlignVCenter

                                    Text {
                                        anchors.centerIn: parent
                                        text: notifItem.isExpanded ? "\ue316" : "\ue313"
                                        font.pointSize: 11
                                        font.family: "Material Symbols Rounded"
                                        color: "#CAC4D0"
                                    }
                                    MouseArea {
                                        id: expandMouse
                                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                        onClicked: notifItem.isExpanded = !notifItem.isExpanded
                                    }
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8
                                visible: notifItem.isExpanded

                                Rectangle {
                                    id: closeActionPill
                                    Layout.fillWidth: true
                                    height: 32
                                    radius: 16
                                    color: closeActionMouse.containsMouse ? "#4A4A4C" : "#2C2C2E"

                                    Text {
                                        anchors.centerIn: parent
                                        text: "close"
                                        color: "#FFB4AB"
                                        font.pointSize: 12
                                        font.family: "Material Symbols Rounded"
                                    }
                                    MouseArea {
                                        id: closeActionMouse
                                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                        onClicked: modelData.dismiss()
                                    }
                                }

                                Rectangle {
                                    id: openActionPill
                                    Layout.fillWidth: true
                                    height: 32
                                    radius: 16
                                    color: openActionMouse.containsMouse ? "#4A4A4C" : "#2C2C2E"

                                    Text {
                                        anchors.centerIn: parent
                                        text: "\ue157" // Link / external open arrow glyph
                                        color: "#E6E1E5"
                                        font.pointSize: 12
                                        font.family: "Material Symbols Rounded"
                                    }
                                    MouseArea {
                                        id: openActionMouse
                                        anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                spacing: 12
                Layout.fillWidth: true; Layout.fillHeight: true
                Item { Layout.fillWidth: true }
                Item { Layout.fillHeight: true }

                Text {
                    Layout.alignment: Qt.AlignCenter
                    text: shellContext && shellContext.globalDnd ? "\ueffb" : "\ue7f6"
                    font.pointSize: 48; font.family: "Material Symbols Rounded"; color: "#4A4A4C"
                }
                Text {
                    Layout.alignment: Qt.AlignCenter
                    text: shellContext && shellContext.globalDnd ? "Do Not Disturb" : "No Notifications"
                    font.pointSize: 14; font.family: "sans-serif"; color: "#4A4A4C"; opacity: 0.8
                }
                Item { Layout.fillHeight: true }
            }

            UtilsCard {
                id: utilsCard
                shellContext: root.shellContext
            }
        }
    }
}
