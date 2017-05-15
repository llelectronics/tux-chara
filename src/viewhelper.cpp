#include "viewhelper.h"

#include <QGuiApplication>
#include <QtQml>
#include <qpa/qplatformnativeinterface.h>
#include <sailfishapp.h>
#include <QDebug>

ViewHelper::ViewHelper(QObject *parent) :
    QObject(parent)
{
    lastXPosConf = new MGConfItem("/apps/harbour-tuxchara/lastXPos", this);
    lastYPosConf = new MGConfItem("/apps/harbour-tuxchara/lastYPos", this);
    characterConf = new MGConfItem("/apps/harbour-tuxchara/character", this);
    QObject::connect(characterConf, SIGNAL(valueChanged()), this, SIGNAL(characterChanged()));
//    screenshotDelayConf = new MGConfItem("/apps/harbour-screentapshot/screenshotDelay", this);
//    QObject::connect(screenshotDelayConf, SIGNAL(valueChanged()), this, SIGNAL(screenshotDelayChanged()));
//    useSubfolderConf = new MGConfItem("/apps/harbour-screentapshot/useSubfolder", this);
//    QObject::connect(useSubfolderConf, SIGNAL(valueChanged()), this, SIGNAL(useSubfolderChanged()));
//    orientationLockConf = new MGConfItem("/lipstick/orientationLock", this);
//    QObject::connect(orientationLockConf, SIGNAL(valueChanged()), this, SIGNAL(orientationLockChanged()));

    overlayView = NULL;
    settingsView = NULL;

    QDBusConnection::sessionBus().connect("", "/com/jolla/lipstick", "com.jolla.lipstick", "coverstatus",
                                          this, SLOT(handleCoverstatus(const QDBusMessage&)));

    m_coverStatus = 0;
    emit coverStatusChanged();
}

void ViewHelper::closeOverlay()
{
    if (overlayView) {
        QDBusConnection::sessionBus().unregisterObject("/harbour/tuxchara/overlay");
        QDBusConnection::sessionBus().unregisterService("harbour.tuxchara.overlay");
        overlayView->close();
        delete overlayView;
        overlayView = NULL;
    }
    else {
        QDBusInterface iface("harbour.tuxchara.overlay", "/harbour/tuxchara/overlay", "harbour.tuxchara");
        iface.call(QDBus::NoBlock, "exit");
    }
}

void ViewHelper::openStore()
{
    QDBusInterface iface("com.jolla.jollastore", "/StoreClient", "com.jolla.jollastore");
    iface.call(QDBus::NoBlock, "showApp", "harbour-tuxchara");
}

void ViewHelper::setDefaultRegion()
{
    setMouseRegion(QRegion(lastXPos(),
                           lastYPos(),
                           80, 80));
}

void ViewHelper::checkActiveSettings()
{
    QDBusConnection::sessionBus().registerObject("/harbour/tuxchara/overlay", this, QDBusConnection::ExportScriptableSlots);
    bool newSettings = QDBusConnection::sessionBus().registerService("harbour.tuxchara.settings");
    if (newSettings) {
        showSettings();
    }
    else {
        QDBusInterface iface("harbour.tuxchara.settings", "/harbour/tuxchara/settings", "harbour.tuxchara");
        iface.call(QDBus::NoBlock, "show");
        qGuiApp->exit(0);
        return;
    }
}

void ViewHelper::checkActiveOverlay()
{
    QDBusConnection::sessionBus().registerObject("/harbour/tuxchara/overlay", this, QDBusConnection::ExportScriptableSlots);
    bool inactive = QDBusConnection::sessionBus().registerService("harbour.tuxchara.overlay");
    if (inactive) {
        showOverlay();
        QDBusConnection::sessionBus().connect("", "", "com.jolla.jollastore", "packageStatusChanged", this, SLOT(onPackageStatusChanged(QString, int)));
    }
}

void ViewHelper::setTouchRegion(const QRect &rect, bool setXY)
{
    setMouseRegion(QRegion(rect));

    if (setXY) {
        setLastXPos(rect.x());
        setLastYPos(rect.y());
    }
}

void ViewHelper::show()
{
    if (settingsView) {
        settingsView->raise();
        checkActiveOverlay();
    }
}

void ViewHelper::hideShowToggle()
{
    if (settingsView) {
        if (settingsView->isActive())
            settingsView->lower();
        else
            settingsView->raise();
    }
    else {
        showSettings();
    }
}

void ViewHelper::exit()
{
    qGuiApp->quit();
}

void ViewHelper::hideOverlay()
{
    if (overlayView)
        overlayView->hide();
}

void ViewHelper::unhideOverlay()
{
    if (overlayView)
        overlayView->show();
    else
        showOverlay();
}

void ViewHelper::showOverlay()
{

    qGuiApp->setApplicationName("Tux-Chara");
    qGuiApp->setApplicationDisplayName("Tux-Chara");

    overlayView = SailfishApp::createView();
    QObject::connect(overlayView->engine(), SIGNAL(quit()), qGuiApp, SLOT(quit()));
    overlayView->setTitle("Tux-Chara");
    overlayView->rootContext()->setContextProperty("viewHelper", this);

    QColor color;
    color.setRedF(0.0);
    color.setGreenF(0.0);
    color.setBlueF(0.0);
    color.setAlphaF(0.0);
    overlayView->setColor(color);
    overlayView->setClearBeforeRendering(true);

    overlayView->setSource(SailfishApp::pathTo("qml/pages/overlay.qml"));
    overlayView->create();
    QPlatformNativeInterface *native = QGuiApplication::platformNativeInterface();
    native->setWindowProperty(overlayView->handle(), QLatin1String("CATEGORY"), "notification");
    setDefaultRegion();
    overlayView->show();
}

void ViewHelper::showSettings()
{
    QDBusConnection::sessionBus().registerObject("/harbour/tuxchara/settings", this, QDBusConnection::ExportScriptableSlots);

    qGuiApp->setApplicationName("Tux-Chara Settings");
    qGuiApp->setApplicationDisplayName("Tux-Chara Settings");

    settingsView = SailfishApp::createView();
    settingsView->setTitle("Tux-Chara Settings");
    settingsView->rootContext()->setContextProperty("viewHelper", this);
    settingsView->setSource(SailfishApp::pathTo("qml/pages/settings.qml"));
    settingsView->showFullScreen();

    QObject::connect(settingsView, SIGNAL(destroyed()), this, SLOT(onSettingsDestroyed()));
    QObject::connect(settingsView, SIGNAL(closing(QQuickCloseEvent*)), this, SLOT(onSettingsClosing(QQuickCloseEvent*)));
    QObject::connect(settingsView, SIGNAL(activeChanged()), this, SLOT(settingsActiveHasChanged()));
}

void ViewHelper::setMouseRegion(const QRegion &region)
{
    QPlatformNativeInterface *native = QGuiApplication::platformNativeInterface();
    native->setWindowProperty(overlayView->handle(), QLatin1String("MOUSE_REGION"), region);
}

int ViewHelper::lastXPos()
{
    return lastXPosConf->value(0).toInt();
}

void ViewHelper::setLastXPos(int xpos)
{
    lastXPosConf->set(xpos);
    Q_EMIT lastXPosChanged();
}

int ViewHelper::lastYPos()
{
    return lastYPosConf->value(0).toInt();
}

void ViewHelper::setLastYPos(int ypos)
{
    lastYPosConf->set(ypos);
    Q_EMIT lastYPosChanged();
}

QString ViewHelper::character()
{
    return characterConf->value("charas/tux2.png").toString();
}

void ViewHelper::setCharacter(QString value)
{
    qDebug() << "SetCharacter to:" + value;
    characterConf->set(value);
    Q_EMIT characterChanged();
}

QString ViewHelper::characterMsg() const
{
    return m_characterMsg;
}

void ViewHelper::setCharacterMsg(QString characterMsg)
{
    m_characterMsg = characterMsg;
    Q_EMIT characterMsgChanged();
}

void ViewHelper::settingsActiveHasChanged()
{
    if (settingsView) {
        m_settingsViewActive = settingsView->isActive();
        emit settingsActiveChanged();
    }
}

//int ViewHelper::screenshotDelay()
//{
//    return screenshotDelayConf->value(3).toInt();
//}

//void ViewHelper::setScreenshotDelay(int value)
//{
//    screenshotDelayConf->set(value);
//    Q_EMIT screenshotDelayChanged();
//}

//bool ViewHelper::useSubfolder()
//{
//    return useSubfolderConf->value(false).toBool();
//}

//void ViewHelper::setUseSubfolder(bool value)
//{
//    useSubfolderConf->set(value);
//    Q_EMIT useSubfolderChanged();
//}

//QString ViewHelper::orientationLock() const
//{
//    return orientationLockConf->value(QString("dynamic")).toString();
//}

void ViewHelper::onPackageStatusChanged(const QString &package, int status)
{
    if (package == "harbour-tuxchara" && status != 1) {
        Q_EMIT applicationRemoval();
    }
}

void ViewHelper::onSettingsDestroyed()
{
    QObject::disconnect(settingsView, 0, 0, 0);
    settingsView = NULL;
}

void ViewHelper::onSettingsClosing(QQuickCloseEvent *)
{
    settingsView->destroy();
    settingsView->deleteLater();

    QDBusConnection::sessionBus().unregisterObject("/harbour/tuxchara/settings");
    QDBusConnection::sessionBus().unregisterService("harbour.tuxchara.settings");
}

void ViewHelper::handleCoverstatus(const QDBusMessage& msg)
{
    QList<QVariant> args = msg.arguments();
    m_coverStatus = args.at(0).toInt();
    emit coverStatusChanged();
}
