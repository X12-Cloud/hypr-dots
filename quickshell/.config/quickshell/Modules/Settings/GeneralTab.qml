import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    Layout.fillWidth: true
    spacing: 16

    ColumnLayout {
        spacing: 4
        Text { 
            text: "General Environment"
            color: settingsWindow.draftTextPrimary
            font.pixelSize: 20
            font.weight: Font.Bold 
        }
        Text { 
            text: "Configure workspace properties, assets, and active quick-themes."
            color: settingsWindow.draftTextMuted
            font.pixelSize: 12 
        }
    }

    // --- Interactive Accent Color Pick Box ---
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: accentPickCol.implicitHeight + 32
        color: settingsWindow.draftSurfacePill
        radius: 12
        border.color: settingsWindow.draftBorderPill

        ColumnLayout {
            id: accentPickCol
            anchors.fill: parent
            anchors.margins: 16
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Rectangle {
                    width: 24
                    height: 24
                    radius: 12
                    color: settingsWindow.draftAccentNormal
                    border.color: settingsWindow.draftBorderPill
                    border.width: 1
                }

                ColumnLayout {
                    spacing: 2
                    Text { 
                        text: "Accent Color"
                        color: settingsWindow.draftTextPrimary
                        font.weight: Font.DemiBold
                        font.pixelSize: 14 
                    }
                    Text { 
                        text: "Instantly switch your system highlight to preset colors"
                        color: settingsWindow.draftTextMuted
                        font.pixelSize: 11 
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Repeater {
                    model: [
                        { label: "Original Blue", val: "#8AB4F8" },
                        { label: "Lavender", val: "#CBA6F7" },
                        { label: "Mossy Green", val: "#A6E3A1" },
                        { label: "Muted Orange", val: "#FAB387" }
                    ]

                    delegate: Button {
                        id: presetChip
                        flat: true
                        Layout.preferredHeight: 32
                        Layout.fillWidth: true

                        background: Rectangle {
                            color: settingsWindow.draftAccentNormal === modelData.val ? Qt.alpha(modelData.val, 0.18) : 
                                   chipHover.hovered ? Qt.alpha(modelData.val, 0.06) : "transparent"
                            border.color: settingsWindow.draftAccentNormal === modelData.val ? modelData.val : settingsWindow.draftBorderPill
                            border.width: 1
                            radius: 6
                            Behavior on color { ColorAnimation { duration: 100 } }
                        }
                        
                        HoverHandler { id: chipHover }

                        contentItem: RowLayout {
                            anchors.centerIn: parent
                            spacing: 8
                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: modelData.val
                            }
                            Text {
                                text: modelData.label
                                color: settingsWindow.draftAccentNormal === modelData.val ? settingsWindow.draftTextPrimary : settingsWindow.draftTextMuted
                                font.pixelSize: 11
                                font.weight: settingsWindow.draftAccentNormal === modelData.val ? Font.DemiBold : Font.Normal
                            }
                        }
                        onClicked: settingsWindow.draftAccentNormal = modelData.val
                    }
                }
            }
        }
    }

    // --- Workspace / Theme / Path Configuration Card ---
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: generalContent.implicitHeight + 36
        color: settingsWindow.draftSurfacePill
        radius: 12
        border.color: settingsWindow.draftBorderPill

        ColumnLayout {
            id: generalContent
            anchors.fill: parent
            anchors.margins: 18
            spacing: 20

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                RowLayout {
                    Layout.fillWidth: true
                    Text { 
                        text: "Workspace Count"
                        color: settingsWindow.draftTextPrimary
                        font.weight: Font.Medium
                        font.pixelSize: 13
                        Layout.fillWidth: true 
                    }
                    Text { 
                        text: settingsWindow.draftWorkspaceCount.toString()
                        color: settingsWindow.draftAccentNormal
                        font.pixelSize: 12
                        font.family: "JetBrains Mono" 
                    }
                }
                Slider {
                    from: 1; to: 20; stepSize: 1
                    value: settingsWindow.draftWorkspaceCount
                    Layout.fillWidth: true
                    onMoved: settingsWindow.draftWorkspaceCount = value
                }
            }

            // Divider Line
            Rectangle { Layout.fillWidth: true; height: 1; color: settingsWindow.draftBorderPill }

            // --- INTERACTIVE LIGHT MODE ROW SWITCH ---
            RowLayout {
                Layout.fillWidth: true
                ColumnLayout {
                    spacing: 2
                    Text { text: "Light Interface Theme"; color: settingsWindow.draftTextPrimary; font.weight: Font.Medium; font.pixelSize: 13 }
                    Text { text: "Swap base palettes to high contrast clean light backgrounds"; color: settingsWindow.draftTextMuted; font.pixelSize: 11 }
                }
                Switch {
                    checked: settingsWindow.draftLightMode
                    onCheckedChanged: {
                        if (settingsWindow.draftLightMode !== checked) {
                            settingsWindow.draftLightMode = checked;
                            settingsWindow.applyThemePreset(checked);
                        }
                    }
                }
            }

            // Divider Line
            Rectangle { Layout.fillWidth: true; height: 1; color: settingsWindow.draftBorderPill }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6
                Text { 
                    text: "Wallpaper Asset Location"
                    color: settingsWindow.draftTextPrimary
                    font.weight: Font.Medium
                    font.pixelSize: 13 
                }
                TextField {
                    text: settingsWindow.draftBackgroundImage
                    color: settingsWindow.draftTextPrimary
                    placeholderText: "No background image (Color base fallback)"
                    placeholderTextColor: settingsWindow.draftTextMuted
                    font.pixelSize: 12
                    Layout.fillWidth: true
                    leftPadding: 10
                    rightPadding: 10
                    background: Rectangle {
                        color: Qt.darker(settingsWindow.draftBgBase, 1.2)
                        border.color: parent.activeFocus ? settingsWindow.draftAccentNormal : settingsWindow.draftBorderPill
                        radius: 6
                        implicitHeight: 32
                    }
                    onEditingFinished: settingsWindow.draftBackgroundImage = text
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6
                Text { 
                    text: "Fallback Placeholder Image Location"
                    color: settingsWindow.draftTextPrimary
                    font.weight: Font.Medium
                    font.pixelSize: 13 
                }
                TextField {
                    text: settingsWindow.draftPlaceholderImage
                    color: settingsWindow.draftTextPrimary
                    placeholderText: "e.g., ../images/fallback.jpg"
                    placeholderTextColor: settingsWindow.draftTextMuted
                    font.pixelSize: 12
                    Layout.fillWidth: true
                    leftPadding: 10
                    rightPadding: 10
                    background: Rectangle {
                        color: Qt.darker(settingsWindow.draftBgBase, 1.2)
                        border.color: parent.activeFocus ? settingsWindow.draftAccentNormal : settingsWindow.draftBorderPill
                        radius: 6
                        implicitHeight: 32
                    }
                    onEditingFinished: settingsWindow.draftPlaceholderImage = text
                }
            }
        }
    }
}
