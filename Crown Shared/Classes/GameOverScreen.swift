//
//  GameOverScreen.swift
//  Crown
//
//  Created by Vladislav Andrushok on 26.06.2023.
//

import SwiftUI

struct GameOverScreen: View {
    
    var isloose: Bool
    var score: Int
    
    var body: some View {
        ZStack {
            Image(isloose ? "gameOverBackground" : "youWinBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image(isloose ? "gameOverText" : "youWinText" )
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 500)
                
                Spacer()
                
                ZStack {
                    Image("rectangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 414, height: 240)
                    
                    VStack {
                        Text("SCORE: \(score)")
                            .font(Font.custom("Gotham Pro", size: 23).weight(.regular))
                            .foregroundColor(.white)
                            .lineSpacing(22)
                            .multilineTextAlignment(.leading)
                        
                        Text("COINS")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.top, 1)
                        
                        Button(action: {
                            
                        }) {
                            Image("buttonGameOver")
                                .resizable()
                                .frame(width: 179, height: 54)
                                .aspectRatio(contentMode: .fit)
                                .overlay(
                                    Image("home")
                                        .resizable()
                                        .frame(width: 74, height: 22)
                                )
                            
                        }
                        
                        Button(action: {
                            
                        }) {
                            
                            Image("buttonGameOver")
                                .resizable()
                                .frame(width: 179, height: 54)
                                .aspectRatio(contentMode: .fit)
                                .overlay(
                                    Image("next")
                                        .resizable()
                                        .frame(width: 74, height: 22)
                                )
                        }
                    }
                }
                
            }
            .ignoresSafeArea(.all)
        }
    }
}


struct GameOverScreenView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverScreen(isloose: true, score: 123)
    }
}
