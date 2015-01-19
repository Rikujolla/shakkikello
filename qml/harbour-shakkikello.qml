import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    initialPage: Component { Pelisivu { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    property string aloitapause: qsTr("Aloita")
    property bool aloitettu : false
    property string maharollisuuret: qsTr("Asetukset")
    property int valkomax : 300
    property int mustamax : 300
    property int increment : 0

}
