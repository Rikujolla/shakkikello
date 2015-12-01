import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("Fast chess")
    }

    /*CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: {
                //pageStack.clear()
                //Qt.resolvedUrl("../pages/Asetukset.qml")
            }
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-pause"
        }
    }*/
}

