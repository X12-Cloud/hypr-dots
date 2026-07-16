import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: launcherWindow

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    implicitHeight: 480

    WlrLayershell.layer: WlrLayershell.Overlay
    WlrLayershell.keyboardFocus: WlrLayershell.Exclusive
    WlrLayershell.exclusionMode: WlrLayershell.None

    color: "transparent"

    property var shellContext: null
    property int currentSelectionIndex: 0

    // --- Dynamic Fallbacks linked to ShellSettings ---
    property color bgBase:       shellContext ? shellContext.bgBase       : "#161618"
    property color surfacePill:  shellContext ? shellContext.surfacePill  : "#1C1C1E"
    property color borderPill:   shellContext ? shellContext.borderPill   : "#252528"
    property color accentNormal: shellContext ? shellContext.accentNormal : "#8AB4F8"
    property color textPrimary:  shellContext ? shellContext.textPrimary  : "#E6E1E5"
    property color textMuted:    shellContext ? shellContext.textMuted    : "#CAC4D0"

    property var settingsApp: shellContext ? shellContext.settingsApp : null

    // Custom apps array falling back to the exact default in your ShellSettings
    property var customAppModel: shellContext ? shellContext.customApps : [
        { name: "Stupid", exec: "~/bin/stupid-script.sh", icon: "foot" }
    ]

    // Unified app arrays
    property var fullAppModel: []
    property var filteredModel: fullAppModel

    FileView {
        id: appFileReader
        path: Quickshell.env("HOME") + "/.config/quickshell/apps.json"
        blockLoading: true

        onLoaded: {
            try {
                let parsed = JSON.parse(appFileReader.text());
                let combined = parsed.concat(launcherWindow.customAppModel || []);
                combined.sort((a, b) => a.name.localeCompare(b.name));
                launcherWindow.fullAppModel = combined;
                launcherWindow.filteredModel = combined;
            } catch(e) {
                console.log("JSON parsing error: " + e);
                fallbackToCustom();
            }
        }

        onLoadFailed: {
            console.log("File load failed");
            fallbackToCustom();
        }
    }

    function fallbackToCustom() {
        let fallbackList = launcherWindow.customAppModel || [];
        launcherWindow.fullAppModel = fallbackList;
        launcherWindow.filteredModel = fallbackList;
    }

    function filterApps(query) {
        currentSelectionIndex = 0;
        if (query.trim() === "") {
            filteredModel = fullAppModel;
            return;
        }
        let result = [];
        for (let i = 0; i < fullAppModel.length; i++) {
            if (fullAppModel[i].name.toLowerCase().includes(query.toLowerCase())) {
                result.push(fullAppModel[i]);
            }
        }
        filteredModel = result;
    }

    function closeLauncher() {
        launcherWindow.visible = false;
    }

    function launchSelectedApp() {
        if (filteredModel.length > 0 && currentSelectionIndex < filteredModel.length) {
            let targetApp = filteredModel[currentSelectionIndex];
            runExternalCommand(targetApp.exec);
        }
    }

    function runExternalCommand(execCmd) {
        processRunner.command = ["systemd-run", "--user", "sh", "-c", execCmd];
        processRunner.running = true;
        launcherWindow.closeLauncher();
    }

    Process {
        id: processRunner
    }

    Item {
        id: rootScope
        anchors.fill: parent

        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
                launcherWindow.closeLauncher();
                event.accepted = true;
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: launcherWindow.closeLauncher()
        }

        Item {
            id: container
            width: 640
            height: 480

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20

            ColumnLayout {
                anchors.fill: parent
                spacing: 12

                // --- Main Search Bar Panel ---
                Rectangle {
                    Layout.preferredHeight: 58
                    Layout.preferredWidth: 420
                    Layout.alignment: Qt.AlignHCenter
                    color: launcherWindow.bgBase
                    radius: 29
                    border.color: searchInput.activeFocus ? launcherWindow.accentNormal : launcherWindow.borderPill
                    border.width: 0

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 20
                        spacing: 10

                        // Circular Search Icon Badge
                        Rectangle {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            color: searchInput.activeFocus ? launcherWindow.accentNormal : launcherWindow.surfacePill
                            radius: 20

                            Text {
                                anchors.centerIn: parent
                                text: "\ue8b6"
                                font.family: "Material Symbols Rounded"
                                font.pointSize: 14
                                color: searchInput.activeFocus ? launcherWindow.bgBase : launcherWindow.textMuted
                            }
                        }

                        // Inner nested pill for the text input block
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            color: launcherWindow.surfacePill
                            radius: 20
                            border.color: searchInput.activeFocus ? Qt.alpha(launcherWindow.accentNormal, 0.3) : "transparent"
                            border.width: 0

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16

                                TextField {
                                    id: searchInput
                                    Layout.fillWidth: true
                                    placeholderText: "Search apps..."
                                    placeholderTextColor: launcherWindow.textMuted
                                    color: launcherWindow.textPrimary
                                    font.pointSize: 11
                                    focus: true

                                    background: Rectangle { color: "transparent" }
                                    onTextChanged: launcherWindow.filterApps(text)

                                    Keys.onPressed: (event) => {
                                        if (event.key === Qt.Key_Escape) {
                                            launcherWindow.closeLauncher();
                                            event.accepted = true;
                                        } else if (event.key === Qt.Key_Down) {
                                            if (launcherWindow.currentSelectionIndex < launcherWindow.filteredModel.length - 1) {
                                                launcherWindow.currentSelectionIndex++;
                                                appListView.positionViewAtIndex(launcherWindow.currentSelectionIndex, ListView.Contain);
                                            }
                                            event.accepted = true;
                                        } else if (event.key === Qt.Key_Up) {
                                            if (launcherWindow.currentSelectionIndex > 0) {
                                                launcherWindow.currentSelectionIndex--;
                                                appListView.positionViewAtIndex(launcherWindow.currentSelectionIndex, ListView.Contain);
                                            }
                                            event.accepted = true;
                                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                            launcherWindow.launchSelectedApp();
                                            event.accepted = true;
                                        }
                                    }

                                    Component.onCompleted: forceActiveFocus()
                                }
                            }
                        }

                        // File Manager (Nautilus)
                        Text {
                            text: "\uea85"
                            font.family: "Material Symbols Rounded"
                            font.pointSize: 15
                            color: fileMouse.containsMouse ? launcherWindow.accentNormal : launcherWindow.textMuted
                            Layout.alignment: Qt.AlignVCenter

                            MouseArea {
                                id: fileMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    launcherWindow.runExternalCommand("nautilus");
                                }
                            }
                        }

                        // Edit config settings in neovim
                        Text {
                            text: "\ue8b8"
                            font.family: "Material Symbols Rounded"
                            font.pointSize: 15
                            color: settingsMouse.containsMouse ? launcherWindow.accentNormal : launcherWindow.textMuted
                            Layout.alignment: Qt.AlignVCenter

                            MouseArea {
                                id: settingsMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    //launcherWindow.runExternalCommand("foot -e nvim " + Quickshell.env("HOME") + "/.config/quickshell/quickshell.conf");
                                    launcherWindow.closeLauncher();
                                    if (launcherWindow.settingsApp) {
                                        launcherWindow.settingsApp.visible = !launcherWindow.settingsApp.visible;
                                    } else {
                                        console.warn("SettingsApp target window not bound to Launcher yet!");
                                    }
                                }
                            }
                        }
                    }
                }

                // --- Apps List View Container ---
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: launcherWindow.bgBase
                    radius: 20
                    border.color: launcherWindow.borderPill
                    border.width: 1
                    visible: launcherWindow.filteredModel.length > 0

                    ListView {
                        id: appListView
                        anchors.fill: parent
                        anchors.margins: 10
                        clip: true
                        spacing: 4
                        model: launcherWindow.filteredModel

                        delegate: Rectangle {
                            width: appListView.width
                            height: 48
                            radius: 12

                            property bool isSelected: index === launcherWindow.currentSelectionIndex

                            color: isSelected 
                                ? launcherWindow.surfacePill 
                                : (itemMouse.containsMouse ? launcherWindow.bgBaseAlt : "transparent")

                            border.color: isSelected ? launcherWindow.accentNormal : "transparent"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 14
                                anchors.rightMargin: 14
                                spacing: 14

                                Image {
                                    Layout.preferredWidth: 26
                                    Layout.preferredHeight: 26
                                    source: modelData.icon ? Quickshell.iconPath(modelData.icon) : ""
                                    fillMode: Image.PreserveAspectFit
                                    asynchronous: true

                                    Rectangle {
                                        anchors.fill: parent
                                        visible: parent.status === Image.Error || parent.status === Image.Null
                                        color: parent.parent.parent.isSelected ? launcherWindow.accentNormal : launcherWindow.borderPill
                                        radius: 6
                                    }
                                }

                                Text {
                                    text: modelData.name
                                    Layout.fillWidth: true
                                    color: parent.parent.isSelected ? launcherWindow.accentNormal : launcherWindow.textPrimary
                                    font.pointSize: 11
                                    font.weight: parent.parent.isSelected ? Font.DemiBold : Font.Normal
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }

                            MouseArea {
                                id: itemMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    launcherWindow.currentSelectionIndex = index;
                                    launcherWindow.launchSelectedApp();
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
