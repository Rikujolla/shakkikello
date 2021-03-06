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
# If in harbour comment the next line
# QT += quick

SOURCES += src/harbour-shakkikello.cpp \
    src/stockfish/benchmark.cpp \
    src/stockfish/bitbase.cpp \
    src/stockfish/bitboard.cpp \
    src/stockfish/book.cpp \
    src/stockfish/endgame.cpp \
    src/stockfish/evaluate.cpp \
    src/stockfish/material.cpp \
    src/stockfish/misc.cpp \
    src/stockfish/movegen.cpp \
    src/stockfish/movepick.cpp \
    src/stockfish/notation.cpp \
    src/stockfish/pawns.cpp \
    src/stockfish/position.cpp \
    src/stockfish/search.cpp \
    src/stockfish/thread.cpp \
    src/stockfish/timeman.cpp \
    src/stockfish/tt.cpp \
    src/stockfish/uci.cpp \
    src/stockfish/ucioption.cpp \
    src/fortuneserver/server.cpp \
    src/fortuneclient/client.cpp


OTHER_FILES += qml/harbour-shakkikello.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-shakkikello.spec \
    rpm/harbour-shakkikello.yaml \
    translations/*.ts \
    LICENSE \
    qml/pages/funktiot.js \
    qml/pages/images/grid.png \
    qml/pages/images/empty.png \
    qml/pages/Promotion.qml \
    qml/pages/Boardview.qml \
    qml/pages/openings.js \
    qml/pages/tables.js \
    qml/pages/infofuncs.js \
    qml/pages/setting.js \
    qml/pages/GameInfo.qml \
    qml/pages/GameList.qml \
    qml/pages/GameInfo2.qml \
    qml/pages/GameSelector.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 256x256

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
                 translations/harbour-shakkikello-nl_nl.ts \
                 translations/harbour-shakkikello-nl_be.ts \
                 translations/harbour-shakkikello-nb.ts \
                 translations/harbour-shakkikello-pl.ts \
                 translations/harbour-shakkikello-pt.ts \
                 translations/harbour-shakkikello-ru.ts \
                 translations/harbour-shakkikello-sv.ts \
                 translations/harbour-shakkikello-zh_cn.ts \
                 translations/harbour-shakkikello-zh_hk.ts \
                 translations/harbour-shakkikello-hu.ts

HEADERS += \
    src/stockfish/bitboard.h \
    src/stockfish/bitcount.h \
    src/stockfish/book.h \
    src/stockfish/endgame.h \
    src/stockfish/evaluate.h \
    src/stockfish/material.h \
    src/stockfish/misc.h \
    src/stockfish/movegen.h \
    src/stockfish/movepick.h \
    src/stockfish/notation.h \
    src/stockfish/pawns.h \
    src/stockfish/platform.h \
    src/stockfish/position.h \
    src/stockfish/psqtab.h \
    src/stockfish/rkiss.h \
    src/stockfish/search.h \
    src/stockfish/thread.h \
    src/stockfish/timeman.h \
    src/stockfish/tt.h \
    src/stockfish/types.h \
    src/stockfish/uci.h \
    src/stockfish/ucioption.h \
    src/fortuneserver/server.h \
    src/fortuneclient/client.h


DISTFILES += \
    rpm/harbour-shakkikello.changes \
    qml/pages/images/framemoved.png \
    qml/pages/images/frame.png \
    qml/pages/Connbox.qml \
    harbour-shakkikello.desktop \
    icons/108x108/harbour-shakkikello.png \
    icons/128x128/harbour-shakkikello.png \
    icons/256x256/harbour-shakkikello.png \
    icons/86x86/harbour-shakkikello.png \
    README.md \
    icons/172x172/harbour-shakkikello.png \
    qml/pages/About.qml \
    qml/pages/Settings.qml \
    qml/pages/Clockview.qml \
    qml/pages/movelegal.js \
    qml/pages/Settings_dialog_personal_art.qml

FORMS +=

