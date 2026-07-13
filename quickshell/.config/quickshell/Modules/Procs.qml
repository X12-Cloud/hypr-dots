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
    property bool isDndActive: root.globalDnd
    property bool isNightLightActive: false
    property bool keepSysAwake: false

    // Core Metrics
    property real cpuUsage: 0.0
    property real memUsage: 0.0
    property real diskUsage: 0.0
    property real cpuTemp: 0.0

    // Extra Metrics
    property string cpuFreq: "Dynamic"
    property string loadAvg: "Nominal"
    property string memBuffers: "Optimized"
    property string swapUsage: "0"
    property string cpuGovernor: "Performance"
    property string diskIO: "Idle"
    property string diskMountPoint: "[ / ]"

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
        root.globalDnd = !root.globalDnd
        //run(dndToggleProcess)
    }
    function execNLToggle() {
        procs.isNightLightActive = !procs.isNightLightActive

        if (procs.isNightLightActive) {
            nightLightToggle.command = ['hyprctl', 'eval', 'hl.config({ decoration = { screen_shader = "/home/x12/.config/hypr/shaders/blue-light.glsl" } })'];
        } else {
            nightLightToggle.command = ['hyprctl', 'eval', 'hl.config({ decoration = { screen_shader = "[[EMPTY]]" } })'];
        }

        nightLightToggle.running = false;
        nightLightToggle.running = true;
    }
    function toggleSystemAwake() {
        run(awakeToggle);
    }

    // Combined Data Fetching via Multi-Statement Shell Scripts
    Process {
        id: cpuPercentage
        command: ["sh", "-c", "usage=$(top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'); freq=$(lscpu | grep 'CPU MHz' | awk '{print $3}'); load=$(cat /proc/loadavg | awk '{print $1}'); echo \"$usage||$freq||$load\""]
        stdout: SplitParser {
            onRead: (data) => {
                let parts = data.trim().split("||");
                if (parts.length >= 3) {
                    procs.cpuUsage = parseFloat(parts[0]) || 0;
                    procs.cpuFreq = parts[1] ? Math.round(parseFloat(parts[1])) + " MHz" : "Dynamic";
                    procs.loadAvg = parts[2] || "Nominal";
                }
            }
        }
    }
    Process {
        id: ramPercentage
        command: ["sh", "-c", "free | awk '/Mem:/ {print ($3/$2)*100 \"||\" ($6+$7)/1024/1024} /Swap:/ {print \"||\" ($2 > 0 ? ($3/$2)*100 : 0)}' | tr -d '\\n'"]
        stdout: SplitParser {
            onRead: (data) => {
                let parts = data.trim().split("||");
                if (parts.length >= 3) {
                    procs.memUsage = parseFloat(parts[0]) || 0;
                    procs.memBuffers = parts[1] ? parseFloat(parts[1]).toFixed(1) + " GB" : "Optimized";
                    procs.swapUsage = parts[2] ? Math.round(parseFloat(parts[2])).toString() : "0";
                }
            }
        }
    }
    Process {
        id: diskPercentage
        command: ["sh", "-c", "df / | awk 'NR==2 {print $5 \"||\" $6}'; iostat -c 1 1 | awk 'NR==4 {print $1}'"]
        stdout: SplitParser {
            onRead: (data) => {
                let clean = data.trim().replace(/\n/g, "||");
                let parts = clean.split("||");
                if (parts.length >= 2) {
                    procs.diskUsage = parseFloat(parts[0].replace("%", "")) || 0;
                    procs.diskMountPoint = parts[1] ? "[ " + parts[1] + " ]" : "[ / ]";
                    procs.diskIO = parts[2] && parseFloat(parts[2]) > 5.0 ? "Active" : "Idle";
                }
            }
        }
    }
    Process {
        id: cpuTemperature
        command: ["sh", "-c", "temp=$(cat /sys/class/hwmon/hwmon*/temp1_input | head -n 1 | awk '{print $1/1000}'); gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'N/A'); echo \"$temp||$gov\""]
        stdout: SplitParser {
            onRead: (data) => {
                let parts = data.trim().split("||");
                if (parts.length >= 2) {
                    procs.cpuTemp = parseFloat(parts[0]) || 0;
                    procs.cpuGovernor = parts[1] ? parts[1].charAt(0).toUpperCase() + parts[1].slice(1) : "Performance";
                }
            }
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
        command: ["sh", "-c", "uptime -p | sed -e 's/^up /Up /' -e 's/ days\\?/d/' -e 's/ hours\\?,\\?/h/' -e 's/ minutes\\?/m/'"]
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
        id: getSsid
        command: [
            "sh", "-c", 
            "ssid=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2); " +
            "if [ -z \"$ssid\" ] && ip route | grep -q '^default'; then ssid='Ethernet'; fi; " +
            "state=$(nmcli networking connectivity); " +
            "echo \"$ssid||$state\""
        ]
        stdout: SplitParser {
            onRead: (data) => {
                let parts = data.trim().split("||");
                let ssidName = parts[0] || "";
                let networkState = parts[1] || "none";

                if (ssidName.length === 0 || networkState === "none") {
                    procs.currentSsid = "Disconnected";
                } else if (networkState === "limited") {
                    procs.currentSsid = ssidName + " (No Internet)";
                } else if (networkState === "portal") {
                    procs.currentSsid = ssidName + " (Sign In)";
                } else {
                    procs.currentSsid = ssidName;
                }
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

    Timer {
        interval: 2000; running: true; repeat: true
        onTriggered: {
            getUptime.running = true
            getSsid.running = true
            getBtDevice.running = true
            getMetadata.running = true
            getVol.running = true
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
