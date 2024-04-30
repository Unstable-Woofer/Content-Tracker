cmake_minimum_required(VERSION 3.16)

project(ContentTracker VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Multimedia Sql)

qt_standard_project_setup()

qt_add_executable(appContentTracker src/main.cpp)

qt_add_qml_module(appContentTracker
    URI ContentTracker
    VERSION 1.0
    QML_FILES
        ui/Main.qml
        ui/Home.qml
        ui/ProductionAdd.qml
        ui/ProductionManage.qml
        ui/Settings.qml
        ui/SiteManager.qml
    SOURCES
        src/database/tableproduction.h src/database/tableproduction.cpp
        src/database/tableproductionlist.h src/database/tableproductionlist.cpp
        src/database/tablesites.h src/database/tablesites.cpp
        src/database/tablesitesuploaded.h src/database/tablesitesuploaded.cpp
        src/database/manager.h src/database/manager.cpp
        src/utils/appsettings.h src/utils/appsettings.cpp
        src/utils/filemanager.h src/utils/filemanager.cpp
    RESOURCES
        images/tick_green.svg
        images/cross_red.svg
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appContentTracker PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appContentTracker
#    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
#    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
#    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appContentTracker PRIVATE
    Qt6::Quick
    Qt6::Multimedia
    Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS appContentTracker
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
