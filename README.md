# HealthKIt-Mock-API
# Overview
The Step Count Dashboard is an iOS application developed using Swift and SwiftUI. The app fetches and displays step count data from HealthKit, allowing users to visualize their daily activity through an interactive graph. The app also includes a list of step count entries that users can interact with to highlight specific data points in the graph.

# Features
	•	HealthKit Integration: Fetches step count data directly from HealthKit.
	•	Interactive Graph: Displays step counts on an interactive line graph with tooltips.
	•	Segmented Control: Users can switch between different date ranges (e.g., Today, Yesterday, Last 7 Days, Custom) to view step count data.
	•	Step Count Tiles: A list of step count entries is displayed below the graph. Tapping on a tile highlights the corresponding data point in the graph.
	•	Data Caching: Step count data is cached to improve performance and reduce redundant mock json queries .
	•	Mock Data for Testing: The app can populate HealthKit with mock data for testing purposes.

# Requirements
	•	iOS 14.0+ / iPadOS 14.0+
	•	Xcode 14.0+
	•	Swift 5.8+
	•	HealthKit enabled on the device
# Installation 
	4	Open the Project:
	◦	Open the project in Xcode by double-clicking the Buoy.xcodeproj file.
	5	Enable HealthKit:
	◦	Ensure that HealthKit capability is enabled in the Xcode project settings.
	6	Set Up Signing:
	◦	In Xcode, go to Signing & Capabilities and select your development team.
	7	Build and Run:
	◦	Build and run the project on a physical device (HealthKit does not work on the simulator).
# Usage
	1	HealthKit Authorization:
	◦	Upon first launch, the app will request authorization to access HealthKit data. Grant the necessary permissions to proceed.
	2	View Step Counts:
	◦	Use the segmented control to switch between different date ranges and view your step counts.
	3	Interact with the Graph:
	◦	Tap on the circles in the graph to view detailed information about each step count entry.
	4	Step Count Tiles:
	◦	Scroll through the list of step count tiles below the graph. Tapping on a tile will highlight the corresponding data point in the graph.
# Customization
Adding Mock Data
To populate HealthKit with mock data, the app includes a function addMockStepData() which can be called after HealthKit authorization is granted. This mock data is based on the sample data provided in the assignment's PDF.
Caching Strategy
The app uses in-memory caching to store step count data for each queried date range. This improves performance by reducing redundant queries to HealthKit.(only during mock json )
 
# Known Issues
	•	HealthKit Authorization: If the user denies HealthKit permissions, the app will not function as intended. The user must manually enable permissions in the device settings if initially denied.
	•	Graph Label Overlap: When scrolling or zooming in the graph, x-axis labels may overlap, leading to a cluttered UI. Scrolling and zooming features were intentionally skipped in favor of simpler, more precise interactions.
# Future Enhancements
	•	Profile Tab: A future enhancement might include adding a "Profile" tab where users can view and manage their HealthKit data.
	•	Improved UI/UX: Further refinement of the graph's interaction model, including better handling of label overlaps and improved tooltip positioning.
	•	Persistent Caching: Consider implementing a persistent caching strategy using Core Data or SQLite for storing step count data across sessions.
