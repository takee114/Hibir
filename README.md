---

# Hibir App

Hibir is a mobile application developed using Flutter for the frontend, Laravel as the backend, and MySQL as the database. The app is designed to provide a platform for users to share cultural posts and interact through comments and likes.

## Features

- **User Authentication**: Secure login and registration system with JWT authentication.
- **Post Management**: Users can create, edit, and delete posts with video or image attachments.
- **Comments and Likes**: Interaction features for commenting on and liking posts.
- **Real-Time Notifications**: Users receive notifications for new comments or likes on their posts.
- **Responsive UI**: Flutter-based mobile app that is smooth and responsive.
- **RESTful API**: Laravel backend with API routes for communication with the frontend.
  
## Tech Stack

### Frontend
- **Flutter**: Cross-platform mobile app framework for Android and iOS.
  
### Backend
- **Laravel**: PHP framework used to build the API and manage the backend logic.
- **MySQL**: Relational database for storing user and app data.

### Additional Tools
- **Shared Preferences**: For storing authentication tokens and session data on the client side.
- **http**: For making API requests to the Laravel backend.

## Installation

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [XAMPP or MySQL](https://www.apachefriends.org/index.html) for database management.
- [Composer](https://getcomposer.org/download/) to install Laravel dependencies.
- A web server like XAMPP or Laravel's built-in server.

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/takee114/Hibir.git
   ```

2. **Backend Setup:**
   - Navigate to the `hibir` backend folder:
     ```bash
     cd backend
     ```
   - Install dependencies:
     ```bash
     composer install
     ```
   - Configure your `.env` file with your database details:
     ```
     DB_CONNECTION=mysql
     DB_HOST=127.0.0.1
     DB_PORT=3306
     DB_DATABASE=your_database_name
     DB_USERNAME=your_username
     DB_PASSWORD=your_password
     ```
   - Run migrations:
     ```bash
     php artisan migrate
     ```
   - Start the Laravel server:
     ```bash
     php artisan serve
     ```

3. **Frontend Setup (Flutter):**
   - Navigate to the `hibir_frontend` folder:
     ```bash
     cd frontend
     ```
   - Install dependencies:
     ```bash
     flutter pub get
     ```
   - Run the app:
     ```bash
     flutter run
     ```

## API Endpoints

| Method | Endpoint        | Description                |
|--------|-----------------|----------------------------|
| POST   | `/api/login`     | Log in a user              |
| POST   | `/api/register`  | Register a new user        |
| GET    | `/api/posts`     | Get all posts              |
| POST   | `/api/posts`     | Create a new post          |
| PUT    | `/api/posts/:id` | Update a post              |
| DELETE | `/api/posts/:id` | Delete a post              |

## Contribution

Feel free to submit issues or pull requests. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT License](LICENSE)

---

You can adjust it based on your specific project details. If you need to include more advanced features or sections, feel free to ask!
