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
    var parser: Parser
    var string: String

    init(from string: String, theme: Theme, grammer: Grammar) {
        self.string = string
        self.theme = theme
        self.parser = .init(string: string, grammar: grammer)
    }

    func tokens() throws -> [Token] {
        let tmTokens = try parser.parseLine()
        return tmTokens.compactMap { Token(for: $0, theme: theme) }
    }

    func styledStrings() throws -> [(String, ScopeStyle?)] {
        let tokens = try self.tokens()
        var styledStrings: [(String,  ScopeStyle?)] = [(string, nil)]
        for token in tokens {
            if let string = styledStrings.last?.0 {
                let assigned = assignToken(token, to: string)
                styledStrings = styledStrings + assigned
            }
        }
        return styledStrings
    }

    private func assignToken(_ token: Token, to string: String) -> [(String, ScopeStyle?)] {
        guard token.range.upperBound >= string.startIndex,
              token.range.lowerBound <= string.endIndex else {
                return []
        }
        var assigned: [(string: String, style: ScopeStyle?)] = []
        let first = String(string[string.startIndex..<token.range.lowerBound])
        assigned.append((string: first, style: nil))
        let middle = String(string[token.range])
        assigned.append((string: middle, style: token.style))
        let last = String(string[token.range.upperBound...string.endIndex])
        assigned.append((string: last, style: nil))
        return assigned
    }
}

struct Token {
    var range: Range<String.Index>
    var style: ScopeStyle

    init?(for token: TMSyntax.Token, theme: Theme) {
        range = token.range
        var scopePath = token.scopePath
        while !scopePath.items.isEmpty {
            if let style = theme.selectScopeStyle(with: .init(for: scopePath.top)) {
                self.style = style
                return
            }
            scopePath.pop()
        }
        return nil
    }
}

extension ScopeName {
    init(for tmScopeName: TMSyntax.ScopeName) {
        self.init(string: tmScopeName.stringValue)
    }
}
