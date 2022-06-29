//
//  ContentView.swift
//  Minesweeper
//
//  Created by Emily on 6/27/22.
//

import SwiftUI


// TODO put these in model
enum gameStatus {
    case active, win, lose
    var message: String {
        switch self {
        case .active:
            return "✅✅◻️ 2/3 found"  // TODO implement
        case .win:
            return "You win! 🎉"
        case .lose:
            return "You lose 😭"
        }
    }
}
var status: gameStatus = .active // TODO put this in model

struct ContentView: View {
    var game = Game(rowCount: 2, colCount: 2, mineCount: 1)
    

    struct TileView: View {
        let row: Int
        let column: Int
        var tile: Game.Tile?
        
        mutating func setTile(newTile: Game.Tile) {
            tile = newTile
        }
        
        
    //     TODO separate out the state into a Model and logic into a ViewModel.
    //     what do you see when flipping the tile? (handle game status update separately in ViewModel)
        
        //move this to ViewModel
        var content: Text? {
            if let existingTile = tile {
                
                if existingTile.hasMine {
                    return Text("💣")
                }
                if let nearby = existingTile.nearbyMines {
                    if nearby == 0 {
                        return nil
                    }
                    else {
                        let textColor: Color = .purple  // TODO set based on the number of mines nearby
                        return Text("\(nearby)") // Tile shouldn't be open if it doesn't have a nearbyMines count. TODO change to !nearbyMines
                            .foregroundColor(textColor)
                            .fontWeight(.bold)
                    }
                }
            }
            else {
                return nil
            }
            return Text("IDK")
        }
        
        @State var isOpen: Bool = false
        var body: some View {
            ZStack{
                let square = Rectangle().aspectRatio(1, contentMode: .fit)
                if isOpen {
                    square.foregroundColor(.white)
                    content.font(.largeTitle)
                } else {
                    square.foregroundColor(.blue)
                }
            } // TODO: to implement flagging, put .onTapGesture(count: 2) first. or use Long Tap
            .onTapGesture(count: 1) {
                isOpen.toggle()
                print("\(tile)")
            }
        }
    }



    
    var body: some View {
        VStack{
            Text(status.message)
            ForEach(0..<game.rowCount) { rowIndex in
                HStack{
                    ForEach(0..<game.colCount) { colIndex in
                        let tile = game.getTile(row: rowIndex, column: colIndex)
                        TileView(row: rowIndex, column: colIndex, tile: tile)
                        // TODO try putting the onTapGesture here to avoid the scope issue.
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
