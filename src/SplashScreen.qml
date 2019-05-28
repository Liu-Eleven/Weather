import QtQuick 2.0
import QtQuick.Window 2.1
/*
 * In mobile platform, splash must full screen
 * In desktop platform, splash half
*/

Window {
    id: splash

    title: "Splash Window"
    color: "transparent"
    modality: Qt.ApplicationModal //模态对话框
    flags: Qt.SplashScreen

    property int timeoutInterval: 1000
    signal timeout

    width: Screen.width * __screen();
    height: Screen.height * __screen();

    //! [timer]
    Timer {
        interval: timeoutInterval;
        running: true;
        repeat: false
        onTriggered: {
            splash.timeout();
            //            visible = false;
            //            splash.hide();
            splash.destroy()
        }
    }

    //! [timer]
    Component.onCompleted: {
        visible = true;
    }


    Image{
        anchors.fill: parent
        source: "qrc:/resource/splish_two.jpg"

        Text{
            anchors.centerIn: parent;
            width: parent.height
            text: "有钱天气"
            font.family: "Helvetica";
            font.pointSize: 33;
            font.bold: true
            color: "#BB88CD"
            wrapMode: Text.WordWrap
        }

    }

    function __screen(){
        switch(Qt.platform.os)
        {
        case "android":
        case "blackberry":
        case "ios":
            return 1.0;
        case "linux":
        case "osx":
        case "unix":
        case "windows":
        case "wince":
        default:
            return 0.5
        }
    }
}

/*
platform.os	This read-only property contains the name of the operating system.
Possible values are:
"android" - Android
"blackberry" - BlackBerry OS
"ios" - iOS
"linux" - Linux
"osx" - OS X
"unix" - Other Unix-based OS
"windows" - Windows
"wince" - Windows CE
*/

