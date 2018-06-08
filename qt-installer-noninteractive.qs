// Emacs mode hint: -*- mode: JavaScript -*-
// https://bitbucket.org/xiannox/trusty-qt5.7-beta-x64/raw/HEAD/qt-installer-noninteractive.qs
// https://bitbucket.org/xiannox/trusty-qt5.7-beta-x64
// modified to depend on envar
//
// $ cat > /tmp/qt/script.qs
// ...
// ^D

function Controller() {
    installer.autoRejectMessageBoxes();
    installer.installationFinished.connect(function() {
        gui.clickButton(buttons.NextButton, 3000);
    });
}

Controller.prototype.WelcomePageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.CredentialsPageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.IntroductionPageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.TargetDirectoryPageCallback = function() {
    gui.currentPageWidget().TargetDirectoryLineEdit.setText("/opt/qt");
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.ComponentSelectionPageCallback = function() {
    var widget = gui.currentPageWidget();
    // http://doc.qt.io/qtinstallerframework/scripting-installer.html#environmentVariable-method
    var QTCOMPONENTS = installer.environmentVariable("QTCOMPONENTS") || "gcc_64";
    var QT = installer.environmentVariable("QT");
    if (!QT) {
        throw new Error("No QT environment variable set.");
    }
    var components = QTCOMPONENTS.split(",").filter(function truthy(x) { return !!x; });
    var component = 'TBA';
    var prefix = "qt.qt" + QT.split('.')[0] + "." + QT.replace(/\./g, "");
    widget.deselectAll();
    console.log("ComponentSelectionPageCallback selecting components:");
    for (idx=0; idx < components.length; idx++) {
        component = prefix + '.' + components[idx];
        console.log('* ' + component);
        console.log(widget.selectComponent(component));
    }
    // console.log('* ' + prefix);
    // widget.selectComponent(prefix);
    // console.log('* qt.tools');
    // widget.selectComponent('qt.tools');
    console.log("Done.");
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.LicenseAgreementPageCallback = function() {
    gui.currentPageWidget().AcceptLicenseRadioButton.setChecked(true);
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.StartMenuDirectoryPageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.ReadyForInstallationPageCallback = function() {
    gui.clickButton(buttons.NextButton, 3000);
}

Controller.prototype.FinishedPageCallback = function() {
    var checkBoxForm = gui.currentPageWidget().LaunchQtCreatorCheckBoxForm;
    if (checkBoxForm && checkBoxForm.launchQtCreatorCheckBox) {
        checkBoxForm.launchQtCreatorCheckBox.checked = false;
    }
    gui.clickButton(buttons.FinishButton, 3000);
}

// $ chmod +x /tmp/qt/installer.run && xvfb-run -e /dev/stderr /tmp/qt/installer.run --script /tmp/qt/script.qs --verbose
