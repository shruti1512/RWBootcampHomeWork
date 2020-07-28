# JQuiz App
[About](#about)<br/>
[Screenshots](#screenshots)<br/>
[App Details](#app)<br/>
</br>

## About
<a name = "about" />This is a game wherein multiple questions and clues from different categories are displayed. If the users selects correct answer the score is updated accordingly. The game fetcehs dat from jservice api.

## Screenshots
<a name = "screenshots" />  



<img src="Screenshots/jQuiz.gif" width="200" height="400"> 

## App Details
<a name = "app" /> 

### Basic Requirements

- [x] Get a random category. Make a GET request to http://www.jservice.io/api/random. 
- [x] Make structs for `Category` and `Clue`. Use the JSON to know what properties to add.
  The URL above will return a `Clue`, which has a `Category`.
- [x] Use a CompletionHandler to return a categoryId for the next Network call. Since the API doesn’t return a list of answers for multiple choice, we’re going to get 4 questions all from the same Category, so that we can display 4 similar answers. You don’t want to make the networking call to get 4 more clues until you have the categoryId, so a completion handler will help you wait until the first networking function is completed before doing the second one.
- [x] When you return an array of [Clue] from getAllCluesInCategory, limit the number of clues to 4.
- [x] Make sure the clue that has the correct answer is different every time!  You can use a random number generator for this, just make sure not to go outside of the array.
- [x] Set up your ViewController to display a clue’s category, question, and set up a tableview or collectionview to show the answers for all 4 of the clues in your array.
- [x] If the user selects the cell with the correct answer, award them points and show their score at the bottom of the screen, then gets a new category with 4 new clues. If they select the wrong answer, then just get a new category with 4 new clues to make a new question, no points are awarded.
- [x] You can set up your view with any design pattern you prefer. You can have a GameObject like in Bullseye and use MVC, or you can use MVVM and set up a viewmodel.
- [x] Download this image at https://cdn1.edgedatg.com/aws/v2/abc/ABCUpdates/blog/2900129/8484c3386d4378d7c
  826e3f3690b481b/1600x900-Q90_8484c3386d4378d7c826e3f3690b481b.jpg and put it
  at the top of the screen.

###  Stretch Goals 

- [x] There’s an mp3 of the Jeopardy! Theme song in the Assets folder. Add a button at the bottom of the screen and make a SoundManager class to play music.
- [x] If the user presses the button, change the icon to indicate that the music is muted and stop the instance of `AVAudioPlayer`.
- [x] Save whether the user wants sound enabled in UserDefaults.
- [x] Take your `Clue` and `Category` structs and conform them to “codable”.  Use JSONDecoder to decode json Data.
- [x] Use CodingKeys to change `category_id` to `categoryId` and `value` to `points`.
- [x] Cache downloaded image.

### Additional Features
- [x] User Interface of the view is modified to match the jeopardy game theme.
- [x] Animation for correct answer selection added.
- [x] Animation for score added.
- [x] Sound plays on correct and incorerct anwer selection.

