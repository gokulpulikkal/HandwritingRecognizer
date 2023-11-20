//
//  ViewController.swift
//  MNISTRecogniser
//
//  Created by Gokul P on 16/11/23.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var drawView: DrawView!
    var lastPoint: CGPoint?
    
    let predictionsIndexToValueMap: [Int:String] = [0: "0",
                                                    1: "One",
                                                    2: "Two",
                                                    3: "Three",
                                                    4: "Four",
                                                    5: "Five",
                                                    6: "Six",
                                                    7: "Seven",
                                                    8: "Eight",
                                                    9: "Nine",
                                                    10: "A",
                                                    11: "B",
                                                    12: "C",
                                                    13: "D",
                                                    14: "E",
                                                    15: "F",
                                                    16: "G",
                                                    17: "H",
                                                    18: "I",
                                                    19: "J",
                                                    20: "K",
                                                    21: "L",
                                                    22: "M",
                                                    23: "N",
                                                    24: "O",
                                                    25: "P",
                                                    26: "Q",
                                                    27: "R",
                                                    28: "S",
                                                    29: "T",
                                                    30: "U",
                                                    31: "V",
                                                    32: "W",
                                                    33: "X",
                                                    34: "Y",
                                                    35: "Z"]

    
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
                doPredictionWith(image: capturedImage)
            }
        default:
            lastPoint = nil
        }
    }
    
    @IBAction func onClearButtonPress(_ sender: Any) {
        drawView.clear()
        predictionLabel.text = ""
    }
    
    func doPredictionWith(image: UIImage) {
        do {
            guard let pixelBuffer = image.resizedAndGrayscalePixelBuffer(width: 28, height: 28) else {
                        print("Error: Unable to convert image to pixel buffer.")
                        return
            }
            let model = try SegmentationModel()
            let prediction = try model.prediction(input_1: pixelBuffer)
            let predictions = prediction.linear_14
            let predictionsArray = (0..<predictions.count).map { index in
                return predictions[index].floatValue
            }
            
            if let maxNumber = predictionsArray.max() {
                if let indexOfMax = predictionsArray.firstIndex(of: maxNumber) {
                    print("The maximum number is \(maxNumber) at index \(indexOfMax) and the value is \(predictionsIndexToValueMap[indexOfMax]!)")
                    let value = predictionsIndexToValueMap[indexOfMax]!
                    predictionLabel.text = "It is \(value)"
                } else {
                    print("Error: Unable to find the index of the maximum number.")
                }
            }
        } catch {
            print("some error has been thrown")
        }
    }
    
}

extension UIImage {
    // Resize and convert to grayscale
    func resizedAndGrayscalePixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        guard let cgImage = self.cgImage else {
            print("Error: Unable to get CGImage from UIImage.")
            return nil
        }

        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_OneComponent8, attrs, &pixelBuffer)

        guard status == kCVReturnSuccess else {
            print("Error: Unable to create pixel buffer.")
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)

        // Resize the image
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }
}
