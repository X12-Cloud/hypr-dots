import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property string timeFormat: "hh:mm AP"
    property string dateFormat: "ddd, dd/MM"
    property string hours: "hh"
    property string minutes: "mm"

    property color textColor: "#FFFFFF"
    property int textSize: 72

    property var currentTime: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentTime = new Date()
    }

    implicitWidth: clockLayout.implicitWidth
    implicitHeight: clockLayout.implicitHeight

    ColumnLayout {
        id: clockLayout
        anchors.centerIn: parent
        spacing: 2

        Text {
            text: Qt.formatDateTime(root.currentTime, root.timeFormat)
            color: root.textColor
            font.pixelSize: root.textSize
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: Qt.formatDateTime(root.currentTime, root.dateFormat)
            color: root.textColor
            opacity: 0.7
            font.pixelSize: root.textSize / 2
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
