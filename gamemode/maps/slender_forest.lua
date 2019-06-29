// shared

Map = {
    cameras = {
        {
            pos = Vector(3686.340088, -3400.396484, 332.101929),
            ang = Angle(-15.894459, -20.920872, 0.000000)
        },
        {
            pos = Vector(-1767.516113, -1775.567017, -51.759216),
            ang = Angle(2.582751, 46.886448, 0.000000)
        },
        {
            pos = Vector(3315.077881, 3508.807617, 62.725948),
            ang = Angle(-19.888777, -108.070564, 0.000000)
        }
    },

    spawns = {
        humans = {
            // group 1
            {
                pos = Vector(1757.696899, -1126.045898, 62.031250),
                ang = Angle(8.656085, -56.588203, 0.000000)
            },
            {
                pos = Vector(1973.491089, -1116.482788, 62.031250),
                ang = Angle(7.059331, -82.640579, 0.000000)
            },
            {
                pos = Vector(2205.993164, -1413.909424, 62.031250),
                ang = Angle(1.596734, 174.410370, 0.000000)
            },
            {
                pos = Vector(2159.309082, -1073.515869, 62.031250),
                ang = Angle(4.538134, -127.685936, 0.000000)
            },
            {
                pos = Vector(1901.161133, -928.954041, 62.031250),
                ang = Angle(5.462577, -93.565674, 0.000000)
            },
            {
                pos = Vector(1658.102661, -995.663391, 62.031250),
                ang = Angle(5.966822, -50.369087, 0.000000)
            },
            {
                pos = Vector(1473.739746, -1123.236450, 62.031250),
                ang = Angle(7.983780, -29.443153, 0.000000)
            },
            {
                pos = Vector(1372.361938, -1343.237061, 62.031250),
                ang = Angle(8.403978, -0.029154, 0.000000)
            },
            {
                pos = Vector(2599.621338, -1844.489014, 62.031250),
                ang = Angle(5.462579, 138.384735, 0.000000)
            },
            {
                pos = Vector(2377.684082, -1902.491333, 62.031250),
                ang = Angle(9.244381, 96.028549, 0.000000)
            },

            // group 2
        },

        boss = {
            {
                pos = Vector(-3451.154297, 529.374268, 62.031250),
                ang = Angle(1.344637, -15.492799, 0.000000)
            }
        }
    },

    pages = {
        {
            pos = Vector(1714.497925, -2164.675781, 57.438423),
            ang = Angle(0.000000, -0.000000, 0.000000)
        },
        {
            pos = Vector(2927.643799, 4497.230957, 72.793968),
            ang = Angle(0.149238, 297.929047, 0.000000)
        },
        {
            pos = Vector(-2858.808105, 4168.269531, 56.341274),
            ang = Angle(30.708496, 90.000000, 0.000000)
        },
        {
            pos = Vector(-3375.031250, -3496.578857, 52.070492),
            ang = Angle(-0.000000, 180.000000, 0.000000)
        },
        {
            pos = Vector(3042.401855, -1990.031250, 56.236713),
            ang = Angle(-0.000000, 270.000000, 0.000000)
        },
        {
            pos = Vector(-1774.968750, -1755.227661, -59.554497),
            ang = Angle(-0.000000, 0.000000, 0.000000)
        },
        {
            pos = Vector(2826.031250, -1095.938721, -53.046139),
            ang = Angle(-0.000000, 0.000000, 0.000000)
        },
        {
            pos = Vector(3716.083008, -1885.043213, 41.989601),
            ang = Angle(2.348846, 334.759918, 0.000000)
        },
        {
            pos = Vector(750.061584, -3708.877686, 72.009666),
            ang = Angle(357.901703, 217.000015, 0.000000)
        },
        {
            pos = Vector(-2537.122559, 885.783936, 31.319948),
            ang = Angle(0.000003, 0.000002, 0.000000)
        },
        {
            pos = Vector(-406.562134, 1206.854858, 51.161015),
            ang = Angle(358.179962, 47.000187, 0.000000)
        },
        {
            pos = Vector(3046.062988, 3422.470459, 60.742615),
            ang = Angle(-0.000000, 0.000002, 0.000000)
        },
        {
            pos = Vector(2651.307617, 4383.864746, 59.231133),
            ang = Angle(0.000000, 116.500008, 0.000000)
        },
        {
            pos = Vector(-1369.809692, 5002.519531, 55.013760),
            ang = Angle(30.708616, 270.000000, 0.000000)
        }
    },

    InitPostEntity = function() // get rid of the models that are in the map
        if not SERVER then return end
        for _, ent in pairs(ents.FindByModel("models/slender/sheet.mdl")) do
			SafeRemoveEntity(ent)
		end
    end,

    PostCleanUpMap = function()
        if not SERVER then return end
        for _, ent in pairs(ents.FindByModel("models/slender/sheet.mdl")) do
			SafeRemoveEntity(ent)
		end
    end
}
