//
//  ViewController.swift
//  CodeTesting
//
//  Created by Kira Weinberg on 8/17/18.
//  Copyright © 2018 Kira Weinberg. All rights reserved.
//

import UIKit

enum Piece {
    case Pawn
    case King
    case Queen
    case Bishop
    case Rook
    case Knight
    case Empty
}

class ViewController: UIViewController {
    
    @IBOutlet weak var TheButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var Board = [[piece]]()
        for _ in 0 ..< 8 //Makes Board the right size
        {
            var row = [piece]()
            for _ in 0 ..< 8
            {
                row.append(piece(type: Piece.Empty, side: "n"))
            }
            Board.append(row)
        }
        initializeBoard(board: Board)
        Board[3][4].set(type: Piece.Queen, side: "B")
        //Board[0][4].set(type: Piece.Rook, side: "W")
        removeHighlight(board: Board)
        draw(board: Board)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func posMoves(Board:[[piece]], x:Int, y:Int){ //calculates possible moves
        let type = Board[x][y].type
        let side = Board[x][y].side
        
        switch type {
        case Piece.Pawn: //Add in the weird backwards pawn
            if (side == "W"){
                if (Board[x][y+1].type==Piece.Empty){ //Doesnt deal with turning into a queen yet
                    Board[x][y+1].light()
                    if (y==1&&(Board[x][y+2].type==Piece.Empty)){ //Pawn hasnt moved and spot is open
                            Board[x][y+2].light()
                    }
                }
                if (x>=1){
                    if ((!(Board[x-1][y+1].type==Piece.Empty))&&(Board[x-1][y+1].side=="B")){ //there is a piece diagonally up left of the pawn
                        Board[x-1][y+1].light()
                    }
                }
                if (x<=7){
                    if ((!(Board[x+1][y+1].type==Piece.Empty))&&(Board[x+1][y+1].side=="B")){ // Piece is present and on B side
                        Board[x+1][y+1].light()
                    }
                }
            }
            break
        case Piece.Rook:
            rookieMistakeBish(board: Board, x: x, y: y, row: 0, col: 1)
            rookieMistakeBish(board: Board, x: x, y: y, row: 0, col: -1)
            rookieMistakeBish(board: Board, x: x, y: y, row: 1, col: 0)
            rookieMistakeBish(board: Board, x: x, y: y, row: -1, col: 0)
            break
        case Piece.Knight: //plz dont kill me
            arabianKnights(board: Board, x: x, y: y, row: -1, col: -2)
            arabianKnights(board: Board, x: x, y: y, row: -2, col: -1)
            arabianKnights(board: Board, x: x, y: y, row: 2, col: 1)
            arabianKnights(board: Board, x: x, y: y, row: -1, col: 2)
            arabianKnights(board: Board, x: x, y: y, row: 2, col: -1)
            arabianKnights(board: Board, x: x, y: y, row: 1, col: -2)
            arabianKnights(board: Board, x: x, y: y, row: -2, col: 1)
            arabianKnights(board: Board, x: x, y: y, row: 1, col: 2)
            break
        case Piece.Bishop://plz plz dont kill me
            rookieMistakeBish(board: Board, x: x, y: y, row: 1, col: 1)
            rookieMistakeBish(board: Board, x: x, y: y, row: 1, col: -1)
            rookieMistakeBish(board: Board, x: x, y: y, row: -1, col: 1)
            rookieMistakeBish(board: Board, x: x, y: y, row: -1, col: -1)
            break
        case Piece.Queen:

            rookieMistakeBish(board: Board, x: x, y: y, row: 0, col: 1)
            rookieMistakeBish(board: Board, x: x, y: y, row: 0, col: -1)
            rookieMistakeBish(board: Board, x: x, y: y, row: 1, col: 0)
            rookieMistakeBish(board: Board, x: x, y: y, row: -1, col: 0)
            
            rookieMistakeBish(board: Board, x: x, y: y, row: 1, col: 1)
            rookieMistakeBish(board: Board, x: x, y: y, row: 1, col: -1)
            rookieMistakeBish(board: Board, x: x, y: y, row: -1, col: 1)
            rookieMistakeBish(board: Board, x: x, y: y, row: -1, col: -1)
            
            break
        default:
            break
            
        }
    }
    
    func arabianKnights(board:[[piece]], x: Int, y: Int, row: Int, col: Int){ //lights all possible knight moves
        if (x+col>=0 && y+row>=0 && x+col<=7 && y+row<=7) && (board[x+col][y+row].type==Piece.Empty || !(board[x+col][y+row].side==board[x][y].side)){
            board[x+col][y+row].light();
        }
    }
    
    func rookieMistakeBish(board:[[piece]], x: Int, y: Int, row: Int, col: Int){ //lights possible rook or bishop moves
        for count in stride(from: 1, to: 8, by: 1){
            if (x+(col*count)>=0 && x+(col*count)<=7&&y+(row*count)>=0 && y+(row*count)<=7) {
                if (board[x+(col*count)][y+(row*count)].type==Piece.Empty) {
                    board[x+(col*count)][y+(row*count)].light()
                } else{
                    if !(board[x+(col*count)][y+(row*count)].side==board[x][y].side){
                        board[x+(col*count)][y+(row*count)].light()
                    }
                    break
                }
            } else {
                break
            }
        }
    }
    
    func removeHighlight(board:[[piece]]){ //write function to set all highlights to false
        for row in 0..<8
        {
            for col in 0..<8
            {
                board[row][col].unLight()
            }
        }
    }
    
    func initializeBoard(board: [[piece]]){
        
        board[0][0].set(type: Piece.Rook, side: "W")
        board[1][0].set(type: Piece.Knight, side: "W")
        board[2][0].set(type: Piece.Bishop, side: "W")
        board[3][0].set(type: Piece.Queen, side: "W")
        board[4][0].set(type: Piece.King, side: "W")
        board[5][0].set(type: Piece.Bishop, side: "W")
        board[6][0].set(type: Piece.Knight, side: "W")
        board[7][0].set(type: Piece.Rook, side: "W")
        
        board[0][7].set(type: Piece.Rook, side: "B")
        board[1][7].set(type: Piece.Knight, side: "B")
        board[2][7].set(type: Piece.Bishop, side: "B")
        board[3][7].set(type: Piece.Queen, side: "B")
        board[4][7].set(type: Piece.King, side: "B")
        board[5][7].set(type: Piece.Bishop, side: "B")
        board[6][7].set(type: Piece.Knight, side: "B")
        board[7][7].set(type: Piece.Rook, side: "B")
        
        for count in 0..<8
        {
            board[count][6].set(type: Piece.Pawn, side: "B")
            board[count][1].set(type: Piece.Pawn, side: "W")
        }
        
    }
    
    func valToLetter(Val: Piece) -> String{
        switch Val{
        case Piece.Pawn:
            return "p"
        case Piece.Rook:
            return "r"
        case Piece.Knight:
            return "n"
        case Piece.Bishop:
            return "b"
        case Piece.Queen:
            return "q"
        case Piece.King:
            return "k"
        default:
            return "_"
        }
    }
    
    func draw(board: [[piece]]){
        print ("  A B C D E F G H")
        var theRow: String
        for row in stride(from: 7, to: -1, by: -1)
        {
            theRow = String(row)+" "
            for letter in stride(from: 0, to: 8, by: 1)
            {
                if (board[letter][row].Highlight==true){
                    theRow+="H "
                } else {
                theRow+=valToLetter(Val: board[letter][row].type)+" "
                }
            }
            print(theRow)
        }
        print()
    }
}

class piece {
    
    var type: Piece
    var side: Character
    var Highlight: Bool

    init(type: Piece, side: Character) {
        self.type = type
        self.side = side
        self.Highlight = false
    }
    
    func set(type: Piece, side: Character){
            self.type = type
            self.side = side
    }
    
    func light(){
        
        self.Highlight = true
    }
    func unLight(){
        
        self.Highlight = false
    }
    

}

