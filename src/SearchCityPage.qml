import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.2

Page {
    property var citysMangePage: undefined
    header: NavigationBar {
        title: qsTr("搜索城市")
    }

    contentItem: Item {
        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 10
            spacing: 10

            TextField {
                id: textField
                placeholderText:  qsTr("搜索城市")
                //placeholderTextColor: "#808080"
                //persistentSelection: true
                font.pixelSize: 15
                selectByMouse: true
                horizontalAlignment: TextInput.AlignHCenter
                Layout.alignment: Qt.AlignHCenter

                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 40
                    color: textField.enabled ? "transparent" : "#353637"
                    border.color: textField.enabled ? mainWnd.settings.primaryColor : "transparent"
                    radius: 20
                }


                onTextChanged: {
                    list.clear();
                    var keyword = text.trim();
                    console.log("-----------------------------"+keyword)
                    if (keyword != "")
                    {
                        /*var array = appModel.searchCitys(keyword);
                         //console.log(array.length)
                         for (var i=0; i<array.length; i+=3)
                         {
                             list.append({'cityid': array[i], "cityname": array[i+1], "display": array[i+2]})
                             //console.log(array[i])
                             //console.log(array[i+1])
                         }*/

                        var xhr = new XMLHttpRequest;
                        var url = "https://search.heweather.com/find?key=%1&location=%2";
                        url = url.arg(Global.heweatherAppkey);
                        url = url.arg(keyword);
                        //print(url)
                        xhr.open("GET", url);
                        xhr.onreadystatechange = function() {
                            if (xhr.readyState === XMLHttpRequest.DONE) {
                                if (xhr.status === 200) {
                                    if (parseJSON(xhr.responseText)) {
                                        //updateSucceed()
                                        //console.log(xhr.responseText)
                                    }
                                    else {
                                        log4Qml.qDebug_Info(0, "解析Json失败，" + xhr.responseText);
                                        //updateFail()
                                    }
                                }
                                else {
                                    log4Qml.qDebug_Info(0, "调用接口失败，" + xhr.status);
                                    //updateFail()
                                }
                            }
                        }
                        xhr.send();
                    }
                }

                function parseJSON(jsonString) {
                    //console.log(jsonString)
                    if (jsonString === null || jsonString.length === 0) return false;
                    try {
                        var JsonObject= JSON.parse(jsonString);
                        var HeWeather6Array = JsonObject.HeWeather6;
                        if (Array.isArray(HeWeather6Array) && HeWeather6Array[0].status === "ok") {
                            var heWeatherCitysArray = HeWeather6Array[0].basic;
                            if (Array.isArray(heWeatherCitysArray)) {
                                for (var i=0; i<heWeatherCitysArray.length; i++){
                                    //console.log(heWeatherCitysArray[i]["cid"])
                                    list.append({'cityid': heWeatherCitysArray[i]["cid"],
                                                    "cityname": heWeatherCitysArray[i]["location"],
                                                    "display": heWeatherCitysArray[i]["cnty"] === "中国" ?
                                                        heWeatherCitysArray[i]["admin_area"] + " " + heWeatherCitysArray[i]["parent_city"] + " " + heWeatherCitysArray[i]["location"] :
                                                        heWeatherCitysArray[i]["cnty"]})
                                }
                            }
                        }
                    } catch(e) {
                        console.log(e.message); // error in the above string (in this case, yes)!
                        return false;
                    }

                    return false;
                }
            }


            Text {
                Layout.leftMargin: 20
                text: qsTr("搜索结果")
                font.pixelSize: 20
            }

            ListView {
                id: l
                clip: true
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: visualModel
            }

            DelegateModel {
                id: visualModel
                model: ListModel {
                    id: list
                }
                delegate: Rectangle {
                    color: mouseArea.pressed ? "#EEEEEE" : "transparent"
                    width: l.width
                    height: 48

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent

                        onClicked: {
                            citysMangePage.addCity(cityid, cityname, true)
                            mainWnd.stackView.pop()
                        }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 20
                        anchors.rightMargin: 20

                        Text {
                            Layout.preferredWidth: 100
                            font.pixelSize: 17
                            text: cityname
                            clip: true;
                        }

                        Text {
                            font.pixelSize: 15
                            text: display
                        }

                        Item { Layout.fillHeight: true; Layout.fillWidth: true }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        // fixbug, stackView.push(Page{s})
        height = parent.height-1
        height = parent.height
    }
}
