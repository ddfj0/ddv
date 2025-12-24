#include "qmlif.h"
#include <iostream>

QMlif::QMlif()
{

}

//-------------- public method -----------
QString QMlif::fnDemoCall(QString para) const  /// qml直接调用
{

    std::cout << "fnDemoCall: " << para.toStdString() << std::endl;

    return "test";
}


//--------------- public solt ------------
void QMlif::slotDemoSigRun(bool useLiveData)  /// c++ 里connect信号，qml里触发信号，异步执行c++槽函数。也可以在qml直接调用。
{
    emit sigDemoEmit(useLiveData);  /// 本地触发，也可以在qml里触发。

}


