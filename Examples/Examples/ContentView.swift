//
//  ContentView.swift
//  Examples
//
//  Created by Makoto Aoyama on 2020/09/24.
//

import SwiftUI
import SyntaxHighlight

struct ContentView: View {

    var theme: Theme
    var grammar: Grammar
    var string = """
        // JavaScript

        var global = "test";

        function foo() {
            var a = 1;

            if (a != null) {
                bar(a);
            }

            for (var i = 0; i < 10; i++) {
                // Comment
            }
        }

        function bar(abc) {
            var b = abc;

            while (true) {
                doSomething();
            }
        }

        """

    init() {
        let url = Bundle.main.url(forResource: "JavaScript.tmLanguage", withExtension: "json")!
        grammar = try! Grammar(contentsOf: url)
        let themeURL = Bundle.main.url(forResource: "Tomorrow", withExtension: "tmTheme")!
        theme = try! Theme(contentsOf: themeURL)
    }

    init(grammar: Grammar, string: String) {
        let themeURL = Bundle.main.url(forResource: "Tomorrow", withExtension: "tmTheme")!
        theme = try! Theme(contentsOf: themeURL)
        self.grammar = grammar
        self.string = string
    }

    var body: some View {
        Text(from: Highlighter(
                string: string,
                theme: theme,
                grammar: grammar))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var swiftGrammar: Grammar {
        let url = Bundle.main.url(forResource: "swift.tmLanguage", withExtension: "json")!
        return try! Grammar(contentsOf: url)
    }
    static var swift = """
        // Swift

        struct Player {
            var name: String
            var highScore: Int = 0
            var history: [Int] = []
        }

        extension Player {
            mutating func updateScore(_ newScore: Int) {
                history.append(newScore)
                if highScore < newScore {
                    print("A new high score for 🎉")
                    highScore = newScore
                }
            }
        }

        var player = Player("Tomas")
        player.updateScore(50)
        """
    static var previews: some View {
        Group {
            ContentView()
            ContentView(grammar: swiftGrammar, string: swift)
        }
    }
}
