#ifndef TABLESITESUPLOADED_H
#define TABLESITESUPLOADED_H

#include <QJsonObject>
#include <QObject>

class TableSitesUploaded : public QObject {
    Q_OBJECT

public:
    explicit TableSitesUploaded(QObject *parent = nullptr);

    Q_INVOKABLE bool hasUpload(QString filehash, QString siteId);
    Q_INVOKABLE void addUpload(QString filehash, QString siteId);
    Q_INVOKABLE void deleteUpload(QString filehash, QString siteId);

signals:
};

#endif // TABLESITESUPLOADED_H
