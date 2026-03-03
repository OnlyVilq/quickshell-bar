import QtQuick
import Quickshell
import Quickshell.Hyprland

Row {
    id: root
    property string targetMonitorName: ""
    anchors {
        //left: parent.left
        //leftMargin: 15
        verticalCenter: parent.verticalCenter
    }

    spacing: theme.spacing


    Repeater {
        model: {
            if (!Hyprland.workspaces.values) return [];
            
            return Hyprland.workspaces.values
                .filter(w => w.monitor.name === root.targetMonitorName)
                .sort((a, b) => a.id - b.id); // Dodatkowo sortujemy od 1 do 10
        }


        Rectangle {
            width: theme.height
            height: theme.height
            radius: theme.radius

        
            color: (Hyprland.focusedWorkspace?.id === modelData.id) ? theme.foreground : mouseArea.containsMouse ? theme.activeWorkspace : theme.background
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
            MouseArea {
                id: mouseArea // WAŻNE: Musimy dać id, żeby Rectangle go widział
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                hoverEnabled: true 
                
                onClicked: {
                    console.log("Kliknięto Workspace")
                    Hyprland.dispatch("workspace " + modelData.name)
                }
            }
            
        }

    }
}