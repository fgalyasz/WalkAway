import Foundation

public enum MenuPanelTrigger: Equatable {
    case menuDidClose
    case itemAction
}

public func shouldPresentStatusPanel(trigger: MenuPanelTrigger) -> Bool {
    trigger == .itemAction
}
