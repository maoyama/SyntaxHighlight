//
//  Highlighter.swift
//  SyntaxHighlight
//
//  Created by Makoto Aoyama on 2020/09/21.
//  Copyright © 2020 dev.aoyama. All rights reserved.
//

import Foundation
import TMSyntax

public typealias Grammar = TMSyntax.Grammar

public struct Highlighter {
    public var string: String
    public var theme: Theme
    public var grammar: Grammar

    public init(string: String, theme: Theme, grammar: Grammar) {
        self.string = string
        self.theme = theme
        self.grammar = grammar
    }

    public func styled() throws -> [(String, Style?)] {
        var styledStrings: [(String, Style?)] = []
        let parser = self.parser()
        while !parser.isAtEnd {
            guard let currentLine = parser.currentLine else { continue }
            let parsed = try parser.parseLine()
            let parsedStyles = parsed.map { (token) -> (String, Style?) in
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
        Parser(string: string, grammar: grammar)
    }
}

extension Theme {
    func selectScopeStyle(for token: TMSyntax.Token) -> Style? {
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
