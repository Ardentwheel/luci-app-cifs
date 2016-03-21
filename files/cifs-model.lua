-- Copyright 2015
-- Matthew
-- Licensed to the public under the Apache License 2.0.

local fs = require "nixio.fs"

local state_msg = ""
local ss_redir_on = (luci.sys.call("pidof cifsd > /dev/null") == 0)
if ss_redir_on then	
	state_msg = "<b><font color=\"green\">" .. translate("Running") .. "</font></b>"
else
	state_msg = "<b><font color=\"red\">" .. translate("Not running") .. "</font></b>"
end

m = Map("cifs", translate("Mounting NAT drives"),
	translate("Allows you mounting Nat drives") .. " - " .. state_msg)

s = m:section(TypedSection, "cifs", "Cifs")
s.anonymous = true



s:tab("general",  translate("General Settings"))

switch = s:taboption("general", Flag, "enabled", translate("Enable"))
switch.rmempty = false

s:taboption("general", Value, "workgroup", translate("Workgroup"))
s:taboption("general", Value, "mountarea", translate("Mount_Area"))
s:taboption("general", Value, "delay", translate("Delay"))
s:taboption("general", Value, "iocharset", translate("Iocharset"),
        translate("Character Encoding"))




s = m:section(TypedSection, "natshare", translate("NAT Drivers"))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

server = s:option(Value, "server", translate("Server"))
server.size = 6

name = s:option(Value, "name", translate("Name"))
name.size = 6

pth = s:option(Value, "natpath", translate("NatPath"))
if nixio.fs.access("/etc/config/fstab") then
        pth.titleref = luci.dispatcher.build_url("admin", "system", "fstab")
end

agm = s:option(Value, "agm", translate("Arguments"))
agm:value("rm", translate"rm: Read Only")
agm:value("rw", translate"rw: Read and Write")
agm:value("noperm")
agm:value("noacl")
agm:value("sfu")
agm:value("dirctio")
agm:value("file_mode=0755,dir_mode=0n755")
agm:value("nounix", translate"nounix: Disable Unix Extensions")
agm.rmempty = true
agm.size = 8

guest = s:option(Flag, "guest", translate("Using Guest"))
guest.rmempty = false
guest.enabled = "1"
guest.disabled = "0"

users = s:option(Value, "users", translate("Users"))
users.size = 3

pwd = s:option(Value, "pwd", translate("password"))
pwd.rmempty = true
pwd.size = 3

local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/cifs restart")
end


return m
