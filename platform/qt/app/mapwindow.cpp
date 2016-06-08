#include "mapwindow.hpp"

#include <QApplication>
#include <QDebug>
#include <QIcon>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QString>

int kAnimationDuration = 10000;

MapWindow::MapWindow(const QMapboxGLSettings &settings)
    : m_map(nullptr, settings)
    , m_bearingAnimation(&m_map, "bearing")
    , m_zoomAnimation(&m_map, "zoom")
    , m_pitchAnimation(&m_map, "pitch")
{
    connect(&m_map, SIGNAL(needsRendering()), this, SLOT(updateGL()));

    // Set default location to Helsinki.
    m_map.setCoordinateZoom(QMapbox::Coordinate(60.170448, 24.942046), 14);

    changeStyle();

    connect(&m_zoomAnimation, SIGNAL(finished()), this, SLOT(animationFinished()));

    setWindowIcon(QIcon(":icon.png"));
}

void MapWindow::selfTest()
{
    m_bearingAnimation.stop();
    m_zoomAnimation.stop();
    m_pitchAnimation.stop();

    // Set default location to Helsinki.
    m_map.setCoordinateZoom(QMapbox::Coordinate(60.170448, 24.942046), 10);
    m_map.setPitch(0);

    m_bearingAnimation.setDuration(kAnimationDuration);
    m_bearingAnimation.setEndValue(m_map.bearing() + 360 * 4);
    m_bearingAnimation.start();

    m_zoomAnimation.setDuration(kAnimationDuration);
    m_zoomAnimation.setEndValue(18);
    m_zoomAnimation.start();

    m_pitchAnimation.setDuration(kAnimationDuration);
    m_pitchAnimation.setEndValue(60);
    m_pitchAnimation.start();
}

void MapWindow::animationFinished()
{
    if (currentStyleIndex != 0) {
        changeStyle();
        selfTest();
        return;
    }

    qApp->quit();
}

void MapWindow::changeStyle()
{
    auto& styles = QMapbox::defaultStyles();

    m_map.setStyleURL(styles[currentStyleIndex].first);
    setWindowTitle(QString("Mapbox GL: ") + styles[currentStyleIndex].second);

    if (++currentStyleIndex == styles.size()) {
        currentStyleIndex = 0;
    }
}

void MapWindow::keyPressEvent(QKeyEvent *ev)
{
    switch (ev->key()) {
    case Qt::Key_S:
        changeStyle();
        break;
    case Qt::Key_Tab:
        m_map.cycleDebugOptions();
        break;
    default:
        break;
    }

    ev->accept();
}

void MapWindow::mousePressEvent(QMouseEvent *ev)
{
#if QT_VERSION < 0x050000
    m_lastPos = ev->posF();
#else
    m_lastPos = ev->localPos();
#endif

    if (ev->type() == QEvent::MouseButtonPress) {
        if (ev->buttons() == (Qt::LeftButton | Qt::RightButton)) {
            changeStyle();
        }
    }

    if (ev->type() == QEvent::MouseButtonDblClick) {
        if (ev->buttons() == Qt::LeftButton) {
            m_map.scaleBy(2.0, m_lastPos);
        } else if (ev->buttons() == Qt::RightButton) {
            m_map.scaleBy(0.5, m_lastPos);
        }
    }

    ev->accept();
}

void MapWindow::mouseMoveEvent(QMouseEvent *ev)
{
#if QT_VERSION < 0x050000
    QPointF delta = ev->posF() - m_lastPos;
#else
    QPointF delta = ev->localPos() - m_lastPos;
#endif

    if (!delta.isNull()) {
        if (ev->buttons() == Qt::LeftButton) {
            m_map.moveBy(delta);
        } else if (ev->buttons() == Qt::RightButton) {
#if QT_VERSION < 0x050000
            m_map.rotateBy(m_lastPos, ev->posF());
#else
            m_map.rotateBy(m_lastPos, ev->localPos());
#endif
        }
    }

#if QT_VERSION < 0x050000
    m_lastPos = ev->posF();
#else
    m_lastPos = ev->localPos();
#endif
    ev->accept();
}

void MapWindow::wheelEvent(QWheelEvent *ev)
{
    if (ev->orientation() == Qt::Horizontal) {
        return;
    }

    float factor = ev->delta() / 1200.;
    if (ev->delta() < 0) {
        factor = factor > -1 ? factor : 1 / factor;
    }

    m_map.scaleBy(1 + factor, ev->pos());
    ev->accept();
}

void MapWindow::initializeGL()
{
    QMapbox::initializeGLExtensions();
}

void MapWindow::resizeGL(int w, int h)
{
    QSize size(w, h);
    m_map.resize(size);
}

void MapWindow::paintGL()
{
    m_map.render();
}
