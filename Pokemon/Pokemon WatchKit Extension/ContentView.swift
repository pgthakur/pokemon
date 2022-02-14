//
//  ContentView.swift
//  Pokemon WatchKit Extension
//
//  Created by prabhat gaurav on 10/02/22.
//

import SwiftUI

struct ContentView: View {
    @State private var question = "fire"
    
    @State private var title = "Fight to Win!"
    
    @State private var shouldWin = true
    
    @State private var level = 1
    
    @State private var gameOver = false
    
    @State private var currentTime = Date()
    
    @State private var startTime = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect()
    
    var time: String {
        let difference = currentTime.timeIntervalSince(startTime)
        return String(Int(difference))
    }
    
    func nextLevel() {
        
        if Bool.random(){
            title = "Fight to Win!"
            
            shouldWin = true
        }
        else {
            
            title = "Fight to Lose!"
            shouldWin = false
        }
        question = main.randomElement()!
    }
    
    let main = ["grass", "water", "fire", "Electric", "fighting", "steel"]
    
    func select(move: String) {
        
        if level == 10 {
            gameOver = true
            return
        }
        let solutions = [
            "fire": (win: "grass", lose:"water"),
            "grass": (win: "water", lose:"fire"),
            "water": (win: "fire", lose:"Electric"),
            "fighting": (win: "Electric", lose:"fire"),
            "steel": (win: "grass", lose:"Electric"),
            "Electric": (win: "water", lose:"fighting")
        ]
        
        guard let answer = solutions[question] else {
            fatalError("Error")
        }
        let isCorrect: Bool
        if shouldWin {
            isCorrect = move == answer.win
        }
        else {
            isCorrect = move == answer.lose
        }
        
        if isCorrect {
            level += 1
        }
        else {
            level -= 1
            if level < 1 { level = 1}
        }
        
        nextLevel()
        
    }
    
    var body: some View {
        ZStack{
            Image("ARENA")
                .resizable()
                .scaledToFit()
        VStack{
            if gameOver {
                VStack{
                    Text("You Win!")
                        .font(.subheadline)
                    Text("Your time: \(time) seconds")
                    
                    Button("Play Again"){
                        startTime = Date()
                        gameOver = false
                        level = 1
                        nextLevel()
                    }.buttonStyle(BorderedButtonStyle(tint: .blue))                }
            }
            else {
        VStack{
            Image(question)
                .resizable()
                .frame(width: 58, height: 58)
            Divider()
                .padding(.vertical)
            
            ScrollView(.horizontal){
                HStack{
                    
                    ForEach(main, id: \.self)
                    {
                        poke in
                        Button{
                            
                            select(move: poke)
                            
                        }
                        label: {
                            Image(poke)
                                .resizable()
                                .frame(width: 58, height:58)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            HStack{
                Text("\(level)/10")
                    .foregroundColor(.red)
                    .font(.title3)
                
                Spacer()
                Text("Time: \(time)")
                    .foregroundColor(.red)
                    .font(.title3)
            }
            .padding(.top)
        }.navigationTitle(title)
        .onAppear(perform: nextLevel)
        .onReceive(timer) {
            newTime in
            guard gameOver == false
            else {
                return
            }
            currentTime = newTime
        }
       }
      }
     }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
