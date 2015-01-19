import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            quickSelect: true
            MenuItem {
                text: qsTr("Mustan vuoro")
                onClicked: vuoro.vaihdaMustalle()
            }
        }

        PushUpMenu {
            quickSelect: true
            MenuItem {
                text: qsTr("Valkoisen vuoro")
                onClicked: vuoro.vaihdaValkealle()
            }
        }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            Item {
                id : vuoro
                function vaihdaMustalle() {
                    if (tilat.musta == true) {} else {
                        startti.timeAsetus();
                        tilat.musta = !tilat.musta; tilat.valko = !tilat.valko;
                        kello.sekuntit = 0;
                        valkokello.timeValko();
                        valkokello.sekuntitv = 0;
                        muttakello.timeMutta();
                        muttakello.sekuntitm=0
                        valkokello.sum_incrementv = valkokello.sum_incrementv + increment
                        valkokello.updateValko()
                    }
                }
                function vaihdaValkealle() {
                    if (tilat.valko == true) {} else {
                        startti.timeAsetus();
                        tilat.musta = !tilat.musta; tilat.valko = !tilat.valko;
                        kello.sekuntit = 0;
                        valkokello.timeValko();
                        valkokello.sekuntitv = 0;
                        muttakello.timeMutta();
                        muttakello.sekuntitm=0
                        muttakello.sum_incrementm = muttakello.sum_incrementm + increment
                        muttakello.updateMutta()
                    }
                }
            }

            Item {
                id : tilat
                property bool musta
                property bool valko
                property bool juoksee
                property bool pelialkoi : false
                property bool peliloppui : false
                function asetaTilat() {
                    musta = false
                    valko = true
                    juoksee = false
                    pelialkoi = false
                }
                function vaihdaTila() {
                    if (pelialkoi == true && juoksee == true)  { aloitapause = qsTr("Keskeytä")} else {aloitapause = qsTr("Jatka")
                    }
                }
                function aloitaPeli() {
                    if (!pelialkoi) {
                        asetaTilat();
                        pelialkoi = true}
                    else {pelialkoi = true}
                }
                function peliLoppui() {
                    peliloppui= true;
                    tilat.aloitaPeli();
                    tilat.juoksee = !tilat.juoksee;
                    startti.timeAsetus();
                    kello.sekuntit = 0;
                    valkokello.sekuntitv = 0;
                    valkokello.timeValko();
                    muttakello.sekuntitm=0;
                    muttakello.timeMutta();
                    tilat.vaihdaTila();
                    maharollisuuret = qsTr("Nollaa")

                }
            }

            Item {
                id : muttakello
                property int sekuntitm0: 0
                property int sekuntitm : 0
                property int rogres_sekuntitm : mustamax
                property int label_sekuntitm
                property int label_minuutitm : mustamax/60
                property int sum_incrementm : 0
                function timeMutta() {sekuntitm0 = sekuntitm0 + sekuntitm}
                function updateMutta() {
                    kello.timeChanged();
                    if (rogres_sekuntitm <= 0) {
                        tilat.peliloppui = true;
                        tilat.peliLoppui()
                    }
                    else {
                        sekuntitm = kello.sekuntit;
                        label_sekuntitm = (mustamax + sum_incrementm - (sekuntitm0 + sekuntitm))%60;
                        label_minuutitm = ((mustamax + sum_incrementm - (sekuntitm0 + sekuntitm))-label_sekuntitm)/60;
                        rogres_sekuntitm = mustamax + sum_incrementm - (sekuntitm0 + sekuntitm)
                    }
                }
            }

            Item {
                id : valkokello
                property int sekuntitv: 0
                property int sekuntitv0: 0
                property int rogres_sekuntitv : valkomax
                property int label_sekuntitv
                property int label_minuutitv : valkomax/60
                property int sum_incrementv : 0
                function timeValko() {sekuntitv0 = sekuntitv0 + sekuntitv}
                function updateValko() {
                    kello.timeChanged();
                    if (rogres_sekuntitv <= 0) {
                        tilat.peliloppui = true;
                        tilat.peliLoppui()
                    }
                    else {
                        sekuntitv = kello.sekuntit;
                        label_sekuntitv = (valkomax + sum_incrementv - (sekuntitv0 + sekuntitv))%60;
                        label_minuutitv = ((valkomax + sum_incrementv - (sekuntitv0 + sekuntitv))-label_sekuntitv)/60;
                        rogres_sekuntitv = valkomax + sum_incrementv - (sekuntitv0 + sekuntitv)
                    }
                }
            }

            Item {
                id : startti
                property int hours0
                property int minutes0
                property int sekuntit0
                function timeAsetus() {
                    var date0 = new Date;
                    hours0 = date0.getHours()
                    minutes0 = date0.getMinutes()
                    sekuntit0= date0.getSeconds()
                }
            }

            Item {
                id : asetussivulle
                function siirrytKo() {
// Nollaus
                    if (tilat.pelialkoi == true) {
                        maharollisuuret = qsTr("Asetukset");
                        tilat.asetaTilat();
                        valkomax = 300;
                        mustamax = 300;
                        valkokello.rogres_sekuntitv = valkomax;
                        muttakello.rogres_sekuntitm = mustamax;
                        valkokello.sekuntitv0 = 0;
                        valkokello.sekuntitv = 0;
                        valkokello.sum_incrementv = 0;
                        muttakello.sekuntitm0 = 0;
                        muttakello.sekuntitm = 0;
                        muttakello.sum_incrementm = 0;
                        kello.sekuntit = 0;
                        startti.timeAsetus();
                        valkokello.updateValko();
                        muttakello.updateMutta();
                        tilat.peliloppui = false
// Siirtyminen asetussivulle
                    } else {
//                        valkomax = 300;
//                        mustamax = 300;
                        valkokello.rogres_sekuntitv = valkomax;
                        muttakello.rogres_sekuntitm = mustamax;
                        valkokello.sekuntitv0 = 0;
                        valkokello.sekuntitv = 0;
                        valkokello.sum_incrementv = 0;
                        muttakello.sekuntitm0 = 0;
                        muttakello.sekuntitm = 0;
                        muttakello.sum_incrementm = 0;
                        kello.sekuntit = 0;
                        tilat.peliloppui = false;
                        pageStack.push(Qt.resolvedUrl("Asetukset.qml"))
                    }
                }
            }

            Item {
               id : kello
               property int hours
               property int minutes
               property int sekuntit
               function timeChanged() {
                   var date = new Date;
                   hours = date.getHours()-startti.hours0
                   minutes = date.getMinutes()-startti.minutes0+60*hours
                   sekuntit= date.getSeconds()-startti.sekuntit0+60*minutes
               }
           }

            BackgroundItem {
                width: page.width
                height: 275
                enabled: tilat.juoksee && tilat.valko
                onClicked: vuoro.vaihdaMustalle()
                PageHeader {
                    title: qsTr("Shakkikello")
                }
                ProgressBar {
                    id: progressBar2
                    width: parent.width
                    height: 200
                    maximumValue: valkomax
                    valueText: valkokello.label_minuutitv + ":" + (valkokello.label_sekuntitv < 10 ? "0" : "") + valkokello.label_sekuntitv
                    label: qsTr("min:s")
                    value: valkokello.rogres_sekuntitv
                    rotation: 180
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: 100
                    Timer {
                        interval: 100
                        running: tilat.juoksee && tilat.valko && Qt.ApplicationActive
                        repeat: true
                        onTriggered: valkokello.updateValko()
                    }
                }
            }

            Row {
                Image {
                    source: "vaihtoValkoinen.png"
                    rotation: 180
                }
                Text {
                    text: qsTr("Valkoisen kello")
                    color: Theme.highlightColor
                    rotation: 180
                }
            }

            Text {
                text: qsTr("              Ohjaukset")
                color: Theme.highlightColor
            }

            Row {
                spacing: Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: aloitapause
                    enabled: !tilat.peliloppui
                    onClicked: {
                        tilat.aloitaPeli();
                        tilat.juoksee = !tilat.juoksee;
                        startti.timeAsetus();
                        kello.sekuntit = 0;
                        valkokello.timeValko();
                        valkokello.sekuntitv = 0;
                        muttakello.timeMutta();
                        muttakello.sekuntitm=0;
                        tilat.vaihdaTila();
                        maharollisuuret = qsTr("Nollaa")
                    }
                }
                Button {
                    text: maharollisuuret
                    onClicked: asetussivulle.siirrytKo()
                    enabled: !tilat.juoksee || tilat.peliloppui
                }
            }

            Row {
                Image {
                    source: "vaihtoMusta.png"
                }
                Text {
                    text: qsTr("Mustan kello")
                    color: Theme.highlightColor
                }
            }

            BackgroundItem {
                width: page.width
                height: 275
                enabled: tilat.juoksee && tilat.musta
                onClicked: vuoro.vaihdaValkealle()
                ProgressBar {
                    id: progressBarm
                    width: parent.width
                    maximumValue: mustamax
                    valueText: muttakello.label_minuutitm + ":" + (muttakello.label_sekuntitm < 10 ? "0" : "") + muttakello.label_sekuntitm
                    label: qsTr("min:s")
                    value: muttakello.rogres_sekuntitm
                    Timer {interval: 100
                        running: tilat.juoksee && tilat.musta && Qt.ApplicationActive
                        repeat: true
                        onTriggered: muttakello.updateMutta()}
                }
            }
// loppusulkeet
        }
    }
}
