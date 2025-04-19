# OpExpense

OpExpense is a cross-platform mobile application (iOS and Android) designed to help people track their expenses effectively. Users can monitor their spending through charts and history while leveraging an AI-powered assistant that analyzes their transactions. This AI assistant can provide spending suggestions and answer any expense-related queries.

---

## Features
- **Authentication**:
  - Sign up or log in with email and password.
  - Google authentication.
- **Expense Tracking**: Add, edit, and view expenses categorized for better organization.
- **AI-Guided Financial Advice**: The AI assistant has access to your transactions and can:
  - Suggest budget-friendly habits.
  - Answer questions about your spending.
- **Charts and Analytics**: Visualize expenses through interactive charts.
- **Custom Categories**: Create and manage categories tailored to your needs.

---

## Purpose
This app was created to:
1. Showcase my skills as a Flutter developer.
2. Help people track their money effectively using modern tools and AI.

---

## Download

You can download **OpExpense** directly from the Google Play Store:

[![Get it on Google Play](https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png)](https://play.google.com/store/apps/details?id=com.opExpense.app)

---

## Tech Stack
OpExpense is built with the following technologies:
- **Frontend**: Flutter (Dart)
- **State Management**: Bloc and Cubit
- **Backend and Services**:
  - Firebase Firestore (database)
  - Firebase Storage
  - Firebase Authentication
  - Hive (local storage)
- **AI Integration**: Gemini API
- **Development Workflow**:
  - Clean Architecture
  - Dependency Injection
  - Git and GitHub (Git Flow strategy)

---

## Installation
To run this app locally, follow these steps:

1. **Prerequisites**:
   - Install Flutter SDK: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
   - Set up an IDE (Android Studio, VS Code, etc.).
   - Clone this repository:
     ```bash
     git clone https://github.com/SouFiane-SinCara/op_expense
     ```
2. **Setup**:
   - Navigate to the project directory:
     ```bash
     cd op_expense
     ```
   - Install dependencies:
     ```bash
     flutter pub get
     ```
3. **Run the App**:
   - Use the following command to run the app:
     ```bash
     flutter run
     ```

> **Note**: Ensure you have set up Firebase configurations in the `android` and `ios` directories for the app to run correctly.

---

## User Interface

<img src="https://github.com/user-attachments/assets/520038fd-d53b-4183-9f92-f82b10375e28" alt="Home Screen" width="300">
<img src="https://github.com/user-attachments/assets/65031bd3-9d3a-4091-9d76-3586526cc11f" alt="AI Screen" width="300">
<details>
  <summary>Click to view all screens</summary>
  <img src="https://github.com/user-attachments/assets/f3a2a622-f8bb-490e-9225-0ca3e12bf697" alt="Screenshot 1" width="200">
  <img src="https://github.com/user-attachments/assets/8cd5b477-1bc1-4497-a367-028e29f64eba" alt="Screenshot 2" width="200">
  <img src="https://github.com/user-attachments/assets/d8778885-394f-486f-95c6-a1d9571e358d" alt="Screenshot 3" width="200">
  <img src="https://github.com/user-attachments/assets/2c5eb43e-28b5-4a3e-b622-6b3b5aead7cb" alt="Screenshot 4" width="200">
  <img src="https://github.com/user-attachments/assets/bc35fe00-fa45-4147-ad24-40dea79c7423" alt="Screenshot 5" width="200">
  <img src="https://github.com/user-attachments/assets/dafe846b-423a-4f62-912b-3099911da937" alt="Screenshot 6" width="200">
  <img src="https://github.com/user-attachments/assets/b3c7099f-5ac3-4aaf-89d4-6beeb6f845f6" alt="Screenshot 7" width="200">
  <img src="https://github.com/user-attachments/assets/223e5c5e-88b1-439b-8f64-af50948de14b" alt="Screenshot 8" width="200">
  <img src="https://github.com/user-attachments/assets/801f3f22-e308-4a15-9f65-c0483590c2c2" alt="Screenshot 9" width="200">
  <img src="https://github.com/user-attachments/assets/d4f54c14-eff5-4a53-8e7c-98638a8b1715" alt="Screenshot 10" width="200">
  <img src="https://github.com/user-attachments/assets/ae5daadf-afc2-437b-ba14-fe6d75b72183" alt="Screenshot 11" width="200">
  <img src="https://github.com/user-attachments/assets/6056bec6-8f5d-4c55-96eb-34612853d2e5" alt="Screenshot 12" width="200">
  <img src="https://github.com/user-attachments/assets/a48b2d68-3c1b-4700-9053-c647d76eb87f" alt="Screenshot 13" width="200">
  <img src="https://github.com/user-attachments/assets/3c8a2b56-d4c1-47ea-91de-3bb1af386a31" alt="Screenshot 14" width="200">
  <img src="https://github.com/user-attachments/assets/40c108db-6614-4935-b79b-83b7b2bf5afd" alt="Screenshot 15" width="200">
  <img src="https://github.com/user-attachments/assets/f84bbe7a-c05b-4e3e-a5ff-dd590908b915" alt="Screenshot 16" width="200">
  <img src="https://github.com/user-attachments/assets/40b73f59-aca1-4378-a001-c59d27264506" alt="Screenshot 17" width="200">
  <img src="https://github.com/user-attachments/assets/b2beff06-faba-439e-bf13-4f34c1bef45d" alt="Screenshot 18" width="200">
  <img src="https://github.com/user-attachments/assets/6892abe6-eef9-4097-949c-51282417c444" alt="Screenshot 19" width="200">
  <img src="https://github.com/user-attachments/assets/1b631c0a-3087-48f8-b6eb-a21556f756ca" alt="Screenshot 20" width="200">
  <img src="https://github.com/user-attachments/assets/755b3dac-8808-4248-bc1c-6d6b2193bf86" alt="Screenshot 21" width="200">
  <img src="https://github.com/user-attachments/assets/db31b4bf-46f7-4c1b-9225-45b1fd333b96" alt="Screenshot 22" width="200">
  <img src="https://github.com/user-attachments/assets/52a31dc6-e45c-4bf3-9fb5-ac71bc933e78" alt="Screenshot 23" width="200">
  <img src="https://github.com/user-attachments/assets/373bdb92-9524-47ca-94ce-b29f096da813" alt="Screenshot 24" width="200">
  <img src="https://github.com/user-attachments/assets/68f85e53-b126-42e8-a8fb-87ef7881905b" alt="Screenshot 25" width="200">
  <img src="https://github.com/user-attachments/assets/fe631461-78c0-479f-b7ed-e970ffe69c60" alt="Screenshot 26" width="200">
  <img src="https://github.com/user-attachments/assets/e48b152d-69d2-4e65-8288-050f7043bb4d" alt="Screenshot 27" width="200">
  <img src="https://github.com/user-attachments/assets/9d64be59-63d2-4ce9-96cd-e92acdb16107" alt="Screenshot 28" width="200">
</details>

---

## Contribution
Contributions are welcome! If you’d like to contribute:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a clear explanation of your changes.

---

## Contact
For questions, feedback, or contributions, feel free to contact me:
- **Email**: [soufiane.selouan.dev@gmail.com](mailto:soufiane.selouan.dev@gmail.com)
