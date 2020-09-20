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


class SyntaxHighlightTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let path = Bundle(for: SyntaxHighlightTests.self).path(forResource: "Swift.tmLanguage", ofType: nil)!
//        let g = try! Grammar(contentsOf: URL(fileURLWithPath: path))
//        let p = Parser(lines: ["// hello world"], grammar: g)
//        p.isTraceEnabled = true
//        let token = try p.parseLine()
//        print(token)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
