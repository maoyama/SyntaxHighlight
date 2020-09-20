//
//  Theme.swift
//  SyntaxHighlight
//
//  Created by Makoto Aoyama on 2020/09/20.
//  Copyright © 2020 dev.aoyama. All rights reserved.
//

import Foundation

public struct Color {
    var hex: String
}

public enum Font {
    case italic, bold, underline
}

public struct ScopeStyle {
    var scope: [String]
    var foreground: Color?
    var background: Color?
    var fontStyle: Set<Font>

    init?(for dictionary: [String: AnyObject]) {
        guard let scope = dictionary["scope"] as? String else { return nil }
        guard let setting = dictionary["settings"] as? [String: AnyObject] else { return nil }

        self.scope = scope.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        if let value = setting["foreground"] as? String {
            foreground = Color(hex: value)
        }
        if let value = setting["background"] as? String {
            background = Color(hex: value)
        }
        fontStyle = []
        if let value = setting["fontStyle"] as? String {
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

    public let UUID: String
    public let name: String
    public let scopeStyles: [ScopeStyle]

    public init?(dictionary: [String: Any]) {
        guard let UUID = dictionary["uuid"] as? String,
            let name = dictionary["name"] as? String,
            let rawSettings = dictionary["settings"] as? [[String: AnyObject]]
            else { return nil }

        self.UUID = UUID
        self.name = name

        var scopeStyles: [ScopeStyle] = []
        for raw in rawSettings {
            if let scopeStyle = ScopeStyle(for: raw) {
                scopeStyles.append(scopeStyle)
            }
        }
        self.scopeStyles = scopeStyles
    }

    func scopeStyle(ForScope scope: String) -> ScopeStyle? {
        var components = scope.components(separatedBy: ".")
        for _ in scope.components(separatedBy: ".") {
            let theScope = components.joined(separator: ".")
            for scopeStyle in scopeStyles {
                if scopeStyle.scope.contains(theScope) {
                    return scopeStyle
                }
            }
            components = components.dropLast()
        }
        return nil
    }
}
