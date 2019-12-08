

--[[
    This is a card class for every card
]]
Card = Class{}

--each card has:
function Card:init(number, suit, quad)
    --a number
    self.number = number
    --whether it is wild or not
    self.wild = false
    --a suit
    self.suit = suit
    --whether it has been found or not
    self.found = false
    --an x and y position
    self.x = 0
    self.y = 0
    --whether it is highlighted or not
    self.highlight = false
   --a quad, or a section of the larger deck sheet
    self.quad = quad
    
    --if the cards number is the round,
    --then set that card to be a wild
    if round == self.number then
        self.wild = true
    end

end