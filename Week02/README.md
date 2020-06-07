# BullsEye App
[About](#about)<br/>
[Biography](#bio)<br/>
[App Details](#app)<br/>
[Screenshots](#screenshots)<br/>
</br>
## About
<a name = "about" /> This project refactors the original **BullsEye app** code to implement MVC design pattern. A model **BullsEyeGame** (**UI-independent** ) is implemented which contains the game logic.  ViewController is refactored to use the **BullsEyeGame** object and presents the game on the screen. The same **BullsEyeGame** is used to implement **RGBullsEye** and **RevBullsEye**.

## Biography 
<a name = "bio" /> 
<img align = "right" src="../Bio-Image.png" width="245" height="350">  

**Name** - Shruti Sharma <br/>
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
- [x] When you’re finished, **ViewController** will contain only code that creates a **BullsEyeGame** object, then uses its properties and methods to present the game on the screen. 
- [x] The game itself will work exactly the same.
- [x] **A Treat: BullsEye Hint** - Add a hint to BullsEye. It sets the slider’s minimum track tint color to blue with alpha set to difference/100. This means the minimum track tint color fades to white as the slider thumb gets closer to the correct position. 

### Basic Functional Requirements - RGBullsEye

- [x] To test your game model created in BullsEye, modify it to handle a 3-slider variation of BullsEye. The target is a random RGB color. The user drags the R, G, B sliders to try to match the target.
- [x] Modify your BullsEyeGame and ViewController code to implement **RGBullsEye**. If you’re doing it right, you won’t need to change much beyond using RGB objects instead of numbers.

### Optional Stretch Goals - RevBullsEye 

- [x]  **Reverse the BullsEye game**. Instead of moving the slider to match a displayed number, the game presents the slider with its thumb already positioned at the target value. The user then enters a guess for that value in a text field.
- [x] This app uses the **same BullsEyeGame model** used in original BullsEye to implement the game logic.
- [x] **To help the user**, a colored view with help text appears above the textfield as soon as the user starts typing in. This view's color changes to the red and text to 'Warm' or 'Warmer' if the user is moving closer to the target. Conversely its color changes to the blue and text to 'Cold' or 'Colder' if the user is moving away from the target.

### Additional Features - Three in One BullsEye 
- [x] This app contains all the three variations of BullsEye game - **'Classic BullsEye', 'RGBullsEye' and 'RevBullsEye'**.
- [x] The project contains a **base class for game model named GameLogic** which contains common functionality for all the three games.
- [x] It uses a model **RGBullsEyeGameLogic which inherits from the GameLogic model** to use 'RGB' objects for target and calculate the difference between guess and target.
- [x] It also uses a **model BullsEyeGameLogic which inherits from the GameLogic** to use 'Int' values for target and calculate the difference between guess and target.
- [x] **A Treat: BullsEye Hint** - To hint the user a box appears around the slider which changes its color to red if the user is moving closer to the target. Conversely its color changes to blue if the user is moving away from the target.



## Screenshots
<a name = "screenshots" />

### iPhone

### iPad
