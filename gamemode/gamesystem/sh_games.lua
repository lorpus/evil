Game.Gametypes = {
    pages = {
        name = "Pages",

        start = function()
            dbg.print("pages.start()")
        end,

        finish = function()
            dbg.print("pages.finish()")
        end,

        playable = function()
            return true
        end
    }
}