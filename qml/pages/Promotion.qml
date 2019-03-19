import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: promotionBox
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        id: overlay
        color: "#000000" //
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
        width: 5*Screen.width/8
        height: Screen.width/8
        color: "#dddea1" // Grid colors dddea1 and 997400 Kapu's colors fada5e and 664228
        //    radius: 10
        anchors.centerIn: parent
        GridView {
            id: promogrid
            cellWidth: Screen.width/8
            cellHeight: Screen.width/8
            anchors.fill: parent
            layoutDirection: isMyStart && turnWhite || !isMyStart && !turnWhite ? Qt.LeftToRight : Qt.RightToLeft
            model:promotionModel
            delegate: Image {
                id: pieceImage
                asynchronous: true
                source:  turnWhite ? piePat + white : piePat + black
                rotation: isMyStart ? 180 : 0
                sourceSize.width: promogrid.cellWidth
                sourceSize.height: promogrid.cellHeight

                // Delete popup
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        // destroy object is needed when you dynamically create it
                        waitPromo = false
                        promotedShort = stfish
                        turnWhite ? promotedLong = piePat + white : promotedLong = piePat + black
                        //console.log(waitPromo, promotedShort, promotedLong)
                        promotionBox.destroy()
                    }
                } //end MouseArea
            } //end Image
        } // end GridView
    } // end Rectangle


    ListModel {
        id: promotionModel
        ListElement {
            white: "Q.png"
            black: "q.png"
            stfish: "q"
        }
        ListElement {
            white: "R.png"
            black: "r.png"
            stfish: "r"
        }
        ListElement {
            white: "N.png"
            black: "n.png"
            stfish: "n"
        }
        ListElement {
            white: "B.png"
            black: "b.png"
            stfish: "b"
        }
        ListElement {
            white: "P.png"
            black: "p.png"
            stfish: "p"
        }
    }


}
