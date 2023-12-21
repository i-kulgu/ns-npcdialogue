Config = Config or {}
HD = HD or {}
Config.UseTarget = GetConvar('UseTarget', 'false') == 'true' -- Use qb-target interactions (don't change this, go to your server.cfg and add setr UseTarget true)
Config.DrawText = '[E] - Talk to NPC'
Config.TargetSystem = 'qb-target' -- Target system : qb-target / qtarget / ox_target
Config.npcs = {
    {
        name = "Grocer Jenny", -- Name of the NPC
        text = "Hi, I have fresh fruit! Wanna buy?", -- Text for the NPC
        job = "Grocer", -- Job of the NPC
        ped = "a_f_m_beach_01", -- Ped model of the NPC
        coords = vector4(-1379.14, 735.99, 181.97, 2.67), -- Location of the NPC
        options = {
            {
                label = "Yes", -- Label for button
                event = "e clubdans7", -- Event or command that will be triggered
                type = "command", -- command or event
                args = {'1'} -- Arguments for the command
            },
            {
                label = "No!",
                event = "e clubdans7",
                type = "command",
                args = {'1'}
            },
            {
                label = "Looking for Jim",
                event = "e clubdans7",
                type = "command",
                args = {'1'}
            },
            {
                label = "I need a car",
                event = "e clubdans7",
                type = "command",
                args = {'1'}
            }
        }
    },
    {
        name = "Nexus Tester",
        text = "Hi, Where can i find a taxi ?",
        job = "Gym",
        ped = "a_f_m_bodybuild_01",
        coords = vector4(-1376.82, 735.64, 182.04, 354.47),
        options = {
            {
                label = "Get the hell out",
                event = "e clubdans7",
                type = "command",
                args = {'1'}
            },
            {
                label = "I don't know..",
                event = "e clubdans7",
                type = "event",
                args = {'2'}
            }
        }
    },
}