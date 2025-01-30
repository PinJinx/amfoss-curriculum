# Task-06: Letterboxd UI

## Objective
The purpose of **Task-06** was to create the Backend for **Letterboxd**, a movie-sharing website.

## Technologies Used
- **Frontend**: Next.js (React Framework)
- **Styling**: Tailwind CSS
- **Backend**: Flask (Python)

## Project Structure
```
Task-06/
├── frontend/
│   ├── components/        # Reusable UI components
│   ├── pages/             # Next.js pages
│   ├── styles/            # Custom Tailwind CSS configurations
│   ├── public/            # Static assets
│   ├── package.json       # Frontend dependencies
│
├── backend/
│   ├── server.py          # Flask backend
│   ├── Flist.json         # Json for storing all movies
└── README.md              # Project documentation
```

## Running the Application
### Prerequisites
Ensure you have the following installed:
- Node.js and npm/yarn
- Python 3.x
- Flask (`pip install flask`)

### Steps to Run
1. Run the Flask backend
2. Open the frontend at `http://localhost:3000/` to interact with the UI.

## Features Implemented
- Responsive movie-sharing UI
- User authentication
- Dynamic movie lists and details
- Backend integration with Flask for data handling
- User reviews and ratings

