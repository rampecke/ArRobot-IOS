# ArRobot-iOS

**ArRobot-iOS** brings the classic RobotKarol experience into Augmented Reality (AR), allowing students to control and program a virtual robot within their real-world environment. The app makes learning programming concepts fun, interactive, and engaging through hands-on exploration.

Students can **freely explore** programming concepts in AR, **create and share their own exercises** using a built-in editor, or participate in structured challenges via an instructor-led **Challenge Mode**. Whether used in self-paced learning or a classroom setting, ArRobot-iOS provides a flexible and motivating experience.

---

## 🚀 Features

- **Free Exploration**: Write and execute code to control a virtual robot in an AR space  
- **Custom Exercise Editor**: Design your own programming tasks  
- **Exercise Sharing**: Distribute custom exercises via QR codes or links  
- **Challenge Mode**: Compete with others by completing instructor-defined exercises  
- **Gamified Learning**: Earn points based on task completion, speed, and solution efficiency

---

## 📁 Project Structure

```bash
/
├── App/           # iOS app source code (Swift + SwiftUI + ARKit)
└── Server/        # Server Code for Challenge Mode (Java + Spring Boot)
```

This structure ensures a clean separation of concerns, making the project easier to maintain and extend.

---

## 🛠️ Getting Started

### App Prerequisites

- macOS with [Xcode](https://developer.apple.com/xcode/) installed  
- iOS device that supports ARKit (e.g., iPhone 8 or newer)  
- Basic familiarity with Swift and iOS development

---

### 🔧 Running the Server with Docker Compose

To start the backend server for **Challenge Mode** using Docker Compose:

1. Make sure [Docker](https://www.docker.com/products/docker-desktop) and [Docker Compose](https://docs.docker.com/compose/) are installed.
2. Navigate to the root of the repository (where the `compose.yml` file is located).
3. Run:

```bash
docker compose up --build
```

This will:
- Build the Spring Boot server
- Start the backend service (default port: 8080)

To stop the services:
```bash
docker-compose down
```
>💡 Free exploration and custom exercises work without the server. The server is only required for Challenge Mode.
