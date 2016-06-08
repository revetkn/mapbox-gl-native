#include "mapwindow.hpp"

#include <QApplication>

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

    QMapboxGLSettings settings;
    settings.setAccessToken(qgetenv("MAPBOX_ACCESS_TOKEN"));
    settings.setCacheDatabaseMaximumSize(50 * 1024 * 1024);

    MapWindow window(settings);

    window.resize(800, 600);
    window.show();

    if (argc == 2 && QString("--test") == argv[1]) {
        window.selfTest();
    }

    return app.exec();
}
