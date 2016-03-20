
-- Copyright 2015
-- Matthew
-- Licensed to the public under the Apache License 2.0.

m = Map("cifs", translate("Mounting NAT drives"))

s = m:section(TypedSection, "cifs", "Cifs")
s.anonymous = true

s:tab("general",  translate("General Settings"))
s:tab("template", translate("Edit Template"))

s:taboption("general", Value, "workgroup", translate("Workgroup"))
s:taboption("general", Value, "mountarea", translate("Mount_Area"))
s:taboption("general", Value, "delay", translate("Delay"))
s:taboption("general", Value, "iocharset", translate("Iocharset"),
        translate("Character Encoding"))

s = m:section(TypedSection, "sambashare", translate("Shared Directories"))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

am = s:option(Value, "server", translate("Server"))
am.size = 6

bm = s:option(Value, "name", translate("Name"))
bm.size = 6

pth = s:option(Value, "path", translate("Path"))
if nixio.fs.access("/etc/config/fstab") then
        pth.titleref = luci.dispatcher.build_url("admin", "system", "fstab")
end

cm = s:option(Value, "arguments", translate("Arguments"))
cm.rmempty = true
cm.size = 4

ro = s:option(Flag, "nounix", translate("Disable Unix Extensions"))
ro.rmempty = false
ro.enabled = "1"
ro.disabled = "0"

ro = s:option(Flag, "guest", translate("Using Guest"))
ro.rmempty = false
ro.enabled = "1"
ro.disabled = "0"

bm = s:option(Value, "users", translate("Users"))
bm.size = 3

dm = s:option(Value, "pwd", translate("password"))
dm.rmempty = true
dm.size = 3

local apply = luci.http.formvalue("cbi.apply")
if apply then
	io.popen("/etc/init.d/cifs restart")
end


return m