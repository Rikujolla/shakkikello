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
    Column {
        id: column
        width: parent.width
        spacing: Theme.paddingMedium

        PageHeader {
            title: qsTr("TCP connection")
        }


        SectionHeader { text: qsTr("Opponent's device info") }

        TextField {
            id: iipee
            text: ""
            //anchors.centerIn: parent
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
            //anchors.top: iipee.bottom
            placeholderText: "12345"
            label: qsTr("Server port")
            //visible: openingMode == 2
            width: page.width
            inputMethodHints: Qt.ImhDigitsOnly
            EnterKey.iconSource: "image://theme/icon-m-enter-close"
            EnterKey.onClicked: {
                conTcpCli.sport = text
                console.log(conTcpCli.sport);
                focus = false;
            }
        }
        SectionHeader { text: qsTr("My device info") }

        Text {
            text: "MyIP: " + conTcpSrv.cipadd
            color: Theme.highlightColor
            anchors.margins: Theme.paddingLarge
            anchors.left: parent.left
            //anchors.bottom: text3.top
        }

        Text {
            id:text3
            text: "My port: " + conTcpSrv.cport
            color: Theme.highlightColor
            //anchors.bottom: iipee.top
            anchors.margins: Theme.paddingLarge
            anchors.left: parent.left
        }

        Button {
            id:tstBtn
            text: qsTr("Test connection")
            onClicked: {
                isMyStart ? conTcpSrv.smove = "white" : conTcpSrv.smove = "black"
                console.log(conTcpSrv.smove);
                conTcpCli.requestNewFortune();
                connTestTimer.start()
                console.log(conTcpCli.cmove);
                colBtn.visible = false;
            }

        }
        Timer {
            id:connTestTimer
            running:false
            interval: 1000
            repeat:true
            onTriggered: {
                console.log(conTcpCli.cmove);
                if (isMyStart && conTcpCli.cmove == "black" || !isMyStart && conTcpCli.cmove == "white"){
                    connTestTimer.stop();
                    colBtn.visible = false;
                    connBtn.visible = true;
                    tstBtn.visible = false;
                }
                else if (isMyStart && conTcpCli.cmove == "white" || !isMyStart && conTcpCli.cmove == "black"){
                    connTestTimer.stop();
                    colBtn.visible = true;
              }
            }
        }

        Button {
            id: colBtn
            visible: false
            text: qsTr("Color mismatch, change my color")
            onClicked: {
                console.log("change my color");
                console.log(conTcpCli.sport);
                isMyStart = !isMyStart;
                isMyStart ? conTcpSrv.smove = "white" : conTcpSrv.smove = "black"
                conTcpCli.requestNewFortune();
                connTestTimer.start()
                console.log(conTcpCli.cmove);
                //colBtn.visible = false;
            }
        }

        Button {
            id:connBtn
            visible: false
            text: qsTr("Connect")
            onClicked: {
                console.log(conTcpCli.sipadd);
                console.log(conTcpCli.sport);
                //conTcpSrv.waitmove = conTcpCli.cmove;
                connectionBox.destroy()
            }
        }
    }

}
