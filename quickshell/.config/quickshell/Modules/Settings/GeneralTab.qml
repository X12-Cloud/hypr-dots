import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    Layout.fillWidth: true
    spacing: 24

    // --- Header Title Area ---
    ColumnLayout {
        spacing: 4
        Text { 
            text: "General Environment"
            color: settingsWindow.draftTextPrimary
            font.pixelSize: 22
            font.weight: Font.Bold 
        }
        Text { 
            text: "Configure workspace properties, asset management, and appearance styling layouts."
            color: settingsWindow.draftTextMuted
            font.pixelSize: 12 
        }
    }

    // --- Top Section: Asymmetric Visual Controls ---
    RowLayout {
        Layout.fillWidth: true
        spacing: 20
        Layout.alignment: Qt.AlignTop

        // Left Top Side: Wallpaper Asset Preview Box (Fixed explicit sizing)
        Rectangle {
            Layout.preferredWidth: 320
            Layout.preferredHeight: 180
            color: settingsWindow.draftSurfacePill
            border.color: settingsWindow.draftBorderPill
            border.width: 1
            radius: 12
            clip: true

            Image {
                id: wallpaperPreview
                anchors.fill: parent
                source: settingsWindow.draftBackgroundImage ? ("file://" + settingsWindow.draftBackgroundImage) : settingsWindow.draftPlaceholderImage
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                opacity: status === Image.Ready ? 1.0 : 0.0
                Behavior on opacity { NumberAnimation { duration: 200 } }
            }

            Rectangle {
                anchors.fill: parent
                color: Qt.alpha(settingsWindow.draftBgBase, 0.4)
                visible: !settingsWindow.draftBackgroundImage
            }

            ColumnLayout {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 14
                spacing: 2

                Text {
                    text: settingsWindow.draftBackgroundImage ? "Active Canvas Wallpaper" : "Fallback Configuration Active"
                    color: "#FFFFFF"
                    font.weight: Font.DemiBold
                    font.pixelSize: 13
                    style: Text.Outline
                    styleColor: "#101012"
                }
                Text {
                    text: settingsWindow.draftBackgroundImage ? settingsWindow.draftBackgroundImage : "Using system fallback source definition"
                    color: "#D0D0D2"
                    font.pixelSize: 11
                    elide: Text.ElideMiddle
                    style: Text.Outline
                    styleColor: "#101012"
                }
            }
        }

        // Right Top Side: Refined Accent Color Picker (Maximized Presentation)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            color: settingsWindow.draftSurfacePill
            border.color: settingsWindow.draftBorderPill
            border.width: 1
            radius: 12

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                RowLayout {
                    spacing: 10
                    Rectangle {
                        width: 14; height: 14; radius: 7
                        color: settingsWindow.draftAccentNormal
                    }
                    Text {
                        text: "System Accent Theme"
                        color: settingsWindow.draftTextPrimary
                        font.weight: Font.DemiBold
                        font.pixelSize: 14
                    }
                }

                // Clean layout grid for the color chips so they wrap nicely
                GridLayout {
                    Layout.fillWidth: true
                    columns: 2
                    columnSpacing: 10
                    rowSpacing: 10

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
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40

                            background: Rectangle {
                                color: settingsWindow.draftAccentNormal === modelData.val ? Qt.alpha(modelData.val, 0.14) : 
                                       chipHover.hovered ? Qt.alpha(modelData.val, 0.05) : Qt.darker(settingsWindow.draftSurfacePill, 1.15)
                                border.color: settingsWindow.draftAccentNormal === modelData.val ? modelData.val : settingsWindow.draftBorderPill
                                border.width: settingsWindow.draftAccentNormal === modelData.val ? 2 : 1
                                radius: 8
                            }

                            HoverHandler { id: chipHover }

                            contentItem: RowLayout {
                                anchors.centerIn: parent
                                spacing: 8
                                Rectangle {
                                    width: 10; height: 10; radius: 5
                                    color: modelData.val
                                }
                                Text {
                                    text: modelData.label
                                    color: settingsWindow.draftAccentNormal === modelData.val ? settingsWindow.draftTextPrimary : settingsWindow.draftTextMuted
                                    font.pixelSize: 12
                                    font.weight: settingsWindow.draftAccentNormal === modelData.val ? Font.DemiBold : Font.Normal
                                }
                            }
                            onClicked: settingsWindow.draftAccentNormal = modelData.val
                        }
                    }
                }

                Text {
                    text: "Updates structural components, highlights, focused inputs, and custom control graphs."
                    color: settingsWindow.draftTextMuted
                    font.pixelSize: 11
                    Layout.fillWidth: true
                }
            }
        }
    }

    // --- Middle Section: Split Asymmetric Interface Options ---
    RowLayout {
        Layout.fillWidth: true
        spacing: 20
        Layout.alignment: Qt.AlignTop

        // Left Side: Big Rectangular Theme Canvas Buttons
        ColumnLayout {
            Layout.preferredWidth: 320
            spacing: 8

            Text {
                text: "Interface Base Preset"
                color: settingsWindow.draftTextPrimary
                font.weight: Font.Medium
                font.pixelSize: 13
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                // Light Mode Selector Button
                Button {
                    id: lightThemeBtn
                    flat: true
                    Layout.fillWidth: true
                    Layout.preferredHeight: 90

                    background: Rectangle {
                        color: settingsWindow.draftLightMode ? Qt.alpha(settingsWindow.draftAccentNormal, 0.12) : Qt.darker(settingsWindow.draftSurfacePill, 1.2)
                        border.color: settingsWindow.draftLightMode ? settingsWindow.draftAccentNormal : settingsWindow.draftBorderPill
                        border.width: settingsWindow.draftLightMode ? 2 : 1
                        radius: 10
                    }

                    contentItem: ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        Item {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            Layout.alignment: Qt.AlignHCenter
                            Rectangle {
                                anchors.centerIn: parent
                                width: 10; height: 10; radius: 5
                                color: settingsWindow.draftLightMode ? settingsWindow.draftAccentNormal : settingsWindow.draftTextMuted
                            }
                            Repeater {
                                model: 8
                                Rectangle {
                                    anchors.centerIn: parent
                                    width: 3; height: 3; radius: 1.5
                                    color: settingsWindow.draftLightMode ? settingsWindow.draftAccentNormal : settingsWindow.draftTextMuted
                                    transform: [
                                        Translate { y: -8 },
                                        Rotation { angle: index * 45; origin.x: 1.5; origin.y: 1.5 }
                                    ]
                                }
                            }
                        }

                        Text {
                            text: "Light Theme"
                            color: settingsWindow.draftLightMode ? settingsWindow.draftTextPrimary : settingsWindow.draftTextMuted
                            font.pixelSize: 12
                            font.weight: settingsWindow.draftLightMode ? Font.DemiBold : Font.Normal
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                    onClicked: {
                        if (!settingsWindow.draftLightMode) {
                            settingsWindow.draftLightMode = true;
                            settingsWindow.applyThemePreset(true);
                        }
                    }
                }

                // Dark Mode Selector Button
                Button {
                    id: darkThemeBtn
                    flat: true
                    Layout.fillWidth: true
                    Layout.preferredHeight: 90

                    background: Rectangle {
                        color: !settingsWindow.draftLightMode ? Qt.alpha(settingsWindow.draftAccentNormal, 0.12) : Qt.darker(settingsWindow.draftSurfacePill, 1.2)
                        border.color: !settingsWindow.draftLightMode ? settingsWindow.draftAccentNormal : settingsWindow.draftBorderPill
                        border.width: !settingsWindow.draftLightMode ? 2 : 1
                        radius: 10
                    }

                    contentItem: ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 8
                        
                        Item {
                            Layout.preferredWidth: 24
                            Layout.preferredHeight: 24
                            Layout.alignment: Qt.AlignHCenter
                            Rectangle {
                                width: 14; height: 14; radius: 7
                                color: !settingsWindow.draftLightMode ? settingsWindow.draftAccentNormal : settingsWindow.draftTextMuted
                                anchors.centerIn: parent
                                anchors.horizontalCenterOffset: 2
                                anchors.verticalCenterOffset: 2
                            }
                            Rectangle {
                                width: 12; height: 12; radius: 6
                                color: !settingsWindow.draftLightMode ? Qt.darker(settingsWindow.draftSurfacePill, 1.2) : Qt.darker(settingsWindow.draftSurfacePill, 1.2)
                                anchors.centerIn: parent
                                anchors.horizontalCenterOffset: -1
                                anchors.verticalCenterOffset: -1
                            }
                        }

                        Text {
                            text: "Dark Theme"
                            color: !settingsWindow.draftLightMode ? settingsWindow.draftTextPrimary : settingsWindow.draftTextMuted
                            font.pixelSize: 12
                            font.weight: !settingsWindow.draftLightMode ? Font.DemiBold : Font.Normal
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                    onClicked: {
                        if (settingsWindow.draftLightMode) {
                            settingsWindow.draftLightMode = false;
                            settingsWindow.applyThemePreset(false);
                        }
                    }
                }
            }
        }

        // Right Side: Workspace Counter Slider + Segmented Bar Style Controls
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 125
            color: settingsWindow.draftSurfacePill
            border.color: settingsWindow.draftBorderPill
            border.width: 1
            radius: 12

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2
                    RowLayout {
                        Layout.fillWidth: true
                        Text { 
                            text: "Workspace Count Allocation"
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
                        id: customSlider
                        from: 1; to: 20; stepSize: 1
                        value: settingsWindow.draftWorkspaceCount
                        Layout.fillWidth: true
                        onMoved: settingsWindow.draftWorkspaceCount = value

                        background: Rectangle {
                            x: customSlider.leftPadding
                            y: customSlider.topPadding + customSlider.availableHeight / 2 - height / 2
                            implicitWidth: 200
                            implicitHeight: 6
                            width: customSlider.availableWidth
                            height: implicitHeight
                            radius: 3
                            color: settingsWindow.draftBorderPill

                            Rectangle {
                                width: customSlider.visualPosition * parent.width
                                height: parent.height
                                color: settingsWindow.draftAccentNormal
                                radius: 3
                            }
                        }

                        handle: Rectangle {
                            x: customSlider.leftPadding + customSlider.visualPosition * (customSlider.availableWidth - width)
                            y: customSlider.topPadding + customSlider.availableHeight / 2 - height / 2
                            implicitWidth: 16
                            implicitHeight: 16
                            radius: 8
                            color: customSlider.pressed ? Qt.darker(settingsWindow.draftAccentNormal, 1.15) : settingsWindow.draftAccentNormal
                            border.color: settingsWindow.draftSurfacePill
                            border.width: 3
                        }
                    }
                }

                // Divider Line
                Rectangle { Layout.fillWidth: true; height: 1; color: settingsWindow.draftBorderPill }

                // Multi-Option Segment Button Selection Block
                RowLayout {
                    Layout.fillWidth: true
                    
                    ColumnLayout {
                        spacing: 1
                        Layout.fillWidth: true
                        Text { 
                            text: "Shell Panel Structural Corner Style" 
                            color: settingsWindow.draftTextPrimary 
                            font.weight: Font.Medium 
                            font.pixelSize: 12 
                        }
                    }

                    RowLayout {
                        spacing: 0
                        property bool isRounded: true

                        Button {
                            id: rectStyleBtn
                            flat: true
                            Layout.preferredWidth: 90
                            Layout.preferredHeight: 28
                            
                            background: Rectangle {
                                color: !parent.isRounded ? settingsWindow.draftAccentNormal : Qt.darker(settingsWindow.draftSurfacePill, 1.2)
                                border.color: settingsWindow.draftBorderPill
                                topLeftRadius: 6; bottomLeftRadius: 6
                            }
                            contentItem: Text {
                                text: "Rectangular"
                                color: !rectStyleBtn.parent.isRounded ? settingsWindow.draftBgBase : settingsWindow.draftTextMuted
                                font.pixelSize: 11
                                font.weight: !rectStyleBtn.parent.isRounded ? Font.DemiBold : Font.Normal
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: parent.isRounded = false
                        }

                        Button {
                            id: roundStyleBtn
                            flat: true
                            Layout.preferredWidth: 90
                            Layout.preferredHeight: 28

                            background: Rectangle {
                                color: parent.isRounded ? settingsWindow.draftAccentNormal : Qt.darker(settingsWindow.draftSurfacePill, 1.2)
                                border.color: settingsWindow.draftBorderPill
                                topRightRadius: 6; bottomRightRadius: 6
                            }
                            contentItem: Text {
                                text: "Rounded Pill"
                                color: roundStyleBtn.parent.isRounded ? settingsWindow.draftBgBase : settingsWindow.draftTextMuted
                                font.pixelSize: 11
                                font.weight: roundStyleBtn.parent.isRounded ? Font.DemiBold : Font.Normal
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: parent.isRounded = true
                        }
                    }
                }
            }
        }
    }

    // --- Bottom Section: Full Width Asset Paths ---
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: pathContent.implicitHeight + 28
        color: settingsWindow.draftSurfacePill
        border.color: settingsWindow.draftBorderPill
        border.width: 1
        radius: 12

        ColumnLayout {
            id: pathContent
            anchors.fill: parent
            anchors.margins: 14
            spacing: 14

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 6
                Text { 
                    text: "Primary Wallpaper File Target Path"
                    color: settingsWindow.draftTextPrimary
                    font.weight: Font.Medium
                    font.pixelSize: 12 
                }
                TextField {
                    text: settingsWindow.draftBackgroundImage
                    color: settingsWindow.draftTextPrimary
                    placeholderText: "No background image configured (Using system fallback color matrices)"
                    placeholderTextColor: settingsWindow.draftTextMuted
                    font.pixelSize: 12
                    Layout.fillWidth: true
                    leftPadding: 10; rightPadding: 10
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
                    text: "Fallback Graphic Target Location"
                    color: settingsWindow.draftTextPrimary
                    font.weight: Font.Medium
                    font.pixelSize: 12 
                }
                TextField {
                    text: settingsWindow.draftPlaceholderImage
                    color: settingsWindow.draftTextPrimary
                    placeholderText: "e.g., ../images/fallback.jpg"
                    placeholderTextColor: settingsWindow.draftTextMuted
                    font.pixelSize: 12
                    Layout.fillWidth: true
                    leftPadding: 10; rightPadding: 10
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
