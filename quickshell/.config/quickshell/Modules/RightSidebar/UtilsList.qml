import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "./../"

Rectangle {
    id: root
    Layout.fillWidth: true
    radius: 18
    color: shellContext ? shellContext.surfacePill : "#1C1C1E"
    property var shellContext: null

    Procs { id: localProcs }

    // Placeholder layout for your Calendar & Timer widgets
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Text {
            text: "Calendar & Tools"
            color: root.shellContext ? root.shellContext.textMuted : "#CAC4D0"
            font.pointSize: 10
            font.weight: Font.Medium
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Text {
                anchors.centerIn: parent
                text: "Calendar & Stopwatch incoming..."
                color: root.shellContext ? root.shellContext.textMuted : "#666666"
                font.pointSize: 9
            }
        }
    }
}
