#ifndef QMLIF_H
#define QMLIF_H

/*
 *  by dream/qq327689069  20251209
 *  qmlif实现qml的c++接口，按照前后端思路设计。
 *  qml通过调用c++公共函数实现同步调用c++方法，通过信号实现异步调用c++槽
 *
 *  QMlif：qml interface  后台c++定义的接口，为了给qml调用
 *
 */


#include <QObject>


class QMlif : public QObject
{
    Q_OBJECT

public:
    QMlif();


    Q_INVOKABLE QString fnDemoCall(QString para) const; /// qml直接调用


public slots:
    void slotDemoSigRun(bool useLiveData); /// c++ 里connect信号，qml里触发信号，异步执行c++槽函数。也可以在qml直接调用。


signals:
    void sigDemoEmit(bool full);  /// 在qml里connect，c++推送信号到qml。



};

#endif // QMLIF_H
