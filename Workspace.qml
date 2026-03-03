import QtQuick
import Quickshell
import Quickshell.Hyprland

Row {
    id: root
    anchors {
        //left: parent.left
        //leftMargin: 15
        verticalCenter: parent.verticalCenter
    }

    spacing: theme.spacing


    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            width: theme.height
            height: theme.height
            radius: theme.radius

        

            color: (Hyprland.focusedWorkspace?.id === modelData.id) ? theme.foreground : theme.background
            Text {
                anchors.centerIn: parent // Wyśrodkuj tekst wewnątrz prostokąta
                color: theme.text
                text: modelData.name // Wyświetlamy nazwę, np. "1", "2"
            }

            Behavior on color {
                ColorAnimation {
                    duration: 200 // czas w ms (0.2 sekundy)
                    easing.type: Easing.OutQuad // Rodzaj ruchu (możesz usunąć, jeśli wolisz liniowy)
                }
            }
        }

    }
}