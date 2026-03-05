import QtQuick
import QtQml
import Quickshell

Rectangle {
    id: root
    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    property color basecolor: theme.background
    color: mouseArea.containsMouse ? theme.foreground : root.basecolor
    
    height: theme.height
    width: clockDisplay.implicitWidth + 12
    radius: theme.radius
    clip: true
    
    anchors {
        //right: parent.right
        //rightMargin: 15
        verticalCenter: parent.verticalCenter
    }
    Text {
        id: clockDisplay
        anchors.centerIn: parent 
        color: mouseArea.containsMouse ? theme.foregroundText : theme.text
        text: isExpanded ? Qt.formatDateTime(clock.date, "HH:mm:ss - dd.MM.yyyy") : Qt.formatDateTime(clock.date, "HH:mm")

        Behavior on color {
        ColorAnimation {
            duration: 200 // czas w ms (0.2 sekundy)
            easing.type: Easing.OutQuad // Rodzaj ruchu (możesz usunąć, jeśli wolisz liniowy)
        }
    }
    }


    property bool isExpanded: false
    Timer {
        id: expandedTimer
        interval: 5000
        running: false
        repeat: false
        onTriggered: isExpanded = false
    }

    MouseArea {
        id: mouseArea // WAŻNE: Musimy dać id, żeby Rectangle go widział
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        // 4. WŁĄCZENIE ŚLEDZENIA (Bez tego containsMouse nie zadziała!)
        hoverEnabled: true 

        onClicked: {
            console.log("Kliknięto Clock ")
            isExpanded = !isExpanded
        }
        onEntered: expandedTimer.stop()
        onExited: expandedTimer.start()
    }

    Behavior on width {
        NumberAnimation{
            duration: 200
            easing.type: Easing.OutQuad
        }
    }
    Behavior on color {
        ColorAnimation {
            duration: 200 // czas w ms (0.2 sekundy)
            easing.type: Easing.OutQuad // Rodzaj ruchu (możesz usunąć, jeśli wolisz liniowy)
        }
    }
}