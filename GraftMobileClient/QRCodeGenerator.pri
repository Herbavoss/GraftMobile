QT += svg

INCLUDEPATH += $$PWD/qrcodegenerator/cpp/

HEADERS += \
    $$PWD/qrcodegenerator/cpp/BitBuffer.hpp \
    $$PWD/qrcodegenerator/cpp/QrCode.hpp \
    $$PWD/qrcodegenerator/cpp/QrSegment.hpp

SOURCES += \
    $$PWD/qrcodegenerator/cpp/BitBuffer.cpp \
    $$PWD/qrcodegenerator/cpp/QrCode.cpp \
    $$PWD/qrcodegenerator/cpp/QrSegment.cpp
