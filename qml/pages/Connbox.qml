import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: connectionBox
    anchors.fill: parent

    // PropertyAnimation voi lisätä tällä tyylikkyyttä

    Rectangle {
        anchors.fill: parent
        id: overlay
        color: "#000000"
        opacity: 1.0
        // add a mouse area so that clicks outside
        // the dialog window will not do anything
        MouseArea {
            anchors.fill: parent
        }
    }
    Text {
        text: "MyIP: " + conTcpSrv.cipadd
        color: Theme.highlightColor
        anchors.bottom: text3.top
    }

    Text {
        id:text3
        text: "My port: " + conTcpSrv.cport
        color: Theme.highlightColor
        anchors.bottom: iipee.top
    }

    // This rectangle is the actual popup
    TextField {
        id: iipee
        text: ""
        anchors.centerIn: parent
        placeholderText: "192.168.1.70"
        label: qsTr("Server IP")
        //visible: openingMode == 2
        width: parent.width
        inputMethodHints: Qt.ImhNoPredictiveText
        EnterKey.iconSource: "image://theme/icon-m-enter-close"
        EnterKey.onClicked: {
            conTcpCli.sipadd = text
            console.log(conTcpCli.sipadd);
            focus = false;
        }
    }

    TextField {
        id: portti
        text: ""
        anchors.top: iipee.bottom
        placeholderText: "12345"
        label: qsTr("Server port")
        //visible: openingMode == 2
        width: page.width
        inputMethodHints: Qt.ImhNoPredictiveText
        EnterKey.iconSource: "image://theme/icon-m-enter-close"
        EnterKey.onClicked: {
            conTcpCli.sport = text
            console.log(conTcpCli.sport);
            focus = false;
        }
    }
    Button {
        text: "Connect"
        onClicked: {
            console.log(conTcpCli.sipadd);
            console.log(conTcpCli.sport);
            connectionBox.destroy()
        }
        anchors.top : portti.bottom
    }

}
