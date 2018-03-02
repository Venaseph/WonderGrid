//
//  ViewController.swift
//  WonderGrid
//
//  Created by Chris Peragine on 2/27/18.
//  Copyright © 2018 Chris Peragine. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    private var cell: CGFloat = 0
    private var cells = [String: UIView]() // Make Dic
    private var selectedCell: UIView?  // For tracking gest later
    private let sounds = [1331,1323,1325,1329,1321,1330,1324,1332]
    private var nextSound = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // becuase typing it 100 times drove me nuts
        let x = view.frame.width
        let y = view.frame.height
        
        //Find correct size for cells - file under reasons to get a comp sci degree
        let cellSizeCount = getCellSizeCount(x: x, y: y)
        print(cellSizeCount.0)
        print(cellSizeCount.1)
        print(cellSizeCount.2)
        
        // num of boxes per col/row for loop
        let countViewCol = Int(cellSizeCount.1)
        let countViewRow = Int(cellSizeCount.2)
        
        // handle for all size devices with view.frame to get box correct box size
        cell = cellSizeCount.0
//        if (cell.truncatingRemainder(dividingBy: y) != 0) {
//            header = y - (cell * CGFloat(countViewRow))
//        }
        
        // renderCells
        for j in 0...countViewRow { //for vert
            for i in 0...countViewCol { //for horiz
                let cellView = UIView()
                // generate random color value for each box
                cellView.backgroundColor = randomColor()
                // set position for boxes, i/j must be cast to CGFloat to fix binary op compat
                cellView.frame = CGRect(x: CGFloat(i) * cell, y: CGFloat(j) * cell, width: cell, height: cell)
                cellView.layer.borderWidth = 0.5
                // expects a CGColor
                cellView.layer.borderColor = UIColor.black.cgColor
                view.addSubview(cellView)
                
                //add to dic/map
                let key = "\(i)|\(j)"
                cells[key] = cellView
            }
        }
        
        // setup gesture detection
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
    }
    
//    fileprivate func getSizeCount2 (x: CGFloat, y: CGFloat) {
//
//    }
    
    fileprivate func getCellSizeCount (x: CGFloat, y: CGFloat) -> (CGFloat, CGFloat, CGFloat) {
        
        // compute number of row and cols, and box size for correct device view.frame off n
        let ratio = x / y
        let n = CGFloat(400)  //TODO set for specific devices
        let ncols = sqrt(n * ratio)
        let nrows = n / ncols
        
        // find best height fill
        var nrows1 = ceil(nrows)
        var ncols1 = ceil(n / nrows1)
        while (nrows1 * ratio < ncols) {
            nrows1 += 1
            ncols1 = ceil(n / nrows1)
        }
        let cellSize1 = y / nrows1
        
        // find best width fill
        var ncols2 = ceil(ncols)
        var nrows2 = ceil(n / ncols2)
        while (ncols2 < nrows2 * ratio) {
            ncols2 += 1
            nrows2 = ceil(n / ncols2)
        }
        let cellSize2 = x / ncols2
        
        //Find optimal size/counts conditional based on above
        var nrow: CGFloat
        var ncol: CGFloat
        var cellSize: CGFloat
        
        if (cellSize1 < cellSize2) {
            nrow = nrows1
            ncol = ncols1
            cellSize = cellSize1
        } else {
            nrow = nrows2
            ncol = ncols2
            cellSize = cellSize2
        }
        // Fun with Tuples
        return (cellSize, ncol, nrow)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        //get current location x/y conv
        let location = gesture.location(in: view)
        let i = Int(location.x / cell)
        let j = Int(location.y / cell)
//        print(i, j)
        
        let key = "\(i)|\(j)"
        guard let over = cells[key] else { return }
        
        if selectedCell != over {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                // return to scale value of 1
                self.selectedCell?.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
        
        // track selected cell
        selectedCell = over
        // bring to front
        view.bringSubview(toFront: over)
       
        
        // grow
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            over.layer.transform = CATransform3DMakeScale(3, 3, 3)
        }, completion: nil)
        
        //check for finger up
        if gesture.state == .ended {
            //rotate through sounds on release
            if (nextSound == 7) {
                nextSound = 0
            } else {
                nextSound += 1
            }
            AudioServicesPlaySystemSound(UInt32(sounds[nextSound]))
            
            // release 
            UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                over.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
        
    }
    
    fileprivate func randomColor() -> UIColor {
        // tried a couple different rands, nothing is less random than random, but this is random enough for a two year old
        let red = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let green = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let blue = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}

