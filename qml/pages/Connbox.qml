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
            text: myIP
            //anchors.centerIn: parent
            placeholderText: "192.168.1.70"
            label: qsTr("IP address")
            //visible: openingMode == 2
            width: parent.width
            inputMethodHints: Qt.ImhNoPredictiveText
            EnterKey.iconSource: "image://theme/icon-m-enter-close"
            EnterKey.onClicked: {
                conTcpCli.sipadd = text
                //console.log(conTcpCli.sipadd);
                focus = false;
            }
        }

        TextField {
            id: portti
            text: ""
            //anchors.top: iipee.bottom
            placeholderText: "12345"
            label: qsTr("Port number")
            //visible: openingMode == 2
            width: page.width
            inputMethodHints: Qt.ImhDigitsOnly
            EnterKey.iconSource: "image://theme/icon-m-enter-close"
            EnterKey.onClicked: {
                conTcpCli.sport = text
                //console.log(conTcpCli.sport);
                focus = false;
            }
        }
        SectionHeader { text: qsTr("My device info") }

        Text {
            text: qsTr("IP address") + ": " + conTcpSrv.cipadd
            color: Theme.highlightColor
            anchors.margins: Theme.paddingLarge
            anchors.left: parent.left
            //anchors.bottom: text3.top
        }

        Text {
            id:text3
            text: qsTr("Port number") + ": " + conTcpSrv.cport
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
                //console.log(conTcpSrv.smove);
                conTcpCli.requestNewFortune();
                connTestTimer.start()
                //console.log(conTcpCli.cmove);
                tstBtn.text = qsTr("Test in progress") + "..."
                colBtn.visible = false;
            }

        }
        Timer {
            id:connTestTimer
            running:false
            interval: 1000
            repeat:true
            onTriggered: {
                //console.log(conTcpCli.cmove);
                if (isMyStart && conTcpCli.cmove == "black" || !isMyStart && conTcpCli.cmove == "white"){
                    connTestTimer.stop();
                    colBtn.visible = false;
                    connBtn.visible = true;
                    tstBtn.visible = false;
                }
                else if (isMyStart && conTcpCli.cmove == "white" || !isMyStart && conTcpCli.cmove == "black"){
                    connTestTimer.stop();
                    colBtn.visible = true;
                    connBtn.visible = false;
                    tstBtn.visible = true;
                    tstBtn.text = qsTr("Retest the connection")
              }
            }
        }

        Button {
            id: colBtn
            visible: false
            text: qsTr("Color mismatch, change my color")
            onClicked: {
                //console.log("change my color");
                //console.log(conTcpCli.sport);
                isMyStart = !isMyStart;
                isMyStart ? conTcpSrv.smove = "white" : conTcpSrv.smove = "black"
                conTcpCli.requestNewFortune();
                connTestTimer.start()
                //console.log(conTcpCli.cmove);
                //colBtn.visible = false;
            }
        }

        Timer {
            id:startTimer
            running:false
            interval: 1000
            repeat:true
            onTriggered: {
                //console.log("waiting start", conTcpCli.cmove);
                if (conTcpSrv.smove == "start" && conTcpCli.cmove == "start"){
                    startTimer.stop();
                    //
                    hopo.stoDepth = stockfishDepth;
                    hopo.stoMovetime = stockfishMovetime;
                    hopo.stoSkill = stockfishSkill;
                    if (!tilat.pelialkoi) {
                        if (playMode == "stockfish") {hopo.initio();}
                        //kripti.lisaa();
                        isMyStart ? feni.stockfishFirstmove = false : feni.stockfishFirstmove = true
                        isMyStart ? feni.feniWhiteReady = false : feni.feniWhiteReady = true
                        //isMyStart ? feni.forChessCheck = false : feni.forChessCheck = true


                    }
                    isMyStart ? feni.feniWhite = true : feni.feniWhite = false
                    tilat.aloitaPeli();
                    tilat.juoksee = !tilat.juoksee;
                    startti.timeAsetus();
                    kello.sekuntit = 0;
                    valkokello.timeValko();
                    valkokello.sekuntitv = 0;
                    muttakello.timeMutta();
                    muttakello.sekuntitm=0;
                    tilat.vaihdaTila();
                    maharollisuuret = qsTr("Reset");
                    //Mytab.clearRecent()
                    conTcpSrv.waitmove = "";
                    conTcpCli.cmove = "";
                    conTcpSrv.smove = "";
                    //
                    connectionBox.destroy()
                }
                else {
                conTcpCli.requestNewFortune();
                }
            }
        }

        Button {
            id:connBtn
            visible: false
            text: qsTr("Start")
            onClicked: {
                //isMyStart ? conTcpSrv.smove = "start" : conTcpSrv.smove = "start";
                conTcpSrv.smove = "start";
                conTcpCli.requestNewFortune();
                startTimer.start();
                //console.log("starting", conTcpSrv.smove, conTcpCli.cmove);
                //connectionBox.destroy()
                connBtn.text = qsTr("Waiting your opponent to start") + "..."
            }
        }
        //Component.onCompleted:
    }

}
