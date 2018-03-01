//
//  ViewController.swift
//  WonderGrid
//
//  Created by Chris Peragine on 2/27/18.
//  Copyright © 2018 Chris Peragine. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // becuase typing it 100 times drove me nuts
        let x = view.frame.width
        let y = view.frame.height
        
        let boxSizeCount = getBoxSizeCount(x: x, y: y)
        
        //num of boxes per col/row for loop
        let countViewCol = Int(boxSizeCount.1)
        let countViewRow = Int(boxSizeCount.2)
        
        //handle for all size devices with view.frame to get box correct box size
        let width = boxSizeCount.0
        let height = boxSizeCount.0
        
        //renderCells
        for j in 0...countViewRow { //for vert
            for i in 0...countViewCol { //for horiz
                let cellView = UIView()
                //generate random color value for each box
                cellView.backgroundColor = randomColor()
                //set position for boxes, i/j must be cast to CGFloat to fix binary op compat
                cellView.frame = CGRect(x: CGFloat(i) * width, y: CGFloat(j) * height, width: width, height: height)
                cellView.layer.borderWidth = 0.5
                //expects a CGColor
                cellView.layer.borderColor = UIColor.black.cgColor
                view.addSubview(cellView)
            }
        }
        
        //setup gesture detection
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
    }
    
    fileprivate func getBoxSizeCount (x: CGFloat, y: CGFloat) -> (CGFloat, CGFloat, CGFloat) {
        
        // compute number of row and cols, and box size for correct device view.frame
        let ratio = x / y
        let n = CGFloat(30)
        let ncols = sqrt(30 * ratio)
        let nrows = 30 / ncols
        
        //find correct height fill
        var nrows1 = ceil(nrows)
        var ncols1 = ceil(n / nrows1)
        while (nrows1 * ratio < ncols) {
            nrows1 += 1
            ncols1 = ceil(n / nrows1)
        }
        let cellSize1 = y / nrows1
        
        //find correct width fill
        var ncols2 = ceil(ncols)
        var nrows2 = ceil(n / ncols2)
        while (ncols2 < nrows2 * ratio) {
            ncols2 += 1
            nrows2 = ceil(n / ncols2)
        }
        let cellSize2 = x / ncols2
        
        //Find optimal size/counts conditional
        var nrow: CGFloat
        var ncol: CGFloat
        var cellSize: CGFloat
        if (cellSize1 < cellSize2) {
            nrow = nrows2
            ncol = ncols2
            cellSize = cellSize2
        } else {
            nrow = nrows1
            ncol = ncols1
            cellSize = cellSize1
        }
        
        return (cellSize, ncol, nrow)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        //get current location x/y
        let location = gesture.location(in: view)
        print(location)
        
        //find cell using width
        
        for subview in view.subviews {
            if subview.frame.contains(location) {
                subview.backgroundColor = .black
            }
        }
    }
    
    fileprivate func randomColor() -> UIColor {
        // drand48 = Double rand from 0-1, cast to cgfloat
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}

