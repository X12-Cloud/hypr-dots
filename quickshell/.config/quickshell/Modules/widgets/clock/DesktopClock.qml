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
        top: 150
        right: 150
    }

    color: "transparent"
    implicitWidth: 300
    implicitHeight: 150

    DigitalClock {
        id: clockWidget
        textColor: "#8AB4F8"
        timeFormat: "HH:mm"
        dateFormat: "ddd, dd/MM"
    }
}
