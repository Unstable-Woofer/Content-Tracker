#include "appsettings.h"

#include <QSettings>

#include <QDebug>

AppSettings::AppSettings(QObject *parent) : QObject{parent} {
    if (uploadMethod().isEmpty() || uploadMethod().isNull())
        setUploadMethod("move");
}

QString AppSettings::contentDirectory() {
    QSettings settings;

    return settings.value("ContentDirectory").toString();
}

void AppSettings::setContentDirectory(QString contentDirectory) {
    QSettings settings;
    settings.setValue("ContentDirectory", contentDirectory);
}

QString AppSettings::uploadMethod() {
    QSettings settings;

    return settings.value("UploadMethod").toString();
}

void AppSettings::setUploadMethod(QString method) {
    QSettings settings;
    settings.setValue("UploadMethod", method);
}
