import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: promotionBox
    anchors.fill: parent

    property alias pro_piece: dialogWindow.proPiece
    property alias pro_color: dialogWindow.proColor
    property alias pro_index: dialogWindow.proIndex
    property alias turn_White: dialogWindow.turnWhite

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
        property string proPiece
        property string proColor
        property int proIndex
        property bool turnWhite
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
            layoutDirection: isMyStart && turn_White || !isMyStart && !turn_White ? Qt.LeftToRight : Qt.RightToLeft
            model:promotionModel
            delegate: Image {
                id: pieceImage
                asynchronous: true
                source:  turn_White ? piePat + white : piePat + black
                rotation: isMyStart ? 180 : 0
                sourceSize.width: promogrid.cellWidth
                sourceSize.height: promogrid.cellHeight

                // Delete popup
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        // destroy object is needed when you dynamically create it
                        //console.log(movedPieces.get(2).piece, movedPieces.get(2).color, movedPieces.get(2).indeksos)
                        waitPromo = false
                        promotedShort = stfish
                        turn_White ? promotedLong = piePat + white : promotedLong = piePat + black
                        movedPieces.set(2,{"color":pro_color, "piece":pro_piece, "indeksos":pro_index})
                        movedPieces.set(3,{"color":"x", "piece":"x", "indeksos":-1}) //Set dummy values
                        //console.log(movedPieces.get(2).piece, movedPieces.get(2).color, movedPieces.get(2).indeksos)
                        promotionBox.destroy()
                    }
                } //end MouseArea
            } //end Image
        } // end GridView
    } // end Rectangle

    //Component.onCompleted: {waitPromo = false;}

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
