# Standup App

## Models

- User
  - Main entity of the system
  - Authentication happens off of it
- Group
  - Consists of users
  - A group is the main meeting place for the users standups
- Standup
  - Tied to a specific date (not time based)
  - Users submit their answers for a given standup
  - Can submit for today, tomorrow
  - Tied to a group
- Questions
  - Hardcoded Questions
  - "What did you do yesterday?"
  - "What are you doing today?"
  - "Do you have any blockers"
  - Potential to be expanded in the future
- Answer
  - Associated with a specific question
  - Tied to a standup for a given user

## Features

- Submit answers to the questions for a given group's standup (today or tomorrow only)
- Append your answers to today or tomorrow standup
- Email out to all users button
- View all standups
- Standup meeting randomizer
