# ProbEase

ProbEase is a simple Real Estate Management application inspired by modern real estate platforms such as NoBroker.

The application provides a clean and responsive dashboard interface along with user authentication and user management functionality. Users can register, log in securely, and manage user records through REST API integration.

## ✨ Features

### Authentication

* User Registration
* User Login
* JWT Authentication
* Secure Token Storage
* Protected User Sessions
* Logout Functionality

### Dashboard

* Clean and Responsive Dashboard UI
* User Information Display
* Dashboard Statistics and Charts
* Modern Real Estate Inspired Design

### User Management

* Add New User
* View User Details
* Update User Details
* Delete User
* Fetch User List

### Other Features

* REST API Integration
* Error Handling
* Form Validation
* Responsive UI
* Clean Project Architecture

---

# 🛠 Tech Stack

## Flutter Application

* Flutter
* Dart
* Flutter Bloc
* Dio
* Flutter Secure Storage
* Google Fonts
* FL Chart

## Backend

* Node.js
* Express.js
* PostgreSQL
* JWT Authentication

---

# 📁 Flutter Project Structure

```text
lib/
│
├── app/
│   ├── app.dart
│   └── routes.dart
│
├── core/
│   │
│   ├── constants/
│   │   ├── api_constants.dart
│   │   └── app_colors.dart
│   │
│   ├── network/
│   │   ├── api_exception.dart
│   │   └── dio_client.dart
│   │
│   ├── storage/
│   │   └── flutter_secure_storage.dart
│   │
│   ├── utils/
│   │   ├── error_handler.dart
│   │   └── validators.dart
│   │
│   └── widgets/
│
├── models/
│   └── user_model.dart
│
├── repositories/
│   ├── auth_repository.dart
│   └── user_repository.dart
│
├── services/
│   ├── auth_service.dart
│   └── user_service.dart
│
├── view_models/
│   │
│   ├── auth/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   │
│   └── user/
│       ├── user_bloc.dart
│       ├── user_event.dart
│       └── user_state.dart
│
├── views/
│   ├── auth/
│   ├── dashboard/
│   └── splash_screen.dart
│
└── main.dart
```

The project follows a structured architecture with separation between:

* Models
* Services
* Repositories
* State Management
* Views
* Core Utilities

---

# ⚙️ Backend Project Structure

```text
src/
│
├── controllers/
├── routes/
├── middleware/
├── database/
├── models/
├── utils/
│
└── server.ts
```

The Express backend handles:

* Authentication
* JWT Token Generation
* User Management
* CRUD Operations
* PostgreSQL Database Integration
* API Error Handling

---

# 🚀 Getting Started

## Prerequisites

Make sure the following are installed:

* Flutter SDK
* Dart SDK
* Express.js(node.js)
* PostgreSQL(Supabase)
* Git

---

# 📱 Flutter Setup

## Clone the repository

```bash
git clone <flutter-repository-link>
```

## Navigate to the project

```bash
cd nobroker_user_dashboard
```

## Install dependencies

```bash
flutter pub get
```

## Configure Environment Variables

Create a `.env` file in the project root:

```env
BASE_URL=YOUR_BACKEND_URL
```

Example:

```env
BASE_URL=http://YOUR_IP:PORT
```

## Run the application

```bash
flutter run
```

---

# 🖥 Backend Setup

## Clone the repository

```bash
git clone <backend-repository-link>
```

## Navigate to the backend project

```bash
cd backend
```

## Install dependencies

```bash
npm install
```

## Configure Environment Variables

Create a `.env` file:

```env
PORT=3000
DATABASE_URL=your_postgresql_connection_string
JWT_SECRET=your_jwt_secret
```

## Run in development mode

```bash
npm run dev
```

## Production Build

```bash
npm run build
npm start
```

---

# 🔌 API Features

The backend provides REST APIs for:

### Authentication

* User Registration
* User Login
* JWT Authentication

### User Management

* Get All Users
* Get User Details
* Create User
* Update User
* Delete User

---

# 🔄 Application Flow

```text
Splash Screen
      ↓
Register / Login
      ↓
JWT Authentication
      ↓
Dashboard
      ↓
View User Records
      ↓
Add / Edit / Delete User
```

---

# 📱 Application Screens

* Splash Screen
* Login Screen
* Registration Screen
* Dashboard
* User List
* Add User
* Edit User

---

# 📦 Assignment Deliverables

* Flutter Source Code
* Express Backend Source Code
* APK File
* GitHub Repository

---

# 👨‍💻 Author

**Parthiban**

Flutter Developer
