//
//  ContentView.swift
//  Minesweeper
//
//  Created by Emily on 6/27/22.
//

import SwiftUI

struct Tile: View {
    let row: Int
    let col: Int
    let content: String
    let squareSize: CGFloat = CGFloat(50.0)
    let isHidden: Bool = true
    var body: some View {
        ZStack{
            let square = Rectangle().aspectRatio(1, contentMode: .fit)
            if isHidden {
                square.foregroundColor(.blue)
            } else {
                square.foregroundColor(.white)
            }
            


            Text(content).font(.largeTitle)
        }

            
    }
}


struct ContentView: View {
    var rows: Array<Array<String>> = [["", "?", "⛳️"], ["", "2", "💣"]]
    
    var body: some View {
        VStack{
            ForEach(Array(rows.enumerated()), id: \.offset) { rowIndex, row in
                HStack{
                    ForEach(Array(row.enumerated()), id: \.offset) { colIndex, content in
                        Tile(row: rowIndex, col: colIndex, content: content)
                    }
                }
            }
        }
        .padding(10)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
