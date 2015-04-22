import QtQuick 2.0

Item {
id: promotionBox
anchors.fill: parent

// PropertyAnimation voi lisätä tällä tyylikkyyttä

Rectangle {
    anchors.fill: parent
    id: overlay
    color: "#000000"
    opacity: 0.6
    // add a mouse area so that clicks outside
    // the dialog window will not do anything
    MouseArea {
        anchors.fill: parent
    }
}

// This rectangle is the actual popup
Rectangle {
    id: dialogWindow
    width: 340
    height: 68
//    radius: 10
    anchors.centerIn: parent

    Text {
        anchors.centerIn: parent
        text: "Promote queen"
    }

// Delete popup
    MouseArea{
        anchors.fill: parent
        onClicked: {
            // destroy object is needed when you dynamically create it
            promotionBox.destroy()
        }
    }
}


}
