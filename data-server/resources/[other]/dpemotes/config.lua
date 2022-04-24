Config = {
    -- Change the language of the menu here!.
    -- Note fr and de are google translated, if you would like to help out with translations, feel free to send me an 'issue' on Github.
    -- Thank you to those who provided the NL and PT languages.
    --

    MenuLanguage = 'de',
    -- Set this to true to enable some extra prints
    DebugDisplay = false,
    -- Set this to false if you have something else on X, and then just use /e c to cancel emotes.
    EnableXtoCancel = true,
    -- Set this to true if you want to disarm the player when they play an emote.
    DisarmPlayer = false,
    -- Set this if you really wanna disable emotes in cars, as of 1.7.2 they only play the upper body part if in vehicle
    AllowedInCars = true,
    -- You can disable the menu here / change the keybind. It is currently set to F3
    MenuKeybindEnabled = true,
    MenuKeybind = 'F3', -- Get the button string here https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
    -- You can disable the Favorite emote keybinding here.
    FavKeybindEnabled = true,
    FavKeybind = 171, -- Get the button number here https://docs.fivem.net/game-references/controls/
    -- You can change the header image for the menu here
    -- Use a 512 x 128 image!
    -- Note this might cause an issue of the image getting stuck on peoples screens
    CustomMenuEnabled = false,
    MenuImage = "https://imgur.com/PvMINNO.png",
    -- You can change the menu image by pasting a link above. It must be the same width and length
    --
    -- You can change the menu position here
    MenuPosition = "left", -- (left, right)
    -- You can enable or disable the Ragdoll keybinding here.
    RagdollEnabled = true,
    RagdollKeybind = 303, -- Get the button number here https://docs.fivem.net/game-references/controls/
    -- You can disable the Facial Expressions menu here.
    ExpressionsEnabled = true,
    -- You can disable the Walking Styles menu here.
    WalkingStylesEnabled = true,
    -- You can disable the Shared Emotes here.
    SharedEmotesEnabled = true,
    -- If you have the SQL imported enable this to turn on keybinding.
    SqlKeybinding = true,
}

Config.KeybindKeys = {
    ['num4'] = 108,
    ['num5'] = 110,
    ['num6'] = 109,
    ['num7'] = 117,
    ['num8'] = 111,
    ['num9'] = 118
}

Config.Languages = { 
    ['de'] = {
        ['emotes'] = 'Emotes',
        ['danceemotes'] = "🕺 Tanz-Emotes",
        ['animalemotes'] = "🐩 Tier Emotes",
        ['propemotes'] = "📦 Prop-Emotes",
        ['favoriteemotes'] = "🌟 Favorit",
        ['favoriteinfo'] = "Wählen Sie hier ein Emote aus, um es als gebundenes Emote festzulegen.",
        ['rfavorite'] = "Keybind zurücksetzen",
        ['prop2info'] = "❓ Prop-Emotes können am Ende platziert werden",
        ['set'] = "Set (",
        ['setboundemote'] = ") soll dein gebundenes Emote sein?",
        ['newsetemote'] = "~w~ ist jetzt dein gebundenes Emote, drücke ~g~CapsLock~w~, um es zu verwenden.",
        ['cancelemote'] = "Emote abbrechen",
        ['cancelemoteinfo'] = "~r~ X ~w~ Bricht das aktuell wiedergegebene Emote ab",
        ['walkingstyles'] = "Gehstile",
        ['resetdef'] = "Auf Standard zurücksetzen",
        ['normalreset'] = "Normal (Zurücksetzen)",
        ['moods'] = "Stimmungen",
        ['infoupdate'] = "Information",
        ['infoupdateav'] = "Information (Update verfügbar)",
        ['suggestions'] = "Vorschläge?",
        ['suggestionsinfo'] = "'TayMcKenzieNZ' in FiveM-Foren für alle Feature- / Emote-Vorschläge! ✉️",
        ['notvaliddance'] = "ist kein gültiger Tanz",
        ['notvalidemote'] = "ist kein gültiges Emote",
        ['nocancel'] = "Kein Emote zum Abbrechen",
        ['maleonly'] = "Dieses Emote ist nur männlich, sorry!",
        ['emotemenucmd'] = "Do /emotemenu für ein Menü",
        ['shareemotes'] = "👫 Geteilte Emotes",
        ['shareemotesinfo'] = "Laden Sie eine Person in Ihrer Nähe zum Emoten ein",
        ['sharedanceemotes'] = "🕺 Geteilte Tänze",
        ['notvalidsharedemote'] = "ist kein gültiges geteiltes Emote.",
        ['sentrequestto'] = "Gesendete Anfrage an ~g~",
        ['nobodyclose'] = "Niemand ist nah genug dran.",
        ['doyouwanna'] = "~y~Y~w~ zu akzeptieren, ~r~L~w~ zu verweigern (~g~",
        ['refuseemote'] = "Emote abgelehnt.",
        ['makenearby'] = "Lässt den Spieler in der Nähe spielen",
        ['camera'] = "Drücken ~y~G~w~ Kamerablitz verwenden.",
        ['makeitrain'] = "Drücken ~y~G~w~ Geld werfen.",
        ['pee'] = "Halt ~y~G~w~ urinieren.",
        ['spraychamp'] = "Halt ~y~G~w~ champagner sprühen",
        ['bound'] = "Gebunden ",
        ['to'] = "zu",
        ['currentlyboundemotes'] = " Derzeit gebundene Emotes:",
        ['notvalidkey'] = "ist kein gültiger schlüssel.",
        ['keybinds'] = "🔢 Tastenkombinationen",
        ['keybindsinfo'] = "verwenden"
    }
}
