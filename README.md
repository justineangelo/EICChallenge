
# Project Name

## Overview
This project is an iOS application built using Swift/UIKit. The application contains a screen that has questions that the user answers to navigate to the step or module.

## Table of Contents
1. [Getting Started](#getting-started)
2. [Building and Running](#building-and-running)
3. [Architecture](#architecture)
4. [Challenges and Solutions](#challenges-and-solutions)
5. [Future Improvements](#future-improvements)

---

## Getting Started

### Prerequisites
- **Xcode** (version 15.4 or above)
- **iOS SDK** (iOS 15.5 or above)

### Installation
1. Clone the repository:
   ```bash
   git clone git@github.com:justineangelo/EICChallenge.git
   cd EICChallenge
   ```
   
## Building and Running

To build and run the application:
1. Open the project in Xcode.
2. Select the target device (simulator or physical device).
3. Press `Cmd + R` to build and run the application.

## Architecture

This app follows MVVM architecture to separate concerns and facilitate testing and scalability.

- **Data Layer**: Handles networking, database, and API calls.
- **Presentation Layer**: View Controllers/View Models manage UI logic.
- **UI Layer**: Storyboard/UI components.

### Key Decisions

- **Networking**: Implemented using URLSession for HTTP requests to external APIs

## Challenges and Solutions

- **Challenge**: Drag and drop on a view to a text view/label the recap screen.
  - **Solution**: Since this is the first time I've implemented it, I tried using a UIKit drag-and-drop implementation, using a UICollectionView drag delegate and a drop delegate attached to a text view. I converted the view to an image and inserted it into the text view as an NSTextAttachment.
- **Challenge**: Designing the flow and passing/interaction of data between child views.
  - **Solution**: Design a protocol ActivityChildViewModelProtocol used as a view model on sub-modules (Recap view and Choice view) and allows interaction with the Composed ActivityViewModelProtocol on activity.


## Future Improvements

- **Optimize Recap Drag & Drop**: Implemented the basic implementation to satisfy the requirements for the recap module, but it needs to update the implementation and add animations.
- **Improve UI**: Some UI are not tested on small devices and may have some issues. I would like to implement some of its UI using SwiftUI.
- **Improve Error Handling**: Simple alert and log for error handling.
- **Add Unit and UI Tests**: Added simple tests and no UI tests, but need to include other critical tests.
- **Optimize for Performance**: Only tested it on a Simulator, may be slow on older devices
