# BullsEye App
[About](#about)<br/>
[Biography](#bio)<br/>
[App Details](#app)<br/>
[Screenshots](#screenshots)<br/>
</br>

## About
<a name = "about" /> This project refactors the original **Bull's Eye app** code to implement MVC design pattern. A model struct **BullsEyeGame** (UI-independent ) is implemented which contains the game logic.  ViewController is refactored to use this model object and present the game on the screen. The same model is used to implement **RGB Bull's Eye** and **Reverse Bull's Eye**.

__Bonus__: The third app **ThreeInOneBullsEye** combines all three apps into one to demonstrate the UI independence of the model and to introduce some advanced concepts. 

#### Struct or Class for BullsEyeGame model







## Biography 
<a name = "bio" /> 
<img align = "right" src="../Bio-Image.png" width="245" height="350"> **Name** - Shruti Sharma <br/>
**Discord Name** - TK:Shruti <br/>
**Basic Location** - Los Angeles (USA/CA) <br/>
**Programming experience** - 6 yrs as iOS Developer in Objective C <br/>
**Hobbies and Interests** - Reading, Cooking, Playing tennis <br/>
**Goals**

- Get proficient in iOS Development 

- Learn how to drive 

- Workout more often 

- Practise mediation more 

- Travel around the world

  

## App Details
<a name = "app" /> 

### Basic Functional Requirements - BullsEye

- [x] Move the game logic out of the view controller into a **BullsEyeGame** type. 
- [x] Create a new Swift file (not Cocoa Touch). This file imports **Foundation**, not UIKit. BullsEyeGame is your **UI-independent model** type, so you should not write any UIKit code in it!
- [x] Refactor the code in **ViewController** and in **BullsEyeGame** into new or modified methods. 
- [x] **ViewController** will contain only code that creates a **BullsEyeGame** object, then uses its properties and methods to present the game on the screen. 
- [x] The game itself will work exactly the same.
- [x] **A Treat: BullsEye Hint** - Add a hint to BullsEye. It sets the slider’s minimum track tint color to blue with alpha set to difference/100. This means the minimum track tint color fades to white as the slider thumb gets closer to the correct position. 

### Basic Functional Requirements - RGBullsEye

- [x] To test your game model created in BullsEye, modify it to handle a 3-slider variation of BullsEye. The target is a random RGB color. The user drags the R, G, B sliders to try to match the target.
- [x] Modify your BullsEyeGame and ViewController code to implement **RGBullsEye**. If you’re doing it right, you won’t need to change much beyond using RGB objects instead of numbers.

### Optional Stretch Goals - RevBullsEye 

- [x]  **Reverse the BullsEye game**. Instead of moving the slider to match a displayed number, the game presents the slider with its thumb already positioned at the target value. The user then enters a guess for that value in a text field.
- [x] This app uses the **same BullsEyeGame model** used in original BullsEye to implement the game logic.
- [x] **To help the user**, a colored view with help text appears above the textfield as soon as the user starts typing in. This view's color changes to the red and text to 'Warm' or 'Warmer' if the user is moving closer to the target. Conversely its color changes to the blue and text to 'Cold' or 'Colder' if the user is moving away from the target.

### Additional Features - ThreeInOne BullsEye 
- [x] This app contains all the three variations of BullsEye game - **Classic BullsEye, RG BullsEye and Rev BullsEye**. 
- [x] This project uses concept of **Generics** to handle variation of game logic target values for all three games.
- [x] **BullsEye Hint** - The hint is now a gradient colored box which changes color from blue (cold) to red (warm) based on the distance between the guess and the target. In Classic Bull's Eye, this box appears around the slider, and in Reverse Bulls Eye this box appears on top with the text associated with the color.

## Screenshots
<a name = "screenshots" />

<img src="Screenshots/Menu-Screen.png" width="400" height="200">  <img src="Screenshots/Classic-BullsEye.png" width="400" height="200"> <img src="Screenshots/Rev-BullsEye.png" width="400" height="200"> <img src="Screenshots/RGB-BullsEye.png" width="400" height="200"> <img src="Screenshots/Alert.png" width="400" height="200"> <img src="Screenshots/Info-Screen.png" width="400" height="200">

