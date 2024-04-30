#include "tableproduction.h"

#include <QSqlError>
#include <QSqlQuery>

#include <QDebug>

#include <QJsonDocument>

TableProduction::TableProduction(QObject *parent) : QObject{parent} {}

bool TableProduction::createTable(QString uid, QString name) {
    QString stringCreateQuery = QString("CREATE TABLE IF NOT EXISTS prod_%1 ("
                                        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                                        "key TEXT NOT NULL,"
                                        "value TEXT)").arg(uid);
    QString stringHashQuery = QString("INSERT INTO prod_%1 (key,value) VALUES ('hash',:hash),('name',:name)").arg(uid);

    QSqlQuery createQuery;
    QSqlQuery hashQuery;

    if (!createQuery.exec(stringCreateQuery)) {
        qDebug() << createQuery.lastError();
        return false;
    }

    hashQuery.prepare(stringHashQuery);
    hashQuery.bindValue(":hash", uid);
    hashQuery.bindValue(":name", name);

    if (!hashQuery.exec()) {
        qDebug() << hashQuery.lastQuery();
        return false;
    }

    return true;
}

QString TableProduction::productionName() {
    QString stringNameQuery = QString("SELECT value FROM prod_%1 WHERE key='name'").arg(p_tableUid);
    QSqlQuery nameQuery;

    if (!nameQuery.exec(stringNameQuery)) {
        qDebug() << "Error" << nameQuery.lastError();
        return QString();
    }

    nameQuery.first();
    return nameQuery.value("value").toString();
}

QString TableProduction::tableUid() { return p_tableUid; }

QJsonObject TableProduction::editFiles() {
    QString stringFileQuery = QString("SELECT id,key,value FROM prod_%1 WHERE key='EditFile'").arg(p_tableUid);
    QSqlQuery fileQuery;

    if (!fileQuery.exec(stringFileQuery)) {
        qDebug() << "Edit Files";
        qDebug() << fileQuery.lastError();
        qDebug() << fileQuery.lastQuery();
        return QJsonObject();
    }

    QJsonObject files;

    while (fileQuery.next()) {
        files[fileQuery.value("id").toString()] = QJsonDocument::fromJson(fileQuery.value("value").toByteArray()).object();
    }

    return files;
}

QJsonObject TableProduction::rawFiles() {
    QString stringFileQuery = QString("SELECT id,key,value FROM prod_%1 WHERE key='RawFile'").arg(p_tableUid);
    QSqlQuery fileQuery;

    if (!fileQuery.exec(stringFileQuery)) {
        qDebug() << "Raw Files";
        qDebug() << fileQuery.lastError();
        qDebug() << fileQuery.lastQuery();
        return QJsonObject();
    }

    QJsonObject files;

    while (fileQuery.next()) {
        files[fileQuery.value("id").toString()] = QJsonDocument::fromJson(fileQuery.value("value").toByteArray()).object();
    }

    return files;
}

void TableProduction::addEditFile(QJsonObject fileinfo) {
    QString stringAddFileQuery = QString("INSERT INTO prod_%1 (key,value) VALUES ('EditFile', :value)").arg(p_tableUid);
    QSqlQuery addFileQuery;

    addFileQuery.prepare(stringAddFileQuery);
    addFileQuery.bindValue(":value", QJsonDocument(fileinfo).toJson());

    if (addFileQuery.exec()) {
        emit fileEditAdded();
    }
}

void TableProduction::addRawFile(QJsonObject fileinfo) {
    QString stringAddFileQuery = QString("INSERT INTO prod_%1 (key,value) VALUES ('RawFile', :value)").arg(p_tableUid);
    QSqlQuery addFileQuery;

    addFileQuery.prepare(stringAddFileQuery);
    addFileQuery.bindValue(":value", QJsonDocument(fileinfo).toJson());

    if (addFileQuery.exec()) {
        emit fileRawAdded();
    }
}

void TableProduction::setTableUid(QString uid) { p_tableUid = uid; }
