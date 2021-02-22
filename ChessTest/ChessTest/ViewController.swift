//
//  ViewController.swift
//  ChessTest
//
//  Created by AZ on 18.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var chessBoard: ChessBoard!
    @IBOutlet weak var boardSize: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    
    var boardSizes = [(title: "6x6", value: 6), (title: "7x7", value: 7), (title: "8x8", value: 8), (title: "9x9", value: 9), (title: "10x10", value: 10), (title: "11x11", value: 11), (title: "12x12", value: 12), (title: "13x13", value: 13), (title: "14x14", value: 14), (title: "15x15", value: 15), (title: "16x16", value: 16)]
    
    private var startPoint: CGPoint?
    private var destinationPoint: CGPoint?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.chessBoard.cols = 6
        self.chessBoard.rows = 6
        self.chessBoard.delegate = self
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        boardSize.inputView = pickerView
    }
    
    @IBAction func clearButtonDidTap(_ sender: Any) {
        self.chessBoard.clearPositions()
        self.resultTextView.text = ""
        self.startPoint = nil
        self.destinationPoint = nil
    }
    
    @IBAction func calculateButtonDidTap(_ sender: Any) {
        self.resultTextView.text = ""
        
        guard let startPoint = self.startPoint, let endPoint = self.destinationPoint else {
            return
        }
        let pathes = KnightAlgorithm().calculatePathes(boardSize: self.chessBoard.cols, startPosition: startPoint, knightPosition: endPoint)
        if pathes.count > 0 {
            pathes.forEach { (fullPath) in
                fullPath.forEach { (path) in
                    let chessLoc = self.chessBoard.convertPositionToCessCoordinates(position: path)
                    self.resultTextView.text.append(" \n \(chessLoc.y)\(chessLoc.x)")
                }
                self.resultTextView.text.append("\n-------------------------------------")
            }
        }else {
            self.resultTextView.text = "Path not found"
        }
        
    }    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.boardSizes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let sizeItem = self.boardSizes[row]
        return sizeItem.title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.chessBoard.clearPositions()
        self.resultTextView.text = ""
        self.boardSize.text = self.boardSizes[row].title
        self.chessBoard.cols = self.boardSizes[row].value
        self.chessBoard.rows = self.boardSizes[row].value
        self.chessBoard.setNeedsDisplay()
    }
}

extension ViewController: ChessBoardDeleagte {
    func startPoint(location: CGPoint) {
        self.view.endEditing(false)
        self.startPoint = location
    }
    
    func endPoint(location: CGPoint) {
        self.view.endEditing(false)
        self.destinationPoint = location
    }
}
