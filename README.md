# iOS Swift Project - Legend Wings - *EverWing's Mini Clone*

**EverWing** is a popular action game. Survive as much you can, earn gold, and upgrade/purchase new characters.

## Videos - Alpha v3.5.1 - Date Recorded: 07/08/2017:
<p>
<img src='https://github.com/woguan/Legend-Wings/blob/master/Angelica%20Fighti/Gif/v3_5_1-1.gif' title='Intro Video' width='200' height='357' alt='Intro Video' /> <img src='https://github.com/woguan/Legend-Wings/blob/master/Angelica%20Fighti/Gif/v3_5_1-2.gif' width='200' height='357'/> <img src='https://github.com/woguan/Legend-Wings/blob/master/Angelica%20Fighti/Gif/v3_5_1-3.gif' width='200' height='357'/> <img src='https://github.com/woguan/Legend-Wings/blob/master/Angelica%20Fighti/Gif/v3_5_1-4.gif' width='200' height='357'/>
</p><br>

## Videos - Alpha v3.0.4 - Date Recorded: 06/20/2017:
<p>
<img src='https://github.com/woguan/Legend-Wings/blob/master/Angelica%20Fighti/Gif/Intro.gif' title='Intro Video' width='200' height='357' alt='Intro Video' /> <img src='https://github.com/woguan/Legend-Wings/blob/master/Angelica%20Fighti/Gif/selection.gif' width='200' height='357'/> <img src='https://github.com/woguan/Legend-Wings/blob/master/Angelica%20Fighti/Gif/startgame.gif' width='200' height='357'/> <img src='https://github.com/woguan/Legend-Wings/blob/master/Angelica%20Fighti/Gif/midgame.gif' width='200' height='357'/>
</p><br>

Next video update on: <b> Alpha v4.0.0 </b>

## Notes:
- Xcode Version: <b>9.0 Beta 2</b>| Latest iOS: <b>10.3</b>
- Using Xcode's simulator will be a bit laggy. Use Device for best experience.
- Current version: <b>Alpha v3.5.3</b>.
- <b>*Best experience with iPhone 7 Plus. </b>
 
#### Message from developer [07/18/2017]:
> This week I had attended many meetings, and due to lack of time, I did not work on the treant class. I have finished the sprites for treant. But, I want to let you know that this project will slow down significantly since I am working on other projects.<Br>
I have received many private messages about using the source code, so I will use this place to answer it.<Br>
Even though this is an open source project, but this does <b>NOT</b> mean you can use it for commercial-purpose or publish on AppStore by re-skin/re-modeling the sprites. The main purpose of this project is to show what we can achieve with the Apple's SpriteKit and it is also my hobby to do so. Of course, if your purpose is just to learn and/or practice, you are free to use the code as you like. 

## TODO list:
   - [✔️] Add Basic Magnetic Field on Characters - <b>07/08/2017</b>
   - [✔️] Replace regular monsters - <b>07/12/2017</b>
      - [✔️] Add new regular monsters sprites - <b>07/11/2017</b>
        - [✔️] Redder - <b>07/11/2017</b>
        - [✔️] Grenner - <b>07/11/2017</b>
        - [✔️] Bluer - <b>07/11/2017</b>
        - [✔️] Pupler - <b>07/11/2017</b>
   - [*] Add new Boss
     - [*] Add Treant Sprites
     - [] Add Class for Treant
     - [] Add Actions for Treant
   - [*] Re-work on difficulty over time
   
[*] = Working [✔️] = Done

## Future Implementations:
- ### About to join TODO List (Order does not matter):
   - [] Add new drops from monsters (diamonds, trophy... etc?)
      - [] Gems (Red, Green, Purple)
   - [] Add new map
   - [] Re-work drop system. 
   - [] Add chance to summon shiny regular monster. (They drop Power-Ups)
   - [] Add Power-Ups
      - [] Imune Item
      - [] Increase Fire Power
      - [] Double Shoot
- ### High Priority (Order does not matter):
   - [] Add Level&Exp System for Account
      - [] Customized UI Progress Bar
      - [] Show level on the Badge
      - [] Show Current Percentage on the Badge
    - [] Add Game Over Scene
- ### Low Priority (Order does not matter):
   - [] Add Purchase Character Function
   - [] Add Companions System (Each side with a small minion to assist you) - Sidekicks!
   - [] Add new effect for character's death
   - [] Add sound when Fireball is incoming
   - [] Pinky constant speed
   - [] Add Unit Test
   - [] Add Character unique skills
   - [] Add new FX for character's bullets

Note: Each new feature moves from Low Priority -> High Priority -> Todo List. In short, low priority items will go up.

## Discovered Bugs:
- Pinky completly freeze itself when it kills the player

#### Note about bugs:
Unless it crashes the game. Above bugs are put in low priority to be fixed. 

## Main Accomplishments:
- [✔️] Add support for iPhone 5, iPhone 6, iPhone 6 Plus, iPhone 7, iPhone 7 Plus 
- [✔️] Preload Textures
  - [✔️] Add progress bar
  - [✔️] Divide Atlas into smaller atlas
- [✔️] Coin System
- [✔️] Character Selection
  - [✔️] Alpha
  - [✔️] Beta
  - [✔️] Celta
  - [✔️] Delta
- [✔️] Add Backup Logic
- [✔️] Add Progress Track
- [✔️] Add Singleton Global to access all Sprites
- [✔️] Add shader to fonts (OpenGL)
- [✔️] Remove Main.storyboard for faster build time
- [✔️] Add Bomber Boss in-game
- [✔️] Add Pinky Boss in-game - <b>06/28/2017</b>
  - [✔️] Add Pinky Boss Sprites
  - [✔️] Add Pinky Boss Actions
- [✔️] Add Labels in Character Selection - <b>06/28/2017</b>
- [✔️] Add particle effects when selecting character - <b>06/29/2017</b>
- [✔️] "Fix" and find a better logic for the top bar which displays account progress <b>06/30/2017</b>
- [✔️] Add customized font ttf for Gold Label with OpenGL shader <b>06/30/2017</b>
- [✔️] Re-implement logic to increase enemies' HP and Velocity over time  <b>07/03/2017</b>
- [✔️] Add new bullets for characters:
  - [✔️] Add Alpha Bullet Sprites <b> 07/04/2017 </b>
  - [✔️] Add Beta Bullet Sprites <b> 07/04/2017 </b>
  - [✔️] Add Celta Bullet Sprites <b> 07/04/2017 </b>
  - [✔️] Add Delta Bullet Sprites <b> 07/04/2017 </b>
- [✔️] Add Class to create custom bullet sprite <b> 07/04/2017 </b>
  - [✔️] Add Bullet Power Logic - <b> 07/08/2017 </b>
  - [✔️] Add Upgrade Bullet Function - <b> 07/08/2017 </b>
  - [✔️] Add Upgrade Scene on Character Scene <b> 07/05/2017 </b>
- [✔️] Display current level of bullet and its image on Character Scene <b> 07/05/2017 </b>

