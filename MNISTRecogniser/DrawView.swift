//
//  DrawView.swift
//  MNISTRecogniser
//
//  Created by Gokul P on 16/11/23.
//
import UIKit

class DrawView: UIView {

    var path = UIBezierPath()
    var strokeColor: UIColor = .white
    var strokeWidth: CGFloat = 10.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        self.isMultipleTouchEnabled = false
        self.backgroundColor = UIColor.clear
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.lineWidth = 10
    }

    override func draw(_ rect: CGRect) {
        strokeColor.setStroke()
        path.stroke()
    }

    func clear() {
        path.removeAllPoints()
        setNeedsDisplay()
    }
    
    func captureImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }

        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
}
