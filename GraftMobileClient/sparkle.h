#ifndef SPARKLE_H
#define SPARKLE_H

#if defined(QT_NO_DEBUG) && (defined(Q_OS_WIN) || defined(Q_OS_MACOS) && !defined(Q_OS_IOS)) && !defined(DISABLE_SPARKLE_UPDATER) && !defined(DSA_PUB_PEM_MISSING)
#include <QSettings>

#include "sparkleupdater.h"
#define IS_ENABLE_SPARKLE
#endif

#ifdef IS_ENABLE_SPARKLE
#ifdef Q_OS_WIN
void exitFunction()
{
    QSettings s;
    QDir appDir(qApp->applicationDirPath());
    appDir.cdUp();
    s.setValue("InstallLocation", QDir::toNativeSeparators(appDir.absolutePath()));
    std::exit(0);
}
#endif

#ifdef POS_BUILD
static const QString scSparkleFeedUrl("https://raw.githubusercontent.com/graft-project/GraftMobile/master/GraftMobileClient/pos_update.xml");
#elif WALLET_BUILD
static const QString scSparkleFeedUrl("https://raw.githubusercontent.com/graft-project/GraftMobile/master/GraftMobileClient/wallet_update.xml");
#endif
#endif

void runSparkleUpdater()
{
#ifdef IS_ENABLE_SPARKLE
    SparkleUpdater::instance()->setLanguage(QStringLiteral("eng"));
    SparkleUpdater::instance()->setAppInfo(qApp->organizationName(), qApp->applicationName(), qApp->applicationVersion());
#ifdef Q_OS_WIN
    SparkleUpdater::instance()->setWillCloseCallback(&exitFunction);
#endif
    SparkleUpdater::instance()->setAutoChecksUpdates(true);
    SparkleUpdater::instance()->setFeedUrl(QUrl(scSparkleFeedUrl));
    SparkleUpdater::instance()->init();
    SparkleUpdater::instance()->checkForUpdates(true);
#endif
#ifdef REQUIRE_ENABLED_SPARKLE
    #ifdef DSA_PUB_PEM_MISSING
        static_assert(false, "dsa_pub.pem is missing!");
    #endif
    #ifdef DISABLE_SPARKLE_UPDATER
        static_assert(false, "Sparkle updater is disabled!");
    #endif
#else
    #ifdef DSA_PUB_PEM_MISSING
        #pragma message("dsa_pub.pem is missing!")
    #endif
    #ifdef DISABLE_SPARKLE_UPDATER
        #pragma message("Sparkle updater is disabled!")
    #endif
#endif
}

void stopSparkleUpdater()
{
#ifdef IS_ENABLE_SPARKLE
    SparkleUpdater::instance()->clean();
#endif
}

#endif // SPARKLE_H
