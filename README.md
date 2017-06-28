# iOS Swift Project - Legend Wings - *EverWing's Mini Clone*

**EverWing** is a popular action game. Survive as much you can, earn gold, and upgrade/purchase new characters.

## Videos:
<p>
<img src='https://github.com/woguan/Legend-Wings/blob/master/Angelica%20Fighti/Gif/Intro.gif' title='Intro Video' width='200' height='357' alt='Intro Video' /> <img src='https://github.com/woguan/Legend-Wings/blob/master/Angelica%20Fighti/Gif/selection.gif' width='200' height='357'/> <img src='https://github.com/woguan/Legend-Wings/blob/master/Angelica%20Fighti/Gif/startgame.gif' width='200' height='357'/> <img src='https://github.com/woguan/Legend-Wings/blob/master/Angelica%20Fighti/Gif/midgame.gif' width='200' height='357'/>

## Notes:
- Xcode Version: 8.3.3 | Latest iOS 10.3
- Using Xcode's simulator will be a bit laggy. Use Device for best experience.

## New TODO list:
- [✔️] Add Pinky Boss in-game - <b>06/28/2017</b>
  - [✔️] Add Pinky Boss Sprites
  - [✔️] Add Pinky Boss Actions
- [] Add Labels in Character Selection
- [] Add particle effects when selecting character
- [] "Fix" and find a better logic for the top bar which displays account progress
- [] Re-implement logic to increase enemies' HP and Velocity over time. 
- [] Add Power-Ups
  - [] Imune Item
  - [] Increare Fire Power
  - [] Double Shoot
- [] Add Companions System (Each side has a small minion to assist you) - Sidekicks!
- [] Add Unit Test

## Known Bugs:
- The top bar is not a bug. I'm just thinking a good approach for displaying them
- It looks like that for smaller devices such as iPhone 5, the monsters are dying quickly.
- HUD displays are not "pretty". I think it's a bit challenging for creating a HUD from sknodes. Thus, in near future, I will replace them with custom OTF/TTF files. I'm still looking for a good software to generate them.
- Characters are too big in smaller devices. This is known issue due for using "fixed" size. It will be fixed later on.

## Main Accomplishments:
- [✔️] Added for iPhone 5, iPhone 6, iPhone 6 Plus, iPhone 7, iPhone 7 Plus 
- [✔️] Preload Textures
  - [✔️] Added progress bar
  - [✔️] Divided Atlas into smaller atlas
- [✔️] Coin System
- [✔️] Character Selection
  - [✔️] Alpha
  - [✔️] Beta
  - [✔️] Celta
  - [✔️] Delta
- [✔️] Added Backup Logic
- [✔️] Added Progress Track
- [✔️] Added Singleton Global to access all Sprites
- [✔️] Removed Main.storyboard for faster build time

  
