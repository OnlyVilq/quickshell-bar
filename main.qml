import QtQuick
import QtQml
import Quickshell
import Quickshell.Hyprland

ShellRoot {
	id: root

    Theme { id: theme }



	// 1. Zamiast bawić się w "Socket", używamy gotowej właściwości Hyprlanda
	// Szukamy ekranu z Quickshella, który ma taką samą nazwę jak obecny monitor z Hyprlanda.
	property var activeScreen: {
		let monitorName = Hyprland.focusedMonitor?.name;
		if (!monitorName) return Quickshell.screens[0]; // Zabezpieczenie przy starcie
		
		return Quickshell.screens.find(s => s.name === monitorName) ?? Quickshell.screens[0];
	}

    Instantiator {
        model: Quickshell.screens

        Timer {
            interval: 10000
            running: true
            repeat: true
            onTriggered: panel.currentTime = Qt.formatTime(new Date(), "HH:mm")
        }

        PanelWindow {
            id: panel
            // Panel automatycznie przeskoczy na monitor, na którym aktualnie pracujesz
            screen: modelData

            property string currentTime: Qt.formatTime(new Date(), "HH:mm")

            // Kotwice Waylandowe (gdzie okno ma się przykleić na ekranie)
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

            Text {
            	color: theme.foreground
            	anchors.centerIn: parent
            	text: modelData.name
            }


            //Left side
            Row {
                Workspace {
                    anchors.verticalCenter: parent.verticalCenter
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
                Rectangle {
                    color: theme.background
                    height: theme.height
                    width: date.implicitWidth + 12
                    radius: theme.radius
                    
                    anchors {
                        //right: parent.right
                        //rightMargin: 15
                        verticalCenter: parent.verticalCenter
                    }
                    Text {
                        id: date
                        anchors.centerIn: parent 
                        color: theme.text
                        text: panel.currentTime
                    }
                }
            }
        }
    }
}