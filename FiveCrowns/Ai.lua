--[[
    This is an Ai class which handles the computers' hand.
]]


Ai = Class{}


--the Ai (or computer) has:
function Ai:init()
    --a hand of cards
    self.deck = {}
    --a table for doubles, wilds, sets, and lones
    self.doubles = {}
    self.sets = {}
    self.lones = {}
    self.wilds = {}
    --a title
    self.title = ''
    --endpoints for the end of the GAME
    self.endPoints = 0

end

function Ai:render(num, points, val)
    --renders some cards at the top of the screen
    local spaceWidth = -60
        
    local fullWidth = (CARD_WIDTH * #self.deck) + (spaceWidth * (#self.deck - 1))
    local a =  .5 * (SCREEN_WIDTH - fullWidth) - 300 + (num * 625)

    for k,v in pairs(self.deck) do

        self.deck[k].x = a + ((k-1) * (CARD_WIDTH + spaceWidth))
        self.deck[k].y = - 60

        -- only the back of the cards
        love.graphics.draw(cardBack, self.deck[k].x, self.deck[k].y)

    end

    --prints the number of points that each AI has
    love.graphics.printf(self.title .. ' Points: ' .. points, val * SCREEN_WIDTH/4, 150, SCREEN_WIDTH, 'center')

end


-- the AI deciding which card to take
function Ai:decide()
    --takes the card from the discard if:
        --it is wild
        --it matches with a set it has
        --completes a double
        --matches with a lone it has
    if upface[1].wild or 
    findNum(self.sets, upface[1].number) or 
    findNum(self.doubles, upface[1].number) or
    findNum(self.lones, upface[1].number) then
        table.insert(self.deck, 1, upface[1])
        table.remove(upface, 1)
    else
        --otherwise it take a card from the deck
        table.insert(self.deck, 1, oldDeck[1])
        table.remove(oldDeck,1)
    end

end

--chooses which card to eilimate
function Ai:eliminate()
    --finds the largest card in lones
    local largeCard = largest(self.lones)
    --if there are lones, take out the largest one
    if #self.lones > 0 then
        table.insert(upface, 1, largeCard)
        table.removeKey(self.deck,largeCard)

    --ELSE if there are doubles
    elseif #self.doubles > 0 then
        local card
        --take out eeither the smallest or largest 
        --value card depending on whether there is 
        --a wild to go with it
        if #self.wilds - 1 >= #self.doubles then
            card = smallest(self.doubles)
        else    
            card = largest(self.doubles)
        end

        table.insert(upface, 1, card)   
        
        for i=1, #self.doubles-1 do 
            if self.doubles[i].number == card.number then
                table.insert(self.lones, 1, self.doubles[i])
                table.remove(self.doubles, i)
            end

        end

        --removes the discarded card from the hand
        table.removeKey(self.deck, card)

    
    --ELSE if there are ONLY sets:
    elseif #self.sets > 0 then
        local discard
        longestRun = 1
        longestRunIndex = 0
        --takes one from the set of the
        --longets run
        findSet(1,self.sets)
        --if all have a runlength of three, take the smallest VALUE one
        if longestRun == 3 then
            discard = smallest(self.sets)
        else
            discard = self.sets[longestRunIndex]
        end

        table.insert(upface, 1, discard)
        table.removeKey(self.deck, discard)
    
    end


end


--finds and classifies all the sets in a table,
--basically just finding how long it is
function findSet(index,t)
    local x = index
    local current 
    local count = 1
    if t[x+1] ~= nil then
        for current = x + 1, #t do
            if t[x].number ==  t[current].number then
                count = count + 1
            else   
                if count > longestRun then
                    longestRun = count
                    longestRunIndex = x
                end

                findSet(current, t)

                break
            
            end

        end
    end

    if count > longestRun then
        longestRun = count
        longestRunIndex = x
    end

end
