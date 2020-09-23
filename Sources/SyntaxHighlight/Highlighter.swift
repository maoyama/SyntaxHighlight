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

    func styledStrings() throws -> [(String, ScopeStyle?)] {
        var styledStrings: [(String, ScopeStyle?)] = []
        let parser = self.parser()
        while !parser.isAtEnd {
            guard let currentLine = parser.currentLine else { continue }
            let parsed = try parser.parseLine()
            let parsedStyles = parsed.map { (tmToken) -> (String, ScopeStyle?) in
                let token  = Token(from: tmToken, theme: theme)
                if parsed.last == tmToken {
                    return (String(currentLine[token.range]) + "\n", token.style)
                }
                return (String(currentLine[token.range]), token.style)
            }
            styledStrings += parsedStyles
        }
        return styledStrings
    }

    func parser() -> Parser {
        Parser(string: string, grammar: grammer)
    }
}

struct Token {
    var range: Range<String.Index>
    var style: ScopeStyle?

    // これはThemeのextensionで
    init(from token: TMSyntax.Token, theme: Theme) {
        range = token.range
        var scopePath = token.scopePath
        while !scopePath.items.isEmpty {
            if let style = theme.selectScopeStyle(with: .init(from: scopePath.top)) {
                self.style = style
                return
            }
            scopePath.items.removeLast()
        }
        style = nil
    }
}

extension ScopeName {
    init(from tmScopeName: TMSyntax.ScopeName) {
        self.init(string: tmScopeName.stringValue)
    }
}
