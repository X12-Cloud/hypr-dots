pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: lockWindow

    anchors.left: true
    anchors.right: true
    anchors.top: true
    anchors.bottom: true

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: WlrLayershell.Ignore
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    visible: true
    color: bgBase

    property color bgBase:         typeof root !== 'undefined' ? root.bgBase         : "#050B14"
    property color surfacePill:    typeof root !== 'undefined' ? root.surfacePill    : "#0C1625"
    property color borderPill:     typeof root !== 'undefined' ? root.borderPill     : "#1F314A"
    property color accentNormal:   typeof root !== 'undefined' ? root.accentNormal   : "#8AB4F8"
    property color textPrimary:    typeof root !== 'undefined' ? root.textPrimary    : "#E2E8F0"
    property color textMuted:      typeof root !== 'undefined' ? root.textMuted      : "#64748B"
    property color errorAccent:    typeof root !== 'undefined' ? root.errorAccent    : "#F2B8B5"
    property color errorSurface:   typeof root !== 'undefined' ? root.errorSurface   : "#2C161A"

    property real uiScale: 0.95
    property real uiOpacity: 0.0
    property string currentInputText: passwordInput.text

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var date = new Date();
            hoursText.text = date.toLocaleTimeString(Qt.locale(), "hh");
            minutesText.text = date.toLocaleTimeString(Qt.locale(), "mm");
            dateText.text = date.toLocaleDateString(Qt.locale(), "dddd, MMMM d");
        }
    }

    Component.onCompleted: {
        var date = new Date();
        hoursText.text = date.toLocaleTimeString(Qt.locale(), "hh");
        minutesText.text = date.toLocaleTimeString(Qt.locale(), "mm");
        dateText.text = date.toLocaleDateString(Qt.locale(), "dddd, MMMM d");

        passwordInput.forceActiveFocus();

        lockWindow.uiScale = 1.0;
        lockWindow.uiOpacity = 1.0;
    }

    Process {
        id: authProc
        command: ["./auth-helper"]
        stdinEnabled: true

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                if (typeof root !== 'undefined') {
                    root.isLocked = false;
                }
            } else {
                passwordInput.text = "";
                inputPill.state = "error";
                wrongPasswordShake.restart();
                errorReset.start();
            }
        }
    }

    Timer {
        id: errorReset
        interval: 1200
        onTriggered: inputPill.state = "normal"
    }

    Item {
        id: lockRoot
        anchors.fill: parent

        Image {
            id: backgroundWallpaper
            anchors.fill: parent
            source: Qt.resolvedUrl("file:///home/x12/Pictures/wallpapers/2054-3840x2160-desktop-4k-firewatch-background.jpg")
            fillMode: Image.PreserveAspectCrop
            smooth: true
            asynchronous: true
            visible: false
        }

        FastBlur {
            id: blurredWallpaper
            anchors.fill: parent
            source: backgroundWallpaper
            radius: 24
            opacity: lockWindow.uiOpacity

            Behavior on opacity { enabled: lockWindow.visible; PropertyAnimation { duration: 400; easing.type: Easing.OutQuad } }
        }

        Rectangle {
            id: blackOverlay
            anchors.fill: parent
            color: "#000000"
            opacity: 0.45
        }

        MouseArea {
            anchors.fill: parent
            onClicked: passwordInput.forceActiveFocus()
        }

        ColumnLayout {
            id: typographyContainer
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 100
            spacing: -40 

            scale: lockWindow.uiScale
            opacity: lockWindow.uiOpacity

            Behavior on scale { enabled: lockWindow.visible; PropertyAnimation { duration: 300; easing.type: Easing.OutCubic } }
            Behavior on opacity { enabled: lockWindow.visible; PropertyAnimation { duration: 250; easing.type: Easing.OutQuad } }

            Text {
                id: hoursText
                font.pointSize: 160
                font.weight: Font.ExtraBold
                font.family: "Inter, Inter Display, Product Sans, Sans"
                color: textPrimary
            }

            Text {
                id: minutesText
                font.pointSize: 160
                font.weight: Font.ExtraBold
                font.family: "Inter, Inter Display, Product Sans, Sans"
                color: accentNormal
            }

            Text {
                id: dateText
                font.pointSize: 18
                font.weight: Font.Medium
                font.family: "Inter, Product Sans, Sans"
                color: textMuted
                Layout.topMargin: 60
                Layout.leftMargin: 10
            }
        }

        Row {
            id: controlRow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 100
            spacing: 12

            scale: lockWindow.uiScale
            opacity: lockWindow.uiOpacity

            Behavior on scale { PropertyAnimation { duration: 300; easing.type: Easing.OutCubic } }
            Behavior on opacity { PropertyAnimation { duration: 250; easing.type: Easing.OutQuad } }

            Rectangle {
                width: 120
                height: 56
                radius: 28
                color: surfacePill
                border.width: 1
                border.color: borderPill

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 8

                    Text {
                        font.family: "Material Symbols Rounded"
                        text: "\ue7fd" 
                        font.pointSize: 16
                        color: textMuted
                    }
                    Text {
                        text: Quickshell.env("USER")
                        color: textPrimary
                        font.family: "Inter, sans-serif"
                        font.weight: Font.Medium
                        font.pointSize: 13
                    }
                }
            }

            Item {
                id: shakeWrapper
                width: 320
                height: 56

                SequentialAnimation {
                    id: wrongPasswordShake
                    loops: 2
                    PropertyAnimation { target: shakeWrapper; property: "x"; from: 0; to: -12; duration: 40; easing.type: Easing.OutQuad }
                    PropertyAnimation { target: shakeWrapper; property: "x"; from: -12; to: 12; duration: 70; easing.type: Easing.InOutQuad }
                    PropertyAnimation { target: shakeWrapper; property: "x"; from: 12; to: 0; duration: 40; easing.type: Easing.InQuad }
                }

                Rectangle {
                    id: inputPill
                    anchors.fill: parent
                    radius: 28
                    color: surfacePill
                    border.width: 1
                    border.color: borderPill

                    states: [
                        State {
                            name: "normal"
                            PropertyChanges { target: inputPill; border.color: borderPill; color: surfacePill }
                        },
                        State {
                            name: "error"
                            PropertyChanges { target: inputPill; border.color: errorAccent; color: errorSurface }
                        }
                    ]

                    transitions: Transition {
                        ColorAnimation { duration: 180 }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 12
                        spacing: 12

                        Text {
                            font.family: "Material Symbols Rounded"
                            text: inputPill.state === "error" ? "\ue002" : "\ue897" 
                            font.pointSize: 16
                            color: inputPill.state === "error" ? errorAccent : textMuted
                            Layout.alignment: Qt.AlignVCenter
                        }

                        TextField {
                            id: passwordInput
                            Layout.fillWidth: true
                            font.pointSize: 13
                            font.family: "Inter, Roboto, sans-serif"
                            color: lockWindow.currentInputText.length > 0 ? "transparent" : textPrimary
                            echoMode: TextInput.Normal
                            background: Item {}
                            enabled: !authProc.running

                            onAccepted: {
                                if (text.length > 0) {
                                    authProc.running = true;
                                    authProc.write(text + "\n");
                                }
                            }
                        }

                        Row {
                            id: customMaskRepeater
                            Layout.alignment: Qt.AlignVCenter
                            spacing: 6
                            
                            Repeater {
                                model: lockWindow.currentInputText.length
                                delegate: Rectangle {
                                    id: dotItem
                                    required property int index
                                    width: 10
                                    height: 10
                                    radius: 5
                                    color: (index % 2 === 0) ? accentNormal : Qt.darker(accentNormal, 1.4)

                                    PropertyAnimation on scale {
                                        from: 0.4
                                        to: 1.0
                                        duration: 120
                                        easing.type: Easing.OutBack
                                    }
                                }
                            }
                        }

                        Button {
                            id: confirmButton
                            implicitWidth: 36
                            implicitHeight: 36
                            background: Rectangle {
                                radius: 18
                                color: confirmButton.hovered ? Qt.alpha(borderPill, 0.3) : "transparent"
                            }

                            contentItem: Text {
                                font.family: "Material Symbols Rounded"
                                text: "\ue5c8" 
                                font.pointSize: 16
                                color: passwordInput.text.length > 0 ? accentNormal : borderPill
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: passwordInput.accepted()
                        }
                    }
                }
            }

            Rectangle {
                width: 100
                height: 56
                radius: 28
                color: surfacePill
                border.width: 1
                border.color: borderPill

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 14

                    Text {
                        font.family: "Material Symbols Rounded"
                        text: "\uea0b" 
                        font.pointSize: 16
                        color: textMuted
                    }

                    Text {
                        font.family: "Material Symbols Rounded"
                        text: "\ue5cd" 
                        font.pointSize: 18
                        color: powerMouse.containsMouse ? errorAccent : textMuted
                        MouseArea {
                            id: powerMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (typeof root !== 'undefined') {
                                    root.isLocked = false;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
