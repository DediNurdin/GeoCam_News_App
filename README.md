# GeoCam News - Flutter Application

A mobile application that combines geolocation, camera functionality, and news fetching capabilities.

![image_alt](https://github.com/DediNurdin/GeoCam_News_App/blob/cf5b9cfc3231842780f8cc37038fc340c7ea1e75/file%20cover%20-%201.png)
## Features

- **GeoCam Feature**:
  - Get current location (latitude & longitude)
  - Take photos with camera
  - Save location and photo data to local storage
  - Reset saved data

- **News Feature**:
  - Fetch news from NewsAPI
  - Display news with images and summaries

- **Bonus Features**:
  - Dark/Light theme toggle
  - Smooth UI animations

## Technologies Used

- Flutter 3.x
- BLoC for state management
- Geolocator for location services
- Image Picker for camera functionality
- SharedPreferences for local storage
- HTTP for API calls
- Flutter Animate for animations

## Setup Instructions

1. **Prerequisites**:
   - Flutter SDK installed
   - Android Studio/Xcode for emulator/device testing
   - NewsAPI API key (register at [newsapi.org](https://newsapi.org/))

2. **Clone the repository**:
   ```bash
   git clone https://github.com/DediNurdin/GeoCam_News_App.git
   cd geo_cam_news
3. **Install dependencies**:
   ```bash
   flutter pub get
4. **Run the app**:
   ```bash
   flutter run

## SDLC Workflow
Requirement Analysis:
  - Reviewed the coding challenge requirements
  - Identified core features and bonus points

Design:
  - Created architecture diagram
  - Defined folder structure
  - Selected state management approach (BLoC)

Implementation:
  - Set up base project with required dependencies
  - Implemented GeoCam feature
  - Implemented News feature
  - Added bonus features (theme, animations, etc.)

Testing:
  - Widget tests for UI components
  - Manual testing on emulator and physical device

Deployment:
  - Generated APK for testing
  - Prepared for submission
