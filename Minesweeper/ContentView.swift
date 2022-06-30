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
    let viewModel = GameViewModel()

    struct TileView: View {
        let row: Int
        let column: Int
        var tileViewModel: TileViewModel?
        
        mutating func setTile(newTile: Game.Tile) {
            tileViewModel = TileViewModel(tile: newTile)
        }
        
        
    //     TODO separate out the state into a Model and logic into a ViewModel.
    //     what do you see when flipping the tile? (handle game status update separately in ViewModel)
        
        var body: some View {
            ZStack{
                let square = Rectangle().aspectRatio(1, contentMode: .fit)
                if let existingTVM = tileViewModel {
                    if existingTVM.tile.isOpen {
                        square.foregroundColor(.white)
                        let content = existingTVM.content()
                        Text(content.text!)
                            .foregroundColor(Color(red: content.color!.r, green: content.color!.g, blue: content.color!.b))
                    }
                    else {
                        // grid has been initialized but tile hasn't been opened
                        square.foregroundColor(.blue)
                    }
                } else {
                    // grid hasn't been initialized
                    square.foregroundColor(.blue)
                }
            }
        }
    }



    
    var body: some View {
        VStack{
            Text(status.message)
            ForEach(0..<viewModel.game.rowCount) { rowIndex in
                HStack{
                    ForEach(0..<viewModel.game.colCount) { colIndex in
                        if let tile = viewModel.game.getTile(row: rowIndex, column: colIndex) {
                            TileView(
                                row: rowIndex,
                                column: colIndex,
                                tileViewModel: TileViewModel(tile: tile)
                            )
                                .onTapGesture(count: 1) {
                                    // TODO: to implement flagging, put .onTapGesture(count: 2) first. or use Long Tap
                                    viewModel.openTile(row: rowIndex, column: colIndex)
                                }
                        } else {
                            TileView(row: rowIndex, column: colIndex)
                                .onTapGesture(count: 1) {
                                    // TODO: take advantage of these different cases to decide here whether to initialize grid.
                                    viewModel.openTile(row: rowIndex, column: colIndex)
                                }
                        }
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
