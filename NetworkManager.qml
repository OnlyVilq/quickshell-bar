import QtQuick
import Quickshell
import Quickshell.Networking 

//Wi-Fi
Rectangle {
    id:root
    
    Theme { id: theme }

    //property color basecolor: isConnected ? theme.background : theme.alert // Zielony/Niebieski jak jest net, Czerwony jak nie ma
    property color basecolor: theme.background
    color: mouseArea.containsMouse ? theme.foreground : root.basecolor

    height: theme.height
    width: network.implicitWidth + 12
    radius: theme.radius

    anchors {
        verticalCenter: parent.verticalCenter
    }

    Text {
        id: network
        color: theme.text
        anchors.centerIn: parent
        //text: Networking.state == DeviceType.None 
        //text: Network.state
        readonly property WifiDevice connectedAdapter: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
        text: connectedAdapter?.networks.values.find(n => n.connected)?.name ?? "󰖪"

        
    }

    Behavior on color {
        ColorAnimation {
            duration: 100 // czas w ms (0.2 sekundy)
            easing.type: Easing.OutQuad // Rodzaj ruchu (możesz usunąć, jeśli wolisz liniowy)
        }
    }

    MouseArea {
        id: mouseArea // WAŻNE: Musimy dać id, żeby Rectangle go widział
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        // 4. WŁĄCZENIE ŚLEDZENIA (Bez tego containsMouse nie zadziała!)
        hoverEnabled: true 

        onClicked: {
            console.log("Kliknięto WiFi: ")
        }
    }
}