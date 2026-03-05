import QtQuick
import Quickshell
import Quickshell.Services.Mpris 

Rectangle{
    id: root
    color: theme.background
    height: theme.height
    //width: player.implicitWidth+12
    radius: theme.radius
    clip: true

    //root.currentPlayer.identity == 'tidal-hifi'

    property var currentPlayer: {
        const players = Mpris.players.values;
        
        // Szukamy Tidala
        let p = players.find(player => player.identity === 'tidal-hifi');
        
        // Jeśli nie ma Tidala, szukamy Spotify (opcjonalnie)
        if (!p) {
            p = players.find(player => player.identity === 'Spotify');
        }
        
        return p || null;
    }

    // 2. Logika szerokości zależy od tego, czy mamy playera.
    width: (currentPlayer && player.implicitWidth > 0) ? player.implicitWidth + 12 : 0


    Behavior on width {
        NumberAnimation{
            duration: 200
            easing.type: Easing.OutQuad
        }
    }

    Text{
        id: player
        anchors.centerIn: parent
        color: theme.text
        // text: Mpris.players.values[0].isPlaying ? "  " + Mpris.players.values[0].trackTitle : "" +
        // Mpris.players.values[0].isPaused ? "  " + Mpris.players.values[0].trackTitle  : ""

        text: {
            if (root.currentPlayer.isPlaying){
                return "  " + root.currentPlayer.trackTitle;
            }
            else if (root.currentPlayer.trackTitle.length == 0){
                return ""
            }
            else if (!(root.currentPlayer.isPlaying == true && root.currentPlayer)){
                return "  " + root.currentPlayer.trackTitle;
            }
            else {
                return ""
            }
        }

    }


    //sekcja szuflady


}