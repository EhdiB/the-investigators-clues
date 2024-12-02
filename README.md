# The Investigator's Clues

_The Investigator's Clues_ is an unofficial application to help Blood on the Clocktower's players to track the game status and register the clues they collected, and to help the storyteller to setup the game and track its status.
This is a free and open source multi-platform project developed with Flutter, which supports Android, Web and iOS. <br/>
This application is not affiliated with The Pandemonium Institute.<br/> All roles and characters are the property of Steven Medway and The Pandemonium Institute.

## Main features

- Monitoring game status as storyteller or player:
  - Add game setup, by registering the script, number of players and their names (optional);
  - Manually ou randomly select script roles according to the players number (Storyteller mode only);
  - Manually ou randomly select bluff for Demon and Lunatic, if in play (Storyteller mode only);
  - Allow player to draw their character (Storyteller mode only);
  - Register information about each player (e.g. name, specific notes, are they dead?, do they have ghost vote, character, did they vote/nominate?);
  - Add/delete travellers and fabled;
  - Track the global number of alive players, ghost votes, number of votes required to successfully execute and number of players per team;
  - Save general notes about the game and write/show some token to the other players or Storyteller;
  - Track current game phase;
  - Add reminders to each player (Storyteller mode only);
  - Check first and other nights order tips and jinxes (Storyteller mode only);
- List of the official and custom scripts available in [BotC Scripts database](https://botc-scripts.azurewebsites.net), with script's characters, night order and jinxes;
- List of all the official characters (townsfolk, outsiders, minions, demo, travellers and fabled), including the experimental ones, with summary and the detailed information about each of them as per [Blood on the Clocktower Wiki](https://wiki.bloodontheclocktower.com).

## Acknowledgments and Copyrights

- [Blood on the Clocktower](https://bloodontheclocktower.com) is a trademark of Steven Medway and The Pandemonium Institute
- Scripts data are obtained from [BotC Scripts database](https://botc-scripts.azurewebsites.net)
- Detailed information about each official character is obtained from [Blood on the Clocktower Wiki](https://wiki.bloodontheclocktower.com).
- Icons were obtained from [Pocket Grimoire](https://www.pocketgrimoire.co.uk/) (source: [Font Awesome](https://fontawesome.com/v5/search))
- Some images were collected from [Clocktower.online](https://www.clocktower.online/)
- Information about night order, reminders and Jinxes was obtained from [Pocket Grimoire](https://www.pocketgrimoire.co.uk/)

## How to Update

### Add new released character

- Get new token image and save it in the _lib/assets/images/character_tokens_ folder;
- Add character info in _lib/assets/data/characters.json_, according to the existing json schema;
- Update jinks in _lib/assets/data/jinx.json_ and night order in _lib/assets/data/night_order.json_ files;

### Update an ability

- Find the character info in _lib/assets/data/characters.json_ and update the info.

### Add new script

- Find the script at [BotC Scripts database](https://botc-scripts.azurewebsites.net) and click on click;
- In the scripts details url (e.g. https://botc-scripts.azurewebsites.net/script/5144/1.0.1) click in _json_ button to copy json link (e.g. https://botc-scripts.azurewebsites.net/api/scripts/8748/json/);
- Grab the script id from the json link (8748 in the example given above), and replace _id_ placeholder by the real id in the url `https://botc-scripts.azurewebsites.net/api/scripts/{id}/` and open the resulting url.
- Copy the json data provided in the response payload and add it to the list available in _lib/assets/data/characters.json_ file. update the info.

### Run the App locally

##### For web

run `flutter build web`

##### For android

run `flutter build apk`

#### For iOS

run `flutter build ipa`

### Build App

##### For web

run `flutter run -d chrome --release`

##### For android

In VSCode, click `Run` -> `Run Without Debugging`, after starting the Android emulator you plan to use.

#### For iOS

In VSCode, click `Run` -> `Run Without Debugging`, after starting the iOS emulator you plan to use.