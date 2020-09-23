//
//  SyntaxHighlightTests.swift
//  SyntaxHighlightTests
//
//  Created by Makoto Aoyama on 2020/09/20.
//  Copyright © 2020 dev.aoyama. All rights reserved.
//

import XCTest
@testable import SyntaxHighlight
@testable import TMSyntax
import SwiftUI

class HighlighterTests: XCTestCase {

    var grammar: Grammar!
    var theme: Theme!
    let string = """
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
// comment

"""

    override func setUpWithError() throws {
        let path = Bundle(for: HighlighterTests.self).path(forResource: "swift.tmLanguage", ofType: "json")!
        grammar = try Grammar(contentsOf: URL(fileURLWithPath: path))
        let themePath = Bundle(for: HighlighterTests.self).path(forResource: "Tomorrow", ofType: "tmTheme")!
        let plist = NSDictionary(contentsOfFile: themePath)! as [NSObject: AnyObject]
        theme = Theme(dictionary: plist as! [String : AnyObject])!
    }

    func testStyledStrings() throws {
        let highlighter = Highlighter(string: string, theme: theme, grammer: grammar)
        let styleds = try! highlighter.styledStrings()
        XCTAssertEqual(styleds[0].1!.foreground?.hex, "#8959A8")
        XCTAssertEqual(styleds[2].1!.foreground?.hex, "#8959A8")
        XCTAssertEqual(styleds[7].1!.foreground?.hex, "#718C00")
        XCTAssertEqual(styleds.last?.1!.foreground?.hex, "#8E908C")
        XCTAssertTrue(styleds.last!.1!.fontStyle.contains(.bold))
        XCTAssertTrue(styleds.last!.1!.fontStyle.contains(.italic))
        XCTAssertTrue(styleds.last!.1!.fontStyle.contains(.underline))
    }

    func testStyledStringsSame() throws {
        let highlighter = Highlighter(string: string, theme: theme, grammer: grammar)
        let styleds = try! highlighter.styledStrings()
        let string2 = styleds.reduce(into: "") { (result, styled) in
            result = result + styled.0
        }
        XCTAssertEqual(string, string2)
    }

    func testPerformanceParse() throws {
        let highlighter = Highlighter(string: string, theme: theme, grammer: grammar)
        self.measure {
            let _ = try! highlighter.styledStrings()
        }
    }

}
