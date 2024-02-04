# ASL Recognition App
![App Icon](https://github.com/eddy10957/ASLRecognition/blob/main/ASLRecognition/Assets/180.png)
## Overview

This application, developed as part of a thesis project, focuses on the recognition of American Sign Language (ASL). It leverages various frameworks and libraries to achieve accurate hand pose recognition, contributing to a more inclusive communication experience.

## Technologies Used

- **Core ML**: Central to the implementation, serving as an interface for the machine learning model trained for hand pose recognition. Core ML enables fast and accurate on-device inferences, ensuring a smooth and responsive user experience.

- **ARKit**: Employed for augmented reality and hand pose detection, ARKit captures video from the camera, providing essential data for pose recognition. This Apple framework combines device motion tracking and camera scene capture, simplifying the creation of augmented reality experiences.

- **Vision Framework**: Utilized for hand pose detection through its VNDetectHumanHandPoseRequest module. Vision plays a crucial role in preprocessing and post-processing data, extracting hand keypoints for input to the machine learning model during the inference phase.

- **SwiftUI**: Chosen for building the application's user interface, SwiftUI offers a declarative and concise approach compared to UIKit. It is used to display model predictions and their associated confidence directly on the interface.

## Model Training

The machine learning model used in this application was personally trained using Create ML. A substantial dataset was meticulously curated to encompass a diverse range of American Sign Language gestures. The training process involved feeding this extensive dataset into Create ML, allowing the model to learn and recognize the nuances of ASL hand poses.

## Implementation

The application follows the Model-View-Controller (MVC) design pattern for a modular and maintainable structure. The architecture comprises three logical components: Model, View, and Controller.

## Conclusion

This ASL recognition app represents a fusion of cutting-edge technologies, making strides in communication accessibility by recognizing and interpreting American Sign Language gestures. The implementation showcases the seamless integration of machine learning, augmented reality, and user interface design to create a transformative tool for users fluent in ASL.
![Screens](https://github.com/eddy10957/ASLRecognition/blob/main/ASLRecognition/Assets/Screens.png)
