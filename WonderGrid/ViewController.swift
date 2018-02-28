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

        
        //num of boxes per row
        let countViewRow = 15
        
        //handle for all size devices with view.width to get box correct box size
        let width = view.frame.width / CGFloat(countViewRow)
        
        //renderCells
        for j in 0...30 {
            //for vert
            for i in 0...countViewRow {
                //for horiz
                let cellView = UIView()
                //generate random color value for each box
                cellView.backgroundColor = randomColor()
                //set position for boxes, i/j must be cast to CGFloat to fix binary op compat
                cellView.frame = CGRect(x: CGFloat(i) * width, y: CGFloat(j) * width, width: width, height: width)
                cellView.layer.borderWidth = 0.5
                //expects a CGColor
                cellView.layer.borderColor = UIColor.black.cgColor
                view.addSubview(cellView)
            }
        }
        
        //setup gesture detection
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
        print(location)
    }
    
    fileprivate func randomColor() -> UIColor {
        // drand48 = Double rand from 0-1, cast to cgfloat
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
}

