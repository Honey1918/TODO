# 📝 Flutter To-Do List App

A simple, intuitive To-Do list app built with **Flutter**. Add, edit, sort, complete, and delete tasks — all with persistent storage and priority indicators.

---

## 🚀 Features

- Add new tasks with **priority (High, Medium, Low)** and a custom title.
- Mark tasks as ✅ completed or ❌ delete them.
- Edit any existing task with a simple tap.
- Sort tasks by priority (High → Low).
- Priority icons:
  - 🔴 High – `priority_high`
  - 🟠 Medium – `trending_up`
  - 🟢 Low – `low_priority`
- Tasks are **saved locally** using `shared_preferences`.
- Automatically shows `"Nothing's here to do"` when task list is empty.
- Responsive design works on both Android and iOS devices.

---

## 📦 Packages Used

| Package              | Version     |
|----------------------|-------------|
| flutter              | >=3.10.0    |
| shared_preferences   | ^2.2.2      |

You can update versions using `flutter pub upgrade` if needed.

---

## 📁 Folder Structure

lib/
├── main.dart
├── models/
│ └── task.dart
├── screens/
│ └── home_screen.dart
├── widgets/
│ └── add_task_modal.dart


---

## 🛠 How to Run the App

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Android Studio or VS Code with Flutter and Dart extensions

---

### 🧪 Run Steps

Install dependencies

flutter pub get

Run the app

flutter run
