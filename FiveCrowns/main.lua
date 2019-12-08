

--[[
    This is the main function for my Five Crowns game.
    Important Vocab:
    'lones': the cards in a hand which have no pairs (are lonely)
    'doubles': a pairs of cards of the same number or value
    'sets': three or more of card of the same number/vaue
    'going out': having no lones or doubles (you can have a double
    if there's a wild to go with it)
]]



--requires all the classes
Class = require 'class'
require 'Util'
require 'Card'
require 'Ai'
require 'Player'

--resizes the window
love.window.setMode(1280, 720)

--loads all the images and divides the deck into quads
cardBack = love.graphics.newImage('Card Back.png')
highlightPic = love.graphics.newImage('highlightPic.png')
winnerBack = love.graphics.newImage('winnerBack.png')
deckSheet = love.graphics.newImage('Deck.png')
cardArray = generateQuads(deckSheet,100,150)

--initiates all the boolean variables
playerChoose = false
playerDiscard = false
someoneOut = false
gameFinished = false
title = true
instructionOn = false
showWinner = false

--initiates all constants
SCREEN_WIDTH = love.graphics.getWidth( )
SCREEN_HEIGHT = love.graphics.getHeight( )
CARD_HEIGHT = 150
CARD_WIDTH  = 100

--initiates the table storing each player's points
playerPoints = {0}
AiOnePoints = {0}
AiTwoPoints = {0}

--initiates the round number (or how many cards are given)
round = 3

--initiates the index of the card in the player's deck which is highlighted
highValue = 1

--initiates which pile the player can choose to take from
pickUpselected = 'discardCard'

--loads all the fonts
largeTitle = love.graphics.newFont('font.ttf', 150)
smallFont = love.graphics.newFont('font.ttf', 30)
mediumFont = love.graphics.newFont('font.ttf', 70)

function love.load()
    
    love.graphics.setFont(smallFont)
    math.randomseed(os.time())

    --sets title of the window
    love.window.setTitle('Five Crowns')

    
    --creates a table to house the deck and one to house the discard pile
    oldDeck = {}
    upface = {}

    --creates all the cards and puts them into the deck
    local count = 1
    for x = 1, 2 do
        for y = 3, 13 do
            for s = 1, 5 do
                if s == 1 then
                    oldDeck[count] = Card(y,'S', cardArray[(y-3) * 5 + s])
                elseif s == 2 then
                    oldDeck[count] = Card(y,'H', cardArray[(y-3) * 5 + s])
                elseif s == 3 then
                    oldDeck[count] = Card(y,'P', cardArray[(y-3) * 5 + s])
                elseif s == 4 then
                    oldDeck[count] = Card(y,'D', cardArray[(y-3) * 5 + s])
                elseif s == 5 then
                    oldDeck[count] = Card(y,'C', cardArray[(y-3) * 5 + s])
                end
                count = count + 1
            end
        end
    end

    --shuffles the deck
    oldDeck = shuffle(oldDeck)

    --changes the round
    roundChange()

end

--executed for the computers to take their turn
function computerTurn(object)

    --organizes and sorts each computers' hand
    prepare(object)
    --decides whether to take a card from the deck or the discard pile
    object:decide()
    
    prepare(object)

    --chooses which card to elimate from the hand
    object:eliminate()
    prepare(object)

    --checks to see if someone is out
    if someoneOut == false then

        --if not, check to see if the computer is out
        if checkWin(object) then
            someoneWon(object)
        else
            --if not, tell the next user to go
            if object == AiOne then
                computerTurn(AiTwo)
            else
                playerTurn()
            end
        end
    end
end


--changes the round
function roundChange()
    --if the round is past 13, then end the game
    if round == 14 then
        endGame()
    else
        --if not, create two computer objects and one player object
        someoneOut = false
        AiOne = Ai()
        AiTwo = Ai()
        AiOne.title = 'C1'
        AiTwo.title = 'C2'
        player = Player()

        --distributes the cards into each players hands 
        for x = 1, round do
            player.deck[x] = oldDeck[x]
            table.remove(oldDeck,x)
            AiOne.deck[x] = oldDeck[x+3]
            table.remove(oldDeck, x + 3)
            AiTwo.deck[x] = oldDeck[x+6]
            table.remove(oldDeck, x + 6)
        end

        --places one card from the deck into the 'upface' (discard) pile
        table.insert(upface, 1, oldDeck[1])
        table.remove(oldDeck,1)

        if title == false then
            --starts with the player's turn
            playerTurn()
        end
    end
end



--execute when it is the human's turn
function playerTurn()
    pickUpselected = 'discardCard'
    upface[1].highlight = true
    playerChoose = true
    --sorts the player's hand
    prepare(player)
end


--changes boolean variables if someone has won the round
function someoneWon(object)
    someoneOut = true
    showWinner = true
end

--the draw funtion for the program
function love.draw()

    love.graphics.printf(string, 10, 10, 1280, 'left')

    --if the instructions should be up, then print the instructions
    if instructionsOn then
        love.graphics.printf({{224/255, 227/255, 39/255},'instructions soon to come'}, 0, 380, 1280,'center')

    --else if thhe title should be up, draw/print the title screen
    elseif title then
        love.graphics.clear(105/255, 0, 147/255)
        love.graphics.setFont(largeTitle)
        love.graphics.printf({{224/255, 227/255, 39/255},'FIVE'}, 0, 20, 1280,'center')
        love.graphics.printf({{224/255, 227/255, 39/255},'CROWNS'}, 0, 200, 1280,'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf({{224/255, 227/255, 39/255},'Programmed by R. Taylor Kruse'}, 0, 380, 1280,'center')
        love.graphics.printf({{1,1,1},'Press "p" to play'}, 0, 450, 1280,'center')
        love.graphics.printf({{1,1,1},'Press "i" for instructions'}, 0, 525, 1280,'center')
        love.graphics.printf({{1,1,1},'Press "Esc" at any time to quit the game'}, 0, 600, 1280,'center')
        
        --add two 'random' cards to the screen for athestic purposes
        love.graphics.draw(deckSheet, oldDeck[4].quad, SCREEN_WIDTH/8 - CARD_WIDTH/2, SCREEN_HEIGHT/2 - CARD_HEIGHT/2)
        love.graphics.draw(deckSheet, oldDeck[5].quad, 7 * SCREEN_WIDTH/8 - CARD_WIDTH/2, SCREEN_HEIGHT/2 - CARD_HEIGHT/2)

    else
        --if you're in game play:

        --make the background green
        love.graphics.clear(50/255, 168/255, 82/255)

        -- upCard is the card at the top of the discard pile
        local upCard = upface[1]
        
        --if it exists:
        if upCard ~= nil then

            --places the card in its proper place
            upCard.x = (SCREEN_WIDTH/2) - CARD_WIDTH - 20
            upCard.y = SCREEN_HEIGHT/2 - CARD_HEIGHT/2

            -- if it's 'highlighted' (meaning the player has selected it) draw a yellow rectangle
            if upface[1].highlight then
                love.graphics.draw(highlightPic, upCard.x - 4, upCard.y - 4)
            end

            --draw the correct card the on the top of the pile
            love.graphics.draw(deckSheet, upCard.quad, upCard.x, upCard.y)

        end

        --same highlight with the deck
        if oldDeck[1].highlight then
            love.graphics.draw(highlightPic, (SCREEN_WIDTH/2) + 16,SCREEN_HEIGHT/2 - CARD_HEIGHT/2 - 4)
        end
 
        --draw the back of a card
        love.graphics.draw(cardBack, (SCREEN_WIDTH/2) + 20, SCREEN_HEIGHT/2 - CARD_HEIGHT/2)


        --renders the player's hand
        player:render()
        --render the two computer hands
        AiOne:render(0, AiOnePoints[#AiOnePoints], -1)
        AiTwo:render(1, AiTwoPoints[#AiTwoPoints], 1)

       

        --prints the round number
        love.graphics.printf('Round ' .. (round - 2), 0, 150, SCREEN_WIDTH, 'center')

        --assessess the type of card and prints that they are wild depending on the round
        if round <= 10 then
            cardType = round
        elseif round == 11 then
            cardType = 'Jack'
        elseif round == 12 then
            cardType = 'Queen'
        elseif round == 13 then
            cardType = 'King'
        end
        
        love.graphics.printf(cardType .. 's are wild!', 0, 200, SCREEN_WIDTH, 'center')


    end

    
    --when someone goes out, it will print a screen with all 
    --their cards to show the others
    if showWinner then
        --print the background
        love.graphics.draw(winnerBack, 40, 35)
        
        local spaceWidth --the same between cards

        --the number of wilds plus the number of doubles plus the number of lones in the winner's hand
        wildDubsLones = #roundWinner.wilds + #roundWinner.doubles + #roundWinner.lones

        --finds what the space width should be
        if wildDubsLones <= 9 then
            spaceWidth = 25
        else
            spaceWidth = -10
        end

        --finds the full width of the image of wilds and doubles
        local fullWidth = (CARD_WIDTH * wildDubsLones) + (spaceWidth * (wildDubsLones - 1))
        --a is what the starting x cooridante should be
        local a = .5 * (SCREEN_WIDTH - fullWidth)

        --prints the wilds
        if #roundWinner.wilds ~= 0 then
            for i=1, #roundWinner.wilds do
                roundWinner.wilds[i].x = a + ((i-1) * (CARD_WIDTH + spaceWidth))
                roundWinner.wilds[i].y = 250
                love.graphics.draw(deckSheet,roundWinner.wilds[i].quad, roundWinner.wilds[i].x, roundWinner.wilds[i].y)
            end
        end
        --prints the lones
        if #roundWinner.lones ~= 0 then
            for i = 1, #roundWinner.lones do
                --makes sure that it is starting in the right place
                roundWinner.lones[i].x = a + ((i + #roundWinner.wilds - 1) * (CARD_WIDTH + spaceWidth)) 
                roundWinner.lones[i].y = 250
                love.graphics.draw(deckSheet,roundWinner.lones[i].quad, roundWinner.lones[i].x, roundWinner.lones[i].y)
            end
        end

        --prints the doubles
        if #roundWinner.doubles ~= 0 then
            for i = 1, #roundWinner.doubles do
                --makes sure that it is starting in the right place
                roundWinner.doubles[i].x = a + ((i + #roundWinner.wilds - 1) * (CARD_WIDTH + spaceWidth)) 
                roundWinner.doubles[i].y = 250
                love.graphics.draw(deckSheet,roundWinner.doubles[i].quad, roundWinner.doubles[i].x, roundWinner.doubles[i].y)
            end
        end
        
        --finds the length of the sets and assesses the spacewidth
        setLength = #roundWinner.sets
        if setLength <= 9 then
            spaceWidth = 25
        else
            spaceWidth = -10
        end

        --does the same for the sets
        local fullWidth = (CARD_WIDTH * setLength) + (spaceWidth * (setLength - 1))
        local a = .5 * (SCREEN_WIDTH - fullWidth)
        
        if setLength ~= 0 then
            for i=1, setLength do
                roundWinner.sets[i].x = a + ((i-1) * (CARD_WIDTH + spaceWidth))
                roundWinner.sets[i].y = 450
                love.graphics.draw(deckSheet,roundWinner.sets[i].quad, roundWinner.sets[i].x, roundWinner.sets[i].y)
            end
        end


        love.graphics.setFont(mediumFont)

        --prints who has gone out and other messages for the human
        love.graphics.printf({{224/255, 227/255, 39/255}, roundWinner.title .. ' has gone out!'}, 0, 100, 1280,'center')

        love.graphics.setFont(smallFont)
        if roundWinner == player then
            love.graphics.printf({{224/255, 227/255, 39/255}, 'Press any key to move to the next round'}, 0, 630, 1280,'center')
        else
            love.graphics.printf({{224/255, 227/255, 39/255}, 'Press any key to take your last turn and move to the next round'}, 0, 630, 1280,'center')
        end

    end

    --messages to print if the game has finished
    if gameFinished then
        love.graphics.draw(winnerBack, 40, 35)
        love.graphics.printf(overallWinner.title .. ' has won with ' .. overallWinner.endPoints .. ' points!', 0, 100, 1280,'center' )
        love.graphics.printf({{224/255, 227/255, 39/255}, 'Press any key to restart the game!'}, 0, 600, 1280,'center')
        love.graphics.printf('Player: ' .. player.endPoints, -200, 300, 1280, 'center')
        love.graphics.printf('C1: ' .. AiOne.endPoints, 0, 300, 1280, 'center')
        love.graphics.printf('C2: ' .. AiTwo.endPoints, 200, 300, 1280, 'center')

    end



end

--executes any commands when the keyboard is pressed
function love.keypressed(key)

    --if esc, then quit the game
    if key == 'escape' then
        love.event.quit()
    end
    
    --only if the title is up
    if title then
        -- press p plays the game
        if key == 'p' then
            title = false
            instructionsOn = false

            playerTurn()

        --pressing i turn's the instructions on
        elseif key == 'i' then
            instructionsOn = true
        end
        
    end

    --if the game is finished, reset it and play again
    if gameFinished then
        gameFinished = false
        playerPoints = {0}
        AiOnePoints = {0}
        AiTwoPoints = {0}
        round = 3
        highValue = 1
        love.load()

    --else if we need to show the round winner, make sure the other
    --two users go one last time and reset the game
    elseif showWinner then
        showWinner = false
        if roundWinner == AiOne then
            computerTurn(AiTwo)
            playerTurn()
        elseif roundWinner == AiTwo then
            computerTurn(AiOne)
            playerTurn()
        elseif roundWinner == player then
            computerTurn(AiOne)
            computerTurn(AiTwo)
            calculatePoints(player, playerPoints)
            calculatePoints(AiOne, AiOnePoints)
            calculatePoints(AiTwo, AiTwoPoints)
            round = round + 1
            love.load()
        end

    --if it is the players turn to choose:
    elseif playerChoose then
        --left or right highlights either the deck or the discard pile
        

        if key == 'right' or key == 'left' then
            if pickUpselected == 'discardCard' then
                pickUpselected = 'deckPile'
                upface[1].highlight = false
                oldDeck[1].highlight = true
            else
                pickUpselected = 'discardCard'
                upface[1].highlight = true
                oldDeck[1].highlight = false
            end
        end
        --return or enter chooses the highlighted card
        if key == 'return' then
            if pickUpselected == 'discardCard' then
                upface[1].highlight = false
                table.insert(player.deck, 1, upface[1])
                table.remove(upface, 1)
            elseif pickUpselected == 'deckPile' then
                oldDeck[1].highlight = false
                table.insert(player.deck, 1, oldDeck[1])
                table.remove(oldDeck, 1)
            end
            --sorts player's hand
            prepare(player)
            
            playerChoose = false
            if upface[1] ~= nil then
                upface[1].highlight = false
            end
            oldDeck[1].highlight = false
            player.deck[highValue].highlight = true
            playerDiscard = true
        end

    --if it it time for the player to discard:
    elseif playerDiscard then
        --makes sure to cancel all highlights so that another can be applied
        

        --left or right hihglihghts the corresponding card
        if key == 'right' then
            player.deck[highValue].highlight = false
            if highValue + 1 > #player.deck then
                highValue = 1
            else 
                highValue = highValue + 1
            end
            player.deck[highValue].highlight = true

        elseif key == 'left' then
            player.deck[highValue].highlight = false
            if highValue - 1 == 0 then
                highValue = #player.deck
            else 
                highValue = highValue - 1
            end
        
            player.deck[highValue].highlight = true
        --return puts the card in the discard pile
        elseif key == 'return' then
            player.deck[highValue].highlight = false
            table.insert(upface, 1, player.deck[highValue])
            table.remove(player.deck, highValue)
            prepare(player)

            playerDiscard = false
            --if someone is not out, check to see if you've won
            if someoneOut == false then
                if checkWin(player) then
                    someoneWon(player)
                else
                    computerTurn(AiOne)
                end
            else
                --if someone has gone out, calculate the points and move
                --to the next round
                calculatePoints(player, playerPoints)
                calculatePoints(AiOne, AiOnePoints)
                calculatePoints(AiTwo, AiTwoPoints)
                round = round + 1
                love.load()
            end

        end
    
    end

end


--shuffles a table
--got this helper function from:
--https://gist.github.com/Uradamus/10323382
function shuffle(t)
    for i = #t, 2, -1 do
      local j = math.random(i)
      t[i], t[j] = t[j], t[i]
    end
    return t
end

--takes in a table and a value and sees if that 
--value is in the table
function findNum (t,v)
    local x
    for x = 1, #t do
        if t[x].number == v then
            return true
        end
    end
    return false
end

--sorts any players' hands
function prepare(object)
    --makes all cards 'unfound'
    resetCards(object.deck)

    --deletes all the cards from each table of wilds,
    --sets, doubles, and lones
    local countD = #object.doubles
    for i=1,countD do object.doubles[i]=nil end

    local countS = #object.sets
    for i=1,countS do object.sets[i]=nil end

    local countW = #object.wilds
    for i=1,countW do object.wilds[i]=nil end

    local countL = #object.lones
    for i=1,countL do object.lones[i]=nil end

    
    
    local x
    
    --sorts all the cards in a hand into four categroeis: 
    --wilds, sets, doubles, and lones
    for x = 1, #object.deck-1 do

        local found = 0
        
        local cardNum = object.deck[x].number
        
        local y

        --first the card is wild, add it to the wilds
        if object.deck[x].wild then
            table.insert(object.wilds, 1, object.deck[x])

        --if it hasn't already been looked at, then:
        elseif object.deck[x].found == false then
            found = found + 1
            local c = x + 1
            for y = c, #object.deck do
                
                local comparedCardNum = object.deck[y].number
                --compared it to all the other unfound cards
                if cardNum == comparedCardNum and object.deck[y].found == false then
                    found = found + 1
                    --if found is 2, then it is a double, or pair
                    if found == 2 then
                        table.insert(object.doubles, 1, object.deck[y])
                    end
                    
                    --if it is more than two, add that card to the sets (we'll
                    -- deal with the fact that 2 of the 3 cards of the set are in the 
                    -- doubles table later)
                    if found > 2 then
                        table.insert(object.sets, 1, object.deck[y])
                    end
                    object.deck[y].found = true
                end
            
            end


        end

        
        --if only one of a number is found, put it in lones
        if found == 1 then
            table.insert(object.lones, 1, object.deck[x])
        --if two, put it in doubles (the other should already be there)
        elseif found == 2 then
            table.insert(object.doubles, 1, object.deck[x])
        --if more, put that card in sets
        elseif found > 2 then
            table.insert(object.sets, 1, object.deck[x])
            local j
            --finds which cards in doubles SHOULD BE in sets and places them there
            for j = 1, #object.doubles do

                if object.doubles[j] ~= nil then
                    if object.doubles[j].number == object.deck[x].number then
                        table.insert(object.sets, 1, object.doubles[j])
                        table.remove(object.doubles, j)
                    end
                end
            end


        end

    end

    --if the last card is wild, put it there
    if object.deck[#object.deck].wild then
        table.insert(object.wilds, 1, object.deck[#object.deck])
    --if the final card in the hand has not been found, then add it to the lones
    elseif object.deck[#object.deck].found == false then
        table.insert(object.lones, 1, object.deck[#object.deck])
    end

    --sorts the hand so that it visually looks organized
    for i=1, #object.wilds do
        object.deck[i] = object.wilds[i]
    end
    for i=1, #object.sets do
        object.deck[i + #object.wilds] = object.sets[i]
    end
    for i=1, #object.doubles do
        object.deck[i + #object.wilds + #object.sets] = object.doubles[i]
    end
    for i=1, #object.lones do
        object.deck[i + #object.wilds + #object.sets + #object.doubles] = object.lones[i]
    end


end


--HELPER FUNCTIONS:

--resets all the cards in table t to be unfound
function resetCards(t)
    local x
    for x = 1, #t do
        t[x].found = false
    end
end

--checks if an object(user) has won
function checkWin(object)
    if #object.wilds >= (#object.doubles/2) + (2 * #object.lones) then
        roundWinner = object
        return true
    else
        return false
    end
end

--calculates the points of an object
function calculatePoints(object,t)
    
    local pointCounter = 0

    --adds the value of the lones
    for i=1, #object.lones do
        pointCounter = pointCounter + object.lones[i].number
    end

    --adds the value of the doubles IF there is not corresponding wilds for it
    if #object.wilds < (#object.doubles/2) then
        numToAdd = #object.doubles - (#object.wilds * 2)
        for i=1, numToAdd do
            small = smallest(object.doubles)
            pointCounter = pointCounter + small.number
            table.removeKey(object.doubles, small)
        end
    end
    
    --inserts BOTH the number of points and the current total score
    --this is so that later on I might add a table that shows all the 
    --points for every round
    table.insert(t, #t + 1, pointCounter)
    table.insert(t, #t + 1, t[#t-1] + pointCounter)


end

--finds and returns the card in a table
--which has the smallest number value
function smallest(t)
    if #t ~= 0 then
        local i
        smaller = 20
        local smallestCard
        for i = 1, #t do
            if t[i].number < smaller then
                smaller = t[i].number
                smallestCard = t[i]
            end

        end

        return smallestCard
    else
        return nil
    end

end

--finds and returns the card in a table
--which has the largest number value
function largest(t)
    if #t ~= 0 then
        local i
        larger = 0
        local largestCard
        for i = 1, #t do
            if t[i].number > larger then
                larger = t[i].number
                largestCard = t[i]
            end

        end

        return largestCard
    else
        return nil
    end

end

--removes a card from a table based
--NOT on its index, but instead based
--on its value
function table.removeKey(t, k)
    local countT = #t
    local i
    for i = 1, countT do
        if t[i] == k then
            table.remove(t,i)
        end
    end
end

--executes if the game has ended
function endGame() 
    --stores the final points for all objects
    local finalPlayer = playerPoints[#playerPoints]
    local finalAiOne = AiOnePoints[#AiOnePoints]
    local finalAiTwo = AiTwoPoints[#AiTwoPoints]

    --sets each objects endpoints
    player.endPoints = finalPlayer
    AiOne.endPoints = finalAiOne
    AiTwo.endPoints = finalAiTwo

    --finds out which user has won
    if finalPlayer < finalAiOne and  finalPlayer < finalAiTwo then
        overallWinner = player
    elseif finalAiOne < finalPlayer and finalAiOne < finalAiTwo then
        overallWinner = AiOne
    elseif finalAiTwo < finalPlayer and finalAiTwo < finalAiOne then
        overallWinner = AiTwo
    end

    gameFinished = true


end