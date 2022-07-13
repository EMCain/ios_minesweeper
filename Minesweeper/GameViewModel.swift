//
//  ViewModel.swift
//  Minesweeper
//
//  Created by Emily on 6/29/22.
//

import Foundation

final class GameViewModel: ObservableObject {
    // TODO let the user set this
    @Published var game: Game = Game(rowCount: 4, colCount: 4, mineCount: 3)
    
    func openTile(row: Int, column: Int) {
        print("game view model openTile")
//        if game.grid == nil {
//            game.initializeGrid(row, column)
//        }
        game.uncoverTile(row: row, column: column)
    }

}

final class TileViewModel: ObservableObject {
    let tile: Game.Tile
    
    init(tile: Game.Tile) {
        self.tile = tile
    }
    
    struct TileContent {
        let text: String
        let color: ColorValues
    }
    
    struct ColorValues {
        let r: Double
        let g: Double
        let b: Double
    }
    func mineCountColors(n: Int) -> ColorValues {
        let colors = [
            ColorValues(r: 39, g: 125, b: 161),
            ColorValues(r: 87, g: 117, b: 144),
            ColorValues(r: 114, g: 9, b: 183),
            ColorValues(r: 77, g: 144, b: 142),
            ColorValues(r: 248, g: 150, b: 30),
            ColorValues(r: 243, g: 114, b: 44),
            ColorValues(r: 249, g: 65, b: 68),
            ColorValues(r: 84, g: 11, b: 14)
        ]
        return colors[n-1]
    }
    
    func content() -> TileContent {
        if tile.hasMine {
            return TileContent(text: "💣", color: mineCountColors(n: 1))
        }
        if let nearby = tile.nearbyMines {
            if nearby == 0 {
                return TileContent(text: "", color: mineCountColors(n: 1))
            }
            else {
                return TileContent(text: String(nearby), color: mineCountColors(n: nearby))
            }
        }
        // TODO raise appropriate exception
        return TileContent(text: "this shouldn't happen", color: mineCountColors(n: 1))
    }
}
