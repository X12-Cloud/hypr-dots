import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: procs

    property string currentSsid: "Disconnected"
    property alias volumeSetter: volumeSetter
    property alias wifiToggle: wifiToggle
    property alias btManager: btManager

    function run(proc) {
        //if (proc.running) proc.kill();
        proc.running = false;
        proc.running = true;
    }

    // WiFi Fetcher
    Process {
        id: getSsid
        command: ["sh", "-c", "nmcli -t -f NAME connection show --active | head -n 1"]
        stdout: SplitParser {
            onRead: (data) => {
                let name = data.trim();
                procs.currentSsid = name.length > 0 ? name : "No WiFi";
            }
        }
    }

    // Volume Slider
    Process {
        id: volumeSetter
        function updateVol(val) {
            command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", val];
            if (running) terminate();
            running = true;
        }
    }

    // WiFi Toggle/Manager
    Process {
        id: wifiToggle
        command: ["/bin/sh", "-c", "nmcli radio wifi | grep -q enabled && nmcli radio wifi off || nmcli radio wifi on"]
    }

    Process {
        id: wifiManager
        command: ["/bin/sh", "-c", "nm-connection-editor"]
    }

    // Bluetooth Manager
    Process {
        id: btManager
        command: ["blueman-manager"]
    }

    // Update SSID every 10 seconds
    Timer {
        interval: 10000; running: true; repeat: true
        onTriggered: getSsid.running = true
        triggeredOnStart: true
    }
}
