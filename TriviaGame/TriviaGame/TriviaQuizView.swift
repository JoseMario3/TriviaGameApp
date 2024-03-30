//
//  TriviaQuizView.swift
//  TriviaGame
//
//  Created by Jose Folgar on 3/25/24.
//

import SwiftUI

struct TriviaQuizView: View {
    
    let quiz: [Question]
    @State private var selectedAnswers: [String?]
    
    init(quiz: [Question]) {
        self.quiz = quiz
        self._selectedAnswers = State(initialValue: Array(repeating: nil, count: quiz.count))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(.blue)
                    .frame(height: 100)
                
                Text("Quiz Time")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .padding(.top, 50)
            }
            .edgesIgnoringSafeArea(.all)

            List {
                ForEach(quiz.indices, id: \.self) { idx in
                    VStack {
                        Text("\(quiz[idx].question)")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)


                        Picker("", selection: $selectedAnswers[idx]) {
                            let allAnswers = quiz[idx].incorrect_answers + [quiz[idx].correct_answer]
                            ForEach(allAnswers.shuffled(), id: \.self) { answer in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .fill(.pink)
                                    
                                    Text(answer)
                                        .tag(answer)
                                        .foregroundStyle(.white)
                                }
                                .frame(height: 30)
                                .padding(.top, 5)
                            }
                        }
                        .pickerStyle(.wheel)
                        .labelsHidden()
                    }
                    .padding(.vertical, 20)
                }
            }
            .padding(.top, -60)
            
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(Color.green)
                    .frame(width: 350, height: 60)
                    .shadow(color: .black, radius: 4, x: -2, y: 2)
                
                Button("Submit") {
                    for answer in selectedAnswers {
                        print(String(answer ?? "bruh"))
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
    }
}

#Preview {
    TriviaQuizView(quiz: [Question(question: "What da dog doin?", correct_answer: "cookin", type: "multiple", incorrect_answers: ["not cookin", "barkin", "sleepin"]), Question(question: "What's 4 + 4?", correct_answer: "Ateee", type: "multiple", incorrect_answers: ["8", "57", "-12"])])
}
