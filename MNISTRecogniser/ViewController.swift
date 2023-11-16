//
//  ViewController.swift
//  MNISTRecogniser
//
//  Created by Gokul P on 16/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var drawView: DrawView!
    var lastPoint: CGPoint?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        setupDrawView()
    }
    
    func setupDrawView() {
        drawView.backgroundColor = UIColor.black
        view.addSubview(drawView)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        drawView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let currentPoint = gestureRecognizer.location(in: drawView)
        switch gestureRecognizer.state {
        case .began:
            lastPoint = currentPoint
            drawView.path.move(to: currentPoint)
        case .changed:
            if let lastPoint = lastPoint {
                let midPoint = CGPoint(x: (currentPoint.x + lastPoint.x) / 2,
                                       y: (currentPoint.y + lastPoint.y) / 2)
                drawView.path.addQuadCurve(to: midPoint, controlPoint: lastPoint)
                drawView.setNeedsDisplay()
            }
            lastPoint = currentPoint
        case .ended:
            if let capturedImage = drawView.captureImage() {
                
            }
        default:
            lastPoint = nil
        }
    }
    
    @IBAction func onClearButtonPress(_ sender: Any) {
        drawView.clear()
    }
    
}

