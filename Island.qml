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


    property var currentPlayer: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

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
            if (Mpris.players.values[0].isPlaying){
                return "  " + Mpris.players.values[0].trackTitle;
            }
            else if (Mpris.players.values[0].trackTitle.length == 0){
                return ""
            }
            else if (!(Mpris.players.values[0].isPaused == false && root.currentPlayer)){
                return "  " + Mpris.players.values[0].trackTitle;
            }
            else {
                return ""
            }
        }

    }
}