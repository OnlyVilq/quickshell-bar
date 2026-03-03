import QtQuick
import Quickshell
import Quickshell.Services.UPower

Rectangle {
    id: root
    color:  
        (UPower.displayDevice.state == UPowerDeviceState.FullyCharged) ? "#080" : 
        (UPower.displayDevice.state == UPowerDeviceState.Charging) ? '#ffd900' : theme.background
    height: theme.height
    width: battery.implicitWidth+12
    radius: theme.radius

    visible: UPower.displayDevice.isPresent

    anchors {
        //right: parent.right
        //rightMargin: 15
        verticalCenter: parent.verticalCenter
    }

    Rectangle{
        color: theme.background
        height: battery.implicitHeight+2
        width: battery.implicitWidth+4
        radius: theme.radius
        anchors{
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
    }

    Text {
        id: battery
        color: theme.text
        anchors.centerIn: parent
        text: "󱃌 " + Math.round(UPower.displayDevice.percentage * 100) + "%"
    }


    Behavior on color {
        ColorAnimation {
            duration: 500
            easing.type: Easing.OutQuad
        }
    }
}