// Emacs mode hint: -*- mode: JavaScript -*-
// https://bitbucket.org/xiannox/trusty-qt5.7-beta-x64/raw/HEAD/qt-installer-noninteractive.qs
// https://bitbucket.org/xiannox/trusty-qt5.7-beta-x64
// modified to depend on envar

function Controller() {
    installer.autoRejectMessageBoxes();
    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton);
    })
}

Controller.prototype.WelcomePageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.CredentialsPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.IntroductionPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.TargetDirectoryPageCallback = function()
{
    gui.currentPageWidget().TargetDirectoryLineEdit.setText("/opt/qt");
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    var widget = gui.currentPageWidget();
    // http://doc.qt.io/qtinstallerframework/scripting-installer.html#environmentVariable-method
    var QTM = installer.environmentVariable("QTM");
    var QTCOMPONENTS = installer.environmentVariable("QTCOMPONENTS") || "gcc_64";
    if (!QTM) {
        throw new Error("No QTM environment variable set.");
    }
    var components = QTCOMPONENTS.split(",").filter(function truthy(x) { return !!x; });
    var prefix = "qt." + installer.environmentVariable("QTM").replace(/\./g, "") + ".";
    widget.deselectAll();
    console.log("ComponentSelectionPageCallback selecting components:");
    for (idx=0; idx < components.length; idx++) {
        var component = prefix + components[idx];
        console.log('*', component);
        widget.selectComponent(component);
    }
    console.log("Done.");
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.StartMenuDirectoryPageCallback = function() {
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.ReadyForInstallationPageCallback = function()
{
    gui.clickButton(buttons.NextButton);
}

Controller.prototype.FinishedPageCallback = function() {
var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm
if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
    checkBoxForm.launchQtCreatorCheckBox.checked = false;
}
    gui.clickButton(buttons.FinishButton);
}
