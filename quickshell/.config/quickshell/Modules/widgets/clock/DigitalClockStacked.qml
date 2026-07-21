import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string timeFormat: "hh:mm AP"
    property string dateFormat: "ddd, dd/MM"
    property string hours: "hh"
    property string minutes: "mm"

    property color textColor: "#FFFFFF"
    property color textColorHrs: "#FFFFFF"
    property int textSize: 80

    property var currentTime: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentTime = new Date()
    }

    implicitWidth: clockLayout.implicitWidth
    implicitHeight: clockLayout.implicitHeight

    RowLayout {
        id: clockLayout
        anchors.centerIn: parent
        spacing: 12

        Text {
            text: Qt.formatDateTime(root.currentTime, "ddd")
            color: root.textColor
            font.pixelSize: root.textSize / 2
            font.bold: false
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            spacing: -30
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: {
                    var h = root.currentTime.getHours();
                    if (h > 12) h = h - 12;
                    return h < 10 ? "0" + h : h.toString();
                }
                color: root.textColorHrs
                font.pixelSize: root.textSize + 15
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: Qt.formatDateTime(root.currentTime, root.minutes)
                color: root.textColor
                font.pixelSize: root.textSize
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
        }

        Text {
            text: Qt.formatDateTime(root.currentTime, "ap")
            color: root.textColor
            font.pixelSize: root.textSize / 2
            font.bold: false
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
