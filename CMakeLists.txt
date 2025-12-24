cmake_minimum_required(VERSION 3.16)

project(ddv VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_PREFIX_PATH "D:/soft/qt/Qt6/6.10.1/mingw_64")

find_package(Qt6 REQUIRED COMPONENTS Quick Gui)

qt_standard_project_setup(REQUIRES 6.8)

# 启用 QML 语言服务器支持，让 IDE 能正确识别 QML 导入
set(QT_QML_GENERATE_QMLLS_INI ON)

qt_add_executable(appddv
    main.cpp
)

# 添加资源文件（用于 C++ 访问）
qt_add_resources(appddv "resources"
    PREFIX "/"
    FILES
        img/ddfj0.ico
)

qt_add_qml_module(appddv
    URI ddv
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES img/Home.png
        RESOURCES img/Settings.png
        RESOURCES img/exit_white.png
        SOURCES qmlif.h qmlif.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appddv PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.ddfj0.appddv
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appddv
    PRIVATE Qt6::Quick Qt6::Gui
)

# 编译后自动复制可执行文件到 bin 目录
add_custom_command(TARGET appddv POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_SOURCE_DIR}/build/bin
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:appddv> ${CMAKE_SOURCE_DIR}/build/bin/
    COMMENT "Copying executable to bin directory"
)

include(GNUInstallDirs)
install(TARGETS appddv
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
