This documentation goes through then implementation decisions I made to build my Five Crowns game for the three biggest factors of the game.

IMPORTANT VOCAB:
	lones': the cards in a hand which have no pairs (are lonely)
    	'doubles': a pairs of cards of the same number or value
    	'sets': three or more cards of the same number/value
   	'going out': having no lones or doubles (you can have a double if there's a wild to go with it)

BASIC OPENING OPERATIONS:
First, there is the love.load function, which is run first. Here, all the cards in the deck are created (with information about the value of the card, the suit, and the quad which represents the image of the card) and put into the deck. The deck is then shuffled using a helper function, and activates the function roundChange which is essential to a card game with many rounds.
	In this function, which is called every new round, it first sees if we are at round 14, which means it is the end of the game, and executes the endGame function which of course ends the game. If it’s a normal round, the program creates three objects: two computers and a player. I decided to program only two computers because it adds the complexity of having multiple players without an overwhelming amount. In the future, I’d like to add functionality which lets the user choose how many players they want to play against. This function then distributes cards based on the round and one card in the discard pile. It ends with having the player (the human) take a turn. 
	The function playerTurn basically just sports the players cards using the prepare function, which sorts any objects cards into four categories: wilds, sets, doubles, and lones. I did this so that it is easier to figure out if an object has won, and makes the calculations for the AI playing possible (you can see what these mean in the README document). For the player, it’s more for visual aesthetics and for calculating winning. The playerTurn function also opens up the possibility for user input from the love.keypressed function, which highlights, adds, and removes different cards according to the players arrow key and esc inputs. This function also holds the functionality which lets the player ‘click any button to continue or reset’ after every round. When the return button is pressed, it also moves on to the computer turn.

COMPUTER AI/HOW A COMPUTER PLAYS FIVE CROWNS:
	I think that the main crux of this program is ‘how do you make a computer play this game?’. This is how I implemented it: 
	The computer first sorts its given cards using the prepare function, so it knows what are wilds, sets, doubles, and lones. Then it must decide whether to pick a card from the discard pile or from the deck. If the card in the discard pile is a wild or matches any of the cards in its hand, then it will take it. If not, than it will take a card from the deck. This is not necessarily always a good thing for it, because sometimes human players make these decisions not only based on what they have, but on how many points they’re trying to get rid of.
	Once they’ve taken a card, they must decide which card to eliminate. First, they look to see if they have any lones. If so, they will discard the highest lone. If they’re no lones, than it will look at the doubles and take the lowest value one, and discard one of those. Unless there are no wilds to add to those doubles, than it will discard the double of the highest value. If there are no doubles, it looks at the sets. If there is a set with more than three cards, it will discard that excess card. If all the sets have three cards, it will choose the smallest value one and discard one from that. The hand gets sorted again so that everything is in the proper place. Then it must check to see if it has won that round, or ‘gone out’. I figured out an equation to tell if anyone has gone out, which is:

	number of wilds >= (number doubles / 2) + (2 * number of lones)

	If this statement is true, then we know someone has gone out, and then executes the round winning function which adds all the points of the cards, and displays the round winning hand. If they haven’t won, then it moves to the next player.

HOW THE CARDS ARE DISPLAYED:
	This was something that I found someone more complicated than I expected, since the cards in a player’s hand or the cards the display at the end of every round need to be centered. Here’s how I did it (keep in mind that this is all in the render function for the player and the computer, or in the love.draw function).
	First it decides how far apart the cards should be spaced. This is so that when the hands gets really big (up to 14 cards) the cards can overlap as to stay within the screen. Next it finds the full width of this image block that it’s trying to create, basically how long is this line of cards going to be. This is found using the equation:

full width = (card width * number of cards in hand) +  (space width * number of cards in hand - 1) 

	It then finds the x coordinate where this block should start (or ‘a’) using:

a = .5 * (width of screen - fill width)

	It then figures out each card’s x value:

card x value = a + ((index of card in the hand - 1) * (width of card + space width))

	This creates a block where the cards are equally spaced and centered on the screen.


These are all the basic factors which operates under the hood of the Five Crowns game. For a deeper look, you can open the source code at https://github.com/rkruse9/Five_Crowns_Game for comments on every function and variable in the game.
	
