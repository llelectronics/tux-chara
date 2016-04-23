#ifndef VIEWHELPER_H
#define VIEWHELPER_H

#include <QObject>
#include <QQuickView>
#include <mlite5/MGConfItem>
#include <QDBusInterface>
#include <QDBusConnection>

class ViewHelper : public QObject
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "harbour.tuxchara")
    Q_PROPERTY(int lastXPos READ lastXPos WRITE setLastXPos NOTIFY lastXPosChanged)
    Q_PROPERTY(int lastYPos READ lastYPos WRITE setLastYPos NOTIFY lastYPosChanged)
    Q_PROPERTY(QString character READ character WRITE setCharacter NOTIFY characterChanged)
    Q_PROPERTY(QString characterMsg READ characterMsg WRITE setCharacterMsg NOTIFY characterMsgChanged)
    Q_PROPERTY(int coverStatus READ coverStatus NOTIFY coverStatusChanged())
    Q_PROPERTY(int settingsActive READ settingsActive NOTIFY settingsActiveChanged())
//    Q_PROPERTY(int screenshotDelay READ screenshotDelay WRITE setScreenshotDelay NOTIFY screenshotDelayChanged)
//    Q_PROPERTY(bool useSubfolder READ useSubfolder WRITE setUseSubfolder NOTIFY useSubfolderChanged)
//    Q_PROPERTY(QString orientationLock READ orientationLock NOTIFY orientationLockChanged)

public:
    explicit ViewHelper(QObject *parent = 0);
    void setDefaultRegion();

    Q_INVOKABLE void closeOverlay();
    Q_INVOKABLE void openStore();
    int coverStatus() { return m_coverStatus; }
    bool settingsActive() { return m_settingsViewActive; }

public slots:
    void checkActiveSettings();
    void checkActiveOverlay();
    void setTouchRegion(const QRect &rect, bool setXY = true);
    void handleCoverstatus(const QDBusMessage& msg);

    Q_SCRIPTABLE Q_NOREPLY void show();
    Q_SCRIPTABLE Q_NOREPLY void hideShowToggle();
    Q_SCRIPTABLE Q_NOREPLY void exit();
    Q_SCRIPTABLE Q_NOREPLY void hideOverlay();
    Q_SCRIPTABLE Q_NOREPLY void unhideOverlay();

signals:
    void lastXPosChanged();
    void lastYPosChanged();
    void characterChanged();
    void characterMsgChanged();
    void screenshotDelayChanged();
    void useSubfolderChanged();
    void orientationLockChanged();
    void coverStatusChanged();
    void settingsActiveChanged();

    void applicationRemoval();

private:
    void showOverlay();
    void showSettings();
    void setMouseRegion(const QRegion &region);

    int lastXPos();
    void setLastXPos(int xpos);
    int lastYPos();
    void setLastYPos(int ypos);
    QString character();
    void setCharacter(QString value);
    QString characterMsg() const;
    void setCharacterMsg(QString characterMsg);

//    int screenshotDelay();
//    void setScreenshotDelay(int value);
//    bool useSubfolder();
//    void setUseSubfolder(bool value);
//    QString orientationLock() const;

    QQuickView *settingsView;
    QQuickView *overlayView;
    MGConfItem *lastXPosConf;
    MGConfItem *lastYPosConf;
    MGConfItem *characterConf;
//    MGConfItem *screenshotDelayConf;
//    MGConfItem *useSubfolderConf;
//    MGConfItem *orientationLockConf;

    QString m_characterMsg;
    int m_coverStatus;
    bool m_settingsViewActive;

private slots:
    void onPackageStatusChanged(const QString &package, int status);

    void onSettingsDestroyed();
    void onSettingsClosing(QQuickCloseEvent*);
    void settingsActiveHasChanged();

};

#endif // VIEWHELPER_H
