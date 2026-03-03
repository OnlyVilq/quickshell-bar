import QtQuick
import QtQml
import Quickshell
import Quickshell.Hyprland

ShellRoot {
	id: root
    Theme { id: theme }

	property var activeScreen: {
		let monitorName = Hyprland.focusedMonitor?.name;
		if (!monitorName) return Quickshell.screens[0]; // Zabezpieczenie przy starcie
		
		return Quickshell.screens.find(s => s.name === monitorName) ?? Quickshell.screens[0];
	}

    Instantiator {
        model: Quickshell.screens

        PanelWindow {

            id: panel
            screen: modelData

            anchors {
                left: true
                bottom: true
                right: true
            }
            
            implicitHeight: 26
            color: "#00ffffff"
            
            // To mówi Hyprlandowi: "Zarezerwuj 30 pikseli od góry, nie wpychaj tu okien!"
            exclusiveZone: height
            visible: true 

            //Center
            Text {
            	color: theme.foreground
            	anchors.centerIn: parent
            	text: modelData.name
            }


            //Left side
            Row {
                spacing: theme.spacing
                PowerMenu {
                    anchors.verticalCenter: parent.verticalCenter
                }
                Workspace {
                    anchors.verticalCenter: parent.verticalCenter
                    targetMonitorName: modelData.name
                }
            }
            //right side
            Row {
                spacing: theme.spacing
            

                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                //Pipewire
                VolumeControl {
                    anchors.verticalCenter: parent.verticalCenter

                }
                //Wi-FI
                NetworkManager {
                    anchors.verticalCenter: parent.verticalCenter
                // Tu decydujesz gdzie leży
                }

                //battery
                Battery{
                    anchors.verticalCenter: parent.verticalCenter
                }

                //Date
                Date{
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}