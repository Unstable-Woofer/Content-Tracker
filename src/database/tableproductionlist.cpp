#include "tableproductionlist.h"

#include <QDateTime>
#include <QCryptographicHash>
#include <QSqlError>
#include <QSqlQuery>

#include <QDebug>


#include "manager.h"
#include "tableproduction.h"

TableProductionList::TableProductionList(QObject *parent): QObject{parent} {
    Manager dbManager;
    dbManager.open();

    QSqlQuery tableQuery;
    tableQuery.prepare("CREATE TABLE IF NOT EXISTS production_list ("
                       "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                       "name TEXT NOT NULL,"
                       "date TEXT NOT NULL,"
                       "uid TEXT)");

    if (!tableQuery.exec()) {
        qDebug() << tableQuery.lastError();
    }
}

void TableProductionList::add(QString name, QString date) {
    QString uid = QCryptographicHash::hash(QDateTime::currentDateTime().toString().toUtf8(), QCryptographicHash::Sha1).toHex();

    QSqlQuery addQuery;
    addQuery.prepare("INSERT INTO production_list(name,date,uid) VALUES (:name, date(:date), :uid)");
    addQuery.bindValue(":name", name);
    addQuery.bindValue(":date", date);
    addQuery.bindValue(":uid", uid);

    if (!addQuery.exec()) {
        qDebug() << addQuery.lastError();

        emit productionAddError(addQuery.lastError().text());

        return;
    }

    qDebug() << TableProduction::createTable(uid, name);

    emit productionAdded(uid);
}

//QJsonObject TableProductionList::list() {
QJsonArray TableProductionList::list() {
    QSqlQuery listQuery;

    if (!listQuery.exec("SELECT id,name,date,uid FROM production_list")) {
        qDebug() << listQuery.lastError();
        return QJsonArray();
    }

    QJsonArray list;

    while(listQuery.next()) {
        QJsonObject row;
        row["name"] = listQuery.value("name").toString();
        row["date"] = listQuery.value("date").toString();
        row["uid"] = listQuery.value("uid").toString();
        //list[listQuery.value("uid").toString()] = row;
        list.append(row);
    }

    return list;
}
