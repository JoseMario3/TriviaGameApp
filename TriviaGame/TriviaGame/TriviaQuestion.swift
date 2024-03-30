//
//  TriviaQuestion.swift
//  TriviaGame
//
//  Created by Jose Folgar on 3/25/24.
//

import Foundation

struct CategoriesResponse: Codable {
    let trivia_categories: [Category]
}

struct Category: Codable, Identifiable {
    let id: Int
    let name: String
}

struct QuestionsResponse: Codable {
    let response_code: Int
    let results: [Question]
}

struct Question: Codable {    
    let question: String
    let correct_answer: String
    let type: String
    let incorrect_answers: [String]
}
