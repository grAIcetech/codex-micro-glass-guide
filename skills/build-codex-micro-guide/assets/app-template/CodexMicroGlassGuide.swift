import AppKit

private struct ThreadSlot {
    let id: String
    let shortTitle: String
    let detail: String
}

private final class GuideButton: NSButton {
    var onPress: (() -> Void)?
    private let bevelLayer = CAGradientLayer()
    private let innerRimLayer = CALayer()
    private let footShadowLayer = CAGradientLayer()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        target = self
        action = #selector(pressed)
        isBordered = false
        bezelStyle = .regularSquare
        wantsLayer = true
        layer?.cornerRadius = 16
        layer?.borderWidth = 1
        layer?.shadowColor = NSColor.black.cgColor
        layer?.shadowOpacity = 0.34
        layer?.shadowRadius = 8
        layer?.shadowOffset = CGSize(width: 0, height: -5)
        layer?.masksToBounds = false

        bevelLayer.cornerRadius = 16
        bevelLayer.startPoint = CGPoint(x: 0.22, y: 1)
        bevelLayer.endPoint = CGPoint(x: 0.78, y: 0)
        bevelLayer.locations = [0, 0.42, 1]
        layer?.insertSublayer(bevelLayer, at: 0)

        footShadowLayer.cornerRadius = 16
        footShadowLayer.startPoint = CGPoint(x: 0.5, y: 0.65)
        footShadowLayer.endPoint = CGPoint(x: 0.5, y: 0)
        footShadowLayer.locations = [0, 1]
        layer?.insertSublayer(footShadowLayer, above: bevelLayer)

        innerRimLayer.cornerRadius = 13
        innerRimLayer.borderWidth = 1
        innerRimLayer.shadowOffset = .zero
        layer?.insertSublayer(innerRimLayer, above: footShadowLayer)
        focusRingType = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func pressed() {
        onPress?()
    }

    func applyBevel(accent: NSColor, backlit: Bool) {
        layer?.backgroundColor = NSColor.clear.cgColor
        layer?.borderColor = NSColor.white.withAlphaComponent(backlit ? 0.58 : 0.42).cgColor

        bevelLayer.colors = [
            NSColor.white.withAlphaComponent(backlit ? 0.30 : 0.20).cgColor,
            accent.withAlphaComponent(backlit ? 0.25 : 0.12).cgColor,
            NSColor.black.withAlphaComponent(0.24).cgColor
        ]
        footShadowLayer.colors = [
            NSColor.clear.cgColor,
            NSColor.black.withAlphaComponent(backlit ? 0.20 : 0.28).cgColor
        ]

        innerRimLayer.borderColor = NSColor.white.withAlphaComponent(backlit ? 0.32 : 0.20).cgColor
        innerRimLayer.shadowColor = accent.cgColor
        innerRimLayer.shadowOpacity = backlit ? 0.75 : 0
        innerRimLayer.shadowRadius = backlit ? 9 : 0

        layer?.shadowColor = (backlit ? accent : NSColor.black).cgColor
        layer?.shadowOpacity = backlit ? 0.78 : 0.38
        layer?.shadowRadius = backlit ? 17 : 8
        layer?.shadowOffset = backlit ? .zero : CGSize(width: 0, height: -5)
    }

    override func layout() {
        super.layout()
        bevelLayer.frame = bounds
        footShadowLayer.frame = bounds
        innerRimLayer.frame = bounds.insetBy(dx: 3, dy: 3)
        layer?.shadowPath = CGPath(roundedRect: bounds.insetBy(dx: -1, dy: -1), cornerWidth: 17, cornerHeight: 17, transform: nil)
    }

    override func updateLayer() {
        super.updateLayer()
        layer?.transform = isHighlighted
            ? CATransform3DMakeScale(0.975, 0.975, 1)
            : CATransform3DIdentity
    }
}

private final class GuidePanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { false }
}

private final class GuideController: NSWindowController {
    private let detailLabel = NSTextField(labelWithString: "Click any tile for a plain-language reminder.")
    private weak var panelRef: NSPanel?

    private let threads: [ThreadSlot] = [
        ThreadSlot(
            id: "",
            shortTitle: "Recent task 1",
            detail: "Replace this sample with a recent Codex task."
        ),
        ThreadSlot(
            id: "",
            shortTitle: "Recent task 2",
            detail: "Replace this sample with a recent Codex task."
        ),
        ThreadSlot(
            id: "",
            shortTitle: "Recent task 3",
            detail: "Replace this sample with a recent Codex task."
        ),
        ThreadSlot(
            id: "",
            shortTitle: "Recent task 4",
            detail: "Replace this sample with a recent Codex task."
        ),
        ThreadSlot(
            id: "",
            shortTitle: "Recent task 5",
            detail: "Replace this sample with a recent Codex task."
        ),
        ThreadSlot(
            id: "",
            shortTitle: "Recent task 6",
            detail: "Replace this sample with a recent Codex task."
        )
    ]

    convenience init() {
        let panel = GuidePanel(
            contentRect: NSRect(x: 0, y: 0, width: 650, height: 840),
            styleMask: [.titled, .fullSizeContentView, .nonactivatingPanel, .resizable],
            backing: .buffered,
            defer: false
        )
        self.init(window: panel)
        panelRef = panel
        configure(panel)
    }

    private func configure(_ panel: NSPanel) {
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.appearance = NSAppearance(named: .darkAqua)
        panel.title = "Codex Micro Glass Guide"
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.standardWindowButton(.closeButton)?.isHidden = true
        panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
        panel.standardWindowButton(.zoomButton)?.isHidden = true
        panel.hasShadow = true
        panel.alphaValue = 0.96
        panel.isMovableByWindowBackground = true
        panel.minSize = NSSize(width: 560, height: 720)
        panel.maxSize = NSSize(width: 1400, height: 1200)
        panel.setFrameAutosaveName("Community.CodexMicroGlassGuide.frame")

        let root = NSView()
        root.frame = NSRect(origin: .zero, size: panel.frame.size)
        root.autoresizingMask = [.width, .height]
        root.wantsLayer = true
        root.layer?.backgroundColor = NSColor(calibratedRed: 0.52, green: 0.66, blue: 1.0, alpha: 0.035).cgColor

        if #available(macOS 26.0, *) {
            let liquidGlass = NSGlassEffectView(frame: root.frame)
            liquidGlass.autoresizingMask = [.width, .height]
            liquidGlass.cornerRadius = 30
            liquidGlass.style = .regular
            liquidGlass.tintColor = NSColor(calibratedRed: 0.10, green: 0.14, blue: 0.24, alpha: 0.14)
            liquidGlass.contentView = root
            panel.contentView = liquidGlass
        } else {
            let fallbackGlass = NSVisualEffectView(frame: root.frame)
            fallbackGlass.autoresizingMask = [.width, .height]
            fallbackGlass.material = .popover
            fallbackGlass.blendingMode = .behindWindow
            fallbackGlass.state = .active
            fallbackGlass.wantsLayer = true
            fallbackGlass.layer?.cornerRadius = 30
            fallbackGlass.layer?.borderWidth = 1
            fallbackGlass.layer?.borderColor = NSColor.white.withAlphaComponent(0.46).cgColor
            fallbackGlass.layer?.masksToBounds = true
            fallbackGlass.addSubview(root)
            panel.contentView = fallbackGlass
        }

        let stack = NSStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 11
        root.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: root.leadingAnchor, constant: 22),
            stack.trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -22),
            stack.topAnchor.constraint(equalTo: root.topAnchor, constant: 18),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: root.bottomAnchor, constant: -18)
        ])

        stack.addArrangedSubview(makeHeader())
        stack.addArrangedSubview(makeSectionLabel("WHITE DIAL + JOYSTICK  •  YOUR BUILT-IN OPTIONS"))
        stack.addArrangedSubview(makeAnalogControlsRow())
        stack.addArrangedSubview(makeSectionLabel("AGENT KEYS  •  YOUR 6 MOST RECENT TASKS"))
        stack.addArrangedSubview(makeAgentGrid())
        stack.addArrangedSubview(makeSectionLabel("COMMAND KEYS  •  YOUR SELECTED KEYCAPS"))
        stack.addArrangedSubview(makeCommandRows())
        stack.addArrangedSubview(makeSectionLabel("BOTTOM EDGE  •  LAYERS + CONNECTION"))
        stack.addArrangedSubview(makeBottomControlsRow())
        stack.addArrangedSubview(makeDetailStrip())
        stack.addArrangedSubview(makeFooter())

        for view in stack.arrangedSubviews {
            view.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        }

        if panel.frame.origin == .zero, let screen = NSScreen.main?.visibleFrame {
            let origin = NSPoint(
                x: screen.maxX - panel.frame.width - 26,
                y: screen.maxY - panel.frame.height - 26
            )
            panel.setFrameOrigin(origin)
        }
    }

    private func makeHeader() -> NSView {
        let row = NSStackView()
        row.orientation = .horizontal
        row.alignment = .centerY
        row.spacing = 12

        let orb = NSTextField(labelWithString: "✦")
        orb.alignment = .center
        orb.font = .systemFont(ofSize: 22, weight: .semibold)
        orb.textColor = NSColor(calibratedRed: 0.68, green: 0.82, blue: 1.0, alpha: 1)
        orb.wantsLayer = true
        orb.layer?.cornerRadius = 18
        orb.layer?.backgroundColor = NSColor(calibratedRed: 0.38, green: 0.48, blue: 0.95, alpha: 0.25).cgColor
        orb.widthAnchor.constraint(equalToConstant: 38).isActive = true
        orb.heightAnchor.constraint(equalToConstant: 38).isActive = true

        let titleStack = NSStackView()
        titleStack.orientation = .vertical
        titleStack.alignment = .leading
        titleStack.spacing = 1
        let title = NSTextField(labelWithString: "Codex Micro • glass guide")
        title.font = .systemFont(ofSize: 18, weight: .bold)
        title.textColor = .labelColor
        let subtitle = NSTextField(labelWithString: "drag the glass anywhere  ·  it stays above your apps")
        subtitle.font = .systemFont(ofSize: 11, weight: .medium)
        subtitle.textColor = .secondaryLabelColor
        titleStack.addArrangedSubview(title)
        titleStack.addArrangedSubview(subtitle)

        let source = makePill("RECENT × 6", color: NSColor.systemBlue)

        let close = NSButton(title: "×", target: self, action: #selector(closePanel))
        close.isBordered = false
        close.font = .systemFont(ofSize: 18, weight: .medium)
        close.contentTintColor = .secondaryLabelColor
        close.toolTip = "Close the guide"
        close.widthAnchor.constraint(equalToConstant: 28).isActive = true

        row.addArrangedSubview(orb)
        row.addArrangedSubview(titleStack)
        row.addArrangedSubview(NSView())
        row.addArrangedSubview(source)
        row.addArrangedSubview(close)
        row.heightAnchor.constraint(equalToConstant: 42).isActive = true
        return row
    }

    private func makeAgentGrid() -> NSView {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.spacing = 9

        let top = NSStackView()
        top.orientation = .horizontal
        top.spacing = 9
        top.distribution = .fillEqually

        let bottom = NSStackView()
        bottom.orientation = .horizontal
        bottom.spacing = 9
        bottom.distribution = .fillEqually

        for (index, thread) in threads.enumerated() {
            let button = makeTile(
                eyebrow: "AGENT \(index + 1)",
                title: thread.shortTitle,
                symbol: "message.fill",
                color: indexColor(index),
                height: 84,
                backlit: true
            )
            button.toolTip = "Open \(thread.detail)"
            button.onPress = { [weak self] in
                guard !thread.id.isEmpty else {
                    self?.detailLabel.stringValue = "Agent \(index + 1): sample tile — personalize it with a Codex task ID."
                    return
                }
                self?.detailLabel.stringValue = "Agent \(index + 1): \(thread.detail) Opening it in Codex…"
                guard let url = URL(string: "codex://threads/\(thread.id)") else { return }
                NSWorkspace.shared.open(url)
            }
            if index < 3 {
                top.addArrangedSubview(button)
            } else {
                bottom.addArrangedSubview(button)
            }
        }

        stack.addArrangedSubview(top)
        stack.addArrangedSubview(bottom)
        top.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        bottom.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        return stack
    }

    private func makeAnalogControlsRow() -> NSView {
        let row = NSStackView()
        row.orientation = .horizontal
        row.alignment = .top
        row.spacing = 10

        let dial = makeKnob()
        let joystick = makeJoystick()
        row.addArrangedSubview(dial)
        row.addArrangedSubview(joystick)
        dial.widthAnchor.constraint(equalTo: row.widthAnchor, multiplier: 0.61).isActive = true
        joystick.widthAnchor.constraint(equalTo: row.widthAnchor, multiplier: 0.37).isActive = true
        row.heightAnchor.constraint(equalToConstant: 94).isActive = true
        return row
    }

    private func makeKnob() -> NSView {
        let card = NSView()
        card.wantsLayer = true
        card.layer?.cornerRadius = 20
        card.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.105).cgColor
        card.layer?.borderWidth = 1
        card.layer?.borderColor = NSColor.white.withAlphaComponent(0.42).cgColor
        card.heightAnchor.constraint(equalToConstant: 94).isActive = true

        let knob = NSButton(title: "·", target: self, action: #selector(showKnob))
        knob.isBordered = false
        knob.font = .systemFont(ofSize: 28, weight: .black)
        knob.contentTintColor = NSColor(calibratedWhite: 0.34, alpha: 1)
        knob.wantsLayer = true
        knob.layer?.cornerRadius = 27
        knob.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.92).cgColor
        knob.layer?.borderWidth = 1.5
        knob.layer?.borderColor = NSColor.white.cgColor
        knob.layer?.shadowColor = NSColor.black.cgColor
        knob.layer?.shadowOpacity = 0.22
        knob.layer?.shadowRadius = 8
        knob.layer?.shadowOffset = CGSize(width: 0, height: -3)
        knob.toolTip = "Personalize the dial's left, right, click, and hold actions from the installed Codex Micro layout."
        knob.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(knob)

        let label = NSTextField(labelWithString: "WHITE DIAL\n↶ left action   ·   right action ↷\nclick action   ·   hold action")
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .labelColor
        label.alignment = .left
        label.maximumNumberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(label)

        NSLayoutConstraint.activate([
            knob.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            knob.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            knob.widthAnchor.constraint(equalToConstant: 54),
            knob.heightAnchor.constraint(equalToConstant: 54),
            label.leadingAnchor.constraint(equalTo: knob.trailingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])
        return card
    }

    private func makeJoystick() -> NSView {
        let card = NSView()
        card.wantsLayer = true
        card.layer?.cornerRadius = 20
        card.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.09).cgColor
        card.layer?.borderWidth = 1
        card.layer?.borderColor = NSColor.white.withAlphaComponent(0.40).cgColor
        card.heightAnchor.constraint(equalToConstant: 94).isActive = true

        let label = NSTextField(labelWithString: "↑ skill 1\n← skill 4   skill 2 →\n↓ skill 3")
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .labelColor
        label.alignment = .center
        label.maximumNumberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(label)

        let click = NSButton(title: "JOYSTICK", target: self, action: #selector(showJoystick))
        click.isBordered = false
        click.font = .monospacedSystemFont(ofSize: 9, weight: .bold)
        click.contentTintColor = NSColor.systemPurple
        click.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(click)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 6),
            label.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -6),
            label.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            click.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            click.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -7)
        ])
        return card
    }

    private func makeCommandRows() -> NSView {
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.spacing = 9

        let first = NSStackView()
        first.orientation = .horizontal
        first.spacing = 9
        first.distribution = .fillEqually
        first.addArrangedSubview(actionTile("APPS", "Skills", "square.grid.2x2.fill", .systemPurple,
            "Open Skills — your selected APPS keycap."))
        first.addArrangedSubview(actionTile("APPROVE", "Allow", "checkmark.circle.fill", .systemGreen,
            "Approve the current permission or action request."))
        first.addArrangedSubview(actionTile("REJECT", "Decline", "xmark.circle.fill", .systemRed,
            "Decline the current permission or action request."))
        first.addArrangedSubview(actionTile("FORK", "Split task", "arrow.triangle.branch", .systemOrange,
            "Fork the current task into a separate copy."))

        let second = NSStackView()
        second.orientation = .horizontal
        second.spacing = 9
        second.distribution = .fillEqually
        second.addArrangedSubview(actionTile("MIC", "Hold to talk", "mic.fill", .systemPink,
            "Hold this key while speaking; release when you are finished."))
        second.addArrangedSubview(actionTile("EMPTY", "Unassigned", "circle.dashed", .systemGray,
            "This physical key is intentionally unassigned right now."))
        second.addArrangedSubview(actionTile("CODEX", "Send", "paperplane.fill", .systemBlue,
            "Submit the message in the Codex composer."))

        let touch = NSView()
        touch.wantsLayer = true
        touch.layer?.cornerRadius = 14
        touch.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.08).cgColor
        touch.layer?.borderWidth = 1
        touch.layer?.borderColor = NSColor.white.withAlphaComponent(0.18).cgColor
        let status = NSTextField(labelWithString: "YOUR LAYOUT\n13 keys · personalized")
        status.alignment = .center
        status.maximumNumberOfLines = 2
        status.font = .monospacedSystemFont(ofSize: 9, weight: .semibold)
        status.textColor = .secondaryLabelColor
        status.translatesAutoresizingMaskIntoConstraints = false
        touch.addSubview(status)
        NSLayoutConstraint.activate([
            status.centerXAnchor.constraint(equalTo: touch.centerXAnchor),
            status.centerYAnchor.constraint(equalTo: touch.centerYAnchor)
        ])
        second.addArrangedSubview(touch)

        stack.addArrangedSubview(first)
        stack.addArrangedSubview(second)
        first.heightAnchor.constraint(equalToConstant: 76).isActive = true
        second.heightAnchor.constraint(equalToConstant: 76).isActive = true
        first.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        second.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        return stack
    }

    private func actionTile(_ eyebrow: String, _ title: String, _ symbol: String, _ color: NSColor, _ detail: String) -> NSView {
        let button = makeTile(eyebrow: eyebrow, title: title, symbol: symbol, color: color, height: 76)
        button.toolTip = detail
        button.onPress = { [weak self] in self?.detailLabel.stringValue = detail }
        return button
    }

    private func makeBottomControlsRow() -> NSView {
        let row = NSStackView()
        row.orientation = .horizontal
        row.spacing = 9
        row.distribution = .fillEqually

        let sensor = makeTile(
            eyebrow: "◉  TOUCH SENSOR",
            title: "Tap: next layer  ·  Hold 3 sec: connections",
            symbol: "hand.tap.fill",
            color: .systemCyan,
            height: 66
        )
        sensor.toolTip = "The glossy black circle is a touch sensor. Tap it to cycle layers. Hold it for 3 seconds to enter Bluetooth or wired connection mode."
        sensor.onPress = { [weak self] in
            self?.detailLabel.stringValue = "Black glass circle: tap = next layer · hold 3 sec = Bluetooth/wired connection mode."
        }

        let lights = makeTile(
            eyebrow: "●  ●  ●   LAYER LIGHTS",
            title: "Show which of 6 layers is active",
            symbol: "ellipsis",
            color: .systemYellow,
            height: 66
        )
        lights.toolTip = "The three LEDs tell you which programmable layer is active. The Micro supports up to 6 layers."
        lights.onPress = { [weak self] in
            self?.detailLabel.stringValue = "Three lights: they identify the active programmable layer — up to 6 layers total."
        }

        row.addArrangedSubview(sensor)
        row.addArrangedSubview(lights)
        row.heightAnchor.constraint(equalToConstant: 66).isActive = true
        return row
    }

    private func makeTile(eyebrow: String, title: String, symbol: String, color: NSColor, height: CGFloat, backlit: Bool = false) -> GuideButton {
        let button = GuideButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.applyBevel(accent: color, backlit: backlit)
        button.contentTintColor = .labelColor
        button.imagePosition = .imageLeading
        button.imageHugsTitle = true
        button.image = NSImage(systemSymbolName: symbol, accessibilityDescription: nil)
        button.image?.size = NSSize(width: 16, height: 16)
        button.attributedTitle = NSAttributedString(
            string: "\(eyebrow)\n\(title)",
            attributes: [
                .font: NSFont.systemFont(ofSize: 11, weight: .semibold),
                .foregroundColor: NSColor.labelColor,
                .paragraphStyle: centeredParagraph()
            ]
        )
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        return button
    }

    private func makeDetailStrip() -> NSView {
        let strip = NSVisualEffectView()
        strip.material = .popover
        strip.blendingMode = .withinWindow
        strip.state = .active
        strip.wantsLayer = true
        strip.layer?.cornerRadius = 13
        strip.heightAnchor.constraint(equalToConstant: 42).isActive = true

        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = .systemFont(ofSize: 11, weight: .medium)
        detailLabel.textColor = .secondaryLabelColor
        detailLabel.lineBreakMode = .byTruncatingTail
        strip.addSubview(detailLabel)
        NSLayoutConstraint.activate([
            detailLabel.leadingAnchor.constraint(equalTo: strip.leadingAnchor, constant: 14),
            detailLabel.trailingAnchor.constraint(equalTo: strip.trailingAnchor, constant: -14),
            detailLabel.centerYAnchor.constraint(equalTo: strip.centerYAnchor)
        ])
        return strip
    }

    private func makeFooter() -> NSView {
        let row = NSStackView()
        row.orientation = .horizontal
        row.alignment = .centerY
        row.spacing = 10

        let tip = NSTextField(labelWithString: "Blue tiles open tasks · other tiles teach only")
        tip.font = .systemFont(ofSize: 10, weight: .medium)
        tip.textColor = .tertiaryLabelColor

        let opacity = NSSlider(value: 0.96, minValue: 0.48, maxValue: 1.0, target: self, action: #selector(opacityChanged(_:)))
        opacity.widthAnchor.constraint(equalToConstant: 92).isActive = true
        opacity.toolTip = "Change glass opacity"
        let fade = NSTextField(labelWithString: "fade")
        fade.font = .monospacedSystemFont(ofSize: 9, weight: .semibold)
        fade.textColor = .secondaryLabelColor

        row.addArrangedSubview(tip)
        row.addArrangedSubview(NSView())
        row.addArrangedSubview(fade)
        row.addArrangedSubview(opacity)
        return row
    }

    private func makeSectionLabel(_ text: String) -> NSView {
        let label = NSTextField(labelWithString: text)
        label.font = .monospacedSystemFont(ofSize: 9, weight: .bold)
        label.textColor = .secondaryLabelColor
        label.heightAnchor.constraint(equalToConstant: 12).isActive = true
        return label
    }

    private func makePill(_ text: String, color: NSColor) -> NSView {
        let pill = NSTextField(labelWithString: text)
        pill.alignment = .center
        pill.font = .monospacedSystemFont(ofSize: 9, weight: .bold)
        pill.textColor = color
        pill.wantsLayer = true
        pill.layer?.cornerRadius = 10
        pill.layer?.backgroundColor = color.withAlphaComponent(0.13).cgColor
        pill.layer?.borderWidth = 1
        pill.layer?.borderColor = color.withAlphaComponent(0.35).cgColor
        pill.widthAnchor.constraint(equalToConstant: 78).isActive = true
        pill.heightAnchor.constraint(equalToConstant: 22).isActive = true
        return pill
    }

    private func centeredParagraph() -> NSParagraphStyle {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 2
        return paragraph
    }

    private func indexColor(_ index: Int) -> NSColor {
        let colors: [NSColor] = [
            .systemBlue, .systemTeal, .systemIndigo,
            .systemPurple, .systemPink, .systemOrange
        ]
        return colors[index % colors.count]
    }

    @objc private func closePanel() {
        panelRef?.close()
        NSApplication.shared.terminate(nil)
    }

    @objc private func opacityChanged(_ sender: NSSlider) {
        panelRef?.alphaValue = sender.doubleValue
    }

    @objc private func showKnob() {
        detailLabel.stringValue = "White dial: personalize turn-left, turn-right, click, and hold actions."
    }

    @objc private func showJoystick() {
        detailLabel.stringValue = "Joystick: personalize one Codex skill or action in each direction."
    }
}

private final class AppDelegate: NSObject, NSApplicationDelegate {
    private var controller: GuideController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        controller = GuideController()
        controller?.showWindow(nil)
        controller?.window?.orderFrontRegardless()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

let app = NSApplication.shared
private let delegate = AppDelegate()
app.delegate = delegate
app.run()
