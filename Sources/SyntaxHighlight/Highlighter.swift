//
//  Highlighter.swift
//  SyntaxHighlight
//
//  Created by Makoto Aoyama on 2020/09/21.
//  Copyright © 2020 dev.aoyama. All rights reserved.
//

import Foundation
import TMSyntax

public struct Highlighter {
    var theme: Theme
    var parser: Parser

    func highlight() throws -> [Token] {
        let tmTokens = try parser.parseLine()
        return tmTokens.compactMap { Token(for: $0, theme: theme) }
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
