# HandwritingRecognizer for iOS

## Overview


https://github.com/gokulpulikkal/HandwritingRecognizer/assets/52960334/ea3c75d1-9d7b-4b1f-9c34-6616438ad88e


This iOS app allows users to draw characters and numbers on a drawing view, and a machine learning model will recognize the input, displaying the results just below the drawing area. The underlying model was created as part of the Intro to Machine Learning course and converted from PyTorch to CoreML using coremltools.

## Features

- **Drawing View:** Users can draw characters and numbers using the drawing view provided.
- **Real-time Recognition:** The machine learning model recognizes the input in real-time, updating the output below the drawing area.
- **EMNIST Model:** The model is trained on the EMNIST dataset, enabling it to recognize a wide range of characters and numbers.

## Installation

### Prerequisites

- Xcode 12 or later
- iOS 14.0 or later

### Steps

1. **Clone the repository:**

    ```bash
    git clone https://github.com/your-username/emnist-recognizer-ios.git
    ```

2. **Open the project in Xcode:**

    ```bash
    cd emnist-recognizer-ios
    open EMNISTRecognizer.xcodeproj
    ```

3. **Build and run the app on a simulator or a physical device.**

## Usage

1. Open the app on your iOS device.
2. Use the drawing view to draw characters or numbers.
3. The model will recognize the input in real-time, and the results will be displayed below the drawing area.

## Model Conversion

The model used in this app was originally trained using PyTorch. To convert it to CoreML, [coremltools](https://github.com/apple/coremltools) was employed. The conversion script can be found in the `model_conversion` directory.

### Conversion Steps

run the ipynb file in the 

`model_conversion` directory.

## Acknowledgments

- The EMNIST dataset: [NIST Website](https://www.nist.gov/itl/products-and-services/emnist-dataset)
- CoreMLTools: [CoreMLTools GitHub](https://github.com/apple/coremltools)





