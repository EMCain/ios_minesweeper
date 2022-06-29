//
//  GameModel.swift
//  Minesweeper
//
//  Created by Emily on 6/28/22.
//

import Foundation

struct Game {
    let rowCount: Int
    let colCount: Int
    let mineCount: Int
    
    var grid: [[Tile]]?  // TODO - set to private once I figure out how to set init error
    
    var allTiles: [Tile] {
        return Array(grid!.joined())
    }
    
    init(rowCount: Int, colCount: Int, mineCount: Int) {
        // TODO get rid of this once I can figure out how to initialize the grid on first tap.
        self.rowCount = rowCount
        self.colCount = colCount
        self.mineCount = mineCount
        
        self.initializeGrid(0, 0)
    }
    
    func getTile(row: Int, column: Int) -> Tile? {
        grid?[row][column]
    }
    
    mutating func initializeGrid(_ excludedTileRow: Int, _ excludedTileColumn: Int) {
        let hasMineArray: [Bool] = (0..<rowCount*colCount - 1).map({ $0 < mineCount }).shuffled()
        var hasMineIndex = 0
        grid = []

        for y in 0..<colCount {
            var tiles: [Tile] = []
            for x in 0..<rowCount {
                if (y == excludedTileColumn && x == excludedTileRow) {
                    /*
                     Make sure the first tile clicked doesn't have a mine.
                     Don't advance hasMineIndex because we aren't using one of the "cards" that determines if there's a mine.
                     */
                    tiles.append(Tile(
                        row: x,
                        column: y,
                        hasMine: false
                    ))
                } else {
                    tiles.append(Tile(
                        row: x,
                        column: y,
                        hasMine: hasMineArray[hasMineIndex]
                    ))
                    hasMineIndex += 1
                }
                    

            }
            grid!.append(tiles)
        }
        
        print("\(grid!)")
        
    }
    
    func getSurroundingTiles(row: Int, column: Int) -> [Tile] {
        var surroundingTiles: [Tile] = []
        // implement from JavaScript example; use if let to handle nonexistent tiles
        //     Board.prototype.getAdjacent = function(x, y){
        
        // get the range of values we are looking in; limit them to the edge of the grid.
        let yMin = max(row - 1, 0)
        let yMax = min(row + 1, colCount - 1)
        
        let xMin = max(column - 1, 0)
        let xMax = min(column + 1, rowCount - 1)
        
        // this also gets the tile we're looking at itself, but that doesn't cause any problems.
        for y in yMin..<yMax {
            for x in xMin..<xMax {
                let adjacentTile = grid![y][x]
                if adjacentTile.hasMine {
                    surroundingTiles.append(adjacentTile)
                }
            }
        }
        return surroundingTiles
    }

    
    mutating func uncoverTileAndCountMines (row: Int, column: Int) {
        if grid == nil {
            initializeGrid(row, column)
        }
        
        var centerTile: Tile = grid![column][row]
        if centerTile.hasMine {
            print("set game status to lose")
        }
        
        var count: Int = 0
        
        for nearbyTile in getSurroundingTiles(row: row, column: column) {
            if nearbyTile.hasMine {
                count += 1
            }
        }
        
        centerTile.nearbyMines = count
        centerTile.isOpen = true
        
    }
    
    struct Tile {
        let row: Int
        let column: Int
        let hasMine: Bool
        var nearbyMines: Int?
        var isOpen: Bool = false
    }

}
