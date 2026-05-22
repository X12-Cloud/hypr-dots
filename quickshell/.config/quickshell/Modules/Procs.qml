import QtQuick
import QtQml
import Quickshell
import Quickshell.Io

Item {
    id: procs

    property string osName: "Unknown OS"
    property string uptime: "Too long"
    property string currentSsid: "Disconnected"
    property string currentBtDevice: "Disconnected"
    property string currentSinkName: "Detecting Audio..."
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
    property bool keepSysAwake: false
    property real cpuUsage: 0.0
    property real memUsage: 0.0
    property real diskUsage: 0.0
    property real cpuTemp: 0.0

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

    function dndToggle() {
        procs.isDndActive = !procs.isDndActive
        run(dndToggleProcess)
    }
    function execNLToggle() {
        procs.isNightLightActive = !procs.isNightLightActive

        if (procs.isNightLightActive) {
            nightLightToggle.command = ["hyprctl", "keyword", "decoration:screen_shader", "/home/x12/.config/hypr/shaders/blue-light.glsl"];
        } else {
            nightLightToggle.command = ["hyprctl", "keyword", "decoration:screen_shader", "[[EMPTY]]"];
        }

        nightLightToggle.running = false;
        nightLightToggle.running = true;
    }
    function toggleSystemAwake() {
        run(awakeToggle);
    }

    Process {
        id: cpuPercentage
        command: ["sh", "-c", "top -bn1 | grep \"Cpu(s)\" | sed \"s/.*, *\\([0-9.]*\\)%* id.*/\\1/\" | awk '{print 100 - $1}'"]
        stdout: SplitParser {
            onRead: (data) => { procs.cpuUsage = parseFloat(data.trim()) || 0 }
        }
    }
    Process {
        id: ramPercentage
        command: ["sh", "-c", "free | grep Mem | awk '{print $3/$2 * 100.0}'"]
        stdout: SplitParser {
            onRead: (data) => { procs.memUsage = parseFloat(data.trim()) || 0 }
        }
    }
    Process {
        id: diskPercentage
        command: ["sh", "-c", "df / | awk 'NR==2 {print $5}' | sed 's/%//'"]
        stdout: SplitParser {
            onRead: (data) => { procs.diskUsage = parseFloat(data.trim()) || 0 }
        }
    }
    Process {
        id: cpuTemperature
        command: ["sh", "-c", "cat /sys/class/hwmon/hwmon*/temp1_input | awk '{print $1/1000}'"]
        stdout: SplitParser {
            onRead: (data) => { procs.cpuTemp = parseFloat(data.trim()) || 0 }
        }
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
        id: getUptime
        command: ["sh", "-c", "uptime -p | sed -e 's/^up /Up /' -e 's/ hours\\?,\\?/h/' -e 's/ minutes\\?/m/'"]
        stdout: SplitParser {
            onRead: (data) => {
                let time = data.trim();
                procs.uptime = time.length > 0 ? time : "Too long bro";
            }
        }
    }

    Process {
        id: dndToggleProcess
        command: ["sh", "-c", "makoctl mode | grep -q 'dnd' && makoctl mode -r dnd || makoctl mode -a dnd"]
    }
    Process { id: nightLightToggle }
    Process {
        id: awakeToggle
        command: ["sh", "-c", "pgrep -f 'Manual panel block' && pkill -f 'Manual panel block' || systemd-inhibit --why='Manual panel block' --what=idle sleep infinity &"]
    }

    Process {
        id: checkDnd
        command: ["sh", "-c", "makoctl mode"]
        stdout: SplitParser {
            onRead: (data) => { procs.isDndActive = data.includes("dnd") }
        }
    }
    Process {
        id: checkAwakeStatus
        command: ["sh", "-c", "systemd-inhibit --list --no-pager | grep -q 'Manual panel block' && echo 'true' || echo 'false'"]
        stdout: SplitParser {
            onRead: (data) => {
                procs.keepSysAwake = (data.trim() === "true");
            }
        }
    }

    Process {
        id: powerMenu
        command: ["sh", "-c", "wlogout -b 3 &"]
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

    // Current sound device
    Process {
        id: getSoundDevice
        command: ["sh", "-c", "wpctl status | grep -A 20 'Sinks:' | grep '*' | awk -F'.' '{print $2}' | sed -E 's/^[[:space:]]+[0-9]+ //; s/[[:space:]]+(\\[vol:.*\\]|\\[MUTED\\])//g' | tr -d '\\n'"]
        stdout: SplitParser {
            onRead: (data) => {
                let cleanName = data.trim();
                procs.currentSinkName = cleanName.length > 0 ? cleanName : "Default Sink";
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

    // Metadata Fetcher
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

    Timer {
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

    // Update loop
    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: {
            getUptime.running = true
            getSsid.running = true
            getBtDevice.running = true
            getMetadata.running = true
            getVol.running = true
            checkDnd.running = true
            checkAwakeStatus.running = true
            getSoundDevice.running = true

            cpuPercentage.running = true
            ramPercentage.running = true
            diskPercentage.running = true
            cpuTemperature.running = true
        }
        triggeredOnStart: true
    }
    Component.onCompleted: {
        getOsName.running = true
    }
}
