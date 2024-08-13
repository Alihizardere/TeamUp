# TeamUp

Welcome to the TeamUp App! This is an innovative application that allows you to easily manage your sports organizations.

## Table of Contents
- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
  - [Home - Landing Page](#home---landing-page)
  - [Player List - Creating Player](#player-list---creating-player)
  - [Create Match](#create-match)
  - [Match Details](#match-details)
- [Improvements](#improvements)

## Features

**Google Firebase**
- Thanks to the realtime database feature, anyone who uses this application can instantly see and manage the players in the application.

**Weather API:**
- You can see what the weather will be like at the specified time and location on the match day.

**Postman Türkiye API:**
- With this API, we can get the location of each city in Turkey and each district relative to the selected city.

**Flexible Team Style:**
- Thanks to the drag-and-drop feature, you can adjust the team however you want.

## Packages and Technologies

* Alamofire
* Kingfisher
* Lottie


## Screenshots

| Image 1 | Image 2 | Image 3 |
|---------|---------|---------|
|<img width="469" alt="onboarding" src="https://github.com/user-attachments/assets/863c8266-c702-4691-908d-17e7e0ab4b50">|<img width="469" alt="Landing" src="https://github.com/user-attachments/assets/49499071-22a8-4b86-ac0d-4f210d36de31">|<img width="469" alt="Home" src="https://github.com/user-attachments/assets/2aa11f45-1a17-4aea-af44-5c8a9fc172e4">|
| Onboarding | Landing | Home |

| Image 4 | Image 5 | Image 6 |
|---------|---------|---------|
|<img width="469" alt="PlayerList" src="https://github.com/user-attachments/assets/be0aac75-fa7c-4296-af84-405262e53836">|<img width="469" alt="UpdatePlayer" src="https://github.com/user-attachments/assets/2f6e8202-be8b-421e-a561-042272ff7599">|<img width="469" alt="AddPlayer" src="https://github.com/user-attachments/assets/1b49939e-8159-4135-89e9-734450bfd381">|
| Player List | Update Player | Add Player |


| Image 7 | Image 8 | Image 9 |
|---------|---------|---------|
|<img width="469" alt="CreateEvent" src="https://github.com/user-attachments/assets/c6abd492-8ea8-4837-9bd5-ff7cbbb96d77">|![TeamSetup](https://github.com/user-attachments/assets/82fbd430-0997-4706-bd9b-828a0ae5c56d)|<img width="469" alt="MatchDetails" src="https://github.com/user-attachments/assets/5a9af26e-c988-4953-803d-7e313204532e">|
| Create Event | Team Setup | Match Details |

| Image 10 | Image 11 |
|----------|----------|
|![Drag-and-Drop](https://github.com/user-attachments/assets/97994dd7-4e94-4538-a2ff-86337ec56e0f)|![MixTeam](https://github.com/user-attachments/assets/16dcf39f-b5c6-44c0-85e9-1d1afa51d5da)|
| Drag-and-Drop | Mix Team |


## Tech Stack
- Xcode: Version 15.4
- Language: Swift 5.10
- Minimum Version 14.0

## Architecture


### MVVM (Model-View-ViewModel)

The MVVM architecture is chosen for these key reasons:

- **Separation of Concerns:**
MVVM divides the application into three distinct components: Model, View, and ViewModel. This separation ensures that each part of the application has a clear and specific role, making the codebase more modular, easier to maintain, and testable.

- **Data Binding:**
MVVM allows for two-way data binding between the View and ViewModel. This means that when the data in the ViewModel changes, the View automatically reflects these changes and vice versa. This leads to a more responsive user interface and reduces the need for boilerplate code.

- **Testability:**
By isolating the business logic within the ViewModel, MVVM makes the application more testable. The ViewModel can be tested independently of the View, ensuring that the business logic is correct without the need to involve the UI.

#### MVVM Components:

- **Model:** Encapsulates the data and business logic of the application. It is responsible for managing the data and providing it to the ViewModel.

- **View:** Displays the data and responds to user interactions. The View observes the ViewModel for updates and reflects any changes in the UI.

- **ViewModel:** Acts as an intermediary between the View and Model. It retrieves data from the Model and transforms it for display in the View. It also handles the user input logic and updates the Model accordingly.

Using MVVM promotes a clean, organized, and maintainable code structure, ensuring a robust and scalable application.



## Getting Started
### Prerequisites
Before you begin, ensure you have the following:
- Xcode installed

### Installation
1. Clone the repository:
```bash
git clone https://github.com/Alihizardere/TeamUp.git
```

2. Open the project in Xcode:
```bash
cd TeamUp
open TeamUp.xcodeproj
```
3. Build and run the project.

## Usage

### Onboarding
- There is an informative onboarding section when you start the app

### Home - Landing Page
- Select in which sport you want to generate teams.
- Tap the "Players" button to pass the section about player matters.
- Tap the "Create Match" button to pass the section about match and team details.

### Player List - Creating Player
- On the "Player List" page, you can see other players.
- You can add a new player by entering the required data and a photo of yourself.
- You can also make changes with a listed player, you can tap the player and update its data.

### Create Match
- On the "Create Event" page, you are supposed to enter the required data.
- After tapping the "Create Match" button, you are supposed to drag and drop the specific player to the desired team.
- Alternatively, you can tap the "Mix" and let the algorithm decide the team setup according to the overall of the players.

### Match Details
- On the "Match Details" page, you can see the match details like the weather according to your match location and date
- You can adjust the position of a player by pressing and holding its icon.


## Improvements
- Some bugs could be resolved to enhance the user experience
- Making unit tests relevant to the entire application
