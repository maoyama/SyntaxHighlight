//
//  Highlighter.swift
//  SyntaxHighlight
//
//  Created by Makoto Aoyama on 2020/09/21.
//  Copyright © 2020 dev.aoyama. All rights reserved.
//

import Foundation
import TMSyntax

typealias Grammar = TMSyntax.Grammar

public struct Highlighter {
    var string: String
    var theme: Theme
    var grammer: Grammar

    public func styledStrings() throws -> [(String, ScopeStyle?)] {
        var styledStrings: [(String, ScopeStyle?)] = []
        let parser = self.parser()
        while !parser.isAtEnd {
            guard let currentLine = parser.currentLine else { continue }
            let parsed = try parser.parseLine()
            let parsedStyles = parsed.map { (token) -> (String, ScopeStyle?) in
                var string = String(currentLine[token.range])
                if parsed.last == token {
                    string += "\n"
                }
                let style = theme.selectScopeStyle(for: token)
                return (string, style)
            }
            styledStrings += parsedStyles
        }
        return styledStrings
    }

    func parser() -> Parser {
        Parser(string: string, grammar: grammer)
    }
}

extension Theme {
    func selectScopeStyle(for token: TMSyntax.Token) -> ScopeStyle? {
        var scopePath = token.scopePath
        while !scopePath.items.isEmpty {
            if let style = selectScopeStyle(for: .init(from: scopePath.top)) {
                return style
            }
            scopePath.items.removeLast()
        }
        return nil
    }
}

extension ScopeName {
    init(from tmScopeName: TMSyntax.ScopeName) {
        self.init(string: tmScopeName.stringValue)
    }
}
