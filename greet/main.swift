//
//  main.swift
//  greet
//
//  Created by Nadia Barbosa on 5/4/20.
//  Copyright © 2020 nbsa. All rights reserved.
//

/**
 PURPOSE:
 
 A command line cool that just says Hello :)
 Additional configurations specified.
 
 USAGE: greet [--single-quote] [--double-quote] [--points <points>] [--name <name> ...] [<content> ...]
 */

import Foundation
import ArgumentParser

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
    init(_ description: String) {
        self.description = description
    }
}

struct Greeter: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "greet",
        abstract: "A customizable greeter",
        discussion: "Demonstrating how Swift Argument Parser Works",
        version: "0.0.1",
        shouldDisplay: true)
    
    /**
     Argument: Custom introductory text to add before the person to greet.
     Usage:
        greet "Hey there"
    */
    @Argument(parsing: .remaining,
              help: "Custom introduction text. Defaults to \"Hello\"")
    var content: [String]
    
    
    /**
     Option: Person to greet.
     Usage:
         --name="Daisy"
    */
     @Option(
         parsing: .upToNextOption, // Parse a big sentence
         help: "Name to greet. Defaults to \"World\"."
     )
     var name: [String]

    
    /**
     Flag: Quote style.
     
     Usage:
         --single-quote wraps output in single quotes
         --double-quote wraps output in double quotes
    */
    enum QuoteType: String, CaseIterable { // Required conformance for argument parser
        case singleQuote
        case doubleQuote
    }
    
    @Flag(help: "Add styled quote") // How to configure short names for multiple flag options?
    var quoteType: QuoteType?
         
    
    /**
     Option: Number of exclamation points to add after greeting is displayed
     Usage:
         --points=4
         -p 4
     
     Known issue: `-p=4` fails. See: https://github.com/apple/swift-argument-parser/issues/132
    */
    @Option(
        name: [.customShort("p"), .long],
        help: "Number of exclamation points. Defaults to 1. Max 5."
    )
    var points: Int?

    // Function definition ----------------------------------------------------
    
    func run() throws {

        guard (points ?? 1 > 0) else {
            throw RuntimeError("Point count must be postitive.")
        }

        guard (points ?? 1) <= 5 else {
            throw RuntimeError("Too many exclamation points. Max is 5.")
        }

        var quoteText = ""

        if let quoteType = quoteType {
            switch quoteType {
            case .singleQuote: quoteText = "'"
            case .doubleQuote: quoteText = "\""
            }
        }

        let pointString = String(repeating: "!", count: points ?? 1)

        let nameString = name.joined(separator: " ")
        let nameOutput = nameString.isEmpty ? "World" : nameString

        let greetString = content.joined(separator: " ")
        let greetOutput = greetString.isEmpty ? "Hello": greetString

        print("\(quoteText)\(greetOutput) \(nameOutput)\(pointString)\(quoteText)")
    }
}

Greeter.main()
