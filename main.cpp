#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include <qicon.h>
#include "qmlif.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);  /// 创建本地线程
    app.setWindowIcon(QIcon(":/img/ddfj0.ico"));  /// 设置系统图标

    QQmlApplicationEngine engine;     /// 创建 qml 环境
    QObject::connect(   /// 连接 qml创建失败信号，提供失败退出功能
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    /// 设置 c++ 对象到 qml 里，为了给 qml 同步调用
    QMlif qmlif;
    engine.rootContext()->setContextProperty("qmlif", &qmlif);

    engine.loadFromModule("ddv", "Main");  /// 加载 qml 前端


    /// 连接 c++ 槽到 qml 里的信号，为了给 qml 异步调用
    QList listQmlObj = engine.rootObjects();

    if( listQmlObj.isEmpty() == false )
    {
        QObject * rootObject = listQmlObj.first();
        QObject::connect(rootObject, SIGNAL(sigDemoRun(bool)), &qmlif, SLOT(slotDemoSigRun(bool)));
    }

    /// 启动其他 c++ 后台服务

    return app.exec();
}
