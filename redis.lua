core.Info("Starting haproxy redis.. this is getting serious")

-- This is where all the redis data is stored
DB = {}

OKAY = "+OK\r\n"
NIL = "$-1\r\n"

function handle_set(cmd)
    if cmd[1] == nil or cmd[2] == nil then
        return "-ERR wrong number of arguments for 'set' command\r\n"
    end
    core.Debug("handle set")
    DB[cmd[1]] = cmd[2]
    return OKAY
end

function handle_get(cmd)
    core.Debug("handle get")
    if cmd[1] == nil then
        return "-ERR wrong number of arguments for 'get' command\r\n"
    end
    local val = DB[cmd[1]]
    if val == nil then
        return NIL
    end
    return '+' .. val .. '\r\n'
end

function handle_del(cmd)
    core.Debug("handle del")
    if cmd[1] == nil then
        return "-ERR wrong number of arguments for 'del' command\r\n"
    end
    if DB[cmd[1]] == nil then
        return ":0\r\n"
    end
    DB[cmd[1]] = nil
    return ":1\r\n"
end


function handle_cmd(cmd)
    local ret = ""
    if cmd[0]:lower() == "set" then
        ret = handle_set(cmd)
    elseif cmd[0]:lower() == "get" then
        ret = handle_get(cmd)
    elseif cmd[0]:lower() == "del" then
        ret = handle_del(cmd)
    elseif cmd[0]:lower() == "command" then
        ret = OKAY
    else
        core.Debug("unsupported: " .. cmd[0])
        return "-ERR unsupported command\r\n"
    end
    return ret
end

function parse_command_array(line, applet)
    -- get the length of the array then parse 2X for each command
    if string.find(line, "*") == 1 then
        core.Debug("array line: " .. line)
        local arg_length = string.gsub(line, "%D+", "")
        local cmd = {}
        -- cheating lua with indexing at 0
        local i = 0
        while i < tonumber(arg_length)  do
            -- drop length cause lua reads lines like pros and are lazy
            local a = applet:getline()
            local arg = string.gsub(applet:getline(), "%W+", "")
            cmd[i] = arg
            i = i+1
        end
        local ret = handle_cmd(cmd)
        return ret
    end
    return "-ERR unknown error"
end


core.register_service("haproxyredis", "tcp", function(applet)
    while true do
        local line = applet:getline()
        if line == nil then
            return
        end
        if line == "" then
            core.Info("Closing connection.") return
        end
        local r = parse_command_array(line, applet)
        if r ~= nil then
            core.Debug("sending: " .. r)
            applet:send(r)
        end
    end
end)
