//
//  GridCell.swift
//  GridPlay
//
//  Created by Wesley Matlock on 4/17/15.
//  Copyright (c) 2015 insoc.net. All rights reserved.
//

import UIKit

enum CellType: Int {
  case Empty, X, O
}

class GridCellView: UIView {
  
  var currentCellType = CellType.Empty
  let cellLabel =  UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = UIColor.whiteColor()
    layer.borderWidth = 2.0
    layer.borderColor = MainTheme.deepColor.CGColor
    
    cellLabel.textAlignment = .Center
    cellLabel.font = MainTheme.cellFont
    addSubview(cellLabel)
  }

  required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
  }
  
  func setEmptyCell() {
    currentCellType = .Empty
    cellLabel.text = ""
    cellLabel.textColor = UIColor.grayColor()
  }
  
  func setCellX() {
    currentCellType = .X
    cellLabel.text = "X"
    cellLabel.textColor = MainTheme.accentColor
  }
  
  func setCellO() {
    currentCellType = .O
    cellLabel.text = "O"
    cellLabel.textColor = MainTheme.neutralColor
  }
  
  func getCellType() -> CellType {
    return currentCellType
  }
  
}