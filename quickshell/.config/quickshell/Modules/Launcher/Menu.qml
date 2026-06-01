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

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.exclusionMode: WlrExclusionMode.None

    color: "transparent"

    property var shellContext: null
    property int currentSelectionIndex: 0

    // Custom apps array to easily inject your own shortcuts
    property var customAppModel: [
        { name: "Stupid", exec: "~/bin/stupid-script.sh", icon: "foot" },
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
                let combined = parsed.concat(launcherWindow.customAppModel);
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
        launcherWindow.fullAppModel = launcherWindow.customAppModel;
        launcherWindow.filteredModel = launcherWindow.customAppModel;
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
            processRunner.command = ["systemd-run", "--user", "sh", "-c", targetApp.exec];
            processRunner.running = true;
            launcherWindow.closeLauncher();
        }
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

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 54
                    color: shellContext ? shellContext.bgBase : "#090F1C"
                    radius: 27
                    border.color: searchInput.activeFocus ? (shellContext ? shellContext.accentNormal : "#528BFF") : (shellContext ? shellContext.borderPill : "#1B2A4A")
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20
                        spacing: 14

                        Text {
                            text: "\ue8b6"
                            font.family: "Material Symbols Rounded"
                            font.pointSize: 16
                            color: searchInput.activeFocus ? (shellContext ? shellContext.accentNormal : "#528BFF") : (shellContext ? shellContext.textMuted : "#4F6380")
                        }

                        TextField {
                            id: searchInput
                            Layout.fillWidth: true
                            placeholderText: "Search apps..."
                            placeholderTextColor: shellContext ? shellContext.textMuted : "#4F6380"
                            color: shellContext ? shellContext.textPrimary : "#E2E8F0"
                            font.pointSize: 12
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

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: shellContext ? shellContext.bgBase : "#090F1C"
                    radius: 20
                    border.color: shellContext ? shellContext.borderPill : "#1B2A4A"
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
                                ? (shellContext ? shellContext.surfacePill : "#1A263D") 
                                : (itemMouse.containsMouse ? (shellContext ? shellContext.bgBaseAlt : "#121B2A") : "transparent")

                            border.color: isSelected ? (shellContext ? shellContext.accentNormal : "#528BFF") : "transparent"
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
                                        color: parent.parent.parent.isSelected ? (shellContext ? shellContext.accentNormal : "#528BFF") : (shellContext ? shellContext.borderPill : "#1B2A4A")
                                        radius: 6
                                    }
                                }

                                Text {
                                    text: modelData.name
                                    Layout.fillWidth: true
                                    color: parent.parent.isSelected ? (shellContext ? shellContext.accentNormal : "#528BFF") : (shellContext ? shellContext.textPrimary : "#E2E8F0")
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
