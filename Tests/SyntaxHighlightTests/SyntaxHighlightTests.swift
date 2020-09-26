import XCTest
@testable import SyntaxHighlight

final class SyntaxHighlightTests: XCTestCase {
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
        let url = Bundle.module.url(forResource: "swift.tmLanguage", withExtension: "json")!
        grammar = try Grammar(contentsOf: url)
        let themeURL = Bundle.module.url(forResource: "Tomorrow", withExtension: "tmTheme")!
        theme = try Theme(contentsOf: themeURL)
    }

    func testStyledStrings() throws {
        let highlighter = Highlighter(string: string, theme: theme, grammer: grammar)
        let styleds = try! highlighter.styled()
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
        let styleds = try! highlighter.styled()
        let string2 = styleds.reduce(into: "") { (result, styled) in
            result = result + styled.0
        }
        XCTAssertEqual(string, string2)
    }

    func testPerformanceParse() throws {
        let highlighter = Highlighter(string: string, theme: theme, grammer: grammar)
        self.measure {
            let _ = try! highlighter.styled()
        }
    }

    static var allTests = [
        ("testStyledStrings", testStyledStrings),
    ]
}
