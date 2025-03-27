G.C.MIST_RED = HEX('950101')
SMODS.Atlas {
    key = 'Decks',
    path = 'RuinaDecks.png',
    px = 71,
    py = 95
}


SMODS.Sound {
    key = 'burn',
    path = 'burn_book.ogg'
}

SMODS.Sound {
    key = 'snap',
    path = 'finger-snap.ogg'
}

SMODS.Back {
    key = 'keter',
    loc_txt = {
        name = 'Book of Keter',
        text = {
            "Start run with",
            "{C:green,T:v_reroll_surplus}Reroll Surplus{},",
            "{C:attention,T:v_directors_cut}Director's Cut{},",
            "and {C:dark_edition,T:v_hone}Hone"
        }
    },
    config = { vouchers = { 'v_reroll_surplus', 'v_hone', 'v_directors_cut' } },
    atlas = 'Decks',
    pos = { x = 0, y = 0 },
    unlocked = true,
    discovered = true,
    apply = function(self)
    end,
}

SMODS.Back {
    key = 'malkuth',
    loc_txt = {
        name = 'Book of Malkuth',
        text = { 'After defeating each',
            '{C:attention}Boss Blind{}, gain',
            'an {C:attention,T:c_immolate}Eternal Immolate',
            "{C:inactive,s:0.8}(Can't be sold or destroyed)",
            'Earn no {C:attention}Interest'
        }
    },
    atlas = 'Decks',
    pos = { x = 1, y = 0 },
    unlocked = true,
    discovered = true,
    config = {no_interest = true},
    calculate = function(self, back, context)
        if context.end_of_round and not context.individual and not context.repetition then
            if G.GAME.blind.boss and context.game_over ~= true then
                G.E_MANAGER:add_event(Event({
                    blockable = true,
                    blocking = true,
                    trigger = "after",
                    delay = 0,
                    func = function()
                        local card = create_card('Spectral', G.deck, nil, nil, nil, nil, 'c_immolate')
                        card.ability.eternal = true
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        play_sound('ruina_burn', 1, 1.5)
                        return true
                    end
                }))
            end
        end
    end
}
--[[
SMODS.Back {
    key = 'yesod',
    loc_txt = {
        name = 'Book of Yesod',
        text = { '???'
        }
    },
    atlas = 'Decks',
    pos = { x = 2, y = 0 },
    unlocked = true,
    discovered = true,
}
]]
SMODS.Back {
    key = 'netzach',
    loc_txt = {
        name = 'Book of Netzach',
        text = { '{C:attention}+1{} hand size for every',
            '{C:attention}Face Card {C:red}discarded',
            'until a hand is scored,',
            '{C:attention}-1{} Hand Size'
        }
    },
    atlas = 'Decks',
    pos = { x = 3, y = 0 },
    unlocked = true,
    discovered = true,
    config = { hand_size = -1, temp_size = 0, add = 1 },
    calculate = function(self, back, context)
        if context.discard and context.other_card then
            if context.other_card:is_face() then
                back.effect.config.temp_size = back.effect.config.temp_size + back.effect.config.add
                G.hand:change_size(back.effect.config.add)
            end
        end
        if context.after then
            G.hand:change_size(-back.effect.config.temp_size)
            back.effect.config.temp_size = 0
        end
    end
}

SMODS.Back {
    key = 'hod',
    loc_txt = {
        name = 'Book of Hod',
        text = {
            '{C:attention}Jokers{} give {C:mult}+0 Mult,',
            'increases by {C:mult}+1',
            'per round held'
        }
    },
    atlas = 'Decks',
    pos = { x = 0, y = 1 },
    unlocked = true,
    discovered = true,
    config = { mult = 1 },
    apply = function(self)
        G.GAME.hod_deck = true
    end,
    calculate = function(self, back, context)
        if context.end_of_round and not context.individual and not context.repetition then
            for i, v in ipairs(G.jokers.cards) do
                if not G.jokers.cards[i].ability.hod_training then G.jokers.cards[i].ability.hod_training = { 0 } end
                G.jokers.cards[i].ability.hod_training[1] = G.jokers.cards[i].ability.hod_training[1] +
                    back.effect.config.mult
                card_eval_status_text(G.jokers.cards[i], 'extra', nil, nil, nil,
                    {
                        message = localize { type = 'variable', key = 'a_mult', vars = { back.effect.config.mult } },
                        colour = G.C.ORANGE,
                    }
                )
            end
        end
        if context.other_joker then
            if context.other_joker.ability.hod_training and context.other_joker.ability.hod_training[1] > 0 then
                card_eval_status_text(context.other_joker, 'extra', nil, nil, nil,
                    {
                        message = localize { type = 'variable', key = 'a_mult', vars = { context.other_joker.ability.hod_training[1] } },
                        colour = G.C.ORANGE,
                    })
                return {
                    mult = context.other_joker.ability.hod_training[1],
                    remove_default_message = true
                }
            end
        end
    end
}

SMODS.Back {
    key = 'tipherethv1',
    loc_txt = {
        name = 'Book of Tiphereth',
        text = { '{C:attention}+3{} Joker slots',
            'Start with {C:attention}3{}',
            'copies of {C:tarot,T:c_judgement}Judgement',
            '{C:red}X2{} base Blind size'
        }
    },
    atlas = 'Decks',
    pos = { x = 1, y = 1 },
    config = { ante_scaling = 2, joker_slot = 3, consumables = { 'c_judgement', 'c_judgement', 'c_judgement' } },
    unlocked = true,
    discovered = true
}
--[[
SMODS.Back {
    key = 'tipherethv2',
    loc_txt = {
        name = 'Book of Tiphereth, ver. 2',
        text = {
            'When a scored hand contains',
            'all 4 suits and no {C:attention,T:m_wild}Wild Cards,',
            'turn all unenhanced scored',
            'cards into {C:attention}Wild Cards.',
            "{C:attention}Wild Cards{} can't be debuffed"
        }
    },
    atlas = 'Decks',
    pos = { x = 1, y = 1 },
    config = {},
    unlocked = true,
    discovered = true
}
]]

--- BUG: Gebura + Chicot + Hook = weird game state
SMODS.Back {
    key = 'gebura',
    loc_txt = {
        name = 'Book of Gebura',
        text = { '{C:dark_edition}Overscored {C:chips}Chips{} carry',
            'over to the {C:attention}next round{},',
            'Start with {C:dark_edition}+1,000 {C:chips}Chips' }
    },
    atlas = 'Decks',
    pos = { x = 2, y = 1 },
    unlocked = true,
    discovered = true,
    apply = function(self)
        G.GAME.mist_chips = 1000
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over ~= true then
            G.GAME.mist_chips = G.GAME.chips - G.GAME.blind.chips
        end
        if context.setting_blind then
            local Kali = G.GAME.mist_chips
            -- IS THAT THE RED MIST?
            ease_chips(Kali)
            G.E_MANAGER:add_event(Event({
                blockable = false,
                blocking = true,
                trigger = "after",
                delay = 0.1,
                func = function()
                    local text = "Onrush"
                    play_sound('ruina_snap', 1, 0.5)
                    attention_text({
                        scale = 1.6,
                        text = text,
                        hold = 3,
                        align = 'cm',
                        offset = { x = 0, y = -2.7 },
                        major = G.play,
                        colour =
                            G.C.MIST_RED
                    })
                    return true
                end
            }))
        end
    end
}

SMODS.Back {
    key = 'chesed',
    loc_txt = {
        name = 'Book of Chesed',
        text = { '{C:common}Common{} Jokers give {C:chips}+100 Chips',
            '{C:uncommon}Uncommon{} Jokers give {C:chips}+50 Chips',
            '{C:rare}Rare{} Jokers give {C:chips}+25 Chips'
        }
    },
    atlas = 'Decks',
    pos = { x = 3, y = 1 },
    config = { common = 100, uncommon = 50, rare = 25 },
    unlocked = true,
    discovered = true,
    apply = function(self)
    end,
    calculate = function(self, back, context)
        if context.other_joker then
            local chips = 0
            if (context.other_joker.config.center.rarity == 1 or context.other_joker.config.center.rarity == "Common") then
                chips = back.effect.config.common
            elseif (context.other_joker.config.center.rarity == 2 or context.other_joker.config.center.rarity == "Uncommon") then
                chips = back.effect.config.uncommon
            elseif (context.other_joker.config.center.rarity == 3 or context.other_joker.config.center.rarity == "Rare") then
                chips = back.effect.config.rare
            end
            if chips > 0 then
                card_eval_status_text(context.other_joker, 'extra', nil, nil, nil,
                    {
                        message = localize { type = 'variable', key = 'a_chips', vars = { chips } },
                        colour = G.C.CHIPS,
                    })
                return {
                    chips = chips,
                    remove_default_message = true
                }
            end
        end
    end
}


SMODS.Back {
    key = 'hokma',
    loc_txt = {
        name = 'Book of Hokma',
        text = {
            "For every {C:blue}hand{} played,",
            "gain {C:red}+1{} discard next round.",
            "Discards don't reset"
        }
    },
    atlas = 'Decks',
    pos = { x = 0, y = 2 },
    unlocked = true,
    discovered = true,
    calculate = function(self, back, context)
        if context.after then
            ease_discard(1)
        end
    end
}

SMODS.Back {
    key = 'binah',
    loc_txt = {
        name = 'Book of Binah',
        text = { '{C:attention}+1{} Booster Pack {C:attention}Size',
            '{C:attention}+1{} Booster Pack {C:attention}Choice' }
    },
    atlas = 'Decks',
    pos = { x = 1, y = 2 },
    unlocked = true,
    discovered = true,
    config = { booster_size = 1, booster_choose = 1 },
    calculate = function(self, back, context)
        if context.open_booster then
            context.card.ability.extra = context.card.ability.extra + back.effect.config.booster_size
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0,
                blockable = false,
                blocking = false,
                func = function()
                    if G.pack_cards and G.pack_cards.cards and G.pack_cards.cards[1] and (G.pack_cards.VT.y < G.ROOM.T.h) then
                        G.GAME.pack_choices = G.GAME.pack_choices + back.effect.config.booster_choose
                        if G.GAME.pack_choices > #G.pack_cards.cards then
                            G.GAME.pack_choices = #G.pack_cards.cards
                        end
                        return true
                    end
                end
            }))
        end
    end
}
