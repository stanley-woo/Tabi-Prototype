# Tabi

A native mobile app for travel itinerary sharing with a Python FastAPI backend and a Flutter frontend.

## Backend Setup (FastAPI)

1. Create a virtual environment:
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: .\venv\Scripts\activate
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Run the development server:
   ```bash
   python main.py
   ```

The API will be available at http://localhost:8000. Access the API documentation at http://localhost:8000/docs.

## Frontend Setup (Flutter)

1. Install Flutter dependencies:
   ```bash
   cd frontend
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

Make sure you have Flutter and Dart SDK installed on your system. For Flutter installation instructions, visit: https://flutter.dev/docs/get-started/install

## Features

- User authentication and authorization
- Create and share travel itineraries
- Collaborative trip planning
- Real-time updates and notifications
- Interactive maps and location services

## Development Status

Currently in initial development phase. More features coming soon!
