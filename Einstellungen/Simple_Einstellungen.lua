SimpleScripts = {}

--Auswahlmöglichkeiten: Gesicht, Maske, Haare, Torso, Beine, Fallschirm / Tasche, Schuhe, Zubehör, Weste, Abzeichen, Unterhemd Torso 2
SimpleScripts.Weste = {
    aktiv = true, -- Weste anziehen Ja oder Nein
    Kategorie = 'Weste',
    Kleidung = 4,
    Farbe = 1,
}

--STANDART NOTFIY von SIMPLESCRIPTS.eu | Dafür muss SimpleNotify Installiert sein!
SimpleScripts.SimpleNotify = true

--CUSTOM NOTIFY
SimpleScripts.UseCustomNotify = false
 
function SimpleNotify(color, title, msg)
    TriggerEvent('notifications', color, title, msg) -- Dein Notify Client Trigger, falls du eine eigene Nutzt.
end

SimpleScripts.NotifyError1WesteHeader = 'Information'
SimpleScripts.NotifyError1Weste = 'Du hast bereits eine Weste an!'
SimpleScripts.NotifyError1WesteFarbe = 'RED'
SimpleScripts.NotifyWesteAngezogenHeader = 'Information'
SimpleScripts.NotifyWesteAngezogen = 'Du hast dir eine Weste angezogen'
SimpleScripts.NotifyWesteAngezogenFarbe = 'GREEN'
SimpleScripts.NotifyModderHeader = 'Security'
SimpleScripts.NotifyModder = 'Du bist ein Modder, jetzt wird du gefickt!!!'
SimpleScripts.NotifyModderFarbe = 'RED'

--Item Einstellungen:
SimpleScripts.Item = {
    Weste100 = 'bread',
    Weste50 = 'Schwereweste',
    Weste25 = 'Leichteweste'
}

SimpleScripts.AdvancedSystem = true --Aktiviert die 25% und 50% Schutzwesten.

--Prgressbar Einstellungen:
SimpleScripts.ProgressBar = {
    Wait = 4000,
    Message = 'Weste wird angezogen',
    TextX = 0.015,
    TextY = 0.012,
}

SimpleScripts.ProgressBarFarben = {
    MainFarbeRGB1 = 0,
    MainFarbeRGB2 = 255,
    MainFarbeRGB3 = 255,
    HintergrundRGB1 = 21,
    HintergrundRBG2 = 21,
    HintergrundRBG3 = 21,
}

--Animation Einstellungen:
SimpleScripts.Animation = {
    Dict = 'clothingtie',
    Anim = 'try_tie_negative_a',
    Bewegungsperren = true,
}

--Security Einstellungen
SimpleScripts.Security = {
    Message = 'Du Lappen',
}
