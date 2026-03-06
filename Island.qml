import QtQuick
import Quickshell
import Quickshell.Services.Mpris 

Rectangle{
    id: root
    color: rootMouseArea.containsMouse ? theme.foreground : theme.background
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
    property int drawerWidth: 350

    FrameAnimation {
  // only emit the signal when the position is actually changing.
  running: currentPlayer.playbackState == MprisPlaybackState.Playing
  // emit the positionChanged signal every frame.
  onTriggered: currentPlayer.positionChanged()
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
    MouseArea {
        id: rootMouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        
        hoverEnabled: true 
    }

    PopupWindow{
        id: menuPopup
        //visible: rootMouseArea.containsMouse || popupMouseArea.containsMouse
        visible: (drawer.height > 0)
        mask: Region { item:root }
        anchor.item: root


        anchor.edges: Edges.top
        anchor.gravity: Edges.Top 
        
        anchor.rect.x: root.width/2
        //anchor.rect.y: root.height-menuPopup.implicit.height-theme.height
        //anchor.rect.x: 100
        //anchor.rect.y: 100
        implicitHeight: 400
        implicitWidth: root.drawerWidth
        color: "transparent"

        Rectangle {
            id: drawer
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }
            height: {
                if (rootMouseArea.containsMouse){
                    popupColumn.implicitHeight+10
                }
                else {
                    0
                }
            }
            
            Behavior on height {
                NumberAnimation{
                    duration: 400
                    easing.type: Easing.OutQuad
                }
            }


            width: {
                if (popupColumn.implicitWidth < root.drawerWidth) {
                    popupColumn.implicitWidth
                }
                else {
                    300
                }
            }
            //idth: popupColumn.implicitWidth + 20

            radius: 10
            color: theme.background

            border.color: theme.foreground
            border.width: 1

            Column {
                id: popupColumn
                //anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                
                //player
                // Text {
                //     font.pointSize: 12
                //     anchors.horizontalCenter: parent.horizontalCenter

                //     text: root.currentPlayer.identity
                // }
                Text {
                    text: " "
                }

                //cover
                Image {
                    width: 200; height: 200
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    source: root.currentPlayer.trackArtUrl
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true

                }

                //title
                Text {
                    color: theme.foreground

                    font.bold: true
                    font.pointSize: 13
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    width: root.drawerWidth - 20 
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter

                    text: root.currentPlayer.trackTitle
                }

                //artist
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: ("by " + root.currentPlayer.trackArtist) || "Unknown Artist"
                    //text: "dupa"
                }

                //album
                Text {
                    font.pointSize: 12
                    anchors.horizontalCenter: parent.horizontalCenter
                    
                    text: root.currentPlayer.trackAlbum
                }
                
                //duration
                Rectangle {
                    id: duration
                    color: theme.foregroundText
                    width: {
                        if (root.currentPlayer.positionSupported){
                            200
                        }
                        else {
                            0
                        }
                    }
                    height: 5
                    radius: 5
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        color: theme.foreground
                        anchors {
                            left: parent.left
                            bottom: parent.bottom
                            top: parent.top
                        }
                        radius: parent.radius
                        height: parent.height
                        width: {
                            if (root.currentPlayer.positionSupported){
                                (root.currentPlayer.position/root.currentPlayer.length)*parent.width
                            }
                            else{
                                0
                            }
                        }
                    }
                }
            }
        }


        MouseArea{
            id: popupMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                
                hoverEnabled: true 
        }
    }

}