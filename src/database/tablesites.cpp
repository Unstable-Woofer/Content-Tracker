#include "tablesites.h"

#include <QSqlError>
#include <QSqlQuery>

#include <QDebug>

TableSites::TableSites(QObject *parent) : QObject{parent} {
    QSqlQuery createTableQuery;

    createTableQuery.exec("CREATE TABLE IF NOT EXISTS sites ("
                          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                          "name TEXT NOT NULL,"
                          "position INTEGER NOT NULL)");
}

int TableSites::siteCount() {
    QSqlQuery siteCountQuery;

    siteCountQuery.exec("SELECT COUNT(*) from sites");

    if (siteCountQuery.next()) {
        return siteCountQuery.value(0).toInt();
    }

    return 0;
}

QJsonObject TableSites::sites() {
    QSqlQuery sitesQuery;

    if (!sitesQuery.exec("SELECT id,name,position FROM sites ORDER BY position ASC")) {
        qDebug() << sitesQuery.lastError();

        return QJsonObject();
    }

    QJsonObject siteList;

    while(sitesQuery.next()) {
        QJsonObject site;
        site["siteid"] = sitesQuery.value("id").toString();
        site["sitename"] = sitesQuery.value("name").toString();
        site["position"] = sitesQuery.value("position").toString();

        siteList[sitesQuery.value("position").toString()] = site;
    }

    return siteList;
}

void TableSites::addSite(QString name) {
    QSqlQuery addSiteQuery;
    addSiteQuery.prepare("INSERT INTO sites (name, position) VALUES (:name,:position)");
    addSiteQuery.bindValue(":name", name);
    addSiteQuery.bindValue(":position", siteCount() + 1);

    if (!addSiteQuery.exec()) {
        qDebug() << addSiteQuery.lastError();
    }
}

void TableSites::updateSite(QString name, QString siteId, QString position) {
    QSqlQuery updateSiteQuery;
    updateSiteQuery.prepare("UPDATE sites SET name=:name,position=:position WHERE id=:id");
    updateSiteQuery.bindValue(":name", name);
    updateSiteQuery.bindValue(":position", position);
    updateSiteQuery.bindValue(":id", siteId);


    if (!updateSiteQuery.exec()) {
        qDebug() << updateSiteQuery.lastError();
        return;
    }
}
