
--[[
    This is a player class which handles the player's hand.
]]

Player = Class{}

--the player has:
function Player:init()
    --a deck (or hand)
    self.deck = {}
    --a table for doubles, wilds, sets, and lones
    self.doubles = {}
    self.sets = {}
    self.lones = {}
    self.wilds = {}
    --a title to display
    self.title = 'The Player'
    --the points AT THE END of the GAME (not ROUND)
    self.endPoints = 0

end

--renders the player's hand
function Player:render(num, other)

    --same code in main used to display the cards in the player's hand
    local spaceWidth

    if #self.deck <= 10 then
        spaceWidth = 25
    else
        spaceWidth = -10
    end

    local fullWidth = (CARD_WIDTH * #self.deck) + (spaceWidth * (#self.deck - 1))
    local a = .5 * (SCREEN_WIDTH - fullWidth)
    

    for k,v in pairs(self.deck) do

        --put the coords of each card at the right part
        self.deck[k].x = a + ((k-1) * (CARD_WIDTH + spaceWidth))
        self.deck[k].y = SCREEN_HEIGHT - 200

        --puts a rectangle if it is highlighted
        if self.deck[k].highlight then
            love.graphics.draw(highlightPic, self.deck[k].x - 4, self.deck[k].y - 4)

        end

        --draw the card
        love.graphics.draw(deckSheet, self.deck[k].quad, self.deck[k].x, self.deck[k].y)

    end

     --prints the player's current points
     love.graphics.printf('Player Points: ' .. playerPoints[#playerPoints], 0, 450, SCREEN_WIDTH, 'center')

end
