#Name of repository: QR-Code-generator
#Author: Nayuki
#Link to original repository: https://github.com/nayuki/QR-Code-generator

QT += svg

INCLUDEPATH += $$PWD/qrcodegenerator/cpp/

SOURCES += \
    $$PWD/qrcodegenerator/cpp/BitBuffer.cpp \
    $$PWD/qrcodegenerator/cpp/QrCoder.cpp \
    $$PWD/qrcodegenerator/cpp/QrSegment.cpp

HEADERS += \
    $$PWD/qrcodegenerator/cpp/BitBuffer.hpp \
    $$PWD/qrcodegenerator/cpp/QrCoder.hpp \
    $$PWD/qrcodegenerator/cpp/QrSegment.hpp
