import QtQuick 2.7
import QtQml.Models 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.0
import com.kaboo.dailyweather 1.1
import QtQuick.LocalStorage 2.0
import "Database.js" as DBJS

ListViewEx {
    id: weatherUnit
    property string cityid;//城市ID
    property string cityname//城市名字
    property var condTextLabel: condTextLabel
    property var tempImg: tempImg
    property var otherLabel: otherLabel
    property var upateTimeLabel: upateTimeLabel
    property var dailyWeatherControl: dailyWeatherControl
    property int condCode: 999

    model: ObjectModel {

        //第一屏
        Item {
            // 第一屏
            width: weatherUnit.width
            height: weatherUnit.height + 145

            ColumnLayout {
                anchors.fill: parent

                Item {
                    Layout.fillWidth: true
                    height: Units.dp(20)
                }

                Item {
                    Layout.fillWidth: true
                    height: 40

                    Label {
                        id: condTextLabel
                        anchors.centerIn: parent
                        text: ""
                        color: settings.foregroundColor
                        font.pixelSize: 25
                    }

                    Label {
                        id: upateTimeLabel
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 20
                        color: settings.foregroundColor
                        font.pixelSize: 15
                    }
                }

                Item {
                    Layout.fillWidth: true
                    height: Units.dp(60)

                    Image {
                        id: tempImg
                        //fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                    }
                }

                Item {
                    Layout.fillWidth: true
                    height: 50
                    //color: "green"  // 当前 空气质量 / 风力 / 湿度等

                    Label {
                        id: otherLabel
                        anchors.centerIn: parent
                        //text: "优 42"
                        color: settings.foregroundColor
                        font.pixelSize: 15
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Item {
                    Layout.fillWidth: true
                    height: 450
                    //color: "green"  // 一周天气预报（温度曲线，星期，天气图标，天气）

                    //每日详情
                    DailyWeather {
                        id: dailyWeatherControl
                        anchors.fill: parent
                        anchors.margins: 5
                    }
                }
            }
        }


        //第一屏下滑，能看到这些东西哦。仅供测试用啦。
        /*
        Rectangle {
            width: weatherUnit.width
            height: 20
            color: "red"
        }
        Rectangle {
            width: weatherUnit.width
            height: 40
            color: "blue"
        }
        Rectangle {
            width: weatherUnit.width
            height: 60
            color: "yellow"
        }
        Rectangle {
            width: weatherUnit.width
            height: 50
            color: "green"
        }

        Rectangle {
            width: weatherUnit.width
            height: 50
            color: "green"
        }*/
    }

    Component.onCompleted: {
        //utils.checkAndroidStoragePermissions();
        //重新加载本地存储的天气预报信息
        //updateWeatherData();
        var jsonString = DBJS.loadForecastFromLocalStorage(cityid);
        parseJSON(jsonString);


    }

    function updateWeatherData() {
        weatherUnit.load();
    }


    //下拉刷新才会触发
    onLoad: {
        var xhr = new XMLHttpRequest;
        var url = "https://free-api.heweather.com/s6/weather?key=%1&location=%2";
        url = url.arg(Global.heweatherAppkey);
        url = url.arg(cityid);

        console.log("---url="+url);
        xhr.open("GET", url);

        //console.log(url);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status === 200) {
                    if (parseJSON(xhr.responseText)) {
                        updateSucceed()
                        //把数据缓存到本地
                        DBJS.cacheToLocalStorage(cityid, xhr.responseText)
                    }
                    else {
                       // log4Qml.qDebug_Info(0, "解析Json失败，" + xhr.responseText);
                        console.log("解析Json失败，" + xhr.responseText);
                        updateFail();
                    }
                }
                else {
                   // log4Qml.qDebug_Info(0, "调用接口失败，" + xhr.status);
                    console.log("调用接口失败，" + xhr.status);
                    updateFail("调用接口失败，" + xhr.status);
                }
            }
        }
        xhr.send();
    }

    //解析获取到的和风天气数据
    function parseJSON(jsonString) {
        if (jsonString === null || jsonString.length === 0)
            return false;

        //console.log(jsonString);
        try {
            //把文本转换为 JavaScript 对象
            var JsonObject= JSON.parse(jsonString);
            var HeWeather6Array = JsonObject.HeWeather6;
            if (Array.isArray(HeWeather6Array) && HeWeather6Array[0].status === "ok") {
                // 城市名字
                var city_name = HeWeather6Array[0].basic.location;
                //地区／城市ID
                //var city_id = HeWeather6Array[0].basic.cid;
                //UTC时间
                var utc_time = convertGMTStringToDate(HeWeather6Array[0].update.utc);

                // 实况天气
                var cond_code = HeWeather6Array[0].now.cond_code;
                //实况天气状况描述
                var cond_txt = HeWeather6Array[0].now.cond_txt;
                //温度，默认单位：摄氏度
                var tmp = HeWeather6Array[0].now.tmp;
                //风向
                var wind_dir = HeWeather6Array[0].now.wind_dir;
                //风力
                var wind_sc = HeWeather6Array[0].now.wind_sc;

                // s6版本常规天气集合中没有 aqi
                //var aqi = HeWeather6Array[0].aqi.city.aqi;
                //var aqi_qlty = HeWeather6Array[0].aqi.city.qlty;

                //实况天气状况代码
                condCode = cond_code;

                //以下是QML界面上要显示的数据
                weatherUnit.condTextLabel.text = cond_txt;
                var cur_utc_time = new Date()
                if (utc_time.toDateString() !== cur_utc_time.toDateString())
                    upateTimeLabel.text = utc_time.getMonth()+1 + "/" + utc_time.getDate() + qsTr(" 发布")
                else
                    upateTimeLabel.text = utc_time.getHours() + ":" + utc_time.getMinutes() + qsTr(" 发布")

                //weatherUnit.cityid = city_id;
                weatherUnit.cityname = city_name
                weatherUnit.tempImg.source = tempImage(tmp)
                //weatherUnit.otherLabel.text = aqi_qlty + " " + aqi
                weatherUnit.otherLabel.text = wind_dir + " " + wind_sc + "级"

                //每日预报
                var daily_forecast = HeWeather6Array[0].daily_forecast;
                //把 JavaScript 对象转换为字符串，然后作为json参数传递给由C++构建的类来解析并绘图
                dailyWeatherControl.setDailyForecast(JSON.stringify(daily_forecast))

                swipeView.currentItemChanged();
                return true;
            }
        } catch(e) {
            console.log(e.message); // error in the above string (in this case, yes)!
            return false;
        }

        return false;
    }

    //GMT转换UTC
    function convertGMTStringToDate(gmt) {
        gmt += "Z"
        var utc = new Date(gmt);
        return utc
    }

    //返回当前温度图片
    function tempImage(temp) {
        var prefix = null;
        if (temp < 0 && temp >= -50)
            prefix = "temp_n" + Math.abs(temp) + ".png";
        else if (temp >= 0 && temp < 100)
            prefix = "temp_" + Math.abs(temp) + ".png";
        else
            prefix = "temp_unkonwn.png"
        return Qt.resolvedUrl("qrc:/temperature/resource/temperature/" + prefix);
    }
}
