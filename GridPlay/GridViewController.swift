//
//  ViewController.swift
//  GridPlay
//
//  Created by Wesley Matlock on 4/17/15.
//  Copyright (c) 2015 insoc.net. All rights reserved.
//

import UIKit

enum PlayerType: Int {
  case PlayerX, PlayerO
  
  func playerName() -> String {
    
    switch self {
    case .PlayerX:
      return "Player X"
    case .PlayerO:
      return "Player O"
    }
  }
}

let NUMBER_CELL_PER_ROW = 40
let WINNER_COUNT = 4

class GridViewController: UIViewController {

  var currentTurn: PlayerType!
  var scroller: UIScrollView!
  var board: UIView!
  var cells = [[GridCellView]]()
  var optionView: OptionsView!
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
  
    let fullWidth = view.frame.size.width
    let fullHeight = view.frame.size.height
    
    scroller = UIScrollView(frame: CGRect(x: 0, y: 20, width: fullWidth, height: fullHeight))
    view.addSubview(scroller)

    scroller.contentSize = CGSize(width: NUMBER_CELL_PER_ROW * 50, height: NUMBER_CELL_PER_ROW * 50)
    
    var startingScrollArea = CGRect(x: NUMBER_CELL_PER_ROW * 10 - Int(fullWidth) / 2, y: NUMBER_CELL_PER_ROW * 10 - Int(fullHeight), width: Int(fullWidth), height: Int(fullHeight))
    
    scroller.scrollRectToVisible(startingScrollArea, animated: false)
    scroller.delegate = self
    scroller.minimumZoomScale = 0.5
    scroller.maximumZoomScale = 2.0
    
    var tapGesture = UITapGestureRecognizer(target: self, action:"cellTapped:")
    scroller.addGestureRecognizer(tapGesture)
    
    board = UIView(frame: CGRect(x: 0, y: 0, width: NUMBER_CELL_PER_ROW * 50, height: NUMBER_CELL_PER_ROW * 50))
    scroller.addSubview(board)
    
    let statusBarBackground = UIView(frame: CGRect(x: 0, y: fullHeight - 60, width: fullWidth, height: 20))
    statusBarBackground.backgroundColor = MainTheme.baseBackgroundColor
    view.addSubview(statusBarBackground)
    view.backgroundColor = MainTheme.baseBackgroundColor

    setupGridCells()
    setupOptionView()

    currentTurn = .PlayerX
  }

  func setupGridCells() {

    for var i = 0;  i < NUMBER_CELL_PER_ROW; i++ {
      var innerArray = [GridCellView]()
      
      for var j = 0;  j < NUMBER_CELL_PER_ROW; j++ {
        var cell = GridCellView(frame: CGRect(x: 50 * i, y: 50 * j, width: 50, height: 50))
        innerArray.append(cell)
        board.addSubview(cell)
      }
      cells.append(innerArray)
    }
  }
  
  func eraseGrid() {
    
    for gridArray in cells {
      for cell in gridArray {
        cell.setEmptyCell()
      }
    }
  }
  
  
  //MARK: Player Moves
  func cellTapped(tapRecognizer: UITapGestureRecognizer) {
    println("Cell was tapped")
    let xVal = tapRecognizer.locationInView(board).x / 50
    let yVal  = tapRecognizer.locationInView(board).y / 50
    
    let tappedCell = cells[Int(xVal)][Int(yVal)]
    
    if tappedCell.getCellType() != .Empty {
      println("Empty cell was NOT pressed")
      return
    }
    
    if currentTurn == .PlayerX {
      tappedCell.setCellX()
      playerOTurn()
    } else {
      tappedCell.setCellO()
      playerXTurn()
    }
    
    checkForWinWithX(Int(xVal), y: Int(yVal))
    
  }
  
  func playerXTurn() {
    currentTurn = .PlayerX
    optionView.setCurrentPlayerAsX()
  }
  
  func playerOTurn() {
    currentTurn = .PlayerO
    optionView.setCurrentPlayerAsO()
  }
  
  func checkForWinWithX(x: Int, y: Int) {
    
    var verticalCount = topCountWithX(x, y: y) + bottomCountWithX(x, y: y)
    var horizontalCount = leftCountWithX(x, y: y) + rightCountWithX(x, y: y)
    var northEastCount = topNorthEastCountWithX(x, y: y) + bottomNorthEastCountWithX(x, y: y)
    var southEastCount = topSouthEastCountWithX(x, y: y) + bottomSouthEastCountWithX(x, y: y)

    if verticalCount >= WINNER_COUNT || horizontalCount >= WINNER_COUNT ||
      northEastCount >= WINNER_COUNT || southEastCount >= WINNER_COUNT {
      
        showWinner()
    }
    
  }
  
  //MARK: Cell Count Methods.
  func cellTypeForCallAt(x: Int, y: Int) -> CellType {
    if x < 0 || y < 0 || x >= cells.count || y >= cells[x].count {
      return .Empty
    } else {
      return cells[x][y].getCellType()
    }
  }
  
  func topCountWithX(x: Int, y: Int) -> Int {
    var count = 0
    var newY = y
    var type = cellTypeForCallAt(x, y: y)
    while type == cellTypeForCallAt(x, y: newY-1) {
      count++
      newY--
    }
    println("There are \(count) top")
    return count
  }
  
  func bottomCountWithX(x: Int, y: Int) -> Int {
    var count = 0
    var newY = y
    var type = cellTypeForCallAt(x, y: y)
    while type == cellTypeForCallAt(x, y: newY+1) {
      count++
      newY++
    }
    println("There are \(count) bottom")
    return count
  }
  
  func leftCountWithX(x: Int, y: Int) -> Int {
    var count = 0
    var newX = x
    var type = cellTypeForCallAt(x, y: y)
    while type == cellTypeForCallAt(newX - 1, y: y) {
      count++
      newX--
    }
    println("There are \(count) left")
    return count
  }
  
  func rightCountWithX(x: Int, y: Int) -> Int {
    var count = 0
    var newX = x
    var type = cellTypeForCallAt(x, y: y)
    while type == cellTypeForCallAt(newX + 1, y: y) {
      count++
      newX++
    }
    println("There are \(count) right")
    return count
  }

  func topNorthEastCountWithX(x: Int, y: Int) -> Int {
    var count = 0
    var newX = x
    var newY = y
    var type = cellTypeForCallAt(x, y: y)
    while type == cellTypeForCallAt(newX + 1, y: newY - 1) {
      count++
      newX++
      newY--
    }
    println("There are \(count) Top - NE")
    return count
  }
  
  func bottomNorthEastCountWithX(x: Int, y: Int) -> Int {
    var count = 0
    var newX = x
    var newY = y
    var type = cellTypeForCallAt(x, y: y)
    while type == cellTypeForCallAt(newX - 1, y: newY + 1) {
      count++
      newX--
      newY++
    }
    println("There are \(count) Bottom - NE")
    return count
  }
  
  func topSouthEastCountWithX(x: Int, y: Int) -> Int {
    var count = 0
    var newX = x
    var newY = y
    var type = cellTypeForCallAt(x, y: y)
    while type == cellTypeForCallAt(newX - 1, y: newY - 1) {
      count++
      newX--
      newY--
    }
    println("There are \(count) Top - SE")
    return count
  }

  func bottomSouthEastCountWithX(x: Int, y: Int) -> Int {
    var count = 0
    var newX = x
    var newY = y
    var type = cellTypeForCallAt(x, y: y)
    while type == cellTypeForCallAt(newX + 1, y: newY + 1) {
      count++
      newX++
      newY++
    }
    println("There are \(count) Bottom - SE")
    return count
  }
  
}

//MARK: Scrollview Delegate
extension GridViewController: UIScrollViewDelegate {

  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return scroller.subviews[0] as? UIView
    
  }
  
}

//MARK: AlertViewDelegate
extension GridViewController: UIAlertViewDelegate {
  
  func showWinner() {
    println("Winner, Winner, Chicken Dinner!")
    var winningPlayer:String
    
    if currentTurn == .PlayerX {
      winningPlayer = "Player O"
    } else {
      winningPlayer = "Player X"
    }
    
    var winText = "Winner, Winner \(winningPlayer) Gets a chicken dinner!"
    let winAlert = UIAlertController(title: "Winner!", message: winText, preferredStyle: .Alert)
    let newGameAction = UIAlertAction(title: "New Game", style: .Default) { (action) -> Void in
        self.eraseGrid()
    }
    
    winAlert.addAction(newGameAction)
    presentViewController(winAlert, animated: true, completion: nil)
    eraseGrid()
    
  }
  
  func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
    if buttonIndex == 0 {
      eraseGrid()
    }
  }
  
}


//MARK: OptionView Delegate
extension GridViewController: OptionsDelegate {
  
  func setupOptionView() {
    
    let fullWidth = view.frame.size.width
    let fullHeight = view.frame.size.height

    optionView = OptionsView(frame: CGRect(x: 0, y: fullHeight - 60, width: fullWidth, height: 60))
    optionView.delegate = self
    optionView.setCurrentPlayerAsX()
    
    view.addSubview(optionView)
    
  }
  
  func goBack() {
    // Nothing yet..
  }
  
  func beginErase() {
    println("begin the address")
    var warnMessage = "Are you sure you want to clear the board?"
    var warnAlert = UIAlertController(title: "Erase Board", message: warnMessage, preferredStyle: .Alert)
   
    var confirmAction = UIAlertAction(title: "Confirm", style: .Destructive) { (action) -> Void in
      self.eraseGrid()
    }
    var cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    
    warnAlert.addAction(cancelAction)
    warnAlert.addAction(confirmAction)
    
    presentViewController(warnAlert, animated: true, completion: nil)
    
  }
  
}







