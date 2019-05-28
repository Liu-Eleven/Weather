import QtQuick 2.0


QtObject {
   /* property var mainWindow: MainWindow {
        id:mainWindow
        visible: false
    }

    property var splashWindow: Splash {
        onTimeout: mainWindow.visible = true
    }

      但是在安卓上不推荐多窗口，因为在多窗体切换的时候，安卓界面会僵死，如果是用来显示一个 SplashScreen 的话，就没有问题吧。*/

        property var splashWindow: SplashScreen {
            onTimeout: mainWindow.visible = true
        }
        property var mainWindow: MainWindow{
            id: mainWindow
        }
}
