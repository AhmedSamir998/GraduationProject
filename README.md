# QuranSearchAndMemorization
This iOS Application is a part of My Graduation Project for Computer Science Departement at Faculty of Computers and Information – Helwan University. It’s also a Graduation Project for Udacity iOS Developer Nano Degree.

## How to run this Project
Just clone or download this project on your machine and open `Quran.xcworkspace` file and run it.
### This Project is built using:
-	XCode 9.2
-	Swift 4.0

## Application Scenes:
-	**SurasViewController**: This is a Table View contains all the 114 Suras, you can see each Sura’s Name, Chapter, and location (Mecca or Madina). You should select the Sura which you want to read and recite it’s specified verses. After clicking on it, a sub view will pop-up to choose verses range (for Ex: you want to recite “Al Fatihah” Sura only from verse 1 to verse 5). You will find 2 picker view which help you to do that.
-	**QuranReadingViewController**:  In this view you will find your chosen verses text to revise it before recitation. You will find also Sura’s Name and Chapter above the Verses. You can click `Start Recitation` Button after being ready.
-	**QuranRecitationViewController**: in this view you can recite the verses using Speech Recognition techniques by clicking on the green button. After finishing click on it again and the Verses text will appear with colors (Green for correct words which you say, and Red for wrong ones). You will get also a percentage of your Goodness in Memorizing this verses.
-	**PrayerTimesViewController**: This view will help you to know Today’s Pray Times depending on your City.
-	**SearchQuranViewController**: You will be allowed to search for specific words/verses in the Holy Quran and you will get a list of each Verse that contains your query and full Information about this Verse. 


# Rules for contributing:

Just write the following in your terminal after entering to the Project Directory

- `git add .` to add all of the files you changed or `git add FILE_NAME` where `FILE_NAME` is a single file you changed.
- `git commit -m "COMMIT_MESSAGE"` where `COMMIT_MESSAGE` could be `bug fix` for example.
- `git push` to push your work to your branch.

