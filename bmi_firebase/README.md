# BMI Calculator with Firebase Integration Made by MOHAMED YASSINE FDIOUICH

A modern BMI (Body Mass Index) calculator application built with Flutter and Firebase, featuring user authentication and data persistence.

## Features

- **User Authentication**
  - Email and password-based login/registration
  - Secure authentication using Firebase Auth

- **BMI Calculation**
  - Calculate BMI using weight (kg) and height (cm)
  - Visual representation of BMI using a gauge
  - Categorization of BMI results:
    - Below Weight
    - Ideal Weight
    - Slightly Overweight
    - Obesity Grade 1
    - Obesity Grade 2
    - Obesity Grade 3

- **Data Persistence**
  - Store BMI records in Firebase Firestore
  - Track historical BMI measurements
  - User-specific data storage

- **Internationalization**
  - Multi-language support
  - Easy language switching within the app
  - Localized content and messages

## Technical Features

- Built with Flutter
- Firebase Integration (Auth & Firestore)
- Provider State Management
- Form Validation
- Responsive Design
- Clean Architecture

## Getting Started

1. Clone the repository
2. Configure Firebase:
   - Create a new Firebase project
   - Add Android/iOS apps to your Firebase project
   - Download and add the configuration files
3. Install dependencies:
   ```bash
   flutter pub get
