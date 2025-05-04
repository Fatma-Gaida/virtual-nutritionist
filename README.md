# virtual-nutritionist
A cross-platform application with Spring Boot backend and Flutter frontend for managing recipes, tracking calories, and creating daily meal plans.

## Project Overview

This project consists of two main components:

### Backend (Spring Boot)
- Written in Java
- MongoDB database integration
- RESTful API for data management
- Models for recipes, ingredients, users, daily plans, and calorie tracking

### Frontend (Flutter)
- Cross-platform mobile application
- State management with flutter_bloc
- HTTP requests with dio
- Web content display with webview_flutter

## Directory Structure

```
├── Backend (Spring Boot)
│   ├── src/main/java/com/example/pfa2/
│   │   ├── controllers/
│   │   │   └── ApiController.java
│   │   ├── models/
│   │   │   ├── DashboardQuotidien.java
│   │   │   ├── DailyPlan.java
│   │   │   ├── Ingredient.java
│   │   │   ├── PlatsConsommes.java
│   │   │   ├── PlatsFavoris.java
│   │   │   ├── Recipe.java
│   │   │   └── User.java
│   │   └── repository/
│   │       ├── RecipeRepository.java
│   │       └── UserRepository.java
│   ├── Configuration Files
│   │   ├── pom.xml
│   │   ├── mvnw
│   │   ├── mvnw.cmd
│   │   └── .gitattributes
│
├── Frontend (Flutter)
│   ├── lib/
│   │   └── main.dart
│   ├── assets/
│   │   ├── images/
│   │   │   ├── profil.png
│   │   │   ├── breakfast.png
│   │   │   └── ...
│   │   └── chatbot.html
│   ├── Configuration Files
│   │   ├── pubspec.yaml
│   │   ├── pubspec.lock
│   │   ├── .metadata
│   │   ├── .flutter-plugins
│   │   └── .flutter-plugins-dependencies
│   └── ios/Runner.xcodeproj/project.pbxproj
```

## Prerequisites

### Backend Prerequisites
- Java: JDK 17 or later
- Maven: Version 3.6.0 or later
- MongoDB: Version 4.0 or later
- Git (optional): For version control

### Frontend Prerequisites
- Flutter: Version 3.27.0 or later
- Dart: Version 3.7.2 or later
- Android Studio/Xcode (optional): For emulators and device testing
- Node.js (optional): For web development with Flutter

## Installation of Prerequisites

### Backend

#### Java
```bash
# Ubuntu/Debian
sudo apt install openjdk-17-jdk

# macOS with Homebrew
brew install openjdk@17

# Verify installation
java -version
```

#### Maven
```bash
# Ubuntu/Debian
sudo apt install maven

# macOS with Homebrew
brew install maven

# Verify installation
mvn -version
```

#### MongoDB
```bash
# Ubuntu/Debian
sudo apt install mongodb

# macOS with Homebrew
brew install mongodb-community

# Start MongoDB server
mongod

# Verify installation
mongo --version
```

### Frontend

#### Flutter
```bash
# Clone Flutter repository
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

#### Dart
Dart is included with Flutter. Verify the version:
```bash
dart --version
```

#### Android Studio/Xcode
- For Android: Install Android Studio and set up an emulator
- For iOS: Install Xcode (macOS only) and set up a simulator

## Compilation and Setup

### Backend

1. Navigate to the project root:
```bash
cd path/to/project
```

2. Compile the source code:
```bash
./mvnw clean package
```
This generates an executable JAR file in `target/pfa2-0.0.1-SNAPSHOT.jar`.

3. Configure MongoDB:
```
# Ensure MongoDB is running
mongod

# Create or update src/main/resources/application.properties
spring.data.mongodb.uri=mongodb://localhost:27017/pfa2
```

4. Run the application:
```bash
java -jar target/pfa2-0.0.1-SNAPSHOT.jar
```
The API will be available at http://localhost:8080 (default port).

### Frontend

1. Navigate to the Flutter project root:
```bash
cd path/to/project
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the Flutter app:
```bash
# For Android/iOS
flutter run

# For web
flutter run -d chrome
```
Ensure a device/emulator is connected or a browser is available.

4. Configure API endpoint:
Update the API endpoint in your Flutter code (likely in `lib/main.dart` or a service file):
```dart
const String apiUrl = 'http://localhost:8080/api';
```

## Usage

- **Backend**: Access the REST API endpoints (e.g., `/api/recipes`, `/api/users`) using tools like Postman or cURL.
- **Frontend**: Launch the Flutter app to interact with the backend. The app supports features like viewing recipes, tracking calories, and managing daily plans.

## Features

- Recipe management
- User profiles
- Daily meal planning
- Calorie tracking
- Favorite dishes
- Food consumption logging

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

[MIT](https://choosealicense.com/licenses/mit/)

## Contact

Your Name - [your.email@example.com](mailto:your.email@example.com)

Project Link: [https://github.com/yourusername/recipe-calorie-tracker](https://github.com/yourusername/recipe-calorie-tracker)
