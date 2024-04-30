#include "manager.h"

#include <QSqlDatabase>
#include <QSqlError>

#include <QDebug>

Manager::Manager(QObject *parent) : QObject{parent} {}

void Manager::open() {
    QSqlDatabase database = QSqlDatabase::addDatabase("QSQLITE");
    database.setDatabaseName("database.sqlite");

    if (!database.open()) {
        qDebug() << "Unable to open database";
        qDebug() << database.lastError();
    }
}
