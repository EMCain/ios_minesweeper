//
//  ContentView.swift
//  Minesweeper
//
//  Created by Emily on 6/27/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = GameViewModel()

    struct TileView: View {
        let row: Int
        let column: Int
        var tileViewModel: TileViewModel?
        
        mutating func setTile(newTile: Game.Tile) {
            tileViewModel = TileViewModel(tile: newTile)
        }
        
        var body: some View {
            ZStack{
                let square = Rectangle().aspectRatio(1, contentMode: .fit)
                if let existingTVM = tileViewModel {
                    if existingTVM.tile.isOpen {
                        square.foregroundColor(.white)
                        let content = existingTVM.content()
                        Text(content.text)
                            .foregroundColor(Color(red: content.color.r/255.0, green: content.color.g/255.0, blue: content.color.b/255.0))
                    }
                    else if existingTVM.tile.isMarked{
                        square.foregroundColor(.red)
                        Text("🏁")
                    } else {
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
            Text(viewModel.game.status.message)
            ForEach(0..<viewModel.game.rowCount) { rowIndex in
                HStack{
                    ForEach(0..<viewModel.game.colCount) { colIndex in
                        if let tile = viewModel.game.getTile(row: rowIndex, column: colIndex) {
                            TileView(
                                row: rowIndex,
                                column: colIndex,
                                tileViewModel: TileViewModel(tile: tile)
                            )
                            

                            .simultaneousGesture(
                                LongPressGesture()
                                    .onEnded { _ in
                                        if viewModel.game.status == .active {
                                            viewModel.markTile(row: rowIndex, column: colIndex)
                                        }
                                    }
                            )
                            .highPriorityGesture(TapGesture()
                                .onEnded { _ in
                                if viewModel.game.status == .active && !viewModel.game.grid![rowIndex][colIndex].isMarked
                                    {
                                        viewModel.openTile(row: rowIndex, column: colIndex)
                                    }
                            })

//
//                                .onTapGesture(count: 1) {
//                                    if viewModel.game.status == .active {
//                                        // TODO: to implement flagging, put .onTapGesture(count: 2) first. or use Long Tap
//                                        viewModel.openTile(row: rowIndex, column: colIndex)
//                                    }
//
//                                }
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
            if viewModel.game.status == .active {
                Text("There are \(viewModel.game.mineCount) mines.")
                Text("\(viewModel.game.currentOpenCount) of \(viewModel.game.openCountToWin) safe tiles uncovered")
            } else {
                Button("Play Again", action: {
                    print("reset the game")
                })
                .buttonStyle(.bordered)
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
