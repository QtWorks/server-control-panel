#
#    WPN-XM Server Control Panel
#
#    Copyright (c) Jens-Andre Koch <jakoch@web.de>
#
#    WPN-XM SCP is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    WPN-XM SCP is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with WPN-XM SCP. If not, see <http://www.gnu.org/licenses/>.
#

if(!equals(QT_MAJOR_VERSION, 5)) {
    error("This program can only be compiled with Qt 5.")
}

message("You are running qmake on wpnxm-servercontrolpanel.pro file.")

VERSION                  = 0.870
QMAKE_TARGET_COMPANY     = Koch Softwaresystemtechnik
QMAKE_TARGET_PRODUCT     = WPN-XM Server Control Panel
QMAKE_TARGET_DESCRIPTION = WPN-XM Server Control Panel
QMAKE_TARGET_COPYRIGHT   = Copyright 2010-2016 Jens A. Koch

DEPLOYMENT.display_name = WPN-XM Server Control Panel

CONFIG += qt console c++11 #warn-on static

QT += core network widgets

# needed for "createShellLink", see ConfigurationDialog
LIBS += -luuid -lole32 -lshell32
# needed for process and port detection, see ProcessViewerDialog
#LIBS += -liphlpapi -lws2_32 -lwsock32

# ZLIB
INCLUDEPATH += $$PWD/libs/zlib/include
release {
    win32:LIBS += -L$$PWD/libs/zlib/lib -lzlib
    unix:LIBS  += -L$$PWD/libs/zlib/lib -lz
}

# QuaZIP
INCLUDEPATH += $$PWD/libs/quazip/include
release {
   win32:LIBS  += -L$$PWD/libs/quazip/lib -lquazip
    unix:LIBS  += -L$$PWD/libs/quazip/lib -lquazip
}

QMAKE_CXXFLAGS -= -fno-keep-inline-dllexport

HEADERS += \
    src/version.h \
    src/app/main.h \
    src/tooltips/TrayTooltip.h \
    src/tray.h \
    src/mainwindow.h \
    src/hostmanager/host.h \
    src/hostmanager/hosttablemodel.h \
    src/hostmanager/adddialog.h \
    src/hostmanager/hostmanagerdialog.h \
    src/config/configurationdialog.h \
    src/config/nginxaddupstreamdialog.h \
    src/config/nginxaddserverdialog.h \
    src/settings.h \
    src/splashscreen.h \
    src/windowsapi.h \
    src/servers.h \
    src/cli.h \
    src/json.h \
    src/selfupdater.h \
    src/filehandling.h \
    src/registry/registrymanager.h \
    src/updater/updaterdialog.h \
    src/updater/actioncolumnitemdelegate.h \
    src/updater/softwarecolumnitemdelegate.h \
    src/updater/downloadmanager.h \
    src/updater/package.h \
    src/services.h \
    src/networkutils.h \
    src/jobscheduler.h \
    src/csv.h \
    src/processviewer/processviewerdialog.h \
    src/ini.h


SOURCES += \
    src/app/main.cpp \
    src/tooltips/TrayTooltip.cpp \
    src/tray.cpp \
    src/mainwindow.cpp \
    src/hostmanager/host.cpp \
    src/hostmanager/hosttablemodel.cpp \
    src/hostmanager/adddialog.cpp \
    src/hostmanager/hostmanagerdialog.cpp \
    src/config/configurationdialog.cpp \
    src/config/nginxaddserverdialog.cpp \
    src/config/nginxaddupstreamdialog.cpp \
    src/settings.cpp \
    src/splashscreen.cpp \
    src/windowsapi.cpp \
    src/servers.cpp \
    src/cli.cpp \   
    src/json.cpp \
    src/selfupdater.cpp \
    src/filehandling.cpp \
    src/updater/updaterdialog.cpp \
    src/updater/actioncolumnitemdelegate.cpp \
    src/updater/softwarecolumnitemdelegate.cpp \
    src/registry/registrymanager.cpp \
    src/updater/downloadmanager.cpp \
    src/updater/transferitem.cpp \
    src/updater/package.cpp \
    src/services.cpp \
    src/networkutils.cpp \
    src/jobscheduler.cpp \
    src/csv.cpp \
    src/processviewer/processviewerdialog.cpp \
    src/ini.cpp


RESOURCES += \
    src/resources/resources.qrc

FORMS += \
    src/mainwindow.ui \
    src/config/configurationdialog.ui \
    src/config/nginxaddupstreamdialog.ui \
    src/config/nginxaddserverdialog.ui \
    src/updater/updaterdialog.ui \
    src/processviewer/processviewerdialog.ui

# WINDOWS RC-FILE (sets the executable attributes)
exists(C:\Windows\System32\cmd.exe) {
    message("Running on Windows")
    HEADERS += src/version_localdev.h
    RC_FILE = src/resources/application_localdev.rc
} else {
    RC_FILE = src/resources/application.rc
}

# set binary name
CONFIG(release, debug|release): TARGET = wpn-xm
CONFIG(debug, debug|release):   TARGET = wpn-xm-debug

# if using Shadow build, you need to get the output folder
CONFIG(release, debug|release): DESTDIR = $$OUT_PWD/release
CONFIG(debug, debug|release):   DESTDIR = $$OUT_PWD/debug

# if using normal build (non-shadow) that would have worked as well.
CONFIG(release, debug|release): DESTDIR = release
CONFIG(debug, debug|release):   DESTDIR = debug

# everything below takes effect with CONFIG += static
static {
    message("~~~ Static Build ~~~")

    CONFIG += staticlib
    DEFINES += STATIC

    # append -static to the exe (to seperate static build from non static build)
    TARGET = $$join(TARGET,,,-static)

    QMAKE_LFLAGS += -static -static-libgcc

    # https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
    QMAKE_CXXFLAGS += -O3 -std=c++11 -pedantic -Wextra -fvisibility=hidden -fvisibility-inlines-hidden -mstackrealign

    # for extra security on Windows: enable ASLR and DEP via GCC linker flags
    QMAKE_LFLAGS *= -Wl,--dynamicbase -Wl,--nxcompat

    QMAKE_CXXFLAGS_WARN_ON = -fdiagnostics-show-option -Wall -Wextra -Wformat -Wformat-security -Wno-ignored-qualifiers  -Wno-unused-parameter -Wstack-protector
}

message($$QMAKESPEC) # Determine the platform we are on

!isEmpty($$(TRAVIS)) {
    message("The project is build on Travis: $$(TRAVIS)")
}

linux-g++ {
    message("using linux g++")
}

win32-g++ {
    message("using win32 g++")
}

win32-msvc* {
    message("using win32 msvc")
    QMAKE_CXXFLAGS += /MP
}

*-g++-32 {
    message("using g++-32, adding -msse2 flag")

    QMAKE_CXXFLAGS += -msse2
    QMAKE_CFLAGS += -msse2
}

# Deployment - Automatically Copy Dependencies to Build Folder

win32 {
    isEmpty(TARGET_EXT) {
        TARGET_CUSTOM_EXT = .exe
    } else {
        TARGET_CUSTOM_EXT = $${TARGET_EXT}
    }

    DEPLOY_COMMAND = $$shell_quote($$shell_path($$[QT_INSTALL_BINS]/windeployqt))

    CONFIG(debug, debug|release) {
        DEPLOY_TARGET = $$shell_quote($$shell_path($${OUT_PWD}/debug/$${TARGET}.exe))
    } else {
        DEPLOY_TARGET = $$shell_quote($$shell_path($${OUT_PWD}/release/$${TARGET}.exe))
    }

    # Uncomment the following line to help debug the deploy command when running qmake
    warning($${DEPLOY_COMMAND} $${DEPLOY_TARGET})

    QMAKE_POST_LINK = $${DEPLOY_COMMAND} $${DEPLOY_TARGET}
}

# Deployment - Copy Dependencies to Build Folder

#dlls.path  =  $${DESTDIR}
#dlls.files += $$[QT_INSTALL_BINS]/icudt51.dll
#dlls.files += $$[QT_INSTALL_BINS]/icuin51.dll
#dlls.files += $$[QT_INSTALL_BINS]/icuuc51.dll
#dlls.files += $$[QT_INSTALL_BINS]/libgcc_s_dw2-1.dll
#dlls.files += $$[QT_INSTALL_BINS]/libstdc++-6.dll
#dlls.files += $$[QT_INSTALL_BINS]/libwinpthread-1.dll
#dlls.files += $$[QT_INSTALL_BINS]/Qt5Core.dll
#dlls.files += $$[QT_INSTALL_BINS]/Qt5Network.dll
#dlls.files += $$[QT_INSTALL_BINS]/Qt5Gui.dll
#dlls.files += $$[QT_INSTALL_BINS]/Qt5Widgets.dll
#dllA.path   += $${DESTDIR}/platforms
#dllA.files  += $$[QT_INSTALL_PLUGINS]/platforms/qwindows.dll
#dllB.path   += $${DESTDIR}/plugins/imageformats/
#dllB.files  += $$[QT_INSTALL_PLUGINS]/imageformats/qico.dll
#dllB.files  += $$[QT_INSTALL_PLUGINS]/imageformats/qwbmp.dll
#INSTALLS   += dlls dllA dllB
