//@ pragma UseQApplication

import QtQuick
import Quickshell
import QtQuick.Controls
import "./Modules/Bar"

ShellRoot {
    id: root

    Loader {
        active: true
        sourceComponent: Bar{}
        z: 99
    }
}
