//
//  ChessBiard.swift
//  ChessTest
//
//  Created by AZ on 18.02.2021.
//

import Foundation
import UIKit

protocol ChessBoardDeleagte: class {
    func startPoint(location: CGPoint)
    func endPoint(location: CGPoint)
}

class ChessBoard: UIView {
    
    weak var delegate: ChessBoardDeleagte?
    
    var startView: UILabel?
    var destinationView: UILabel?
    
    var cols: Int = 8
    var rows: Int = 8
    
    let originaX: CGFloat = 20
    let originaY: CGFloat = 20
    var cellSide: CGFloat = 20
    
    var lettersArray = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P"]
    
    override func draw(_ rect: CGRect) {
        cellSide = (self.frame.size.width - originaX * 2) / CGFloat(cols)
        drawGrid()
        self.setAxisValues()
    }
    
    func drawGrid() {
        let gridPath = UIBezierPath()
        
        for i in 0...rows {
            gridPath.move(to: CGPoint(x: originaX, y: originaY + CGFloat(i) * cellSide))
            gridPath.addLine(to: CGPoint(x: originaX + CGFloat(cols) * cellSide, y: originaY + CGFloat(i) * cellSide))

        }
        
        for i in 0...cols {
            gridPath.move(to: CGPoint(x: originaX + CGFloat(i) * cellSide, y: originaY ))
            gridPath.addLine(to: CGPoint(x: originaX + CGFloat(i) * cellSide, y: originaY + CGFloat(rows) * cellSide))
        }
        
        UIColor.lightGray.setStroke()
        gridPath.stroke()
    }
    
    func setAxisValues() {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        for i in 0...rows - 1 {
            let poslabel = UILabel()
            poslabel.frame.origin = CGPoint(x: originaY - 16, y:  (CGFloat(i) * cellSide) + originaY + cellSide / 2 )
            poslabel.font = UIFont(name: "Helvetica", size: 9)
            poslabel.text = lettersArray[(rows-1) - i]
            poslabel.sizeToFit()
            self.addSubview(poslabel)
        }
        
        for i in 0...cols - 1 {
            let poslabel = UILabel()
            poslabel.frame.origin = CGPoint(x:  (originaY + CGFloat(i) * cellSide) + cellSide / 2, y: (CGFloat(rows) * cellSide)  + originaY + 8 )
            poslabel.font = UIFont(name: "Helvetica", size: 9)
            poslabel.text = "\(i + 1)"
            
            poslabel.sizeToFit()
            self.addSubview(poslabel)
        }
    }
    
    func convertPositionToCessCoordinates(position: CGPoint) -> (x: String, y: String) {
        let xChessPos = Int(position.x + 1)
        let yChessPos = self.lettersArray[(rows - Int(position.y + 1))]
        return (x: "\(xChessPos)", y: "\(yChessPos)")
    }
    
    func getCellBy(_ point: CGPoint) -> CGPoint? {
        let xPos: Int = Int((point.x - originaX) / cellSide)
        let yPos: Int = Int((point.y - originaY) / cellSide)
        if xPos < rows && yPos < cols && point.x >= originaX && point.y >= originaY {
            return CGPoint(x: xPos, y: yPos)
        }
        return nil
    }
    
    func getFrameOf(_ cell: CGPoint) -> CGRect {
        
        let xPos: CGFloat = CGFloat((cell.x * cellSide) + originaX)
        let yPos: CGFloat = CGFloat((cell.y * cellSide) + originaY)
        let cellFrame = CGRect(x: xPos, y: yPos, width: cellSide, height: cellSide)
        return cellFrame
    }
    
    func setStartPoint(position: CGPoint) {
        if startView == nil {
            startView = UILabel(frame: self.getFrameOf(position))
            startView?.adjustsFontSizeToFitWidth = true
            startView?.numberOfLines = 2
            startView?.text = "Start Point"
            startView?.textAlignment = .center
            startView!.backgroundColor = UIColor.gray
            self.addSubview(startView!)
            self.delegate?.startPoint(location: position)
        }
    }
    
    func setDestinationPoint(position: CGPoint) {
        if destinationView == nil {
            destinationView = UILabel(frame: self.getFrameOf(position))
            destinationView?.adjustsFontSizeToFitWidth = true
            destinationView?.numberOfLines = 2
            destinationView?.textAlignment = .center
            destinationView?.text = "End Point"
            destinationView!.backgroundColor = UIColor.red
            self.addSubview(destinationView!)
            self.delegate?.endPoint(location: position)
        }
    }

    func clearPositions() {
        startView?.removeFromSuperview()
        startView = nil
        destinationView?.removeFromSuperview()
        destinationView = nil
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchLoc  = touches.first?.location(in: self)
        
        guard let curentCell = self.getCellBy(touchLoc!) else {
            return
        }
        if startView == nil {
            self.setStartPoint(position: curentCell)
        }else if destinationView == nil {
            self.setDestinationPoint(position: curentCell)
        }
    }
}
