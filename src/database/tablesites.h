#ifndef TABLESITES_H
#define TABLESITES_H

#include <QJsonObject>
#include <QObject>

class TableSites : public QObject {
    Q_OBJECT

    Q_PROPERTY(QJsonObject sites READ sites CONSTANT)

public:
    explicit TableSites(QObject *parent = nullptr);

    int siteCount();

    QJsonObject sites();

    Q_INVOKABLE void addSite(QString name);
    Q_INVOKABLE void updateSite(QString name, QString siteId, QString position);

signals:
};

#endif // TABLESITES_H
