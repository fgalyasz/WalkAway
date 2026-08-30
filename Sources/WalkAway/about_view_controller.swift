import AppKit

final class AboutViewController: NSViewController {
    private let nameLabel = NSTextField(labelWithString: "WalkAway")
    private let versionLabel = NSTextField(labelWithString: "")
    private let descriptionLabel = NSTextField(wrappingLabelWithString: "")
    private let copyrightLabel = NSTextField(labelWithString: "© 2026 TenPrint Software")

    override func loadView() {
        view = NSView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabels()
        layoutContent()
    }
}

private extension AboutViewController {
    func configureLabels() {
        versionLabel.stringValue = "Version \(appVersionString())"
        descriptionLabel.stringValue =
            "Locks the screen when you walk away with your Watch or iPhone. Jobs keep running."
        styleTitleLabels()
        styleBodyLabels()
    }

    func styleTitleLabels() {
        nameLabel.font = NSFont.systemFont(ofSize: 22, weight: .bold)
        nameLabel.alignment = .center
        versionLabel.font = NSFont.systemFont(ofSize: 13)
        versionLabel.textColor = .secondaryLabelColor
        versionLabel.alignment = .center
    }

    func styleBodyLabels() {
        descriptionLabel.font = NSFont.systemFont(ofSize: 13)
        descriptionLabel.alignment = .center
        copyrightLabel.font = NSFont.systemFont(ofSize: 11)
        copyrightLabel.textColor = .secondaryLabelColor
        copyrightLabel.alignment = .center
    }

    func layoutContent() {
        [nameLabel, versionLabel, descriptionLabel, copyrightLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate(aboutConstraints())
    }

    func aboutConstraints() -> [NSLayoutConstraint] {
        titleConstraints() + bodyConstraints()
    }

    func titleConstraints() -> [NSLayoutConstraint] {
        [
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            versionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 6),
            versionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            versionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
    }

    func bodyConstraints() -> [NSLayoutConstraint] {
        [
            descriptionLabel.topAnchor.constraint(equalTo: versionLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            copyrightLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            copyrightLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            copyrightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
    }
}
