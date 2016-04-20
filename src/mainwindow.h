#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QDialogButtonBox>
#include <QCheckBox>
#include <QSystemTrayIcon>

#include "servers.h"
#include "settings.h"
#include "tray.h"
#include "configurationdialog.h"
#include "updater/updaterdialog.h"

namespace ServerControlPanel
{
    namespace Ui {
        class MainWindow;
    }

    class MainWindow : public QMainWindow
    {
            Q_OBJECT  // Enables signals and slots

        public:
            explicit MainWindow(QWidget *parent = 0);
            ~MainWindow();

            void setVisible(bool visible);

            QString getPHPVersion();
            QString getNginxVersion();
            QString getMariaVersion();
            QString getMongoVersion();
            QString getMemcachedVersion();
            QString getPostgresqlVersion();

            QString parseVersionNumber(QString stringWithVersion);

        public slots:

            // General Action Slots of the MainWindow
            void startAllDaemons();
            void stopAllDaemons();

            void goToWebsite();
            void goToForum();
            void goToReportIssue();
            void goToDonate();

            void openToolPHPInfo();
            void openToolPHPMyAdmin();
            void openToolWebgrind();
            void openToolAdminer();
            void openToolRobomongo();

            void openProjectFolderInBrowser();
            void openProjectFolderInExplorer();

            void openConsole();
            void openWebinterface();
            void openConfigurationDialog();
            void openHelpDialog();
            void openAboutDialog();
            void openUpdaterDialog();

            void openConfigurationDialogNginx();
            void openConfigurationDialogPHP();
            void openConfigurationDialogMariaDb();
            void openConfigurationDialogMongoDb();
            void openConfigurationDialogPostgresql();

            void openLog();
            void openConfigurationInEditor();

            void setLabelStatusActive(QString label, bool enabled);
            void updateVersion(QString server);

            void enableToolsPushButtons(bool enabled);
            void updateTrayIconTooltip();

            void quitApplication();

            void execEditor(QUrl logfile);

        private:
            Ui::MainWindow *ui;

            ServerControlPanel::Tray  *tray;
            Settings::SettingsManager *settings;
            Servers::Servers          *servers;

            QAction *minimizeAction;
            QAction *restoreAction;
            QAction *quitAction;

            void checkAlreadyActiveDaemons();
            void checkPorts();
            void createActions();
            void createTrayIcon();
            void startMonitoringDaemonProcesses();

            void setDefaultSettings();
            void autostartDaemons();

            void renderInstalledDaemons();

            QString getProjectFolder() const;
            void showPushButtonsOnlyForInstalledTools();

            QString getVersion(QString server);

            QString getLogfile(QString objectName);
            QString getServerNameFromPushButton(QPushButton *button);

        signals:
            void mainwindow_show();

        private slots:
            void iconActivated(QSystemTrayIcon::ActivationReason reason);
            //void execEditor(QUrl logfile);

            void on_pushButton_Updater_clicked();
            void MainWindow_ShowEvent();

        protected:
            void closeEvent(QCloseEvent *event);
            void changeEvent(QEvent *event);
            void showEvent(QShowEvent *ev);
    };

}

#endif // MAINWINDOW_H
