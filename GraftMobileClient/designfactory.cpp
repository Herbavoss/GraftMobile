#include "designfactory.h"

#include <QQmlContext>
#include <QQmlEngine>

#ifdef Q_OS_ANDROID
#include <QGuiApplication>
#include <QFontDatabase>
#include <QtAndroid>
#include <QColor>
#include <QFont>
#endif

DesignFactory::DesignFactory(QObject *parent) : QObject(parent)
{
    mColors.insert(Foreground, QStringLiteral("#34435b"));
    mColors.insert(IosNavigationBar, QStringLiteral("#394558"));
    mColors.insert(CircleBackground, QStringLiteral("#4fb67a"));
    mColors.insert(Highlighting, QStringLiteral("#f5f6f8"));
    mColors.insert(ItemHighlighting, QStringLiteral("#fedbb4"));
    mColors.insert(LightText, QStringLiteral("#ffffff"));
    mColors.insert(CartLabel, QStringLiteral("#fe4200"));
    mColors.insert(AllocateLine, QStringLiteral("#e6e6e8"));
    mColors.insert(AndroidStatusBar, QStringLiteral("#233146"));
    mColors.insert(MainText, QStringLiteral("#404040"));
    mColors.insert(ProductText, QStringLiteral("#000000"));
    mColors.insert(LightButton, QStringLiteral("#7e726d"));
    setApplicationFont();
    init();

    #ifdef Q_OS_IOS
        mColors.insert(ItemText, QStringLiteral("#797979"));
    #endif

    #ifdef Q_OS_ANDROID
        mColors.insert(ItemText, QStringLiteral("#9e9e9e"));
    #endif
}

QString DesignFactory::color(DesignFactory::ColorTypes type) const
{
    return mColors.value(type);
}

void DesignFactory::registrate(QQmlContext *context)
{
    qmlRegisterType<DesignFactory>("com.graft.design", 1, 0, "DesignFactory");
    context->setContextProperty(QStringLiteral("ColorFactory"), this);
}

void DesignFactory::setApplicationFont() const
{
#ifdef Q_OS_ANDROID
    QFontDatabase::addApplicationFont(":/fonts/Roboto-Bold.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Roboto-Light.ttf");
    QFontDatabase::addApplicationFont(":/fonts/Roboto-Medium.ttf");
    int id = QFontDatabase::addApplicationFont(":/fonts/Roboto-Regular.ttf");
    QStringList loadedFontFamilies = QFontDatabase::applicationFontFamilies(id);
    if (!loadedFontFamilies.empty())
    {
        QString font = loadedFontFamilies.at(0);
        QGuiApplication::setFont(QFont(font));
    }
#endif
}

void DesignFactory::init()
{
#ifdef Q_OS_ANDROID
    if (QtAndroid::androidSdkVersion() >= 21)
    {
        QtAndroid::runOnAndroidThread([=]() {
            QAndroidJniObject window = QtAndroid::androidActivity().callObjectMethod(
                        "getWindow","()Landroid/view/Window;");
            window.callMethod<void>("addFlags", "(I)V", 0x80000000);
            window.callMethod<void>("clearFlags", "(I)V", 0x04000000);
            window.callMethod<void>("setStatusBarColor", "(I)V",
                                    QColor(color(AndroidStatusBar)).rgba());
            window.callMethod<void>("setNavigationBarColor", "(I)V",
                                    QColor(color(AndroidStatusBar)).rgba());
        });
    }
#endif
}
