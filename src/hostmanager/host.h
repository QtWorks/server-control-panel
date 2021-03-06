#ifndef HOST_H
#define HOST_H

// Windows / C++
#include <Windows.h>
#include <shellapi.h>
#include <stdlib.h>
#include <string>

#include <QDir>
#include <QFile>
#include <QList>
#include <QString>
#include <QStringList>
#include <QTemporaryFile>
#include <QTextStream>
#include <QThread>

namespace HostsFileManager
{
    class Host
    {
    public:
        explicit Host();
        explicit Host(QString name, QString address);

        static QList<Host *> GetHosts();
        static void SetHosts(QList<Host *> listHosts);

        QString name;
        QString address;
        // bool isEnable();
        // void setEnable(bool bEnable);

        bool operator==(const Host &host) const;

    private:
        static QString getHostFile();
        // bool m_bIsEnable;
    };
} // namespace HostsFileManager

#endif // HOST_H
