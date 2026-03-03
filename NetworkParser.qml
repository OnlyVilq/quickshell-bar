import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    // Właściwości, które trzymamy "w pamięci" widgetu
    property string ssid: "Rozłączono"
    //property int signalStrength: 0
    property bool isConnected: false

    // Wygląd prostokąta
    property color basecolor: isConnected ? theme.background : theme.alert // Zielony/Niebieski jak jest net, Czerwony jak nie ma

    color: mouseArea.containsMouse ? theme.foreground : root.basecolor
    radius: theme.radius
    height: theme.height
    
    // Szerokość dopasowuje się do tekstu w środku + marginesy
    width: contentRow.implicitWidth + 20

    // 1. PROCES SPRAWDZAJĄCY WIFI
    // Komenda: nmcli -t -f active,ssid,signal dev wifi | grep '^yes'
    // Zwraca np.: yes:MojeWiFi_5G:82
    Process {
        id: nmcli
        command: ["bash", "-c", "nmcli -t -f active,ssid,signal dev wifi | grep '^yes'"]
        
        stdout: SplitParser {
            onRead: data => {
                // Czyścimy śmieci (białe znaki)
                let cleanData = data.trim();

                if (cleanData !== "") {
                    // Mamy połączenie! Parsujemy wynik
                    let parts = cleanData.split(":");
                    // parts[0] to "yes", parts[1] to SSID, parts[2] to sygnał
                    
                    if (parts.length >= 3) {
                        root.ssid = parts[1];
                        //root.signalStrength = parseInt(parts[2]);
                        root.isConnected = true;
                    }
                } else {
                    // Komenda nic nie zwróciła (grep nie znalazł 'yes'), więc nie ma WiFi
                    root.ssid = "Brak sieci";
                    //root.signalStrength = 0;
                    root.isConnected = false;
                }
            }
        }
    }

    // 2. TIMER (Odświeżanie)
    // Odpalamy sprawdzanie co 5 sekund
    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: nmcli.running = true
    }

    // 3. WYGLĄD (Ikona + Tekst)
    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 5

        // Tutaj możesz dać ikonkę (jeśli masz czcionkę z ikonami)
        // Na razie dajemy prosty tekst z % sygnału
        Text {
            visible: root.isConnected
            //text: root.signalStrength + "%" 
            color: theme.text
            font.bold: true
        }

        Text {
            text: root.ssid
            color: theme.text
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 100 // czas w ms (0.2 sekundy)
            easing.type: Easing.OutQuad // Rodzaj ruchu (możesz usunąć, jeśli wolisz liniowy)
        }
    }

    // 4. KLIKANIE
    MouseArea {
        id: mouseArea // WAŻNE: Musimy dać id, żeby Rectangle go widział
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        // 4. WŁĄCZENIE ŚLEDZENIA (Bez tego containsMouse nie zadziała!)
        hoverEnabled: true 

        onClicked: {
            console.log("Kliknięto WiFi: " + root.ssid)
        }
    }

}