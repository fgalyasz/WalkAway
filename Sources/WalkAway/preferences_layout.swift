import AppKit
import WalkAwayCore

extension PreferencesViewController {
    func layoutContent() {
        let views: [NSView] = [
            deviceLabel, devicePopup, deviceHint,
            rssiLabel, rssiValue, rssiSlider,
            delayLabel, delayValue, delaySlider,
            launchCheckbox, launchHint, privacyHint
        ]
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate(allConstraints())
    }

    func allConstraints() -> [NSLayoutConstraint] {
        deviceConstraints() + rssiConstraints() + delayConstraints() + launchConstraints()
    }

    func deviceConstraints() -> [NSLayoutConstraint] {
        [
            deviceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            deviceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            devicePopup.topAnchor.constraint(equalTo: deviceLabel.bottomAnchor, constant: 6),
            devicePopup.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            devicePopup.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deviceHint.topAnchor.constraint(equalTo: devicePopup.bottomAnchor, constant: 6),
            deviceHint.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deviceHint.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
    }

    func rssiConstraints() -> [NSLayoutConstraint] {
        [
            rssiLabel.topAnchor.constraint(equalTo: deviceHint.bottomAnchor, constant: 18),
            rssiLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rssiValue.centerYAnchor.constraint(equalTo: rssiLabel.centerYAnchor),
            rssiValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            rssiSlider.topAnchor.constraint(equalTo: rssiLabel.bottomAnchor, constant: 6),
            rssiSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rssiSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
    }

    func delayConstraints() -> [NSLayoutConstraint] {
        [
            delayLabel.topAnchor.constraint(equalTo: rssiSlider.bottomAnchor, constant: 18),
            delayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            delayValue.centerYAnchor.constraint(equalTo: delayLabel.centerYAnchor),
            delayValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            delaySlider.topAnchor.constraint(equalTo: delayLabel.bottomAnchor, constant: 6),
            delaySlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            delaySlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
    }

    func launchConstraints() -> [NSLayoutConstraint] {
        [
            launchCheckbox.topAnchor.constraint(equalTo: delaySlider.bottomAnchor, constant: 18),
            launchCheckbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            launchHint.topAnchor.constraint(equalTo: launchCheckbox.bottomAnchor, constant: 6),
            launchHint.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            launchHint.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            privacyHint.topAnchor.constraint(equalTo: launchHint.bottomAnchor, constant: 12),
            privacyHint.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            privacyHint.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
    }
}
