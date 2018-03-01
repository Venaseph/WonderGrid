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
        
        let boxSize = getBoxSize(x: x, y: y)
        
        //num of boxes per col/row
        let countViewCol = 15
        let countViewRow = 20
        //handle for all size devices with view.frame to get box correct box size
        let width = x / CGFloat(countViewCol)
        let height = y / CGFloat(countViewRow)
        
        //renderCells
        for j in 0...countViewRow {
            //for vert
            for i in 0...countViewCol {
                //for horiz
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
    
    func getBoxSize (x: CGFloat, y: CGFloat) -> CGFloat {
        
        // compute number of row and cols, and box size
        let ratio = x / y
        let ncols = sqrt(30 * ratio)
        let nrows = 30 / ncols
        
        //find correct height fill
        var nrows1 = ceil(nrows)
        var ncols1 = ceil(30 / nrows1)
        while (nrows1 * ratio < ncols) {
            nrows1 += 1
            ncols1 = ceil(30 / nrows1)
        }
        let cell_size1 = y / nrows1
        
        //find correct width fill
        let ncols2 = ceil(ncols)
        
        return 0
        
        
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

