// Emacs mode hint: -*- mode: JavaScript -*-
// https://bitbucket.org/xiannox/trusty-qt5.7-beta-x64/raw/HEAD/qt-installer-noninteractive.qs
// https://bitbucket.org/xiannox/trusty-qt5.7-beta-x64

function Controller() {
    installer.autoRejectMessageBoxes();
    installer.installationFinished.connect(function() {
        console.log('=== installationFinished');
        gui.clickButton(buttons.NextButton, 3000);
    });
}

Controller.prototype.WelcomePageCallback = function() {
    console.log('=== WelcomePageCallback');
    gui.clickButton(buttons.NextButton, 3000);
    console.log('=== WelcomePageCallback CLICKED');
}

Controller.prototype.CredentialsPageCallback = function() {
    console.log('=== CredentialsPageCallback');
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.IntroductionPageCallback = function() {
    console.log('=== IntroductionPageCallback');
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.TargetDirectoryPageCallback = function() {
    console.log('=== TargetDirectoryPageCallback');
    gui.currentPageWidget().TargetDirectoryLineEdit.setText("/opt/qt");
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    console.log('=== ComponentSelectionPageCallback');

    var widget = gui.currentPageWidget();

    widget.deselectAll();
    widget.selectComponent("qt.qt5.597.gcc_64");
    // to add more components:
    // widget.selectComponent("qt.59.qtwebengine");
    // add --verbose to installer.run command line to discover

    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    console.log('=== LicenseAgreementPageCallback');
    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.StartMenuDirectoryPageCallback = function() {
    console.log('=== StartMenuDirectoryPageCallback');
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.ReadyForInstallationPageCallback = function() {
    console.log('=== ReadyForInstallationPageCallback');
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.FinishedPageCallback = function() {
    console.log('=== FinishedPageCallback');
    var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm;
    if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
        checkBoxForm.launchQtCreatorCheckBox.checked = false;
    }
    gui.clickButton(buttons.FinishButton, 3000);
}
