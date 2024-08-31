--- STEAMODDED HEADER
--- MOD_NAME: Ruina Decks
--- MOD_ID: RuinaDecks
--- MOD_AUTHOR: [someone23832]
--- MOD_DESCRIPTION: Adds decks loosely based on Ruina concepts.
--- LOADER_VERSION_GEQ: 1.0.0
--- BADGE_COLOR: 85d6c7
--- PREFIX: ruina

----------------------------------------------
------------MOD CODE -------------------------
----------------------------------------------

--SMODS.current_mod.config_tab = function()
--  return {n = G.UIT.ROOT, config = {r = 0.25, align = 'tm', padding = 0.5, colour = G.C.BLACK, minw = 15, minh = 8}, nodes = {
--      
--    }}
--end

G.C.MIST_RED = HEX('950101')
SMODS.Atlas{
 key = 'Decks',
 path = 'RuinaDecks.png',
 px = 71,
 py = 95
}

SMODS.Sound{
 key = 'snap',
 path = 'finger-snap.ogg'
}



SMODS.Back{
  key = 'gebura',
  loc_txt = {
    name = 'Book of Gebura',
    text = {'{C:dark_edition}Overscored {C:chips}Chips{} carry','over to the {C:attention}next round','Start with {C:dark_edition}+1,000 {C:chips}Chips'}
  },
  atlas = 'Decks',
  pos = {x = 0, y = 0},
  unlocked = true,
  discovered = true,
  apply = function(self)
    G.GAME.mist_chips = 1000
  end,
  trigger_effect = function(self, args)
    if args.context == 'mist_start' then
      -- IS THAT THE RED MIST?
      local Kali = G.GAME.mist_chips
      ease_chips(Kali)
      G.E_MANAGER:add_event(Event({
        func = (function()
            local text = "Onrush"
            play_sound('ruina_snap', 1, 0.5)
            attention_text({
                scale = 1.6, text = text, hold = 3, align = 'cm', offset = {x = 0,y = -2.7},major = G.play, colour = G.C.MIST_RED
            })
          return true
        end)
      }))
      
      
      
      
      
    end
    if args.context == 'mist_end' then
      G.GAME.mist_chips = G.GAME.chips - G.GAME.blind.chips
    end
    sendDebugMessage(G.GAME.mist_chips)
  end
}



SMODS.Back{
  key = 'binah',
  loc_txt = {
    name = 'Book of Binah',
    text = {'{C:attention}+1{} Booster Pack {C:attention}Size','{C:attention}+1{} Booster Pack {C:attention}Choice'}
  },
  atlas = 'Decks',
  pos = {x = 1, y = 0},
  unlocked = true,
  discovered = true,
  trigger_effect = function(self, args)
    if args.context == 'booster' then
      G.GAME.pack_size = G.GAME.pack_size + 1
      G.GAME.pack_choices = G.GAME.pack_choices + 1
    end
    if args.context == 'booster2' then
      local size = args.size + 1
      return(size)
    end
  end
}
