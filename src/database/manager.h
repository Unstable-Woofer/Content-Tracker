#ifndef MANAGER_H
#define MANAGER_H

#include <QObject>

class Manager : public QObject {
    Q_OBJECT

public:
    explicit Manager(QObject *parent = nullptr);
    void open();

signals:
};

#endif // MANAGER_H
