#include "tablesitesuploaded.h"

#include <QSqlError>
#include <QSqlQuery>

#include <QDebug>

TableSitesUploaded::TableSitesUploaded(QObject *parent) : QObject{parent} {
    QSqlQuery createTableQuery;

    if (!createTableQuery.exec("CREATE TABLE IF NOT EXISTS site_uploads ("
                               "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                               "file TEXT NOT NULL,"
                               "site INTEGER NOT NULL)")) {
        qDebug() << createTableQuery.lastError();
    }
}

bool TableSitesUploaded::hasUpload(QString filehash, QString siteId) {
    QSqlQuery hasUploadQuery;
    hasUploadQuery.prepare("SELECT COUNT(*) FROM site_uploads WHERE file=:filehash AND site=:siteid");
    hasUploadQuery.bindValue(":filehash", filehash);
    hasUploadQuery.bindValue(":siteid", QString(siteId).toInt());

    if (!hasUploadQuery.exec()) {
        qDebug() << "BBB " << filehash << " " << siteId;
        qDebug() << hasUploadQuery.lastError();
        qDebug() << "BBB";
        return false;
    }

    if (hasUploadQuery.next()) {
        int count = hasUploadQuery.value(0).toInt();

        if (count != 0) return true;
    }

    return false;
}

void TableSitesUploaded::addUpload(QString filehash, QString siteId) {
    QSqlQuery addUploadQuery;
    addUploadQuery.prepare("INSERT INTO site_uploads(file,site) VALUES (:filehash, :siteid)");
    addUploadQuery.bindValue(":filehash", filehash);
    addUploadQuery.bindValue(":siteid", QString(siteId).toInt());

    if (!addUploadQuery.exec()) {
        qDebug() << "AAA";
        qDebug() << addUploadQuery.lastError();
        qDebug() << "AAA";
    }
}

void TableSitesUploaded::deleteUpload(QString filehash, QString siteId) {
    QSqlQuery deleteUploadQuery;
    deleteUploadQuery.prepare("DELETE FROM site_uploads WHERE file=:filehash AND site=:siteid");
    deleteUploadQuery.bindValue(":filehash", filehash);
    deleteUploadQuery.bindValue(":siteid", QString(siteId).toInt());

    if (!deleteUploadQuery.exec()) {
        qDebug() << "AAA";
        qDebug() << deleteUploadQuery.lastError();
        qDebug() << "AAA";
    }
}
