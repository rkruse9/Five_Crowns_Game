# Five_Crowns_Game

HOW TO RUN FIVE CROWNS:

1. This game runs using the LOVE game framework, so first you’ll need to download that. Head on over to https://love2d.org/ and download LOVE for your operating system. The steps to download are on that website(even though all you really need to do is to press the download button). You’ll know that you’ve downloaded it correctly if, when you click on the LOVE application (either on your Desktop or in your Applications folder) you see a bird balloon hybrid that says ‘NO GAME’. 

2. There are two important files which you will now need, however one is just a backup solution if the easier one does not work. These two files are ‘FiveCrownsMac.love.zip’ and ‘FiveCrownsMac.zip’. These files should have been in the folder which was submitted through the CS50 IDE. Download both of these files. If you are unable (or unwilling) to download these files from the IDE, you can also get these files on my gitHub at https://github.com/rkruse9/Five_Crowns_Game, where they are called the same thing. Make sure to unzip them as well (you can trash the zipped files of course).

3. Once you have those two files downloaded onto your computer (make sure that your computer actually does download them, I promise I’m not giving anyone any viruses), the next step is simple! If you have downloaded everything correctly, all you need to do is to click on the ‘FiveCrowns.love’ application, and the game should run! Make sure you are clicking on the ‘FiveCrowns.love’ application, NOT the LOVE application and NOT the ‘FiveCrowns’ folder from the ‘FiveCrowns.zip’ file. If that works (which it should) then you can go ahead and chuck that ‘FiveCrowns’ folder from the ‘FiveCrowns.zip’ file, you don’t need it! You still need the LOVE application though.

4. If this does not work for you, or you cannot acquire the ‘FiveCrowns.love’ application, then you will need the ‘FiveCrowns’ folder from the ‘FiveCrowns.zip’ file. If you’re on windows, make sure that when you unzip the folder you use the 'FiveCrowns' folder, not the MACOS_ folder. All you need to do is drag that folder ON TOP of the LOVE application, and release. This will open the file in LOVE. That FiveCrowns folder also contains all the source code for the project.

HOW TO PLAY FIVE CROWN/RULES:

*Most of these rules are copied from https://www.setgame.com/sites/default/files/instructions/FIVE%20CROWNS%20-%20ENGLISH_0.pdf

OBJECTIVE: To obtain the lowest number of points after playing all eleven hands of the game. 

THE CARDS: The game consists of two 55-card decks. Each deck has five suits: stars , hearts ♥, clubs ♣, spades ♠, and diamonds ♦. Each suit has eleven cards: 3 through 10, Jack, Queen and King. 

CARD VALUES: Each number card is worth its face value, the Jacks are 11 points, Queens are 12, Kings are 13. The wild card changes from hand to hand. For each hand, the card that matches the number of cards dealt in the hand is wild. Thus, when three cards are dealt, the 3s are wild, when four cards are dealt, the 4s are wild, and so on until the last hand when the Kings are wild. 

SETS: A set consists of three or more cards of the same value regardless of suit, e.g., 8♣, 8, 8♠, or K♠, K♦, K♥, K♥. Any card in a set can be replaced by any wild card. For example, if 8s are wild, then a set could be 8♠, Q♠, Q. You can have as many wild cards in a set as you wish. 

THE PLAYERS: There are three players in this game. One is, well, you the human. The other two are computers which are programmed on how to play. 

THE PLAY: You start the game on round three with three cards. The human always goes first. Each turn starts with either drawing a card from the deck or picking up the top card from the discard pile. You can do this by using the LEFT and RIGHT arrow keys to select whether you want to choose from the discard pile or the deck, and hitting enter/return to actually pick it. The turn is completed by discarding one card, which you can again do by highlighting the card you want  to eliminate with the arrow keys and pressing enter. The computers will also do this, even though it happens very fast and you won’t be able to see it (trust me they are playing). When a player or computer is able to go out (see GOING OUT), the remaining players each have one last turn. Each remaining player, in turn, will either draw from the deck or pick up the top discard. The player will then lay down all his/her sets, discard one card, and count the cards remaining in his/her hand as points against him/her. The program will do all of this for you. The value of the cards on the table does not matter, only cards remaining unused in the hand are counted. The program will keep a talley and shows it on screen. The number of cards dealt increases by one card each deal, and the wild card changes as described above. Play continues until the eleventh hand when the Kings are wild. Low score wins. 

GOING OUT: After drawing from the deck or picking up the top card from the discard pile, if a player is able to arrange all the cards in his/her hand into sets with one card remaining, he/she lays the cards down and discards the one card to go out. The discard can be a card that could have been played on the cards laid down. The program will do this for you, and will let you know if you have gone out.
