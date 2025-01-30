# Task-09: Pokemon Trading App

## Objective
The purpose of **Task-09** is to create an application similar to a Pokémon trading app. The app allows users to trade Pokémon with each other in a structured and seamless manner.

## Technologies Used
- **Backend**: Flask (Python)
- **Frontend**: HTML, CSS, JavaScript (if applicable)
- **Database**: SQLite / PostgreSQL (if applicable)
- **API Handling**: Flask-RESTful (if applicable)

## Project Structure
```
Task-09/
├── server/
│   ├── server.py          # Main Flask application
│   ├── store.json         # Used to store pokemon sorted by thier power to legendary common rare
│   ├── users.json          # Json used to store user details and pokemon trades
│ 
├── client/
│   ├── flutter app
└── README.md              # Instructions for running the app
```

## Features Implemented
- User authentication 
- Ability to list available Pokémon for trade
- Ability to buy pokemon at trade
- Ability to gamble money at pokemon store buying card packs
- Confirmation and approval of trades

