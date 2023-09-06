import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Material
import QtMultimedia
import QtQuick.Dialogs

Window {
    color: "black"
    id:root
    width: 1500
    height: 800
    visible: true
    title: qsTr("Video Player")

    Item {
        anchors.fill: parent
        Rectangle{
            Video {
                id: mediaPlayer
                source: "file:///C:/Users/omercan.yalcin/Desktop/QT/file_example.mov"
                onStateChanged: {
                    if(Video.PausedState){
                        firstFrameImage.source = mediaPlayer.videoFrameImage
                        console.log("First Frame Has Done")
                    }
                }
            }
        }

        MouseArea {
            // availabilty of the clickin on screen - Right -
            id: mouseArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onPressed: (mouse)=> {
                           // right click Open Menu Bar for functions
                           if(mouse.button === Qt.RightButton){
                               console.log("right button used")
                               rightClickMenu.popup()
                               // and stop the video - for screenshot - call function - from MENU
                           }
                           // left click Video Pause and MediaPlayer
                           else if(mouse.button === Qt.LeftButton) {
                               console.log("left button used")
                               mediaPlayer.play()
                           }
                       }
        }
    }

    Menu {
        id: rightClickMenu

        MenuItem{
            text: "Screenshot and Save"
            onClicked: {
                mediaPlayer.pause()
                takeScreenShot();
            }
        }
    }

    function takeScreenShot(){
        var date = new Date();
        var filename = "screenshot_" +  date.getTime() + ".png";

        mediaPlayer.grabToImage(function(result){
            result.saveToFile(filename);
            console.log("Screenshot has taken: " + filename);
            saveFile.open()
        }
        );
    }

    FileDialog {
        id: saveFile
        title: "Save File"
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]
        onAccepted: {
            var selectedFilePath = saveFile.fileUrl
            console.log("Selected File Path: " + selectedFilePath)
            mediaPlayer.play()
        }
        fileMode:FileDialog.SaveFile
    }

    // slider background
    Rectangle {
        id: sliderBackground
        height: 100
        width: root.width
        color: "white"
        anchors.bottom: parent.bottom

        Rectangle {
            id: buttonsRec
            anchors.horizontalCenter: sliderBackground.horizontalCenter
            Button {
                id: playButton
                anchors.right: pauseButton.left
                icon.name: "playButton"
                icon.source: "file:///C:/Users/omercan.yalcin/Desktop/QT/playIcon.png"

                onClicked: {
                    console.log("Played")
                    mediaPlayer.play()
                }
            }
            Button {
                id: pauseButton
                anchors.left: playButton.right
                icon.name: "pauseButton"
                icon.source: "file:///C:/Users/omercan.yalcin/Desktop/QT/pauseIcon.png"

                onClicked: {
                    console.log("Paused");
                    mediaPlayer.pause()
                }
            }
        }
        Button {
            id: settingsButton
            anchors.right: sliderBackground.right
            anchors.rightMargin: 15
            icon.name: "settingsButton"
            icon.source: "file:///C:/Users/omercan.yalcin/Desktop/QT/settingsIcon.png"

            onClicked: {
                console.log("Pop Settings")
                settingsMenu.popup()
            }
        }


        Slider {
            id: progressSlider
            from: 0
            value: mediaPlayer.position
            to: mediaPlayer.duration

            anchors.bottom: sliderBackground.bottom
            anchors.bottomMargin: 10
            anchors.left: sliderBackground.left
            anchors.right: sliderBackground.right

            onValueChanged: {
                console.log(value + " Value Changed")
                mediaPlayer.seek(value)
            }
        }
    }

    Menu{
        id: settingsMenu
        MenuItem {
            text: "Set Time"
            onClicked: {
                // function will be called here - sldier time change
                openPopupLoader(popupTimerLoader)
            }
        }
    }

    Loader {
        id: popupTimerLoader
        active: false
        source: "PopupTimer.qml"
        onLoaded: item.open()
    }

    function openPopupLoader(popupLoader){
        if(popupLoader.active) {
            popupLoader.item.open()
        } else {
            popupLoader.active = true
        }
    }

    function convertToVideoTime(value) {
        var totalSeconds = value / 1000
        var hours = Math.floor(totalSeconds / 3600)
        var minutes = Math.floor((totalSeconds % 60) / 60)
        var seconds = Math.floor(totalSeconds % 60)

        return (hours < 10 ? "0" : "") + hours + ":" +
               (minutes < 10 ? "0" : "") + minutes + ":" +
               (seconds < 10 ? "0" : "") + seconds
    }

    function timeText(minute, second){
        var timeInSeconds = minute.toString() + ":" + second.toString()
        return timeInSeconds
    }

}
