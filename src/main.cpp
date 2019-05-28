#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "qqpidailyweather.h"
#include "animationweather.h"
#include <QIcon>
#include "appmodel.h"
#include "qmllog4qml.h"
#include <QQmlContext>
#include <QScreen>
#include <QDir>

#include "utils.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    Utils utils;
    utils.checkAndroidStoragePermissions();

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/logo.png"));

    QCoreApplication::setOrganizationName("qsyyn");
    QCoreApplication::setOrganizationDomain("kaboo");
    QCoreApplication::setApplicationName("Weather");


    qreal refDpi = 216.;
    qreal refHeight = 1776.;
    qreal refWidth = 1080.;
    QRect rect = QGuiApplication::primaryScreen()->geometry();
    qreal height = qMax(rect.width(), rect.height());
    qreal width = qMin(rect.width(), rect.height());
    qreal dpi = QGuiApplication::primaryScreen()->logicalDotsPerInch();
    qreal dp2i = QGuiApplication::primaryScreen()->physicalDotsPerInch();
    QString d = QGuiApplication::primaryScreen()->manufacturer();
    QString d1 = QGuiApplication::primaryScreen()->name();
    QString d12 = QGuiApplication::primaryScreen()->model();

    qreal m_ratio = qMin(height/refHeight, width/refWidth);
    qreal m_ratioFont = qMin(height*refDpi/(dpi*refHeight), width*refDpi/(dpi*refWidth));

    QDir dir;
    dir.mkdir("/sdcard/weather/offlinedata");


    qmlRegisterType<AppModel>("com.kaboo.appmodel", 1, 0, "AppModel");
    qmlRegisterType<QQPIDailyWeather>("com.kaboo.dailyweather", 1, 1, "DailyWeather");
    qmlRegisterType<AnimationWeather>("com.kaboo.animationweather", 1, 0, "AnimationWeather");

    //QmlLog4Qml log4Qml;

    QQmlApplicationEngine engine;
#ifdef Q_OS_ANDROID
    engine.setOfflineStoragePath("/sdcard/weather/offlinedata");
#else
    engine.setOfflineStoragePath(app.applicationDirPath());
#endif
   // engine.rootContext()->setContextProperty("utils", new Utils());
   // engine.rootContext()->setContextProperty("log4Qml", &log4Qml);
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
