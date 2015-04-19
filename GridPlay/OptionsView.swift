//
//  OptionsView.swift
//  GridPlay
//
//  Created by Wesley Matlock on 4/18/15.
//  Copyright (c) 2015 insoc.net. All rights reserved.
//

import UIKit

protocol OptionsDelegate {
  func beginErase()
  func goBack()
}

let EXPANDED_TITLE = "Options"
let COLLAPSED_TITLE = "Close"
let DEFAULT_PLAYER_TEXT = "Current Player: -"

class OptionsView: UIView {
  
  var moreButton = UIButton(frame: CGRect(x: 20, y: 10, width: 70, height: 44))
  var currentPlayerLabel = UILabel(frame: CGRect(x: 190, y: 8, width: 175, height: 44))
  
  var expanded = false
  var screenWidth = UIScreen.mainScreen().bounds.width
  var screenHeight = UIScreen.mainScreen().bounds.height
  
  var currentPlayerString = NSMutableAttributedString(string: DEFAULT_PLAYER_TEXT)
  
  var delegate: OptionsDelegate?

  required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = MainTheme.baseBackgroundColor
    currentPlayerString.addAttribute(NSForegroundColorAttributeName, value: MainTheme.deepColor, range: NSMakeRange(0, 16) )
    currentPlayerString.addAttribute(NSForegroundColorAttributeName, value: MainTheme.baseBackgroundColor, range: NSMakeRange(16, 1))
    
    moreButton.setTitle(EXPANDED_TITLE, forState: .Normal)
    moreButton.titleLabel?.font = MainTheme.buttonFont
    moreButton.tintColor = MainTheme.accentColor
    moreButton.titleLabel?.textAlignment = .Left
    moreButton.addTarget(self, action: "expand", forControlEvents: .TouchUpInside)
    addSubview(moreButton)
    
    currentPlayerLabel.attributedText = currentPlayerString
    currentPlayerLabel.font = MainTheme.labelFont
    addSubview(currentPlayerLabel)
  }
  
  func expand() {
    
    if expanded {
      
      UIView.animateWithDuration(0.7, animations: { () -> Void in
        self.frame = CGRect(x: 0, y: self.screenHeight - 60, width: self.screenWidth, height: 60)
        self.moreButton.setTitle(EXPANDED_TITLE, forState: .Normal)
      })
      
//      UIView.animateWithDuration(0.7, delay:0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: 0, animations: { () -> Void in
//        
//        self.frame = CGRect(x: 0, y: screenHeight - 60, width: screenWidth, height: 60)
//        moreButton.setTitle(EXPANDED_TITLE, forState: .Normal)
//
//      }, completion: nil)
//    
    }else {
      createRestartButton()

      frame = CGRect(x: 0, y: screenHeight - 60, width:screenWidth, height: screenWidth)
      
      UIView.animateWithDuration(0.7, animations: { () -> Void in
        self.frame = CGRect(x: 0, y: self.screenHeight / 2, width: self.screenWidth, height: self.screenHeight / 2)
        self.moreButton.setTitle(COLLAPSED_TITLE, forState: .Normal)
      })

    }
    
    expanded = !expanded
    
  }
  
  //MARK: Restart Game
  func createRestartButton() {
    var restartButton = UIButton(frame: CGRect(x: 20, y: 100, width: screenWidth - 40, height: 44))
    restartButton.setTitle("Restart Game", forState: .Normal)
    restartButton.titleLabel?.font = MainTheme.buttonFont
    restartButton.setTitleColor(UIColor.redColor(), forState: .Normal)
    restartButton.addTarget(self, action: "createRestartGame", forControlEvents: .TouchUpInside)
    addSubview(restartButton)
  }
  
  func createRestartGame() {
    delegate?.beginErase()
    expand()
    
  }
  
  func backButton() {
    var backButton = UIButton(frame: CGRect(x: 20, y: 150, width: screenWidth - 40, height: 44))
    backButton.setTitle("Close Game", forState: .Normal)
    backButton.titleLabel?.font = MainTheme.buttonFont
    backButton.setTitleColor(MainTheme.accentColor, forState: .Normal)
    backButton.addTarget(self, action: "closeGame", forControlEvents: .TouchUpInside)
    addSubview(backButton)
  }
  
  func closeGame() {
    delegate?.goBack()
  }
  
  //MARK: Set Player
  func setCurrentPlayerAsX() {
    println("Setting player X")
    currentPlayerString.replaceCharactersInRange(NSMakeRange(16, 1), withString: "X")
    currentPlayerString.addAttribute(NSForegroundColorAttributeName, value:UIColor.blackColor(), range: NSMakeRange(16, 1))
    currentPlayerLabel.attributedText = currentPlayerString
  }
  
  func setCurrentPlayerAsO() {
    
    println("sEtting Player Y")
    
    currentPlayerString.replaceCharactersInRange(NSMakeRange(16, 1), withString: "O")
    currentPlayerString.addAttribute(NSForegroundColorAttributeName, value: MainTheme.neutralColor, range: NSMakeRange(16, 1))
    currentPlayerLabel.attributedText = currentPlayerString
    
  }
  
}
