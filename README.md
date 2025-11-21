## 📌 CDManager To-Do Demo

This is a simple SwiftUI demo showcasing how to use **CDManager** as a lightweight and clean abstraction layer over **Core Data**.

### 🔗 CDManager Repository

[https://github.com/AbdallahEdres/CDManager](https://github.com/AbdallahEdres/CDManager)

### 📱 Demo Features

* Add new tasks
* Mark tasks as completed or pending
* Delete tasks
* Automatic UI updates using `@Published` and `ObservableObject`
* Separate task sections (Pending / Completed)

### 🧩 How CDManager Is Used

* `CDDataSource<T>` is used as the Core Data access layer
* `ManagedEntity` is applied to the `ToDoTask` entity
* Repository pattern (`ToDoTasksRepository`) handles all CRUD operations
* The ViewModel remains clean and focused only on UI state

This demo shows how **CDManager** reduces Core Data boilerplate and provides a more readable, maintainable structure for SwiftUI apps.
