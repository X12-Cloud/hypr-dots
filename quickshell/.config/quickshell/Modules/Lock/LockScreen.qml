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
    property bool isDimmed: false

    // TODO: Will be used for the brightness control later
    Process { id: monitorProc }
    Process { id: keyboardProc }

    Process { id: powerProc }

    function setDimState(dim) {
        lockWindow.isDimmed = dim; // TODO: Make it dim the monitor brightness
    }

    function restoreBrightness() {
        if (lockWindow.isDimmed) {
            setDimState(false);
        }
        idleTimer.restart();
    }

    Timer {
        id: idleTimer
        interval: 300000
        running: true
        repeat: false
        onTriggered: lockWindow.setDimState(true)
    }

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateClock()
    }

    function updateClock() {
        var date = new Date();
        hoursText.text = Qt.formatDateTime(date, "HH");
        minutesText.text = Qt.formatDateTime(date, "mm");
        dateText.text = Qt.formatDateTime(date, "dddd, MMMM d");
    }

    Component.onCompleted: {
        updateClock();
        passwordInput.forceActiveFocus();
        lockWindow.uiScale = 1.0;
        lockWindow.uiOpacity = 1.0;
        idleTimer.start();
    }

    Process {
        id: authProc
        command: ["/home/x12/.config/quickshell/Modules/Lock/auth-helper"]
        stdinEnabled: true

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                lockWindow.setDimState(false);
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
            source: Qt.resolvedUrl("file://" + Quickshell.env("HOME") + "/Pictures/wallpapers/2054-3840x2160-desktop-4k-firewatch-background.jpg")
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
            hoverEnabled: true
            onPositionChanged: lockWindow.restoreBrightness()
            onPressed: lockWindow.restoreBrightness()
            onClicked: {
                lockWindow.restoreBrightness();
                passwordInput.forceActiveFocus();
                customPowerMenu.visible = false;
            }
        }

        RowLayout {
            id: typographyContainer
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 120
            spacing: 32
            scale: lockWindow.uiScale
            opacity: lockWindow.uiOpacity

            Behavior on scale { enabled: lockWindow.visible; PropertyAnimation { duration: 300; easing.type: Easing.OutCubic } }
            Behavior on opacity { PropertyAnimation { duration: 300; easing.type: Easing.InOutQuad } }

            Row {
                spacing: 8
                Text {
                    id: hoursText
                    font.pointSize: 130
                    font.weight: Font.Black
                    font.family: "Inter, Inter Display, Product Sans, Sans"
                    color: textPrimary
                }

                Text {
                    text: ":"
                    font.pointSize: 130
                    font.weight: Font.Black
                    font.family: "Inter, Inter Display, Product Sans, Sans"
                    color: accentNormal
                    opacity: 0.8
                }

                Text {
                    id: minutesText
                    font.pointSize: 130
                    font.weight: Font.Black
                    font.family: "Inter, Inter Display, Product Sans, Sans"
                    color: accentNormal
                }
            }

            Rectangle {
                Layout.preferredWidth: 2
                Layout.preferredHeight: 110
                color: borderPill
                opacity: 0.5
            }

            ColumnLayout {
                spacing: 4
                Layout.alignment: Qt.AlignVCenter

                Text {
                    id: dateText
                    font.pointSize: 22
                    font.weight: Font.Bold
                    font.family: "Inter, Product Sans, Sans"
                    color: textPrimary
                }

                Text {
                    text: "SYSTEM LOCKED"
                    font.pointSize: 11
                    font.weight: Font.DemiBold
                    font.family: "Inter, Product Sans, Sans"
                    color: accentNormal
                    font.letterSpacing: 3
                }
            }
        }

        // Dim the clock if u want cuz why not
        Rectangle {
            id: clockBlackOverlay
            anchors.fill: parent
            color: "#000000"
            opacity: lockWindow.isDimmed ? 0.45 : 0
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
            Behavior on opacity { PropertyAnimation { duration: 300; easing.type: Easing.InOutQuad } }

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
                    Text { font.family: "Material Symbols Rounded"; text: "\ue7fd"; font.pointSize: 16; color: textMuted }
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
                        State { name: "normal"; PropertyChanges { target: inputPill; border.color: borderPill; color: surfacePill } },
                        State { name: "error"; PropertyChanges { target: inputPill; border.color: errorAccent; color: errorSurface } }
                    ]
                    transitions: Transition { ColorAnimation { duration: 180 } }

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
                            onTextChanged: lockWindow.restoreBrightness()
                            onAccepted: {
                                if (text.length > 0) {
                                    lockWindow.restoreBrightness();
                                    authProc.running = false;
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
                                    width: 10; height: 10; radius: 5
                                    color: (index % 2 === 0) ? accentNormal : Qt.darker(accentNormal, 1.4)
                                    PropertyAnimation on scale { from: 0.4; to: 1.0; duration: 120; easing.type: Easing.OutBack }
                                }
                            }
                        }

                        Button {
                            id: confirmButton
                            implicitWidth: 36; implicitHeight: 36
                            background: Rectangle { radius: 18; color: confirmButton.hovered ? Qt.alpha(borderPill, 0.3) : "transparent" }
                            contentItem: Text {
                                font.family: "Material Symbols Rounded"
                                text: "\ue5c8"
                                font.pointSize: 16
                                color: passwordInput.text.length > 0 ? accentNormal : borderPill
                                horizontalAlignment: Text.AlignHCenter; verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: passwordInput.accepted()
                        }
                    }
                }
            }

            // Quick settings pill (Brightness & Power)
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

                        MouseArea {
                            id: brightnessMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                if (lockWindow.isDimmed) {
                                    lockWindow.restoreBrightness();
                                } else {
                                    lockWindow.setDimState(true);
                                }
                            }
                        }
                    }

                    Text {
                        id: powerButtonIcon
                        font.family: "Material Symbols Rounded"
                        text: "\ue8ac"
                        font.pointSize: 18
                        color: powerMouse.containsMouse || customPowerMenu.visible ? errorAccent : textMuted
                        MouseArea {
                            id: powerMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                lockWindow.restoreBrightness();
                                customPowerMenu.visible = !customPowerMenu.visible;
                            }
                        }

                        Rectangle {
                            id: customPowerMenu
                            visible: false
                            width: 150
                            height: 136
                            anchors.right: parent.right
                            anchors.rightMargin: -16
                            anchors.bottom: parent.top
                            anchors.bottomMargin: 24
                            color: surfacePill
                            border.color: borderPill
                            border.width: 1
                            radius: 16
                            transformOrigin: Item.BottomRight

                            onVisibleChanged: {
                                if (visible) {
                                    openAnim.restart();
                                }
                            }

                            ParallelAnimation {
                                id: openAnim
                                NumberAnimation { target: customPowerMenu; property: "scale"; from: 0.85; to: 1.0; duration: 200; easing.type: Easing.OutCubic }
                                NumberAnimation { target: customPowerMenu; property: "opacity"; from: 0.0; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
                            }

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 6
                                spacing: 2

                                component MenuButton : Rectangle {
                                    property string label: ""
                                    property var actionCommand: []
                                    id: btn
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    radius: 10
                                    color: btnMouse.containsMouse ? Qt.alpha(errorSurface, 0.5) : "transparent"
                                    Behavior on color { ColorAnimation { duration: 100 } }

                                    Text {
                                        anchors.centerIn: parent
                                        text: btn.label
                                        font.family: "Inter, sans-serif"
                                        font.weight: Font.Medium
                                        font.pointSize: 11
                                        color: btnMouse.containsMouse ? errorAccent : textPrimary
                                    }

                                    MouseArea {
                                        id: btnMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: {
                                            customPowerMenu.visible = false;
                                            if (btn.actionCommand.length > 0) {
                                                powerProc.command = btn.actionCommand;
                                                powerProc.running = true;
                                            }
                                        }
                                    }
                                }

                                MenuButton {
                                    label: "Sleep"
                                    actionCommand: ["systemctl", "suspend"]
                                }
                                MenuButton {
                                    label: "Reboot"
                                    actionCommand: ["systemctl", "reboot"]
                                }
                                MenuButton {
                                    label: "Shutdown"
                                    actionCommand: ["systemctl", "poweroff"]
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
