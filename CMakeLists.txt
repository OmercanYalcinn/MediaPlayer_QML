cmake_minimum_required(VERSION 3.16)

project(mediaPlayer_v02 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

qt_add_executable(appmediaPlayer_v02
    main.cpp
    v02_mediaPlayer
    v02_mediaPlayer
)

qt_add_qml_module(appmediaPlayer_v02
    URI mediaPlayer_v02
    VERSION 1.0
    QML_FILES Main.qml PopupTimer.qml
)

set_target_properties(appmediaPlayer_v02 PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appmediaPlayer_v02
    PRIVATE Qt6::Quick
)

install(TARGETS appmediaPlayer_v02
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
