import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: procs

    property string currentSsid: "Disconnected"
    property string currentBtDevice: "Disconnected"
    property string trackTitle: "Nothing Playing"
    property string trackArtist: "Unknown Artist"
    property bool isPlaying: false
    property string trackArt: ""
    property real currentVolume: 0.0

    property alias volumeSetter: volumeSetter
    property alias wifiToggle: wifiToggle
    property alias wifiManager: wifiManager
    property alias btManager: btManager
    property alias mediaNext: mediaNext
    property alias mediaToggle: mediaToggle
    property alias mediaPrev: mediaPrev


    function run(proc) {
        //if (proc.running) proc.kill();
        proc.running = false;
        proc.running = true;
    }

    // WiFi/BT Fetcher
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

    Process {
        id: getBtDevice
        command: ["sh", "-c", "bluetoothctl info | grep 'Name:' | cut -d: -f2 || echo 'Disconnected'"]
        stdout: SplitParser {
            onRead: (data) => {
                let name = data.trim();
                procs.currentBtDevice = name.length > 0 ? name : "Disconnected";
            }
        }
    }

    // Volume Slider/Fetcher
    Process {
        id: volumeSetter
        function updateVol(val) {
            command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", val];
            if (running) terminate();
            running = true;
        }
    }

    Process {
        id: getVol
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}'"]
        stdout: SplitParser {
            onRead: (data) => { procs.currentVolume = parseFloat(data.trim()) || 0 }
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

    // Media
    Process {
        id: mediaNext
        command: ["playerctl", "next"]
    }

    Process {
        id: mediaToggle
        command: ["playerctl", "play-pause"]
    }

    Process {
        id: mediaPrev
        command: ["playerctl", "previous"]
    }

    Process {
        id: getMetadata
        command: ["sh", "-c", "playerctl metadata --format '{{title}}||{{artist}}||{{status}}||{{mpris:artUrl}}'"]
        stdout: SplitParser {
            onRead: (data) => {
                let parts = data.split("||");
                if (parts.length === 4) {
                    procs.trackTitle = parts[0].trim() || "Stopped";
                    procs.trackArtist = parts[1].trim() || "No Media";
                    procs.isPlaying = (parts[2].trim() === "Playing");
                    procs.trackArt = parts[3].trim() || "";
                }
            }
        }
    }

    // Update every 5 seconds
    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: {
            getSsid.running = true
            getBtDevice.running = true
            getMetadata.running = true
            getVol.running = true
        }
        triggeredOnStart: true
    }
}
