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
    var theme: Theme
    let parser: Parser
    let string: String

    init(string: String, theme: Theme, grammer: Grammar) {
        self.string = string
        self.theme = theme
        self.parser = .init(string: string, grammar: grammer)
    }

    func tokens() throws -> [Token] {
        let tmTokens = try parser.parseLine()
        return tmTokens.map { Token(from: $0, theme: theme) }
    }

    func styledStrings() throws -> [(String, ScopeStyle?)]  {
        return try tokens().map({ (token) -> (String, ScopeStyle?) in
            return (String(string[token.range]), token.style)
        })
    }
}

struct Token {
    var range: Range<String.Index>
    var style: ScopeStyle?

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
