import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Rectangle {

    ColumnLayout {
        anchors.fill: parent

        //上面图片背景框
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            color: "#060608"

            Image {
                anchors.fill: parent
                source: "qrc:///resource/img_nav_header.png"
                fillMode: Image.PreserveAspectFit
            }
        }



        //城市管理
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: cityManageMouseArea.pressed ? "#EEEEEE" : "transparent" //选中每一项之后的背景色

            //城市管理内部布局
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: 20

                Item {
                    Layout.preferredHeight: parent.height / 2
                    Layout.preferredWidth: parent.height / 2

                    Image {
                        id: cityManageImage
                        anchors.fill: parent
                        source: "qrc:///resource/ic_menu_city_manage.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    ColorOverlay {
                        anchors.fill: parent
                        source: cityManageImage
                        color: settings.primaryColor
                    }
                }

                Text {
                    text: qsTr("城市管理")
                    font.pixelSize: 20
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            MouseArea {
                id: cityManageMouseArea
                anchors.fill: parent
                onClicked: {
                    drawer.close()
                    stackView.push(Qt.resolvedUrl("qrc:///CitysManagePage.qml"))
                }
            }
        }

        //其他 分割显示框
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 50

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                Text {
                    text: qsTr("其他")
                    font.pixelSize: 20
                }
            }
        }

        //主题皮肤

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: skinManageMouseArea.pressed ? "#EEEEEE" : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: 20

                Item {
                    Layout.preferredHeight: parent.height / 2
                    Layout.preferredWidth: parent.height / 2

                    Image {
                        id: skinManageImage
                        anchors.fill: parent
                        source: "qrc:///resource/ic_menu_skin.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    ColorOverlay {
                        anchors.fill: parent
                        source: skinManageImage
                        color: settings.primaryColor
                    }
                }

                Text {
                    text: qsTr("主题皮肤")
                    font.pixelSize: 20
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            MouseArea {
                id: skinManageMouseArea
                anchors.fill: parent
                onClicked: {
                    drawer.close()
                    themeWnd.open()
                }
            }
        }


        //检测更新
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: checkUpdateMouseArea.pressed ? "#EEEEEE" : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: 20

                Item {
                    Layout.preferredHeight: parent.height / 2
                    Layout.preferredWidth: parent.height / 2

                    Image {
                        id: checkUpdateImage
                        anchors.fill: parent
                        source: "qrc:///resource/ic_menu_check_update.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    ColorOverlay {
                        anchors.fill: parent
                        source: checkUpdateImage
                        color: settings.primaryColor
                    }
                }

                Text {
                    text: qsTr("检测更新")
                    font.pixelSize: 20
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            MouseArea {
                id: checkUpdateMouseArea
                anchors.fill: parent
                onClicked: {
                    drawer.close()
                }
            }
        }

        //设置
        Rectangle {
            Layout.fillWidth: true;
            Layout.preferredHeight: 50;
            color: settingsMouseArea.pressed ? "#EEEEEE" : "transparent";

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: 20

                Item {
                    Layout.preferredHeight: parent.height / 2
                    Layout.preferredWidth: parent.height / 2

                    Image {
                        id: settingsImage
                        anchors.fill: parent
                        source: "qrc:///resource/ic_menu_settings.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    ColorOverlay {
                        anchors.fill: parent
                        source: settingsImage
                        color: settings.primaryColor
                    }
                }

                Text {
                    text: qsTr("设置")
                    font.pixelSize: 20
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            MouseArea {
                id: settingsMouseArea
                anchors.fill: parent
                onClicked: {
                    drawer.close()
                }
            }
        }

        //关于
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            color: aboutMouseArea.pressed ? "#EEEEEE" : "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                spacing: 20

                Item {
                    Layout.preferredHeight: parent.height / 2
                    Layout.preferredWidth: parent.height / 2

                    Image {
                        id: aboutImage
                        anchors.fill: parent
                        source: "qrc:///resource/ic_menu_about.png"
                        fillMode: Image.PreserveAspectFit
                    }

                    ColorOverlay {
                        anchors.fill: parent
                        source: aboutImage
                        color: settings.primaryColor
                    }
                }

                Text {
                    text: qsTr("关于")
                    font.pixelSize: 20
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }

            MouseArea {
                id: aboutMouseArea
                anchors.fill: parent
                onClicked: {
                    drawer.close()
                    stackView.push(aboutPage) //这里为啥能访问stackView?想想为撒谎？
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }


    Component {
        id: aboutPage
        AboutPage {
        }
    }

}
