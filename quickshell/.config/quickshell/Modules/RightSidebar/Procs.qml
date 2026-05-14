import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: procs

    property string osName: "Unknown OS"
    property string currentSsid: "Disconnected"
    property string currentBtDevice: "Disconnected"
    property string trackTitle: "Nothing Playing"
    property string trackArtist: "Unknown Artist"
    property bool isPlaying: false
    property string trackArt: ""
    property real trackPosUs: 0.0
    property real trackLengthUs: 0.0
    property real percentage: 0.0
    property real currentVolume: 0.0
    property bool isDndActive: false
    property bool isNightLightActive: false

    property alias volumeSetter: volumeSetter
    property alias wifiToggle: wifiToggle
    property alias wifiManager: wifiManager
    property alias btManager: btManager
    property alias mediaNext: mediaNext
    property alias mediaToggle: mediaToggle
    property alias mediaPrev: mediaPrev

    function run(proc) {
        proc.running = false;
        proc.running = true;
    }

    Process {
        id: getOsName
        command: ["sh", "-c", "grep -oP 'PRETTY_NAME=\"\\K[^\"]+' /etc/os-release"]
        stdout: SplitParser {
            onRead: (data) => {
                let name = data.trim();
                procs.osName = name.length > 0 ? name : "Unknown OS";
            }
        }
    }

    Process {
        id: dndToggle
        command: ["sh", "-c", "makoctl mode | grep -q 'dnd' && makoctl mode -r dnd || makoctl mode -a dnd"]
    }
    Process {
        id: checkDnd
        command: ["sh", "-c", "makoctl mode"]
        stdout: SplitParser {
            onRead: (data) => { procs.isDndActive = data.includes("dnd") }
        }
    }

    Process {
        id: nightLightToggle
        command: ["sh", "-c", "pkill gammastep || gammastep -O 3500 &"]
    }
    Process {
        id: checkNightLight
        command: ["sh", "-c", "pgrep gammastep"]
        stdout: SplitParser {
            onRead: (data) => { procs.isNightLightActive = data.trim().length > 0 }
        }
    }

    // WiFi/BT Fetchers
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

    // WiFi & Bluetooth Toggles
    Process {
        id: wifiToggle
        command: ["/bin/sh", "-c", "nmcli radio wifi | grep -q enabled && nmcli radio wifi off || nmcli radio wifi on"]
    }
    Process {
        id: wifiManager
        command: ["/bin/sh", "-c", "nm-connection-editor"]
    }
    Process {
        id: btManager
        command: ["blueman-manager"]
    }

    // Media Actions
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

    // Metadata Fetcher (Hard-Syncs raw values every 2 seconds)
    Process {
        id: getMetadata
        command: ["playerctl", "metadata", "--format", "{{title}}||{{artist}}||{{status}}||{{mpris:artUrl}}||{{position}}||{{mpris:length}}"]
        stdout: SplitParser {
            onRead: (data) => {
                let parts = data.split("||");
                if (parts.length === 6) {
                    procs.trackTitle = parts[0].trim() || "Stopped";
                    procs.trackArtist = parts[1].trim() || "No Media";
                    procs.isPlaying = (parts[2].trim() === "Playing");
                    procs.trackArt = parts[3].trim() || "";
                    procs.trackPosUs = parseFloat(parts[4].trim()) || 0;
                    procs.trackLengthUs = parseFloat(parts[5].trim()) || 0;

                    if (procs.trackLengthUs > 0) {
                        procs.percentage = (procs.trackPosUs / procs.trackLengthUs) * 100;
                    } else {
                        procs.percentage = 0;
                    }
                }
            }
        }
    }

    Timer { // 10hz timer for media player progress bar
        id: progressTimer
        interval: 100
        running: procs.isPlaying
        repeat: true
        onTriggered: {
            if (procs.trackPosUs < procs.trackLengthUs) {
                procs.trackPosUs += 100000;
                procs.percentage = (procs.trackPosUs / procs.trackLengthUs) * 100;
            } else {
                procs.percentage = 100;
            }
        }
    }

    // Update every 2 seconds
    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: {
            getSsid.running = true
            getBtDevice.running = true
            getMetadata.running = true
            getVol.running = true
            checkNightLight.running = true
            checkDnd.running = true
        }
        triggeredOnStart: true
    }
    Component.onCompleted: {
        getOsName.running = true
    }
}
