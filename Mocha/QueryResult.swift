//
//  QueryResult.swift
//  Mocha
//
//  Created by Zane Duncan on 9/7/25.
//


//
//  QueryResult.swift
//  Mocha
//

import Foundation

/// Represents the result of an AI-powered natural language query
struct QueryResult: Identifiable {
    let id = UUID()
    let answer: String
    let suggestedActions: [String]
}
