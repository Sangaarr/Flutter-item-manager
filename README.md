# Flutter CRUD Task

A clean, structured, and professional Flutter application demonstrating local data persistence using SQLite, State Management with Provider, and a solid UI/UX experience.

## Overview

A simple item manager app that allows users to create, edit, and delete items using a local database.

---

## Features

* **Complete CRUD:** Create, Read, Update, and Delete items.
* **Local Database:** Offline-first approach using `sqflite`.
* **State Management:** Reactive UI using `provider`.
* **Form Validations:** Prevents empty submissions.
* **User Feedback:** SnackBars for success/error messages and confirm dialogs for destructive actions.
* **Edge Cases Handled:** Empty states, loading states, and exception handling.

---

## Architecture & Pattern

This project follows a simple structure separated by technical concerns:

* `models/`: Data definitions and SQLite mappers (`toMap`, `fromMap`).
* `database/`: Singleton `DatabaseHelper` isolating all SQL queries.
* `providers/`: Business logic layer separating the database from the UI.
* `screens/`: Main UI views.
* `widgets/`: Reusable UI components (cards, dialogs).

---

## Tech Stack

* **Flutter SDK** (Dart)
* **provider** (State Management)
* **sqflite** & **path** (Database)

---

## Technical Decisions

**Why Provider?**  
Provider was chosen because it is lightweight, easy to understand, and ideal for small applications. It allows a clear separation between UI and business logic without adding unnecessary complexity.

**Why SQLite?**  
SQLite was used to provide local data persistence without requiring a backend. It keeps the application simple while still demonstrating real-world data handling.

---

## How to Run

1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Run `flutter run` on an iOS/Android emulator or physical device.