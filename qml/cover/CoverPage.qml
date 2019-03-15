import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id:fastchessCover

    Image{
        source:"cover_board.png"
        width: 0.34*fastchessCover.height
        height: 0.34*fastchessCover.height
        opacity: 0.2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: label.top
    }

    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("Fast chess")
    }

    Image{
        source:"cover_clock.png"
        width: 0.321*fastchessCover.height
        height: 0.136*fastchessCover.height
        opacity: 0.2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: label.bottom
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "cover_action_board.png"
            onTriggered: {
                pageStack.clear()
                pageStack.push(Qt.resolvedUrl("../pages/Boardview.qml"))
                window.activate()
            }
        }

        CoverAction {
            iconSource: "cover_action_clock.png"
            onTriggered: {
                pageStack.clear()
                pageStack.push(Qt.resolvedUrl("../pages/Pelisivu.qml"))
                window.activate()
            }
        }
    }
}

