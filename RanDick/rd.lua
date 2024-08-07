require "tprint"
require "serialize"
require "aardwolf_colors"

--load randoms. structure stolen from kelaire bc this stuff is hard.
local randoms = {}
local borderColor = "@x025"
local textColor = "@x178"
local cmdColor = "@W"

local randick_prefix = "@W[@x184randick@W]"

if (GetVariable("rd_data") ~= nil) then
	luastmt = "obj = " .. GetVariable("rd_data")
	assert (loadstring (luastmt or "")) ()
	randoms = obj
end

function handle_rd(_,_,args)
    local randNum = math.random(1,(#randoms-1))
    local chan = args["channel"]
    local target = args["target"] or ""
    
    local social = randoms[randNum]
    local cmd = args["channel"] .. " *" .. social
    
    if not (target == "") or not (target == nil) then
        cmd = cmd .. " " .. target
    end

    colorsToAnsiNote(randick_prefix .. " " .. textColor .. social)
    Execute(cmd)
end

function handle_randick(_,_,args)
    local command = string.lower(args["command"])
    local argument = string.lower(args["argument"])
    if command == "help" then
        OnHelp()
    elseif command == "add" then
--[[
        I don't think I need to separate single and multiple.
    add_random(argument) --add single
    elseif command == "madd" then --add multiple ]]--
        add_multi()
    elseif command == "rem" then
        rem_random(argument)
    elseif command == "mrem" then
        rem_multi()
    elseif command == "list" then
        list_random()
    elseif command == "update" then
        if argument == "install" then update_install_alias()
        else update_check_alias() end
    else
        Note("something else?")
    end
end

function insert_random(thing)
    Note("adding " ..thing)
    -- check for existince of the social in array
    if checkTable(thing) then
        -- if true, string exists in list
        return false
    else
        -- if false, string does not exist in list.
        if not (thing == nil) or not (thing == "") then
            --if not an empty string, then do the insert
            table.insert(randoms,thing)
            SetVariable("rd_data", serialize.save_simple(randoms))
            return true
        else
            --if empty then no.
            return false
        end
    end
end

function add_random(argument)
    local newRandom = utils.inputbox(
        "Add a single social",
        "Add a single social"
        ,nil,nil,nil,
        {
            box_width=180,
            box_height=125,
            prompt_width=100,
            prompt_height=12,
            reply_height=20,
            reply_width=75
        }
    )
    if not isEmpty(newRandom) then insert_random(newRandom)
    else Note("You didn't put anything in the box :(") end
end

function add_multi()
    local randomList = utils.editbox(
        "Add socials, separated by comma or on separate lines",
        "Add socials",nil,nil,nil,
        {
            box_width=500,
            box_height=300,
            prompt_width=300,
            prompt_height=12
        })
    if isEmpty(randomList) then
        colorsToAnsiNote(randick_prefix .. textColor .. " That was a blank line. Try again.")
    elseif string.find(randomList,",") then
         Note("comma separated")
         local randTable = utils.split(randomList,",")
         for _,v in pairs(randTable) do
            insert_random(v)
         end
    elseif string.find(randomList,"\n") then
        Note("newline separated")
        local randTable = utils.split(randomList,"\n")
        for _,v in pairs(randTable) do
            local stringArr = {}
            insert_random(trim(string.sub(v,1,15)))
            insert_random(trim(string.sub(v,16,30)))
            insert_random(trim(string.sub(v,31,45)))
            insert_random(trim(string.sub(v,46,61)))
            --insert_random(v)
        end
    else
--        Note("I suppose you COULD use this to add a single random, but use randick add next time instead.")
        local randTable = utils.split(randomList,"\n")        
        for _,v in pairs(randTable) do
            local stringArr = {}
            insert_random(trim(string.sub(v,1,15)))
            insert_random(trim(string.sub(v,16,30)))
            insert_random(trim(string.sub(v,31,45)))
            insert_random(trim(string.sub(v,46,61)))
            --insert_random(v)
        end
    end
end

function rem_random(argument)
    if not isEmpty(randoms) then
        for i,j in ipairs(randoms) do
            if j==argument then table.remove(randoms,i) end
        end
    else
        
    end
    SetVariable("rd_data", serialize.save_simple(randoms))
end

function rem_multi()
    Note("feature coming soon...")
    --utils.multilistbox("description","title",{"arg","three","here"})
end

function list_random()
    Note("this will get prettier sometime")
    tprint(randoms)
end

function resetData()
	ColourNote("#0152a1","","----RANDICK RESET----")
    ColourNote("#0152a1","","HOPE YOU MADE A BACKUP")
	randoms = { }
	SetVariable("rd_data", serialize.save_simple(randoms))
end

-- utility functions
function isEmpty(testme)
    return testme == nil or testme==""
end

function trim(s)
    return(string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function checkTable(input)
    for _,j in ipairs(randoms) do
      if j == string.lower(input) then
        return true
      end
    end
    return false
end

function colorsToAnsiNote(data)
    return AnsiNote(ColoursToANSI(data))
  end

-- plugin meta stuff
function OnHelp()
    colorsToAnsiNote(borderColor .. "------------------" .. textColor .. "Randick Help" .. borderColor .. "------------------")
    Note()
    colorsToAnsiNote(borderColor .. "--==" .. textColor .. "Sending Randoms" .. borderColor .. "==--")
    colorsToAnsiNote(cmdColor .. "rd <channel> [target]")
    colorsToAnsiNote(textColor .. "     sends a random from " .. cmdColor .. "randick list" .. textColor .. " to " .. cmdColor .. "channel" .. textColor .. ", aimed at " .. cmdColor .. "target" .. textColor .. ".")
    colorsToAnsiNote(cmdColor .. "     channel" .. textColor .. " value is not optional. " .. cmdColor .. "target" .. textColor .. " value is optional.")
    Note()
    colorsToAnsiNote(borderColor .. "--==" .. textColor .. "Configuring Randick" .. borderColor .. "==--")
    colorsToAnsiNote(cmdColor .. "randick help")
    colorsToAnsiNote(textColor .. "     This helpfile")
    Note()
    colorsToAnsiNote(cmdColor .. "randick add")
    colorsToAnsiNote(textColor .. "     Opens a text box to add socials to. You can copy/paste directly from " .. cmdColor .. "social <word>" .. textColor .. " output from the mud,")
    colorsToAnsiNote(textColor .. "     or a list separated by commas, or each social on its own line.")
    Note()
    colorsToAnsiNote(cmdColor .. "randick rem <social>")
    colorsToAnsiNote(textColor .. "     Removes a single specified social from the list. Has to match exactly.")
--[[    Note()
    colorsToAnsiNote(cmdColor .. "randick mrem")
    colorsToAnsiNote(textColor .. "     Future feature. Maybe. To remove multiple socials in one go. Probably won't make this actually happen, but you never know.") ]]--
    Note()
    colorsToAnsiNote(cmdColor .. "randick list")
    colorsToAnsiNote(textColor .. "     Shows the current list of socials. It's ugly right now. Maybe some day it will be less ugly.")
end

function OnPluginSaveState()
    SetVariable("rd_data",serialize.save_simple(randoms))
end
  -- On plugin install ...
  -- more stuff I stole from Kel :D
function OnPluginInstall(msg, id, name, text)
	ColourNote("#0152a1","","----RANDICK ENABLED----")
	if (GetVariable("rd_data") ~= nil) then
		-- load saved variables if they exist
		luastmt = "obj = " .. GetVariable("rd_data")
		assert (loadstring (luastmt or "")) ()
		randoms = obj
        Note("loaded rd_data")
	else
        Note("reset rd_data")
		resetData()
	end
end

  ----------------------- Plugin Update Code -----------------------
 -- Code taken from Durel's dinv plugin, originally via Crowley
 require("wait")
require("async")
json = require("json")

 plugin_url = "https://raw.githubusercontent.com/Anssett/Aard-Plugins/main/RanDick/RD.xml"
 plugin_lua_url = "https://raw.githubusercontent.com/Anssett/Aard-Plugins/main/RanDick/rd.lua"

 SetVariable("DownloadURL", plugin_url)
 plugin_protocol = "HTTPS"
 plugin_prefix = "[Randick]"
 
 function update_check_alias()
     update_plugin("check")
     ColourNote("white", "", plugin_prefix .. " Checking for updated version...")
 end
 
 function update_install_alias()
     update_plugin("install")
     ColourNote("white", "", plugin_prefix .. " Checking for and installing updated version...")
 end
 
 function reload_plugin()
     local scriptPrefix = GetAlphaOption("script_prefix")
     local retval
 
     -- If the user has not already specified the script prefix for this version of mush, pick a
     -- reasonable default value
     if (scriptPrefix == "") then
         scriptPrefix = "\\\\\\"
         SetAlphaOption("script_prefix", scriptPrefix)
     end
 
     -- Tell mush to reload the plugin in one second.  We can't do it directly here because a
     -- plugin can't unload itself.  Even if it could, how could it tell mush to load it again
     -- if it weren't installed? 
     retval = Execute(scriptPrefix.."DoAfterSpecial(0.1, \"ReloadPlugin('"..GetPluginID().."')\", sendto.script)")
 end
 
 function update_plugin(mode)
     update_mode = mode
 
     wait.make(get_plugin_file)
 end
 
 function get_plugin_file()
     local urlThread = async.request(plugin_url, plugin_protocol)
     local urlLuaThread = async.request(plugin_lua_url, plugin_protocol)
 
     if not urlThread or not urlLuaThread then
         note_error("Couldn't create async url request.")
         return
     end
--[[ can maybe remove this...
     if not urlLuaThread then
        note_error("Couldn't create async url request - lua file")
        return
     end
    ]]--  
     local timeout = 10
     local totTime = 0
     while (urlThread:alive() and totTime < timeout) do
         wait.time(0.1)
         totTime = totTime + 0.1
     end
 
     local remoteRet, pluginData, status, headers, fullStatus = urlThread:join()
     local remoteRetLua, pluginDataLua, statusLua, headersLua, fullStatusLua = urlLuaThread:join()
 
     if not status or not statusLua then
         ColourNote("red", "", plugin_prefix .. " Couldn't download plugin file. No status code.")
         
         return
     end
 
     if (status ~= 200) or (statusLua ~= 200) then
         ColourNote("red", "", plugin_prefix .. " Plugin file request status code: " .. status .. ": " .. fullStatus)
         return
     end
     
     local currentVersion = GetPluginInfo(GetPluginID(), 19) or 0
     local currentVerStr  = string.format("%1.3f", currentVersion)
     local remoteVerStr   = string.match(pluginData, '%s%s+version="([0-9%.]+)"')
     local remoteVersion  = tonumber(remoteVerStr or "") or 0
 
     if remoteVersion == currentVersion then
         ColourNote("white", "", plugin_prefix .. " You are running the most recent version (v" .. currentVerStr .. ")")
     elseif (remoteVersion < currentVersion) then
         ColourNote("white", "", plugin_prefix .. " You have a newer version than is publicly available. (v" .. currentVerStr .. ")")
     elseif (update_mode == "check") then
         ColourNote("white", "", plugin_prefix .. " You are running v" .. currentVerStr .. ", but there's a newer version v" .. remoteVerStr)
     elseif (update_mode == "install") then
         ColourNote("white", "", plugin_prefix .. " Updating plugin from version " .. currentVerStr .. " to version " .. remoteVerStr) 
 
         local pluginFile = GetPluginInfo(GetPluginID(), 6)
         local file = io.open(pluginFile, "wb")
         file:write(pluginData)
         file:close()

         local pluginLuaFile = string.sub(GetPluginInfo(GetPluginID(),6),0,-4).."lua"
         local luafile = io.open(pluginLuaFile,"wb")
         luafile:write(pluginDataLua)
         luafile:close()
         
         reload_plugin()
     else
         ColourNote("red", "", plugin_prefix .. " Invalid update mode: " .. update_mode)
     end
 end
 ----------------------- End Plugin Update Code -----------------------