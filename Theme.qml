import QtQuick

// QtObject to taki czysty, niewidzialny klocek, który służy tylko do trzymania zmiennych
QtObject {
    property color background: '#575757'
    property color text: "#ffffff"
    property color activeWorkspace: "#44aaff" // Ładny niebieski dla aktywnego
    property color inactiveWorkspace: "#444444" // Szary dla nieaktywnego
    property color foreground: "#f0c674"
    property color foregroundText: '#000000'
    property color alert: "#ff5555"


    property int radius: 4
    property int spacing: 5
    property int height: 26
}