//
//  KnightAlgorithm.swift
//  ChessTest
//
//  Created by AZ on 22.02.2021.
//

import Foundation
import UIKit

class KnightAlgorithm: NSObject {
    
    
    // algorithm realization
    func calculatePathes(boardSize: Int, startPosition: CGPoint, knightPosition: CGPoint) -> [[CGPoint]] {
        var destinationPathes = [[CGPoint]]()
        // checking if the endPoint can be reached in 3 moves
        if getDistanceBetwen(firstPoint: startPosition, seconPoint: knightPosition) < 7 {
            
            // getting all possible knight moves from an existing point
            var posibleMoves1 = getPosibleMoves(boardSizeValue: boardSize, position: startPosition)
            
            // checking if the endPoint is reched in 1 move
            let posiblePathes1 = posibleMoves1.filter({ $0.x == knightPosition.x && $0.y == knightPosition.y })
            if posiblePathes1.count != 0 {
                destinationPathes.append(posiblePathes1)
            }
            
            // if the endPoint is reached the path is cut off for the next calculations
            posibleMoves1 = posibleMoves1.filter({ $0.x != knightPosition.x || $0.y != knightPosition.y})
            
            
            // repeating the same for the second and third moves
            posibleMoves1.forEach { (posibleMove) in
                
                if getDistanceBetwen(firstPoint: posibleMove, seconPoint: knightPosition) < 5 {
                    var posibleMoves2 = getPosibleMoves(boardSizeValue: boardSize, position: posibleMove)
                    let posiblePathes2 = posibleMoves2.filter({ $0.x == knightPosition.x && $0.y == knightPosition.y })
                    
                    posiblePathes2.forEach { (posiblePath) in
                        destinationPathes.append([posibleMove, posiblePath])
                    }
                    
                    posibleMoves2 = posibleMoves2.filter({ $0.x != knightPosition.x || $0.y != knightPosition.y})
                    
                    posibleMoves2.forEach { (posibleMove2) in
                        if getDistanceBetwen(firstPoint: posibleMove2, seconPoint: knightPosition) < 3 {
                            let posibleMoves3 = getPosibleMoves(boardSizeValue: boardSize, position: posibleMove2)
                            let posiblePathes3 = posibleMoves3.filter({ $0.x == knightPosition.x && $0.y == knightPosition.y })
                            
                            posiblePathes3.forEach { (posiblePath) in
                                destinationPathes.append([posibleMove, posibleMove2, posiblePath])
                            }
                        }
                    }
                }
            }
        }
        return destinationPathes
    }
    
    // checking distance 
    func getDistanceBetwen(firstPoint: CGPoint, seconPoint: CGPoint) -> Int {
        let xDistance = firstPoint.x - seconPoint.x
        let yDistance = firstPoint.y - seconPoint.y
        let distance = xDistance > yDistance ? xDistance : yDistance
        return Int(abs(distance))
    }
    
    // calculating possible knight moves taking board size and borders into consideration
    func getPosibleMoves(boardSizeValue: Int, position: CGPoint) -> [CGPoint] {
        var posibleMoves = [CGPoint]()
        posibleMoves.append(CGPoint(x: position.x - 1, y: position.y - 2))
        posibleMoves.append(CGPoint(x: position.x - 2, y: position.y - 1))
        posibleMoves.append(CGPoint(x: position.x - 2, y: position.y + 1))
        posibleMoves.append(CGPoint(x: position.x + 1, y: position.y - 2))
        posibleMoves.append(CGPoint(x: position.x - 1, y: position.y + 2))
        posibleMoves.append(CGPoint(x: position.x + 2, y: position.y - 1))
        posibleMoves.append(CGPoint(x: position.x + 1, y: position.y + 2))
        posibleMoves.append(CGPoint(x: position.x + 2, y: position.y + 1))
        
        posibleMoves.removeAll { (posiblePosition) -> Bool in
            let exp1 = posiblePosition.x < 0
            let exp2 = posiblePosition.y < 0
            let exp3 = Int(posiblePosition.x) >= boardSizeValue
            let exp4 = Int(posiblePosition.y) >= boardSizeValue
            return exp1 || exp2 || exp3 || exp4
        }
        return posibleMoves
    }
}
