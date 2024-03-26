//
//  ContentView.swift
//  TriviaGame
//
//  Created by Jose Folgar on 3/24/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var categories: [Category] = []
    @State private var quiz: [Question] = []
    @State private var numQuestions: String = "3"
    @State private var difficulty: String = "easy"
    @State private var currCategory: String = "20"
    @State private var type: String = "multiple"
    @State private var duration: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(.blue)
                    .frame(height: 100)
                
                Text("Trivia Game")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .padding(.top, 50)
            }
            .edgesIgnoringSafeArea(.all)
            
            List {
                TextField("How many questions?", text: $numQuestions)
                    .onReceive(numQuestions.publisher.collect()) { chars in
                        let filtered = String(chars.filter { "0123456789".contains($0) })
                        if filtered != self.numQuestions {
                            self.numQuestions = filtered
                        }
                    }
                Picker("Difficulty", selection: $difficulty) {
                    Text("Easy").tag("easy")
                    Text("Medium").tag("medium")
                    Text("Hard").tag("hard")
                }
                .pickerStyle(.segmented)
                
                Picker("Select Category", selection: $currCategory) {
                    ForEach(categories) { category in
                        Text(category.name)
                            .tag(String(category.id))
                    }
                }
                
                Picker("Select Type", selection: $type) {
                    Text("Multiple Choice")
                        .tag("multiple")
                    Text("True / False")
                        .tag("boolean")
                }
                .pickerStyle(.segmented)
            }
            .padding(.top, -60)
            
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(Color.green)
                    .frame(width: 350, height: 60)
                    .shadow(color: .black, radius: 4, x: -2, y: 2)
                
                Button("Start Trivia") {
                    Task {
                        await fetchQuestions()
                    }
                }
                .frame(width: 350, height: 60)
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundStyle(.white)
            }
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .background(.blue)
        }
        .onAppear(perform: {
            Task {
                await fetchCategories()
            }
        })
    }
    
    private func fetchCategories() async {
        let url = URL(string: "https://opentdb.com/api_category.php")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let categoriesResponse = try JSONDecoder().decode(CategoriesResponse.self, from: data)
            let categories = categoriesResponse.trivia_categories
            self.categories = categories
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func fetchQuestions() async {
        let url = URL(string: "https://opentdb.com/api.php?amount=\(numQuestions)&difficulty=\(difficulty)&type=\(type)&category=\(currCategory)")!
                
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let questionsResponse = try JSONDecoder().decode(QuestionsResponse.self, from: data)
            let questions = questionsResponse.results
            print(questions)
            self.quiz = questions
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

#Preview {
    ContentView()
}
