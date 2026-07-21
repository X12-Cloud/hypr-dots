import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Background

    anchors {
        top: true
        right: true
    }

    margins {
        top: 100
        right: 150
    }

    color: "transparent"
    width: 300
    height: 300

    Canvas {
        id: clockBackground
        anchors.fill: parent

        property color fillColor: "#263144"
        property int spikes: 12
        property real bumpSize: 5

        Component.onCompleted: requestPaint()

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            ctx.shadowColor = "rgba(0, 0, 0, 0.4)" // Low opacity cuz it doesnt look great
            ctx.shadowBlur = 15;
            ctx.OffsetX = 3;
            ctx.OffsetY = 6;

            var centerX = width / 2;
            var centerY = height / 2;
            var baseRadius = Math.min(centerX, centerY) - bumpSize;

            ctx.fillStyle = fillColor;
            ctx.beginPath();

            var step = (Math.PI * 2) / 360;
            for (var i = 0; i <= 360; i++) {
                var angle = i * (Math.PI / 180);
                var r = baseRadius + bumpSize * Math.sin(angle * spikes);
                var x = centerX + r * Math.cos(angle);
                var y = centerY + r * Math.sin(angle);

                if (i === 0) {
                    ctx.moveTo(x, y);
                } else {
                    ctx.lineTo(x, y);
                }
            }

            ctx.closePath();
            ctx.fill();
        }
    }

    /* DropShadow {
        anchors.fill: clockBackground
        horizontalOffset: 0
        verticalOffset: 8
        radius: 16.0
        samples: 33
        color: "#80000000"
        source: clockBackground
    } */ // Doesnt work that well with the canvas

    Rectangle {
        id: secondsBadge
        width: 75
        height: 75
        radius: 40
        color: "#5A3E5D"

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.rightMargin: 10

        Text {
            anchors.centerIn: parent
            text: Qt.formatDateTime(clockWidget.currentTime, "ss")
            color: "#FDD8FF"
            font.pixelSize: 30
        }
    }

    DigitalClockStacked {
        id: clockWidget
        anchors.centerIn: parent
        textColor: "#4077B4"
        textColorHrs: "#C0E5FF"
        timeFormat: "HH:mm"
        dateFormat: "ddd, dd/MM"
    }

    Rectangle {
        id: dateBadge
        width: 80
        height: 80
        radius: 30
        color: "#C0E4FF"

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 15
        anchors.leftMargin: 15

        Text {
            anchors.centerIn: parent
            text: Qt.formatDateTime(clockWidget.currentTime, "dd")
            color: "#233141"
            font.pixelSize: 40
            font.bold: true
        }
    }
}
