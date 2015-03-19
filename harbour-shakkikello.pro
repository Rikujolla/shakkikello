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
TARGET = harbour-shakkikello

CONFIG += sailfishapp

SOURCES += src/harbour-shakkikello.cpp

OTHER_FILES += qml/harbour-shakkikello.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-shakkikello.changes.in \
    rpm/harbour-shakkikello.spec \
    rpm/harbour-shakkikello.yaml \
    translations/*.ts \
    harbour-shakkikello.desktop \
    qml/pages/Asetukset.qml \
    qml/pages/Pelisivu.qml \
    harbour-shakkikello.png \
    qml/pages/vaihtoMusta.png \
    qml/pages/vaihtoValkoinen.png \
    LICENSE \
    qml/pages/Tietoja.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS +=  translations/harbour-shakkikello-da.ts \
                 translations/harbour-shakkikello-de.ts \
                 translations/harbour-shakkikello-en.ts \
                 translations/harbour-shakkikello-es.ts \
                 translations/harbour-shakkikello-fi.ts \
                 translations/harbour-shakkikello-fr.ts \
                 translations/harbour-shakkikello-it.ts \
                 translations/harbour-shakkikello-nl.ts \
                 translations/harbour-shakkikello-no.ts \
                 translations/harbour-shakkikello-pl.ts \
                 translations/harbour-shakkikello-pt.ts \
                 translations/harbour-shakkikello-ru.ts \
                 translations/harbour-shakkikello-sv.ts \
                 translations/harbour-shakkikello-zh_cn.ts \
                 translations/harbour-shakkikello-zh_hk.ts

