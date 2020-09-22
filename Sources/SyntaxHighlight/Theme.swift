//
//  Theme.swift
//  SyntaxHighlight
//
//  Created by Makoto Aoyama on 2020/09/20.
//  Copyright © 2020 dev.aoyama. All rights reserved.
//

import Foundation

public struct ScopeName: Equatable {
    var string: String
    var components: [String] {
        string.components(separatedBy: ".")
    }

    public static func == (lhs: ScopeName, rhs: ScopeName) -> Bool {
        return lhs.string == rhs.string
    }

    func componentsScopeNames() -> [ScopeName] {
        var names: [ScopeName] = []
        var c = components
        for _ in components {
            names.append(ScopeName(string: c.joined(separator: ".")))
            c = c.dropLast()
        }
        return names
    }
}

public struct Color {
    var hex: String
    var hexIntValue: Int? {
        Int("0x"+hex)
    }
}

public enum Font {
    case italic, bold, underline
}

public struct ScopeStyle {
    var scope: [ScopeName]
    var foreground: Color?
    var background: Color?
    var fontStyle: Set<Font>

    init?(from dictionary: [String: AnyObject]) {
        guard let scope = dictionary["scope"] as? String else { return nil }
        guard let settings = dictionary["settings"] as? [String: AnyObject] else { return nil }

        self.scope = scope.components(separatedBy: ",").map { ScopeName(string: $0.trimmingCharacters(in: .whitespaces)) }
        if let value = settings["foreground"] as? String {
            foreground = Color(hex: value)
        }
        if let value = settings["background"] as? String {
            background = Color(hex: value)
        }
        fontStyle = []
        if let value = settings["fontStyle"] as? String {
            if value.contains("italic") {
                fontStyle.insert(.italic)
            }
            if value.contains("bold") {
                fontStyle.insert(.bold)
            }
            if value.contains("underline") {
                fontStyle.insert(.underline)
            }
        }
    }
}

public struct Theme {
    var UUID: String
    var name: String
    var scopeStyles: [ScopeStyle]

    public init?(dictionary: [String: Any]) {
        guard let UUID = dictionary["uuid"] as? String,
            let name = dictionary["name"] as? String,
            let rawSettings = dictionary["settings"] as? [[String: AnyObject]]
            else { return nil }

        self.UUID = UUID
        self.name = name

        var scopeStyles: [ScopeStyle] = []
        for raw in rawSettings {
            if let scopeStyle = ScopeStyle(from: raw) {
                scopeStyles.append(scopeStyle)
            }
        }
        self.scopeStyles = scopeStyles
    }

    func selectScopeStyle(with scopeName: ScopeName) -> ScopeStyle? {
        for theScopeName in scopeName.componentsScopeNames() {
            for scopeStyle in scopeStyles {
                if scopeStyle.scope.contains(theScopeName) {
                    return scopeStyle
                }
            }
        }
        return nil
    }
}
