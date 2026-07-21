import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications 0.0
import "./../"

PanelWindow {
    id: sidebar
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: active ? WlrLayershell.Exclusive : WlrLayershell.Ignore
    WlrLayershell.margins.top: 50
    WlrLayershell.margins.right: 5
    WlrLayershell.margins.bottom: 5
    anchors.right: true
    anchors.top: true
    anchors.bottom: true
    width: 420
    color: "transparent"
    visible: active || sidebarContent.opacity > 0
    mask: Region { item: sidebarContent }

    property var shellContext: null
    property var settingsApp: shellContext ? shellContext.settingsApp : null

    property bool active: false
    Procs { id: localProcs }

    Rectangle {
        id: sidebarContent
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width
        color: shellContext ? shellContext.bgBase : "#161618"
        radius: 20
        x: sidebar.active ? 0 : sidebar.width

        Behavior on x {
            NumberAnimation {
                duration: 400
                easing.type: Easing.OutBack
                easing.overshoot: 0.5
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                Layout.leftMargin: 4
                Layout.rightMargin: 4
                Layout.topMargin: 4
                spacing: 10

                Rectangle {
                    Layout.preferredWidth: 160
                    Layout.fillHeight: true
                    radius: 90
                    color: shellContext ? shellContext.surfacePill : "#1C1C1E"

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 8

                        Text {
                            font.family: "Font Awesome 6 Free"
                            text: "\uf17c"
                            color: shellContext ? shellContext.accentNormal : "#8AB4F8"
                            font.pointSize: 11
                            font.weight: Font.Bold
                            Layout.alignment: Qt.AlignVCenter
                        }
                        Text {
                            text: localProcs.uptime
                            color: shellContext ? shellContext.textPrimary : "#E6E1E5"
                            font.pointSize: 10.5
                            font.weight: Font.Bold
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            elide: Text.ElideRight
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Rectangle {
                    Layout.preferredWidth: 96
                    Layout.fillHeight: true
                    radius: 23
                    color: shellContext ? shellContext.surfacePill : "#1C1C1E"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 3
                        spacing: 2

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 20
                            color: settingsMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                            Behavior on color { ColorAnimation { duration: 120 } }

                            Text {
                                anchors.centerIn: parent
                                font.family: "Material Symbols Rounded"
                                text: "\ue8b8"
                                color: shellContext ? shellContext.textPrimary : "#E6E1E5"
                                font.pointSize: 13
                            }

                            MouseArea {
                                id: settingsMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    sidebar.active = !sidebar.active
                                    if (sidebar.settingsApp) {
                                        sidebar.settingsApp.visible = !sidebar.settingsApp.visible;
                                    } else {
                                        console.warn("SettingsApp target window not bound to RightsideBar yet!");
                                    }
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 20
                            color: reloadMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"
                            Behavior on color { ColorAnimation { duration: 120 } }

                            Text {
                                anchors.centerIn: parent
                                font.family: "Material Symbols Rounded"
                                text: "\uf053"
                                color: shellContext ? shellContext.textPrimary : "#E6E1E5"
                                font.pointSize: 13
                            }

                            MouseArea {
                                id: reloadMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Quickshell.reload(Quickshell.configPath)
                                    Hyprland.dispatch("exec hyprctl reload")
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 20
                            color: powerMouse.containsMouse ? "#E94A4A" : "transparent"
                            Behavior on color { ColorAnimation { duration: 120 } }

                            Text {
                                anchors.centerIn: parent
                                font.family: "Material Symbols Rounded"
                                text: "\ue8ac"
                                color: powerMouse.containsMouse ? (shellContext ? shellContext.surfacePill : "#1C1C1E") : (shellContext ? shellContext.textPrimary : "#E6E1E5")
                                font.pointSize: 13
                            }

                            MouseArea {
                                id: powerMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    sidebar.active = false;
                                    if (sidebar.shellContext !== null) {
                                        sidebar.shellContext.createLogoutMenu();
                                    } else {
                                        console.log("Error: shellContext is not bound to root shell root element.");
                                    }
                                }
                            }
                        }
                    }
                }
            }

            QuickSettings {
                id: settingsCard
                Layout.fillWidth: true
                Layout.preferredHeight: sidebar.height * 0.23
                shellContext: sidebar.shellContext
            }
            MediaPlayer {
                id: mediaPlayerSmall
                Layout.fillWidth: true
                visible: true
                shellContext: sidebar.shellContext
            }
            NotificationList {
                id: notifCard
                Layout.fillWidth: true
                Layout.fillHeight: true
                shellContext: sidebar.shellContext
            }
            /* UtilsList {
                id: utilsCard
                Layout.fillWidth: true
                Layout.fillHeight: true
                shellContext: sidebar.shellContext
            } */
        }
    }
}
