///
/// dreamchain@live.cn
///

import QtCore
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

ApplicationWindow {
    /// 属性
    id: frmMain
    width: 1600
    height: 900
    visible: true
    title: qsTr("视觉软件平台")
    color: "black"

    /// C++ 对象引用
    property var m_qmlif: null  /// C++ 对象引用

    /// 变量
    property bool bExit : false
    property string bkgHeadMenuColor: "#25292c"
    property string bkgMenuBtnSelColor: "#424f57"
    property string bkgWindowColor: "#737373"
    property real   mathPi: 3.1415926    

    property string msgboxTitle: "test"
    property string msgboxContent: "test"
    property bool msgboxRtn: false

    /// 信号 - 用于异步调用 C++ 槽函数
    signal sigDemoRun(bool useLiveData)

    /// 函数
    function fnDrawEllips(centerX, centerY, angle, radiusX, radiusY, ctx )
    {
        if( ctx === null ) return;

        ctx.translate(centerX, centerY);
        ctx.rotate( angle );

        ctx.beginPath();
        var factor = 0.552284749831; // 贝塞尔曲线近似系数
        ctx.moveTo(-radiusX, 0);
        ctx.bezierCurveTo(-radiusX, radiusY * factor, -radiusX * factor, radiusY, 0, radiusY);
        ctx.bezierCurveTo(radiusX * factor, radiusY, radiusX, radiusY * factor, radiusX, 0);
        ctx.bezierCurveTo(radiusX, -radiusY * factor, radiusX * factor, -radiusY, 0, -radiusY);
        ctx.bezierCurveTo(-radiusX * factor, -radiusY, -radiusX, -radiusY * factor, -radiusX, 0);
        ctx.closePath();

        ctx.fillStyle = "blue";
        ctx.fill();
        //ctx.strokeStyle = "darkblue";
        //ctx.lineWidth = 2;
        //ctx.stroke();

    }

    /// 组件
    header: ToolBar {
        id: toolbar
        height: 60
        background: Rectangle {
            color: frmMain.bkgHeadMenuColor
        }

        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: " \u2630"
                palette.buttonText: hovered ? 'yellow' : 'white'
                background: Rectangle {
                    color: frmMain.bkgHeadMenuColor
                }
                font.pixelSize: 20
                onClicked: {
                    if( drawer.visible) {
                        drawer.close()
                    }
                    else {
                        drawer.open()
                    }
                }
            }
            Label {
                text: "视觉软件平台"
                color: "#c0c000"
                font.pixelSize: 24
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                background: Rectangle {
                    color: frmMain.bkgHeadMenuColor
                }

            }
            ToolButton {
                text: qsTr("x ")
                font.pixelSize: 20
                palette.buttonText: hovered ? 'yellow' : 'white'
                background: Rectangle {
                    color: frmMain.bkgHeadMenuColor
                }
                onClicked: {
                    frmMain.close()
                }
            }
        }
    }

    Drawer {  /// 左侧菜单
        id: drawer
        width: 100
        height: frmMain.height - toolbar.height
        y: toolbar.height

        background: Rectangle {
            color: frmMain.bkgHeadMenuColor
        }

        // 左侧菜单项
        Column {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 2

            ItemDelegate {
                id: btnMenuHome
                width: parent.width
                height: 80

                onClicked: {
                    drawer.close()
                    frmHome.visible = true
                    frmSettings.visible = false

                    btnMenuHome.background.color = frmMain.bkgMenuBtnSelColor
                    btnMenuSettings.background.color = frmMain.bkgHeadMenuColor
                }

                background: Rectangle {
                    color: frmMain.bkgHeadMenuColor
                    border.color: frmMain.bkgMenuBtnSelColor
                }

                Column {
                    y: 8
                    anchors.horizontalCenter: btnMenuHome.horizontalCenter
                    Image {
                        id: btnMenuHomeImg
                        source: "img/Home.png"
                        height: 50
                        width: 50
                    }
                    Label {
                        text: "算法"
                        color: "white"
                        anchors.horizontalCenter: btnMenuHomeImg.horizontalCenter
                    }
                }
            }
            ItemDelegate {
                id: btnMenuSettings
                width: parent.width
                height: 80

                onClicked: {
                    drawer.close()
                    frmHome.visible = false
                    frmSettings.visible = true

                    btnMenuHome.background.color = frmMain.bkgHeadMenuColor
                    btnMenuSettings.background.color = frmMain.bkgMenuBtnSelColor

                    frmMain.sigDemoRun(true);
                    frmMain.sigDemoRun(false);

                    console.log( "call fnDemoCall: " + frmMain.m_qmlif.fnDemoCall("qml cll c++ code") );
                }

                background: Rectangle {
                    color: frmMain.bkgHeadMenuColor
                    border.color: frmMain.bkgMenuBtnSelColor
                }

                Column {
                    y: 8
                    anchors.horizontalCenter: btnMenuSettings.horizontalCenter
                    Image {
                        id: btnMenuSettingsImg
                        source: "img/Settings.png"
                        height: 50
                        width: 50
                    }
                    Label {
                        topPadding: 4
                        text: "设置"
                        color: "white"
                        anchors.horizontalCenter: btnMenuSettingsImg.horizontalCenter
                    }
                }
            }
        }

        // 底部退出按钮
        ItemDelegate {
            id: btnMenuExit
            width: parent.width
            height: 80
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            
            onClicked: {
                frmMain.close()
            }

            background: Rectangle {
                color: frmMain.bkgHeadMenuColor
                border.color: frmMain.bkgMenuBtnSelColor
            }

            Column {
                y: 8
                anchors.horizontalCenter: btnMenuExit.horizontalCenter
                Image {
                    id: btnMenuExitImg
                    source: "img/exit_white.png"
                    height: 50
                    width: 50
                }
                Label {
                    text: "退出"
                    color: "white"
                    anchors.horizontalCenter: btnMenuExitImg.horizontalCenter
                }
            }
        }

    }

    Timer {
        id: drawTimer
        interval: 100
        running : true
        repeat  : true
        onTriggered: {
            //console.log("draw time run ...");
            canvasHome.requestPaint();
        }
    }


    /// 消息
    Component.onCompleted: { /// 初始化
        // 在这里设置变量和修改组件属性
        console.log("ApplicationWindow completed.");
        
        // 示例：设置默认显示 home 页面
        frmHome.visible = true;
        frmSettings.visible = false;
        btnMenuHome.background.color = bkgMenuBtnSelColor;

        m_qmlif = qmlif;  /// 获取 C++ 对象引用，过早引用会导致失败。
        // 连接 C++ 信号到 QML 槽函数，用来接收 C++ 的推送（发出的信号）
        m_qmlif.sigDemoEmit.connect(onSigDemoEmit);

        //btnMenuExit.y = drawer.height - 80
        //console.log( "高度 " + drawer.height)
        //console.log( "y " + btnMenuExit.y)
    }

    onClosing: function ( evClose) { /// 关闭窗口
        quitDialog.open()
        evClose.accepted = false;
    }
    MessageDialog {
        id : quitDialog
        title: qsTr("退出?")
        text: qsTr("是否退出?")
        buttons: MessageDialog.Yes | MessageDialog.No
        onButtonClicked: function (button, role) {
            if (role === MessageDialog.YesRole) {
                console.log( "exit application ..." )
                Qt.exit(0)
            }
        }
    }


    /// 窗口大小变化信号
    onWidthChanged: {
        //console.log("窗口宽度变化：", width)
        // 在这里处理窗口宽度变化
        //btnMenuExit.y = drawer.height - 80
        //console.log( "y " + btnMenuExit.y)
    }

    onHeightChanged: {
        //console.log("窗口高度变化：", height)
        // 在这里处理窗口高度变化
        //btnMenuExit.y = drawer.height - 80
        //console.log( "y " + btnMenuExit.y)
    }

    /// 接收 C++ 发出的信号
    function onSigDemoEmit(full) {
        console.log("receive C++ signal sigDemoEmit:", full)
        // 在这里处理 C++ 发来的信号
    }



    /// home 页面
    Rectangle {
        id: frmHome
        color: frmMain.bkgWindowColor
        visible: false

        width: parent.width
        height: frmMain.height - toolbar.height

        //border.color: "white"
        //border.width: 1

        Rectangle {
            id: frmHomeTopleft

            color: frmMain.bkgMenuBtnSelColor
            x: 1
            width: parent.width / 2 - 2
            height: parent.height / 2 - 1

            border.color: "yellow"
            border.width: 1
            radius: 6

            anchors.top:  parent.top
            anchors.left: parent.left

            Rectangle {
                id: frmHomeTopLeftHeader

                width: parent.width - 20
                height: 40
                y: 1

                //border.color: "yellow"
                //border.width: 1
                color: frmMain.bkgMenuBtnSelColor

                anchors.horizontalCenter: parent.horizontalCenter

                Label {
                    id: homeLabel
                    text: "算法分析"
                    color: "white"
                    font.pixelSize: 14
                    topPadding: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.verticalCenter: parent.verticalCenter

                }

            }


            Rectangle {
                id: frmHomeTopLeftControls

                width: parent.width - 20
                height: 40

                //border.color: "yellow"
                //border.width: 1
                color: frmMain.bkgMenuBtnSelColor

                anchors.top: frmHomeTopLeftHeader.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                Row {
                    spacing: 10
                    topPadding: 10
                    leftPadding: 4

                    Label {
                        text: "坐标X："
                        color: "plum"
                        font.pixelSize: 12
                        leftPadding: 4
                    }

                    TextField {
                        id: editX
                        width: 60
                        focus: true
                        wrapMode: TextEdit.Wrap
                        color: "white"
                        cursorVisible: true
                        background: Rectangle {
                            color: "black"
                        }
                    }

                    Label {
                        text: "坐标Y："
                        color: "white"
                        font.pixelSize: 12
                        leftPadding: 4
                    }

                    TextField {
                        id: editY
                        width: 60
                        focus: true
                        wrapMode: TextEdit.Wrap
                        color: "white"
                        cursorVisible: true
                        background: Rectangle {
                            color: "black"
                        }
                    }

                    Button {
                        text: qsTr("运算")
                        //leftPadding: 10

                        width: 80
                        onClicked: {
                            if( editX.text === "") {
                                popupTitle.text = "提示";
                                popupContent.text = "请输入X坐标！";
                                popup.open();
                                return;
                            }
                            if( editY.text === "") {
                                popupTitle.text = "提示";
                                popupContent.text = "请输入Y坐标！";
                                popup.open();
                                return;
                            }
                            editX.text = "5";
                            editY.text = "10"

                        }

                        Popup {
                            id: popup

                            width: 300
                            height: 200

                            modal: true
                            focus: true
                            anchors.centerIn: Overlay.overlay
                            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent


                            Label {
                                id: popupTitle
                                text: ""
                            }

                            Text {
                                id: popupContent
                                anchors.centerIn: parent
                                text: ""
                            }

                            Button {
                                text: qsTr("确定")
                                bottomPadding: 8

                                //anchors.centerIn: parent
                                anchors.bottom: parent.bottom
                                anchors.horizontalCenter: popupContent.horizontalCenter
                                //anchors.left: parent.left
                                //anchors.right: parent.right

                                onClicked: {
                                    popup.close();
                                }
                            }

                        }

                    }

                }
            }


            Canvas {
                id: canvasHome

                width: parent.width - 20
                height: parent.height - frmHomeTopLeftControls.height - frmHomeTopLeftHeader.height - 20

                anchors.horizontalCenter: parent.horizontalCenter
                //anchors.verticalCenter: parent.verticalCenter
                anchors.top: frmHomeTopLeftControls.bottom
                anchors.topMargin: 5


                property real angRight: 0
                property real angLeft: 0

                Component.onCompleted: {
                    console.log("canvas completed...");
                }

                onPaint: {
                    //console.log("canvas onPaint 1...");
                    var ctx = canvasHome.getContext("2d");

                    ctx.clearRect(0, 0, canvasHome.width, canvasHome.height);
                    ctx.strokeStyle = "darkblue";
                    ctx.lineWidth = 1;
                    ctx.strokeRect(0, 0, canvasHome.width, canvasHome.height )

                    angRight += frmMain.mathPi / 60;  /// 每次增加 3 度
                    if( angRight > (2 * frmMain.mathPi) ) angRight = 0;
                    ctx.save();
                    frmMain.fnDrawEllips(292, 200, angRight, 50, 42, ctx);
                    ctx.restore();

                    angLeft = 2 * frmMain.mathPi + frmMain.mathPi / 2 - angRight;  /// 每次增加 3 度
                    if( angLeft < frmMain.mathPi / 60 ) angLeft = 2 * frmMain.mathPi;
                    ctx.save();
                    frmMain.fnDrawEllips(200, 200, angLeft, 50, 42, ctx);
                    ctx.restore();

                }
            }

        }

        Rectangle {
            id: frmHomeTopRight

            color: frmMain.bkgMenuBtnSelColor
            x: parent.width + 1
            width: parent.width / 2 - 2
            height: parent.height / 2 - 1

            border.color: "yellow"
            border.width: 1
            radius: 6

            anchors.top:  parent.top
            anchors.right: parent.right
        }

        Rectangle {
            id: frmHomeBtmleft

            color: frmMain.bkgMenuBtnSelColor
            x: 1
            y: parent.height / 2
            width: parent.width / 2 - 2
            height: parent.height / 2 - 1

            border.color: "yellow"
            border.width: 1
            radius: 6

            anchors.left: parent.left
            anchors.bottom: parent.bottom

            Label {
                text: "算法二"
                color: "#c0c000"
                font.pixelSize: 12
                //horizontalAlignment: Qt.AlignHCenter
                //verticalAlignment: Qt.AlignVCenter
                topPadding: 4
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }

        Rectangle {
            id: frmHomeBtmRight

            color: frmMain.bkgMenuBtnSelColor
            x: parent.width + 1
            y: parent.height / 2
            width: parent.width / 2 - 2
            height: parent.height / 2 - 1

            border.color: "yellow"
            border.width: 1
            radius: 6

            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

    }


    /// setup 页面
    Rectangle {
        id: frmSettings
        color: frmMain.bkgWindowColor
        visible: false

        width: parent.width
        height: frmMain.height - toolbar.height

        //border.color: "white"
        //border.width: 1

        Rectangle {
            id: frmSetTopleft

            color: frmMain.bkgMenuBtnSelColor
            x: 1
            width: parent.width / 2 - 2
            height: parent.height / 2 - 1

            border.color: "yellow"
            border.width: 1
            radius: 6

            anchors.top:  parent.top
            anchors.left: parent.left

            Label {
                text: "系统设置"
                color: "#c0c000"
                font.pixelSize: 12
                //horizontalAlignment: Qt.AlignHCenter
                //verticalAlignment: Qt.AlignVCenter
                topPadding: 4
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }

        Rectangle {
            id: frmSetTopRight

            color: frmMain.bkgMenuBtnSelColor
            x: parent.width + 1
            width: parent.width / 2 - 2
            height: parent.height / 2 - 1

            border.color: "yellow"
            border.width: 1
            radius: 6

            anchors.top:  parent.top
            anchors.right: parent.right
        }

        Rectangle {
            id: frmSetBtmleft

            color: frmMain.bkgMenuBtnSelColor
            x: 1
            y: parent.height / 2
            width: parent.width / 2 - 2
            height: parent.height / 2 - 1

            border.color: "yellow"
            border.width: 1
            radius: 6

            anchors.left: parent.left
            anchors.bottom: parent.bottom

            Label {
                text: "系统设置"
                color: "#c0c000"
                font.pixelSize: 12
                //horizontalAlignment: Qt.AlignHCenter
                //verticalAlignment: Qt.AlignVCenter
                topPadding: 4
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }

        Rectangle {
            id: frmSetBtmRight

            color: frmMain.bkgMenuBtnSelColor
            x: parent.width + 1
            y: parent.height / 2
            width: parent.width / 2 - 2
            height: parent.height / 2 - 1

            border.color: "yellow"
            border.width: 1
            radius: 6

            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

   }
}
