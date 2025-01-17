dart sdk set up
Flutter sdk set up
Chrome(web) is the platform I have used.

My code is in all with in the lib folder and then subfolders from there. All images and sounds are in the assets folder and then a subfolder from there.
In the backend folder you will find the node class and the node.g file which enables me to use the local database (hive).
I also have the comma-separated values(csv) ripper in the backend which takes each row of the CSV file called currentCsvFile1 and puts them into a node. 
Within the backend I have the business class and all methods within the file too. This business class holds the values I use/manipulate during the game.

In the display pages are the start-up page which is the first page the user sees. This page gets information from the cloud database (firebase/firestore).
In the game page file, this is what the user sees when they choose to play the game. This page has access to both the hive database and the firestore database. 

In the services folder I have the firebase options and the firestore class and methods. Both the game page and the start-up page use this file to communicate with the database to perform CRUD tasks.
In the main file it loads the start-up page and initiates the creation of the nodes plus the cloud database communications.

dependencies:
flutter:
sdk: flutter
hive: ^2.0.4
hive_flutter: ^1.1.0
intl: ^0.18.0
audioplayers: ^0.20.1

cupertino_icons: ^1.0.8
firebase_core: ^3.9.0
cloud_firestore: ^5.6.0

dev_dependencies:
flutter_test:
sdk: flutter
hive_generator: ^1.1.0
build_runner: ^2.0.5

flutter_lints: ^4.0.0

This is a business game which asks the users questions with 3 possible answers that the user can choose from.
There are business values that change after each decision made and they influence the sales made for the business.

I made a map for the which helped me plan questions and have a path. The map I have added in a download within the folder.
