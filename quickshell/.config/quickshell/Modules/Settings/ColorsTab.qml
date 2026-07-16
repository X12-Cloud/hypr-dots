import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    Layout.fillWidth: true
    spacing: 16

    ColumnLayout {
        spacing: 4
        Text { 
            text: "UI Color Palette"
            color: settingsWindow.draftTextPrimary
            font.pixelSize: 20
            font.weight: Font.Bold 
        }
        Text { 
            text: "Tweak colors across base screens, accents, surfaces, and error boundaries."
            color: settingsWindow.draftTextMuted
            font.pixelSize: 12 
        }
    }

    GridLayout {
        id: colorsGrid
        columns: 2
        columnSpacing: 16
        rowSpacing: 16
        Layout.fillWidth: true

        Repeater {
            model: [
                { name: "Base Background", prop: "draftBgBase", def: settingsWindow.defBgBase, desc: "Primary window shell back" },
                { name: "Accent Highlight", prop: "draftAccentNormal", def: settingsWindow.defAccentNormal, desc: "Active states & glows" },
                { name: "Card Surface", prop: "draftSurfacePill", def: settingsWindow.defSurfacePill, desc: "Main content panels & blocks" },
                { name: "Border/Outline", prop: "draftBorderPill", def: settingsWindow.defBorderPill, desc: "Dividers, rings & borders" },
                { name: "Primary Text", prop: "draftTextPrimary", def: settingsWindow.defTextPrimary, desc: "High emphasis fonts" },
                { name: "Muted Text", prop: "draftTextMuted", def: settingsWindow.defTextMuted, desc: "Captions & subtext entries" },
                { name: "Error Accent", prop: "draftErrorAccent", def: settingsWindow.defErrorAccent, desc: "Core alert highlighting" },
                { name: "Error Surface", prop: "draftErrorSurface", def: settingsWindow.defErrorSurface, desc: "Warning boxes & backgrounds" }
            ]

            delegate: Rectangle {
                Layout.fillWidth: true 
                Layout.preferredHeight: 60
                color: settingsWindow.draftSurfacePill
                radius: 10
                border.color: settingsWindow.draftBorderPill

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 14
                    anchors.rightMargin: 14
                    spacing: 12

                    Rectangle {
                        width: 32
                        height: 32
                        radius: 16
                        color: settingsWindow[modelData.prop]
                        border.color: settingsWindow.draftBorderPill
                        border.width: 1
                    }

                    ColumnLayout {
                        spacing: 2
                        Layout.fillWidth: true 
                        
                        Text { 
                            text: modelData.name
                            color: settingsWindow.draftTextPrimary
                            font.pixelSize: 13
                            font.weight: Font.Medium 
                            elide: Text.ElideRight
                        }
                        Text { 
                            text: modelData.desc
                            color: settingsWindow.draftTextMuted
                            font.pixelSize: 10 
                            elide: Text.ElideRight
                        }
                    }

                    TextField {
                        text: settingsWindow[modelData.prop]
                        color: settingsWindow.draftTextPrimary
                        font.pixelSize: 11
                        font.family: "JetBrains Mono, monospace"
                        horizontalAlignment: Text.AlignHCenter
                        
                        background: Rectangle {
                            color: Qt.darker(settingsWindow.draftBgBase, 1.2)
                            border.color: parent.activeFocus ? settingsWindow.draftAccentNormal : settingsWindow.draftBorderPill
                            radius: 6
                            implicitWidth: 84
                            implicitHeight: 32
                        }
                        onEditingFinished: {
                            if (text.startsWith("#") && (text.length === 7 || text.length === 9)) {
                                settingsWindow[modelData.prop] = text;
                            }
                        }
                    }
                }
            }
        }
    }
}
