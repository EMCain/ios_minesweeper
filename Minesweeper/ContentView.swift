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
}
var status: gameStatus = .active // TODO put this in model


struct Tile: View {
    // TODO separate out the state into a Model and logic into a ViewModel.
    let row: Int
    let col: Int
    let hasMine: Bool
    var nearbyMines: Int {
        // TODO implement (in Model logic)
        7
    }
    // what do you see when flipping the tile? (handle game status update separately in ViewModel)
    var content: Text {
        if hasMine {
            return Text("💣")
        }
        else if nearbyMines == 0 {
            return Text("")
        }
        else {
            let textColor: Color = .purple  // TODO set based on the number of mines nearby
            return Text("\(nearbyMines)")
                .foregroundColor(textColor)
                .fontWeight(.bold)
        }
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
            // TODO this really should only happen if it's not already open.
            isOpen.toggle()
            print("\(self)")
        }
    }
}


struct ContentView: View {
    var rows: Array<Array<Bool>> = [[false, false, true], [false, false, false]]
    
    func statusMessage(_ status: gameStatus) -> String {
        switch status {
        case .active:
            return "x mines found, y remaining"
        case .win:
            return "You win! 🎉"
        case .lose:
            return "You lose 😭"
        }
    }
    
    var body: some View {
        VStack{
            Text(statusMessage(status))
            ForEach(Array(rows.enumerated()), id: \.offset) { rowIndex, row in
                HStack{
                    ForEach(Array(row.enumerated()), id: \.offset) { colIndex, content in
                        Tile(row: rowIndex, col: colIndex, hasMine: content)
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
