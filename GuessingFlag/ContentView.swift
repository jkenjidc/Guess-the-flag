//
//  ContentView.swift
//  GuessingFlag
//
//  Created by Justine Kenji Dela Cruz on 7/13/22.
//

import SwiftUI

struct ContentView: View {
    @State private var score = 0
    @State private var round = 1
    @State private var showingScore = false
    @State private var gameOver = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var animationAmount = Array(stride(from: 1.0, through: 3.0, by: 1.0))
    @State private var opacityAmount = Array(stride(from: 1.0, through: 1.3, by: 0.1))

    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var clickedButton = 0
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ],center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack (spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){number in
                        Button{
                            flagTapped(number)
                        }label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .rotation3DEffect(.degrees(animationAmount[number]), axis: (x: 0, y: 1, z: 0))
                                .opacity(opacityAmount[number])
                        }
                        
                    }
                    Text("Round \(round < 9 ? round : 8)/8")
                        .font(.title.bold())
                        .foregroundColor(.black)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text ("Score: \(score)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        }message: {
            Text("Your score is \(score)")
        }
        .alert("Game over",isPresented: $gameOver){
            Button("Reset", action: resetGame)
        }message: {
            Text("Final score: \(score)")
        }
    }
    func flagTapped(_ number: Int){
        if number == correctAnswer{
            scoreTitle = "Correct"
            score += 1
        }else{
            scoreTitle = "Wrong! thats the flag of \(countries[number])"
        }
        clickedButton = number
        withAnimation{
            animationAmount[number] += 360.0
            switch number {
            case 0:
                opacityAmount[1] -= 0.75
                animationAmount[1] -= 360.0
                opacityAmount[2] -= 0.75
                animationAmount[2] -= 360.0
            case 1:
                opacityAmount[0] -= 0.75
                animationAmount[0] -= 360.0
                opacityAmount[2] -= 0.75
                animationAmount[2] -= 360.0
            default:
                opacityAmount[0] -= 0.75
                animationAmount[0] -= 360.0
                opacityAmount[1] -= 0.75
                animationAmount[1] -= 360.0
            }

        }

        showingScore = true
    }
    
    func askQuestion(){
        countries.shuffle()
        opacityAmount = Array(stride(from: 1.0, through: 1.3, by: 0.1))
        correctAnswer = Int.random(in: 0...2)
        round += 1
        if round == 9 {
            gameOver = true
        }
    }
    
    func resetGame(){
        score = 0
        round = 1
        showingScore =  false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
