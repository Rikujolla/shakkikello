import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "setting.js" as Mysets

Item {
    id: connectionBox
    anchors.fill: parent
    property bool vtesttimer: false
    property bool vstarttimer: false
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
            text: oppIP
            placeholderText: "192.168.1.70"
            label: qsTr("IP address")
            width: parent.width
            inputMethodHints: Qt.ImhNoPredictiveText
            EnterKey.iconSource: "image://theme/icon-m-enter-close"
            EnterKey.onClicked: {
                conTcpCli.sipadd = text;
                oppIP = text;
                Mysets.saveInstantSetting();
                focus = false;
            }
        }

        TextField {
            id: portti
            text: ""
            placeholderText: "12345"
            label: qsTr("Port number")
            width: page.width
            inputMethodHints: Qt.ImhDigitsOnly
            EnterKey.iconSource: "image://theme/icon-m-enter-close"
            EnterKey.onClicked: {
                conTcpCli.sport = text
                focus = false;
            }
        }
        SectionHeader { text: qsTr("My device info") }

        Text {
            text: qsTr("IP address") + ": " + conTcpSrv.cipadd
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.highlightColor
            anchors.margins: Theme.paddingLarge
            anchors.left: parent.left
        }

        Text {
            id:text3
            text: qsTr("Port number") + ": " + conTcpSrv.cport
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.highlightColor
            anchors.margins: Theme.paddingLarge
            anchors.left: parent.left
        }

        Button {
            id:tstBtn
            text: qsTr("Test connection")
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                isMyStart ? conTcpSrv.smove = "white" : conTcpSrv.smove = "black"
                conTcpCli.sipadd = iipee.text;
                conTcpCli.sport = portti.text
                conTcpCli.requestNewFortune();
                //connTestTimer.start()
                vtesttimer = true;
                tstBtn.text = qsTr("Test in progress") + "..."
                colBtn.visible = false;
            }
        }

        Timer {
            id:connTestTimer
            running:vtesttimer && Qt.application.active
            interval: 1000
            repeat:true
            onTriggered: {
                if (isMyStart && conTcpCli.cmove == "black" || !isMyStart && conTcpCli.cmove == "white"){
                    //connTestTimer.stop();
                    vtesttimer = false;
                    colBtn.visible = false;
                    connBtn.visible = true;
                    tstBtn.visible = false;
                }
                else if (isMyStart && conTcpCli.cmove == "white" || !isMyStart && conTcpCli.cmove == "black"){
                    //connTestTimer.stop();
                    vtesttimer = false;
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
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                isMyStart = !isMyStart;
                isMyStart ? conTcpSrv.smove = "white" : conTcpSrv.smove = "black"
                conTcpCli.requestNewFortune();
                //connTestTimer.start()
                vtesttimer = true;
            }
        }

        Timer {
            id:startTimer
            running:vstarttimer && Qt.application.active
            interval: 1000
            repeat:true
            onTriggered: {
                if (conTcpSrv.smove == "start" && conTcpCli.cmove == "start"){
                    //startTimer.stop();
                    vstarttimer = false;
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
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                conTcpSrv.smove = "start";
                conTcpCli.requestNewFortune();
                //startTimer.start();
                vstarttimer = true;
                connBtn.text = qsTr("Waiting your opponent to start") + "..."
            }
        }

        Component.onCompleted: Mysets.loadInstantSetting()
    }
}
