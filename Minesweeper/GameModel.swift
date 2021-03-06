//
//  GameModel.swift
//  Minesweeper
//
//  Created by Emily on 6/28/22.
//

import Foundation

struct Game {
    var rowCount: Int
    var colCount: Int
    var mineCount: Int
    
    var status: gameStatus = .active
    var currentOpenCount = 0
    var openCountToWin: Int
    
    init (rowCount: Int, colCount: Int, mineCount: Int){
        self.rowCount = rowCount
        self.colCount = colCount
        self.mineCount = mineCount
        
        openCountToWin = rowCount * colCount - mineCount
    }
    
    var grid: [[Tile]]? 
    
    var allTiles: [Tile] {
        return Array(grid!.joined())
    }
    
    func getTile(row: Int, column: Int) -> Tile? {
        grid?[row][column]
    }
    
    mutating func initializeGrid(_ excludedTileRow: Int, _ excludedTileColumn: Int) {
        /*
        Start by creating a "deck" of tiles that could have mines, and ones that actually do (value True).
        The number of "cards" is 1 less than the number of tiles, because first tile clicked is excluded.
         */
        let hasMineArray: [Bool] = (0..<rowCount*colCount - 1).map({ $0 < mineCount }).shuffled()
        var hasMineIndex = 0
        grid = []

        for y in 0..<rowCount {
            var tiles: [Tile] = []
            for x in 0..<colCount {
                if (x == excludedTileColumn && y == excludedTileRow) {
                    /*
                     Make sure the first tile clicked doesn't have a mine.
                     Don't advance hasMineIndex because we aren't using one of the "cards" that determines if there's a mine.
                     */
                    tiles.append(Tile(
                        row: y,
                        column: x,
                        hasMine: false
                    ))
                } else {
                tiles.append(Tile(
                    row: y,
                    column: x,
                    hasMine: hasMineArray[hasMineIndex]
                ))
                hasMineIndex += 1
                }
                    
            }
            grid!.append(tiles)
        }
    }
    
    private func getSurroundingTiles(row: Int, column: Int) -> [Tile] {
        var surroundingTiles: [Tile] = []
        // get the range of values we are looking in; limit them to the edge of the grid.
        let yMin = max(row - 1, 0)
        let yMax = min(row + 1, colCount - 1)
        
        let xMin = max(column - 1, 0)
        let xMax = min(column + 1, rowCount - 1)
        
        // this also gets the tile we're looking at itself, but that doesn't cause any problems.
        for y in yMin...yMax {
            for x in xMin...xMax {
                let adjacentTile = grid![y][x]
                surroundingTiles.append(adjacentTile)
            }
        }
        return surroundingTiles
    }

    
    mutating func uncoverTile (row: Int, column: Int) {
        var centerTile: Tile = grid![row][column]
        if centerTile.hasMine {
            status = .lose
        }
        
        var count: Int = 0
        
        let nearbyTiles = getSurroundingTiles(row: row, column: column)
        
        for nearbyTile in nearbyTiles {
            if nearbyTile.hasMine {
                count += 1
            }
        }
        
        centerTile.nearbyMines = count
        centerTile.isOpen = true
        
        currentOpenCount += 1
        if status == .active && currentOpenCount == openCountToWin {
            status = .win
        }
        
        grid![row][column] = centerTile
    }
    
    mutating func markTile (row: Int, column: Int) {
        var tile: Tile = grid![row][column]
        tile.isMarked.toggle()
        grid![row][column] = tile
    }
    
    struct Tile {
        let row: Int
        let column: Int
        let hasMine: Bool
        var nearbyMines: Int?
        var isOpen: Bool = false
        var isMarked: Bool = false
    }
    
    enum gameStatus {
        case active, win, lose
        var message: String {
            switch self {
            case .active:
                return "Tap spaces without mines\nLong-tap to flag mines"
            case .win:
                return "You win! ????"
            case .lose:
                return "You lose ????"
            }
        }
    }
}
