import QtQuick 2.6
import QtQuick.Window 2.2

Window {
  id: root
  visible: true
  width: 640
  height: 480
  title: qsTr("Selection rectangle")

  Flickable {
    id: flickableView
    anchors.fill: parent

    Rectangle {
      id: selectionRect
      visible: false
      x: 0
      y: 0
      z: 99
      width: 0
      height: 0
      rotation: 0
      opacity: 0.5
      color: "#1DE9B6"
      border.width: 1
      border.color: "#103A6E"
      transformOrigin: Item.TopLeft
    }
  }

  MouseArea {
    id: selectionMouseArea
    property int initialXPos
    property int initialYPos

    anchors.fill: flickableView
    z: 2 // make sure we're above other elements
    onPressed: {
      if (mouse.button == Qt.LeftButton)
      {
        initialXPos = mouse.x
        initialYPos = mouse.y

        flickableView.interactive = false // in case the event started over a Flickable element
        selectionRect.x = mouse.x
        selectionRect.y = mouse.y
        selectionRect.width = 0
        selectionRect.height = 0
        selectionRect.visible = true
      }
    }
    onPositionChanged: {
      if (selectionRect.visible == true)
      {
        if (mouse.x != initialXPos || mouse.y != initialYPos) {
          if (mouse.x >= initialXPos) {
            if (mouse.y >= initialYPos)
              selectionRect.rotation = 0
            else
              selectionRect.rotation = -90
          }
          else {
            if (mouse.y >= initialYPos)
              selectionRect.rotation = 90
            else
              selectionRect.rotation = -180
          }
        }

        if (selectionRect.rotation == 0) {
          selectionRect.width = Math.min(Math.abs(mouse.x - selectionRect.x), flickableView.width - selectionRect.x)
          selectionRect.height = Math.min(Math.abs(mouse.y - selectionRect.y), flickableView.height - selectionRect.y)
        }
        else if (selectionRect.rotation == 90){
          selectionRect.width = Math.min(Math.abs(mouse.y - selectionRect.y), flickableView.height - selectionRect.y)
          selectionRect.height = Math.min(Math.abs(mouse.x - selectionRect.x), selectionRect.x)
        }
        else if (selectionRect.rotation == -180){
          selectionRect.width = Math.min(Math.abs(mouse.x - selectionRect.x), Math.abs(selectionRect.x))
          selectionRect.height = Math.min(Math.abs(mouse.y - selectionRect.y), Math.abs(selectionRect.y))
        }
        else if (selectionRect.rotation == -90){
          selectionRect.width = Math.min(Math.abs(mouse.y - selectionRect.y), Math.abs(selectionRect.y))
          selectionRect.height = Math.min(Math.abs(mouse.x - selectionRect.x), Math.abs(flickableView.width - selectionRect.x))
        }
      }
    }

    onReleased: {
      flickableView.interactive = true
    }
  }
}
