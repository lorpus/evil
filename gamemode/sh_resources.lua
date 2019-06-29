if SERVER then
    resource.AddWorkshop("1780893440")

    if not EVIL_CONTENT_1_INSTALLED then
        print("\n\n")
        for i = 1, 10 do
            print(Lang:Format("#ServerNoContent", { num = "1" }))
        end
    end
else // cli
    // placeholder
    if not EVIL_CONTENT_1_INSTALLED then
        Evil:AddTextChat(Lang:Format("#ClientNoContent", { num = "1" }))
    end
end

// pack 1
util.PrecacheModel("models/pinkiepie.mdl")
util.PrecacheModel("models/player/neckbeard.mdl")
util.PrecacheModel("models/jazzmcfly/kantai/nt/nt.mdl")
util.PrecacheSound("evil/gman/jumpscare.mp3")
util.PrecacheSound("evil/loli/bulgywulgy.mp3")
util.PrecacheSound("evil/loli/gotyou.mp3")
util.PrecacheSound("evil/loli/nuzzle.mp3")
util.PrecacheSound("evil/loli/rawr.mp3")
util.PrecacheSound("evil/loli/stophiding.mp3")
util.PrecacheSound("evil/loli/uwu.mp3")
util.PrecacheSound("evil/loli/canthide.mp3")
util.PrecacheSound("evil/loli/maga.mp3")
util.PrecacheSound("evil/loli/playwithme.mp3")
util.PrecacheSound("evil/loli/reee.mp3")
util.PrecacheSound("evil/loli/thereyouare.mp3")
util.PrecacheSound("evil/loli/yiff.mp3")
util.PrecacheSound("evil/loli/fun.mp3")
util.PrecacheSound("evil/loli/noescape.mp3")
util.PrecacheSound("evil/loli/question06.mp3")
util.PrecacheSound("evil/loli/senpai.mp3")
util.PrecacheSound("evil/loli/trap.mp3")
util.PrecacheSound("evil/mrbones/ache.mp3")
util.PrecacheSound("evil/mrbones/bonetopick.mp3")
util.PrecacheSound("evil/mrbones/hmyaa.mp3")
util.PrecacheSound("evil/mrbones/howunpleasant.mp3")
util.PrecacheSound("evil/mrbones/scare1.mp3")
util.PrecacheSound("evil/mrbones/suitcase.mp3")
util.PrecacheSound("evil/neckbeard/bodypillow1.mp3")
util.PrecacheSound("evil/neckbeard/bodypillow2.mp3")
util.PrecacheSound("evil/neckbeard/katana.mp3")
util.PrecacheSound("evil/neckbeard/maniac.mp3")
util.PrecacheSound("evil/neckbeard/reee.mp3")
util.PrecacheSound("evil/neckbeard/stophittingme.mp3")
util.PrecacheSound("evil/neckbeard/uwu.mp3")
util.PrecacheSound("evil/neckbeard/uwu2.mp3")
util.PrecacheSound("evil/neckbeard/waifu.mp3")
