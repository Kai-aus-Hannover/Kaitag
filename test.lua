local function sleep(zeit)
    io.popen(string.format([==[PING localhost -n %s >NUL]==], zeit))
end

function links(datei, a)
    local output = io.open(string.sub(datei, 1, a - 5) .. "-LINKS.txt", "r")
    if output then
        if string.len(io.open(string.sub(datei, 1, a - 5) .. "-LINKS.txt", "r"):read("*a")) > 0 then
            return
        end
    end
    local input = io.open(datei, "r")
    local inputtest
    while inputtest ~= input:read("*a") do
        inputtest = input:read("*a")
        sleep(1)
        input = io.open(datei, "r")
    end
    output = io.open(string.sub(datei, 1, a - 5) .. "-LINKS.txt", "w")
    for zeile in input:lines() do
        local nix, anfang, ende, link, beschreibung
        nix, anfang = string.find(zeile, '<A HREF="')
        if anfang then
            ende = string.find(zeile, '"', anfang + 1)
            if ende then
                link = string.sub(zeile, anfang + 1, ende - 1)
            end
        end
        nix, anfang = string.find(zeile, '>', ende)
        if anfang then
            ende = string.find(zeile, '<', anfang)
            if ende then
                beschreibung = string.sub(zeile, anfang + 1, ende - 1)
            end
        end
        if link and beschreibung then
            output:write(string.format([==[<a href="%s">%s</a>]==] .. "\n" , link, beschreibung))
        end
    end
    input:close()
    output:close()
end

for datei in io.popen([[dir "E:\Transfer" /s /b /a]]):lines() do
    local a = string.len(datei)
    if string.sub(datei, a - 4, a) == ".html" then
        print(pcall(links, datei, a))
    end
end
