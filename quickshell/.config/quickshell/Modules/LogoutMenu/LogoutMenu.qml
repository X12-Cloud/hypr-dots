import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: logoutWindow

    anchors.left: true
    anchors.right: true
    anchors.top: true
    anchors.bottom: true

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: WlrLayershell.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    visible: true
    color: "#80000000"

    property var shellContext: null
    property int currentSelectionIndex: 0

    // Helper function to dynamically underline the matching keybind character
    function wrapMnemonic(name, keyChar) {
        let index = name.toLowerCase().indexOf(keyChar.toLowerCase());
        if (index === -1) return name;
        return name.substring(0, index) + "<u>" + name.charAt(index) + "</u>" + name.substring(index + 1);
    }

    function triggerAction(modelData) {
        if (modelData.type === "cmd") {
            processCmd.command = modelData.target;
            processCmd.running = true;
        } else if (modelData.type === "lock") {
            if (logoutWindow.shellContext !== null) {
                logoutWindow.shellContext.isLocked = true;
            }
            logoutWindow.destroy();
        } else {
            logoutWindow.destroy();
        }
    }

    Process {
        id: processCmd
        onExited: (exitCode, exitStatus) => {
            logoutWindow.destroy();
        }
    }

    Item {
        id: rootScope
        anchors.fill: parent
        Component.onCompleted: rootScope.forceActiveFocus()

        Keys.onPressed: (event) => {
            let keyStr = event.text.toLowerCase();
            let rawModel = gridRepeater.model;
            for (let i = 0; i < rawModel.length; i++) {
                if (rawModel[i].hotkey.toLowerCase() === keyStr) {
                    logoutWindow.triggerAction(rawModel[i]);
                    event.accepted = true;
                    return;
                }
            }

            if (event.key === Qt.Key_Escape) {
                logoutWindow.destroy();
                event.accepted = true;
            } else if (event.key === Qt.Key_Left) {
                logoutWindow.currentSelectionIndex = (logoutWindow.currentSelectionIndex - 1 + 8) % 8;
                event.accepted = true;
            } else if (event.key === Qt.Key_Right) {
                logoutWindow.currentSelectionIndex = (logoutWindow.currentSelectionIndex + 1) % 8;
                event.accepted = true;
            } else if (event.key === Qt.Key_Up) {
                logoutWindow.currentSelectionIndex = (logoutWindow.currentSelectionIndex - 4 + 8) % 8;
                event.accepted = true;
            } else if (event.key === Qt.Key_Down) {
                logoutWindow.currentSelectionIndex = (logoutWindow.currentSelectionIndex + 4) % 8;
                event.accepted = true;
            } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                logoutWindow.triggerAction(rawModel[logoutWindow.currentSelectionIndex]);
                event.accepted = true;
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: logoutWindow.destroy()
        }

        Rectangle {
            id: menuBox
            anchors.centerIn: parent

            width: grid.implicitWidth + 24
            height: grid.implicitHeight + 24

            color: shellContext.surfacePill

            radius: 24
            border.color: shellContext.borderPill
            border.width: 1

            MouseArea { anchors.fill: parent }

            GridLayout {
                id: grid
                anchors.centerIn: parent
                columns: 4
                rows: 2
                columnSpacing: 12
                rowSpacing: 12

                Repeater {
                    id: gridRepeater

                    model: [
                        { icon: "\ue897", name: "Lock",      color: "#FBBF24", type: "lock",   hotkey: "l", target: "" },
                        { icon: "\ue8ac", name: "Shutdown",  color: "#E94A4A", type: "cmd",    hotkey: "s", target: ["systemctl", "poweroff"] },
                        { icon: "\uf053", name: "Reboot",    color: "#4ADE80", type: "cmd",    hotkey: "r", target: ["systemctl", "reboot"] },
                        { icon: "\uef44", name: "Suspend",   color: "#60A5FA", type: "cmd",    hotkey: "u", target: ["systemctl", "suspend"] },
                        { icon: "\uf45e", name: "Btop",      color: "#A78BFB", type: "cmd",    hotkey: "b", target: ["systemd-run", "--user", "foot", "-e", "btop"] },
                        { icon: "\ue9ba", name: "Log Out",   color: "#A78BFA", type: "cmd",    hotkey: "o", target: ["hyprctl", "dispatch", "exit"] },
                        { icon: "\uf724", name: "Hibernate", color: "#60A5FA", type: "cmd",    hotkey: "h", target: ["systemctl", "hibernate"] },
                        { icon: "\ue5cd", name: "Cancel",    color: "#9CA3AF", type: "cancel", hotkey: "c", target: "" }
                    ]

                    delegate: Rectangle {
                        Layout.preferredWidth: 86
                        Layout.preferredHeight: 86

                        id: gridItem

                        property bool isFocused: index === logoutWindow.currentSelectionIndex || itemMouse.containsMouse

                        color: isFocused ? modelData.color : "#2C2C2E"
                        radius: isFocused ? height / 2 : 16

                        // Sharp individual button borders
                        border.width: 1
                        border.color: isFocused ? Qt.rgba(1, 1, 1, 0.15) : "#3E3E42"

                        Behavior on radius { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                        Behavior on color { ColorAnimation { duration: 120 } }
                        Behavior on border.color { ColorAnimation { duration: 120 } }

                        ColumnLayout {
                            anchors.centerIn: parent
                            width: parent.width - 8
                            spacing: 2

                            Text {
                                font.family: "Material Symbols Rounded"
                                text: modelData.icon
 
                                color: gridItem.isFocused ? (shellContext ? shellContext.surfacePill : "#1C1C1E") : "#E6E1E5"

                                font.pointSize: 22
                                Layout.alignment: Qt.AlignHCenter
                                Behavior on color { ColorAnimation { duration: 120 } }
                            }

                            Text {
                                textFormat: Text.RichText
                                text: logoutWindow.wrapMnemonic(modelData.name, modelData.hotkey)

                                color: gridItem.isFocused ? (shellContext ? shellContext.surfacePill : "#1C1C1E") : "#9CA3AF"

                                font.pointSize: 8
                                font.weight: Font.Medium
                                Layout.alignment: Qt.AlignHCenter
                                visible: gridItem.isFocused
                                maximumLineCount: 1
                                elide: Text.ElideRight
                                Behavior on color { ColorAnimation { duration: 120 } }
                            }
                        }

                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onEntered: logoutWindow.currentSelectionIndex = index

                            onClicked: logoutWindow.triggerAction(modelData)
                        }
                    }
                }
            }
        }
    }
}
