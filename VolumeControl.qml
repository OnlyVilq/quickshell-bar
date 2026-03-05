import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Rectangle {
    id: root

    height: theme.height
    width: volume.implicitWidth + 12
    radius: theme.radius

    property color basecolor: theme.background
    color: mouseArea.containsMouse ? theme.foreground : root.basecolor

    clip: true


    anchors {
        verticalCenter: parent.verticalCenter
    }

    Text{
        id: volume
        color: mouseArea.containsMouse ? theme.foregroundText : theme.text
        anchors.centerIn: parent
        //text: Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100) + "%"
        text: Pipewire.defaultAudioSink?.audio.muted? "" : "    " + Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100) + "%"

        Behavior on color {
            ColorAnimation {
                duration: 100 // czas w ms (0.2 sekundy)
                easing.type: Easing.OutQuad // Rodzaj ruchu (możesz usunąć, jeśli wolisz liniowy)
            }
        }
    }

    Behavior on color {
        ColorAnimation {
            duration: 100 // czas w ms (0.2 sekundy)
            easing.type: Easing.OutQuad // Rodzaj ruchu (możesz usunąć, jeśli wolisz liniowy)
        }
    }
    Behavior on width {
        NumberAnimation{
            duration: 200
            easing.type: Easing.OutQuad
        }
    }

    MouseArea {
        id: mouseArea // WAŻNE: Musimy dać id, żeby Rectangle go widział
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        // 4. WŁĄCZENIE ŚLEDZENIA (Bez tego containsMouse nie zadziała!)
        hoverEnabled: true 

        onClicked: {
            console.log("Kliknięto Mute: ")
            let audio = Pipewire.defaultAudioSink?.audio;
            if (audio) {
                // Zmień stan na przeciwny do obecnego
                audio.muted = !audio.muted;
            }
        }
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio
        
        function onVolumeChanged() {
            // Odświeża jak zmienisz głośność
        }
        
        // Dodaj to! Dzięki temu tekst zmieni się z procentów na ikonkę (lub odwrotnie)
        // w tej samej milisekundzie, w której klikniesz.
        function onMutedChanged() {
            // Pusta funkcja wymusza odświeżenie tekstu
        }
    }
    PwObjectTracker {
        objects: [ Pipewire.defaultAudioSink ]
    }
}