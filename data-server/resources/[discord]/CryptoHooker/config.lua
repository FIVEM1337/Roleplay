Config = {}

Config.Webhook = {
    chatMessage = {
        url = "https://discord.com/api/webhooks/960150204361875526/7JHJ9alsGdGc7alxrELw9yYK5ZO6B7cxNxPkl9l2I7T4ySglTWdYgi3_DNU6xQSmS7au",
        title = "Nahricht gesendet",
        color = "RED",
        elements = {
            Postals = true,
            SteamID = true,
            DiscordID = true,
            SteamID = true,
            License = true,
            IP = true,
            PlayerID = true,
            ESX = {
                esxName = true,
                esxJob = true,
                esxMoney = true,
            }
        }
    },

    oocMessage = {
        url = "https://discord.com/api/webhooks/966054058672672789/MgSO_uyct8gBJ8d0-bnkcZk4NYhvfuC4p5IbsAKyW1697FisYa33eczuDvTIaepfmwfe",
        title = "OOC Nahricht gesendet",
        color = "RED",
        elements = {
            Postals = true,
            SteamID = true,
            DiscordID = true,
            SteamID = true,
            License = true,
            IP = true,
            PlayerID = true,
        }
    },

    StaffToStaff = {
        url = "https://discord.com/api/webhooks/966059217788207106/pWEvvI2T0tMTxhaVip0sgSVY49sxMRXBmb2iCPGk1iFGwHxQqOph-2kjxhVCxB2TOm2x",
        title = "Team Nahricht gesendet",
        color = "RED",
        elements = {
            Postals = true,
            SteamID = true,
            DiscordID = true,
            SteamID = true,
            License = true,
            IP = true,
            PlayerID = true,
        }
    },

    StaffToPlayers = {
        url = "https://discord.com/api/webhooks/966059480854958122/_45yPeFaqSTv1Ui_P4Y7c10aLdevXeW7xAAVmOj7ulAhYigbrEpK3ajoZkW87HO5myZy",
        title = "Team zu Spieler Nahricht gesendet",
        color = "RED",
        elements = {
            Postals = true,
            SteamID = true,
            DiscordID = true,
            SteamID = true,
            License = true,
            IP = true,
            PlayerID = true,
        }
    },

    handcuff = {
        url = "https://discord.com/api/webhooks/966061174846259270/98Y2nblw7ZWJN8kfv2fx3bK8v7oTgvhv772XpWKE66YmiP-fvRDrvyjAt0-AMZyo8b1b",
        title = "Spieler festgenommen",
        color = "GREEN",
        elements = {
            Postals = true,
            SteamID = true,
            DiscordID = true,
            SteamID = true,
            License = true,
            IP = true,
            PlayerID = true,
        }
    },

    unhandcuff = {
        url = "https://discord.com/api/webhooks/966068591923441704/-S0-0LgW4S-1zqhi_iHaeyWBXDzt8IoCdrUnG2XNDyFOFAMhQkE9YretfYtlUOqULXjY",
        title = "Spieler entfesselt",
        color = "RED",
        elements = {
            Postals = true,
            SteamID = true,
            DiscordID = true,
            SteamID = true,
            License = true,
            IP = true,
            PlayerID = true,
        }
    },

    joined = {
        url = "https://discord.com/api/webhooks/966074448052645928/pX_XwW-UPCKHRxuWRx3akBaIsjkCRwKrvcbYzgj3cClO4sLNF5dxcl7E-4d-7nNP_TGt",
        title = "Spieler vollständig Verbunden",
        color = "GREEN",
        elements = {
            Postals = true,
            SteamID = true,
            DiscordID = true,
            SteamID = true,
            License = true,
            IP = true,
            PlayerID = true,
        }
    },

    leave = {
        url = "https://discord.com/api/webhooks/966078980790824990/JubS6NDOrODZ0kFtIT8a7BQDpmkeNH_a_Mp9JtyCrUIdda9AiJeQr7v2gcIOloIbAzNk",
        title = "Spieler hat den Server verlassen",
        color = "RED",
        elements = {
            Postals = true,
            SteamID = true,
            DiscordID = true,
            SteamID = true,
            License = true,
            IP = true,
            PlayerID = true,
        }
    },

    weaponcraft = {
        url = "https://discord.com/api/webhooks/966375997719060580/WYDaSFWkUb-m7C1QgA2vHXWIKUuTjQwsiZLKfzBsyIX3Tm6h6NfJ3hoO1OBhkIHFVnXw",
        title = "Waffe hergestellt",
        color = "RED",
        elements = {
            Postals = true,
            SteamID = true,
            DiscordID = true,
            SteamID = true,
            License = true,
            IP = true,
            PlayerID = true,
        }
    },
}



Config.Colors = {
    AQUA = 1752220,
    DARK_AQUA = 1146986,
    GREEN = 3066993,
    DARK_GREEN = 2067276,
    BLUE = 3447003,
    DARK_BLUE = 2123412,
    PURPLE = 10181046,
    DARK_PURPLE = 7419530,
    LUMINOUS_VIVID_PINK = 15277667,
    DARK_VIVID_PINK = 11342935,
    GOLD = 15844367,
    DARK_GOLD = 12745742,
    ORANGE = 15105570,
    DARK_ORANGE = 11027200,
    RED = 15158332,
    DARK_RED = 10038562,
    GREY = 9807270,
    DARK_GREY = 9936031,
    DARKER_GREY = 8359053,
    LIGHT_GREY = 12370112,
    NAVY = 3426654,
    DARK_NAVY = 2899536,
    YELLOW = 16776960,
    WHITE = 16777215,
    BLURPLE = 5793266,
    GREYPLE = 10070709,
    GREEN = 5763719,
    YELLOW = 16705372,
    FUSCHIA = 15418782,
    RED = 15548997,
    BLACK = 2303786,
}


-- http://www.kronzky.info/fivemwiki/index.php/Weapons
Config.deathCauseList = {
    [-842959696] = {reason = "ist auf den Boden geklatscht"},
    [453432689] = {reason = "mit einer Pistole erschossen"},
    [-1553120962] = {reason = "mit einem Fahrzeug überfahren"},


}