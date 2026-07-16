import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import "./../.." 

FloatingWindow {
    id: settingsWindow
    title: "Shell Settings"

    width: 820
    height: 580
    color: draftBgBase

    ShellSettings { id: settings }

    // --- Dark Mode Defaults (Your original colors) ---
    readonly property string defBgBase: "#161618"
    readonly property string defSurfacePill: "#1C1C1E"
    readonly property string defBorderPill: "#252528"
    readonly property string defAccentNormal: "#8AB4F8"
    readonly property string defTextPrimary: "#E6E1E5"
    readonly property string defTextMuted: "#CAC4D0"
    readonly property string defErrorAccent: "#FFB4AB"
    readonly property string defErrorSurface: "#3A1E1E"

    // --- Light Mode Defaults (New Clean Set) ---
    readonly property string lightBgBase: "#F4F4F6"
    readonly property string lightSurfacePill: "#FFFFFF"
    readonly property string lightBorderPill: "#E2E2E6"
    readonly property string lightAccentNormal: "#1A73E8" // Punchier blue for light background
    readonly property string lightTextPrimary: "#1C1C1E"
    readonly property string lightTextMuted: "#5F6368"
    readonly property string lightErrorAccent: "#BA1A1A"
    readonly property string lightErrorSurface: "#FFDAD7"

    readonly property string defBackgroundImage: ""
    readonly property string defPlaceholderImage: "../images/blackhole.jpg"
    readonly property int defWorkspaceCount: 10

    // --- Draft States ---
    property bool draftLightMode: settings.lightMode // <-- New Boolean State
    
    property string draftBgBase: settings.bgBase
    property string draftSurfacePill: settings.surfacePill
    property string draftBorderPill: settings.borderPill
    property string draftAccentNormal: settings.accentNormal
    property string draftTextPrimary: settings.textPrimary
    property string draftTextMuted: settings.textMuted
    property string draftErrorAccent: settings.errorAccent
    property string draftErrorSurface: settings.errorSurface
    property string draftBackgroundImage: settings.backgroundImage
    property string draftPlaceholderImage: settings.placeholderImage
    property int draftWorkspaceCount: settings.workspaceCount

    property int activeTab: 0 
    property bool dndToggle: settings.globalDnd

    // --- Dirty Checker Update ---
    readonly property bool isDirty: {
        return (draftLightMode !== settings.lightMode) || // <-- Track the switch
               (draftBgBase !== settings.bgBase) ||
               (draftSurfacePill !== settings.surfacePill) ||
               (draftBorderPill !== settings.borderPill) ||
               (draftAccentNormal !== settings.accentNormal) ||
               (draftTextPrimary !== settings.textPrimary) ||
               (draftTextMuted !== settings.textMuted) ||
               (draftErrorAccent !== settings.errorAccent) ||
               (draftErrorSurface !== settings.errorSurface) ||
               (draftBackgroundImage !== settings.backgroundImage) ||
               (draftPlaceholderImage !== settings.placeholderImage) ||
               (draftWorkspaceCount !== settings.workspaceCount) ||
               (dndToggle !== settings.globalDnd)
    }

    onVisibleChanged: if (visible) discardDrafts();

    // --- Triggered when toggling Light/Dark directly ---
    function applyThemePreset(toLightMode) {
        draftBgBase = toLightMode ? lightBgBase : defBgBase;
        draftSurfacePill = toLightMode ? lightSurfacePill : defSurfacePill;
        draftBorderPill = toLightMode ? lightBorderPill : defBorderPill;
        draftAccentNormal = toLightMode ? lightAccentNormal : defAccentNormal;
        draftTextPrimary = toLightMode ? lightTextPrimary : defTextPrimary;
        draftTextMuted = toLightMode ? lightTextMuted : defTextMuted;
        draftErrorAccent = toLightMode ? lightErrorAccent : defErrorAccent;
        draftErrorSurface = toLightMode ? lightErrorSurface : defErrorSurface;
    }

    function discardDrafts() {
        draftLightMode = settings.lightMode;
        draftBgBase = settings.bgBase;
        draftSurfacePill = settings.surfacePill;
        draftBorderPill = settings.borderPill;
        draftAccentNormal = settings.accentNormal;
        draftTextPrimary = settings.textPrimary;
        draftTextMuted = settings.textMuted;
        draftErrorAccent = settings.errorAccent;
        draftErrorSurface = settings.errorSurface;
        draftBackgroundImage = settings.backgroundImage;
        draftPlaceholderImage = settings.placeholderImage;
        draftWorkspaceCount = settings.workspaceCount;
        dndToggle = settings.globalDnd;
    }

    function saveAndApply() {
        settings.lightMode = draftLightMode;
        settings.bgBase = draftBgBase;
        settings.surfacePill = draftSurfacePill;
        settings.borderPill = draftBorderPill;
        settings.accentNormal = draftAccentNormal;
        settings.textPrimary = draftTextPrimary;
        settings.textMuted = draftTextMuted;
        settings.errorAccent = draftErrorAccent;
        settings.errorSurface = draftErrorSurface;
        settings.backgroundImage = draftBackgroundImage;
        settings.placeholderImage = draftPlaceholderImage;
        settings.workspaceCount = draftWorkspaceCount;
        settings.globalDnd = dndToggle;
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ==========================================
        //  LEFT HAND HERO DASHBOARD
        // ==========================================
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: 300
            color: Qt.darker(draftBgBase, 1.08)

            // Divider Line
            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 1
                color: draftBorderPill
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 16

                // Tab Switcher
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8

                    Repeater {
                        model: ["General", "Colors"]
                        delegate: Button {
                            id: tabBtn
                            Layout.fillWidth: true
                            Layout.preferredHeight: 38
                            flat: true

                            background: Rectangle {
                                color: activeTab === index ? draftSurfacePill : 
                                       tabHover.hovered ? Qt.alpha(draftSurfacePill, 0.4) : "transparent"
                                border.color: activeTab === index ? draftBorderPill : "transparent"
                                radius: 8
                                Behavior on color { ColorAnimation { duration: 100 } }
                            }
                            
                            HoverHandler { id: tabHover }

                            contentItem: Text {
                                text: modelData
                                font.family: "Inter, sans-serif"
                                font.pixelSize: 13
                                font.weight: activeTab === index ? Font.DemiBold : Font.Normal
                                color: activeTab === index ? draftAccentNormal : 
                                       tabHover.hovered ? draftTextPrimary : draftTextMuted
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                Behavior on color { ColorAnimation { duration: 100 } }
                            }
                            onClicked: activeTab = index
                        }
                    }
                }

                // Wallpaper Preview Box
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: draftSurfacePill
                    radius: 12
                    border.color: draftBorderPill
                    clip: true

                    Image {
                        id: previewImage
                        anchors.fill: parent
                        source: draftBackgroundImage !== "" ? "file://" + draftBackgroundImage : draftPlaceholderImage
                        fillMode: Image.PreserveAspectCrop
                        opacity: 0.85

                        onStatusChanged: {
                            if (status === Image.Error) {
                                source = draftPlaceholderImage;
                            }
                        }
                    }

                    // Soft overlay shade
                    Rectangle {
                        anchors.fill: parent
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "#00000000" }
                            GradientStop { position: 1.0; color: "#CC101012" }
                        }
                    }

                    // Floating Wallpaper Indicator Badge
                    Rectangle {
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.margins: 14
                        color: Qt.alpha(draftBgBase, 0.7)
                        border.color: draftBorderPill
                        radius: 6
                        implicitWidth: innerText.implicitWidth + 16
                        implicitHeight: 26

                        Text {
                            id: innerText
                            anchors.centerIn: parent
                            text: draftBackgroundImage !== "" ? "Active Wallpaper" : "Using Fallback Image"
                            color: draftTextPrimary
                            font.pixelSize: 10
                            font.weight: Font.Bold
                        }
                    }
                }

                // Quick States Footer Card
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 110
                    color: draftSurfacePill
                    radius: 12
                    border.color: draftBorderPill

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        RowLayout {
                            Layout.fillWidth: true
                            ColumnLayout {
                                spacing: 2
                                Text { text: "Do Not Disturb"; color: draftTextPrimary; font.weight: Font.Medium; font.pixelSize: 13 }
                                Text { text: "Block global system notifications"; color: draftTextMuted; font.pixelSize: 10 }
                            }
                            Switch {
                                id: dndSwitch
                                checked: dndToggle
                                onCheckedChanged: dndToggle = checked
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: draftBorderPill
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            
                            Text { 
                                text: "Workspace Target"
                                color: draftTextPrimary
                                font.pixelSize: 12
                                Layout.fillWidth: true 
                            }
                            
                            Text { 
                                text: draftWorkspaceCount + " Virtual Spaces"
                                color: draftAccentNormal
                                font.pixelSize: 11
                                font.family: "monospace" 
                            }
                        }
                    }
                }
            }
        }

        // ==========================================
        //  RIGHT CONTENT VIEW
        // ==========================================
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ColumnLayout {
                    width: parent.width - 48
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 30
                    spacing: 24

                    // Dynamic Sub-Tab Views
                    GeneralTab {
                        visible: activeTab === 0
                    }

                    ColorsTab {
                        visible: activeTab === 1
                    }
                }
            }

            // ==========================================
            //  ACTION PANEL (BOTTOM SAVE BAR)
            // ==========================================
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                color: Qt.darker(draftBgBase, 1.04)
                border.color: draftBorderPill
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20
                    spacing: 12

                    Text {
                        text: "Unsaved changes detected"
                        color: draftAccentNormal
                        font.pixelSize: 11
                        font.family: "Inter, sans-serif"
                        visible: isDirty
                        Layout.fillWidth: true
                    }

                    Item { 
                        Layout.fillWidth: true 
                        visible: !isDirty 
                    }

                    // --- DISCARD BUTTON ---
                    Button {
                        id: discardBtn
                        text: "Discard"
                        implicitWidth: 80
                        implicitHeight: 32
                        visible: isDirty
                        flat: true

                        background: Rectangle {
                            color: "transparent"
                            border.color: discardBtnHover.hovered ? draftTextPrimary : draftBorderPill
                            border.width: 1
                            radius: 6
                            Behavior on border.color { ColorAnimation { duration: 120 } }
                        }

                        HoverHandler { id: discardBtnHover }

                        contentItem: Text {
                            text: discardBtn.text
                            color: discardBtnHover.hovered ? draftTextPrimary : draftTextMuted
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            Behavior on color { ColorAnimation { duration: 120 } }
                        }
                        onClicked: discardDrafts()
                    }

                    // --- RELOAD CONFIG BUTTON ---
                    Button {
                        id: reloadBtn
                        text: "Reload Config"
                        implicitWidth: 110
                        implicitHeight: 32
                        flat: true

                        background: Rectangle {
                            color: reloadHover.hovered ? Qt.alpha(draftTextPrimary, 0.08) : "transparent"
                            border.color: reloadHover.hovered ? Qt.alpha(draftTextPrimary, 0.3) : draftBorderPill
                            border.width: 1
                            radius: 6
                            Behavior on color { ColorAnimation { duration: 120 } }
                            Behavior on border.color { ColorAnimation { duration: 120 } }
                        }

                        HoverHandler { id: reloadHover }

                        contentItem: Text {
                            text: reloadBtn.text
                            color: reloadBtn.down ? Qt.darker(draftTextPrimary, 1.2) : draftTextPrimary
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: Quickshell.reload(Quickshell.configPath)
                    }

                    // --- APPLY BUTTON ---
                    Button {
                        id: applyBtn
                        text: "Apply Changes"
                        implicitWidth: 120
                        implicitHeight: 32
                        flat: true
                        enabled: isDirty

                        background: Rectangle {
                            color: !isDirty ? Qt.alpha(draftAccentNormal, 0.2) :
                                   applyBtn.down ? Qt.darker(draftAccentNormal, 1.15) :
                                   applyHover.hovered ? Qt.darker(draftAccentNormal, 1.06) : draftAccentNormal
                            radius: 6
                            border.color: isDirty && applyHover.hovered ? Qt.lighter(draftAccentNormal, 1.2) : "transparent"
                            border.width: 1
                            Behavior on color { ColorAnimation { duration: 100 } }
                        }

                        HoverHandler { 
                            id: applyHover
                            enabled: isDirty
                        }

                        contentItem: Text {
                            text: applyBtn.text
                            color: isDirty ? draftBgBase : Qt.alpha(draftBgBase, 0.6)
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        onClicked: saveAndApply()
                    }
                }
            }
        }
    }
}
