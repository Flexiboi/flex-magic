Config = {}
Config.Debug = false

Config.Spells = {
    [1] = {
        spellname = 'Test', -- Name of the spell
        spelltime = 5, -- How long the spell last in seconds
        range = 1, -- Radius / range of the spell
        speleffects = {
            heal = {
                who = 'OTHER', -- SELF (to heal yourself on hit) / OTHER (to heal nearby players)
                amount = 50, -- Amount to add to health
                time = 100, -- Time in miliseconds it takes for each 1 health to regenerate
            },
            damage = {
                who = 'SELF', -- SELF (to heal yourself on hit) / OTHER (to heal nearby players)
                amount = 0, -- Amount to add to health
                time = 100, -- Time in miliseconds it takes for each 1 health to regenerate
            },
            particles = {
                zoffset = -1,
                loop = 200, -- Amount of times the particles will do a loop
                particletime = 25, -- Time in seconds the particle will stay
                tothetop = true, -- Animate particles to the top in a spiral
                scale = 1.0,
                color = {
                    r = 255.0,
                    g = 255.0,
                    b = 255.0,
                },
                alpha = 100.0,
                dict = 'scr_portoflsheist',
                particleName = 'scr_bio_flare',
            }
        }
    },
    [2] = {
        spellname = 'Test', -- Name of the spell
        spelltime = 5, -- How long the spell last in seconds
        range = 5, -- Radius / range of the spell
        speleffects = {
            heal = {
                who = 'OTHER', -- SELF (to heal yourself on hit) / OTHER (to heal nearby players)
                amount = 50, -- Amount to add to health
                time = 100, -- Time in miliseconds it takes for each 1 health to regenerate
            },
            damage = {
                who = 'SELF', -- SELF (to heal yourself on hit) / OTHER (to heal nearby players)
                amount = 0, -- Amount to add to health
                time = 100, -- Time in miliseconds it takes for each 1 health to regenerate
            },
            particles = {
                zoffset = 0,
                loop = 0, -- Amount of times the particles will do a loop
                particletime = 25, -- Time in seconds the particle will stay
                tothetop = false, -- Animate particles to the top in a spiral
                scale = .5,
                color = {
                    r = 255.0,
                    g = 255.0,
                    b = 255.0,
                },
                alpha = 100.0,
                dict = 'scr_xm_farm',
                particleName = 'scr_xm_dst_elec_crackle',
            }
        }
    }
}