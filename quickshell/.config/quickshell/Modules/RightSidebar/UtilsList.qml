import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "./../"

Rectangle {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 400
    radius: 18
    color: shellContext ? shellContext.surfacePill : "#1C1C1E"
    property var shellContext: null

    Procs { id: localProcs }

    // Calender and timer/stopwatch
}
