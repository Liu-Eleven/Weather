﻿#ifndef UTILS_H
#define UTILS_H

#include <QObject>

class Utils : public QObject
{
    Q_OBJECT
public:
    Utils(){}
    Q_INVOKABLE bool checkAndroidStoragePermissions();
};

#endif // UTILS_H
