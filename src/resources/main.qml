import QtQuick 2.5
import Qt.labs.controls 1.0
import QtQuick.Layouts 1.3


ApplicationWindow {
    id: app
    visible: true
    width: 640
    height: 480
    title: qsTr("Yet Another NonoGrams")

    property int gridColls: 2
    property int gridCellWidth: app.width/gridColls

    property int gridRows: 4
    property int gridCellHeight: app.height/gridRows

    property bool loadingCrossword: false

    FontLoader {
        id: mandarinFont;
        source: "qrc:/MandarinC.ttf"
    }

    FontLoader {
        id: hanZiFont;
        source: "qrc:/HanZi.ttf"
    }

    header: ToolBar {
        id: topToolBar
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: "Open"
                font.family: hanZiFont.name
                font.pointSize: 20
                onClicked: drwr.open()
            }
        }

        Text{
            anchors.centerIn: parent
            font.family: hanZiFont.name
            font.pointSize: 20
            text:"Yet Another NonoGrams"
        }
    }

    Item{
        id: game
        anchors.fill: parent

        Drawer{
            id: drwr
            edge: Qt.LeftEdge

            ToolBar{
                height:app.height

                ColumnLayout{
                    width: parent.width
                    ToolButton{
                        text:"Small"
                        font.family: hanZiFont.name
                        font.pointSize: 16
                        onClicked: {
                            game.state = "ShowGallery";
                            crosswords.source = "http://www.nonograms.ru/nonograms/size/small";
                            drwr.close()
                        }
                    }
                    ToolButton{
                        text:"Medium"
                        font.family: hanZiFont.name
                        font.pointSize: 16
                        onClicked:{
                            game.state = "ShowGallery";
                            crosswords.source = "http://www.nonograms.ru/nonograms/size/medium";
                            drwr.close()
                        }
                    }
                    ToolButton{
                        text:"Large"
                        font.family: hanZiFont.name
                        font.pointSize: 16
                        onClicked: {
                            game.state = "ShowGallery";
                            crosswords.source = "http://www.nonograms.ru/nonograms/size/large";
                            drwr.close()
                        }
                    }
                }
            }
        }

        Image{
            asynchronous: true
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
            source:"qrc:/lotos.jpg"
            cache:false
        }

        NonogramsGallery {
            id:cosswordsView
            model:crosswords
            height: parent.height
            width: parent.width
            //labelFontPixelSize: 16

            onOpenNonogram:{
                loadingCrossword = true;
                game.state = 'InGame';
                nonogramField.loadFromNonogramsOrg(itemUrl);
            }
        }

        Flickable{
            visible: false
            id: crossFlick
            height: parent.height
            width: parent.width
            contentWidth:flickableItem.width
            contentHeight:flickableItem.height
            ScrollBar.vertical: ScrollBar {
            }
            ScrollBar.horizontal: ScrollBar {
            }

            Item{
                id: flickableItem
                implicitWidth: Math.max(nonogramField.width, app.width)
                implicitHeight: Math.max(nonogramField.height, app.height)

                Nonogram {
                    id: nonogramField
                    anchors.centerIn: parent
                    ceilSize: 25
                    fontSize: 18
                    visible: true
                }
            }

        }

        Connections {
            target: crossword
            onLoaded: {
                loadingCrossword = false;
            }
        }

        BusyIndicator {
            anchors.centerIn: parent
            running: loadingCrossword
        }

        states: [
            State {
                name: "ShowGallery"
                PropertyChanges { target: cosswordsView; visible: true }
                PropertyChanges { target: crossFlick; visible: false }
            },
            State {
                name: "InGame"
                PropertyChanges { target: cosswordsView; visible: false }
                PropertyChanges { target: crossFlick; visible: true }
            }
        ]
    }
}
