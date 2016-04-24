# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-tuxchara

QT += dbus gui-private
CONFIG += sailfishapp

PKGCONFIG += mlite5

DEFINES += APP_VERSION=\\\"$$VERSION\\\"

SOURCES += src/harbour-tuxchara.cpp \
    src/viewhelper.cpp

OTHER_FILES += qml/harbour-tuxchara.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-tuxchara.changes.in \
    rpm/harbour-tuxchara.spec \
    rpm/harbour-tuxchara.yaml \
    translations/*.ts \
    harbour-tuxchara.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-tuxchara-de.ts

HEADERS += \
    src/viewhelper.h

DISTFILES += \
    qml/pages/overlay.qml \
    qml/pages/settings.qml \
    qml/pages/MainPage.qml \
    qml/pages/charas/tux-construction.png \
    qml/pages/charas/tux-back.gif \
    qml/pages/charas/tux-construction2.gif \
    qml/pages/charas/tux-easter.gif \
    qml/pages/charas/tux-loading.gif \
    qml/pages/charas/tux-americanfootball.png \
    qml/pages/charas/tux-android.png \
    qml/pages/charas/tux-angel.png \
    qml/pages/charas/tux-anzug.png \
    qml/pages/charas/tux-avatar.png \
    qml/pages/charas/tux-bartsimpson.png \
    qml/pages/charas/tux-batman.png \
    qml/pages/charas/tux-bitch.png \
    qml/pages/charas/tux-construction2.png \
    qml/pages/charas/tux-construction3.png \
    qml/pages/charas/tux-cowboy.png \
    qml/pages/charas/tux-cptHarlock.png \
    qml/pages/charas/tux-cptjacksparrow.png \
    qml/pages/charas/tux-daftpunk.png \
    qml/pages/charas/tux-darth-maul.png \
    qml/pages/charas/tux-darthvader.png \
    qml/pages/charas/tux-devil.png \
    qml/pages/charas/tux-diver.png \
    qml/pages/charas/tux-easter.png \
    qml/pages/charas/tux-elvis.png \
    qml/pages/charas/tux-engineer.png \
    qml/pages/charas/tux-fbi.png \
    qml/pages/charas/tux-flash.png \
    qml/pages/charas/tux-football.png \
    qml/pages/charas/tux-guitar.png \
    qml/pages/charas/tux-halloween.png \
    qml/pages/charas/tux-harrypotter.png \
    qml/pages/charas/tux-hero-turtles.png \
    qml/pages/charas/tux-hulk.png \
    qml/pages/charas/tux-icehockey.png \
    qml/pages/charas/tux-indianajones.png \
    qml/pages/charas/tux-inuyasha.png \
    qml/pages/charas/tux-joker.png \
    qml/pages/charas/tux-judgedredd.png \
    qml/pages/charas/tux-kameSennin.png \
    qml/pages/charas/tux-lego.png \
    qml/pages/charas/tux-link.png \
    qml/pages/charas/tux-luke-skywalker.png \
    qml/pages/charas/tux-maggie.png \
    qml/pages/charas/tux-magneto.png \
    qml/pages/charas/tux-mario.png \
    qml/pages/charas/tux-monkeydruffy.png \
    qml/pages/charas/tux-naruto.png \
    qml/pages/charas/tux-neo.png \
    qml/pages/charas/tux-ninja.png \
    qml/pages/charas/tux-obelix.png \
    qml/pages/charas/tux-pikachu.png \
    qml/pages/charas/tux-pirate.png \
    qml/pages/charas/tux-police.png \
    qml/pages/charas/tux-predator.png \
    qml/pages/charas/tux-r2d2.png \
    qml/pages/charas/tux-rambo.png \
    qml/pages/charas/tux-rapper.png \
    qml/pages/charas/tux-samurai.png \
    qml/pages/charas/tux-santa.png \
    qml/pages/charas/tux-smoking.png \
    qml/pages/charas/tux-sonGoku.png \
    qml/pages/charas/tux-space.png \
    qml/pages/charas/tux-spiderman.png \
    qml/pages/charas/tux-stormtrooper.png \
    qml/pages/charas/tux-summer.png \
    qml/pages/charas/tux-superman.png \
    qml/pages/charas/tux-tron.png \
    qml/pages/charas/tux-yoda.png \
    qml/pages/charas/tux2.png \
    qml/pages/SpeechBubble.qml \
    qml/pages/img/speech-bubble.png \
    qml/pages/CharaModel.qml \
    qml/pages/AboutPage.qml

