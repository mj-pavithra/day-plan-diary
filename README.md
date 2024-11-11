# Day Plan Diary - Flutter.material UI and Hive

A simple task management app built with Flutter and Hive for local data storage. The app allows users to create, update, and manage tasks with attributes such as title, due date, and priority. The project uses Hive, a lightweight and fast NoSQL database, to store the task data locally on the device.

## Features

- **Create Task**: Users can create new tasks by providing a title, due date, and priority.
- **Update Task**: Users can edit the details of an existing task.
- **Priority Selection**: Tasks can be assigned a priority level (High, Medium, Low).
- **Date Picker**: Users can select a date using a calendar.
- **Task Validation**: Ensures all fields are filled correctly before submission, and prevents the addition of tasks with past dates.
- **Hive Database**: Tasks are stored locally using the Hive database for fast data retrieval and storage.

## Technologies Used

- **Flutter**: For building the cross-platform mobile application.
- **Hive**: A fast, lightweight key-value database for Flutter, used to store task data locally.
- **Dart**: The programming language used for developing the Flutter app.
- **Material Design**: For consistent UI/UX design, with widgets like `TextField`, `ElevatedButton`, `DropdownButtonFormField`, etc.

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/task-manager-app.git

Navigate to the project directory:

cd task-manager-app

Install dependencies:

flutter pub get

Run the app:

    flutter run

Theories Covered in This Project
1. State Management in Flutter

    This project demonstrates the use of StatefulWidget to manage the state of the application.
    The state of the text fields, date picker, and dropdown list is managed using TextEditingController and setState().
    This ensures that changes in the UI are reflected when the user interacts with the components.

2. Database Handling with Hive

    Hive is used as a local database to store task data persistently.
    Box: The core concept of Hive is the Box, which is a simple key-value store. In this project, we use a box named 'tasksBox' to store the tasks.
    Data is retrieved, added, and updated using the taskBox.add() and taskBox.putAt() methods.
    Tasks are stored in a Map format and can be accessed using their index or key.

3. Date Handling in Flutter

    The app allows users to select a date using a date picker and ensures that the selected date is not in the past.
    The date is formatted and displayed in the TextField as a string in yyyy-mm-dd format.
    The DateTime class is used for parsing and validating dates.

4. Form Validation

    This project demonstrates basic form validation in Flutter.
    The validation ensures that the user provides values for all fields (title, date, priority).
    It also ensures that the selected date is not in the past, protecting users from submitting invalid data.
    If any field is empty or if the date is invalid, an error message is shown using SnackBar.

5. UI/UX Design (Material Design)

    The app's user interface follows Material Design principles to ensure a clean, intuitive user experience.
    The UI components such as TextField, DropdownButtonFormField, and ElevatedButton are styled to create a consistent and user-friendly interface.
    The app uses padding, spacing, and button design best practices to create a visually appealing and functional layout.

6. Flutter Navigation

    The app uses Navigator to move between different screens. For example, the user can navigate from the "Create Task" page to the "Update Task" page, passing necessary data between pages.
    The Navigator.pop(context) method is used to close the current screen and return to the previous one.

7. Error Handling and SnackBars

    Error handling is implemented to catch potential issues like empty fields, invalid dates, or problems when interacting with the database.
    SnackBar widgets are used to display user-friendly messages (such as "Task saved successfully!" or error messages) at the bottom of the screen to inform the user about the success or failure of their actions.

Screenshots

Insert a screenshot of the app's home page here.

Insert a screenshot of the "Create Task" screen here.
Future Improvements

    Task Completion: Add functionality to mark tasks as completed.
    Task Deletion: Add the ability to delete tasks.
    Task Search: Implement a search feature to filter tasks based on keywords or due date.

Screen shots
{![image](https://github.com/user-attachments/assets/e17e74b0-4f80-47cb-90e1-990352e2ce72) 
Homepage ToDo tasks}
![image](https://github.com/user-attachments/assets/6d239fd7-5fbf-4c82-8d0d-96e6c71423fc) 
Homepage ToDo tasks Sorting(Medium Priority)
![image](https://github.com/user-attachments/assets/10f6741f-b284-4662-a98e-e5228564df30) 
Homepage Completed tasks
![image](https://github.com/user-attachments/assets/56efc98d-3d12-44b2-a114-e76b8689b183) 
Add new task



