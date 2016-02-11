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
        GridView {
            id: promogrid
            cellWidth: 68
            cellHeight: 68
            anchors.fill: parent
            layoutDirection: isMyStart && turnWhite || !isMyStart && !turnWhite ? Qt.LeftToRight : Qt.RightToLeft
            model:promotionModel
            delegate: Image {
                id: pieceImage
                asynchronous: true
                source:  turnWhite ? white : black
                rotation: isMyStart ? 180 : 0
                sourceSize.width: promogrid.cellWidth
                sourceSize.height: promogrid.cellHeight
                //Text {
                //     anchors.centerIn: parent
                //    text: turnWhite ? "Promote Queen" : "Promote queen"
                //}

                //Canvas {id: movearrows}

                // Delete popup
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        // destroy object is needed when you dynamically create it
                        waitPromo = false
                        promotedShort = stfish
                        turnWhite ? promotedLong = white : promotedLong = black
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
                white: "images/Q.png"
                black: "images/q.png"
                stfish: "q"
            }
            ListElement {
                white: "images/R.png"
                black: "images/r.png"
                stfish: "r"
            }
            ListElement {
                white: "images/N.png"
                black: "images/n.png"
                stfish: "n"
            }
            ListElement {
                white: "images/B.png"
                black: "images/b.png"
                stfish: "b"
            }
            ListElement {
                white: "images/P.png"
                black: "images/p.png"
                stfish: "p"
            }
    }


}
