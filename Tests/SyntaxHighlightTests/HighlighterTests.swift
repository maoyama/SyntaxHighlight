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

    override func setUpWithError() throws {
        let path = Bundle(for: HighlighterTests.self).path(forResource: "swift.tmLanguage", ofType: "json")!
        grammar = try Grammar(contentsOf: URL(fileURLWithPath: path))
        let themePath = Bundle(for: HighlighterTests.self).path(forResource: "Tomorrow", ofType: "tmTheme")!
        let plist = NSDictionary(contentsOfFile: themePath)! as [NSObject: AnyObject]
        theme = Theme(dictionary: plist as! [String : AnyObject])!
    }

    func testStyledStrings() throws {
        let string = "public struct ScopeName: Equatable {"
        let highlighter = Highlighter(string: string, theme: theme, grammer: grammar)
        let styleds = try! highlighter.styledStrings()
        XCTAssertEqual(styleds[0].1!.foreground?.hex, "#8959A8")
        XCTAssertEqual(styleds[2].1!.foreground?.hex, "#8959A8")
        XCTAssertEqual(styleds[7].1!.foreground?.hex, "#718C00")
    }

    func testStyledStringsSame() throws {
        let string = "public struct ScopeName: Equatable {"
        let highlighter = Highlighter(string: string, theme: theme, grammer: grammar)
        let styleds = try! highlighter.styledStrings()
        let string2 = styleds.reduce(into: "") { (result, styled) in
            result = result + styled.0
        }
        XCTAssertEqual(string, string2)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
