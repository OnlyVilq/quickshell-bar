import QtQuick
import Quickshell


Rectangle {
    id: root
    anchors {
        verticalCenter: parent.verticalCenter
    }
    

    property bool isExpanded: false

    Timer {
        id: expandedTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: isExpanded = false
    }


    width: isExpanded ? 200 : theme.height
    height: theme.height
    radius: theme.radius

    property color basecolor: theme.background
    color: mouseArea.containsMouse ? theme.foreground : root.basecolor

    MouseArea {
        id: mouseArea // WAŻNE: Musimy dać id, żeby Rectangle go widział
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        // 4. WŁĄCZENIE ŚLEDZENIA (Bez tego containsMouse nie zadziała!)
        hoverEnabled: true 

        onClicked: {
            console.log("Kliknięto Power Menu ")
            //isExpanded = !isExpanded
            menuPopup.visible = !menuPopup.visible
        }
        //onEntered: expandedTimer.stop()
        //onExited: expandedTimer.start()
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

    Text{
        color: theme.text
        anchors.centerIn: parent
        text: "󰣇"
    }

    PopupWindow{
        id: menuPopup
        anchor.window: root
        anchor.rect.x: 100
        anchor.rect.y: 100
        implicitHeight: 500
        implicitWidth: 500
        color: theme.foreground
    }
}
