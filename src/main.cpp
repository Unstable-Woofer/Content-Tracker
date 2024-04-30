#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "database/tableproduction.h"
#include "database/tableproductionlist.h"
#include "database/tablesites.h"
#include "database/tablesitesuploaded.h"
#include "utils/appsettings.h"
#include "utils/filemanager.h"

#include <QLibrary>
#include <QDebug>

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

#ifdef QT_DEBUG
    QCoreApplication::setApplicationName("Content Tracker - Dev");
    QCoreApplication::setOrganizationName("Unstable Woofer");
    QCoreApplication::setApplicationVersion("1.0.0-beta");
#else
    QCoreApplication::setApplicationName("Content Tracker");
    QCoreApplication::setOrganizationName("Unstable Woofer");
    QCoreApplication::setApplicationVersion("1.0.0");
#endif

    qmlRegisterType<TableProduction>("ContentTracker.Database", 1, 0, "Production");
    qmlRegisterType<TableProductionList>("ContentTracker.Database", 1, 0, "ProductionList");
    qmlRegisterType<TableSites>("ContentTracker.Database", 1, 0, "SiteList");
    qmlRegisterType<TableSitesUploaded>("ContentTracker.Database", 1, 0, "SiteUploadList");
    qmlRegisterType<AppSettings>("ContentTracker.Utils", 1, 0, "AppSettings");
    qmlRegisterType<FileManager>("ContentTracker.Utils", 1, 0, "FileManager");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/ContentTracker/ui/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
