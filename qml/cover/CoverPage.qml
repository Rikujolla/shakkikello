import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("Fast chess")
    }

    // /*
    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "../pages/vaihtoValkoinen.png"
            onTriggered: {
                pageStack.clear()
                pageStack.push(Qt.resolvedUrl("../pages/Pelisivu.qml"))
                window.activate()
            }
        }

        CoverAction {
            iconSource: "../pages/images/grid.png"
            onTriggered: {
                pageStack.clear()
                pageStack.push(Qt.resolvedUrl("../pages/Boardview.qml"))
                window.activate()
            }
        }
    }
    //*/
}

