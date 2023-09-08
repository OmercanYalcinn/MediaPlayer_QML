import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material
import Qt.labs.folderlistmodel
import Qt.labs.platform
import Qt.labs.folderlistmodel 2.15
import QtMultimedia
import QtQuick.Dialogs

Popup {
    id: uiSettingsPopupId

    property string title : "Ana Ekran Ayarları"

    parent: Overlay.overlay
    anchors.centerIn: Overlay.overlay
    modal: true
    focus: true
    dim: true
    width: 600
    height: 365
    closePolicy: Popup.NoAutoClose

    property int preferredWidth: 100

    contentItem : Pane {
        id: uiSettingsPane
        Material.elevation: 16

        background: Rectangle {
            color: mainBackgroundColor
            border.color: "#696866"
        }

        Rectangle{
            anchors.centerIn: parent
            Column {
                anchors.centerIn: parent
                Text {
                    id: timeSetInputHeading
                    text: "Please Write the Time That You Want To Go"
                    font.bold: true
                }
                TextField {
                    id: takingInputTime
                    // allow only numeric inputs
                    validator: DoubleValidator {
                        bottom: 0
                        top: mediaPlayer.duration / 1000
                    }
                    inputMask: "00:00:00"
                    // function from Main - convertToVideoTime
                    text: convertToVideoTime(mediaPlayer.position)

                }
                Button {
                    id: goToTime
                    text: "SET"
                    anchors.horizontalCenter: horizontalCenter.uiSettingsPane

                    onClicked: {
                        // type is seconds - max duration, thats why /1000
                        var maxDuration = mediaPlayer.duration / 1000
                        var totalTimeInSeconds

                        console.log(maxDuration)

                        var input = takingInputTime.text;
                        var separatorIndex = input.indexOf(":");
                        if (separatorIndex !== -1) {
                            var hours = parseInt(input.substr(0, 2));
                            var minutes = parseInt(input.substr(3,5));
                            var seconds = parseInt(input.substr(6,7));
                            totalTimeInSeconds = hours * 3600 + minutes * 60 + seconds;
                        }
                        mediaPlayer.seek(totalTimeInSeconds * 1000);

                        if(totalTimeInSeconds > maxDuration){
                            warnningMessageBox.visible = true
                            console.log("WARNNING - Please Rewrite the duration between 0 and " + maxDuration + " !!!")
                        }
                    }
                }
                Button {
                    id: closeIcon
                    text: "EXIT"
                    icon.name: "closeButton"

                    onClicked: {
                        uiSettingsPopupId.close()
                    }
                }

            }
        }

        // Warnning Message Box
        Rectangle {
            id: warnningMessageBox
            width: 400
            height: 200
            anchors.centerIn: parent
            color: "lightgrey"
            border.color: "black"
            visible: false

            Column {
                spacing: 20
                anchors.centerIn: parent
                Text {
                    id: warningHeading
                    text: "Warning!!!"
                    font.bold: true
                }

                Text {
                    text: "WARNNING - Please Rewrite the duration between video time limits"
                }

                Button {
                    text: "OK"
                    onClicked: {
                        warnningMessageBox.visible = false;
                    }
                }
            }
        }
    }
}
