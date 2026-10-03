-- VoidcxzHub | Steal An Egg
-- Version 6.1.0  |  build 704ce183  |  9e892c9  |  2026-09-19 20:22 UTC
--
-- GENERATED FILE - DO NOT EDIT.
-- Edit the modules in src/ and run: python tools/build.py
--
-- Modules in load order:
--   boot/00_runtime.lua                  143 lines
--   boot/01_log.lua                      174 lines
--   boot/02_scope.lua                    173 lines
--   boot/03_profile.lua                  249 lines
--   core/services.lua                     34 lines
--   core/net.lua                          77 lines
--   core/scan.lua                         56 lines
--   core/data.lua                        774 lines
--   core/profiles.lua                    459 lines
--   core/exec.lua                        359 lines
--   core/device.lua                      122 lines
--   core/character.lua                    84 lines
--   core/restore.lua                     135 lines
--   core/config.lua                       31 lines
--   core/state.lua                        14 lines
--   core/motion.lua                      156 lines
--   core/util.lua                         29 lines
--   auth/vampauth.lua                     98 lines
--   ui/logodata.lua                       19 lines
--   ui/logo.lua                          134 lines
--   ui/wording.lua                        68 lines
--   ui/splash.lua                        711 lines
--   ui/stats.lua                        1828 lines
--   ui/island.lua                        181 lines
--   ui/recap.lua                         193 lines
--   ui/lib/theme.lua                     551 lines
--   ui/lib/render.lua                    224 lines
--   ui/lib/widgets.lua                  2074 lines
--   ui/lib/init.lua                     2389 lines
--   ui/adapter.lua                       367 lines
--   ui/shell.lua                         162 lines
--   ui/tabs/home.lua                      88 lines
--   ui/tabs/main.lua                     446 lines
--   ui/tabs/farm.lua                     658 lines
--   ui/tabs/event.lua                    295 lines
--   ui/tabs/misc.lua                     192 lines
--   ui/tabs/config.lua                   169 lines
--   features/movement.lua                686 lines
--   features/humanoid.lua                217 lines
--   features/jump.lua                     75 lines
--   features/antideath.lua               128 lines
--   features/guard.lua                   249 lines
--   features/guardwatch.lua               90 lines
--   features/treadmill.lua               154 lines
--   features/farm/index.lua              159 lines
--   features/farm/filter.lua             529 lines
--   features/farm/priority.lua           190 lines
--   features/farm/treadmill_on.lua       391 lines
--   features/farm/pets.lua                35 lines
--   features/farm/plotcare.lua           470 lines
--   features/esp/cards.lua               367 lines
--   features/esp/eggs.lua                171 lines
--   features/esp/plot.lua                259 lines
--   features/misc/servers.lua            310 lines
--   features/misc/webhook.lua            270 lines
--   features/gamethrottle.lua            173 lines
--   features/fps.lua                     477 lines
--   features/boss.lua                    287 lines
--   features/rift.lua                    647 lines
--   features/drones.lua                  526 lines
--   features/catalogdata.lua             177 lines
--   features/catalog.lua                 198 lines
--   features/eggs.lua                   1315 lines
--   features/grab.lua                    343 lines
--   features/instant.lua                 317 lines
--   features/plot.lua                    242 lines
--   features/regrab.lua                  172 lines
--   features/carry.lua                   402 lines
--   features/bait.lua                    319 lines
--   features/autosteal.lua              1115 lines
--   features/bossfight.lua              1326 lines
--   features/prewarm.lua                 103 lines
--   main.lua                             532 lines

local VOIDCXZ_VERSION = "6.1.0"
local VOIDCXZ_BUILD   = "704ce183"
local VOIDCXZ_GAME    = "Steal An Egg"
local VOIDCXZ_EDITION = "free"

local env = (type(getgenv) == "function" and getgenv()) or _G
env.VoidcxzGeneration = (env.VoidcxzGeneration or 0) + 1
local BX = {
generation  = env.VoidcxzGeneration,
version     = VOIDCXZ_VERSION,
build       = VOIDCXZ_BUILD,
game        = VOIDCXZ_GAME,
edition     = VOIDCXZ_EDITION or "full",
_factories  = {},
_loaded     = {},
_loading    = {},
_conns      = {},
}
env.BX = BX
function BX.alive()
return env.VoidcxzGeneration == BX.generation
end
function BX.module(name, factory)
if BX._factories[name] then
error(("duplicate module %q"):format(name), 2)
end
BX._factories[name] = factory
end
function BX.require(name)
local cached = BX._loaded[name]
if cached ~= nil then return cached end
if BX._loading[name] then
error(("circular dependency: %s"):format(name), 2)
end
local factory = BX._factories[name]
if not factory then
error(("no such module: %s"):format(name), 2)
end
BX._loading[name] = true
local ok, result = pcall(factory, BX)
BX._loading[name] = nil
if not ok then
error(("module %q failed to load: %s"):format(name, tostring(result)), 2)
end
if result == nil then
error(("module %q returned nil (forgot to return M?)"):format(name), 2)
end
BX._loaded[name] = result
return result
end
function BX.connect(signal, fn)
local c = signal:Connect(fn)
BX._conns[#BX._conns + 1] = c
return c
end
function BX.offthread(fn, timeout)
local done, result, failure = false, nil, nil
task.spawn(function()
local ok, r = pcall(fn)
if ok then result = r else failure = r end
done = true
end)
local startedAt = os.clock()
timeout = timeout or 5
while not done and (os.clock() - startedAt) < timeout do
task.wait(0.03)
end
return result, done, failure
end
BX._teardownHooks = {}
function BX.onTeardown(label, fn)
BX._teardownHooks[#BX._teardownHooks + 1] = { label = tostring(label), fn = fn }
end
function BX.teardown()
if BX._tornDown then return end
BX._tornDown = true
for i = #BX._teardownHooks, 1, -1 do
local h = BX._teardownHooks[i]
local ok, err = pcall(h.fn)
if not ok then
pcall(function()
local lg = BX._loaded["boot.log"]
if lg then lg._emit(4, "teardown", ("%s: %s"):format(h.label, tostring(err))) end
end)
end
end
BX._teardownHooks = {}
pcall(function()
local lg = BX._loaded["boot.log"]
if lg and lg.flushNow then lg.flushNow() end
end)
if BX.destroyAllScopes then pcall(BX.destroyAllScopes) end
for _, c in ipairs(BX._conns) do
pcall(function() c:Disconnect() end)
end
BX._conns = {}
BX._loaded = {}
end
if type(env.VoidcxzTeardown) == "function" then
pcall(env.VoidcxzTeardown)
end
env.VoidcxzTeardown = BX.teardown
BX.module("boot.log", function(BX)
local M = {}
local TRACE_FILE  = "VoidcxzHub_trace.txt"
local FLUSH_GAP   = 3.0
local RING        = 500   
local canWrite  = (type(writefile) == "function")
local debugOn   = function()
local env = (type(getgenv) == "function" and getgenv()) or _G
return env.VoidcxzDebug == true
end
local PREV_FILE = "VoidcxzHub_trace_prev.txt"
if canWrite and type(readfile) == "function" and type(isfile) == "function" then
pcall(function()
local env = (type(getgenv) == "function" and getgenv()) or _G
if env.__VOIDCXZ_LOG_ROTATED then return end
env.__VOIDCXZ_LOG_ROTATED = true
if isfile(TRACE_FILE) then writefile(PREV_FILE, readfile(TRACE_FILE)) end
end)
end
if canWrite then
pcall(writefile, TRACE_FILE, "[boot] VoidcxzHub logger initialized\n")
end
local ring, ringN, ringHead = {}, 0, 0
local flushAt     = 0
local seen, seenN = {}, 0   
local SEEN_MAX    = 400     
M.LEVELS = { TRACE = 1, INFO = 2, WARN = 3, ERROR = 4 }
M.level  = M.LEVELS.INFO
local function stamp()
return ("%7.2f"):format(os.clock())
end
local dirty = false
local function writeNow()
if not canWrite then return end
flushAt = os.clock()
dirty = false
local out, n = {}, 0
local start = (ringN < RING) and 1 or (ringHead % RING) + 1
for i = 0, ringN - 1 do
n = n + 1
out[n] = ring[((start - 1 + i) % RING) + 1]
end
local body = table.concat(out, "\n", 1, n)
if BX.profile and BX.profile.measure then
BX.profile.measure("log/writefile", pcall, writefile, TRACE_FILE, body)
else
pcall(writefile, TRACE_FILE, body)
end
end
local function flush(force)
if not canWrite then return end
if force then return writeNow() end
dirty = true
end
if canWrite then
task.spawn(function()
while BX.alive() do
task.wait(FLUSH_GAP)
if dirty then pcall(writeNow) end
end
if dirty then pcall(writeNow) end
end)
end
function M.flushNow() pcall(writeNow) end
local TAGS = { "TRACE", "INFO", "WARN", "ERROR" }
local function emit(level, mod, msg)
if level < M.level then return end
local line = ("[%s] %-5s %-16s %s"):format(stamp(), TAGS[level], mod, msg)
ringHead = (ringHead % RING) + 1
ring[ringHead] = line
if ringN < RING then ringN = ringN + 1 end
if debugOn() or level >= M.LEVELS.WARN then
print("[VOIDCXZ] " .. line)
end
flush(level >= M.LEVELS.ERROR)
end
function M.for_module(name)
return {
trace = function(m, ...)
if M.level > 1 then return end
emit(1, name, select("#", ...) > 0 and m:format(...) or m)
end,
info  = function(m, ...) emit(2, name, select("#", ...) > 0 and m:format(...) or m) end,
warn  = function(m, ...) emit(3, name, select("#", ...) > 0 and m:format(...) or m) end,
error = function(m, ...) emit(4, name, select("#", ...) > 0 and m:format(...) or m) end,
}
end
function M.session(msg)
emit(2, "session", "=== " .. msg .. " ===")
flush(true)
end
function M.repeats()
local out = {}
for label, n in pairs(seen) do
if n > 1 then out[#out + 1] = ("%s x%d"):format(label, n) end
end
table.sort(out)
return out
end
function BX.try(label, fn, ...)
local ok, result = pcall(fn, ...)
if not ok then
if seen[label] == nil then
if seenN >= SEEN_MAX then
label = "(other)"
else
seenN = seenN + 1
end
end
local n = (seen[label] or 0) + 1
seen[label] = n
if n == 1 then
emit(4, "try", ("%s: %s"):format(label, tostring(result)))
elseif n == 10 or n == 100 or n == 1000 then
emit(3, "try", ("%s: still failing (x%d)"):format(label, n))
end
end
return ok, result
end
function BX.guard(label, fn)
return function(...)
return select(2, BX.try(label, fn, ...))
end
end
M._emit = emit
M._seen = seen
return M
end)
BX._scopes = {}
function BX.scope(name)
local existing = BX._scopes[name]
if existing and not existing.dead then existing:destroy() end
local sc = {
name    = name,
dead    = false,
conns   = {},
insts   = {},
threads = {},
tweens  = {},
gen     = BX.generation,
}
function sc:alive()
return (not self.dead) and BX.alive()
end
function sc:connect(signal, fn)
if self.dead then return nil end
local c = signal:Connect(fn)
self.conns[#self.conns + 1] = c
return c
end
function sc:own(inst)
if self.dead then
pcall(function() inst:Destroy() end)
return inst
end
self.insts[#self.insts + 1] = inst
return inst
end
function sc:spawn(label, fn, ...)
if self.dead then return nil end
local th
th = task.spawn(function(...)
BX.try(self.name .. "/" .. label, fn, ...)
for i, t in ipairs(self.threads) do
if t == th then table.remove(self.threads, i) break end
end
end, ...)
self.threads[#self.threads + 1] = th
return th
end
function sc:loop(label, interval, fn)
local tag = self.name .. "/" .. label
local body = BX.profile and BX.profile.wrapLoop(tag, interval, fn) or fn
return self:spawn(label .. "/loop", function()
while self:alive() do
BX.try(tag, body)
if not self:alive() then return end
task.wait(interval)
end
end)
end
function sc:onFrame(label, signal, fn)
local tag = self.name .. "/" .. label
local guarded = BX.guard(tag, fn)
local timed = BX.profile and BX.profile.wrap(tag, guarded) or guarded
return self:connect(signal, timed)
end
function sc:delay(label, seconds, fn)
if self.dead then return end
task.delay(seconds, function()
if not self:alive() then return end
BX.try(self.name .. "/" .. label, fn)
end)
end
function sc:tween(obj, t, props, style, dir)
if self.dead then return nil end
local tween
BX.try(self.name .. "/tween", function()
tween = BX.require("core.services").TweenService:Create(obj,
TweenInfo.new(t, style or Enum.EasingStyle.Quint,
dir or Enum.EasingDirection.Out), props)
tween:Play()
end)
if tween then self.tweens[#self.tweens + 1] = tween end
return tween
end
function sc:destroy()
if self.dead then return end
self.dead = true
for _, c in ipairs(self.conns) do pcall(function() c:Disconnect() end) end
for _, t in ipairs(self.tweens) do pcall(function() t:Cancel() end) end
for _, i in ipairs(self.insts) do pcall(function() i:Destroy() end) end
local me = coroutine.running()
for _, th in ipairs(self.threads) do
if th ~= me then pcall(task.cancel, th) end
end
self.conns, self.insts, self.threads, self.tweens = {}, {}, {}, {}
if BX._scopes[self.name] == self then BX._scopes[self.name] = nil end
end
function sc:counts()
return {
conns   = #self.conns,
insts   = #self.insts,
threads = #self.threads,
tweens  = #self.tweens,
}
end
BX._scopes[name] = sc
return sc
end
function BX.scopeReport()
local out = {}
for name, sc in pairs(BX._scopes) do
if not sc.dead then
local c = sc:counts()
out[#out + 1] = ("%-24s conns=%-3d insts=%-4d threads=%-3d tweens=%d")
:format(name, c.conns, c.insts, c.threads, c.tweens)
end
end
table.sort(out)
return out
end
function BX.destroyAllScopes()
for _, sc in pairs(BX._scopes) do
pcall(function() sc:destroy() end)
end
BX._scopes = {}
end
BX.profile = {
enabled = true,
_stats  = {},    
_mem0   = nil,
_t0     = os.clock(),
}
local P = BX.profile
P._watch = {}
function P.watch(name, fn) P._watch[name] = fn end
function P.watched()
local out = {}
for name, fn in pairs(P._watch) do
local ok, n = pcall(fn)
out[#out + 1] = ("%s=%s"):format(name, ok and tostring(n) or "?")
end
table.sort(out)
return out
end
P._marks = {}
local function markRead()
local plr = game:GetService("Players").LocalPlayer
local char = plr and plr.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not hum then return -1, "no-humanoid", false end
return hum.Health, hum:GetState().Name, hum:GetAttribute("VoidcxzStealHum") == true
end
function P.mark(name)
local ok, health, state, swapped = pcall(markRead)
local row = {
name = name, at = os.clock(),
health = ok and health or -1,
state = ok and state or "?",
swapped = ok and swapped or false,
}
P._marks[#P._marks + 1] = row
if #P._marks > 200 then table.remove(P._marks, 1) end
return row
end
function P.marksSince(t)
local out = {}
for _, r in ipairs(P._marks) do
if r.at >= (t or 0) then
out[#out + 1] = ("%s@%.2f hp=%.0f %s%s"):format(
r.name, r.at - (t or 0), r.health, r.state, r.swapped and " swapped" or "")
end
end
return out
end
local heapKb = function()
local ok, v = pcall(collectgarbage, "count")
return (ok and type(v) == "number") and v or 0
end
P.journalOn = false
P._journal, P._jHead, P.JOURNAL = {}, 0, 512
function P.stamp(label, t0, dt)
if not P.journalOn then return end
P._jHead = (P._jHead % P.JOURNAL) + 1
local row = P._journal[P._jHead]
if not row then row = {}; P._journal[P._jHead] = row end
row[1], row[2], row[3] = label, t0, dt
end
local function statFor(label, kind, interval)
local s = P._stats[label]
if not s then
s = { n = 0, total = 0, max = 0, last = 0, alloc = 0, kind = kind,
interval = interval, since = os.clock(), yields = 0, wall = 0 }
P._stats[label] = s
end
return s
end
P.frameNo = 0
BX.scope("boot.profile.clock"):connect(game:GetService("RunService").Heartbeat, function()
P.frameNo = P.frameNo + 1
end)
local function timed(s, label, fn, ...)
local t0, k0, f0 = os.clock(), heapKb(), P.frameNo
local r1, r2, r3, r4 = fn(...)
local dt = os.clock() - t0
s.n = s.n + 1
if P.frameNo ~= f0 then
s.yields = s.yields + 1
s.wall = s.wall + dt
return r1, r2, r3, r4
end
local dk = heapKb() - k0
s.total = s.total + dt
s.last = dt
if dk > 0 then s.alloc = s.alloc + dk end
if dt > s.max then s.max = dt end
if P.journalOn then P.stamp(label, t0, dt) end
return r1, r2, r3, r4
end
function P.wrap(label, fn)
local s = statFor(label, "frame")
return function(...)
if not P.enabled then return fn(...) end
return timed(s, label, fn, ...)
end
end
function P.wrapLoop(label, interval, fn)
local s = statFor(label, "loop", interval)
return function(...)
if not P.enabled then return fn(...) end
return timed(s, label, fn, ...)
end
end
function P.measure(label, fn, ...)
if not P.enabled then return fn(...) end
timed(statFor(label, "io"), label, fn, ...)
end
function P.rows()
local rows, now = {}, os.clock()
for label, s in pairs(P._stats) do
if s.n > 0 then
local sync = math.max(s.n - s.yields, 1)
rows[#rows + 1] = {
label = label, kind = s.kind,
hz    = s.n / math.max(now - s.since, 0.001),
avg   = (s.total / sync) * 1000,
max   = s.max * 1000,
total = s.total,
n     = s.n,
yields = s.yields,
wallAvg = s.yields > 0 and (s.wall / s.yields) * 1000 or 0,
kbPer = s.alloc / sync,
interval = s.interval,
}
end
end
table.sort(rows, function(a, b) return a.total > b.total end)
return rows
end
function P.reset()
for _, s in pairs(P._stats) do
s.n, s.total, s.max, s.last, s.alloc, s.since = 0, 0, 0, 0, 0, os.clock()
s.yields, s.wall = 0, 0
end
end
function P.report()
local out = { ("%-40s %-5s %7s %8s %8s %8s %8s %5s"):format(
"job", "kind", "hz", "avg ms", "max ms", "calls", "kb/call", "yld") }
for _, r in ipairs(P.rows()) do
out[#out + 1] = ("%-40s %-5s %7.2f %8.3f %8.3f %8d %8.2f %5d")
:format(r.label, r.kind, r.hz, r.avg, r.max, r.n, r.kbPer, r.yields)
end
return out
end
local StatsService = game:GetService("Stats")
local function memMb()
local ok, v = pcall(StatsService.GetTotalMemoryUsageMb, StatsService)
if ok and type(v) == "number" then return v end
ok, v = pcall(gcinfo)
return (ok and type(v) == "number") and (v / 1024) or 0
end
function P.health()
local conns, threads, scopes, insts = 0, 0, 0, 0
for _, sc in pairs(BX._scopes or {}) do
if not sc.dead then
scopes = scopes + 1
conns   = conns + #sc.conns
insts   = insts + #sc.insts
threads = threads + #sc.threads
end
end
local mem = memMb()
P._mem0 = P._mem0 or mem
local loaded = 0
for _ in pairs(BX._loaded) do loaded = loaded + 1 end
return {
uptime  = os.clock() - P._t0,
mem     = mem,
memGrow = mem - P._mem0,
scopes  = scopes,
conns   = conns,
insts   = insts,
threads = threads,
loaded  = loaded,
}
end
function P.start()
local sc  = BX.scope("boot.profile")
local log = BX.require("boot.log").for_module("profile")
local fps, lastFrame, last = 0, P.frameNo, os.clock()
sc:loop("health", 60, function()
local now = os.clock()
fps = (P.frameNo - lastFrame) / math.max(now - last, 0.001)
lastFrame, last = P.frameNo, now
local h = P.health()
local w = P.watched()
log.info("health up=%.0fs fps=%.0f mem=%.0fMB (%+.0f) scopes=%d conns=%d insts=%d threads=%d%s",
h.uptime, fps, h.mem, h.memGrow, h.scopes, h.conns, h.insts, h.threads,
#w > 0 and (" | " .. table.concat(w, " ")) or "")
end)
return sc
end
BX.module("core.services", function(BX)
local log = BX.require("boot.log").for_module("services")
local M = {}
local WANTED = {
"Players", "ReplicatedStorage", "RunService", "TweenService",
"UserInputService", "Lighting", "Workspace", "HttpService",
"TextService", "Stats",
"TeleportService",
}
for _, name in ipairs(WANTED) do
local ok, svc = pcall(game.GetService, game, name)
if ok and svc then
M[name] = svc
else
log.error("service unavailable: %s", name)
end
end
if M.Players and not M.Players.LocalPlayer then
local deadline = os.clock() + 10
while not M.Players.LocalPlayer and os.clock() < deadline do task.wait(0.1) end
if M.Players.LocalPlayer then
log.info("LocalPlayer arrived late (%.1fs) - waited for it", 10 - (deadline - os.clock()))
else
log.error("Players.LocalPlayer is still nil after 10s")
end
end
M.LocalPlayer = M.Players and M.Players.LocalPlayer
return M
end)
BX.module("core.net", function(BX)
local svc = BX.require("core.services")
local log = BX.require("boot.log").for_module("net")
local M = {}
local container, containerAt = nil, 0
local CONTAINER_TTL = 30
local function networking()
local now = os.clock()
if container and container.Parent and (now - containerAt) < CONTAINER_TTL then
return container
end
local pkgs = svc.ReplicatedStorage:FindFirstChild("Packages")
local net = pkgs and pkgs:FindFirstChild("Networking")
container, containerAt = net, now
return net
end
function M.find(name)
local net = networking()
return net and net:FindFirstChild(name) or nil
end
function M.call(name, ...)
local rf = M.find(name)
if not rf then return false, "remote not found: " .. tostring(name) end
local ok, a, b = pcall(function(...) return rf:InvokeServer(...) end, ...)
if not ok then return false, tostring(a) end
return a, b
end
function M.list(pattern)
local net = networking()
if not net then return {} end
local out = {}
for _, remote in ipairs(net:GetChildren()) do
local name = remote.Name
if not pattern or name:lower():find(pattern, 1, true) then
out[#out + 1] = ("%s (%s)"):format(name, remote.ClassName)
end
end
table.sort(out)
return out
end
function M.fire(name, ...)
local re = M.find(name)
if not re then return false, "remote not found: " .. tostring(name) end
local ok, err = pcall(function(...) re:FireServer(...) end, ...)
if not ok then return false, tostring(err) end
return true
end
return M
end)
BX.module("core.scan", function(BX)
local M = {}
function M.collect(root, visit, budget)
if not root or type(visit) ~= "function" then return 0 end
budget = tonumber(budget) or 0.0015
local stack = { root }
local count = 0
while #stack > 0 do
local sliceAt = os.clock()
local batch = 0
repeat   
local node = table.remove(stack)
local ok, children = pcall(node.GetChildren, node)
if ok and type(children) == "table" then
for i = #children, 1, -1 do
stack[#stack + 1] = children[i]
end
end
if node ~= root then
local keepGoing = visit(node)
count = count + 1
if keepGoing == false then
stack = {}
end
end
batch = batch + 1
if batch >= 256 then
task.wait()
batch = 0
end
until #stack == 0 or os.clock() - sliceAt >= budget
task.wait()
end
return count
end
function M.snapshot(root, budget)
local out = {}
M.collect(root, function(node)
out[#out + 1] = node
end, budget)
return out
end
return M
end)
BX.module("core.data", function(BX)
local svc  = BX.require("core.services")
local exec = BX.require("core.exec")
local log  = BX.require("boot.log").for_module("data")
local M = {}
local cache = {}      
local RETRY_AFTER = 2
local function atPath(...)
local node = svc.ReplicatedStorage
for _, part in ipairs({ ... }) do
if not node then return nil end
node = node:FindFirstChild(part)
end
return node
end
local heapTried, heapFound = false, {}
local HEAP_SHAPES = {
assets = function(t)
local dir = rawget(t, "Directory")
if type(dir) ~= "table" then return false end
for _, entry in pairs(dir) do
return type(entry) == "table" and type(entry.Rarity) == "table"
end
return false
end,
assetEarnings = function(t) return type(rawget(t, "LiveRatePerSecond")) == "function" end,
eggState = function(t) return type(rawget(t, "ReadFieldEggs")) == "function" end,
}
local SWEEP_FLAG = "VoidcxzHub/heap_sweep.flag"
local function harvestHeap()
if heapTried then return end
heapTried = true
if not exec.can.gc then
log.warn("require failed and this executor has no gc access - names and rates stay unavailable")
return
end
if exec.can.files and exec.isFile(SWEEP_FLAG) then
log.warn("skipping the heap sweep: the client died in one last run")
return
end
if exec.can.files then
exec.ensureFolder("VoidcxzHub")
exec.writeFile(SWEEP_FLAG, "sweeping")
end
local objs = exec.gcScan(true)
if exec.can.files then exec.deleteFile(SWEEP_FLAG) end
local scanned, hits = 0, {}
for _, obj in ipairs(objs) do
if type(obj) == "table" then
scanned = scanned + 1
for key, shape in pairs(HEAP_SHAPES) do
if not heapFound[key] then
local ok, matched = pcall(shape, obj)
if ok and matched then
heapFound[key] = obj
hits[#hits + 1] = key
end
end
end
end
end
log.info("heap sweep: %d tables, recovered %s", scanned,
#hits > 0 and table.concat(hits, ", ") or "NOTHING (this executor runs its own Lua state)")
end
local function assembleAssets(inst)
if not WARM_ENABLED then return nil end
local kids = inst:GetChildren()
local built, ok, failed = {}, 0, 0
for _, child in ipairs(kids) do
if child:IsA("ModuleScript") then
local entry
local got = pcall(function() entry = exec.requireGame(child) end)
if got and type(entry) == "table"
and (entry.DisplayName ~= nil or entry.Rarity ~= nil) then
built[child.Name] = entry
ok = ok + 1
else
failed = failed + 1
end
end
end
log.info("Data.Assets pieced from children: %d loaded, %d refused, of %d",
ok, failed, #kids)
if ok == 0 then return nil end
return { Directory = built }
end
local function searchModule(name)
for _, d in ipairs(svc.ReplicatedStorage:GetDescendants()) do
if d:IsA("ModuleScript") and d.Name == name then return d end
end
return nil
end
local warmed, warmDone, warmValues = false, {}, {}
local knownCategories = {}
function M.noteCategories(list)
for _, category in pairs(list or {}) do
if type(category) == "string" then knownCategories[category] = true end
end
end
local warmLoaded = 0
local WARM_ENABLED = false
local function warmModuleGraph()
local baked = BX._loaded["features.catalog"] or BX.require("features.catalog")
if baked and baked.loaded then
if not warmed then
warmed = true
log.info("baked catalog present - not reading any game module")
end
return 0
end
if not WARM_ENABLED then
if not warmed then
warmed = true
log.warn("module warm pass disabled: requiring game modules breaks the game's own scripts")
end
return 0
end
if warmed then return warmLoaded end
warmed = true
local roots = {}
local rs = svc.ReplicatedStorage
local assets = rs:FindFirstChild("Data")
assets = assets and assets:FindFirstChild("Assets")
local configs = assets and assets:FindFirstChild("Configs")
for _, d in ipairs(configs and configs:GetChildren() or {}) do
if d:IsA("ModuleScript") and #roots < 400 then roots[#roots + 1] = d end
end
if #roots == 0 then
log.warn("no Data.Assets.Configs modules to read - names and rates stay unavailable")
return 0
end
local loaded = 0
for pass = 1, 4 do
local before = loaded
for _, mod in ipairs(roots) do
if not warmDone[mod] then
local value
local ok = pcall(function() value = exec.requireGame(mod) end)
if ok then
warmDone[mod] = true
loaded = loaded + 1
if type(value) == "table" then warmValues[mod:GetFullName()] = value end
end
end
end
log.info("module warm pass %d: %d of %d loaded", pass, loaded, #roots)
if loaded == before then break end
end
warmLoaded = loaded
return loaded
end
local function knownCount()
local n = 0
for _ in pairs(knownCategories) do n = n + 1 end
return n
end
local function directoryScore(candidate)
if type(candidate) ~= "table" then return 0 end
local hits = 0
for category in pairs(knownCategories) do
local entry = rawget(candidate, category)
if type(entry) == "table" then hits = hits + 1 end
end
return hits
end
local saidMined = false
local slotShaped = nil
local function findSlotIdentity()
for name, value in pairs(warmValues) do
if type(rawget(value, "SlotKey")) == "function"
and type(rawget(value, "LooksLikeFirstAreaUid")) == "function" then
log.info("slot identity recovered from %s", name)
return value
end
end
return nil
end
local function directoryFromConfigs()
local built, n = {}, 0
for name, value in pairs(warmValues) do
local pet = name:match("^ReplicatedStorage%.Data%.Assets%.Configs%.(.+)$")
if pet and type(value) == "table" then
built[pet] = value
n = n + 1
end
end
return n > 0 and built or nil, n
end
local mutationCache, saidMutations = nil, false
function M.mutationFactor(name)
if not name then return nil end
if not mutationCache then
mutationCache = {}
for full, value in pairs(warmValues) do
local id = full:match("%.Mutations%.Configs%.(.+)$") or full:match("%.Mutations%.(.+)$")
if id and type(value) == "table" then mutationCache[id] = value end
end
if not saidMutations then
saidMutations = true
local n, sampleKey = 0, nil
for key in pairs(mutationCache) do n = n + 1 sampleKey = sampleKey or key end
if sampleKey then
local fields = {}
for key, value in pairs(mutationCache[sampleKey]) do
fields[#fields + 1] = ("%s=%s"):format(tostring(key), tostring(value):sub(1, 16))
end
table.sort(fields)
log.info("mutation configs: %d loaded, %q = { %s }", n, sampleKey,
table.concat(fields, ", "))
else
log.info("no mutation configs loaded - mutated eggs price at base rate")
end
end
end
local entry = mutationCache[tostring(name)]
if type(entry) ~= "table" then return nil end
return tonumber(entry.EarningMultiplier or entry.Multiplier or entry.EarningRateMultiplier
or entry.RateMultiplier or entry.Bonus)
end
local function mineWarmed()
local assembled, count = directoryFromConfigs()
if assembled then
local score = directoryScore(assembled)
if score > 0 or knownCount() == 0 then
if not saidMined then
saidMined = true
log.info("pet directory assembled from %d Data.Assets.Configs modules (%d of %d live categories)",
count, score, knownCount())
local sampleKey
for category in pairs(knownCategories) do
if type(rawget(assembled, category)) == "table" then sampleKey = category break end
end
if not sampleKey then
for category in pairs(assembled) do sampleKey = category break end
end
local entry = sampleKey and rawget(assembled, sampleKey)
if type(entry) == "table" then
local fields = {}
for key, value in pairs(entry) do
local shown = tostring(value):sub(1, 20)
if type(value) == "table" then
local inner = {}
for k2, v2 in pairs(value) do
inner[#inner + 1] = ("%s=%s"):format(tostring(k2), tostring(v2):sub(1, 14))
if #inner >= 6 then break end
end
table.sort(inner)
shown = "{" .. table.concat(inner, ",") .. "}"
end
fields[#fields + 1] = ("%s:%s=%s"):format(tostring(key), typeof(value), shown)
end
table.sort(fields)
log.info("entry %q = { %s }", tostring(sampleKey), table.concat(fields, ", "))
end
end
local earned
for _, value in pairs(warmValues) do
if type(rawget(value, "LiveRatePerSecond")) == "function" then earned = value break end
end
slotShaped = slotShaped or findSlotIdentity()
return assembled, earned, "configs"
end
end
local directory, earnings, best, bestName = nil, nil, 0, nil
for name, value in pairs(warmValues) do
if not earnings and type(rawget(value, "LiveRatePerSecond")) == "function" then
earnings = value
log.info("pricing function found in %s", name)
end
for _, candidate in ipairs({ value, rawget(value, "Directory") }) do
local score = directoryScore(candidate)
if score > best then best, bestName, directory = score, name, candidate end
end
end
if directory and not saidMined then
saidMined = true
log.info("pet directory: %s matches %d of %d live categories", bestName, best, knownCount())
for category in pairs(knownCategories) do
local entry = rawget(directory, category)
if type(entry) == "table" then
local fields = {}
for key, value in pairs(entry) do
fields[#fields + 1] = ("%s:%s=%s"):format(tostring(key), typeof(value),
tostring(value):sub(1, 20))
end
table.sort(fields)
log.info("entry %q = { %s }", category, table.concat(fields, ", "))
break
end
end
elseif not directory and knownCount() > 0 and not saidMined then
saidMined = true
local names = {}
for name in pairs(warmValues) do names[#names + 1] = name:gsub("^ReplicatedStorage%.", "") end
table.sort(names)
log.warn("no loaded module keys any of the %d live categories", knownCount())
for i = 1, math.min(#names, 80), 20 do
log.info("loaded modules %d-%d: %s", i, math.min(i + 19, #names),
table.concat(table.move(names, i, math.min(i + 19, #names), 1, {}), ", "))
end
end
return directory, earnings, "shape"
end
local function resolve(key, path)
local held = cache[key]
if held and held.mod then return held.mod end
if held and held.missing and (os.clock() - (held.at or 0)) < RETRY_AFTER then
return nil
end
cache[key] = nil
local inst = atPath(table.unpack(path))
if not (inst and inst:IsA("ModuleScript")) then
local name = path[#path]
local found = searchModule(name)
if found then
log.warn("%s was not a module at %s - using %s",
name, table.concat(path, "."), found:GetFullName())
inst = found
end
end
if not inst then
cache[key] = { missing = true, at = os.clock() }
return nil
end
local mod
local ok = BX.try("data.require." .. key, function() mod = exec.requireGame(inst) end)
if not ok or type(mod) ~= "table" then
if HEAP_SHAPES[key] then
harvestHeap()
if heapFound[key] then
log.info("%s recovered from the heap", key)
cache[key] = { mod = heapFound[key] }
return heapFound[key]
end
end
if warmModuleGraph() > 0 then
local retried
if pcall(function() retried = exec.requireGame(inst) end) and type(retried) == "table" then
log.info("%s loaded after warming the module graph", key)
cache[key] = { mod = retried }
return retried
end
local directory, earnings, source = mineWarmed()
local trusted = (source == "configs") or (directory and knownCount() > 0)
if key == "assets" and directory and trusted then
local stand = { Directory = directory }
cache[key] = { mod = stand }
return stand
end
if key == "assetEarnings" and earnings then
cache[key] = { mod = earnings }
return earnings
end
if key == "slotIdentity" and slotShaped then
cache[key] = { mod = slotShaped }
return slotShaped
end
end
if key == "assets" then
local pieced = assembleAssets(inst)
if pieced then
cache[key] = { mod = pieced }
return pieced
end
end
cache[key] = { missing = true, at = os.clock() }
return nil
end
cache[key] = { mod = mod }
return mod
end
function M.assets()        return resolve("assets", { "Data", "Assets" }) end
function M.areas()         return resolve("areas", { "Data", "Areas" }) end
function M.eggState()      return resolve("eggState", { "Client", "EggState" }) end
function M.assetEarnings() return resolve("assetEarnings", { "Shared", "Util", "AssetEarnings" }) end
function M.plotState()     return resolve("plotState", { "Client", "PlotState" }) end
function M.slotIdentity()  return resolve("slotIdentity", { "Shared", "Util", "AreaEggSlotIdentity" }) end
function M.resetWall()     return resolve("resetWall", { "Client", "AreaEggResetWall" }) end
function M.bases()         return resolve("bases", { "Data", "Bases" }) end
function M.save()          return resolve("save", { "Shared", "Save" }) end
function M.eggCycle()      return resolve("eggCycle", { "Shared", "Util", "AreaEggCycle" }) end
function M.fusionFlags()   return resolve("fusionFlags", { "Shared", "Flags", "ShrineFusionFlags" }) end
local LIMIT_FALLBACK = 115
function M.eggInventory()
local count, limit
BX.try("data.eggInventoryCount", function()
local save = M.save()
local s = save and save.Get and save.Get(svc.Players.LocalPlayer)
if type(s) == "table" and type(s.EggInventory) == "table" then
count = 0
for _ in pairs(s.EggInventory) do count = count + 1 end
end
end)
BX.try("data.eggInventoryLimit", function()
local flags = M.fusionFlags()
local f = flags and flags.EggInventoryLimit
limit = f and type(f.Get) == "function" and tonumber(f:Get()) or nil
end)
limit = limit or LIMIT_FALLBACK
if not count then return nil, nil, limit end
return count >= limit, count, limit
end
function M.secondsUntilReset()
local cyc = M.eggCycle()
if not (cyc and type(cyc.SecondsUntilReset) == "function") then return nil end
local ok, s = pcall(cyc.SecondsUntilReset, workspace:GetServerTimeNow())
return ok and tonumber(s) or nil
end
local WALL_MARGIN = 1.5
M.WALL_MARGIN = WALL_MARGIN
local function wallOpensAfter()
local d = resolve("resetCycleData", { "Data", "AreaEggResetCycle" }) or {}
return (tonumber(d.WallCountdownDelayAfterDayStartsSeconds) or 2)
+ (tonumber(d.WallCountdownSeconds) or 3)
end
function M.secondsSinceReset()
local cyc = M.eggCycle()
local left = M.secondsUntilReset()
if not left then return nil end
local period = cyc and tonumber(cyc.ResetPeriodSeconds) or 300
return period - left
end
function M.secondsUntilFieldOpens()
local since = M.secondsSinceReset()
if not since then return nil end
local left = wallOpensAfter() + WALL_MARGIN - since
return left > 0 and left or nil
end
local function wallCollision()
local o = workspace:FindFirstChild("__OBJECTS")
o = o and o:FindFirstChild("Areas")
return o and o:FindFirstChild("WallStartCollision") or nil
end
function M.fieldSealed()
local flag = nil
local wall = M.resetWall()
if wall and type(wall.IsSealed) == "function" then
local ok, sealed = pcall(wall.IsSealed)
if ok then flag = (sealed == true) end
end
local part = wallCollision()
if flag ~= nil then return flag end
if part and part:IsA("BasePart") then return part.CanCollide end
local schedule = nil
BX.try("data.fieldSealed.schedule", function()
local cyc = M.eggCycle()
if not (cyc and type(cyc.IsNightPhase) == "function") then return end
local now = workspace:GetServerTimeNow()
if cyc.IsNightPhase(now) then schedule = true return end
local since = M.secondsSinceReset()
if since then schedule = since < (wallOpensAfter() + WALL_MARGIN) end
end)
if schedule then return true end
if flag == nil and schedule == nil then return nil end
return false
end
function M.onWallChanged(sc, fn)
local n = 0
BX.try("data.wallSignal", function()
local wall = M.resetWall()
local sig = wall and wall.Changed
if type(sig) == "table" and type(sig.Connect) == "function" then
sc:connect(sig, function(sealed) fn(sealed == true, "signal") end)
n = n + 1
end
end)
BX.try("data.wallPart", function()
local part = wallCollision()
if part and part:IsA("BasePart") then
sc:connect(part:GetPropertyChangedSignal("CanCollide"), function()
fn(part.CanCollide, "collision")
end)
n = n + 1
end
end)
return n
end
local profileAt, profileCache, saidProfile = 0, nil, false
local PROFILE_TTL = 5
function M.profile()
local mod = M.save()
if mod and type(mod.Get) == "function" then
local ok, prof = pcall(mod.Get, svc.Players.LocalPlayer)
if ok and type(prof) == "table" then return prof end
end
local now = os.clock()
if profileCache and (now - profileAt) < PROFILE_TTL then return profileCache end
local got = BX.require("core.net").call("RF/ProfileMirror/FetchProfile")
if type(got) ~= "table" then
if not saidProfile then
saidProfile = true
log.warn("no profile: Save is unrequirable and RF/ProfileMirror/FetchProfile gave %s",
typeof(got))
end
return nil
end
if not saidProfile then
saidProfile = true
local keys = {}
for key in pairs(got) do keys[#keys + 1] = tostring(key) end
table.sort(keys)
log.info("profile via RF/ProfileMirror/FetchProfile: %s", table.concat(keys, ", "))
end
profileCache, profileAt = got, now
return got
end
function M.assetsDir()
local a = M.assets()
return a and a.Directory or nil
end
function M.areasDir()
local a = M.areas()
return a and a.Directory or nil
end
function M.report()
local out = {}
for key, held in pairs(cache) do
out[#out + 1] = key .. (held.missing and "=MISSING" or "=ok")
end
table.sort(out)
return out
end
return M
end)
BX.module("core.profiles", function(BX)
local svc  = BX.require("core.services")
local exec = BX.require("core.exec")
local log  = BX.require("boot.log").for_module("profiles")
local M = {}
local FORMAT = 2
local GAME_SUFFIX = ""
if BX.game and BX.game ~= "Steal An Egg" then
GAME_SUFFIX = "_" .. tostring(BX.game):gsub("%W+", "")
end
local DIR = "VoidcxzHub/profiles" .. GAME_SUFFIX
local SETTINGS = "VoidcxzHub/settings" .. GAME_SUFFIX .. ".json"
M.FORMAT = FORMAT
local SKIP_KEYS = { "url", "token", "secret", "key", "password" }
local ORDER = {
"Theme", "Background",
"FarmAreas", "FarmRarities", "FarmMutations",
"FarmMinWeight", "FarmMinIncome",
"FarmTargetBy", "FarmPriority",
"WebhookOn", "AntiTreadmill", "AntiTrap", "BatAura",
"UseTreadmillWhileWaiting", "TreadmillLock",
"FarmAutoSteal", "AutoSteal",
}
local ALLOW = {}
for _, k in ipairs(ORDER) do ALLOW[k] = true end
M.ALLOW = ALLOW
local KIND = {
Theme = "string", Background = "string",
FarmAreas = "table", FarmRarities = "table", FarmMutations = "table",
FarmMinWeight = "string", FarmMinIncome = "string",
FarmTargetBy = "string", FarmPriority = "string",
WebhookOn = "boolean", AntiTreadmill = "boolean", AntiTrap = "boolean",
BatAura = "boolean",
UseTreadmillWhileWaiting = "boolean", TreadmillLock = "boolean",
FarmAutoSteal = "boolean", AutoSteal = "boolean",
}
function M.allow(key, kind)
key = tostring(key)
if not ALLOW[key] then
ORDER[#ORDER + 1] = key
ALLOW[key] = true
end
KIND[key] = kind
end
local function skipped(name)
if not ALLOW[name] then return true end
local n = tostring(name):lower()
for _, bad in ipairs(SKIP_KEYS) do
if n:find(bad, 1, true) then return true end
end
return false
end
local function validValue(key, value)
local want = KIND[key]
if not want then return false end
if want == "table" then return type(value) == "table" end
return type(value) == want
end
function M.available()
return exec.can.files and exec.can.folders and true or false
end
local listing, listingOk = {}, false
local function safeName(name)
name = tostring(name or ""):gsub("[^%w%-_ ]", ""):gsub("^%s+", ""):gsub("%s+$", "")
return name
end
local function pathFor(name)
return DIR .. "/" .. name .. ".json"
end
function M.refresh()
listing, listingOk = {}, false
if not M.available() then return listing end
BX.try("profiles.refresh", function()
exec.ensureFolder("VoidcxzHub")
exec.ensureFolder(DIR)
local files = exec.listFiles(DIR)
if not files then
log.warn("this executor has no listfiles - saved profiles cannot be listed")
return
end
for _, f in ipairs(files) do
local name = tostring(f):match("([^/\\]+)%.json$")
if name then listing[#listing + 1] = name end
end
table.sort(listing)
listingOk = true
end)
return listing
end
function M.list()
if not listingOk then M.refresh() end
return listing
end
local flagSource = nil
function M.setFlagSource(fn) flagSource = fn end
local appearanceSource, appearanceApply = nil, nil
function M.setAppearanceHooks(read, apply)
appearanceSource, appearanceApply = read, apply
end
local windowSource, windowApply = nil, nil
function M.setWindowGeometryHooks(read, apply)
windowSource, windowApply = read, apply
end
local appliers = {}
function M.onApply(flag, fn) appliers[tostring(flag)] = fn end
local function elementValue(el)
if type(el) ~= "table" then return el end
local v = el.CurrentValue
if v == nil then v = el.Value end
if v == nil then v = el.value end
return v
end
local function collectFlags()
local out = {}
if type(flagSource) ~= "function" then return out end
local ok, flags = pcall(flagSource)
if not ok or type(flags) ~= "table" then return out end
for name, el in pairs(flags) do
if not skipped(name) then
local v = elementValue(el)
local t = type(v)
if t == "boolean" or t == "number" or t == "string" then
out[tostring(name)] = v
elseif t == "table" then
local copy = {}
for i, item in ipairs(v) do
if type(item) == "string" or type(item) == "number" then
copy[i] = item
end
end
out[tostring(name)] = copy
end
end
end
return out
end
function M.save(name)
if not M.available() then return false, "This executor cannot save files" end
name = safeName(name)
if name == "" then return false, "Give the profile a name" end
local payload = {
version = FORMAT,
saved = os.date("!%Y-%m-%dT%H:%M:%SZ"),
build = tostring(BX.build),
flags = collectFlags(),
appearance = (type(appearanceSource) == "function")
and select(2, pcall(appearanceSource)) or nil,
window = (type(windowSource) == "function")
and select(2, pcall(windowSource)) or nil,
}
local body
local okEnc = pcall(function() body = svc.HttpService:JSONEncode(payload) end)
if not okEnc or not body then return false, "Could not encode the profile" end
local path = pathFor(name)
local ok = BX.try("profiles.save", function()
exec.ensureFolder("VoidcxzHub")
exec.ensureFolder(DIR)
if not exec.writeFile(path, body) then error("writefile refused", 0) end
end)
if not ok then return false, "Could not write the profile" end
if not exec.isFile(path) then
log.warn("profile %q: writefile returned but isfile says no", name)
return false, "Written but not found - this executor's file access is broken"
end
local back = exec.readFile(path)
if back ~= body then
log.warn("profile %q: readback mismatch (%d vs %d bytes)", name,
type(back) == "string" and #back or -1, #body)
return false, "Written but readback differs - not saved"
end
M.refresh()
local n = 0
for _ in pairs(payload.flags) do n = n + 1 end
log.info("saved profile %q (%d flags)", name, n)
return true, "Saved " .. name
end
local loading = false
function M.load(name)
if not M.available() then return false, "This executor cannot read files" end
if loading then return false, "A profile is still loading" end
name = safeName(name)
if name == "" then return false, "Pick a profile" end
local path = pathFor(name)
if not exec.isFile(path) then return false, "No profile called " .. name end
local body = exec.readFile(path)
if type(body) ~= "string" or body == "" then
return false, name .. " is empty"
end
local data
local okDec = pcall(function() data = svc.HttpService:JSONDecode(body) end)
if not okDec or type(data) ~= "table" then
log.warn("profile %q is not valid JSON - refusing it", name)
return false, name .. " is corrupt"
end
local v = tonumber(data.version) or 0
if v > FORMAT then
return false, name .. " was saved by a newer version"
end
loading = true
local applied, ignored = 0, {}
local flagsIn = type(data.flags) == "table" and data.flags or {}
local elements = {}
if type(flagSource) == "function" then
local ok, flags = pcall(flagSource)
if ok and type(flags) == "table" then elements = flags end
end
for _, key in ipairs(ORDER) do
local value = flagsIn[key]
if value ~= nil then
if skipped(key) or not validValue(key, value) then
ignored[#ignored + 1] = key
else
local el = elements[key]
if type(el) == "table" and type(el.Set) == "function" then
BX.try("profiles.set." .. key, function() el:Set(value) end)
end
local fn = appliers[key]
if fn then
if BX.try("profiles.apply." .. key, fn, value) then applied = applied + 1 end
elseif el then
applied = applied + 1
end
end
end
end
for key in pairs(flagsIn) do
if not ALLOW[key] then ignored[#ignored + 1] = key end
end
if type(data.appearance) == "table" and type(appearanceApply) == "function" then
BX.try("profiles.appearance", function() appearanceApply(data.appearance) end)
end
if type(data.window) == "table" and type(windowApply) == "function" then
BX.try("profiles.window", function() windowApply(data.window) end)
end
loading = false
if #ignored > 0 then
log.info("profile %q: ignored %s", name, table.concat(ignored, ", "))
end
log.info("loaded profile %q (%d settings applied)", name, applied)
return true, ("Loaded %s (%d settings)"):format(name, applied)
end
function M.delete(name)
if not M.available() then return false, "This executor cannot delete files" end
name = safeName(name)
local path = pathFor(name)
if name == "" or not exec.isFile(path) then return false, "No such profile" end
local ok = BX.try("profiles.delete", function() exec.deleteFile(path) end)
M.refresh()
if not ok then return false, "Could not delete " .. name end
log.info("deleted profile %q", name)
return true, "Deleted " .. name
end
local function readSettings()
if not M.available() or not exec.isFile(SETTINGS) then return {} end
local body = exec.readFile(SETTINGS)
local data
pcall(function() data = svc.HttpService:JSONDecode(body) end)
return type(data) == "table" and data or {}
end
function M.autoLoadName()
local s = readSettings()
local n = s.autoLoad
return type(n) == "string" and n ~= "" and n or nil
end
function M.setAutoLoad(name)
if not M.available() then return false, "This executor cannot save files" end
name = safeName(name)
local s = readSettings()
s.autoLoad = (name ~= "" and name) or nil
s.version = FORMAT
local body
if not pcall(function() body = svc.HttpService:JSONEncode(s) end) then
return false, "Could not save the setting"
end
local wrote = BX.try("profiles.settings", function()
exec.ensureFolder("VoidcxzHub")
if not exec.writeFile(SETTINGS, body) then error("writefile refused", 0) end
end)
if not wrote then return false, "Could not write the auto-load setting" end
local verify = readSettings()
if verify.autoLoad ~= s.autoLoad then
return false, "Auto-load setting was not saved"
end
log.info("auto-load profile is now %s", name ~= "" and ("%q"):format(name) or "off")
return true, name ~= "" and ("Auto-loading " .. name) or "Auto-load off"
end
function M.rememberWindowGeometry()
if not M.available() or type(windowSource) ~= "function" then return false end
local ok, geometry = pcall(windowSource)
if not ok or type(geometry) ~= "table" then return false end
local s = readSettings()
s.window = geometry
s.version = FORMAT
local body
if not pcall(function() body = svc.HttpService:JSONEncode(s) end) then return false end
return BX.try("profiles.windowSettings", function()
exec.ensureFolder("VoidcxzHub")
if not exec.writeFile(SETTINGS, body) then error("writefile refused", 0) end
end) and true or false
end
local autoLoadRan = false
local LAST = "Last session"
local lastSaveAt, lastDirty = 0, false
local SAVE_EVERY = 5
function M.touch()
lastDirty = true
end
function M.startAutoSave()
local sc = BX.scope("core.profiles.autosave")
sc:loop("autosave", SAVE_EVERY, function()
if not lastDirty or not M.available() then return end
if M.autoLoadName() and M.autoLoadName() ~= LAST then
lastDirty = false
return
end
lastDirty = false
lastSaveAt = os.clock()
local ok, why = M.save(LAST)
if not ok then log.warn("could not keep the session profile: %s", tostring(why)) end
end)
end
function M.runAutoLoad()
if autoLoadRan then return false, "already ran" end
autoLoadRan = true
local settings = readSettings()
if type(settings.window) == "table" and type(windowApply) == "function" then
BX.try("profiles.windowSettings", function() windowApply(settings.window) end)
end
local name = M.autoLoadName()
if not name then
local found = false
for _, row in ipairs(M.list() or {}) do
local rowName = type(row) == "table" and (row.name or row[1]) or row
if tostring(rowName) == LAST then found = true break end
end
if not found and exec.isFile(pathFor(LAST)) then found = true end
if not found then return false, "no auto-load profile set" end
name = LAST
log.info("no auto-load profile set - restoring %q", LAST)
end
local ok, msg = M.load(name)
if not ok then log.warn("auto-load failed: %s", tostring(msg)) end
return ok, msg
end
return M
end)
BX.module("core.exec", function(BX)
local log = BX.require("boot.log").for_module("exec")
local M = {}
local env = (type(getgenv) == "function" and getgenv()) or _G
local deny = type(env.VOIDCXZ_CAPS_DENY) == "table" and env.VOIDCXZ_CAPS_DENY or {}
M.simulatedDenies = deny
local function fn(name)
if deny[name] then return nil end
local ok, v
ok, v = pcall(function() return type(getgenv) == "function" and getgenv()[name] or nil end)
if not ok or type(v) ~= "function" then
ok, v = pcall(function() return getfenv and getfenv()[name] or nil end)
end
if not ok or type(v) ~= "function" then
ok, v = pcall(function() return (_G and _G[name]) end)
end
if not ok or type(v) ~= "function" then
ok, v = pcall(function()
local chunk = loadstring and loadstring("return " .. name)
return chunk and chunk() or nil
end)
end
return (ok and type(v) == "function") and v or nil
end
local function first(...)
for _, name in ipairs({ ... }) do
local f = fn(name)
if f then return f, name end
end
return nil, nil
end
local f_writefile   = first("writefile")
local f_readfile    = first("readfile")
local f_isfile      = first("isfile")
local f_delfile     = first("delfile")
local f_isfolder    = first("isfolder")
local f_makefolder  = first("makefolder")
local f_listfiles   = first("listfiles")
local f_customasset = first("getcustomasset", "getsynasset")
local f_gethui      = first("gethui")
local f_getgc       = first("getgc")
local f_getconns    = first("getconnections")
local f_hookfn      = first("hookfunction", "replaceclosure")
local f_getrawmeta  = first("getrawmetatable")
local f_setreadonly = first("setreadonly", "make_writeable")
local f_queueport   = first("queue_on_teleport", "queueonteleport")
local f_identify    = first("identifyexecutor", "getexecutorname")
local f_fireprompt  = first("fireproximityprompt")
local f_setident    = first("setthreadidentity", "set_thread_identity",
"setidentity", "setthreadcontext")
local f_getident    = first("getthreadidentity", "get_thread_identity",
"getidentity", "getthreadcontext")
local f_clip, clipName = first("setclipboard", "toclipboard", "set_clipboard", "setrbxclipboard")
local canRequire, requireWhy = true, "unprobed"
do
local ok, err = pcall(function()
local RS = game:GetService("ReplicatedStorage")
local data = RS:FindFirstChild("Data")
local probe = data and data:FindFirstChild("Areas")
if not (probe and probe:IsA("ModuleScript")) then return end
canRequire, requireWhy = true, probe:GetFullName()
end)
if not ok then canRequire, requireWhy = false, tostring(err) end
if deny.gameRequire then canRequire, requireWhy = false, "simulated deny" end
end
local f_request, requestName
do
local ok, v = pcall(function() return syn and syn.request end)
if ok and type(v) == "function" then
f_request, requestName = v, "syn.request"
else
ok, v = pcall(function() return http and http.request end)
if ok and type(v) == "function" then
f_request, requestName = v, "http.request"
else
f_request, requestName = first("request", "http_request", "httprequest")
end
end
end
M.can = {
files      = (f_writefile and f_readfile and f_isfile) and true or false,
folders    = (f_isfolder and f_makefolder) and true or false,
listFiles  = f_listfiles and true or false,
customAsset = f_customasset and true or false,
identity   = (f_setident and f_getident) and true or false,
hiddenUi   = f_gethui and true or false,
gc         = f_getgc and true or false,
connections = f_getconns and true or false,
hooking    = (f_hookfn and f_getrawmeta) and true or false,
clipboard  = f_clip and true or false,
request    = f_request and true or false,
teleportQueue = f_queueport and true or false,
prompts    = true,
gameRequire = canRequire,
}
M.promptVia = f_fireprompt and "fireproximityprompt" or "InputHoldBegin"
M.gameRequireWhy = requireWhy
M.name = "unknown"
if f_identify then
local ok, n = pcall(f_identify)
if ok and type(n) == "string" and #n > 0 then M.name = n end
end
local FRAGILE = { "solara" }
M.fragile = false
do
local lower = M.name:lower()
for _, bad in ipairs(FRAGILE) do
if lower:find(bad, 1, true) then M.fragile = true break end
end
end
if M.fragile then
M.can.hooking, M.can.gc = false, false
f_getgc = nil
if BX.profile then BX.profile.enabled = false end
log.warn("fragile executor (%s): hooks, gc, per-frame profiling, renderer settings and custom assets are off", M.name)
end
function M.hiddenParent()
local ok, playerGui = pcall(function()
local player = game:GetService("Players").LocalPlayer
return player and (player:FindFirstChildOfClass("PlayerGui")
or player:WaitForChild("PlayerGui", 10))
end)
if ok and playerGui then return playerGui end
if f_gethui then
local ok, ui = pcall(f_gethui)
if ok and ui then return ui end
end
return nil
end
function M.writeFile(path, data)
if not f_writefile then return false end
return (BX.try("exec.writeFile", f_writefile, path, data))
end
function M.readFile(path)
if not f_readfile then return nil end
local ok, data = BX.try("exec.readFile", f_readfile, path)
return ok and data or nil
end
function M.isFile(path)
if not f_isfile then return false end
local ok, yes = pcall(f_isfile, path)
return ok and yes or false
end
function M.listFiles(path)
if not f_listfiles then return nil end
local ok, files = BX.try("exec.listFiles", f_listfiles, path)
if not ok or type(files) ~= "table" then return nil end
return files
end
function M.deleteFile(path)
if not f_delfile then return false end
return (BX.try("exec.deleteFile", f_delfile, path))
end
function M.ensureFolder(path)
if not M.can.folders then return false end
local built = ""
for part in tostring(path):gmatch("[^/]+") do
built = (built == "") and part or (built .. "/" .. part)
local ok, exists = pcall(f_isfolder, built)
if ok and not exists then
if not BX.try("exec.makeFolder", f_makefolder, built) then return false end
end
end
return true
end
function M.requireGame(inst)
if not (f_setident and f_getident) then return require(inst) end
local okPrev, prev = pcall(f_getident)
if not okPrev or type(prev) ~= "number" then return require(inst) end
local result
local ok, err = pcall(function()
f_setident(2)
result = require(inst)
end)
pcall(f_setident, prev)
if not ok then error(err, 0) end
return result
end
function M.customAsset(path)
if not f_customasset then return nil end
local ok, id = BX.try("exec.customAsset", f_customasset, path)
return ok and id or nil
end
function M.clipboard(text)
for _, name in ipairs({ "setclipboard", "toclipboard", "set_clipboard", "setrbxclipboard" }) do
local f = fn(name)
if f and pcall(f, text) then return true end
end
return false
end
function M.requestFunction() return f_request, requestName end
function M.httpRequest(opts)
if not f_request then return nil end
local ok, res = BX.try("exec.httpRequest", f_request, opts)
return ok and res or nil
end
function M.gcScan(tablesOnly)
if not f_getgc then return {} end
local t0 = os.clock()
local ok, objs = BX.try("exec.gcScan", f_getgc, tablesOnly and true or false)
if not ok or type(objs) ~= "table" then return {} end
local ms = (os.clock() - t0) * 1000
M.lastGcMs = ms
log.warn("gc sweep: %d objects in %.0fms", #objs, ms)
return objs
end
function M.firePrompt(prompt, holdDuration)
if f_fireprompt then
return (BX.try("exec.firePrompt", f_fireprompt, prompt, holdDuration or 0))
end
return (BX.try("exec.firePrompt.hold", function()
prompt:InputHoldBegin()
local hold = tonumber(holdDuration)
if hold == nil then hold = tonumber(prompt.HoldDuration) or 0 end
if hold > 0 then task.wait(hold + 0.05) end
prompt:InputHoldEnd()
end))
end
function M.report()
local have, missing = {}, {}
for k, v in pairs(M.can) do
table.insert(v and have or missing, k)
end
table.sort(have); table.sort(missing)
local denied = {}
for k in pairs(deny) do denied[#denied + 1] = tostring(k) end
table.sort(denied)
return {
executor = M.name,
have = have,
missing = missing,
denied = denied,
promptVia = M.promptVia,
gameRequireWhy = requireWhy,
}
end
local r = M.report()
log.info("executor=%s clipboard=%s request=%s prompts=%s gameRequire=%s (%s)",
M.name, tostring(clipName), tostring(requestName), M.promptVia,
tostring(canRequire), tostring(requireWhy))
if #r.denied > 0 then
log.warn("SIMULATED capability denies active: %s", table.concat(r.denied, ", "))
end
log.info("supported: %s", #r.have > 0 and table.concat(r.have, ", ") or "(none)")
if #r.missing > 0 then
log.warn("unsupported here: %s", table.concat(r.missing, ", "))
end
return M
end)
BX.module("core.device", function(BX)
local svc = BX.require("core.services")
local cfg = BX.require("core.config")
local log = BX.require("boot.log").for_module("device")
local M = {}
M.isTouch = svc.UserInputService.TouchEnabled
and not svc.UserInputService.KeyboardEnabled
local function shortSide()
local cam = workspace.CurrentCamera
local vp = cam and cam.ViewportSize
if not vp or vp.Y < 10 then return 1080 end
return math.min(vp.X, vp.Y)
end
M.smallScreen = shortSide() < 500
M.tier = (M.isTouch and M.smallScreen) and "low" or "mid"
M.fps = nil
local MULT = { low = 2.2, mid = 1.35, high = 1.0 }
function M.scale(seconds)
return seconds * (MULT[M.tier] or 1.35)
end
function M.budget(n)
local share = (M.tier == "low" and 0.35) or (M.tier == "mid" and 0.7) or 1
return math.max(1, math.floor(n * share + 0.5))
end
function M.lite()
return M.tier == "low"
end
local listeners = {}
function M.onTier(sc, label, fn)
listeners[#listeners + 1] = { scope = sc, label = label, fn = fn }
end
local function setTier(t)
if M.tier == t then return end
local was = M.tier
M.tier = t
log.info("tier %s -> %s (fps %.0f, touch=%s, short=%d)",
was, t, M.fps or -1, tostring(M.isTouch), shortSide())
for i = #listeners, 1, -1 do
local L = listeners[i]
if not L.scope or L.scope.dead then
table.remove(listeners, i)
else
BX.try("device/" .. L.label, L.fn, t, was)
end
end
end
local sc = BX.scope("core.device")
local lastFrame, lastAt = BX.profile.frameNo, os.clock()
local pending, pendingCount = nil, 0
sc:loop("measure", 5, function()
local now = os.clock()
local fps = (BX.profile.frameNo - lastFrame) / math.max(now - lastAt, 0.001)
lastFrame, lastAt = BX.profile.frameNo, now
M.fps = M.fps and (M.fps + (fps - M.fps) * 0.4) or fps
local want = M.tier
if M.tier == "high" then
if M.fps < 45 then want = "mid" end
elseif M.tier == "mid" then
if M.fps < cfg.LITE_FPS then want = "low"
elseif M.fps > 75 then want = "high" end
else
if M.fps > 40 then want = "mid" end
end
if want == "high" and M.isTouch and M.smallScreen then want = "mid" end
if want == M.tier then
pending, pendingCount = nil, 0
return
end
if pending == want then
pendingCount = pendingCount + 1
else
pending, pendingCount = want, 1
end
if pendingCount >= 2 then
setTier(want)
pending, pendingCount = nil, 0
end
end)
log.info("start tier=%s touch=%s smallScreen=%s", M.tier,
tostring(M.isTouch), tostring(M.smallScreen))
return M
end)
BX.module("core.character", function(BX)
local svc = BX.require("core.services")
local log = BX.require("boot.log").for_module("character")
local M = {}
local plr = svc.LocalPlayer
local current = setmetatable({}, { __mode = "v" })
local listeners = {}   
function M.get()
local c = current.char
if c and c.Parent then return c end
return plr and plr.Character
end
function M.root()
local c = M.get()
return c and c:FindFirstChild("HumanoidRootPart")
end
function M.humanoid()
local c = M.get()
return c and c:FindFirstChildOfClass("Humanoid")
end
local function fire(char)
current.char = char
for i = #listeners, 1, -1 do
local L = listeners[i]
if not L.scope or L.scope.dead then
table.remove(listeners, i)
else
BX.try(("character/%s"):format(L.label), L.fn, char)
end
end
end
function M.onSpawn(sc, label, fn)
listeners[#listeners + 1] = { scope = sc, label = label, fn = fn }
local c = M.get()
if c then BX.try(("character/%s"):format(label), fn, c) end
end
local sc = BX.scope("core.character")
if plr then
sc:connect(plr.CharacterAdded, function(char)
log.trace("respawn")
task.spawn(function()
BX.try("character/wait", function()
char:WaitForChild("HumanoidRootPart", 10)
end)
if BX.alive() then fire(char) end
end)
end)
sc:connect(plr.CharacterRemoving, function()
current.char = nil
end)
current.char = plr.Character
else
log.error("no LocalPlayer - character tracking unavailable")
end
M._listenerCount = function() return #listeners end
return M
end)
BX.module("core.restore", function(BX)
local ch  = BX.require("core.character")
local log = BX.require("boot.log").for_module("restore")
local M = {}
local entries = {}     
local order = {}       
BX.profile.watch("restore.pending", function() return #order end)
function M.remember(key, read, write)
if entries[key] then return false end
local ok, value = pcall(read)
if not ok then
log.warn("could not read %s to remember it: %s", key, tostring(value))
return false
end
entries[key] = {
read = read, write = write, original = value,
char = ch.get(), at = os.clock(),
}
order[#order + 1] = key
return true
end
function M.onRestore(key, undo)
if entries[key] then return false end
entries[key] = { undo = undo, char = ch.get(), at = os.clock() }
order[#order + 1] = key
return true
end
function M.permanent(key, why)
if entries[key] then return false end
entries[key] = { permanent = why or "not reversible", char = ch.get() }
order[#order + 1] = key
return true
end
function M.restoreAll()
local restored, skipped, failed = 0, 0, 0
local liveChar = ch.get()
for i = #order, 1, -1 do
local key = order[i]
local e = entries[key]
if e then
if e.permanent then
skipped = skipped + 1
elseif e.char and e.char ~= liveChar then
skipped = skipped + 1
else
local ok, err = pcall(function()
if e.undo then e.undo() else e.write(e.original) end
end)
if ok then
restored = restored + 1
else
failed = failed + 1
log.error("restoring %s failed: %s", key, tostring(err))
end
end
entries[key] = nil
end
table.remove(order, i)
end
return restored, skipped, failed
end
function M.audit()
local diffs = {}
for _, key in ipairs(order) do
local e = entries[key]
if e and e.read then
local ok, now = pcall(e.read)
if ok and tostring(now) ~= tostring(e.original) then
diffs[#diffs + 1] = ("%s: %s (was %s)")
:format(key, tostring(now), tostring(e.original))
end
elseif e and e.permanent then
diffs[#diffs + 1] = ("%s: %s"):format(key, e.permanent)
end
end
return diffs
end
function M.pending()
return #order
end
local sc = BX.scope("core.restore")
ch.onSpawn(sc, "restore.respawn", function(char)
local dropped = 0
for i = #order, 1, -1 do
local key = order[i]
local e = entries[key]
if e and e.char and e.char ~= char then
entries[key] = nil
table.remove(order, i)
dropped = dropped + 1
end
end
if dropped > 0 then
log.trace("dropped %d entries captured against the old character", dropped)
end
end)
return M
end)
BX.module("core.config", function(BX)
return {
CARRY_SPEED        = 500,
OUTBOUND_SPEED_MIN = 500,
OUTBOUND_SPEED_MAX = 1200,
LITE_FPS           = 25,
STATS_HZ           = 4,
LOG_LEVEL          = 2,
FPS_MESH_LOD       = false,
AUTO_FPS_BOOST     = true,
SHOW_STATS         = true,
DEFAULT_ANTI_TREADMILL = false,
}
end)
BX.module("core.state", function(BX)
return {
heldEggUid      = nil,     
autoStealOn     = false,   
autoStealBusy   = false,   
autoStealState  = "DISABLED",
stayOnTreadmill = false,
lastFps         = 0,       
startedAt       = os.clock(),
}
end)
BX.module("core.motion", function(BX)
local svc = BX.require("core.services")
local log = BX.require("boot.log").for_module("motion")
local M = {}
local PRIORITY = { autosteal = 100, bossfight = 90, hold = 80, fly = 50, speed = 40 }
M.PRIORITY = PRIORITY
local claims = {}          
local preemptFns = {}      
local stats = { claims = 0, preempts = 0, rejections = 0 }
function M.stats() return table.clone(stats) end
function M.owner()
local best, bestP = nil, -1
for name in pairs(claims) do
local p = PRIORITY[name] or 0
if p > bestP then best, bestP = name, p end
end
return best
end
function M.blockedBy(name)
local mine = PRIORITY[name] or 0
local top = M.owner()
if top and top ~= name and (PRIORITY[top] or 0) > mine then return top end
return nil
end
function M.onPreempt(name, fn) preemptFns[name] = fn end
function M.claim(name)
local blocker = M.blockedBy(name)
if claims[name] then return blocker == nil, blocker end
claims[name] = true
stats.claims = stats.claims + 1
local mine = PRIORITY[name] or 0
for other in pairs(claims) do
if other ~= name and (PRIORITY[other] or 0) < mine and preemptFns[other] then
stats.preempts = stats.preempts + 1
BX.try("motion.preempt." .. other, preemptFns[other], name)
end
end
if blocker then log.info("%s claimed under %s (waiting)", name, blocker) end
return blocker == nil, blocker
end
function M.release(name)
if claims[name] then
claims[name] = nil
log.trace("%s released the character", name)
end
end
function M.holds(name) return claims[name] == true end
local rejections = {}      
local RING = 64
local head = 0
local listeners = {}       
local function hasRelocate(v, depth)
depth = depth or 0
if type(v) == "string" then return v:find("Relocate", 1, true) ~= nil end
if type(v) == "table" and depth < 2 then
for k, x in pairs(v) do
if hasRelocate(k, depth + 1) or hasRelocate(x, depth + 1) then return true end
end
end
return false
end
local function reject(kind)
stats.rejections = stats.rejections + 1
head = (head % RING) + 1
local now = os.clock()
local who = M.owner()
rejections[head] = { at = now, kind = kind, owner = who }
log.info("server correction (%s) while %s owned the character", kind, tostring(who or "nobody"))
for i = #listeners, 1, -1 do
local L = listeners[i]
if L.scope and L.scope.dead then
table.remove(listeners, i)
else
BX.try("motion.onRejected", L.fn, kind, who)
end
end
end
function M.rejectionsSince(t)
local n = 0
for _, r in pairs(rejections) do
if r.at >= (t or 0) then n = n + 1 end
end
return n
end
function M.lastRejectionAt()
local last = 0
for _, r in pairs(rejections) do if r.at > last then last = r.at end end
return last
end
function M.onRejected(scope, fn)
listeners[#listeners + 1] = { scope = scope, fn = fn }
end
local sc = BX.scope("core.motion")
BX.try("motion.watch", function()
local net = svc.ReplicatedStorage:FindFirstChild("Packages")
net = net and net:FindFirstChild("Networking")
if not net then log.warn("no Networking folder - corrections not observable") return end
local began = net:FindFirstChild("RE/RigSync/CorrectionBegan")
if began and began:IsA("RemoteEvent") then
sc:connect(began.OnClientEvent, function() reject("CorrectionBegan") end)
end
local refresh = net:FindFirstChild("RE/RigSync/Refresh")
if refresh and refresh:IsA("RemoteEvent") then
sc:connect(refresh.OnClientEvent, function(...)
for i = 1, select("#", ...) do
if hasRelocate((select(i, ...))) then reject("Relocate") return end
end
end)
end
log.info("watching RigSync corrections (began=%s refresh=%s)",
tostring(began ~= nil), tostring(refresh ~= nil))
end)
BX.profile.watch("motion.owner", function() return M.owner() or "-" end)
return M
end)
BX.module("core.util", function(BX)
local M = {}
function M.clamp(v, lo, hi)
return math.max(lo, math.min(hi, v))
end
function M.round(v, places)
local m = 10 ^ (places or 0)
return math.floor(v * m + 0.5) / m
end
function M.wait(seconds)
task.wait(seconds)
return BX.alive()
end
function M.short(n)
if n >= 1e6 then return ("%.1fM"):format(n / 1e6) end
if n >= 1e3 then return ("%.1fk"):format(n / 1e3) end
return tostring(math.floor(n))
end
return M
end)
BX.module("auth.vampauth", function(BX)
local PROJECT_ID = "R9Z3HF7LBJ0BBIUY"
local AUTH_SECRET = "cef8607da5c3bb3e11f93d8109133e266a7c0d2e3077a190"
local KEY_LINK = "https://vampauth.com/R9Z3HF7LBJ0BBIUY/flow"
local last = ""
local client
local function message(text)
last = tostring(text or "")
return last
end
local function loadClient()
if client then return client end
if AUTH_SECRET == "REPLACE_WITH_YOUR_NEW_VAMP_AUTH_SECRET" then
message("Add your new Vampauth Auth Secret in auth/vampauth.lua first.")
return nil
end
local ok, factory = pcall(function()
local source = game:HttpGet("https://vampauth.com/client/vampauth.lua")
local loader = loadstring or load
return loader(source)()
end)
if not ok or type(factory) ~= "table" then
message("Could not load the Vampauth client.")
return nil
end
local made, instance = pcall(factory.new, {
projectId = PROJECT_ID,
authSecret = AUTH_SECRET,
})
if not made or not instance then
message("Could not initialize Vampauth.")
return nil
end
client = instance
return client
end
local function copyLink()
local set = setclipboard or toclipboard
if type(set) == "function" then
local ok = pcall(set, KEY_LINK)
if ok then
message("Vampauth key link copied.")
return true, KEY_LINK, true
end
end
message("Vampauth key link is ready below.")
return true, KEY_LINK, false
end
local function verifyKey(key)
key = tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", "")
if key == "" then message("Key is empty."); return false end
local vp = loadClient()
if not vp then return nil end
local ok, valid, data = pcall(function()
local passed, result = vp:Check(key)
return passed, result
end)
if not ok then
message("Vampauth key check failed.")
return nil
end
if valid then
message("Vampauth key is valid.")
return true
end
message(type(data) == "string" and data or "Invalid or expired key.")
return false
end
local function lastMessage() return last end
return {
copyLink = copyLink,
verifyKey = verifyKey,
lastMessage = lastMessage,
}
end)
BX.module("ui.logodata", function(BX)
return {
name = "logo-33f70fd5.png",
b64 = "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",
}
end)
BX.module("ui.logo", function(BX)
local exec = BX.require("core.exec")
local log = BX.require("boot.log").for_module("logo")
local M = {}
local FALLBACK_ASSET = "rbxassetid://95108798243406"
local FOLDER = "VoidcxzHub/assets"
local OVERRIDE = FOLDER .. "/logo.png"
local ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function decode(text)
local out
pcall(function()
local lib = crypt
local candidates = {}
local function add(fn) if type(fn) == "function" then candidates[#candidates + 1] = fn end end
if type(lib) == "table" then
add(lib.base64decode)
if type(lib.base64) == "table" then add(lib.base64.decode) end
end
add(base64decode)
add(base64_decode)
for _, fn in ipairs(candidates) do
local ok, data = pcall(fn, text)
if ok and type(data) == "string" and #data > 0 then out = data return end
end
end)
if out then return out end
local map = {}
for i = 1, 64 do map[ALPHABET:sub(i, i)] = i - 1 end
local bytes, n = {}, 0
for i = 1, #text, 4 do
local a = map[text:sub(i, i)]
local b = map[text:sub(i + 1, i + 1)]
if not (a and b) then break end
local c, d = map[text:sub(i + 2, i + 2)], map[text:sub(i + 3, i + 3)]
n = n + 1; bytes[n] = string.char(a * 4 + math.floor(b / 16))
if c then n = n + 1; bytes[n] = string.char((b % 16) * 16 + math.floor(c / 4)) end
if d then n = n + 1; bytes[n] = string.char((c % 4) * 64 + d) end
end
return table.concat(bytes)
end
local function assetFor(path)
if not exec.isFile(path) then return nil end
local id = exec.customAsset(path)
if type(id) == "string" and id ~= "" then return id end
return nil
end
local function fromWorkspace()
if not (exec.can.customAsset and exec.can.files) then return nil end
local override = assetFor(OVERRIDE)
if override then
log.info("using the dropped %s", OVERRIDE)
return override
end
local data = BX.require("ui.logodata")
local path = FOLDER .. "/" .. data.name
if not exec.isFile(path) then
local bytes = decode(data.b64)
if #bytes < 64 then
log.warn("could not decode the baked mark")
return nil
end
exec.ensureFolder(FOLDER)
if not exec.writeFile(path, bytes) then return nil end
end
return assetFor(path)
end
local resolved = nil
function M.image()
if resolved then return resolved end
local ok, id = BX.try("logo.resolve", fromWorkspace)
resolved = (ok and id) or FALLBACK_ASSET
if resolved == FALLBACK_ASSET then
log.warn("no file access for the mark - falling back to the upload")
end
return resolved
end
function M.icon()
local id = M.image()
local numeric = tostring(id):match("^rbxassetid://(%d+)$")
return numeric and tonumber(numeric) or id
end
return M
end)
BX.module("ui.wording", function(BX)
local M = {}
local RULES = {
{ "^delivered",                    "Egg delivered!" },
{ "egg inventory full",            "Your egg inventory is full - sell, place or hatch eggs" },
{ "inventory is full",             "Your egg inventory is full - sell, place or hatch eggs" },
{ "^field resetting",              "The egg field is resetting - it continues after" },
{ "^guards out: (.+)",             "Waiting for the guard to walk back (%1)" },
{ "waiting for the guard",         "Waiting for the guard to walk back" },
{ "movement not trusted",          "The server slowed you down - pausing a moment" },
{ "no bait egg",                   "No egg in the Forest to distract the guard yet" },
{ "egg back in its nest",          "The egg went back to its nest - trying again" },
{ "^selected egg is gone",         "Your egg is gone - pick another one" },
{ "^egg taken by someone else",    "Someone else grabbed that egg - picking another" },        { "^waiting for the selected egg", "Waiting for your egg to be free" },
{ "^nothing matches the filter",   "No eggs match your filters right now" },
{ "^nothing to steal",             "No eggs to steal right now" },
{ "^field=0",                      "No eggs out right now" },
{ "^held egg",                     "Dropping the egg you are holding first" },
{ "^bait not taken",               "The guard did not take the bait - trying again" },
{ "^approach:",                    "Could not reach the egg - trying again" },
{ "^grab:",                        "Could not pick up the egg - trying again" },
{ "^drop recovery:",               "Picking the dropped egg back up" },
{ "^carry:",                       "Lost the egg on the way home - trying again" },
{ "^target picker failed",         "Could not choose an egg - trying again" },
{ "^cancelled",                    "Stopped" },
{ "^toggled off",                  "Stopped" },
{ "^hub unloaded",                 "Stopped" },
}
function M.plain(why)
local text = tostring(why or "")
if text == "" then return "" end
local lower = text:lower()
for _, rule in ipairs(RULES) do
local caps = { lower:match(rule[1]) }
if #caps > 0 then
local first = caps[1]
local at = lower:find(first, 1, true)
local original = at and text:sub(at, at + #first - 1) or first
return (rule[2]:gsub("%%1", function() return original end))
end
end
return text:sub(1, 1):upper() .. text:sub(2)
end
M.GUARDED = "guarded"
M.ON_GROUND = "on the ground"
return M
end)
BX.module("ui.splash", function(BX)
local svc = BX.require("core.services")
local exec = BX.require("core.exec")
local log = BX.require("boot.log").for_module("splash")
local sc = BX.scope("ui.splash")
local timeline = BX.timeline or function() end
local M = {}
M.step = function() end
M.fail = function() end
M.done = function() end
M.whenClosed = function(fn) pcall(fn) end
M.stats = function() return {} end
M.geometry = function() return nil end
local WIDTH, HEIGHT, PAD = 520, 376, 44
local AUTO_CONTINUE = 10 
local UPDATES = type(BX.releaseNotes) == "table" and BX.releaseNotes or {
{ "New",      "Native V6 UI — no Rayfield download, cache, or CDN dependency." },
{ "Polished", "Premium motion, Dynamic Island, drag, resize, and touch controls." },
{ "Improved", "One dark-violet visual system with clearer, more readable type." },
{ "Fixed",    "Reliable tabs, profiles, fades, window morphs, and layout." },
}
function M.build(tab)
if not tab then return M end
if type(tab.SetHeading) == "function" then
tab:SetHeading("VoidcxzHub Community")
end
tab:CreateSection({ name = "Updates" })
local major = tostring(BX.version or "5"):match("^(%d+)") or "5"
tab:CreateListCard({
name = "Latest",
badge = ("V%s Release"):format(major),
rows = UPDATES,
titleSize = 17,
badgeSize = 11,
tagSize = 10,
rowTextSize = 14,
})
return M
end
return M
end)
BX.module("ui.tabs.main", function(BX)
local auto = BX.require("features.autosteal")
local eggs = BX.require("features.eggs")
local dev  = BX.require("core.device")
local tread = BX.require("features.treadmill")
local prof = BX.require("core.profiles")
local win  = BX.require("ui.shell")
local log  = BX.require("boot.log").for_module("main")
local cfg  = BX.require("core.config")
local words = BX.require("ui.wording")
local M = {}
local MAX_EGGS = 120
local SETTLE_AFTER_NIGHT = 2.0
local labelToUid = {}
local rows       = {}
local selectedUid = nil
local dropdown, toggle = nil, nil
BX.profile.watch("ui.dropdown", function() return #rows end)
local function labelFor(egg)
local suffix = ""
if egg.guardHeld then suffix = "  (" .. words.GUARDED .. ")"
elseif egg.dropped then suffix = "  (" .. words.ON_GROUND .. ")" end
return ("%s  |  %s%s"):format(egg.name, eggs.rateText(egg), suffix)
end
local function labelName(value)
if type(value) ~= "string" then return nil end
return value:match("^(.-)%s%s|%s%s") or value
end
local function buildOptions(allowPartial)
local list = eggs.list({ allowPartial = allowPartial == true }, true)
labelToUid = {}
rows = {}
local options, used = {}, {}
for i, egg in ipairs(list) do
if i > MAX_EGGS then break end
local label = labelFor(egg)
if used[label] then
local n = used[label] + 1
used[label] = n
label = label .. ("  #%d"):format(n)
else
used[label] = 1
end
labelToUid[label] = egg.uid
rows[#rows + 1] = egg
options[#options + 1] = label
end
if #options == 0 then options[1] = "No eggs found" end
return options
end
local function eggForLabel(value)
if type(value) ~= "string" or value == "" or value == "No eggs found" then
return nil
end
local uid = labelToUid[value]
if uid then
for _, e in ipairs(rows) do
if e.uid == uid then return e end
end
return { uid = uid, name = labelName(value) or value }
end
local want = labelName(value)
if want then
for _, e in ipairs(rows) do
if e.name == want then return e end
end
end
return nil
end
local refreshing = false
local function refresh(reason)
if refreshing or not dropdown then return end
refreshing = true
eggs.invalidate("ui " .. tostring(reason or "refresh"))
local options = BX.offthread(function() return buildOptions(true) end, 8)
local ok = BX.try("main.refresh", function()
if type(options) ~= "table" then
log.warn("refresh: egg read timed out - list left as it was")
return
end
local keep = nil
if selectedUid then
for label, uid in pairs(labelToUid) do
if uid == selectedUid then keep = label break end
end
if not keep then
log.info("selected egg %s is gone - clearing", tostring(selectedUid))
selectedUid = nil
if not (auto.isRunning() and auto.owner() == "main") then
auto.setOptions("main", { uid = nil })
end
end
end
dropdown:Refresh(options, true)
if keep then dropdown:Set(keep) end
end)
refreshing = false
log.info("refresh (%s): %d of %d eggs%s", tostring(reason), #rows,
#(eggs.list({ allowPartial = true }) or {}), ok and "" or " FAILED")
if reason == "button" then
if not ok or type(options) ~= "table" then
win.notify("Eggs", "Could not read the field - try again", 4)
else
win.notify("Eggs", ("%d eggs on the field"):format(#rows), 3)
end
end
end
M.refresh = refresh
local function startMain()
local okStart, why
if not selectedUid then
okStart, why = false, "Pick a Target Egg first"
else
auto.setOptions("main", { uid = selectedUid })
okStart, why = auto.setEnabled(true, "main")
end
if okStart == false then
win.notify("Auto Steal", tostring(why), 6)
task.spawn(function()
BX.try("main.toggleRefused", function()
if toggle and toggle.Set then
toggle:Set(false)
end
end)
end)
end
end
function M.build(tab)
if not tab then return M end
tab:CreateSection({ name = "Stealing" })
dropdown = tab:CreateDropdown({
name = "Target Egg",
description = "Highest income first.",
options = BX.offthread(buildOptions, 5) or { "No eggs found" },
currentOption = nil,
callback = function(value)
local picked = type(value) == "table" and value[1] or value
local egg = eggForLabel(picked)
selectedUid = egg and egg.uid or nil
M.selectedName = egg and egg.name or nil
auto.setOptions("main", { uid = selectedUid })
log.info("target: %s (uid=%s)", tostring(picked), tostring(selectedUid))
end,
})
tab:CreateButton({
name = "Refresh Eggs",
callback = function() refresh("button") end,
})
local autoButtonOk, autoButtonOrError = pcall(function()
return tab:CreateButton({
name = "Auto Steal",
description = "Start stealing the selected egg.",
callback = function() startMain() end,
})
end)
if not autoButtonOk then
log.warn("Auto Steal button failed: %s", tostring(autoButtonOrError))
tab:CreateLabel({
name = "Auto Steal",
text = "Auto Steal unavailable",
})
end
toggle = nil
prof.onApply("AutoSteal", function(v)
if v then
if not auto.isRunning() then startMain() end
elseif auto.isRunning() and auto.owner() == "main" then
auto.setEnabled(false, "main")
end
end)
auto.onIdle(function(why, whose)
if whose and whose ~= "main" then return end
local text = tostring(why)
if text:find("egg inventory full", 1, true) then
local count = text:match("%(%d+/%d+%)")
text = "Your egg inventory is full" .. (count and (" " .. count) or "")
.. " - sell, place or hatch eggs. It continues by itself."
elseif text == "field resetting" then
local data = BX.require("core.data")
local left = data.secondsUntilReset()
local wait
if data.fieldSealed() then
wait = (left and left < 60) and (left + 6) or 6
else
wait = left and (left + 6) or nil
end
text = wait and ("The egg field is resetting - Auto Steal continues in about %ds"):format(math.ceil(wait))
or "The egg field is resetting - Auto Steal continues after"
else
text = words.plain(text)
end
task.spawn(function() win.notify("Auto Steal", text, 7) end)
end)
auto.onStop(function(why, whose)
if whose and whose ~= "main" then return end
auto.setOptions("main", { uid = selectedUid })
if why == "selected egg is gone" then
task.spawn(function()
win.notify("Auto Steal", words.plain("selected egg is gone"), 5)
end)
end
task.spawn(function()
BX.try("main.toggleOff", function()
if toggle and toggle.Set then
toggle:Set(false)
end
end)
end)
if why == "delivered" then
task.spawn(function()
win.notify("Auto Steal", "Egg delivered!", 4)
end)
end
end)
if BX._factories["features.antihit"] then
local ah = BX.require("features.antihit")
ah.setEnabled(true, "main")
prof.allow("AntiHit", "boolean")
tab:CreateToggle({
name = "Anti Hit",
description = "Protects you and flies straight home the moment the egg is yours.",
value = true,
flag = "AntiHit",
callback = function(on) ah.setEnabled(on, "main") end,
})
prof.onApply("AntiHit", function(v) ah.setEnabled(v and true or false, "main") end)
end
tab:CreateSection({ name = "Visuals" })
local espRow = tab
BX.try("main.espRow", function()
local row = tab:CreateGroup({ direction = "row" })
if row then espRow = row end
end)
espRow:CreateToggle({
name = "Egg ESP",
value = false,
callback = function(on)
BX.try("main.eggEsp", function()
BX.require("features.esp.eggs").setEnabled(on)
end)
end,
})
espRow:CreateToggle({
name = "Plot ESP",
value = false,
callback = function(on)
BX.try("main.plotEsp", function()
BX.require("features.esp.plot").setEnabled(on)
end)
end,
})
tab:CreateSection({ name = "Safety" })
if BX.edition == "free" then
tab:CreateButton({
name = "Get Off Treadmill",
description = "Stuck on your treadmill? Press to get off.",
callback = function()
task.spawn(function()
local ok, msg = tread.unstuck()
win.notify("Treadmill", tostring(msg), ok and 3 or 4)
end)
end,
})
else
tab:CreateToggle({
name = "Anti Treadmill",
description = "Gets you off your plot's treadmill automatically.",
value = cfg.DEFAULT_ANTI_TREADMILL == true,
flag = "AntiTreadmill",
callback = function(on)
tread.setEnabled(on and true or false)
end,
})
prof.onApply("AntiTreadmill", function(v) tread.setEnabled(v and true or false) end)
end
local sc = BX.scope("ui.tabs.main")
sc:loop("prune", dev.scale(10), function()
if not selectedUid then return end
local still = eggs.get(selectedUid)
if not still then refresh("selected egg vanished") end
end)
local data = BX.require("core.data")
local wasSealed = nil        
local reopenAt = nil
sc:loop("night", dev.scale(2), function()
local sealed = BX.offthread(function() return data.fieldSealed() end, 2)
if sealed == nil then return end          
if wasSealed == nil then
wasSealed = sealed
return
end
if sealed ~= wasSealed then
wasSealed = sealed
reopenAt = (not sealed) and (os.clock() + SETTLE_AFTER_NIGHT) or nil
if reopenAt then log.info("field reopened - refreshing the list") end
end
if reopenAt and os.clock() >= reopenAt then
reopenAt = nil
eggs.invalidate("night")
refresh("night")
end
end)
log.info("main tab built (%d eggs)", #rows)
return M
end
return M
end)
BX.module("ui.tabs.farm", function(BX)
local auto   = BX.require("features.autosteal")
local eggs   = BX.require("features.eggs")
local filter = BX.require("features.farm.filter")
local prio   = BX.require("features.farm.priority")
local hold   = BX.require("features.farm.treadmill_on")
local pets   = BX.require("features.farm.pets")
local care   = BX.require("features.farm.plotcare")
local prof   = BX.require("core.profiles")
local win    = BX.require("ui.shell")
local words  = BX.require("ui.wording")
local log    = BX.require("boot.log").for_module("farm.tab")
local M = {}
local index  = BX.require("features.farm.index")
local autoToggle, holdToggle, lockToggle, statusLine
local placeToggle, hatchToggle = nil, nil
local indexStartedFarm = false
local areaDrop, rarityDrop
local statusSc, lastStatus = nil, nil
local function paintStatus(text)
if not statusLine or text == lastStatus then return end
if BX.try("farm.status", function() statusLine:Set(text) end) then
lastStatus = text
end
end
local function statusText()
local st = filter.status()
if not auto.isRunning() or auto.owner() ~= "farm" then return "Off" end
local idle = auto.status().idle
if idle then
local areasOut = tostring(idle):match("guards out: (.+)%)$")
if areasOut then return words.plain("guards out: " .. areasOut) end
return words.plain(idle)
end
if care.isPlacing() and care.status():find("walking to your plot", 1, true) then
return "Placing the egg on your plot"
end
local riftNow = prio.statusSuffix()
if riftNow then return riftNow:sub(1, 1):upper() .. riftNow:sub(2) end
return words.plain(st.text)
end
local statusWanted = false
local pendingStatus = nil
local function watchStatus(on)
statusWanted = on and true or false
end
local areaIds, rarityIds = {}, {}
local function labelsAndMap(rows)
local labels, map = {}, {}
for _, r in ipairs(rows) do
labels[#labels + 1] = r.label
map[r.label] = r.id
end
return labels, map
end
local function idsFor(picked, map)
local out = {}
if type(picked) == "table" then
for _, label in pairs(picked) do
local id = map[tostring(label)]
if id then out[#out + 1] = id end
end
elseif type(picked) == "string" and picked ~= "" then
local id = map[picked]
if id then out[#out + 1] = id end
end
return out
end
local function farmOptions()
return {
pick = prio.pick,
continuous = true,
}
end
local function startFarm()
auto.setOptions("farm", farmOptions())
log.info("options handed over (%s)", filter.describe())
local okStart, why = auto.setEnabled(true, "farm")
log.info("start requested: running=%s owner=%s state=%s",
tostring(auto.isRunning()), tostring(auto.owner()), tostring(auto.runState()))
if okStart == false then
pendingStatus = tostring(why)
win.notify("Farm", tostring(why), 6)
task.spawn(function()
BX.try("farm.toggleRefused", function()
if autoToggle and autoToggle.Set then
autoToggle:Set(false)
end
end)
end)
return false
end
watchStatus(true)
return true
end
local function setHold(on)
local ok, why = hold.setEnabled(on and true or false)
if on and not ok then
BX.try("farm.holdRefused", function()
if holdToggle and holdToggle.Set then
holdToggle:Set(false)
end
end)
win.notify("Farm", tostring(why or "Could not use the belt"), 4)
end
end
local function buildFarm(tab)
if not tab then return M end
local function row()
local r = tab
BX.try("farm.row", function()
local g = tab:CreateGroup({ direction = "row" })
if g then r = g end
end)
return r
end
tab:CreateSection({ name = "Targets" })
local areaRows = filter.areaOptions()
local areaLabels
areaLabels, areaIds = labelsAndMap(areaRows)
areaDrop = tab:CreateDropdown({
name = "Areas",
multi = true,
options = #areaLabels > 0 and areaLabels or { "No areas found" },
flag = "FarmAreas",
callback = function(picked)
filter.setAreas(idsFor(picked, areaIds))
end,
})
prof.onApply("FarmAreas", function(v) filter.setAreas(idsFor(v, areaIds)) end)
local rarityRows = filter.rarityOptions()
local rarityLabels
rarityLabels, rarityIds = labelsAndMap(rarityRows)
rarityDrop = tab:CreateDropdown({
name = "Rarities",
multi = true,
options = #rarityLabels > 0 and rarityLabels or { "No rarities found" },
flag = "FarmRarities",
callback = function(picked)
filter.setRarities(idsFor(picked, rarityIds))
end,
})
prof.onApply("FarmRarities", function(v) filter.setRarities(idsFor(v, rarityIds)) end)
tab:CreateDropdown({
name = "Target By",
options = filter.targetByOptions(),
flag = "FarmTargetBy",
callback = function(v)
filter.setTargetBy(type(v) == "table" and v[1] or v)
end,
})
prof.onApply("FarmTargetBy", function(v) filter.setTargetBy(type(v) == "table" and v[1] or v) end)
tab:CreateButton({
name = "Check Matching Eggs",
callback = function()
local count = filter.matchCount()
win.notify("Farm", ("%d matching eggs found"):format(count), 3)
end,
})
tab:CreateSection({ name = "Farming" })
autoToggle = tab:CreateToggle({
name = "Auto Farm",
description = "Keeps stealing eggs that match your targets.",
value = false,
flag = "FarmAutoSteal",
callback = function(on)
BX.try("farm.autoToggle", function()
log.info("toggle -> %s", on and "ON" or "OFF")
if on then
startFarm()
return
end
watchStatus(false)
auto.setEnabled(false, "farm")
end)
end,
})
prof.onApply("FarmAutoSteal", function(v)
if v then
if not auto.isRunning() then startFarm() end
elseif auto.isRunning() and auto.owner() == "farm" then
watchStatus(false)
auto.setEnabled(false, "farm")
end
end)
if BX._factories["features.antihit"] then
local ah = BX.require("features.antihit")
ah.setEnabled(true, "farm")
prof.allow("FarmAntiHit", "boolean")
tab:CreateToggle({
name = "Anti Hit",
description = "Protects you and flies straight home the moment the egg is yours.",
value = true,
flag = "FarmAntiHit",
callback = function(on) ah.setEnabled(on, "farm") end,
})
prof.onApply("FarmAntiHit", function(v) ah.setEnabled(v and true or false, "farm") end)
end
tab:CreateDropdown({
name = "Priority",
options = prio.MODES,
flag = "FarmPriority",
callback = function(v)
prio.setMode(type(v) == "table" and v[1] or v)
end,
})
prof.onApply("FarmPriority", function(v)
prio.setMode(type(v) == "table" and v[1] or v)
end)
tab:CreateToggle({
name = "Auto Index",
description = "Steals missing pets, hatches them, claims rewards.",
value = false,
callback = function(on)
BX.try("farm.autoIndex", function()
on = on and true or false
filter.setIndexOnly(on)
if on then
if placeToggle and not care.isPlacing() then placeToggle:Set(true) end
if hatchToggle and not care.isHatching() then hatchToggle:Set(true) end
if not (auto.isRunning() and auto.owner() == "farm") and autoToggle then
indexStartedFarm = true
autoToggle:Set(true)
end
else
if indexStartedFarm and autoToggle and auto.isRunning() and auto.owner() == "farm" then
autoToggle:Set(false)
end
indexStartedFarm = false
end
local have, total = index.progress()
win.notify("Auto Index", on and ("On  \u{B7}  %d/%d discovered"):format(have, total) or "Off", 3)
end)
end,
})
tab:CreateSection({ name = "Treadmill" })
local treadRow = row()
holdToggle = treadRow:CreateToggle({
name = "Wait On Treadmill",
value = false,
flag = "UseTreadmillWhileWaiting",
callback = function(on)
setHold(on)
end,
})
prof.onApply("UseTreadmillWhileWaiting", function(v)
if (v and true or false) ~= hold.isOn() then setHold(v) end
end)
lockToggle = treadRow:CreateToggle({
name = "Lock To Treadmill",
value = false,
flag = "TreadmillLock",
callback = function(on)
hold.setLock(on)
end,
})
prof.onApply("TreadmillLock", function(v) hold.setLock(v) end)
tab:CreateSection({ name = "Plot & Pets" })
local plotRow = row()
placeToggle = plotRow:CreateToggle({
name = "Auto Place",
value = false,
callback = function(on)
BX.try("farm.autoPlace", function() care.setPlace(on) end)
end,
})
hatchToggle = plotRow:CreateToggle({
name = "Auto Hatch",
value = false,
callback = function(on)
BX.try("farm.autoHatch", function() care.setHatch(on) end)
end,
})
tab:CreateButton({
name = "Equip Best Pets",
callback = function()
local ok, msg = pets.equipBest()
win.notify("Pets", tostring(msg), ok and 3 or 4)
end,
})
statusSc = BX.scope("ui.tabs.farm.paint")
statusSc:loop("indexClaim", 1.0, function()
if not filter.isIndexOnly() then return end
task.spawn(function()
BX.try("farm.indexClaim", function()
local ok, msg = index.claimRewards()
if ok then win.notify("Auto Index", msg, 4) end
end)
end)
end)
if not M.wiredPlace then
M.wiredPlace = true
auto.setBetweenCycles(function(whose)
if whose ~= "farm" then return end
if care.isPlacing() then care.placeNow() end
if care.isHatching() then care.hatchNow() end
end)
end
if not M.wired then
M.wired = true
auto.onStop(function(why, whose)
if whose and whose ~= "farm" then return end
task.spawn(function()
BX.try("farm.toggleOff", function()
watchStatus(false)
if autoToggle and autoToggle.Set then
autoToggle:Set(false)
end
end)
end)
end)
end
log.info("farm tab built (%d areas, %d rarities)", #areaLabels, #rarityLabels)
return M
end
local KEY_FILE = "VoidcxzHub/farm_key.txt"
local RECHECK = 600     
local function buildGated(tab)
local exec = BX.require("core.exec")
local auth = BX.require("auth.vampauth")
local gate, keyValue, built, open, checking = {}, "", false, false, false
local gateStatus, keyLink
local content = {}
local farmTab = setmetatable({}, { __index = tab })
for _, method in ipairs({ "CreateSection", "CreateText", "CreateLabel",
"CreateButton", "CreateToggle", "CreateSlider", "CreateDropdown",
"CreateInput", "CreateRichCard", "CreateListCard" }) do
farmTab[method] = function(_, o)
local h = tab[method](tab, o)
if h then content[#content + 1] = h end
return h
end
end
farmTab.CreateGroup = function(_, o)
local g = tab:CreateGroup(o)
if g == tab then return farmTab end
local tracked = setmetatable({}, { __index = g })
function tracked:CreateToggle(opts)
local h = g:CreateToggle(opts)
if h then content[#content + 1] = h end
return h
end
function tracked:CreateButton(opts)
local h = g:CreateButton(opts)
if h then content[#content + 1] = h end
return h
end
return tracked
end
local function status(text, announce)
text = tostring(text)
local lower = text:lower()
if lower:find("httperror", 1, true) or lower:find("ssl", 1, true)
or lower:find("could not be reached", 1, true) then
text = "Key service is unavailable right now. Use Get Key, then retry shortly."
end
if gateStatus then BX.try("farm.gateStatus", function() gateStatus:Set(text) end) end
if announce then win.notify("Farm access", text, 4) end
end
local function showAll(list, on)
for _, h in ipairs(list) do
BX.try("farm.visible", function() h:setVisible(on) end)
end
end
local function showGate(on) showAll(gate, on) end
local function scrollTop()
BX.try("farm.scrollTop", function()
local raw = gate[1] and gate[1]:raw()
local m = type(raw) == "table" and rawget(raw, "main")
local sf = typeof(m) == "Instance" and m:FindFirstAncestorWhichIsA("ScrollingFrame")
if sf then sf.CanvasPosition = Vector2.zero end
end)
end
local function saveKey(k)
BX.try("farm.saveKey", function()
exec.ensureFolder("VoidcxzHub")
exec.writeFile(KEY_FILE, k)
end)
end
local function savedKey()
local k
BX.try("farm.readKey", function()
if exec.isFile(KEY_FILE) then k = exec.readFile(KEY_FILE) end
end)
k = k and tostring(k):gsub("^%s+", ""):gsub("%s+$", "") or ""
return k ~= "" and k or nil
end
local function unlock()
open = true
showGate(false)
if built then
showAll(content, true)
else
built = true
BX.try("farm.buildUnlocked", function() buildFarm(farmTab) end)
end
scrollTop()
end
local function check(k, quiet)
if checking then return nil end
checking = true
if not quiet then status("Checking key...") end
local ok, valid = pcall(auth.verifyKey, k)
checking = false
if not ok then
log.warn("key check failed: %s", tostring(valid))
return nil
end
return valid
end
gate[#gate + 1] = tab:CreateSection({ name = "Farm Access" })
gate[#gate + 1] = tab:CreateInput({
name = "Farm Key",
placeholder = "KEY_...",
callback = function(value) keyValue = tostring(value or "") end,
})
gate[#gate + 1] = tab:CreateButton({
name = "Get Key",
callback = function()
task.spawn(function()
local ran, made, link, copied = pcall(auth.copyLink)
if ran and made and type(link) == "string" and link ~= "" then
if copied then
status("Key link copied - paste it in your browser.", true)
else
if keyLink and keyLink.Set then keyLink:Set(link) end
if keyLink then keyLink:setVisible(true) end
status("Key link is ready below - long-press to copy it into your browser.", true)
end
else
status(tostring(auth.lastMessage() or "Could not create the key link."), true)
end
end)
end,
})
keyLink = tab:CreateInput({
name = "Key Link",
placeholder = "Appears here if your device cannot copy it automatically",
})
keyLink:setVisible(false)
gate[#gate + 1] = keyLink
gate[#gate + 1] = tab:CreateButton({
name = "Unlock Farm",
callback = function()
task.spawn(function()
local k = keyValue:gsub("^%s+", ""):gsub("%s+$", "")
if k == "" then status("Paste a key first.", true) return end
local valid = check(k)
if valid then
saveKey(k)
status("Farm unlocked.", true)
log.info("farm unlocked with a key")
unlock()
elseif valid == nil then
status(auth.lastMessage() or "Could not reach the key server - try again.", true)
else
status(auth.lastMessage() or "Invalid or expired key.", true)
end
end)
end,
})
task.spawn(function()
local k = savedKey()
if not k then return end
keyValue = k
status("Checking your saved key...")
local valid = check(k, true)
if valid then
log.info("farm unlocked with the saved key")
unlock()
else
status(valid == false and "Your saved key expired - get a new one."
or "Could not reach the key server - press Unlock Farm to retry.")
end
end)
task.spawn(function()
while BX.alive() do
task.wait(RECHECK)
if open and keyValue ~= "" and not checking then
if check(keyValue, true) == false then
log.info("farm key expired - locking the farm")
if auto.isRunning() and auto.owner() == "farm" then auto.setEnabled(false, "farm") end
open = false
status("Your key expired - get a new one.")
showAll(content, false)
showGate(true)
win.notify("Farm", "Your key expired - get a new one in the Farm tab.", 6)
end
end
end
end)
return M
end
function M.build(tab)
if not tab then return M end
if BX.edition == "free" and BX._factories["auth.vampauth"] then
return buildGated(tab)
end
return buildFarm(tab)
end
function M.teardown()
autoToggle, holdToggle, lockToggle, statusLine, areaDrop, rarityDrop = nil, nil, nil, nil, nil, nil
placeToggle, hatchToggle, indexStartedFarm = nil, nil, false
filter.setIndexOnly(false)
lastStatus = nil
if statusSc then statusSc:destroy() statusSc = nil end
if auto.isRunning() and auto.owner() == "farm" then auto.setEnabled(false, "farm") end
if hold.isOn() then hold.setEnabled(false) end
statusWanted = false
care.setPlace(false)
care.setHatch(false)
log.info("farm tab torn down")
end
return M
end)
BX.module("ui.tabs.event", function(BX)
local boss  = BX.require("features.boss")
local fight = BX.require("features.bossfight")
local rift  = BX.require("features.rift")
local auto = BX.require("features.autosteal")
local win  = BX.require("ui.shell")
local log  = BX.require("boot.log").for_module("event.tab")
local M = {}
local K = {
PAINT = 1.0,
}
M.K = K
local sc = nil
local bossLine, riftLine, petDrop, autoRiftToggle, fightToggle
local droneLine, droneToggle
local suppressDrop = 0
local lastOptSig = nil
local painted = {}      
local function say(msg, secs)
win.notify("Event", tostring(msg), secs or 3)
end
local function paint(el, st)
if not el then return end
local last = painted[el]
if not last then last = {} painted[el] = last end
if st.title and st.title ~= last.title then
if BX.try("event.setTitle", function() el:SetTitle(st.title) end) then
last.title = st.title
end
end
if st.body ~= last.body then
if BX.try("event.setBody", function() el:Set(st.body) end) then
last.body = st.body
end
end
end
local function repaintBoss()
paint(bossLine, boss.status())
end
local function repaintDrones()
if not droneLine then return end
local mod = BX._loaded["features.drones"]
if mod then
local status = mod.status()
local body = tostring(status.body or "")
body = body:match("^(.-)%s+·") or body
paint(droneLine, { title = body, body = "" })
end
end
local function repaintRift()
paint(riftLine, rift.status())
if not petDrop then return end
local opts = rift.options()
local sig = table.concat(opts, "\1")
if sig == lastOptSig then return end
lastOptSig = sig
BX.try("event.refreshDrop", function()
suppressDrop = suppressDrop + 1
petDrop:Refresh(opts)
end)
end
function M.build(tab)
if not tab then return M end
tab:CreateSection({ name = "Boss" })
bossLine = tab:CreateText({ name = "Abyss Overlord", text = "Reading..." })
tab:CreateToggle({
name = "Auto Enter Boss",
description = "Join the boss event automatically.",
value = false,
callback = function(v)
v = v and true or false
if v and not boss.isOn() then boss.setEnabled(true) end
boss.setAutoEnter(v)
say("Auto enter " .. (v and "ON" or "OFF"))
end,
})
fightToggle = tab:CreateToggle({
name = "Auto Fight Boss",
description = "Fight the active boss.",
value = false,
callback = function(v)
v = v and true or false
fight.setEnabled(v)
say("Auto fight " .. (v and "ON" or "OFF"))
end,
})
tab:CreateSection({ name = "Rift" })
riftLine = tab:CreateText({ name = "Rift", text = "reading..." })
autoRiftToggle = tab:CreateToggle({
name = "Auto Steal Rift Pets",
description = "Steals only the pets the rift needs.",
value = false,
callback = function(v)
if not v then
if auto.isRunning() and auto.owner() == "rift" then
auto.setEnabled(false, "rift")
end
say("Rift auto OFF")
return
end
if not rift.isOn() then rift.setEnabled(true) end
auto.setOptions("rift", { pick = rift.pickTarget, continuous = true })
local okStart, why = auto.setEnabled(true, "rift")
if okStart == false then
say(tostring(why), 5)
task.spawn(function()
BX.try("event.riftRefused", function()
if autoRiftToggle and autoRiftToggle.Set then
autoRiftToggle:Set(false)
end
end)
end)
return
end
say("Rift auto ON")
end,
})
tab:CreateToggle({
name = "Auto Rift Trade-In",
description = "Trades rift pets in automatically.",
value = false,
callback = function(v)
v = v and true or false
rift.setAutoTrade(v)
say("Auto trade-in " .. (v and "ON" or "OFF"))
end,
})
if not M.wired then
rift.onTrade(function(r)
if not sc then return end   
if r == "traded" then
say("Rift: traded in - Rift Egg added to your eggs", 5)
elseif r ~= "revealed" then
say("Rift trade-in " .. tostring(r), 6)
end
end)
end
if BX._factories["features.drones"] then
local drones = BX.require("features.drones")
tab:CreateSection({ name = "Dr. Scramble" })
droneLine = tab:CreateText({ name = "0/0 drones", text = "" })
local labels = {}
for _, pair in ipairs(drones.PRIORITY_LABELS) do labels[#labels + 1] = pair[1] end
tab:CreateDropdown({
name = "Target Drones",
description = "Big drones pay more per kill.",
options = labels,
currentOption = labels[1],
callback = function(value)
local picked = type(value) == "table" and value[1] or value
for _, pair in ipairs(drones.PRIORITY_LABELS) do
if pair[1] == picked then drones.setPriority(pair[2]) end
end
end,
})
droneToggle = tab:CreateToggle({
name = "Auto Drones",
description = "Visits your drones during the window; the game swings and collects.",
value = false,
callback = function(v)
v = v and true or false
drones.setEnabled(v)
say("Auto drones " .. (v and "ON" or "OFF"))
end,
})
end
sc = BX.scope("ui.tabs.event")
sc:loop("paint", K.PAINT, function()
repaintBoss()
repaintRift()
repaintDrones()
end)
boss.setEnabled(true)
rift.setEnabled(true)
if not M.wired then
M.wired = true
auto.onStop(function(_, whose)
if whose and whose ~= "rift" then return end
task.spawn(function()
BX.try("event.riftAutoOff", function()
if autoRiftToggle and autoRiftToggle.Set then
autoRiftToggle:Set(false)
end
end)
end)
end)
end
log.info("event tab built (Boss 3 + Rift 5; watchers on, painter %.0fs)", K.PAINT)
return M
end
function M.teardown()
bossLine, riftLine, petDrop, autoRiftToggle, fightToggle = nil, nil, nil, nil, nil
droneLine, droneToggle = nil, nil
BX.try("event.teardownDrones", function()
local mod = BX._loaded["features.drones"]
if mod then mod.setEnabled(false) end
end)
painted, lastOptSig, suppressDrop = {}, nil, 0
if sc then sc:destroy() sc = nil end
BX.try("event.teardown", function()
if auto.isRunning() and auto.owner() == "rift" then auto.setEnabled(false, "rift") end
fight.setEnabled(false)
boss.setAutoEnter(false)
boss.setEnabled(false)
rift.setAutoTrade(false)
rift.setEnabled(false)
end)
log.info("event tab torn down")
end
return M
end)
BX.module("ui.tabs.misc", function(BX)
local servers = BX.require("features.misc.servers")
local hook    = BX.require("features.misc.webhook")
local fps     = BX.require("features.fps")
local win     = BX.require("ui.shell")
local prof    = BX.require("core.profiles")
local log     = BX.require("boot.log").for_module("misc.tab")
local cfg     = BX.require("core.config")
local exec    = BX.require("core.exec")
local M = {}
local webhookStatus = nil
local webhookToggle = nil
local fpsToggle = nil
function M.setFpsBoost(on)
on = on and true or false
if fpsToggle and fpsToggle.Set then
BX.try("misc.fpsSet", function() fpsToggle:Set(on) end)
else
if not on then fps.userTurnedOff = true end
BX.try("misc.fpsDirect", function() fps.setEnabled(on) end)
end
end
function M.syncWebhookState()
if webhookToggle and webhookToggle.Set then
webhookToggle:Set(hook.isOn())
end
end
local function say(title, ok, msg)
win.notify(title, tostring(msg), ok and 3 or 4)
end
function M.build(tab)
if not tab then return M end
tab:CreateSection({ name = "Performance" })
fpsToggle = tab:CreateToggle({
name = "Low Graphics",
description = "Reduce rendering load for smoother FPS.",
value = cfg.AUTO_FPS_BOOST == true,
callback = function(on)
on = on and true or false
if not on then fps.userTurnedOff = true end
BX.try("misc.fpsToggle", function() fps.setEnabled(on) end)
end,
})
tab:CreateSection({ name = "Servers" })
tab:CreateButton({
name = "Join Smallest Server",
description = "Hops to the emptiest public server.",
callback = function()
task.spawn(function()
local ok, msg = servers.lowestServer()
say("Servers", ok, msg)
end)
end,
})
tab:CreateButton({
name = "Rejoin Server",
callback = function()
local ok, msg = servers.rejoin()
say("Servers", ok, msg)
end,
})
tab:CreateSection({ name = "Webhooks" })
webhookStatus = tab:CreateText({
name = "Webhook",
text = hook.hasUrl() and ("Sending to " .. hook.redactedUrl())
or "No URL set - paste one below",
})
tab:CreateInput({
name = "Webhook URL",
description = "Webhook. Stored on this device, not in your profile.",
placeholder = "Webhook URL...",
callback = function(value)
local ok, why = hook.setUrl(value)
BX.try("misc.webhookUrlStatus", function()
if not webhookStatus then return end
if ok and hook.hasUrl() then
webhookStatus:Set("Saved - sending to " .. hook.redactedUrl())
elseif ok then
webhookStatus:Set("No URL set - paste one below")
else
webhookStatus:Set(tostring(why))
end
end)
win.notify("Webhook", tostring(why or (ok and "Saved" or "Rejected")), 4)
end,
})
tab:CreateButton({
name = "Send Test Message",
description = "Posts one test payload to the URL above.",
callback = function()
if not hook.hasUrl() then
win.notify("Webhook", "Set a URL first", 4)
return
end
local ok, why = hook.test()
M.syncWebhookState()
win.notify("Webhook", ok and "Test sent" or tostring(why or "Test failed"), 5)
end,
})
webhookToggle = tab:CreateToggle({
name = "Webhook Logging",
description = "Send delivery events to the configured endpoint.",
value = hook.isOn(),
flag = "WebhookOn",
callback = function(on)
BX.try("misc.webhookToggle", function() hook.setEnabled(on) end)
if on and not exec.can.request then
local why = "Webhooks are not supported by this executor (no HTTP request API)"
log.warn("%s", why)
win.notify("Webhook", why, 6)
BX.try("misc.webhookStatus", function()
if webhookStatus then webhookStatus:Set(why) end
end)
end
end,
})
prof.onApply("WebhookOn", function(on)
hook.applyProfileEnabled(on and true or false)
end)
if not exec.can.request then
BX.try("misc.webhookUnsupported", function()
if webhookStatus then
webhookStatus:Set("HTTP request support is unavailable on this executor.")
end
end)
end
log.info("misc tab built")
return M
end
function M.teardown()
webhookStatus, webhookToggle, fpsToggle = nil, nil, nil
BX.try("misc.teardown", function() hook.setEnabled(false, true) end)
log.info("misc tab torn down")
end
return M
end)
BX.module("ui.tabs.config", function(BX)
local prof = BX.require("core.profiles")
local win  = BX.require("ui.shell")
local log  = BX.require("boot.log").for_module("config.tab")
local M = {}
local loadDrop, autoToggle
local NONE = "None"
local function say(ok, msg)
win.notify("Config", tostring(msg), ok and 3 or 4)
end
local function options()
local list = prof.list()
local out = { NONE }
for _, n in ipairs(list) do out[#out + 1] = n end
return out
end
local function refreshLists()
local opts = options()
BX.try("config.refreshLists", function()
if loadDrop and loadDrop.Refresh then loadDrop:Refresh(opts) end
end)
return opts
end
local function pick(v)
local s = type(v) == "table" and v[1] or v
s = tostring(s or "")
if s == NONE then return "" end
return s
end
function M.build(tab)
if not tab then return M end
local autoLoadOn = prof.autoLoadName() ~= nil
tab:CreateSection({ name = "Profiles" })
if not prof.available() then
tab:CreateText({
name = "Profiles",
text = "Saving settings is not supported by this executor. Everything else works.",
})
log.warn("no filesystem (%s) - profile controls not built",
table.concat(BX.require("core.exec").report().missing, ","))
return M
end
local pendingName = ""
tab:CreateInput({
name = "Profile Name",
description = "What to call the next save. Blank saves as Default.",
placeholder = "farm setup",
callback = function(value)
pendingName = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end,
})
tab:CreateButton({
name = "Save Profile",
description = "Store current settings under the name above.",
callback = function()
local name = pendingName ~= "" and pendingName or "Default"
local ok, msg = prof.save(name)
if ok then
refreshLists()
if autoLoadOn then
prof.setAutoLoad(name)
if loadDrop and loadDrop.Set then loadDrop:Set(name) end
end
msg = ("Saved as %q"):format(name)
end
say(ok, msg)
end,
})
tab:CreateButton({
name = "Delete Profile",
description = "Removes the profile selected under Load Profile.",
callback = function()
local name = loadDrop and pick(loadDrop.get and loadDrop:get() or nil) or ""
if name == "" then
say(false, "Pick a profile under Load Profile first")
return
end
local ok, msg = prof.delete(name)
if ok then
refreshLists()
msg = ("Deleted %q"):format(name)
end
say(ok, msg)
end,
})
tab:CreateSection({ name = "Loading" })
loadDrop = tab:CreateDropdown({
name = "Load Profile",
options = options(),
currentOption = prof.autoLoadName() or NONE,
callback = function(v)
local name = pick(v)
if name == "" then return end
local ok, msg = prof.load(name)
if ok and autoLoadOn then
local saved, why = prof.setAutoLoad(name)
if saved then
msg = msg .. " · Auto-load on"
else
msg = tostring(why or msg)
end
end
say(ok, msg)
end,
})
autoToggle = tab:CreateToggle({
name = "Auto Load Profile",
description = "Load the selected profile on start.",
value = autoLoadOn,
callback = function(on)
local selected = loadDrop and loadDrop:get() or ""
local name = pick(selected)
if on and name == "" then
autoLoadOn = false
if autoToggle and autoToggle.Set then autoToggle:Set(false) end
say(false, "Pick a profile first")
return
end
autoLoadOn = on and true or false
local ok, msg = prof.setAutoLoad(autoLoadOn and name or "")
say(ok, msg)
end,
})
tab:CreateButton({
name = "Unload VoidcxzHub",
description = "Close the hub and stop its workers.",
callback = function() win.unload() end,
})
log.info("config tab built (%d profiles)", #prof.list())
return M
end
return M
end)
BX.module("features.movement", function(BX)
local svc = BX.require("core.services")
local ch  = BX.require("core.character")
local dev = BX.require("core.device")
local rs  = BX.require("core.restore")
local log = BX.require("boot.log").for_module("movement")
local RunService, Players = svc.RunService, svc.Players
local M = {}
local K = {
GROUND_OFFSET     = 3,
CRUISE_UP         = 18,    
RAMP_FRAC         = 0.12,  
RAMP_MAX          = 220,
RAMP_MIN          = 40,    
START_SPEED       = 0.45,  
SPEED_RAMP_FRAC   = 0.28,
SLOW_RADIUS       = 50,    
SLOW_SPEED        = 260,
ARRIVE            = 5,
MAX_DT            = 0.05,  
MAX_FRAME         = 0.25,  
MAX_DEBT          = 2.0,   
MAX_STEP          = 20,    
SPEED             = 1200,  
SPEED_NOSPOOF     = 500,   
NOSPOOF_FLOOR     = 300,
NOSPOOF_CONVERGE  = 40,
DROP_SPEED        = 400,
SPOOF_HEADROOM    = 1.35,  
WS_MAX            = 4000,
WALKSPEED_SANE_MIN = 40,
RELOC_CLAMP_FOR   = 6,
RELOC_CLAMP_RATIO = 1.04,
TP_SETTLE         = 0.35,
TP_LANDED         = 30,
QUICK_CLIMB       = 25,
THROWN_BACK       = 50,
}
M.K = K
local ac = nil
function M.setAnticheat(adapter) ac = adapter end
local function acGet(name)
local f = ac and ac[name]
return type(f) == "function" and f or nil
end
local groundParams = RaycastParams.new()
groundParams.FilterType = Enum.RaycastFilterType.Exclude
groundParams.IgnoreWater = true
local filterDirty = true
local scratchIgnore = {}   
local function rebuildFilter()
local n = 0
for i = #scratchIgnore, 1, -1 do scratchIgnore[i] = nil end
for _, pl in ipairs(Players:GetPlayers()) do
if pl.Character then
n = n + 1
scratchIgnore[n] = pl.Character
end
end
groundParams.FilterDescendantsInstances = scratchIgnore
filterDirty = false
end
local function solidGroundY(pos)
if filterDirty then rebuildFilter() end
local origin = pos + Vector3.new(0, 80, 0)
local dir = Vector3.new(0, -700, 0)
local extra = nil
for _ = 1, 15 do
local r = workspace:Raycast(origin, dir, groundParams)
if not r then break end
if r.Instance.CanCollide then
if extra then groundParams.FilterDescendantsInstances = scratchIgnore end
return r.Position.Y + K.GROUND_OFFSET
end
extra = extra or table.clone(scratchIgnore)
extra[#extra + 1] = r.Instance
groundParams.FilterDescendantsInstances = extra
end
if extra then groundParams.FilterDescendantsInstances = scratchIgnore end
return nil
end
local function groundOr(pos, fallback)
return solidGroundY(pos) or fallback
end
M.groundY = solidGroundY
local TRAP = {
REFRESH     = 1.0,   
FULL_RADIUS = 16,    
LIFT_RADIUS = 34,    
CLEAR       = 9,     
FEET        = 3,     
}
M.TRAP = TRAP
local trapTops, trapScanAt = {}, -math.huge
local function scanTraps()
local now = os.clock()
if (now - trapScanAt) < TRAP.REFRESH then return trapTops end
trapScanAt = now
for i = #trapTops, 1, -1 do trapTops[i] = nil end
local deb = workspace:FindFirstChild("__DEBRIS")
if not deb then return trapTops end
local me = Players.LocalPlayer and Players.LocalPlayer.Name
for _, c in ipairs(deb:GetChildren()) do
if c.Name == "PlayerTrap" and c:GetAttribute("Owner") ~= me then
local hb = c:FindFirstChild("Hitbox") or c
if hb:IsA("BasePart") then
trapTops[#trapTops + 1] = hb.Position + Vector3.new(0, hb.Size.Y / 2, 0)
end
end
end
return trapTops
end
M.traps = scanTraps
local function trapFloor(x, z, list)
local need = nil
for i = 1, #list do
local top = list[i]
local dx, dz = x - top.X, z - top.Z
local d = math.sqrt(dx * dx + dz * dz)
if d < TRAP.LIFT_RADIUS then
local k = (d <= TRAP.FULL_RADIUS) and 1
or (TRAP.LIFT_RADIUS - d) / (TRAP.LIFT_RADIUS - TRAP.FULL_RADIUS)
local y = top.Y + TRAP.FEET + TRAP.CLEAR * k
if not need or y > need then need = y end
end
end
return need
end
local noclipSc, noclipWas, noclipParts, noclipFor = nil, nil, nil, nil
local function noclipStep()
local char = ch.get()
if not char then return end
if noclipFor ~= char or not noclipParts then
noclipParts, noclipFor, noclipWas = {}, char, {}
for _, p in ipairs(char:GetDescendants()) do
if p:IsA("BasePart") then
noclipParts[#noclipParts + 1] = p
noclipWas[p] = p.CanCollide
end
end
end
for i = 1, #noclipParts do
local p = noclipParts[i]
if p.Parent and p.CanCollide then p.CanCollide = false end
end
end
function M.noclip(on)
if on then
if noclipSc then return end
rs.onRestore("movement.noclip", function() M.noclip(false) end)
noclipSc = BX.scope("features.movement.noclip")
noclipSc:onFrame("noclip", RunService.Stepped, noclipStep)
else
if not noclipSc then return end
noclipSc:destroy()
noclipSc = nil
if noclipWas then
for part, was in pairs(noclipWas) do
if part.Parent then pcall(function() part.CanCollide = was end) end
end
end
noclipParts, noclipWas, noclipFor = nil, nil, nil
end
end
local brk = { low = nil, high = nil, speed = nil, legSpeed = nil, legRelocs = nil }
function M.outboundSpeed()
return K.SPEED
end
function M.carrySpeedCap()
if not acGet("relocateCount") then return K.SPEED_NOSPOOF end
return brk.speed or K.SPEED_NOSPOOF
end
local function bracketAfterLeg()
local count = acGet("relocateCount")
if not count or not brk.legSpeed then return end
local used = brk.legSpeed
local hadRelocs = count() > (brk.legRelocs or 0)
if hadRelocs then
brk.high = used                                   
else
brk.low = math.max(brk.low or K.SPEED_NOSPOOF, used)
end
local low = brk.low or K.SPEED_NOSPOOF
local nextSpeed
if brk.high then
if (brk.high - low) <= K.NOSPOOF_CONVERGE then
nextSpeed = low                               
else
nextSpeed = math.floor((low + brk.high) / 2)
end
else
nextSpeed = math.min(K.SPEED, low * 2)
end
nextSpeed = math.clamp(nextSpeed, K.NOSPOOF_FLOOR, K.SPEED)
if nextSpeed ~= (brk.speed or K.SPEED_NOSPOOF) then
log.info("travel: %s at %d - next leg %d studs/s (bracket %d..%s)",
hadRelocs and "relocated" or "clean", used, nextSpeed,
low, tostring(brk.high or "-"))
end
brk.speed = nextSpeed
brk.legSpeed = nil
end
local stats = { legs = 0, cancelled = 0, respawned = 0, timedOut = 0, arrived = 0,
teleports = 0, tpLanded = 0, tpRefused = 0 }
function M.stats() return table.clone(stats) end
function M.teleport(pos, tag)
local char, hrp = ch.get(), ch.root()
if not char or not hrp then return false, math.huge end
local gy = solidGroundY(pos)
local dest = Vector3.new(pos.X, gy or pos.Y, pos.Z)
local from = hrp.Position
local ok = pcall(function() char:PivotTo(CFrame.new(dest)) end)
if ok then
hrp.AssemblyLinearVelocity = Vector3.zero
hrp.AssemblyAngularVelocity = Vector3.zero
end
task.wait(dev.scale(K.TP_SETTLE))
local h2 = ch.root()
local gap = h2 and (h2.Position - dest).Magnitude or math.huge
local landed = gap <= K.TP_LANDED
stats.teleports = stats.teleports + 1
if landed then
stats.tpLanded = stats.tpLanded + 1
else
stats.tpRefused = stats.tpRefused + 1
end
log.info("tp %s: %.0f studs -> %s (%.0f off, tier=%s)",
tostring(tag), (dest - from).Magnitude,
landed and "landed" or "REFUSED", gap, dev.tier)
return landed, gap
end
local function writeStep(char, hum, hrp, dest, look)
if hum then hum:Move(Vector3.zero, false) end
char:PivotTo(CFrame.lookAt(dest, dest + look))
hrp.AssemblyLinearVelocity = Vector3.zero
hrp.AssemblyAngularVelocity = Vector3.zero
end
function M.travel(opts)
local pos      = opts.to
local tag      = opts.tag or "leg"
local arrive   = opts.arrive or K.ARRIVE
local carrying = opts.carrying and true or false
local cancel   = opts.cancel
local quick    = opts.quickLift and true or false
local replan   = opts.replan and true or false
local char = ch.get()
local hrp  = ch.root()
local hum  = ch.humanoid()
if not char or not hrp then
log.warn("%s: no character to move", tag)
return false, { reason = "no-character" }
end
local speed = math.max(opts.speed or K.SPEED_NOSPOOF, 40)
local start = hrp.Position
local flatTotal = Vector3.new(pos.X - start.X, 0, pos.Z - start.Z).Magnitude
if flatTotal < 1 then return true, { reason = "already-there", distance = 0 } end
local startGround = groundOr(start, start.Y)
local endGround   = groundOr(pos, pos.Y)
local landY   = endGround
local cruiseY = math.max(startGround, endGround, start.Y, pos.Y) + K.CRUISE_UP
local ramp = math.clamp(flatTotal * K.RAMP_FRAC, K.RAMP_MIN, K.RAMP_MAX)
if ramp * 2 > flatTotal * 0.9 then ramp = flatTotal * 0.45 end
if flatTotal < K.RAMP_MIN * 2 and not quick then cruiseY = math.max(start.Y, pos.Y) end
local climb = quick and math.min(ramp, K.QUICK_CLIMB) or ramp
local wasPS = hum and hum.PlatformStand or false
if hum then
rs.remember("movement.platformStand",
function() return hum.PlatformStand end,
function(v) hum.PlatformStand = v end)
hum.PlatformStand = true
end
local push, spoofFn = acGet("push"), acGet("spoof")
local spoof = (not carrying) and hum and true or false
local claimWS, savedWS = nil, nil
if spoof then
rs.remember("movement.walkSpeed",
function() return hum.WalkSpeed end,
function(v) hum.WalkSpeed = v end)
savedWS = hum.WalkSpeed
claimWS = math.clamp(speed * K.SPOOF_HEADROOM, 16, K.WS_MAX)
hum.WalkSpeed = claimWS
end
if not carrying and not spoof then
brk.legSpeed = speed
local count = acGet("relocateCount")
brk.legRelocs = count and count() or 0
end
local legAt = os.clock()
local t0 = legAt
local deadline = t0 + math.max(flatTotal / speed, 0.3) * 3 + 6
local lastT = t0
local arcDebt = 0
local ok, reason = false, "timeout"
local frames, subStepTotal, maxFrameSeen = 0, 0, 0
local trapDodges = 0
local prevRem = flatTotal
log.trace("%s: begin %.0f studs at %.0f studs/s (carrying=%s spoof=%s tier=%s)",
tag, flatTotal, speed, tostring(carrying), tostring(spoof), dev.tier)
while os.clock() < deadline do
if cancel and cancel() then reason = "cancelled" break end
local liveChar = ch.get()
if liveChar ~= char then
reason = "respawned"
break
end
local hh = ch.root()
if not hh then reason = "lost-root" break end
local now = os.clock()
local raw = now - lastT
lastT = now
arcDebt = math.min(arcDebt + raw, K.MAX_DEBT)
local frameDt = math.min(arcDebt, K.MAX_FRAME)
arcDebt = arcDebt - frameDt
if raw > maxFrameSeen then maxFrameSeen = raw end
local subSteps = math.max(1, math.ceil(frameDt / K.MAX_DT))
local dt = frameDt / subSteps
frames = frames + 1
subStepTotal = subStepTotal + subSteps
local flat = Vector3.new(pos.X - hh.Position.X, 0, pos.Z - hh.Position.Z)
local rem = flat.Magnitude
if rem <= arrive then ok, reason = true, "arrived" break end
if replan and rem > prevRem + K.THROWN_BACK then
log.info("%s: thrown back %.0f studs - handing back to replan", tag, rem - prevRem)
reason = "relocated"
break
end
prevRem = rem
local done = math.max(flatTotal - rem, 0)
local want
local speedRamp = math.max(ramp * K.SPEED_RAMP_FRAC, 1)
if rem <= K.SLOW_RADIUS then
want = math.min(K.SLOW_SPEED, speed)
elseif rem < ramp then
local f = rem / ramp
want = math.max(speed * f, math.min(K.SLOW_SPEED, speed))
elseif done < speedRamp and not quick then
want = speed * (K.START_SPEED + (1 - K.START_SPEED) * (done / speedRamp))
else
want = speed
end
local lastReloc = acGet("lastRelocateAt")
local relocAt = lastReloc and lastReloc() or nil
if relocAt and (not carrying or relocAt >= legAt)
and (os.clock() - relocAt) < K.RELOC_CLAMP_FOR then
local allowFn = acGet("allowance")
local allow = allowFn and allowFn() or nil
if not allow and hum and hum.WalkSpeed > K.WALKSPEED_SANE_MIN then
allow = hum.WalkSpeed * K.RELOC_CLAMP_RATIO
end
if allow and allow > 0 and want > allow then
want = allow
end
end
local wantY
if done < climb then
wantY = start.Y + (cruiseY - start.Y) * (done / climb)
elseif rem < ramp then
wantY = landY + (cruiseY - landY) * (rem / ramp)
else
wantY = cruiseY
end
local trapList = scanTraps()
local arrived = false
for _ = 1, subSteps do
local hp = hh.Position
local f2 = Vector3.new(pos.X - hp.X, 0, pos.Z - hp.Z)
local rem2 = f2.Magnitude
if rem2 <= arrive then arrived = true break end
local step = math.min(rem2, want * dt, K.MAX_STEP)
local unit = f2.Unit
local nxt = hp + unit * step
local y = wantY
if #trapList > 0 then
local floor = trapFloor(nxt.X, nxt.Z, trapList)
if floor and floor > y then
y = floor
trapDodges = trapDodges + 1
end
end
pcall(writeStep, char, hum, hh,
Vector3.new(nxt.X, y, nxt.Z), unit)
end
if arrived then ok, reason = true, "arrived" break end
if spoof then
if hum.WalkSpeed < claimWS - 1 then hum.WalkSpeed = claimWS end
if push or spoofFn then
local told = flat.Unit * math.min(want, claimWS)
if push then push(hh, hum, told) else spoofFn(claimWS, told) end
end
pcall(function() hh.AssemblyLinearVelocity = Vector3.zero end)
end
RunService.Heartbeat:Wait()
end
local hz = ch.root()
local liveChar = ch.get()
if hz and liveChar == char then
local gy = solidGroundY(hz.Position)
if gy and math.abs(hz.Position.Y - gy) > 1 then
pcall(function() char:PivotTo(CFrame.new(hz.Position.X, gy, hz.Position.Z)) end)
end
end
if spoof and hum and hum.Parent then
local legalFn = acGet("legalWalkSpeed")
local legal = legalFn and legalFn() or savedWS or 16
pcall(function() hum.WalkSpeed = math.max(legal, 16) end)
end
if hum and hum.Parent then
hum.PlatformStand = wasPS
local hstate = hum:GetState()
if hstate == Enum.HumanoidStateType.Freefall
or hstate == Enum.HumanoidStateType.PlatformStanding
or hstate == Enum.HumanoidStateType.Physics then
pcall(function() hum:ChangeState(Enum.HumanoidStateType.Landed) end)
end
end
if hz then
hz.AssemblyLinearVelocity = Vector3.zero
hz.AssemblyAngularVelocity = Vector3.zero
end
if not carrying and not spoof then bracketAfterLeg() end
local gap = hz and Vector3.new(pos.X - hz.Position.X, 0, pos.Z - hz.Position.Z).Magnitude
or math.huge
local elapsed = os.clock() - t0
local settled = ok or gap <= arrive + 4
stats.legs = stats.legs + 1
stats[settled and "arrived" or (reason == "cancelled" and "cancelled")
or (reason == "respawned" and "respawned") or "timedOut"] =
(stats[settled and "arrived" or (reason == "cancelled" and "cancelled")
or (reason == "respawned" and "respawned") or "timedOut"] or 0) + 1
local level = settled and log.trace or log.warn
level("%s: %s %.0f studs in %.2fs (want %.0f/s, %.0f/s actual, %.1f short) "
.. "reason=%s frames=%d sub=%.1f worstFrame=%.0fms tier=%s",
tag, settled and "ok" or "FAILED", flatTotal, elapsed, speed,
flatTotal / math.max(elapsed, 0.001), gap, reason, frames,
frames > 0 and (subStepTotal / frames) or 0,
maxFrameSeen * 1000, dev.tier)
if trapDodges > 0 then
stats.trapDodges = (stats.trapDodges or 0) + 1
log.info("%s: lifted over player traps (%d writes)", tag, trapDodges)
end
return settled, {
reason = reason, distance = flatTotal, elapsed = elapsed,
gap = gap, frames = frames, worstFrameMs = maxFrameSeen * 1000,
trapDodges = trapDodges,
}
end
function M.descend(tag)
tag = tag or "land"
local char, h = ch.get(), ch.root()
if not char or not h then return false end
local hum = ch.humanoid()
local gy = solidGroundY(h.Position)
if not gy then
if hum then hum.PlatformStand = false end
log.trace("%s: no ground below - falling", tag)
return false
end
local x, z = h.Position.X, h.Position.Z
local from = h.Position.Y
if from - gy <= 2 then
if hum then hum.PlatformStand = false end
return true
end
if hum then hum.PlatformStand = true end
local t0 = os.clock()
local dur = math.clamp((from - gy) / math.max(K.DROP_SPEED, 50), 0.05, 1.2)
while os.clock() - t0 < dur do
if ch.get() ~= char then break end
local hh = ch.root()
if not hh then break end
local f = (os.clock() - t0) / dur
local y = from + (gy - from) * f
pcall(function()
char:PivotTo(CFrame.new(x, y, z) * (hh.CFrame - hh.CFrame.Position))
hh.AssemblyLinearVelocity = Vector3.zero
end)
RunService.Heartbeat:Wait()
end
if ch.get() == char then
pcall(function() char:PivotTo(CFrame.new(x, gy, z)) end)
end
if hum and hum.Parent then
hum.PlatformStand = false
pcall(function() hum:ChangeState(Enum.HumanoidStateType.Landed) end)
end
log.trace("%s: descended %.0f studs to ground", tag, from - gy)
return true
end
local sc = BX.scope("features.movement")
sc:connect(Players.PlayerAdded, function() filterDirty = true end)
sc:connect(Players.PlayerRemoving, function() filterDirty = true end)
ch.onSpawn(sc, "movement.respawn", function()
filterDirty = true
noclipParts, noclipWas, noclipFor = nil, nil, nil
end)
function M.reset()
M.noclip(false)
end
return M
end)
BX.module("features.humanoid", function(BX)
local svc = BX.require("core.services")
local ch  = BX.require("core.character")
local rs  = BX.require("core.restore")
local log = BX.require("boot.log").for_module("humanoid")
local M = {}
local SWAP_ATTR = "VoidcxzStealHum"
M.SWAP_ATTR = SWAP_ATTR
local sc = nil
local swapPrior = nil
local stats = { swaps = 0, alreadySwapped = 0, failures = 0 }
function M.stats() return table.clone(stats) end
function M.isSwapped()
local hum = ch.humanoid()
return hum ~= nil and hum:GetAttribute(SWAP_ATTR) == true
end
local function applyStates(prior)
local hum = ch.humanoid()
if not hum or hum:GetAttribute(SWAP_ATTR) ~= true then return end
hum:SetStateEnabled(Enum.HumanoidStateType.Dead, prior.dead)
hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, prior.fallingDown)
hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, prior.ragdoll)
hum.BreakJointsOnDeath = prior.breakJoints
end
local function rememberStates(prior)
rs.remember("humanoid.states",
function() return prior end,
function(v) applyStates(v) end)
end
function M.swap(char)
char = char or ch.get()
if not char then return false end
local hum = char:FindFirstChildOfClass("Humanoid")
if not hum then return false end
if hum:GetAttribute(SWAP_ATTR) == true then
stats.alreadySwapped = stats.alreadySwapped + 1
if not swapPrior then
local d = hum:GetAttribute("VoidcxzPriorDead")
if d ~= nil then
swapPrior = {
dead        = d,
fallingDown = hum:GetAttribute("VoidcxzPriorFallingDown") ~= false,
ragdoll     = hum:GetAttribute("VoidcxzPriorRagdoll") ~= false,
breakJoints = hum:GetAttribute("VoidcxzPriorBreakJoints") == true,
}
rememberStates(swapPrior)
end
end
BX.try("humanoid.reapply", function()
hum.BreakJointsOnDeath = false
hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
end)
return true
end
local prior = {
dead        = hum:GetStateEnabled(Enum.HumanoidStateType.Dead),
fallingDown = hum:GetStateEnabled(Enum.HumanoidStateType.FallingDown),
ragdoll     = hum:GetStateEnabled(Enum.HumanoidStateType.Ragdoll),
breakJoints = hum.BreakJointsOnDeath,
}
local ok = BX.try("humanoid.swap", function()
local healthScript = char:FindFirstChild("Health")
if healthScript then healthScript:Destroy() end
hum.BreakJointsOnDeath = false
hum.Archivable = true
local clone = hum:Clone()
if not clone then error("clone failed") end
clone.Name = "Humanoid"
clone:SetAttribute(SWAP_ATTR, true)
clone:SetAttribute("VoidcxzPriorDead", prior.dead)
clone:SetAttribute("VoidcxzPriorFallingDown", prior.fallingDown)
clone:SetAttribute("VoidcxzPriorRagdoll", prior.ragdoll)
clone:SetAttribute("VoidcxzPriorBreakJoints", prior.breakJoints)
clone:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
clone:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
clone:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
clone.Health = hum.MaxHealth
if not clone:FindFirstChildOfClass("Animator") then
Instance.new("Animator").Parent = clone
end
hum:Destroy()
clone.Parent = char
if workspace.CurrentCamera then
workspace.CurrentCamera.CameraSubject = clone
end
local animate = char:FindFirstChild("Animate")
if animate then
local ac = animate:Clone()
animate:Destroy()
ac.Parent = char
ac.Disabled = false
end
for _, d in ipairs(char:GetDescendants()) do
if d:IsA("Motor6D") then d.Enabled = true end
end
end)
if ok then
rs.permanent("humanoid.swap",
"Humanoid replaced and Health script destroyed - undone by respawn")
swapPrior = prior
rememberStates(prior)
stats.swaps = stats.swaps + 1
log.info("swapped (anticheat now holds a destroyed Humanoid)")
else
stats.failures = stats.failures + 1
log.error("swap FAILED - teleports will be punished")
end
return ok and true or false
end
function M.isArmed() return sc ~= nil end
function M.arm()
if sc then return true end
sc = BX.scope("features.humanoid")
M.swap()
ch.onSpawn(sc, "humanoid.reswap", function(char)
swapPrior = nil
M.swap(char)
end)
return true
end
function M.disarm()
if not swapPrior then
local hum = ch.humanoid()
if hum and hum:GetAttribute(SWAP_ATTR) == true then
local d = hum:GetAttribute("VoidcxzPriorDead")
swapPrior = {
dead        = (d == nil) and true or d,
fallingDown = hum:GetAttribute("VoidcxzPriorFallingDown") ~= false,
ragdoll     = hum:GetAttribute("VoidcxzPriorRagdoll") ~= false,
breakJoints = hum:GetAttribute("VoidcxzPriorBreakJoints") == true,
}
end
end
if swapPrior then
BX.try("humanoid.restoreStates", function()
applyStates(swapPrior)
log.info("death states restored (dead=%s fallingDown=%s "
.. "ragdoll=%s breakJoints=%s) - the character can respawn "
.. "normally again",
tostring(swapPrior.dead), tostring(swapPrior.fallingDown),
tostring(swapPrior.ragdoll), tostring(swapPrior.breakJoints))
end)
end
if not sc then return end
sc:destroy()
sc = nil
log.info("disarmed (%d swaps this session)", stats.swaps)
end
return M
end)
BX.module("features.jump", function(BX)
local svc  = BX.require("core.services")
local ch   = BX.require("core.character")
local st   = BX.require("core.state")
local hsw  = BX.require("features.humanoid")
local log  = BX.require("boot.log").for_module("jump")
local M = {}
local sc = nil
local stats = { requests = 0, applied = 0, duringRun = 0, unswapped = 0, busy = 0 }
function M.stats() return table.clone(stats) end
function M.isArmed() return sc ~= nil end
function M.arm()
if sc then return true end
sc = BX.scope("features.jump")
sc:connect(svc.UserInputService.JumpRequest, function()
stats.requests = stats.requests + 1
if st.autoStealBusy then
stats.duringRun = stats.duringRun + 1
return
end
local hum = ch.humanoid()
if not hum then return end
if hum:GetAttribute(hsw.SWAP_ATTR) ~= true then
stats.unswapped = stats.unswapped + 1
return
end
if hum.Health <= 0 or hum.PlatformStand or hum.Sit then return end
local state = hum:GetState()
if state == Enum.HumanoidStateType.Jumping
or state == Enum.HumanoidStateType.Freefall then
stats.busy = stats.busy + 1
return
end
hum.Jump = true
stats.applied = stats.applied + 1
end)
log.info("armed - the player's jump reaches the live humanoid")
return true
end
function M.disarm()
if not sc then return end
sc:destroy()
sc = nil
log.info("disarmed (%d requests, %d applied)", stats.requests, stats.applied)
end
return M
end)
BX.module("features.antideath", function(BX)
local ch  = BX.require("core.character")
local svc = BX.require("core.services")
local rs  = BX.require("core.restore")
local log = BX.require("boot.log").for_module("antideath")
local M = {}
local sc = nil
local saved = nil        
local armedFor = nil     
local stats = { arms = 0, deathsBlocked = 0, restores = 0 }
function M.stats() return table.clone(stats) end
local function applyTo(char)
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not hum then return false end
if armedFor == hum then return true end
saved = {
humanoid = hum,
breakJoints = hum.BreakJointsOnDeath,
deadEnabled = hum:GetStateEnabled(Enum.HumanoidStateType.Dead),
}
armedFor = hum
BX.try("antideath.apply", function()
rs.remember("antideath.breakJoints",
function() return hum.BreakJointsOnDeath end,
function(v) hum.BreakJointsOnDeath = v end)
rs.remember("antideath.state.Dead",
function() return hum:GetStateEnabled(Enum.HumanoidStateType.Dead) end,
function(v) hum:SetStateEnabled(Enum.HumanoidStateType.Dead, v) end)
hum.BreakJointsOnDeath = false
hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
end)
sc:connect(hum.HealthChanged, function(hp)
if hp <= 0 and hum.Parent then
stats.deathsBlocked = stats.deathsBlocked + 1
hum.Health = hum.MaxHealth
end
end)
sc:connect(hum.StateChanged, function(_, new)
if new == Enum.HumanoidStateType.Dead and hum.Parent then
stats.deathsBlocked = stats.deathsBlocked + 1
hum:ChangeState(Enum.HumanoidStateType.GettingUp)
hum.Health = hum.MaxHealth
end
end)
if hum.Health <= 0 then
stats.deathsBlocked = stats.deathsBlocked + 1
log.warn("armed on a humanoid already at 0 health - reviving it")
hum.Health = hum.MaxHealth
end
stats.arms = stats.arms + 1
log.trace("armed on humanoid (health %.0f/%.0f)", hum.Health, hum.MaxHealth)
return true
end
local function restore()
local s = saved
saved, armedFor = nil, nil
if not s or not s.humanoid or not s.humanoid.Parent then return end
stats.restores = stats.restores + 1
BX.try("antideath.restore", function()
s.humanoid.BreakJointsOnDeath = s.breakJoints
s.humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, s.deadEnabled)
end)
end
function M.isArmed() return sc ~= nil end
function M.arm()
if sc then return true end
sc = BX.scope("features.antideath")
local ok = applyTo(ch.get())
ch.onSpawn(sc, "antideath.rearm", function(char)
saved, armedFor = nil, nil
applyTo(char)
end)
log.info("armed (%s)", ok and "ok" or "no humanoid yet")
return true
end
function M.disarm()
if not sc then return end
sc:destroy()
sc = nil
BX.try("antideath.reviveOnDisarm", function()
local hum = ch.humanoid()
if hum and hum.Parent and hum.Health <= 0 then
log.warn("disarming on 0 health - reviving before restoring states")
hum.Health = hum.MaxHealth
end
end)
restore()
log.info("disarmed (blocked %d deaths this session)", stats.deathsBlocked)
end
return M
end)
BX.module("features.guard", function(BX)
local svc = BX.require("core.services")
local data = BX.require("core.data")
local ch  = BX.require("core.character")
local rs  = BX.require("core.restore")
local log = BX.require("boot.log").for_module("guard")
local RunService = svc.RunService
local M = {}
local K = {
RISE      = 150,   
FLAT_MULT = 2.5,   
FLAT_MIN  = 150,   
JOINT_GAP = 0.25,  
HOLD_MAX  = 2.75,  
HOLD_GRACE = 0.08, 
}
M.K = K
local sc = nil
local stats = { launchesCancelled = 0, standUps = 0, dropsRefused = 0 }
function M.stats() return table.clone(stats) end
function M.isRagdolled()
local hum = ch.humanoid()
if not hum then return false end
if hum.PlatformStand then return true end
local s = hum:GetState()
return s == Enum.HumanoidStateType.Physics
or s == Enum.HumanoidStateType.Ragdoll
or s == Enum.HumanoidStateType.FallingDown
end
function M.waitForRecovery(seconds)
local deadline = os.clock() + (seconds or 4)
while os.clock() < deadline do
if not M.isRagdolled() then return true end
RunService.Heartbeat:Wait()
end
return false
end
local function applyAntiRagdoll(char)
char = char or ch.get()
local hum = char and char:FindFirstChildOfClass("Humanoid")
if not hum then return false end
BX.try("guard.antiRagdoll", function()
rs.remember("guard.state.Ragdoll",
function() return hum:GetStateEnabled(Enum.HumanoidStateType.Ragdoll) end,
function(v) hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, v) end)
rs.remember("guard.state.FallingDown",
function() return hum:GetStateEnabled(Enum.HumanoidStateType.FallingDown) end,
function(v) hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, v) end)
hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
for _, d in ipairs(char:GetDescendants()) do
if d:IsA("Motor6D") then d.Enabled = true end
end
end)
return true
end
local dropOriginal, dropInstalled, eggStateRef = nil, false, nil
local dropAllowed = false
local function installDropBlock()
if dropInstalled then return true end
eggStateRef = eggStateRef or data.eggState()
if not eggStateRef or type(eggStateRef.DropFieldEgg) ~= "function" then
log.warn("cannot block egg drops - EggState.DropFieldEgg missing")
return false
end
dropOriginal = eggStateRef.DropFieldEgg
eggStateRef.DropFieldEgg = function(reason, ...)
if not dropAllowed then
stats.dropsRefused = stats.dropsRefused + 1
log.trace("drop refused: %s", tostring(reason))
return
end
return dropOriginal(reason, ...)
end
dropInstalled = true
log.info("egg-drop block installed")
return true
end
local function removeDropBlock()
if not dropInstalled then return end
BX.try("guard.restoreDrop", function()
if eggStateRef and dropOriginal then
eggStateRef.DropFieldEgg = dropOriginal
end
end)
dropInstalled, dropOriginal = false, nil
end
function M.allowDrops(on) dropAllowed = on and true or false end
local blocked, ups, jointAt = 0, 0, 0
local function antiHitStep()
local hum, hrp = ch.humanoid(), ch.root()
if not hum or not hrp then return end
local st = hum:GetState()
if st == Enum.HumanoidStateType.Jumping then return end
local v = hrp.AssemblyLinearVelocity
local flat = (v * Vector3.new(1, 0, 1)).Magnitude
local flatCap = math.max((hum.WalkSpeed or 16) * K.FLAT_MULT, K.FLAT_MIN)
if v.Y > K.RISE or flat > flatCap then
local keep = Vector3.zero
if flat > 0.001 then
keep = (v * Vector3.new(1, 0, 1)).Unit * math.min(flat, hum.WalkSpeed or 16)
end
hrp.AssemblyLinearVelocity = Vector3.new(keep.X, math.min(v.Y, 0), keep.Z)
hrp.AssemblyAngularVelocity = Vector3.zero
blocked = blocked + 1
stats.launchesCancelled = blocked
end
if hum.PlatformStand or hum.Sit
or st == Enum.HumanoidStateType.Physics
or st == Enum.HumanoidStateType.Ragdoll
or st == Enum.HumanoidStateType.FallingDown
or st == Enum.HumanoidStateType.PlatformStanding then
pcall(function()
hum.PlatformStand = false
hum.Sit = false
hum:ChangeState(Enum.HumanoidStateType.GettingUp)
end)
ups = ups + 1
stats.standUps = ups
local now = os.clock()
if now - jointAt > K.JOINT_GAP then
jointAt = now
local char = ch.get()
if char then
for _, d in ipairs(char:GetDescendants()) do
if d:IsA("Motor6D") and not d.Enabled then d.Enabled = true end
end
end
end
end
end
function M.ragdollRemaining()
local left = 0
BX.try("guard.ragdollRemaining", function()
local plr = svc.LocalPlayer
local t = plr and plr:GetAttribute("RagdollEndTime")
if type(t) == "number" then
left = math.max(left, t - workspace:GetServerTimeNow())
end
end)
return math.max(0, left)
end
function M.waitForServerRelease(cancel, lead)
lead = lead or 0
local held = M.ragdollRemaining()
if held <= lead then return 0, held end
local t0 = os.clock()
local deadline = os.clock() + math.min(held - lead, K.HOLD_MAX)
while os.clock() < deadline do
if cancel and cancel() then break end
task.wait(0.03)
if M.ragdollRemaining() <= lead then break end
end
if lead <= 0 then task.wait(K.HOLD_GRACE) end
local waited = os.clock() - t0
log.info("server knockdown %.2fs - waited %.2fs (lead %.2fs)", held, waited, lead)
return waited, held
end
function M.isArmed() return sc ~= nil end
function M.arm()
if sc then return true end
sc = BX.scope("features.guard")
blocked, ups, jointAt = 0, 0, 0
dropAllowed = false
applyAntiRagdoll()
installDropBlock()
sc:onFrame("antihit", RunService.Heartbeat, antiHitStep)
ch.onSpawn(sc, "guard.respawn", function(char)
applyAntiRagdoll(char)
end)
log.info("armed (anti-hit + anti-ragdoll + drop block)")
return true
end
function M.disarm()
if not sc then return end
sc:destroy()
sc = nil
dropAllowed = true
removeDropBlock()
log.info("disarmed (%d launches cancelled, %d stand-ups, %d drops refused)",
stats.launchesCancelled, stats.standUps, stats.dropsRefused)
end
return M
end)
BX.module("features.guardwatch", function(BX)
local plot = BX.require("features.plot")
local log  = BX.require("boot.log").for_module("guardwatch")
local M = {}
local K = {
BEHIND_OK = 60,
}
M.K = K
local AT_HOME = { Sleeping = true, Waking = true }
local stats = { checks = 0, blocked = 0 }
function M.stats() return table.clone(stats) end
local function guardOf(areaId)
local g
pcall(function() g = workspace.__OBJECTS.Areas.GuardAreas[areaId].Guard end)
return g
end
local function rootOf(g)
local r = g and (g:FindFirstChild("HumanoidRootPart") or g.PrimaryPart)
return (r and r:IsA("BasePart")) and r or nil
end
function M.blocking(areaId, nestPos)
stats.checks = stats.checks + 1
if not areaId or typeof(nestPos) ~= "Vector3" then return nil end
local g = guardOf(areaId)
local root = rootOf(g)
if not root then return nil end
local state = tostring(g:GetAttribute("GuardState") or "")
if AT_HOME[state] then return nil end
local home = plot.safeZone()
if typeof(home) ~= "Vector3" then return nil end
local route = (home - nestPos) * Vector3.new(1, 0, 1)
if route.Magnitude < 1 then return nil end
local rel = (root.Position - nestPos) * Vector3.new(1, 0, 1)
local along = rel:Dot(route.Unit)
if along < -K.BEHIND_OK then return nil end
stats.blocked = stats.blocked + 1
return ("%s guard is %s %d studs up the route"):format(
tostring(areaId), state:lower(), math.floor(math.max(along, 0)))
end
function M.blockedAreas()
local out = {}
local areas
pcall(function() areas = workspace.__OBJECTS.Areas.GuardAreas:GetChildren() end)
for _, a in ipairs(areas or {}) do
local g = a:FindFirstChild("Guard")
local bounds = a:FindFirstChild("Bounds")
local state = g and tostring(g:GetAttribute("GuardState") or "")
if g and bounds and bounds:IsA("BasePart") and not AT_HOME[state] then
local why = M.blocking(a.Name, bounds.Position)
if why then out[a.Name] = why end
end
end
return out
end
return M
end)
BX.module("features.treadmill", function(BX)
local svc = BX.require("core.services")
local data = BX.require("core.data")
local ch  = BX.require("core.character")
local dev = BX.require("core.device")
local net = BX.require("core.net")
local st  = BX.require("core.state")
local log = BX.require("boot.log").for_module("treadmill")
local M = {}
local K = {
PAD       = 6,     
Y_SLACK   = 12,
POLL      = 1.5,
AFTER_OFF = 2.0,   
PART_TTL  = 30,    
}
M.K = K
local PlotState = data.plotState()
local netCall = net.call
M.netCall = netCall
local partCache, partAt = nil, 0
local function treadmillPart()
local now = os.clock()
if partCache and partCache.Parent then return partCache end
if not partCache and partAt > 0 and (now - partAt) < K.PART_TTL then
return nil
end
local found = nil
BX.try("treadmill.resolvePart", function()
local plot = PlotState and PlotState.ResolvePlot and PlotState.ResolvePlot()
if type(plot) ~= "table" or not plot.PlotFolder then return end
local p = plot.PlotFolder:FindFirstChild("TreadmillBottom", true)
if p and p:IsA("BasePart") then found = p end
end)
partCache, partAt = found, now
return found
end
function M.onBelt()
local part = treadmillPart()
local hrp = ch.root()
if not part or not hrp then return false end
local rel = part.CFrame:PointToObjectSpace(hrp.Position)
local half = part.Size * 0.5
return math.abs(rel.X) <= half.X + K.PAD
and math.abs(rel.Z) <= half.Z + K.PAD
and math.abs(rel.Y) <= K.Y_SLACK
end
local enabled = true
local sc = nil
local stats = { checks = 0, caught = 0, doffed = 0, refused = 0, yielded = 0, notWorn = 0 }
function M.worn()
local hrp = ch.root()
if hrp and hrp.Anchored then return true end
local char = hrp and hrp.Parent
local hp = char and char:FindFirstChild("Headphones")
return hp ~= nil and hp:IsA("Accessory")
end
function M.stats() return table.clone(stats) end
function M.isOn() return enabled end
local function step()
if not enabled then return end
if st.stayOnTreadmill then
stats.yielded = stats.yielded + 1
return
end
stats.checks = stats.checks + 1
if not M.onBelt() then return end
if not M.worn() then
stats.notWorn = stats.notWorn + 1
return
end
stats.caught = stats.caught + 1
local ok, msg = netCall("RF/Treadmill/AskDoff")
if ok == true then
stats.doffed = stats.doffed + 1
log.info("standing on the belt - AskDoff accepted")
else
stats.refused = stats.refused + 1
log.warn("standing on the belt - AskDoff refused: %s %s",
tostring(ok), tostring(msg or ""))
end
task.wait(dev.scale(K.AFTER_OFF))
end
function M.arm()
if sc then return true end
sc = BX.scope("features.treadmill")
sc:loop("watch", dev.scale(K.POLL), step)
ch.onSpawn(sc, "treadmill.respawn", function()
partCache, partAt = nil, 0
end)
log.info("armed (poll %.1fs, %s)", dev.scale(K.POLL), enabled and "enabled" or "disabled")
return true
end
function M.unstuck()
if not M.worn() then
return false, "You are not on the treadmill"
end
local ok, msg = netCall("RF/Treadmill/AskDoff")
if ok == true then
stats.doffed = stats.doffed + 1
log.info("unstuck button - AskDoff accepted")
return true, "Off the treadmill"
end
stats.refused = stats.refused + 1
log.warn("unstuck button - AskDoff refused: %s %s", tostring(ok), tostring(msg or ""))
return false, "The game refused - try again in a moment"
end
function M.disarm()
if not sc then return end
sc:destroy()
sc = nil
partCache, partAt = nil, 0
log.info("disarmed (%d checks, %d caught, %d doffed)",
stats.checks, stats.caught, stats.doffed)
end
function M.setEnabled(on)
enabled = on and true or false
log.info("anti treadmill %s", enabled and "ON" or "OFF")
if enabled then M.arm() else M.disarm() end
end
return M
end)
BX.module("features.farm.index", function(BX)
local svc  = BX.require("core.services")
local data = BX.require("core.data")
local eggs = BX.require("features.eggs")
local net  = BX.require("core.net")
local log  = BX.require("boot.log").for_module("farm.index")
local M = {}
local K = {
CACHE      = 2.0,   
CLAIM_GAP  = 20,    
}
M.K = K
local function save()
local s
BX.try("index.save", function()
s = data.profile()
end)
return type(s) == "table" and s or nil
end
local required = nil
local function requiredPets()
if required then return required end
local out = {}
BX.try("index.required", function()
local areas, assets = data.areasDir(), data.assetsDir()
for areaId, cfg in pairs(areas or {}) do
for _, row in pairs((type(cfg) == "table" and cfg.DropTable) or {}) do
local cat, weight = row[1], tonumber(row[2]) or 0
local a = assets and assets[cat]
if cat and weight > 0 and a and a.DontRoll ~= true then
out[tostring(cat)] = tostring(areaId)
end
end
end
end)
if next(out) then required = out end
return out
end
local function onTheWay(s)
local set = {}
for _, rec in pairs((s and s.EggInventory) or {}) do
if type(rec) == "table" and rec.AssetCategory then set[tostring(rec.AssetCategory)] = true end
end
BX.try("index.owned", function()
local me = svc.Players.LocalPlayer and svc.Players.LocalPlayer.UserId
local recs = eggs.ownerEggs(me)
for _, rec in pairs(recs or {}) do
if type(rec) == "table" and rec.AssetCategory then set[tostring(rec.AssetCategory)] = true end
end
end)
return set
end
local needed, neededAt = {}, -math.huge
local lastCounts = { have = 0, total = 0, missing = 0, waiting = 0 }
local function refresh(force)
local now = os.clock()
if not force and (now - neededAt) < K.CACHE then return needed end
neededAt = now
local s = save()
local req = requiredPets()
local found = (s and s.Index) or {}
local way = onTheWay(s)
local out, have, total, waiting = {}, 0, 0, 0
for cat in pairs(req) do
total = total + 1
if found[cat] == true then
have = have + 1
elseif way[cat] then
waiting = waiting + 1       
else
out[cat] = true
end
end
needed = out
local missing = 0
for _ in pairs(out) do missing = missing + 1 end
lastCounts = { have = have, total = total, missing = missing, waiting = waiting }
return needed
end
function M.needs(category)
if category == nil then return false end
return refresh()[tostring(category)] == true
end
function M.progress()
refresh()
return lastCounts.have, lastCounts.total, lastCounts.missing, lastCounts.waiting
end
function M.missingList()
local req = requiredPets()
local list = {}
for cat in pairs(refresh()) do list[#list + 1] = { category = cat, area = req[cat] } end
table.sort(list, function(a, b)
if a.area ~= b.area then return tostring(a.area) < tostring(b.area) end
return a.category < b.category
end)
return list
end
local function unclaimed(s)
local n = 0
for cat, v in pairs((s and s.Index) or {}) do
if v == true and not ((s.IndexClaimedCategories or {})[cat]) then n = n + 1 end
end
return n
end
local lastClaimAt = -math.huge
function M.claimRewards()
if (os.clock() - lastClaimAt) < K.CLAIM_GAP then return false, "too soon" end
local s = save()
local n = unclaimed(s)
if n == 0 then return false, "nothing to claim" end
lastClaimAt = os.clock()
local ok, msg = net.call("RF/Codex/AskRedeemAll")
if ok then
log.info("claimed %d index rewards", n)
return true, ("Claimed %d index rewards"):format(n)
end
log.warn("index claim refused: %s", tostring(msg))
return false, tostring(msg)
end
return M
end)
BX.module("features.farm.filter", function(BX)
local data = BX.require("core.data")
local eggs = BX.require("features.eggs")
local guardwatch = BX.require("features.guardwatch")
local log  = BX.require("boot.log").for_module("farm.filter")
local M = {}
local function AreasDir() return data.areasDir() end
local function AssetsDir() return data.assetsDir() end
local FALLBACK_RARITIES = {
{ id = "Common",    label = "Common",    num = 1 },
{ id = "Rare",      label = "Rare",      num = 2 },
{ id = "Epic",      label = "Epic",      num = 3 },
{ id = "Legendary", label = "Legendary", num = 4 },
{ id = "Mythic",    label = "Mythic",    num = 5 },
{ id = "Cosmic",    label = "Cosmic",    num = 6 },
{ id = "Divine",    label = "Divine",    num = 7 },
{ id = "Eternal",   label = "Eternal",   num = 8 },
{ id = "Secret",    label = "Secret",    num = 9 },
}
local areas    = {}          
local rarities = {}          
local mutations = {}         
local minWeight = nil        
local minIncome = nil        
local targetBy = "Income"    
local TARGET_MODES = { "Income", "Weight", "Income / Trip" }
local TRIP_FIXED = 4.5
local function count(set)
local n = 0
for _ in pairs(set) do n = n + 1 end
return n
end
local function toSet(list)
local set = {}
if type(list) == "table" then
for _, v in pairs(list) do
if v ~= nil and v ~= "" then set[tostring(v)] = true end
end
elseif type(list) == "string" and list ~= "" then
set[list] = true
end
return set
end
function M.areaOptions()
local out = {}
for id, entry in pairs(AreasDir() or {}) do
out[#out + 1] = {
id = tostring(id),
label = tostring((type(entry) == "table" and entry.DisplayName) or id),
}
end
table.sort(out, function(a, b) return a.label < b.label end)
return out
end
function M.rarityOptions()
local seen, rows = {}, {}
for _, entry in pairs(AssetsDir() or {}) do
local r = type(entry) == "table" and entry.Rarity or nil
if type(r) == "table" then
local id = tostring(r._id or r.DisplayName or "")
if id ~= "" and not seen[id] then
seen[id] = true
rows[#rows + 1] = {
id = id,
label = tostring(r.DisplayName or id),
num = tonumber(r.RarityNumber) or 0,
}
end
end
end
if #rows == 0 then
for _, egg in ipairs(eggs.list({ allowPartial = true }) or {}) do
local id = tostring(egg.rarityId or egg.rarity or "")
local label = tostring(egg.rarity or egg.rarityId or "")
if id ~= "" and id ~= "?" and label ~= "" and label ~= "?" and not seen[id] then
seen[id] = true
rows[#rows + 1] = { id = id, label = label, num = 0 }
end
end
end
if #rows == 0 then
local baked = BX.require("features.catalog")
for _, entry in pairs(baked.all and baked.all() or {}) do
local id = tostring(entry.rarityId or entry.rarity or "")
if id ~= "" and not seen[id] then
seen[id] = true
rows[#rows + 1] = { id = id, label = tostring(entry.rarity or id),
num = tonumber(entry.rarityNum) or 0 }
end
end
if #rows > 0 then log.info("rarity list from the baked catalog (%d tiers)", #rows) end
end
if #rows == 0 then
for _, row in ipairs(FALLBACK_RARITIES) do
rows[#rows + 1] = { id = row.id, label = row.label, num = row.num }
end
log.info("rarity directory unavailable; using fallback catalog")
end
table.sort(rows, function(a, b)
if a.num ~= b.num then return a.num < b.num end
return a.label < b.label
end)
return rows
end
function M.targetByOptions() return table.clone(TARGET_MODES) end
function M.mutationOptions()
local seen, rows = {}, {}
local function add(m)
if type(m) == "table" then
local id = tostring(m._id or m.DisplayName or "")
if id ~= "" and not seen[id] then
seen[id] = true
rows[#rows + 1] = { id = id, label = tostring(m.DisplayName or id) }
end
elseif type(m) == "string" and m ~= "" and not seen[m] then
seen[m] = true
rows[#rows + 1] = { id = m, label = m }
end
end
for _, entry in pairs(AssetsDir() or {}) do
if type(entry) == "table" then
local list = entry.Mutations or entry.PossibleMutations
if type(list) == "table" then
for _, m in pairs(list) do add(m) end
end
end
end
if #rows == 0 then
for _, e in ipairs(eggs.list() or {}) do
if type(e.mutations) == "table" then
for _, m in ipairs(e.mutations) do add(m) end
end
end
end
table.sort(rows, function(a, b) return a.label < b.label end)
return rows
end
function M.setAreas(list)
areas = toSet(list)
log.info("areas: %s", count(areas) == 0 and "any" or tostring(count(areas)))
end
function M.setRarities(list)
rarities = toSet(list)
log.info("rarities: %s", count(rarities) == 0 and "any" or tostring(count(rarities)))
end
function M.setMutations(list)
mutations = toSet(list)
log.info("mutations: %s", count(mutations) == 0 and "any" or tostring(count(mutations)))
end
local function floorValue(v)
if v == nil or v == "" then return nil end
local n = tonumber(v)
if not n or n <= 0 then return nil end
return n
end
function M.setMinWeight(v)
minWeight = floorValue(v)
log.info("minimum weight: %s", minWeight and (minWeight .. " Kg") or "any")
end
function M.setMinIncome(v)
minIncome = floorValue(v)
log.info("minimum income: %s", minIncome and eggs.formatRate(minIncome) .. "/s" or "any")
end
function M.setTargetBy(v)
targetBy = "Income"
for _, mode in ipairs(TARGET_MODES) do
if v == mode then targetBy = mode end
end
log.info("target by: %s", targetBy)
end
local function tripSeconds(e)
local secs = TRIP_FIXED
if not e.pos then return secs end
local dest = BX.require("features.plot").safeZone()
if not dest then return secs end
local speed = BX.require("features.carry").K.SPEED
local flat = Vector3.new(dest.X - e.pos.X, 0, dest.Z - e.pos.Z).Magnitude
return secs + flat / math.max(speed, 1)
end
local function keyFor(e)
if targetBy == "Weight" then
return tonumber(e.kg) or 0
end
local income = tonumber(e.value) or 0
if targetBy == "Income / Trip" then
return income / tripSeconds(e)
end
return income
end
function M.selection()
return { areas = areas, rarities = rarities, mutations = mutations,
minWeight = minWeight, minIncome = minIncome, targetBy = targetBy }
end
function M.describe()
if indexOnly then
local extra = count(rarities) > 0 and (" within %d rarities"):format(count(rarities)) or ""
return ("index mode (missing pets%s), by %s"):format(extra, targetBy)
end
local parts = {
("%s areas"):format(count(areas) == 0 and "all" or tostring(count(areas))),
("%s rarities"):format(count(rarities) == 0 and "any" or tostring(count(rarities))),
}
if count(mutations) > 0 then
parts[#parts + 1] = ("%d mutations"):format(count(mutations))
end
if minWeight then parts[#parts + 1] = ("min %gKg"):format(minWeight) end
if minIncome then parts[#parts + 1] = ("min " .. eggs.formatRate(minIncome) .. "/s") end
parts[#parts + 1] = "by " .. targetBy
return table.concat(parts, ", ")
end
local function rarityOk(e)
if count(rarities) == 0 then return true end
local id = tostring(e.rarityId or e.rarity or "")
local label = tostring(e.rarity or "")
return rarities[id] == true or rarities[label] == true
end
local indexOnly = false
local indexMod = nil
function M.setIndexOnly(on)
indexOnly = on and true or false
if indexOnly and not indexMod then indexMod = BX.require("features.farm.index") end
log.info("index mode: %s", indexOnly and "ON" or "off")
end
function M.isIndexOnly() return indexOnly end
local function mutationOk(e)
if count(mutations) == 0 then return true end
local list = e.mutations
if type(list) ~= "table" then return false end
for _, m in ipairs(list) do
if type(m) == "table" then
if mutations[tostring(m._id or "")] or mutations[tostring(m.DisplayName or "")] then
return true
end
elseif mutations[tostring(m)] then
return true
end
end
return false
end
local function weightPass(e)
if not minWeight then return true end
local kg = tonumber(e.kg)
if not kg then return true end
return kg >= minWeight
end
local function incomePass(e)
if not minIncome then return true end
local v = tonumber(e.value)
if not v then return true end
return v >= minIncome
end
local function areaPass(e)
if count(areas) == 0 then return true end
return areas[tostring(e.areaId)] == true
end
local function rarityPass(e)
if indexOnly and not indexMod.needs(e.assetCategory) then return false end
return rarityOk(e) and mutationOk(e)
end
local function wanted(e)
return areaPass(e) and rarityPass(e) and weightPass(e) and incomePass(e)
end
function M.allows(e)
if not e then return false end
if count(areas) > 0 and areas[tostring(e.areaId)] ~= true then return false end
if count(rarities) > 0 and not rarityOk(e) then return false end
return mutationOk(e)
end
function M.hasDescription()
return count(areas) > 0 or count(rarities) > 0 or count(mutations) > 0
end
local last = { text = "waiting for the first pass", n = 0, field = 0, degraded = nil }
function M.status() return last end
local function degradedFor(list)
local anyArea, anyRarity = false, false
for _, e in ipairs(list) do
if e.areaId ~= nil then anyArea = true end
if e.rarity and e.rarity ~= "?" then anyRarity = true end
if anyArea and anyRarity then return nil end
end
if count(areas) > 0 and not anyArea then
return "eggs carry no area on this executor - clear the Areas filter"
end
if count(rarities) > 0 and not anyRarity then
return "eggs carry no rarity on this executor - clear the Rarities filter"
end
return nil
end
local blockedSince = nil
local GUARD_WAIT_MAX = 3
local overrideUntil = 0
local OVERRIDE_FOR = 25
function M.pick()
local list = eggs.list()          
local field = list and #list or 0
if field == 0 then
last = { text = "no takeable eggs on the field", n = 0, field = 0 }
return nil, "field=0 (no takeable eggs listed)"
end
local afterArea, afterRarity = 0, 0
local best, bestKey
local overriding = os.clock() < overrideUntil
local blocked = overriding and {} or guardwatch.blockedAreas()
local skippedFor = {}
for _, e in ipairs(list) do
if areaPass(e) then
afterArea = afterArea + 1
local fits = rarityPass(e) and weightPass(e) and incomePass(e)
if fits and blocked[tostring(e.areaId)] then
skippedFor[tostring(e.areaId)] = true
elseif fits then
afterRarity = afterRarity + 1
local key = keyFor(e)
if not best or key > bestKey then best, bestKey = e, key end
end
end
end
if best then
blockedSince = nil
last = { text = ("%d of %d eggs match  \u{B7}  next: %s"):format(afterRarity, field, tostring(best.name)),
n = afterRarity, field = field }
return best, nil, overriding
end
local waitingOn = {}
for areaId in pairs(skippedFor) do waitingOn[#waitingOn + 1] = areaId end
if #waitingOn > 0 then
local now = os.clock()
blockedSince = blockedSince or now
if (now - blockedSince) >= GUARD_WAIT_MAX then
local best2, key2
for _, e in ipairs(list) do
if wanted(e) then
local key = keyFor(e)
if not best2 or key > key2 then best2, key2 = e, key end
end
end
if best2 then
log.info("guard still out after %.0fs - going anyway for %s", now - blockedSince, tostring(best2.name))
blockedSince = nil
overrideUntil = now + OVERRIDE_FOR
last = { text = ("guard still out - going anyway  \u{B7}  next: %s"):format(tostring(best2.name)),
n = 1, field = field }
return best2, nil, true
end
end
table.sort(waitingOn)
local names = table.concat(waitingOn, ", ")
last = { text = ("waiting for guards to go home: %s"):format(names), n = 0, field = field }
return nil, "guards out: " .. names
end
local degraded = (not indexOnly) and degradedFor(list) or nil
local why = ("all eggs discovered=%d area-matched=%d rarity-matched=%d target candidates=%d final eligible=0 (%s)")
:format(field, afterArea, afterRarity, afterRarity, M.describe())
if degraded then why = why .. " - " .. degraded end
local text = degraded or ("0 of %d eggs match your filters  \u{B7}  waiting"):format(field)
if indexOnly then
local have, total = indexMod.progress()
text = ("Index %d/%d  \u{B7}  no missing pet on the field right now"):format(have, total)
why = "index: no missing pet on the field"
end
last = { text = text, n = 0, field = field, degraded = degraded }
return nil, why
end
function M.matchCount()
local list = eggs.list()
local n = 0
for _, e in ipairs(list or {}) do
if wanted(e) then n = n + 1 end
end
return n
end
return M
end)
BX.module("features.farm.priority", function(BX)
local filter = BX.require("features.farm.filter")
local rift   = BX.require("features.rift")
local log    = BX.require("boot.log").for_module("farm.priority")
local M = {}
M.MODES = { "Eggs first", "Rift pets first" }
local MODE_ID = { ["Eggs first"] = "eggs", ["Rift pets first"] = "rift" }
local mode = "eggs"
local lastSource = nil
local lastMiss = nil          
local lastRiftName = nil
local stats = { picks = 0, rift = 0, filter = 0, empty = 0 }
function M.stats() return table.clone(stats) end
function M.mode() return mode end
function M.lastSource() return lastSource end
function M.label()
for label, id in pairs(MODE_ID) do
if id == mode then return label end
end
return M.MODES[1]
end
function M.setMode(v)
local id = MODE_ID[tostring(v)] or (v == "eggs" or v == "rift") and v or nil
if not id then return false, "unknown priority" end
if id == mode then return true end
mode = id
lastSource, lastMiss = nil, nil
if not rift.isOn() then
task.spawn(function()
BX.try("priority.enableRift", function()
if not rift.isOn() then rift.setEnabled(true) end
end)
end)
end
log.info("priority: %s", id == "rift" and "rift pets, eggs when none are out"
or "eggs, rift pets when nothing matches the filter")
return true
end
local function riftSide()
if not rift.isOn() then return nil, "rift is off" end
if not rift.eligible() then return nil, "no required pet is takeable" end
local ok, egg, why = pcall(rift.pickTarget)
if not ok then
log.warn("rift picker threw: %s", tostring(egg))
return nil, "rift picker failed"
end
if egg and filter.hasDescription() and not filter.allows(egg) then
return nil, ("the rift wants %s, which your filters exclude"):format(
tostring(egg.name or "a pet"))
end
return egg, why
end
local function filterSide()
local ok, egg, why, override = pcall(filter.pick)
if not ok then
log.warn("filter picker threw: %s", tostring(egg))
return nil, "filter failed"
end
return egg, why, override
end
function M.pick()
stats.picks = stats.picks + 1
local first, second = riftSide, filterSide
local firstName, secondName = "rift", "filter"
if mode == "eggs" then
first, second = filterSide, riftSide
firstName, secondName = "filter", "rift"
end
local egg, why, override = first()
if egg then
if lastSource ~= firstName then
log.info("taking the %s target (%s has priority)", firstName, firstName)
end
lastSource, lastMiss = firstName, nil
if firstName == "rift" then lastRiftName = egg.name end
stats[firstName] = stats[firstName] + 1
return egg, nil, override
end
local firstWhy = why
egg, why, override = second()
if egg then
if lastSource ~= secondName or lastMiss ~= firstWhy then
log.info("nothing from %s (%s) - taking the %s target",
firstName, tostring(firstWhy or "no reason given"), secondName)
end
lastSource, lastMiss = secondName, firstWhy
if secondName == "rift" then lastRiftName = egg.name end
stats[secondName] = stats[secondName] + 1
return egg, nil, override
end
stats.empty = stats.empty + 1
lastSource = nil
local reason = (mode == "eggs") and firstWhy or why
return nil, reason or firstWhy
end
function M.statusSuffix()
if lastSource ~= "rift" then return nil end
return lastRiftName and ("going for " .. tostring(lastRiftName))
or "going for a rift pet"
end
return M
end)
BX.module("features.farm.treadmill_on", function(BX)
local svc = BX.require("core.services")
local move = BX.require("features.movement")
local data = BX.require("core.data")
local ch  = BX.require("core.character")
local dev = BX.require("core.device")
local net = BX.require("core.net")
local st  = BX.require("core.state")
local motion = BX.require("core.motion")
local log = BX.require("boot.log").for_module("farm.treadmill")
local M = {}
local K = {
POLL     = 1.0,
DRIFT    = 6,      
STEP_OFF = 14,     
}
M.K = K
local PlotState = data.plotState()
local sc = nil
local enabled = false
local lock = false         
local stats = { nudges = 0, paused = 0, doffed = 0, noSpot = 0, yielded = 0, stoodDown = 0 }
function M.stats() return table.clone(stats) end
function M.isOn() return enabled end
function M.isLocked() return lock end
local saidSlot = false
local function slotFromWorld()
local me = svc.Players.LocalPlayer and svc.Players.LocalPlayer.UserId
local plots = workspace:FindFirstChild("Plots")
if not plots then return nil end
for _, child in ipairs(plots:GetChildren()) do
local ok, attrs = pcall(child.GetAttributes, child)
if ok and type(attrs) == "table" then
for key, value in pairs(attrs) do
local k = tostring(key):lower()
if (k:find("owner") or k:find("userid")) and tonumber(value) == me then
if not saidSlot then
saidSlot = true
log.info("plot slot %s resolved from the %s attribute", child.Name, tostring(key))
end
return child.Name
end
end
end
end
local anchor = nil
BX.try("farm.treadmill.anchor", function()
for _, rec in pairs(BX.require("features.eggs").ownerEggs() or {}) do
local cf = type(rec) == "table" and (rec.BoundsCFrame or rec.CFrame or rec.BottomCFrame)
if typeof(cf) == "CFrame" then anchor = cf.Position break end
if typeof(rec.Position) == "Vector3" then anchor = rec.Position break end
end
end)
if not anchor then
local myName = svc.Players.LocalPlayer and svc.Players.LocalPlayer.Name
local myDisplay = svc.Players.LocalPlayer and svc.Players.LocalPlayer.DisplayName
for _, child in ipairs(plots:GetChildren()) do
for _, d in ipairs(child:GetDescendants()) do
if d:IsA("TextLabel") then
local text = tostring(d.Text or "")
if (myName and text:find(myName, 1, true))
or (myDisplay and text:find(myDisplay, 1, true)) then
if not saidSlot then
saidSlot = true
log.info("plot slot %s resolved from its nameplate (%q)", child.Name, text:sub(1, 30))
end
return child.Name
end
end
end
end
end
local home = anchor or BX.require("features.plot").home()
if typeof(home) ~= "Vector3" then return nil end
local best, bestDist
local renders = workspace:FindFirstChild("__ClientTreadmillRenders")
for _, render in ipairs(renders and renders:GetChildren() or {}) do
local slotName = tostring(render.Name):match("TreadmillRender_(.+)$")
local root = render:FindFirstChild("Root")
if slotName and root and root:IsA("BasePart") then
local d = (root.Position - home).Magnitude
if not bestDist or d < bestDist then best, bestDist = slotName, d end
end
end
if not best then
for _, child in ipairs(plots:GetChildren()) do
local bottom = child:FindFirstChild("TreadmillBottom")
if bottom and bottom:IsA("BasePart") then
local d = (bottom.Position - home).Magnitude
if not bestDist or d < bestDist then best, bestDist = child.Name, d end
end
end
end
if best and not saidSlot then
saidSlot = true
log.info("plot slot %s resolved as the treadmill nearest %s (%.0f studs)", best,
anchor and "your placed eggs" or "your spawn point", bestDist)
end
return best
end
function M.spot()
local slot
BX.try("farm.treadmill.slot", function()
slot = PlotState and PlotState.ResolveLocalSlot and PlotState.ResolveLocalSlot()
if not slot then
PlotState = PlotState or data.plotState()
slot = PlotState and PlotState.ResolveLocalSlot and PlotState.ResolveLocalSlot()
end
if not slot then slot = slotFromWorld() end
end)
if not slot then return nil end
local pos
BX.try("farm.treadmill.spot", function()
local folder = workspace:FindFirstChild("__ClientTreadmillRenders")
local render = folder and folder:FindFirstChild("TreadmillRender_" .. tostring(slot))
local root = render and render:FindFirstChild("Root")
if root and root:IsA("BasePart") then
pos = root.Position
return
end
local plots = workspace:FindFirstChild("Plots")
local plot = plots and plots:FindFirstChild(tostring(slot))
local bottom = plot and plot:FindFirstChild("TreadmillBottom")
if bottom and bottom:IsA("BasePart") then
pos = bottom.Position + Vector3.new(0, 4, 0)
end
end)
return pos
end
local NUDGE_MAX = 12
local function place(pos, nudgeOnly)
local hrp = ch.root()
if not hrp or not pos then return false end
local far = (hrp.Position - pos).Magnitude
if nudgeOnly or far <= NUDGE_MAX then
local ok = BX.try("farm.treadmill.place", function()
hrp.CFrame = CFrame.new(pos)
end)
return ok and true or false
end
local speed = K.WALK_SPEED
BX.try("farm.treadmill.speed", function()
local st2 = BX.require("features.carry").speedState()
if st2 and tonumber(st2.current) then speed = tonumber(st2.current) end
end)
local arrived = BX.try("farm.treadmill.travel", function()
return move.travel{
to = pos, speed = speed, arrive = 4,
carrying = false, tag = "to the belt",
}
end)
if not arrived then return false end
BX.try("farm.treadmill.settle", function()
local h = ch.root()
if h then h.CFrame = CFrame.new(pos) end
end)
return true
end
local function mayPark()
if not st.autoStealOn then return true end
local auto = BX.require("features.autosteal")
local s = auto.status()
return s.running and not s.busy and auto.isParkableWait(s.idle)
end
local parked = false
local function setParked(on)
parked = on and true or false
st.stayOnTreadmill = enabled and parked
end
local function step()
if not enabled then return end
local above = motion.blockedBy("hold")
if above then
stats.paused = stats.paused + 1
if parked then
stats.stoodDown = stats.stoodDown + 1
setParked(false)
log.info("%s is moving you - standing down (we park again when it lets go)", above)
end
return
end
if not mayPark() then
stats.paused = stats.paused + 1
if parked then setParked(false) end
return
end
local pos = M.spot()
if not pos then
stats.noSpot = stats.noSpot + 1
return
end
local hrp = ch.root()
if not hrp then return end
if not parked then
setParked(true)
if st.autoStealOn then log.info("run is waiting - parking on the belt") end
place(pos)
return
end
if lock and (hrp.Position - pos).Magnitude > K.DRIFT then
if place(pos, true) then
stats.nudges = stats.nudges + 1
log.trace("nudged back onto the belt")
end
end
end
function M.yieldToRun()
if not enabled then return end
local tm = BX.require("features.treadmill")
if not parked and not tm.worn() then return end
setParked(false)
local ok, msg = net.call("RF/Treadmill/AskDoff")
if ok == true then
stats.doffed = stats.doffed + 1
else
log.warn("AskDoff refused: %s %s", tostring(ok), tostring(msg or ""))
end
local pos = M.spot()
if pos then place(pos + Vector3.new(0, 3, K.STEP_OFF)) end
local t0 = os.clock()
while tm.worn() and os.clock() - t0 < 1.5 do task.wait(0.1) end
stats.yielded = stats.yielded + 1
log.info("egg found - off the belt in %.0fms, handing over to the run",
(os.clock() - t0) * 1000)
end
function M.setLock(on)
lock = on and true or false
log.info("lock to treadmill %s", lock and "ON" or "OFF")
return true
end
function M.setEnabled(on)
on = on and true or false
if on == enabled then return true end
if on then
local pos = M.spot()
if not pos then
log.warn("refused - could not resolve your treadmill")
return false, "Could not find your treadmill"
end
enabled = true
BX.require("core.motion").claim("hold")
BX.require("features.autosteal").setBeforeSteal(function() M.yieldToRun() end)
sc = BX.scope("features.farm.treadmill_on")
sc:loop("hold", dev.scale(K.POLL), step)
ch.onSpawn(sc, "farm.treadmill.respawn", function()
setParked(false)
end)
log.info("using the belt while waiting (poll %.1fs, lock=%s)", dev.scale(K.POLL), tostring(lock))
return true
end
local wasParked = parked
enabled = false
setParked(false)
BX.require("core.motion").release("hold")
if sc then sc:destroy() sc = nil end
if not wasParked and st.autoStealBusy then
log.info("released (run in progress - nothing to step off)")
return true
end
local ok, msg = net.call("RF/Treadmill/AskDoff")
if ok == true then
stats.doffed = stats.doffed + 1
else
log.warn("AskDoff refused: %s %s", tostring(ok), tostring(msg or ""))
end
local pos = M.spot()
if pos then place(pos + Vector3.new(0, 3, K.STEP_OFF)) end
log.info("released (%d nudges, %d paused for a run)", stats.nudges, stats.paused)
return true
end
BX.onTeardown("farm.treadmill_on", function() if enabled then M.setEnabled(false) end end)
return M
end)
BX.module("features.farm.pets", function(BX)
local net = BX.require("core.net")
local log = BX.require("boot.log").for_module("farm.pets")
local M = {}
local stats = { asked = 0, equipped = 0, refused = 0 }
function M.stats() return table.clone(stats) end
function M.equipBest()
stats.asked = stats.asked + 1
local ok, msg = net.call("RF/Haul/WearBest")
if ok == true then
stats.equipped = stats.equipped + 1
log.info("equipped best pets")
return true, "Equipped your best pets"
end
stats.refused = stats.refused + 1
log.warn("WearBest refused: %s %s", tostring(ok), tostring(msg or ""))
return false, "Refused: " .. tostring(msg or ok)
end
return M
end)
BX.module("features.farm.plotcare", function(BX)
local svc   = BX.require("core.services")
local dev   = BX.require("core.device")
local st    = BX.require("core.state")
local data  = BX.require("core.data")
local eggs  = BX.require("features.eggs")
local log   = BX.require("boot.log").for_module("farm.plotcare")
local M = {}
local K = {
TICK          = 5,     
HATCH_GAP     = 1.5,   
FINISH_TRIES  = 4,     
PLACE_GAP     = 0.6,   
WEAR_WAIT     = 1.5,   
SPACING       = 7,     
MARGIN        = 4,     
CLEARANCE     = 5.5,   
SPOT_TRIES    = 3,     
REFUSED_WAIT  = 30,    
NEAR          = 35,
WALK_TIMEOUT  = 8,
RANGE_WAIT    = 4,     
}
M.K = K
local placeOn, hatchOn = false, false
local placeSc, hatchSc = nil, nil
local busyPlace, busyHatch = false, false
local placeCooldownUntil = 0
local lastPlace, lastHatch = "off", "off"
local stats = { placed = 0, placeRefused = 0, hatched = 0, hatchRefused = 0, finishRetries = 0 }
function M.stats() return table.clone(stats) end
function M.isPlacing() return placeOn end
function M.isHatching() return hatchOn end
local function me()
local lp = svc.Players.LocalPlayer
return lp and lp.UserId
end
local function ownedEggs()
local ES = data.eggState()
local recs = {}
BX.try("plotcare.readOwner", function()
recs = eggs.ownerEggs(me()) or {}
end)
return recs, ES
end
local function inArena()
local lp = svc.Players.LocalPlayer
return lp ~= nil and lp:GetAttribute("InBossArena") == true
end
local function hatchOne(ES, uid)
local ok, msg, result = false, nil, nil
BX.try("plotcare.beginHatch", function() ok, msg, result = ES.BeginHatch(uid) end)
if not ok then
stats.hatchRefused = stats.hatchRefused + 1
lastHatch = "refused: " .. tostring(msg or "no reason given")
log.warn("BeginHatch refused for %s: %s", uid, tostring(msg))
return false
end
for attempt = 1, K.FINISH_TRIES do
task.wait(K.HATCH_GAP)
if not hatchOn then return false end
local fok, fmsg, granted = false, nil, nil
BX.try("plotcare.finishHatch", function() fok, fmsg, granted = ES.FinishHatch(uid) end)
if fok then
stats.hatched = stats.hatched + 1
lastHatch = ("hatched %d this session"):format(stats.hatched)
log.info("hatched %s -> %s%s", uid, tostring(granted),
result and (" (" .. tostring(result) .. ")") or "")
return true
end
stats.finishRetries = stats.finishRetries + 1
log.warn("FinishHatch %d/%d for %s: %s", attempt, K.FINISH_TRIES, uid, tostring(fmsg))
lastHatch = "finishing: " .. tostring(fmsg or "waiting")
end
return false
end
local hatchInvited = false
local function hatchPass()
if not hatchOn or busyHatch then return end
if st.autoStealBusy and not hatchInvited then lastHatch = "waiting for Auto Steal" return end
busyHatch = true
BX.try("plotcare.hatchPass", function()
local recs, ES = ownedEggs()
if not (ES and ES.IsReadyToHatch and ES.BeginHatch and ES.FinishHatch) then
lastHatch = "hatch API unavailable"
return
end
local placed, ready = 0, {}
for uid, rec in pairs(recs) do
if rec.Placement ~= nil then
placed = placed + 1
local isReady = false
BX.try("plotcare.ready", function() isReady = ES.IsReadyToHatch(uid) == true end)
if isReady then ready[#ready + 1] = uid end
end
end
if #ready == 0 then
lastHatch = placed == 0 and "nothing placed" or ("%d growing"):format(placed)
return
end
for _, uid in ipairs(ready) do
if not hatchOn or (st.autoStealBusy and not hatchInvited) then break end
hatchOne(ES, uid)
end
end)
busyHatch = false
end
local function freeSpots(plot)
local area, center = plot.PetArea, plot.CenterPoint
if not (area and center and area:IsA("BasePart")) then return {} end
local taken = {}
local folder = workspace:FindFirstChild("PlacedEggRenders")
local prefix = tostring(me()) .. "_"
if folder then
for _, m in ipairs(folder:GetChildren()) do
if m:IsA("Model") and m.Name:sub(1, #prefix) == prefix then
BX.try("plotcare.pivot", function() taken[#taken + 1] = m:GetPivot().Position end)
end
end
end
local half = area.Size * 0.5
local spots = {}
for x = -half.X + K.MARGIN, half.X - K.MARGIN, K.SPACING do
for z = -half.Z + K.MARGIN, half.Z - K.MARGIN, K.SPACING do
local world = (area.CFrame * CFrame.new(x, half.Y, z)).Position
local clear = true
for _, p in ipairs(taken) do
local flat = Vector3.new(p.X - world.X, 0, p.Z - world.Z)
if flat.Magnitude < K.CLEARANCE then clear = false break end
end
if clear then
spots[#spots + 1] = center.CFrame:ToObjectSpace(CFrame.new(world))
end
end
end
return spots
end
local function wornEggToolUid(timeout)
local lp = svc.Players.LocalPlayer
local deadline = os.clock() + (timeout or 0)
repeat
local char = lp and lp.Character
if char then
for _, d in ipairs(char:GetChildren()) do
if d:IsA("Tool") and d:GetAttribute("ItemType") == "AssetEgg" then
local uid = d:GetAttribute("UID")
if type(uid) == "string" and uid ~= "" then return uid end
end
end
end
if os.clock() >= deadline then break end
task.wait(0.05)
until false
return nil
end
local function unplacedByValue(recs)
local list = {}
for uid, rec in pairs(recs) do
if rec.Placement == nil then
local v = 0
BX.try("plotcare.value", function()
v = eggs.value({ Uid = uid, AssetCategory = rec.AssetCategory,
AssetScale = rec.AssetScale, Mutations = rec.Mutations }) or 0
end)
list[#list + 1] = { uid = uid, value = tonumber(v) or 0, name = tostring(rec.AssetCategory) }
end
end
table.sort(list, function(a, b) return a.value > b.value end)
return list
end
local function placeOne(ES, plot, egg)
local wok, wmsg = false, nil
BX.try("plotcare.wear", function() wok, wmsg = ES.WearEggTool(egg.uid) end)
if not wok then
return false, "could not hold the egg: " .. tostring(wmsg or "refused")
end
local toolUid = wornEggToolUid(K.WEAR_WAIT) or egg.uid
local spots = freeSpots(plot)
if #spots == 0 then
BX.try("plotcare.doff", function() ES.DoffEggTool(toolUid) end)
return false, "no free space on the plot"
end
local lastMsg
for i = 1, math.min(K.SPOT_TRIES, #spots) do
local spot = spots[((stats.placed + i - 1) % #spots) + 1]
local ok, msg = false, nil
BX.try("plotcare.plant", function() ok, msg = ES.PlantEgg(toolUid, spot) end)
if ok then
stats.placed = stats.placed + 1
log.info("placed %s (%s)", egg.name, toolUid)
return true
end
lastMsg = msg
log.warn("PlantEgg refused (%s): %s", egg.name, tostring(msg))
end
BX.try("plotcare.doff", function() ES.DoffEggTool(toolUid) end)
return false, tostring(lastMsg or "refused")
end
local invited = false
local nearNeeded = K.NEAR
local function isRangeRefusal(msg)
return type(msg) == "string" and msg:lower():find("closer", 1, true) ~= nil
end
local function walkToPlot(plot)
local lp = svc.Players.LocalPlayer
local char = lp and lp.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
local root = char and char:FindFirstChild("HumanoidRootPart")
local anchor = plot.CenterPoint or plot.PetArea
if not (hum and root and anchor and anchor:IsA("BasePart")) then
return false, "no character or plot to walk to"
end
local target = anchor.Position
local function flatDist()
local d = root.Position - target
return Vector3.new(d.X, 0, d.Z).Magnitude
end
if flatDist() <= nearNeeded then return true end
if hum.Health <= 0 then return false, "character is dead" end
lastPlace = "walking to your plot"
log.info("walking to the plot to place (%.0f studs away)", flatDist())
local deadline = os.clock() + K.WALK_TIMEOUT
local lastIssue = 0
while os.clock() < deadline do
if not placeOn or (st.autoStealOn and not invited) or st.stayOnTreadmill or inArena() then
return false, "interrupted"
end
if os.clock() - lastIssue >= 1 then
lastIssue = os.clock()
hum:MoveTo(target)
end
if flatDist() <= nearNeeded then
hum:MoveTo(root.Position)   
return true
end
task.wait(0.1)
end
return false, "could not walk to your plot"
end
local function placePass()
if not placeOn or busyPlace then return end
if os.clock() < placeCooldownUntil and not invited then return end
if st.autoStealOn and not invited then lastPlace = "waiting for Auto Steal" return end
if st.stayOnTreadmill then lastPlace = "waiting for the treadmill hold" return end
if inArena() then lastPlace = "waiting - in the boss arena" return end
busyPlace = true
BX.try("plotcare.placePass", function()
local recs, ES = ownedEggs()
local PS = data.plotState()
if not (ES and ES.WearEggTool and ES.PlantEgg and ES.DoffEggTool and PS) then
lastPlace = "place API unavailable"
return
end
local plot
BX.try("plotcare.plot", function() plot = PS.ResolvePlot() end)
if type(plot) ~= "table" then lastPlace = "could not find your plot" return end
local todo = unplacedByValue(recs)
if #todo == 0 then lastPlace = "no eggs to place" return end
local near, whyFar = walkToPlot(plot)
if not near then
lastPlace = "waiting: " .. tostring(whyFar)
placeCooldownUntil = os.clock() + K.RANGE_WAIT
return
end
for _, egg in ipairs(todo) do
if not placeOn or (st.autoStealOn and not invited) or st.stayOnTreadmill then break end
local ok, stop = placeOne(ES, plot, egg)
if not ok then
stats.placeRefused = stats.placeRefused + 1
if isRangeRefusal(stop) then
lastPlace = "getting closer to your plot"
placeCooldownUntil = os.clock() + K.RANGE_WAIT
if nearNeeded > 8 then
nearNeeded = 8
log.info("still out of range - walking to the plot centre from now on")
end
else
lastPlace = "stopped: " .. tostring(stop)
placeCooldownUntil = os.clock() + K.REFUSED_WAIT
end
break
end
lastPlace = ("placed %d this session"):format(stats.placed)
task.wait(K.PLACE_GAP)
end
end)
busyPlace = false
end
local function arm(name, pass)
local sc = BX.scope("features.farm.plotcare." .. name)
sc:loop(name, dev.scale(K.TICK), pass)
BX.try("plotcare.watch." .. name, function()
local ES = data.eggState()
if ES and ES.OwnerRefreshed then
sc:connect(ES.OwnerRefreshed, function(userId)
if userId ~= me() then return end
task.spawn(function() BX.try("plotcare.onOwner." .. name, pass) end)
end)
end
end)
task.spawn(function() BX.try("plotcare.first." .. name, pass) end)
return sc
end
function M.placeNow()
if not placeOn then return false end
local t0 = os.clock()
while busyPlace and os.clock() - t0 < 10 do task.wait(0.1) end
for attempt = 1, 4 do
local recs = ownedEggs()
local any = false
for _, rec in pairs(recs) do
if rec.Placement == nil then any = true break end
end
if any then break end
if attempt == 4 then return true end
task.wait(0.5)
end
invited = true
placeCooldownUntil = 0
BX.try("plotcare.placeNow", placePass)
invited = false
return true
end
function M.hatchNow()
if not hatchOn then return false end
local t0 = os.clock()
while busyHatch and os.clock() - t0 < 10 do task.wait(0.1) end
hatchInvited = true
BX.try("plotcare.hatchNow", hatchPass)
hatchInvited = false
return true
end
function M.setPlace(on)
on = on and true or false
if on == placeOn then return true end
placeOn = on
if placeSc then placeSc:destroy() placeSc = nil end
if on then
placeCooldownUntil = 0
lastPlace = "starting"
placeSc = arm("place", placePass)
else
lastPlace = "off"
end
log.info("auto place %s", on and "ON" or "OFF")
return true
end
function M.setHatch(on)
on = on and true or false
if on == hatchOn then return true end
hatchOn = on
if hatchSc then hatchSc:destroy() hatchSc = nil end
if on then
lastHatch = "starting"
hatchSc = arm("hatch", hatchPass)
else
lastHatch = "off"
end
log.info("auto hatch %s", on and "ON" or "OFF")
return true
end
function M.preview()
local recs, ES = ownedEggs()
local out = { placed = 0, ready = 0, unplaced = 0, freeSpots = 0, nextEgg = nil }
for uid, rec in pairs(recs) do
if rec.Placement ~= nil then
out.placed = out.placed + 1
BX.try("plotcare.previewReady", function()
if ES.IsReadyToHatch(uid) then out.ready = out.ready + 1 end
end)
else
out.unplaced = out.unplaced + 1
end
end
local order = unplacedByValue(recs)
out.nextEgg = order[1] and order[1].name or nil
local PS = data.plotState()
BX.try("plotcare.previewPlot", function()
local plot = PS and PS.ResolvePlot()
if type(plot) == "table" then out.freeSpots = #freeSpots(plot) end
end)
return out
end
function M.status()
return ("Place: %s  \u{B7}  Hatch: %s"):format(lastPlace, lastHatch)
end
return M
end)
BX.module("features.esp.cards", function(BX)
local svc = BX.require("core.services")
local dev = BX.require("core.device")
local log = BX.require("boot.log").for_module("esp.cards")
local M = {}
local K = {
W = 190, H = 40,
VIS_HZ = 12,          
MAX_DIST = 2200,      
FADE_BAND = 260,      
BASE_ALPHA = 0.42,    
BASE_STROKE = 0.55,
BUILD_PER_FRAME = 3,
}
M.K = K
local C = {
bgTop   = Color3.fromRGB(26, 26, 30),
bgBot   = Color3.fromRGB(14, 14, 17),
accent  = Color3.fromRGB(206, 206, 212),
element = Color3.fromRGB(41, 41, 48),
title   = Color3.fromRGB(246, 242, 234),
sub     = Color3.fromRGB(168, 158, 144),
}
M.STYLE = {
titleFont = Enum.Font.GothamBold, titleSize = 13,
subFont   = Enum.Font.Gotham,     subSize   = 10,
}
M.COL = {
income = "57F287", neutral = "F0F0F6", mutation = "F0BE5A",
dim = "8A8A92", ready = "57F287",
}
M.SEP = "  \u{B7}  "
function M.tint(col, text)
return ('<font color="#%s">%s</font>'):format(col, text)
end
function M.hex(c)
return ("%02X%02X%02X"):format(
math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5),
math.floor(c.B * 255 + 0.5))
end
local function scaleFor(dist)
return math.clamp(1.25 - (tonumber(dist) or 0) / 800, 0.6, 1.25)
end
local sc, folder, handles = nil, nil, 0
local pools = {}      
local build, apply
local function ensure()
if sc then return end
sc = BX.scope("features.esp.cards")
folder = Instance.new("Folder")
folder.Name = "VoidcxzESP"
sc:own(folder)
folder.Parent = workspace
local acc, step = 0, 1 / K.VIS_HZ
sc:onFrame("vis", svc.RunService.RenderStepped, function(dt)
local budget = dev.budget(K.BUILD_PER_FRAME)
for _, pool in pairs(pools) do
if budget <= 0 then break end
for i, d in pairs(pool.pending) do
if budget <= 0 then break end
local c = build()
pool[i] = c
pool.n = pool.n + 1
if i > pool.high then pool.high = i end
apply(c, d)
pool.pending[i] = nil
budget = budget - 1
end
end
acc = acc + (dt or 0)
if acc < step then return end
acc = 0
local cam = workspace.CurrentCamera
if not cam then return end
local eye = cam.CFrame.Position
for _, pool in pairs(pools) do
for i = 1, pool.shown do
local c = pool[i]
if c and c.anchor.Parent then
local d = (c.pos - eye).Magnitude
local show = d <= K.MAX_DIST
if c.bb.Enabled ~= show then c.bb.Enabled = show end
if show then
local s = scaleFor(d)
if math.abs(c.lastScale - s) > 0.01 or c.lastH ~= c.baseH then
c.lastScale, c.lastH = s, c.baseH
c.scale.Scale = s
c.bb.Size = UDim2.fromOffset(K.W * s, c.baseH * s)
end
local fade = math.clamp((K.MAX_DIST - d) / K.FADE_BAND, 0, 1)
if math.abs(c.lastFade - fade) > 0.02 then
c.lastFade = fade
c.frame.BackgroundTransparency = 1 - (1 - K.BASE_ALPHA) * fade
c.title.TextTransparency = 1 - fade
c.sub.TextTransparency = 1 - fade
c.icon.ImageTransparency = 1 - fade
c.stroke.Transparency = 1 - (1 - K.BASE_STROKE) * fade
end
end
end
end
end
end)
end
function build()
local anchor = Instance.new("Part")
anchor.Name = "EggAnchor"
anchor.Anchored = true
anchor.CanCollide = false
anchor.CanQuery = false
anchor.CanTouch = false
anchor.CastShadow = false
anchor.Transparency = 1
anchor.Size = Vector3.new(0.2, 0.2, 0.2)
anchor.Parent = folder
local bb = Instance.new("BillboardGui")
bb.Name = "EggCard"
bb.AlwaysOnTop = true
bb.LightInfluence = 0
bb.MaxDistance = 1e6          
bb.Size = UDim2.fromOffset(K.W, K.H)
bb.StudsOffset = Vector3.new(0, 3, 0)
bb.Active = false
bb.Adornee = anchor
bb.Enabled = false
bb.Parent = anchor
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(K.W, K.H)
frame.BackgroundColor3 = Color3.new(1, 1, 1)
frame.BackgroundTransparency = K.BASE_ALPHA
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = bb
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
local grad = Instance.new("UIGradient", frame)
grad.Color = ColorSequence.new(C.bgTop, C.bgBot)
grad.Rotation = 90
local scaleObj = Instance.new("UIScale")
scaleObj.Scale = 1
scaleObj.Parent = frame
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.new(1, 1, 1)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Thickness = 1
stroke.Transparency = K.BASE_STROKE
local sg = Instance.new("UIGradient", stroke)
sg.Color = ColorSequence.new(C.accent, C.element)
sg.Rotation = 90
local accent = Instance.new("Frame")
accent.Name = "Accent"
accent.Position = UDim2.fromOffset(3, 4)
accent.Size = UDim2.new(0, 2, 1, -8)
accent.BorderSizePixel = 0
accent.BackgroundColor3 = Color3.fromRGB(194, 142, 54)
accent.Parent = frame
Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
local icon = Instance.new("ImageLabel")
icon.Name = "Icon"
icon.Position = UDim2.fromOffset(9, 8)
icon.Size = UDim2.fromOffset(24, 24)
icon.BackgroundTransparency = 1
icon.ScaleType = Enum.ScaleType.Fit
icon.Image = ""
icon.Parent = frame
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.fromOffset(38, 3)
title.Size = UDim2.new(1, -44, 0, 15)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextColor3 = C.title
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextTruncate = Enum.TextTruncate.AtEnd
title.Text = ""
title.Parent = frame
local sub = Instance.new("TextLabel")
sub.Name = "Sub"
sub.Position = UDim2.fromOffset(38, 18)
sub.Size = UDim2.new(1, -44, 0, 20)
sub.BackgroundTransparency = 1
sub.Font = Enum.Font.Gotham
sub.TextSize = 10
sub.TextColor3 = C.sub
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.TextYAlignment = Enum.TextYAlignment.Top
sub.RichText = true          
sub.Text = ""
sub.Parent = frame
return {
anchor = anchor, bb = bb, frame = frame, stroke = stroke,
accent = accent, icon = icon, title = title, sub = sub,
scale = scaleObj, pos = Vector3.zero, baseH = K.H,
lastScale = -1, lastFade = -1, lastH = -1,
lastTitle = nil, lastSub = nil, lastIcon = nil, lastStyle = nil,
}
end
function apply(c, d)
if c.pos ~= d.pos then
c.pos = d.pos
c.anchor.CFrame = CFrame.new(d.pos)
end
local h = (d.lines and d.lines > 1) and (K.H + 12) or K.H
if c.baseH ~= h then
c.baseH = h
c.frame.Size = UDim2.fromOffset(K.W, h)
c.sub.Size = UDim2.new(1, -44, 0, h - 20)
end
local titleText = (d.target and "\u{25B8} " or "") .. tostring(d.title or "")
if titleText ~= c.lastTitle then
c.lastTitle = titleText
c.title.Text = titleText
end
if d.sub ~= c.lastSub then
c.lastSub = d.sub
c.sub.Text = tostring(d.sub or "")
end
if d.icon ~= c.lastIcon then
c.lastIcon = d.icon
c.icon.Image = tostring(d.icon or "")
end
if d.accent and d.accent ~= c.lastAccent then
c.lastAccent = d.accent
c.accent.BackgroundColor3 = d.accent
end
local st = d.style
if st ~= c.lastStyle then
c.lastStyle = st
c.title.Font = (st and st.titleFont) or Enum.Font.GothamBold
c.title.TextSize = (st and st.titleSize) or 12
c.sub.Font = (st and st.subFont) or Enum.Font.Gotham
c.sub.TextSize = (st and st.subSize) or 10
end
end
local Handle = {}
Handle.__index = Handle
function Handle:show(i, d)
local pool = pools[self.name]
local c = pool[i]
if not c then
pool.pending[i] = d
return
end
apply(c, d)
end
function Handle:shown(n)
local pool = pools[self.name]
pool.shown = n
for i = n + 1, pool.high do
local c = pool[i]
if c and c.bb.Enabled then c.bb.Enabled = false end
end
for i in pairs(pool.pending) do
if i > n then pool.pending[i] = nil end
end
end
function Handle:count()
local pool = pools[self.name]
return pool.n, pool.shown
end
function Handle:close()
local pool = pools[self.name]
for i = 1, pool.high do
local c = pool[i]
if c then pcall(function() c.anchor:Destroy() end) end
end
pools[self.name] = nil
handles = handles - 1
if handles <= 0 then
handles = 0
if sc then sc:destroy() sc = nil end
folder, pools = nil, {}
log.info("released")
end
end
function M.open(name)
ensure()
handles = handles + 1
pools[name] = { shown = 0, pending = {}, n = 0, high = 0 }
return setmetatable({ name = name }, Handle)
end
function M.liveCount()
local n = 0
for _, pool in pairs(pools) do n = n + pool.n end
return n
end
function M.pendingCount()
local n = 0
for _, pool in pairs(pools) do
for _ in pairs(pool.pending) do n = n + 1 end
end
return n
end
BX.profile.watch("esp.cards", M.liveCount)
BX.profile.watch("esp.cards.queued", M.pendingCount)
return M
end)
BX.module("features.esp.eggs", function(BX)
local dev   = BX.require("core.device")
local eggs  = BX.require("features.eggs")
local data  = BX.require("core.data")
local cards = BX.require("features.esp.cards")
local log   = BX.require("boot.log").for_module("esp.eggs")
local M = {}
local K = {
REFRESH = 1.0,
MAX_CARDS = 40,       
LIFT_BASE = 2.2,      
LIFT_SCALE = 3.4,     
}
M.K = K
local sc, handle, enabled = nil, nil, false
local stats = { updates = 0, listed = 0, shown = 0 }
function M.stats() return table.clone(stats) end
function M.isOn() return enabled end
local STYLE, COL, SEP, tint, hex = cards.STYLE, cards.COL, cards.SEP, cards.tint, cards.hex
local function rate(n)
n = tonumber(n) or 0
for _, u in ipairs({ { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }) do
if n >= u[1] then
local v = n / u[1]
local txt = (v < 10) and ("%.2f"):format(v) or ("%.1f"):format(v)
return (txt:gsub("%.?0+$", "")) .. u[2]
end
end
return tostring(math.floor(n))
end
local scratch = {}
local DEFAULT_COLOUR = Color3.fromRGB(200, 200, 200)
local textFor, textNext = {}, {}
local slotData = {}
local function buildText(e, dir)
local d = e.assetCategory and dir and dir[e.assetCategory] or nil
local colour = DEFAULT_COLOUR
local rarityName = (e.rarity and e.rarity ~= "?") and e.rarity or nil
if d and d.Rarity then
if typeof(d.Rarity.Color) == "Color3" then colour = d.Rarity.Color end
rarityName = rarityName or d.Rarity.DisplayName or d.Rarity._id
end
local bits
if e.unpriced then
bits = { tint(COL.neutral, "rate unknown") }
else
bits = { tint(COL.income, "<b>" .. rate(e.value or 0) .. "/s</b>") }
end
if rarityName then
bits[#bits + 1] = tint(hex(colour), rarityName)
end
local kg = tonumber(e.kg) or 0
if kg > 0 then
bits[#bits + 1] = tint(COL.neutral,
kg >= 100 and ("%.0fkg"):format(kg) or ("%.1fkg"):format(kg))
end
local sub = table.concat(bits, SEP)
local lines = 1
if type(e.mutations) == "table" and #e.mutations > 0 then
local names = {}
for _, mu in ipairs(e.mutations) do
names[#names + 1] = tostring(type(mu) == "table"
and (mu.DisplayName or mu._id or "?") or mu)
end
sub = sub .. "\n" .. tint(COL.mutation, table.concat(names, " \u{B7} "))
lines = 2
end
return {
sub = sub, lines = lines, colour = colour,
icon = d and d.Icon or nil,
lift = Vector3.new(0, K.LIFT_BASE + (tonumber(e.assetScale) or 1) * K.LIFT_SCALE, 0),
}
end
local function update()
if not enabled or not handle then return end
stats.updates = stats.updates + 1
local cam = workspace.CurrentCamera
local list = eggs.list()
if not cam or not list then return end
local dir = data.assetsDir()
local eye = cam.CFrame.Position
for i = #scratch, 1, -1 do scratch[i] = nil end
for _, e in ipairs(list) do
if e.pos and (e.pos - eye).Magnitude <= cards.K.MAX_DIST then
scratch[#scratch + 1] = e
end
end
stats.listed = #scratch
local n = math.min(#scratch, K.MAX_CARDS)
for i = 1, n do
local e = scratch[i]
local t = textFor[e.uid] or buildText(e, dir)
textNext[e.uid] = t
local sd = slotData[i]
if not sd then sd = { style = STYLE } slotData[i] = sd end
sd.pos = e.pos + t.lift
sd.title = e.name
sd.sub = t.sub
sd.accent = t.colour
sd.icon = t.icon
sd.lines = t.lines
sd.target = e.isTarget
handle:show(i, sd)
end
textFor, textNext = textNext, textFor
table.clear(textNext)
handle:shown(n)
stats.shown = n
end
function M.setEnabled(on)
on = on and true or false
if on == enabled then return true end
enabled = on
if not on then
if handle then handle:close() handle = nil end
if sc then sc:destroy() sc = nil end
table.clear(textFor)
table.clear(slotData)
log.info("off")
return true
end
handle = cards.open("eggs")
sc = BX.scope("features.esp.eggs")
sc:loop("update", dev.scale(K.REFRESH), update)
log.info("on (max %d cards, %.2fs, range %d)",
K.MAX_CARDS, dev.scale(K.REFRESH), cards.K.MAX_DIST)
return true
end
return M
end)
BX.module("features.esp.plot", function(BX)
local svc   = BX.require("core.services")
local dev   = BX.require("core.device")
local ch    = BX.require("core.character")
local data  = BX.require("core.data")
local util  = BX.require("core.util")
local eggs  = BX.require("features.eggs")
local cards = BX.require("features.esp.cards")
local log   = BX.require("boot.log").for_module("esp.plot")
local M = {}
local K = { RATE = 1.0, MAX_CARDS = 24, OWNER_TTL = 10 }
M.K = K
local STYLE, COL, SEP, tint, hex = cards.STYLE, cards.COL, cards.SEP, cards.tint, cards.hex
local sc, handle, enabled = nil, nil, false
local stats = { updates = 0, eggs = 0, ready = 0 }
function M.stats() return table.clone(stats) end
function M.isOn() return enabled end
local function timeLeft(seconds)
seconds = math.max(0, math.floor(seconds))
local h = math.floor(seconds / 3600)
local m = math.floor(seconds / 60) % 60
if h > 0 then return ("%dh %02dm"):format(h, m) end
if m > 0 then return ("%dm %02ds"):format(m, seconds % 60) end
return ("%ds"):format(seconds)
end
local recs, recsAt, recsDirty = nil, 0, true
local staticFor = {}
local slotData = {}
local DEFAULT_COLOUR = Color3.fromRGB(190, 190, 200)
local READY_TEXT = tint(COL.ready, "<b>READY</b>")
local function ownerRecords(ES, me)
local now = os.clock()
if recs and not recsDirty and (now - recsAt) < K.OWNER_TTL then return recs end
local ok, got = pcall(function() return eggs.ownerEggs(me) end)
recs = (ok and type(got) == "table") and got or {}
recsAt, recsDirty = now, false
table.clear(staticFor)
stats.ownerReads = (stats.ownerReads or 0) + 1
return recs
end
local function buildStatic(uid, rec, dir)
local d = rec and dir and dir[rec.AssetCategory] or nil
local title = (d and d.DisplayName ~= "" and d.DisplayName)
or (rec and tostring(rec.AssetCategory)) or "Egg"
local rarity = d and d.Rarity
and tostring(d.Rarity.DisplayName or d.Rarity._id or "") or ""
local colour = (d and d.Rarity and typeof(d.Rarity.Color) == "Color3")
and d.Rarity.Color or DEFAULT_COLOUR
local muts = ""
if rec and type(rec.Mutations) == "table" and #rec.Mutations > 0 then
local names = {}
for _, mu in ipairs(rec.Mutations) do
names[#names + 1] = tostring(type(mu) == "table"
and (mu.DisplayName or mu._id or "?") or mu)
end
muts = table.concat(names, " \u{B7} ")
end
local rate = nil
if rec then
local ok, v = pcall(eggs.value, {
Uid = uid,
AssetCategory = rec.AssetCategory,
AssetScale = rec.AssetScale,
Mutations = rec.Mutations,
})
if ok then rate = v end
end
local kg = d and d.Egg and tonumber(d.Egg.WeightKg)
if kg then kg = kg * (tonumber(rec and rec.AssetScale) or 1) end
if kg and kg <= 0 then kg = nil end
local bits = {}
if rate and rate > 0 then
bits[#bits + 1] = eggs.unpriced(rec and rec.AssetCategory)
and tint(COL.neutral, "rate unknown")
or tint(COL.income, "<b>" .. eggs.formatRate(rate) .. "/s</b>")
end
if rarity ~= "" then
bits[#bits + 1] = tint(hex(colour), rarity)
end
if kg then
bits[#bits + 1] = tint(COL.neutral, kg >= 100
and ("%.0fkg"):format(kg) or ("%.1fkg"):format(kg))
end
local grow = d and d.Egg and tonumber(d.Egg.GrowthTime)
local placed = rec and rec.Placement and tonumber(rec.Placement.PlacedAt)
local mult = math.max(tonumber(rec and rec.GrowthSpeedMultiplier) or 1, 0.01)
return {
title = title, colour = colour, icon = d and d.Icon or nil,
head = table.concat(bits, SEP) .. "\n"
.. ((muts ~= "") and (tint(COL.mutation, muts) .. SEP) or ""),
readyAt = (grow and placed) and (placed + grow / mult) or nil,
hasRec = rec ~= nil,
lift = Vector3.new(0, 2.2 + (tonumber(rec and rec.AssetScale) or 1) * 3.4, 0),
}
end
local function update()
if not enabled or not handle then return end
stats.updates = stats.updates + 1
local rendered = workspace:FindFirstChild("PlacedEggRenders")
if not rendered then
handle:shown(0)
stats.eggs = 0
return
end
local ES = data.eggState()
local dir = data.assetsDir()
local me = svc.Players.LocalPlayer and svc.Players.LocalPlayer.UserId
if not me then return end
local prefix = tostring(me) .. "_"
local plen = #prefix
local owned = ownerRecords(ES, me)
local isReady = ES and ES.IsReadyToHatch
local nowT = os.time()
local n, readyN = 0, 0
for _, m in ipairs(rendered:GetChildren()) do
local name = m.Name
if string.find(name, prefix, 1, true) == 1 and m:IsA("Model") then
local uid = string.sub(name, plen + 1)
local okPos, pv = pcall(m.GetPivot, m)
if okPos and pv then
n = n + 1
local s = staticFor[uid]
if not s then
local rec = owned[uid]
s = buildStatic(uid, rec, dir)
if rec then
staticFor[uid] = s
else
recsDirty = true
end
end
local ready = false
if isReady then
local okR, r = pcall(isReady, uid)
ready = okR and r == true
end
local state
if ready then
readyN = readyN + 1
state = READY_TEXT
elseif s.readyAt then
state = tint(COL.dim, timeLeft(s.readyAt - nowT))
else
state = tint(COL.dim, "growing")
end
local sd = slotData[n]
if not sd then sd = { style = STYLE, lines = 2 } slotData[n] = sd end
sd.pos = pv.Position + s.lift
sd.title = s.title
sd.sub = s.head .. state
sd.accent = s.colour
sd.icon = s.icon
sd.target = ready
handle:show(n, sd)
end
end
end
handle:shown(n)
stats.eggs, stats.ready = n, readyN
end
function M.setEnabled(on)
on = on and true or false
if on == enabled then return true end
enabled = on
if not on then
if handle then handle:close() handle = nil end
if sc then sc:destroy() sc = nil end
recs, recsAt, recsDirty = nil, 0, true
table.clear(staticFor)
table.clear(slotData)
log.info("off")
return true
end
handle = cards.open("plot")
sc = BX.scope("features.esp.plot")
recsDirty = true
BX.try("esp.plot.watchOwner", function()
local ES = data.eggState()
for _, name in ipairs({ "OwnerRefreshed", "OwnerCleared" }) do
local sig = ES and ES[name]
if type(sig) == "table" and type(sig.Connect) == "function" then
sc:connect(sig, function() recsDirty = true end)
end
end
end)
sc:loop("update", dev.scale(K.RATE), update)
ch.onSpawn(sc, "esp.plot.respawn", function()
if handle then handle:shown(0) end
end)
log.info("on (%.2fs)", dev.scale(K.RATE))
return true
end
return M
end)
BX.module("features.misc.servers", function(BX)
local svc  = BX.require("core.services")
local exec = BX.require("core.exec")
local log  = BX.require("boot.log").for_module("servers")
local M = {}
local K = {
MAX_PAGES = 2, TRIES = 4,
PAGE_DELAY = 0.55,
CACHE_FOR = 25,
RATE_LIMIT_FOR = 20,
FAILED_FOR = 600,     
FAILED_MAX = 200,     
TP_SETTLE  = 2.5,
}
M.K = K
local searching = false
local rateLimitedUntil = 0
local cachedCandidates, cachedListed, cachedAt = nil, 0, 0
local failed, failedN = {}, 0
BX.profile.watch("servers.failed", function() return failedN end)
local function pruneFailed()
local now = os.clock()
local live, n = {}, 0
for id, at in pairs(failed) do
if (now - at) > K.FAILED_FOR then
failed[id] = nil
else
n = n + 1
live[n] = id
end
end
if n > K.FAILED_MAX then
table.sort(live, function(a, b) return failed[a] < failed[b] end)
for i = 1, n - K.FAILED_MAX do
failed[live[i]] = nil
end
n = K.FAILED_MAX
end
failedN = n
end
local function markFailed(id)
if not id then return end
failed[id] = os.clock()
pruneFailed()
end
local function canFetch()
if exec.can.request then return true end
local ok, f = pcall(function() return game.HttpGet end)
return ok and type(f) == "function"
end
local function fetchPage(cursor)
local now = os.clock()
if now < rateLimitedUntil then
return nil, ("rate limited - wait %ds"):format(math.ceil(rateLimitedUntil - now))
end
local url = ("https://games.roblox.com/v1/games/%d/servers/Public"
.. "?sortOrder=Asc&limit=100"):format(game.PlaceId)
if cursor then url = url .. "&cursor=" .. tostring(cursor) end
local body, via, status
if exec.can.request then
local res
BX.try("servers.fetch", function()
res = exec.httpRequest({ Url = url, Method = "GET" })
end)
body = res and (res.Body or res.body)
status = res and (res.StatusCode or res.status_code)
via = "request"
end
if not body then
local ok, got = pcall(function() return game:HttpGet(url) end)
if ok and type(got) == "string" then body, via = got, "HttpGet"
elseif not ok then status = tostring(got) end
end
if tonumber(status) == 429 then
local wasLimited = rateLimitedUntil > now
rateLimitedUntil = now + K.RATE_LIMIT_FOR
if not wasLimited then
log.warn("server list rate limited; pausing requests for %ds", K.RATE_LIMIT_FOR)
end
return nil, ("rate limited - wait %ds"):format(K.RATE_LIMIT_FOR)
end
if not body then
if tostring(status):find("429", 1, true) then
local wasLimited = rateLimitedUntil > now
rateLimitedUntil = now + K.RATE_LIMIT_FOR
if not wasLimited then
log.warn("server list rate limited; pausing requests for %ds", K.RATE_LIMIT_FOR)
end
return nil, ("rate limited - wait %ds"):format(K.RATE_LIMIT_FOR)
end
log.warn("server list: no response (via %s, %s)", tostring(via), tostring(status))
return nil, "no response"
end
local decoded
pcall(function() decoded = svc.HttpService:JSONDecode(body) end)
if type(decoded) ~= "table" or type(decoded.data) ~= "table" then
log.warn("server list: unreadable (via %s, status %s, %d bytes: %s)",
tostring(via), tostring(status), #body, body:sub(1, 80))
return nil, "unreadable list"
end
log.info("server list: page via %s, %d servers%s", via, #decoded.data,
decoded.nextPageCursor and ", more pages" or "")
return decoded
end
local function candidates()
pruneFailed()
local now = os.clock()
if cachedCandidates and (now - cachedAt) < K.CACHE_FOR then
local copy = table.create(#cachedCandidates)
for i, sv in ipairs(cachedCandidates) do copy[i] = sv end
log.info("candidates: using %ds cache (%d servers)",
math.floor(now - cachedAt), #copy)
return copy, cachedListed
end
local out, cursor = {}, nil
local here = tostring(game.JobId)
local listed, pages, why = 0, 0, nil
for pageN = 1, K.MAX_PAGES do
local page, err = fetchPage(cursor)
if not page then why = why or err break end
pages = pages + 1
for _, sv in ipairs(page.data) do
listed = listed + 1
local playing = tonumber(sv.playing) or 0
local maxP = tonumber(sv.maxPlayers) or 0
if sv.id and sv.id ~= here             
and not failed[sv.id]               
and maxP > 0 and playing < maxP     
then
out[#out + 1] = {
id = sv.id, playing = playing, maxPlayers = maxP,
ping = tonumber(sv.ping) or 0,
}
end
end
cursor = page.nextPageCursor
if not cursor then break end
if pageN < K.MAX_PAGES then task.wait(K.PAGE_DELAY) end
end
if pages > 0 then
cachedCandidates, cachedListed, cachedAt = table.clone(out), listed, now
end
log.info("candidates: %d of %d listed over %d page(s) (here=%s, failed cache=%d)",
#out, listed, pages, here:sub(1, 8), failedN)
return out, listed, why
end
local function teleport(sv)
local failedWhy = nil
local conn
pcall(function()
conn = svc.TeleportService.TeleportInitFailed:Connect(function(plr, result, msg)
if plr == svc.Players.LocalPlayer then
failedWhy = tostring(result) .. " " .. tostring(msg or "")
end
end)
end)
log.info("teleporting to %s (%d/%d players)", tostring(sv.id):sub(1, 8),
sv.playing, sv.maxPlayers)
pcall(function() BX.require("boot.log").flushNow() end)
local ok, err = pcall(function()
svc.TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.id,
svc.Players.LocalPlayer)
end)
if ok then
local t0 = os.clock()
while not failedWhy and (os.clock() - t0) < K.TP_SETTLE do task.wait(0.1) end
end
if conn then pcall(function() conn:Disconnect() end) end
if not ok or failedWhy then
markFailed(sv.id)
log.warn("teleport to %s failed: %s", tostring(sv.id):sub(1, 8),
tostring(failedWhy or err))
return false, failedWhy or err
end
log.info("teleport requested: %s (%d/%d players)", tostring(sv.id):sub(1, 8),
sv.playing, sv.maxPlayers)
return true
end
local function go(order, what)
if searching then return false, "Already searching" end
if not canFetch() then
log.warn("%s: no HTTP capability on this executor (request=%s)", what, tostring(exec.can.request))
return false, "Server search is not supported by this executor"
end
searching = true
log.info("%s: click", what)
local okRun, ok, msg = pcall(function()
local list, listed, why = candidates()
if #list == 0 then
if listed == 0 then
return false, "Could not read the server list" .. (why and (" (" .. why .. ")") or "")
end
return false, ("All %d listed servers are full or recently refused us"):format(listed)
end
table.sort(list, order)
local lastWhy
for i = 1, math.min(#list, K.TRIES) do
local sv = list[i]
local tpOk, tpWhy = teleport(sv)
if tpOk then
log.info("%s: joining %d/%d players (listed ping %s)", what, sv.playing, sv.maxPlayers, tostring(sv.ping))
if what == "ping" and sv.ping > 0 then
return true, ("Joining a server with %dms ping, %d players"):format(sv.ping, sv.playing)
end
return true, ("Joining a server with %d players"):format(sv.playing)
end
lastWhy = tpWhy
end
return false, "Teleport refused " .. math.min(#list, K.TRIES) .. " times"
.. (lastWhy and (" (" .. tostring(lastWhy) .. ")") or "") .. " - press again"
end)
searching = false
if not okRun then
log.warn("%s: failed: %s", what, tostring(ok))
return false, "Server search failed - see the log"
end
return ok, msg
end
function M.lowestServer()
return go(function(a, b)
if a.playing ~= b.playing then return a.playing < b.playing end
local ap = a.ping > 0 and a.ping or math.huge
local bp = b.ping > 0 and b.ping or math.huge
return ap < bp
end, "lowest")
end
function M.bestPing()
return go(function(a, b)
local ap = a.ping > 0 and a.ping or math.huge
local bp = b.ping > 0 and b.ping or math.huge
if ap ~= bp then return ap < bp end
return a.playing < b.playing
end, "ping")
end
function M.hop()
return go(function(a, b) return a.playing < b.playing end, "hop")
end
function M.rejoin()
if searching then return false, "Already switching servers" end
local plr = svc.Players.LocalPlayer
log.info("rejoin: click (job %s)", tostring(game.JobId):sub(1, 8))
pcall(function() BX.require("boot.log").flushNow() end)
local ok, err = pcall(function()
if #svc.Players:GetPlayers() <= 1 or game.JobId == "" then
svc.TeleportService:Teleport(game.PlaceId, plr)
else
svc.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
end
end)
if not ok then
log.warn("rejoin failed: %s", tostring(err))
return false, "Could not rejoin - try Server Hop"
end
return true, "Rejoining this server..."
end
function M.stats()
pruneFailed()
return { failedServers = failedN, searching = searching }
end
return M
end)
BX.module("features.misc.webhook", function(BX)
local svc  = BX.require("core.services")
local exec = BX.require("core.exec")
local util = BX.require("core.util")
local log  = BX.require("boot.log").for_module("webhook")
local M = {}
local K = { MIN_GAP = 3.0, TIMEOUT = 8 }
M.K = K
local enabled = false
local enabledPersisted = false
local url = nil              
local lastSend = 0
local stats = { sent = 0, failed = 0, dropped = 0, skipped = 0 }
function M.stats() return table.clone(stats) end
function M.isOn() return enabled end
function M.hasUrl() return url ~= nil and url ~= "" end
function M.redactedUrl()
if not M.hasUrl() then return "not set" end
local host = tostring(url):match("^https?://([^/]+)") or "?"
return ("%s/...(%d chars)"):format(host, #url)
end
local ENABLE_FILE = "VoidcxzHub/webhook-state.txt"
local function rememberEnabled(v)
if not exec.can.files then return end
BX.try("webhook.rememberEnabled", function()
exec.ensureFolder("VoidcxzHub")
exec.writeFile(ENABLE_FILE, v and "1" or "0")
end)
end
function M.setEnabled(on, quiet)
enabled = on and true or false
if not quiet then
enabledPersisted = true
rememberEnabled(enabled)
end
log.info("%s (url %s)", enabled and "enabled" or "disabled", M.redactedUrl())
return true
end
function M.applyProfileEnabled(on)
if enabledPersisted then return enabled end
return M.setEnabled(on, true)
end
local URL_FILE = "VoidcxzHub/webhook.txt"
local function remember(v)
if not exec.can.files then return end
BX.try("webhook.remember", function()
if v == nil or v == "" then
if exec.isFile(URL_FILE) then exec.deleteFile(URL_FILE) end
return
end
exec.ensureFolder("VoidcxzHub")
exec.writeFile(URL_FILE, v)
end)
end
function M.setUrl(v, quiet)
v = tostring(v or ""):gsub("%s", "")
if v == "" then
url = nil
if not quiet then remember(nil) end
log.info("url cleared")
return true, "URL cleared"
end
if not v:match("^https://") then
return false, "That does not look like a webhook URL"
end
url = v
if not quiet then
remember(v)
if not enabled then M.setEnabled(true) end
end
log.info("url set (%s)", M.redactedUrl())
return true, "Webhook URL saved"
end
BX.try("webhook.restore", function()
if not exec.can.files or not exec.isFile(URL_FILE) then return end
local saved = exec.readFile(URL_FILE)
if type(saved) == "string" and saved:match("^https://") then
M.setUrl(saved, true)
log.info("url restored from %s (%s)", URL_FILE, M.redactedUrl())
end
end)
BX.try("webhook.restoreEnabled", function()
if not exec.can.files or not exec.isFile(ENABLE_FILE) then return end
local saved = exec.readFile(ENABLE_FILE)
if saved == "1" then enabledPersisted = true; M.setEnabled(true, true)
elseif saved == "0" then enabledPersisted = true; M.setEnabled(false, true) end
end)
function M.finishProfileRestore()
if not enabledPersisted and M.hasUrl() then
M.setEnabled(true, false)
log.info("enabled from saved webhook URL (legacy profile fallback)")
end
return enabled
end
local function embedFor(e)
local fields = {}
local function add(name, value)
if value == nil or value == "" then return end
fields[#fields + 1] = { name = name, value = tostring(value), inline = true }
end
local mutation = e.mutation or e.mutations
if type(mutation) == "table" then
local out = {}
for key, value in pairs(mutation) do
if value == true then out[#out + 1] = tostring(key)
elseif type(value) == "string" and value ~= "" then out[#out + 1] = value
elseif type(key) == "number" and value ~= nil then out[#out + 1] = tostring(value) end
end
table.sort(out)
mutation = #out > 0 and table.concat(out, ", ") or nil
end
local income = tonumber(e.value)
local weight = tonumber(e.kg)
add("Income", (income and (util.short(income) .. "/s")) or nil)
add("Weight", weight and weight > 0 and ("%.1f kg"):format(weight) or nil)
add("Rarity", e.rarity ~= "?" and e.rarity or nil)
add("Mutation", mutation)
add("Area", e.areaId)
return {
username = "VoidcxzHub",
embeds = { {
title = "Egg delivered",
description = "**" .. tostring(e.name or "Egg") .. "**",
color = 5814783,
fields = fields,
footer = { text = "VoidcxzHub V6" },
timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
} },
}
end
local function post(payload, tag)
if not exec.can.request then
stats.skipped = stats.skipped + 1
log.warn("no HTTP request capability - nothing sent")
return false
end
local body
local okEnc = pcall(function() body = svc.HttpService:JSONEncode(payload) end)
if not okEnc or not body then
stats.failed = stats.failed + 1
return false
end
local res
local ok = BX.try("webhook.post", function()
res = exec.httpRequest({
Url = url, Method = "POST",
Headers = { ["Content-Type"] = "application/json" },
Body = body,
})
end)
local code = res and (res.StatusCode or res.status_code)
if ok and code and code >= 200 and code < 300 then
stats.sent = stats.sent + 1
log.info("%s sent (HTTP %s)", tag, tostring(code))
return true
end
stats.failed = stats.failed + 1
log.warn("%s failed (HTTP %s)", tag, tostring(code or "no response"))
return false
end
function M.onDelivered(e)
if not enabled or not M.hasUrl() or type(e) ~= "table" then return end
local now = os.clock()
if now - lastSend < K.MIN_GAP then
stats.dropped = stats.dropped + 1
return
end
lastSend = now
task.spawn(function()
BX.try("webhook.delivered", function()
post(embedFor(e), "delivery")
end)
end)
end
function M.test()
if not M.hasUrl() then return false, "Set a webhook URL first" end
if not enabled then M.setEnabled(true) end
task.spawn(function()
BX.try("webhook.test", function()
post({
username = "VoidcxzHub",
embeds = { {
title = "Test",
description = "Webhook is working.",
color = 5814783,
footer = { text = "VoidcxzHub " .. tostring(BX.version) },
timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
} },
}, "test")
end)
end)
return true, "Test sent"
end
return M
end)
BX.module("features.gamethrottle", function(BX)
local svc  = BX.require("core.services")
local st   = BX.require("core.state")
local exec = BX.require("core.exec")
local log  = BX.require("boot.log").for_module("gamethrottle")
local M = {}
local K = {
PETS_HZ    = 20,
PROMPTS_HZ = 10,
}
M.K = K
local env = (type(getgenv) == "function" and getgenv()) or _G
local ENV_KEY = "__VOIDCXZ_THROTTLE"
local enabled = false
local stats = { pets = false, prompts = false, petSteps = 0, petSkips = 0,
promptSteps = 0, promptSkips = 0 }
function M.isOn() return enabled end
function M.stats() return table.clone(stats) end
local function petsClass()
local mod
pcall(function()
mod = svc.Players.LocalPlayer.PlayerScripts.Game.Plots
.ActiveAssetsController.AssetMovementBatch
end)
if not (mod and mod:IsA("ModuleScript")) then return nil end
local ok, cls = pcall(require, mod)
if ok and type(cls) == "table" and type(rawget(cls, "_step")) == "function" then
return cls
end
return nil
end
local function followerAdvance()
if exec.fragile then return nil end
local getups = (debug and debug.getupvalues) or rawget(env, "getupvalues")
if type(getups) ~= "function" then return nil end
local mod = svc.ReplicatedStorage:FindFirstChild("Client")
mod = mod and mod:FindFirstChild("SmartProximityPrompt")
mod = mod and mod:FindFirstChild("FollowerLoop")
if not (mod and mod:IsA("ModuleScript")) then return nil end
local ok, lib = pcall(require, mod)
if not ok or type(lib) ~= "table" or type(lib.Add) ~= "function" then return nil end
local okU, ups = pcall(getups, lib.Add)
if not okU or type(ups) ~= "table" then return nil end
for _, u in pairs(ups) do
if type(u) == "function" then
local okN, name = pcall(debug.info, u, "n")
if okN and name == "advance" then return u end
end
end
return nil
end
local function restore(rec, why)
if type(rec) ~= "table" then return end
if rec.cls and rec.step then
pcall(rawset, rec.cls, "_step", rec.step)
end
if rec.advance and rec.advanceOrig and type(hookfunction) == "function" then
pcall(hookfunction, rec.advance, rec.advanceOrig)
end
log.info("restored game loops (%s)", tostring(why))
end
if type(env[ENV_KEY]) == "table" then
local stale = env[ENV_KEY]
env[ENV_KEY] = nil
BX.try("throttle.restoreStale", restore, stale, "previous copy")
end
function M.setEnabled(on)
on = on and true or false
if on == enabled then return true end
if not on then
enabled = false
restore(env[ENV_KEY], "toggled off")
env[ENV_KEY] = nil
stats.pets, stats.prompts = false, false
return true
end
enabled = true
local rec = {}
env[ENV_KEY] = rec
BX.try("throttle.pets", function()
if exec.fragile then log.info("fragile executor - game loops left alone") return end
local cls = petsClass()
if not cls then log.info("pet movement batch not found - left alone") return end
local orig = rawget(cls, "_step")
local period = 1 / K.PETS_HZ
local acc = setmetatable({}, { __mode = "k" })
rec.cls, rec.step = cls, orig
rawset(cls, "_step", function(self, dt)
local a = (acc[self] or 0) + (tonumber(dt) or 0)
if a < period then
acc[self] = a
stats.petSkips = stats.petSkips + 1
return
end
acc[self] = 0
stats.petSteps = stats.petSteps + 1
return orig(self, a)
end)
stats.pets = true
end)
BX.try("throttle.prompts", function()
if not exec.can.hooking or type(hookfunction) ~= "function" then
log.info("no hookfunction - prompt follower left alone")
return
end
local advance = followerAdvance()
if not advance then log.info("prompt follower not found - left alone") return end
local period = 1 / K.PROMPTS_HZ
local acc = 0
local orig
local function throttled(dt)
dt = tonumber(dt) or 0
if st.autoStealOn then
acc = 0
return orig(dt)
end
acc = acc + dt
if acc < period then
stats.promptSkips = stats.promptSkips + 1
return
end
local d = acc
acc = 0
stats.promptSteps = stats.promptSteps + 1
return orig(d)
end
orig = hookfunction(advance, throttled)
rec.advance, rec.advanceOrig = advance, orig
stats.prompts = true
end)
log.info("on (pets %s @%dHz, prompts %s @%dHz)",
tostring(stats.pets), K.PETS_HZ, tostring(stats.prompts), K.PROMPTS_HZ)
return true
end
return M
end)
BX.module("features.fps", function(BX)
local svc = BX.require("core.services")
local log = BX.require("boot.log").for_module("fps")
local scan = BX.require("core.scan")
local M = {}
local K = {
BUDGET      = 0.002,  
MESH_PER_FRAME = 12,  
GUI_SURFACE = 150,    
PRUNE_EVERY = 30,     
DEFER       = 5.0,    
MAX_BOOST   = 40000,  
GUI_DISTANCE = 120,   
MAX_POTATO  = 400000, 
}
M.K = K
local env = (type(getgenv) == "function" and getgenv()) or _G
local exec = BX.require("core.exec")
if exec.fragile then
K.BUDGET, K.DEFER = 0.001, 8.0
K.MESH_PER_FRAME = 4
end
local MESH_LOD = BX.require("core.config").FPS_MESH_LOD == true and not exec.fragile
local function newRecord()
return { objs = {}, keys = {}, was = {}, n = 0 }
end
local function restoreRecord(rec, why)
if type(rec) ~= "table" then return 0 end
local put = 0
if type(rec.props) == "table" then
for i = #rec.props, 1, -1 do
local e = rec.props[i]
if e and e.obj and pcall(function() e.obj[e.key] = e.was end) then put = put + 1 end
rec.props[i] = nil
end
log.info("restored %d properties (%s, previous build)", put, tostring(why))
return put
end
if type(rec.objs) ~= "table" then return 0 end
for i = rec.n or #rec.objs, 1, -1 do
local obj, key = rec.objs[i], rec.keys[i]
if obj ~= nil and key ~= nil then
if pcall(function() obj[key] = rec.was[i] end) then put = put + 1 end
end
rec.objs[i], rec.keys[i], rec.was[i] = nil, nil, nil
end
rec.n = 0
log.info("restored %d properties (%s)", put, tostring(why))
return put
end
local function fences()
local esp = workspace:FindFirstChild("VoidcxzESP")
local plr = svc.Players.LocalPlayer
return esp, plr and plr.Character
end
local function offLimits(d, esp, char)
if esp and d:IsDescendantOf(esp) then return true end
if char and d:IsDescendantOf(char) then return true end
return false
end
local function makeTier(def)
local T = { enabled = false, sweeping = false, rec = nil, sc = nil,
stats = { changed = 0, added = 0, pruned = 0, refused = 0, sweepMs = 0, seen = 0 } }
if type(env[def.envKey]) == "table" then
local stale = env[def.envKey]
env[def.envKey] = nil
BX.try("fps.restoreStale." .. def.name, function()
restoreRecord(stale, def.name .. ": previous copy, before re-applying")
end)
end
local function set(obj, key, value)
local rec = T.rec
if not rec then return false end
if rec.n >= def.cap then
T.stats.refused = T.stats.refused + 1
if T.stats.refused == 1 then
log.warn("%s: tracking ceiling of %d reached - further instances left as they are",
def.name, def.cap)
end
return false
end
local was
if not pcall(function() was = obj[key] end) then return false end
if was == value then return false end
if not pcall(function() obj[key] = value end) then return false end
local n = rec.n + 1
rec.n = n
rec.objs[n], rec.keys[n], rec.was[n] = obj, key, was
T.stats.changed = T.stats.changed + 1
return true
end
local function handle(d, esp, char)
local ok = pcall(def.match, d, set, esp, char, T)
return ok
end
local function sweep()
if T.sweeping then return end
T.sweeping = true
local t0 = os.clock()
local before = T.stats.changed
local esp, char = fences()
for _, d in ipairs(scan.snapshot(svc.Lighting, K.BUDGET)) do handle(d, esp, char) end
local desc = M._snapshot
if not desc or (os.clock() - (M._snapshotAt or 0)) > 60 then
desc = scan.snapshot(workspace, K.BUDGET)
M._snapshot, M._snapshotAt = desc, os.clock()
end
local total = #desc
T.stats.seen = total
local function stealBusy()
local ok, busy = BX.try("fps.stealBusy", function()
local auto = BX._loaded["features.autosteal"]
return auto and auto.isRunning() and auto.isBusy()
end)
return ok and busy == true
end
local i = 1
while i <= total do
while stealBusy() and T.enabled and T.sc and T.sc:alive() do
svc.RunService.Heartbeat:Wait()
end
esp, char = fences()
local f0 = os.clock()
T.meshBudget = K.MESH_PER_FRAME
for j = i, total do
local d = desc[j]
if d then handle(d, esp, char) end
i = j + 1
if (os.clock() - f0) >= K.BUDGET then break end
end
svc.RunService.Heartbeat:Wait()
if not T.enabled or not (T.sc and T.sc:alive()) then break end
end
desc = nil
if def.name == "potato" then M._snapshot = nil end
while T.deferMesh and #T.deferMesh > 0 and T.enabled and T.sc and T.sc:alive() do
while stealBusy() and T.enabled and T.sc and T.sc:alive() do
svc.RunService.Heartbeat:Wait()
end
local esp2, char2 = fences()
for _ = 1, K.MESH_PER_FRAME do
local d = table.remove(T.deferMesh)
if not d then break end
if d.Parent and not offLimits(d, esp2, char2) then
set(d, "RenderFidelity", Enum.RenderFidelity.Performance)
end
end
svc.RunService.Heartbeat:Wait()
end
T.deferMesh = nil
T.stats.sweepMs = (os.clock() - t0) * 1000
T.sweeping = false
log.info("%s sweep: %d descendants, %d properties changed, %.0fms",
def.name, total, T.stats.changed - before, T.stats.sweepMs)
if def.afterSweep and T.enabled then BX.try("fps.afterSweep." .. def.name, def.afterSweep) end
end
function T.setEnabled(on)
on = on and true or false
if on == T.enabled then return true end
T.enabled = on
if not on then
if T.sc then T.sc:destroy() T.sc = nil end
if def.onOff then BX.try("fps.onOff." .. def.name, def.onOff) end
local put = restoreRecord(T.rec, def.name .. " toggled off")
T.rec = nil
env[def.envKey] = nil
T.stats.changed = 0
log.info("%s off (%d properties restored)", def.name, put)
return true
end
T.rec = newRecord()
env[def.envKey] = T.rec      
T.sc = BX.scope("features.fps." .. def.name)
if def.globals then BX.try("fps.globals." .. def.name, def.globals, set) end
if def.onOn then BX.try("fps.onOn." .. def.name, def.onOn) end
T.sc:spawn("sweep", sweep)
local function added(d)
if not T.enabled then return end
local esp, char = fences()
local n0 = T.stats.changed
handle(d, esp, char)
if T.stats.changed > n0 then T.stats.added = T.stats.added + 1 end
end
T.sc:connect(workspace.DescendantAdded, BX.guard("fps.added." .. def.name, added))
T.sc:connect(svc.Lighting.DescendantAdded, BX.guard("fps.addedLighting." .. def.name, added))
T.sc:loop("prune", K.PRUNE_EVERY, function()
local rec = T.rec
if not rec then return end
local objs, keys, was = rec.objs, rec.keys, rec.was
local keep, dropped = 0, 0
for idx = 1, rec.n do
local obj = objs[idx]
local gone = obj == nil or (typeof(obj) == "Instance" and obj.Parent == nil)
if gone then
dropped = dropped + 1
else
keep = keep + 1
objs[keep], keys[keep], was[keep] = obj, keys[idx], was[idx]
end
end
for idx = keep + 1, rec.n do objs[idx], keys[idx], was[idx] = nil, nil, nil end
rec.n = keep
if dropped > 0 then
T.stats.pruned = T.stats.pruned + dropped
log.trace("%s: pruned %d destroyed (%d tracked)", def.name, dropped, keep)
end
end)
log.info("%s on", def.name)
return true
end
function T.snapshot()
local s = table.clone(T.stats)
s.on = T.enabled
s.tracked = T.rec and T.rec.n or 0
return s
end
BX.onTeardown("fps." .. def.name, function() T.setEnabled(false) end)
return T
end
local EFFECTS = {
ParticleEmitter = true, Trail = true, Beam = true,
Smoke = true, Fire = true, Sparkles = true,
}
local POST = {
BloomEffect = true, BlurEffect = true, ColorCorrectionEffect = true,
SunRaysEffect = true, DepthOfFieldEffect = true,
}
local LIGHTS = { PointLight = true, SpotLight = true, SurfaceLight = true }
BX.try("fps.throttleStale", function() BX.require("features.gamethrottle") end)
local boost = makeTier({
name = "boost", envKey = "__VOIDCXZ_FPS", cap = K.MAX_BOOST,
match = function(d, set, esp, char, T)
local cls = d.ClassName
if EFFECTS[cls] then
if not offLimits(d, esp, char) then set(d, "Enabled", false) end
elseif POST[cls] then
set(d, "Enabled", false)
elseif cls == "Clouds" then
set(d, "Enabled", false)
elseif cls == "Atmosphere" then
set(d, "Density", 0)
set(d, "Haze", 0)
set(d, "Glare", 0)
elseif LIGHTS[cls] then
if not offLimits(d, esp, char) then set(d, "Shadows", false) end
elseif cls == "MeshPart" then
if MESH_LOD and not offLimits(d, esp, char) and d.RenderFidelity ~= Enum.RenderFidelity.Performance then
local left = T and T.meshBudget
if left ~= nil then
if left <= 0 then
T.deferMesh = T.deferMesh or {}
T.deferMesh[#T.deferMesh + 1] = d
return
end
T.meshBudget = left - 1
end
set(d, "RenderFidelity", Enum.RenderFidelity.Performance)
end
elseif cls == "BillboardGui" then
if not offLimits(d, esp, char) then
local md = d.MaxDistance
if md == 0 or md > K.GUI_DISTANCE then set(d, "MaxDistance", K.GUI_DISTANCE) end
end
elseif cls == "SurfaceGui" then
if not offLimits(d, esp, char) then
local md = d.MaxDistance
if md == 0 or md > K.GUI_SURFACE then set(d, "MaxDistance", K.GUI_SURFACE) end
end
elseif cls == "Highlight" then
if not offLimits(d, esp, char) then set(d, "Enabled", false) end
elseif cls == "Explosion" then
set(d, "Visible", false)
end
end,
globals = function(set)
set(svc.Lighting, "GlobalShadows", false)
local ter = workspace:FindFirstChildOfClass("Terrain")
if ter then
set(ter, "Decoration", false)
set(ter, "WaterWaveSize", 0)
set(ter, "WaterWaveSpeed", 0)
set(ter, "WaterReflectance", 0)
set(ter, "WaterTransparency", 0)
end
set(svc.Lighting, "EnvironmentDiffuseScale", 0)
set(svc.Lighting, "EnvironmentSpecularScale", 0)
set(svc.Lighting, "ShadowSoftness", 0)
local sky = svc.Lighting:FindFirstChildOfClass("Sky")
if sky then
set(sky, "CelestialBodiesShown", false)
set(sky, "StarCount", 0)
end
if exec.fragile then return end
local okR, r = pcall(function() return settings().Rendering end)
if okR and r then
set(r, "QualityLevel", Enum.QualityLevel.Level01)
pcall(function() set(r, "EditQualityLevel", Enum.QualityLevel.Level01) end)
pcall(function() set(r, "MeshPartDetailLevel", Enum.MeshPartDetailLevel.Level04) end)
end
pcall(function()
local ugs = UserSettings():GetService("UserGameSettings")
set(ugs, "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
end)
end,
onOn = function()
BX.require("features.gamethrottle").setEnabled(true)
end,
afterSweep = function()
if M.wantAll and not M._potato.enabled then M._potato.setEnabled(true) end
end,
onOff = function()
BX.require("features.gamethrottle").setEnabled(false)
end,
})
local TEXTURED = { Decal = true, Texture = true }
local potato = makeTier({
name = "potato", envKey = "__VOIDCXZ_FPS_POTATO", cap = K.MAX_POTATO,
match = function(d, set, esp, char)
local cls = d.ClassName
if TEXTURED[cls] then
if not offLimits(d, esp, char) then set(d, "Transparency", 1) end
elseif cls == "SpecialMesh" then
if not offLimits(d, esp, char) then set(d, "TextureId", "") end
elseif cls == "MeshPart" then
if d.TextureID ~= "" and not offLimits(d, esp, char) then set(d, "TextureID", "") end
elseif cls ~= "Terrain" and d:IsA("BasePart") then
if d.Reflectance ~= 0 and not offLimits(d, esp, char) then set(d, "Reflectance", 0) end
end
end,
})
M._potato = potato
function M.isOn() return boost.enabled end
function M.setEnabled(on)
on = on and true or false
M.wantAll = on
if not on then
M.userTurnedOff = true
potato.setEnabled(false)
return boost.setEnabled(false)
end
return boost.setEnabled(true)
end
function M.stats()
local b, p = boost.snapshot(), potato.snapshot()
return {
boost = b, potato = p,
effects = b.changed, tracked = b.tracked + p.tracked, sweepMs = b.sweepMs + p.sweepMs,
}
end
BX.profile.watch("fps.tracked", function()
return (boost.rec and boost.rec.n or 0) + (potato.rec and potato.rec.n or 0)
end)
local armed = false
function M.arm()
if armed then return false end
armed = true
task.delay(K.DEFER, function()
if not BX.alive() then return end
if boost.enabled or M.userTurnedOff then return end
BX.try("fps.armApply", function() M.setEnabled(true) end)
end)
return true
end
return M
end)
BX.module("features.boss", function(BX)
local svc = BX.require("core.services")
local exec = BX.require("core.exec")
local dev = BX.require("core.device")
local net = BX.require("core.net")
local log = BX.require("boot.log").for_module("boss")
local M = {}
local K = {
SNAP_TTL  = 5,
BACKSTOP  = 30,
ENTER_GAP = 1.0,
RETRY     = { 5, 10, 20 },
}
M.K = K
local sc, enabled = nil, false
local snap, snapAt = nil, 0
local retryN, retryArmed = 0, false
local autoEnter = false
local stats = { asks = 0, enters = 0, entersRefused = 0, claims = 0,
stateEvents = 0, autoEntered = 0 }
function M.stats() return table.clone(stats) end
function M.isOn() return enabled end
function M.autoEnterOn() return autoEnter end
local listeners = {}
function M.onChange(fn) listeners[#listeners + 1] = fn end
local function fireChange()
for _, fn in ipairs(listeners) do
task.spawn(function() BX.try("boss.onChange", fn) end)
end
end
function M.snapshot(force)
if not enabled then return nil end
local now = os.clock()
if not force and snap and (now - snapAt) < K.SNAP_TTL then return snap end
stats.asks = stats.asks + 1
local st = net.call("RF/BossEvent/AskSnapshot")
snapAt = now
if type(st) == "table" then snap = st end
return snap
end
function M.isOpen()
local s = M.snapshot()
return (s and s.Open == true) or false
end
function M.held() return snap end
local function clock(seconds)
seconds = math.max(0, math.floor(seconds or 0))
local h = math.floor(seconds / 3600)
local m = math.floor(seconds / 60) % 60
if h > 0 then return ("%dh %02dm"):format(h, m) end
if m > 0 then return ("%dm %02ds"):format(m, seconds % 60) end
return ("%ds"):format(seconds)
end
function M.status()
if not enabled then return { title = "Abyss Overlord", body = "Off" } end
local s = snap
if not s then
return { title = "Abyss Overlord", body = (stats.asks > 0)
and "Can't read it - retrying"
or "Reading..." }
end
local nowSrv = workspace:GetServerTimeNow()
if s.Open == true then
local left = (tonumber(s.ClosesAt) or 0) - nowSrv
return { title = "Abyss Overlord",
body = ("Open  \u{B7}  closes in %s"):format(clock(left)) }
end
local until_ = (tonumber(s.OpensAt) or 0) - nowSrv
if until_ > 0 then
return { title = "Abyss Overlord",
body = ("Opens in %s"):format(clock(until_)) }
end
return { title = "Abyss Overlord", body = "Closed" }
end
function M.refresh()
if not enabled then return false end
task.spawn(function()
BX.try("boss.refresh", function()
M.snapshot(true)
fireChange()
end)
end)
return true
end
local function readOrRetry()
local st = M.snapshot(true)
if st then
retryN = 0
return st
end
if retryArmed or not sc then return nil end
local wait = K.RETRY[retryN + 1]
if not wait then return nil end
retryArmed = true
log.warn("boss read failed - retrying in %ds", wait)
sc:delay("retry", dev.scale(wait), function()
retryArmed = false
retryN = retryN + 1
if readOrRetry() then fireChange() end
end)
return nil
end
function M.enter()
stats.enters = stats.enters + 1
local accepted, msg = net.call("RF/BossEvent/AskEnter")
log.info("AskEnter -> accepted=%s msg=%s", tostring(accepted), tostring(msg))
if accepted == true then
return true, "Entering the boss world"
end
stats.entersRefused = stats.entersRefused + 1
if msg and tostring(msg):find("defeated") then
return false, "Boss already defeated - waiting for the next one"
end
return false, tostring(msg or "Refused")
end
function M.setAutoEnter(on)
autoEnter = on and true or false
log.info("auto enter %s", autoEnter and "ON" or "OFF")
if autoEnter and enabled and M.isOpen() then
task.spawn(function()
BX.try("boss.autoEnterNow", function()
local ok, why = M.enter()
if ok then stats.autoEntered = stats.autoEntered + 1 end
log.info("auto enter (already open) -> %s %s", tostring(ok), tostring(why))
end)
end)
end
return true
end
function M.claimMilestones()
local BM
local okReq = BX.try("boss.requireMastery", function()
local mod = svc.ReplicatedStorage:FindFirstChild("Data")
mod = mod and mod:FindFirstChild("BossMastery")
if mod and mod:IsA("ModuleScript") then BM = exec.requireGame(mod) end
end)
if not okReq or type(BM) ~= "table" then
log.warn("Data.BossMastery unavailable - cannot claim")
return 0, "Could not read the mastery list"
end
local ids = {}
for _, m in pairs(BM.Milestones or {}) do
if type(m) == "table" and m.Id then ids[#ids + 1] = tostring(m.Id) end
end
if BM.InfiniteMilestoneId then ids[#ids + 1] = tostring(BM.InfiniteMilestoneId) end
local claimed = 0
for _, id in ipairs(ids) do
local got, msg = net.call("RF/BossMastery/AskClaimMilestone", id)
if got == true then
claimed = claimed + 1
log.info("claimed milestone %s", id)
elseif msg and not tostring(msg):find("Not enough") then
log.trace("milestone %s -> %s", id, tostring(msg))
end
task.wait(0.15)
end
stats.claims = stats.claims + claimed
return claimed, claimed > 0 and ("Claimed " .. claimed) or "Nothing to claim yet"
end
function M.setEnabled(on)
on = on and true or false
if on == enabled then return true end
if not on then
enabled = false
autoEnter = false
if sc then sc:destroy() sc = nil end
snap, snapAt = nil, 0
retryN, retryArmed = 0, false
log.info("off (%d snapshot reads this session)", stats.asks)
fireChange()
return true
end
sc = BX.scope("features.boss")
enabled = true
BX.try("boss.watchState", function()
local re = net.find("RE/BossEvent/StateShifted")
if not re then
log.warn("RE/BossEvent/StateShifted not found - running on the backstop")
return
end
sc:connect(re.OnClientEvent, function()
stats.stateEvents = stats.stateEvents + 1
task.spawn(function()
BX.try("boss.stateShifted", function()
local was = snap and snap.Open
M.snapshot(true)
local isOpen = snap and snap.Open
log.info("state shifted: open %s -> %s",
tostring(was), tostring(isOpen))
fireChange()
if autoEnter and isOpen == true and was ~= true then
task.wait(K.ENTER_GAP)
local ok, why = M.enter()
if ok then stats.autoEntered = stats.autoEntered + 1 end
log.info("auto enter on open -> %s %s",
tostring(ok), tostring(why))
end
end)
end)
end)
end)
sc:loop("backstop", dev.scale(K.BACKSTOP), function()
local had, was = snap ~= nil, snap and snap.Open
readOrRetry()
if not had or (snap and snap.Open) ~= was then fireChange() end
end)
log.info("on (StateShifted event + %.0fs backstop)", dev.scale(K.BACKSTOP))
return true
end
return M
end)
BX.module("features.rift", function(BX)
local svc  = BX.require("core.services")
local exec = BX.require("core.exec")
local dev  = BX.require("core.device")
local data = BX.require("core.data")
local net  = BX.require("core.net")
local eggs = BX.require("features.eggs")
local log  = BX.require("boot.log").for_module("rift")
local M = {}
local K = {
BACKSTOP    = 30,
SNAP_TTL    = 5,
STALE_MAX   = 8,
DEBOUNCE    = 0.35,
RETRY       = { 5, 10, 20 },
NONE_LABEL  = "No pets spawned",
}
M.K = K
local sc        = nil
local enabled   = false
local snap, snapAt, snapOkAt = nil, 0, 0
local retryN, retryArmed = 0, false
local fieldIds  = nil      
local ownedHave, ownedMiss = nil, nil
local pick      = nil      
local labelToId = {}
local dirty     = false
local stats = {
askState = 0, askFailed = 0, repaints = 0, coalesced = 0,
rotations = 0, pickCleared = 0,
}
function M.stats() return table.clone(stats) end
function M.isOn() return enabled end
local listeners = {}
function M.onChange(fn) listeners[#listeners + 1] = fn end
local function fireChange()
stats.repaints = stats.repaints + 1
for _, fn in ipairs(listeners) do
task.spawn(function() BX.try("rift.onChange", fn) end)
end
end
function M.petName(id)
local dir = data.assetsDir()
local cfg = dir and dir[id]
return (cfg and cfg.DisplayName and tostring(cfg.DisplayName)) or tostring(id)
end
function M.state(force)
if not enabled then return nil end
local now = os.clock()
if not force and snap and (now - snapAt) < K.SNAP_TTL then
return snap
end
stats.askState = stats.askState + 1
local st = net.call("RF/Rift/AskState")
snapAt = now
if type(st) == "table" then
snap, snapOkAt = st, now
return snap
end
stats.askFailed = stats.askFailed + 1
if (now - snapOkAt) > K.STALE_MAX then
snap = nil
end
return snap
end
function M.requirements()
local st = M.state()
local reqs = st and st.Requirements
if type(reqs) ~= "table" then return {} end
return reqs
end
local function computeOwned()
local reqs = M.requirements()
if #reqs == 0 then
ownedHave, ownedMiss = nil, nil
return
end
local counts = nil
BX.try("rift.readInventory", function()
local profile = data.profile()
local inv = profile and profile.Inventory
if type(inv) ~= "table" then return end
counts = {}
for _, row in pairs(inv) do
local cat = type(row) == "table" and row.Category or nil
if cat then counts[cat] = (counts[cat] or 0) + 1 end
end
end)
if not counts then
ownedHave, ownedMiss = nil, nil
return
end
local have, missing = 0, {}
for _, id in ipairs(reqs) do
if (counts[id] or 0) > 0 then
have = have + 1
else
missing[#missing + 1] = id
end
end
ownedHave, ownedMiss = have, missing
end
function M.owned()
if ownedHave == nil and ownedMiss == nil then computeOwned() end
return ownedHave, ownedMiss
end
local function computeField()
local reqs = M.requirements()
if #reqs == 0 then
fieldIds = nil
return
end
local want = {}
for _, id in ipairs(reqs) do want[id] = true end
local list = eggs.list()
if not list then
fieldIds = nil
return
end
local seen, out = {}, {}
for _, e in ipairs(list) do
local cat = e.assetCategory
if cat and want[cat] and not seen[cat] then
seen[cat] = true
out[#out + 1] = cat
end
end
fieldIds = out
end
function M.onField()
if not enabled then return {} end
if not fieldIds then computeField() end
return fieldIds or {}
end
function M.petIsOut(id)
if not id then return false end
for _, out in ipairs(M.onField()) do
if out == id then return true end
end
return false
end
function M.options()
local out = {}
labelToId = {}
for _, id in ipairs(fieldIds or {}) do
local label = M.petName(id)
labelToId[label] = id
out[#out + 1] = label
end
if #out == 0 then out[1] = K.NONE_LABEL end
return out
end
function M.idForLabel(label)
if type(label) ~= "string" or label == K.NONE_LABEL then return nil end
return labelToId[label] or label
end
function M.pick() return pick end
function M.setPick(id)
pick = id
if id then
log.info("targeting %s", M.petName(id))
else
log.info("targeting any required rift pet")
end
end
local function prunePick()
if not pick then return false end
if M.petIsOut(pick) then return false end
stats.pickCleared = stats.pickCleared + 1
log.info("%s is no longer out - clearing the pick", M.petName(pick))
pick = nil
return true
end
function M.status()
if not enabled then return { title = "Rift", body = "Off" } end
local st = snap
if not st then
return { title = "Rift", body = (stats.askState > 0)
and "Can't read it - retrying"
or "Reading..." }
end
if st.Unlocked == false then
local need = tonumber(st.UnlockSpeedPower)
return {
title = "Rift",
body = need
and ("Unlocks at " .. eggs.formatRate(need) .. " speed")
or "Locked",
}
end
local reqs = st.Requirements or {}
local have, missing = ownedHave, ownedMiss
local banner = tostring(st.BannerDisplayName or st.BannerId or "Rift")
local secs = (tonumber(st.SecondsUntilRotation) or 0) - (os.clock() - snapOkAt)
local mins = math.max(0, math.floor(secs / 60))
local title = have and ("%s  %d/%d"):format(banner, have, #reqs) or banner
local tail = ("new rift in %dm"):format(mins)
if have and #reqs > 0 and have >= #reqs then
return { title = title, body = ("All pets ready  \u{B7}  %s"):format(tail) }
end
local want = (missing and #missing > 0) and missing or reqs
if #want == 0 then
return { title = title, body = tail:sub(1, 1):upper() .. tail:sub(2) }
end
local outSet = {}
for _, id in ipairs(fieldIds or {}) do outSet[id] = true end
local ready = {}
for _, id in ipairs(want) do
if outSet[id] then ready[#ready + 1] = M.petName(id) end
end
local body
if #ready > 0 then
body = (#ready == 1) and ("Steal %s now"):format(ready[1])
or ("Steal %d pets now"):format(#ready)
elseif #want == 1 then
body = ("Waiting for %s"):format(M.petName(want[1]))
else
body = ("Waiting for %d pets"):format(#want)
end
return { title = title, body = ("%s  \u{B7}  %s"):format(body, tail) }
end
function M.eligible()
if not enabled then return false end
local have, missing = M.owned()
if have and #M.requirements() > 0 and have >= #M.requirements() then
return false
end
local need = {}
for _, id in ipairs((missing and #missing > 0) and missing or M.requirements()) do
need[id] = true
end
if pick then return M.petIsOut(pick) and need[pick] ~= nil end
for _, id in ipairs(M.onField()) do
if need[id] then return true end
end
return false
end
function M.pickTarget()
if not enabled then return nil, "rift is off" end
local have, missing = M.owned()
local reqs = M.requirements()
if #reqs == 0 then return nil, "rift has no requirements" end
if have and have >= #reqs then return nil, "all rift pets owned" end
local need = {}
for _, id in ipairs((missing and #missing > 0) and missing or reqs) do
need[id] = true
end
local list = eggs.list()
if not list then return nil, "no egg list" end
for _, e in ipairs(list) do
local cat = e.assetCategory
if cat and need[cat] then
if pick then
if cat == pick then return e end
else
return e
end
end
end
return nil, pick
and ("%s is not on the field"):format(M.petName(pick))
or "no required rift pet is on the field"
end
local tradeSc, tradeOn, trading = nil, false, false
local mark          
function M.autoTradeOn() return tradeOn end
local function riftHave(reqs)
if type(reqs) ~= "table" or #reqs == 0 then return nil end
local out, okAny = {}, false
for _, r in ipairs(reqs) do out[r] = out[r] or { owned = 0, uids = {} } end
BX.try("rift.tradeInventory", function()
local prof = data.profile()
local inv = prof and prof.Inventory
if type(inv) ~= "table" then return end
okAny = true
local FuseKernel, AssetItems
pcall(function() FuseKernel = exec.requireGame(svc.ReplicatedStorage.Shared.Util.FuseKernel) end)
pcall(function() AssetItems = exec.requireGame(svc.ReplicatedStorage.Shared.Util.AssetItems) end)
local equipped = {}
for _, u in pairs(prof.EquippedAssets or {}) do equipped[u] = true end
local weight = {}
for uid, row in pairs(inv) do
local cat = type(row) == "table" and (row.Category or (row.ItemData and row.ItemData.Category))
local slot = cat and out[cat]
if slot then
slot.owned = slot.owned + 1
local may = not equipped[uid]
if may and FuseKernel and FuseKernel.MayEnterRift then
local ok, r = pcall(FuseKernel.MayEnterRift, uid, row)
may = ok and r == true
end
if may then
local w = math.huge
if AssetItems then
pcall(function() w = AssetItems.WeightKg(AssetItems.Decode(row)) end)
end
weight[uid] = w
slot.uids[#slot.uids + 1] = uid
end
end
end
for _, slot in pairs(out) do
table.sort(slot.uids, function(a, b) return (weight[a] or 0) < (weight[b] or 0) end)
end
end)
return okAny and out or nil
end
local function tryTrade()
if trading then return nil end
trading = true
local result = nil
BX.try("rift.tryTrade", function()
local st = M.state(true)
if type(st) ~= "table" then return end
if st.PendingReward then
net.call("RF/Rift/AskFinishReveal")
result = "revealed"
return
end
local reqs = st.Requirements
if type(reqs) ~= "table" or #reqs < 3 then return end
local have = riftHave(reqs)
if not have then return end
local uids, used = {}, {}
for i = 1, 3 do
local slot = have[reqs[i]]
for _, u in ipairs(slot and slot.uids or {}) do
if not used[u] then uids[i] = u used[u] = true break end
end
if not uids[i] then return end      
end
local res, msg = net.call("RF/Rift/AskTradeIn", uids)
if res ~= true then
result = "refused: " .. tostring(msg or res)
return
end
task.wait(1)
net.call("RF/Rift/AskFinishReveal")
result = "traded"
end)
trading = false
if result then
ownedHave, ownedMiss = nil, nil
mark("traded")
end
return result
end
local tradeListeners = {}
function M.onTrade(fn) tradeListeners[#tradeListeners + 1] = fn end
function M.setAutoTrade(on)
on = on and true or false
if on == tradeOn then return true end
tradeOn = on
if not on then
if tradeSc then tradeSc:destroy() tradeSc = nil end
log.info("auto trade-in OFF")
return true
end
if not enabled then M.setEnabled(true) end
tradeSc = BX.scope("features.rift.trade")
tradeSc:loop("trade", dev.scale(5), function()
local r = tryTrade()
if r == "traded" then
log.info("traded the 3 pets in - Rift Egg claimed")
elseif r == "revealed" then
log.info("finished a pending reveal")
elseif r then
log.warn("trade-in %s", tostring(r))
end
if r then
for _, fn in ipairs(tradeListeners) do
task.spawn(function() BX.try("rift.onTrade", fn, r) end)
end
end
end)
log.info("auto trade-in ON (every 5s, lightest eligible pet of each kind, never equipped)")
return true
end
local scheduleRetry
local function recompute(why, full)
dirty = false
if full then
snapAt = 0            
local st = M.state(true)
if st then
retryN = 0
else
scheduleRetry()
end
end
if full or (ownedHave == nil and ownedMiss == nil) then computeOwned() end
computeField()
prunePick()
log.trace("recomputed (%s)", tostring(why))
fireChange()
end
scheduleRetry = function()
if retryArmed or not sc then return end
local wait = K.RETRY[retryN + 1]
if not wait then return end
retryArmed = true
log.warn("rift read failed - retrying in %ds", wait)
sc:delay("retry", dev.scale(wait), function()
retryArmed = false
retryN = retryN + 1
recompute("retry " .. retryN, true)
end)
end
M.refresh = function(why)
if not enabled then return false end
eggs.invalidate("rift refresh")
recompute(why or "manual refresh", true)
return true
end
mark = function(why)
if dirty then
stats.coalesced = stats.coalesced + 1
return
end
dirty = true
if not sc then return end
sc:delay("recompute", K.DEBOUNCE, function()
if dirty then recompute(why, false) end
end)
end
function M.setEnabled(on)
on = on and true or false
if on == enabled then return true end
if not on then
enabled = false
if sc then sc:destroy() sc = nil end
snap, snapAt, snapOkAt = nil, 0, 0
fieldIds, ownedHave, ownedMiss = nil, nil, nil
labelToId, dirty = {}, false
retryN, retryArmed = 0, false
pick = nil
log.info("off (%d state reads, %d repaints this session)",
stats.askState, stats.repaints)
fireChange()
return true
end
sc = BX.scope("features.rift")
enabled = true
BX.try("rift.watchRotation", function()
local re = net.find("RE/Rift/BannerRotated")
if not re then
log.warn("RE/Rift/BannerRotated not found - running on the backstop")
return
end
sc:connect(re.OnClientEvent, function()
stats.rotations = stats.rotations + 1
log.info("banner rotated - re-reading")
task.spawn(function()
BX.try("rift.rotated", function() recompute("banner rotated", true) end)
end)
end)
end)
BX.try("rift.watchField", function()
local ES = data.eggState()
if not ES then return end
for _, name in ipairs({ "FieldRefreshed", "FieldGone", "FieldShifted" }) do
local sig = ES[name]
if sig and type(sig) == "table" and type(sig.Connect) == "function" then
sc:connect(sig, function() mark("field " .. name) end)
end
end
end)
BX.try("rift.watchSave", function()
local mod = data.save()
local sig = type(mod) == "table" and mod.FieldChanged or nil
if sig and type(sig) == "table" and type(sig.Connect) == "function" then
sc:connect(sig, function(field)
if field == nil or field == "Inventory" then
ownedHave, ownedMiss = nil, nil
mark("inventory changed")
end
end)
end
end)
sc:loop("backstop", dev.scale(K.BACKSTOP), function()
recompute(snap and "backstop" or "first read", true)
end)
log.info("on (rotation event + field signals, backstop %.0fs)",
dev.scale(K.BACKSTOP))
return true
end
return M
end)
BX.module("features.drones", function(BX)
local svc = BX.require("core.services")
local ch  = BX.require("core.character")
local st  = BX.require("core.state")
local net = BX.require("core.net")
local motion = BX.require("core.motion")
local mv  = BX.require("features.movement")
local log = BX.require("boot.log").for_module("drones")
local M = {}
local K = {
TICK        = 0.5,    
SNAPSHOT    = 8,      
STAND_OFF   = 7,      
KILL_WAIT   = 14,     
LINGER      = 0.6,    
DROP_REACH  = 25,     
SWING_GAP   = 0.75,   
FALLBACK_AFTER = 1.5, 
SKIP_FOR    = 60,     
BAT_ASK_GAP = 6,      
AREA_Z      = -360,   
}
M.K = K
motion.PRIORITY.drones = motion.PRIORITY.drones or 85
local TIER_RANK = { AugmentedDrone = 3, ReactorDrone = 2, ScrapDrone = 1 }
local priority = "nearest"
function M.setPriority(mode)
mode = tostring(mode or "nearest"):lower()
if mode ~= "biggest" and mode ~= "bigonly" then mode = "nearest" end
priority = mode
log.info("priority: %s", mode)
return mode
end
function M.priority() return priority end
M.PRIORITY_LABELS = {
{ "Nearest first", "nearest" },
{ "Biggest first", "biggest" },
{ "Big drones only", "bigonly" },
}
local enabled = false
local sc = nil
local snap = nil             
local snapAt = 0
local drones = {}            
local skipped = {}           
local standDown = nil
local current = nil          
local phase = "idle"
local batAskedAt = 0
local lastSwing = 0
local stats = { kills = 0, visited = 0, skipped = 0, swings = 0, rejected = 0, windows = 0 }
function M.stats() return table.clone(stats) end
function M.isOn() return enabled end
function M.standDownReason() return standDown end
local function me() return svc.Players.LocalPlayer.UserId end
local function applyUpserts(list, full)
if type(list) ~= "table" then return end
local seen = {}
for _, d in pairs(list) do
if type(d) == "table" and d.Id and d.OwnerUserId == me() then
local rec = drones[d.Id] or {}
local cf = d.CFrame
if typeof(cf) == "CFrame" then rec.pos = cf.Position end
rec.hp  = tonumber(d.Health) or rec.hp or 0
rec.max = tonumber(d.MaxHealth) or rec.max or 1
local a = d.Attributes
if type(a) == "table" then
rec.tier = a.ScrambleTier or rec.tier
rec.area = a.ScrambleArea or rec.area
end
if rec.pos then drones[d.Id] = rec end
seen[d.Id] = true
end
end
if full then
for id in pairs(drones) do
if not seen[id] then drones[id] = nil end
end
end
end
local function readSnapshot(force)
if not force and os.clock() - snapAt < K.SNAPSHOT then return snap end
snapAt = os.clock()
local res = net.call("RF/Scramble/Request", "Snapshot")
if type(res) == "table" then
snap = res
if type(res.Drones) == "table" then
applyUpserts(res.Drones.Upserts, true)
for _, id in ipairs(res.Drones.Removed or {}) do drones[id] = nil end
end
end
return snap
end
local function windowState()
local w = snap and snap.Window
if not w then return nil end
local now = workspace:GetServerTimeNow()
return {
active = w.Active == true and now < (w.EndsAt or 0),
left = math.max(0, (w.EndsAt or 0) - now),
next = math.max(0, (w.NextAt or 0) - now),
available = w.Available ~= false,
}
end
local function liveHitbox(id)
local f = workspace:FindFirstChild("ScrambleLocalVisuals")
local m = f and f:FindFirstChild("PersonalDrone_" .. tostring(id))
local hb = m and m:FindFirstChild("Hitbox")
return hb
end
local function healthOf(id)
local hb = liveHitbox(id)
if hb then
local h = hb:GetAttribute("Health")
if type(h) == "number" then return h, hb.Position end
end
local d = drones[id]
return d and d.hp or 0, d and d.pos
end
local function isBatTool(t)
return t:IsA("Tool") and (t:GetAttribute("IsBat") == true or t.Name:find("Bat") ~= nil)
end
local function findBat()
local char = ch.get()
if char then
for _, t in ipairs(char:GetChildren()) do if isBatTool(t) then return t, true end end
end
local bp = svc.Players.LocalPlayer:FindFirstChild("Backpack")
if bp then
for _, t in ipairs(bp:GetChildren()) do if isBatTool(t) then return t, false end end
end
return nil
end
local function ensureBat()
local bat = findBat()
if bat then return bat end
if os.clock() - batAskedAt > K.BAT_ASK_GAP then
batAskedAt = os.clock()
local ok, why = net.call("RF/Codex/AskWearFieldBat")
log.info("no bat - AskWearFieldBat -> %s %s", tostring(ok), tostring(why or ""))
end
return nil
end
local function fallbackSwing()
local bat, held = findBat()
if not bat then return false end
local hum = ch.humanoid()
if not held and hum then
pcall(function() hum:EquipTool(bat) end)
return false
end
local now = os.clock()
if now - lastSwing < K.SWING_GAP then return false end
local cdEnd = bat:GetAttribute("CooldownEndTime")
if type(cdEnd) == "number" and workspace:GetServerTimeNow() < cdEnd then return false end
if bat:GetAttribute("CooldownActive") == true then return false end
lastSwing = now
stats.swings = stats.swings + 1
pcall(function() bat:Activate() end)
return true
end
local function blockedBy()
if st.autoStealBusy then return "Auto Steal is mid-cycle" end
local fight = BX._loaded["features.bossfight"]
if fight and type(fight.isOn) == "function" and fight.isOn() then
return "Auto Fight owns the character"
end
local owner = motion.blockedBy("drones")
if owner then return owner .. " owns the character" end
return nil
end
local function nextTarget()
local root = ch.root()
if not root then return nil end
local here = root.Position
local now = os.clock()
local best, bestD, bestRank = nil, math.huge, -1
for id, d in pairs(drones) do
local until_ = skipped[id]
if until_ and now < until_ then continue end
if (d.hp or 0) <= 0 then continue end
local rank = TIER_RANK[d.tier or ""] or 0
if priority == "bigonly" and rank < 2 then continue end
local dist = (Vector3.new(d.pos.X, 0, d.pos.Z) - Vector3.new(here.X, 0, here.Z)).Magnitude
local better
if priority == "biggest" then
better = rank > bestRank or (rank == bestRank and dist < bestD)
else
better = dist < bestD
end
if better then best, bestD, bestRank = id, dist, rank end
end
return best, bestD
end
local function standSpot(pos)
local root = ch.root()
local from = root and root.Position or pos
local flat = Vector3.new(from.X - pos.X, 0, from.Z - pos.Z)
local dir = flat.Magnitude > 1 and flat.Unit or Vector3.new(-1, 0, 0)
local spot = pos + dir * K.STAND_OFF
local gy = mv.groundY and mv.groundY(spot) or nil
return Vector3.new(spot.X, gy or (pos.Y - 2), spot.Z)
end
local function nearestDrop(from)
local f = workspace:FindFirstChild("ScrambleLocalVisuals")
if not f then return nil end
local best, bestD = nil, K.DROP_REACH
for _, m in ipairs(f:GetChildren()) do
if not m.Name:find("PersonalDrone") and m ~= f then
local p = nil
if m:IsA("BasePart") then p = m.Position
elseif m:IsA("Model") then local ok, cf = pcall(m.GetPivot, m) if ok then p = cf.Position end end
if p then
local d = (p - from).Magnitude
if d < bestD then best, bestD = p, d end
end
end
end
return best
end
local function travel(to, tag)
local hum, root = ch.humanoid(), ch.root()
if not hum or not root then return false, "no-character" end
hum.PlatformStand = false
local speed = math.max(hum.WalkSpeed or 16, 16)
local dist = (Vector3.new(to.X, 0, to.Z) - Vector3.new(root.Position.X, 0, root.Position.Z)).Magnitude
if dist <= 3 then return true, "already-there" end
local deadline = os.clock() + dist / speed * 2.5 + 6
local lastProgress, lastDist = os.clock(), dist
local reissue = 0
while enabled do
if blockedBy() then hum:Move(Vector3.zero, false) return false, "cancelled" end
local w = windowState()
if w and not w.active then hum:Move(Vector3.zero, false) return false, "window closed" end
root = ch.root() hum = ch.humanoid()
if not root or not hum then return false, "lost-root" end
local stt = hum:GetState()
if hum.PlatformStand or stt == Enum.HumanoidStateType.Physics
or stt == Enum.HumanoidStateType.Ragdoll or stt == Enum.HumanoidStateType.FallingDown then
lastProgress = os.clock()
task.wait(0.2)
continue
end
local here = root.Position
local d = (Vector3.new(to.X, 0, to.Z) - Vector3.new(here.X, 0, here.Z)).Magnitude
if d <= 3 then hum:Move(Vector3.zero, false) return true, "arrived" end
if os.clock() >= reissue then
hum:MoveTo(Vector3.new(to.X, to.Y, to.Z))
reissue = os.clock() + 0.5
end
if d < lastDist - 1 then lastProgress, lastDist = os.clock(), d
elseif os.clock() - lastProgress > 1.5 then
hum.Jump = true
lastProgress = os.clock()
end
if os.clock() > deadline then hum:Move(Vector3.zero, false) return false, "timeout" end
task.wait(0.1)
end
return false, "cancelled"
end
local function workOne(id)
local d = drones[id]
if not d then return "gone" end
current = id
phase = "travel"
local tTravel = os.clock()
local okT, why = travel(standSpot(d.pos), "approach")
if not okT then return "travel " .. tostring(why) end
stats.visited = stats.visited + 1
tTravel = os.clock() - tTravel
phase = "hit"
ensureBat()
local t0 = os.clock()
local lastHp, lastChange = nil, os.clock()
while enabled and os.clock() - t0 < K.KILL_WAIT do
if blockedBy() then return "stood down" end
local w = windowState()
if w and not w.active then return "window closed" end
local hp, pos = healthOf(id)
if hp <= 0 then
stats.kills = stats.kills + 1
d.hp = 0
break
end
if hp ~= lastHp then lastHp, lastChange = hp, os.clock() end
local root = ch.root()
if root and pos and (pos - root.Position).Magnitude > 11 then
travel(standSpot(pos), "reapproach")
elseif os.clock() - lastChange > K.FALLBACK_AFTER then
fallbackSwing()
end
task.wait(0.2)
end
local tHit = os.clock() - t0
if (d.hp or 1) > 0 then
skipped[id] = os.clock() + K.SKIP_FOR
stats.skipped = stats.skipped + 1
return ("no kill in time (travel %.1fs, hit %.1fs)"):format(tTravel, tHit)
end
phase = "collect"
local tC = os.clock()
task.wait(K.LINGER)
return ("killed (travel %.1fs, hit %.1fs, collect %.1fs)"):format(tTravel, tHit, os.clock() - tC)
end
local running = false
local function tick()
if not enabled or running then return end
readSnapshot(false)
local why = blockedBy()
if why ~= standDown then
standDown = why
if why then log.info("standing down: %s", why) end
end
if why then phase = "standing down" return end
local w = windowState()
if not w then phase = "reading" return end
if not w.active then
phase = "waiting"
motion.release("drones")
return
end
local id, dist = nextTarget()
if not id then
phase = priority == "bigonly" and "no big drones left" or "none left"
motion.release("drones")
return
end
running = true
BX.try("drones.work", function()
local okC = motion.claim("drones")
if not okC then return end
if phase == "waiting" or phase == "idle" then stats.windows = stats.windows + 1 end
local result = workOne(id)
log.info("%s %s (%s, %.0f studs) - %s", tostring(drones[id] and drones[id].tier or "drone"),
tostring(id):sub(1, 8), tostring(drones[id] and drones[id].area or "?"), dist or 0, result)
end)
running = false
current = nil
end
local function fmt(s)
s = math.max(0, math.floor(s + 0.5))
return ("%d:%02d"):format(math.floor(s / 60), s % 60)
end
function M.status()
if not snap then return { title = "Dr. Scramble", body = enabled and "Reading..." or "Off" } end
local w = windowState()
local alive, total = 0, 0
for _, d in pairs(drones) do total = total + 1 if (d.hp or 0) > 0 then alive = alive + 1 end end
local samples = snap.State and snap.State.Samples
local parts = snap.State and snap.State.TotalParts
local head = ("%d/%d drones"):format(alive, total)
if samples then head = head .. (" · %d samples"):format(samples) end
if parts then head = head .. (" · %d/5 parts"):format(parts) end
local body
if not w or (not w.available and w.next <= 0) then
body = "No window"
elseif w.active then
body = ("Open · %s left"):format(fmt(w.left))
if enabled then
body = body .. " · " .. (standDown and "waiting" or phase)
end
else
body = ("Next in %s"):format(fmt(w.next))
end
return { title = head, body = body }
end
function M.setEnabled(on)
on = on and true or false
if on == enabled then return true end
enabled = on
if not on then
if sc then sc:destroy() sc = nil end
motion.release("drones")
standDown, current, phase = nil, nil, "idle"
log.info("off (%d kills, %d visited, %d skipped this session)", stats.kills, stats.visited, stats.skipped)
return true
end
sc = BX.scope("features.drones")
readSnapshot(true)
local re = net.find("RE/Scramble/Drones")
if re then
sc:connect(re.OnClientEvent, function(msg)
if type(msg) ~= "table" or msg.OwnerUserId ~= me() then return end
applyUpserts(msg.Upserts, msg.Full == true)
for _, id in ipairs(msg.Removed or {}) do drones[id] = nil end
end)
end
local stateRe = net.find("RE/Scramble/State")
if stateRe then
sc:connect(stateRe.OnClientEvent, function(s)
if type(s) ~= "table" then return end
if type(snap) ~= "table" then snap = {} end
for k, v in pairs(s) do snap[k] = v end
if type(s.Drones) == "table" then
applyUpserts(s.Drones.Upserts, s.Drones.Full == true)
for _, id in ipairs(s.Drones.Removed or {}) do drones[id] = nil end
end
snapAt = os.clock()
end)
end
motion.onPreempt("drones", function(by) log.info("preempted by %s", tostring(by)) end)
sc:loop("plan", K.TICK, tick)
local n = 0 for _ in pairs(drones) do n = n + 1 end
log.info("on (%d of my drones known, window %s)", n,
(windowState() and windowState().active) and "open" or "closed")
return true
end
BX.onTeardown("features.drones", function()
if enabled then M.setEnabled(false) end
end)
return M
end)
BX.module("features.catalogdata", function(BX)
return {
scaleExponent = 1,
mutations = {
},
assets = {
["Abyssal Overlord"] = { name = "Abyss Overlord", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 4, rate = 1250000 },
["Abyssal Overlord OP"] = { name = "Abyss Overlord", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 4, rate = 100000000 },
["Alabaster Whale"] = { name = "Beluga Whale", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 6, rate = 850000 },
["Alien Skeleton Boss"] = { name = "Cosmic Skeleton Boss", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 8, rate = 45000000 },
["Ankylosaurus"] = { name = "Ankylosaurus", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 2, rate = 120000 },
["Archdemon Dragon"] = { name = "Archdemon Dragon", rarity = "Divine", rarityId = "Divine", rarityNum = 10, weight = 40, rate = 1250000000 },
["Ascended Vermilion Phoenix"] = { name = "Phoenix", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 5, rate = 85000000 },
["Ash Gecko"] = { name = "Lava Gecko", rarity = "Rare", rarityId = "Rare", rarityNum = 3, weight = 5, rate = 180 },
["Baby Aurora Dragon"] = { name = "Baby Aurora Dragon", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 5, rate = 5000000 },
["Balrog"] = { name = "Balrog", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 16, rate = 200000000 },
["Bananita Dolphinita"] = { name = "Bananita Dolphinita", rarity = "Epic", rarityId = "Epic", rarityNum = 4, weight = 6, rate = 400 },
["Basilisk"] = { name = "Leviathan", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 2, rate = 220000 },
["Bear"] = { name = "Bear", rarity = "Epic", rarityId = "Epic", rarityNum = 4, weight = 2, rate = 240 },
["Belula Beluga"] = { name = "Belula Beluga", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 6, rate = 40000 },
["Blade Head"] = { name = "Bladehide", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 3, rate = 750000 },
["Bomboclat Crocolat"] = { name = "Bombo Croco", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 6, rate = 20000000 },
["Bronto"] = { name = "Bronto", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 4, rate = 1500000 },
["Brr Brr Patapim"] = { name = "Brr Brr Patapim", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 2, rate = 1800 },
["Burrowing Owl"] = { name = "Burrowing Owl", rarity = "Rare", rarityId = "Rare", rarityNum = 3, weight = 1, rate = 35 },
["Camel"] = { name = "Camel", rarity = "Rare", rarityId = "Rare", rarityNum = 3, weight = 2, rate = 75 },
["Catfish"] = { name = "Catfish", rarity = "Uncommon", rarityId = "Uncommon", rarityNum = 2, weight = 2, rate = 12 },
["Cave Dragon"] = { name = "Cosmic Dragon", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 8, rate = 60000000 },
["Centapede"] = { name = "Centapede", rarity = "Epic", rarityId = "Epic", rarityNum = 4, weight = 7, rate = 1500 },
["Cerberus"] = { name = "Cerberus", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 5, rate = 8000000 },
["Chicken"] = { name = "Chicken", rarity = "Common", rarityId = "Common", rarityNum = 1, weight = 1, rate = 1 },
["Chillin Chilli"] = { name = "Chillin Chilli", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 5, rate = 55000 },
["Chimpanzee"] = { name = "Chimpanzee", rarity = "Rare", rarityId = "Rare", rarityNum = 3, weight = 3, rate = 90 },
["Colossal Mammoth"] = { name = "King Mammoth", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 4, rate = 400000 },
["Crab"] = { name = "Crustacia", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 2, rate = 130000 },
["Crane"] = { name = "Crane", rarity = "Epic", rarityId = "Epic", rarityNum = 4, weight = 2, rate = 4000 },
["Crawler"] = { name = "Crawler", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 6, rate = 1500000 },
["Crocodile"] = { name = "Crocodile", rarity = "Epic", rarityId = "Epic", rarityNum = 4, weight = 3, rate = 420 },
["Crocodon"] = { name = "Crocodon", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 6, rate = 30000000 },
["Cthulhu"] = { name = "Cthulhu", rarity = "Divine", rarityId = "Divine", rarityNum = 10, weight = 6, rate = 3000000000 },
["Cyclops Gorilla"] = { name = "Cosmic Gorilla", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 8, rate = 180000 },
["DeathstalkerScorpion"] = { name = "Scorpion", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 3, rate = 18500 },
["Demon Hound"] = { name = "Demon Hound", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 5, rate = 25000000 },
["Demon Imp"] = { name = "Demon Imp", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 8, rate = 700000 },
["Depths Cthulhu"] = { name = "Luminous Cthulhu", rarity = "Divine", rarityId = "Divine", rarityNum = 10, weight = 6, rate = 6500000000 },
["Depths Electric Eel"] = { name = "Luminous Electric Eel", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 6, rate = 1750000000 },
["Depths Manta Ray"] = { name = "Luminous Spirit Manta", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 6, rate = 500000000 },
["Depths Megalodon"] = { name = "Luminous Abyss Shark", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 6, rate = 600000000 },
["Depths Riptide Octopus"] = { name = "Depths Riptide Octopus", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 6, rate = 430000000 },
["Depths Spike"] = { name = "Luminous Spike", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 6, rate = 350000000 },
["Depths Terra Snapper"] = { name = "Luminous Terra Snapper", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 6, rate = 2500000000 },
["DesertLark"] = { name = "Bird", rarity = "Uncommon", rarityId = "Uncommon", rarityNum = 2, weight = 1, rate = 8 },
["Dodo"] = { name = "Dodo", rarity = "Rare", rarityId = "Rare", rarityNum = 3, weight = 7, rate = 280 },
["Dog"] = { name = "Dog", rarity = "Common", rarityId = "Common", rarityNum = 1, weight = 1, rate = 2 },
["Dragon"] = { name = "Lava Dragon", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 5, rate = 100000000 },
["Dreadclaw"] = { name = "Dreadclaw", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 4, rate = 2200000 },
["Dreadscale"] = { name = "Dreadscale", rarity = "Divine", rarityId = "Divine", rarityNum = 10, weight = 6, rate = 2000000000 },
["Dream Axolotl"] = { name = "Axolotl", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 2, rate = 2800 },
["Drill Monster"] = { name = "Drilla", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 6, rate = 100000000 },
["Duckling"] = { name = "Duckling", rarity = "Common", rarityId = "Common", rarityNum = 1, weight = 2, rate = 4 },
["El Maja"] = { name = "El Maja", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 6, rate = 130000000 },
["Electric Eel"] = { name = "Electric Eel", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 6, rate = 200000000 },
["Ember Dragon"] = { name = "Ember Dragon", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 5, rate = 600000000 },
["Eternal Lunar Dragon"] = { name = "Eternal Lunar Dragon", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 9, rate = 250000000 },
["FennecFox"] = { name = "Fennec", rarity = "Uncommon", rarityId = "Uncommon", rarityNum = 2, weight = 2, rate = 18 },
["Finned Thresher"] = { name = "Shark", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 6, rate = 15000 },
["Flaming Bull"] = { name = "Flaming Bull", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 5, rate = 9500 },
["Frog"] = { name = "Frog", rarity = "Common", rarityId = "Common", rarityNum = 1, weight = 2, rate = 3 },
["Froggo"] = { name = "Froggo", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 6, rate = 50000 },
["Galaxy Gecko"] = { name = "Cosmic Gecko", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 8, rate = 30000 },
["Godzilla"] = { name = "Nightflame", rarity = "Divine", rarityId = "Divine", rarityNum = 10, weight = 4, rate = 3000000000 },
["Gorilla"] = { name = "Gorilla", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 3, rate = 4800 },
["Hellhound"] = { name = "Hellhound", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 20, rate = 1800000 },
["Ice Dragon"] = { name = "Ice Dragon", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 4, rate = 65000000 },
["Imp"] = { name = "Imp", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 5, rate = 16000000 },
["Irihorus"] = { name = "Royal Sphinx", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 3, rate = 280000 },
["Jellyfish"] = { name = "Pure Jellyfish", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 10, rate = 225000000 },
["Jerboa"] = { name = "Jerboa", rarity = "Common", rarityId = "Common", rarityNum = 1, weight = 2, rate = 6 },
["Kaiju Spider"] = { name = "Spideron", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 2, rate = 95000 },
["King Kong"] = { name = "Gorilla King", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 4, rate = 880000000 },
["Kitsune"] = { name = "Kitsune", rarity = "Divine", rarityId = "Divine", rarityNum = 10, weight = 4, rate = 1800000000 },
["Koi"] = { name = "Koi", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 3, rate = 12000000 },
["Kraken"] = { name = "Kraken", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 6, rate = 15000000 },
["Krakenoid"] = { name = "Krakenoid", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 6, rate = 500000000 },
["La Vacca Saturno Saturnita"] = { name = "La Vacca Saturno Saturnita", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 8, rate = 2200000 },
["Lava Iguana"] = { name = "Lava Iguana", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 5, rate = 11000 },
["Lava frog"] = { name = "Lava frog", rarity = "Epic", rarityId = "Epic", rarityNum = 4, weight = 5, rate = 850 },
["Mammoth"] = { name = "Mammoth", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 4, rate = 42000 },
["Mangolini Parrochini"] = { name = "Mangolini Parrochini", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 6, rate = 800000 },
["Manta Ray"] = { name = "Spirit Manta", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 6, rate = 75000 },
["Mantis"] = { name = "Mantaris", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 2, rate = 11000000 },
["Mawbreaker"] = { name = "Mawbreaker", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 4, rate = 60000000 },
["Mecha Crawler"] = { name = "Mecha Crawler", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 6, rate = 320000000 },
["Mecha Crocodon"] = { name = "Mecha Crocodon", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 6, rate = 680000000 },
["Mecha Dreadscale"] = { name = "Mecha Dreadscale", rarity = "Divine", rarityId = "Divine", rarityNum = 10, weight = 6, rate = 4000000000 },
["Mecha Froggo"] = { name = "Mecha Froggo", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 6, rate = 155000000 },
["Mecha Krakenoid"] = { name = "Mecha Krakenoid", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 6, rate = 1000000000 },
["Mecha Scorpio"] = { name = "Mecha Scorpio", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 6, rate = 45000000 },
["Megalodon"] = { name = "Abyss Shark", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 6, rate = 2500000 },
["Mire Fox"] = { name = "Fox", rarity = "Epic", rarityId = "Epic", rarityNum = 4, weight = 1, rate = 180 },
["Mosasaurus"] = { name = "Mosasaurus", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 6, rate = 180000000 },
["Oni Tiger"] = { name = "Oni Tiger", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 4, rate = 600000000 },
["Orangutini Ananassini"] = { name = "Orangutini Ananassini", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 3, rate = 5500 },
["Orca"] = { name = "Orca", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 6, rate = 80000 },
["Parrotfish"] = { name = "Parrotfish", rarity = "Rare", rarityId = "Rare", rarityNum = 3, weight = 6, rate = 220 },
["Penguin"] = { name = "Penguin", rarity = "Rare", rarityId = "Rare", rarityNum = 3, weight = 4, rate = 140 },
["Polar Bear"] = { name = "Polar Bear", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 4, rate = 7000 },
["Pterodactyl"] = { name = "Pterodactyl", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 3, rate = 22000 },
["Raccoon"] = { name = "Raccoon", rarity = "Rare", rarityId = "Rare", rarityNum = 3, weight = 1, rate = 45 },
["Rattlesnake"] = { name = "Snake", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 3, rate = 3600 },
["RazorFang"] = { name = "RazorFang", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 5, rate = 350000000 },
["Red Panda"] = { name = "Red Panda", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 2, rate = 450000 },
["Rhino"] = { name = "Rhinotaur", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 2, rate = 17500000 },
["Rift Eye"] = { name = "Rift Eye", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 4, rate = 11000 },
["Riftwing"] = { name = "Riftwing", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 4, rate = 220000 },
["Ring Guard"] = { name = "Ring Guard", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 80, rate = 15000000 },
["Ringlord"] = { name = "Ringlord", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 80, rate = 825000000 },
["Riptide Octopus"] = { name = "Riptide Octopus", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 6, rate = 1500000 },
["Sabertooth Tiger"] = { name = "Sabertooth Tiger", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 4, rate = 35000 },
["Salamander"] = { name = "Salamander", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 2, rate = 74000 },
["Sand Spider"] = { name = "Sand Spider", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 3, rate = 16000 },
["ScorchedDragon"] = { name = "Scorched Dragon", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 40, rate = 35000000 },
["Scorpio"] = { name = "Scorpio", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 6, rate = 10000 },
["Shadow Dragon"] = { name = "Shadow Dragon", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 5, rate = 25000000 },
["Shardling"] = { name = "Shardling", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 4, rate = 450000 },
["Shardwing"] = { name = "Shardwing", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 4, rate = 145000000 },
["Shark"] = { name = "Mutant Shark", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 3, rate = 215000000 },
["Shattered Colossus"] = { name = "Shattered Colossus", rarity = "Divine", rarityId = "Divine", rarityNum = 10, weight = 4, rate = 3500000000 },
["Shattered Drake"] = { name = "Shattered Drake", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 4, rate = 800000000 },
["Shattered Ram"] = { name = "Shattered Ram", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 4, rate = 8000000 },
["Snowy Owl"] = { name = "Snowy Owl", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 2, rate = 7500000 },
["Spider"] = { name = "Spider", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 4, rate = 22000 },
["Spike"] = { name = "Spike", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 6, rate = 15000 },
["Stag"] = { name = "Stag", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 3, rate = 145000000 },
["Strawberry Elephant"] = { name = "Strawberry Elephant", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 6, rate = 110000000 },
["Swan"] = { name = "Swan", rarity = "Epic", rarityId = "Epic", rarityNum = 4, weight = 2, rate = 320 },
["Swordfish"] = { name = "Swordfish", rarity = "Epic", rarityId = "Epic", rarityNum = 4, weight = 6, rate = 1100 },
["Terra Snapper"] = { name = "Terra Snapper", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 6, rate = 750000000 },
["Tiger"] = { name = "Tiger", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 4, rate = 28000 },
["Tob Tobi Tob Tob"] = { name = "Tob Tobi Tob Tob", rarity = "Epic", rarityId = "Epic", rarityNum = 4, weight = 3, rate = 325 },
["Toucan"] = { name = "Toucan", rarity = "Rare", rarityId = "Rare", rarityNum = 3, weight = 3, rate = 110 },
["Tralaledon"] = { name = "Tralaledon", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 4, rate = 32000000 },
["Triceratops"] = { name = "Triceratops", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 3, rate = 1200000 },
["Trulimero Trulicina"] = { name = "Trulimero Trulicina", rarity = "Epic", rarityId = "Epic", rarityNum = 4, weight = 2, rate = 260 },
["Tung Tung Sahur"] = { name = "Tung Tung Sahur", rarity = "Rare", rarityId = "Rare", rarityNum = 3, weight = 6, rate = 100 },
["Turtle"] = { name = "Turtle", rarity = "Rare", rarityId = "Rare", rarityNum = 3, weight = 2, rate = 60 },
["TyrannosaurusRex"] = { name = "TRex", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 5, rate = 25000000 },
["Unicorn"] = { name = "Unicorn", rarity = "Divine", rarityId = "Divine", rarityNum = 10, weight = 10, rate = 1000000000 },
["Ventinal"] = { name = "Ventinal", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 4, rate = 585000 },
["Void Angler"] = { name = "Void Angler", rarity = "Legendary", rarityId = "Legendary", rarityNum = 5, weight = 4, rate = 30000 },
["Void Dragon"] = { name = "Void Dragon", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 5, rate = 120000000 },
["Void Serpent"] = { name = "Void Serpent", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 4, rate = 900000000 },
["Voidmaw"] = { name = "Voidmaw", rarity = "Mythic", rarityId = "Mythic", rarityNum = 6, weight = 4, rate = 50000 },
["Walrus"] = { name = "Walrus", rarity = "Epic", rarityId = "Epic", rarityNum = 4, weight = 4, rate = 600 },
["Warden"] = { name = "King Snake", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 4, rate = 3500000 },
["Wendigo"] = { name = "Wendigo", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 4, rate = 15000000 },
["Whale Shark"] = { name = "Whale Shark", rarity = "Cosmic", rarityId = "Cosmic", rarityNum = 7, weight = 6, rate = 700000 },
["World Eater"] = { name = "World Eater", rarity = "Eternal", rarityId = "Eternal", rarityNum = 9, weight = 4, rate = 500000000 },
["Yeti"] = { name = "Yeti", rarity = "Secret", rarityId = "Secret", rarityNum = 8, weight = 4, rate = 5000000 },
},
}
end)
BX.module("features.catalog", function(BX)
local data = BX.require("core.data")
local exec = BX.require("core.exec")
local svc  = BX.require("core.services")
local log  = BX.require("boot.log").for_module("catalog")
local M = {}
local EXPORT_PATH = "VoidcxzHub/catalog_export.json"
local baked = nil
BX.try("catalog.baked", function()
if BX._factories and BX._factories["features.catalogdata"] then
baked = BX.require("features.catalogdata")
end
end)
M.loaded = baked ~= nil
function M.all()
return (baked and baked.assets) or {}
end
function M.entry(category)
if not (baked and category) then return nil end
return baked.assets and baked.assets[tostring(category)] or nil
end
function M.rate(rec)
local entry = M.entry(rec and rec.AssetCategory)
if not entry then return nil end
local base = tonumber(entry.rate)
if not base then return nil end
local scale = tonumber(rec.AssetScale) or 1
local exponent = tonumber(baked.scaleExponent) or 1
local value = base * (scale ^ exponent)
if type(rec.Mutations) == "table" and baked.mutations then
for _, mutation in pairs(rec.Mutations) do
local key = type(mutation) == "table"
and (mutation.Id or mutation.Name or mutation.Type) or mutation
local factor = tonumber(baked.mutations[tostring(key)])
if factor then value = value * factor end
end
end
return value
end
local function sample(earnings, category, scale, mutations)
local rate
pcall(function()
rate = earnings.LiveRatePerSecond(
{ Category = category, Scale = scale, Mutations = mutations or {} },
nil, nil, svc.LocalPlayer)
end)
return tonumber(rate)
end
function M.export()
if not exec.can.files then
log.warn("no file access - cannot write the harvest")
return false
end
local dir = data.assetsDir()
local earnings = data.assetEarnings()
if not (dir and earnings) then
log.info("nothing to harvest here: the game modules are not readable")
return false
end
local out = { assets = {}, mutations = {}, scaleExponent = 1, at = os.time() }
local counted, mutationNames = 0, {}
for category, entry in pairs(dir) do
if type(entry) == "table" then
local base = sample(earnings, category, 1, {})
local rarity = type(entry.Rarity) == "table" and entry.Rarity or nil
out.assets[tostring(category)] = {
name = entry.DisplayName or tostring(category),
rarity = rarity and (rarity.DisplayName or rarity._id) or nil,
rarityId = rarity and (rarity._id or rarity.DisplayName) or nil,
rarityNum = rarity and tonumber(rarity.RarityNumber) or nil,
weight = type(entry.Egg) == "table" and tonumber(entry.Egg.WeightKg) or nil,
rate = base,
}
counted = counted + 1
for _, mutation in pairs(entry.Mutations or entry.PossibleMutations or {}) do
local key = type(mutation) == "table"
and (mutation.Id or mutation.Name or mutation._id) or mutation
if key then mutationNames[tostring(key)] = true end
end
end
end
local exponents = {}
for category, entry in pairs(out.assets) do
if entry.rate and entry.rate > 0 and #exponents < 5 then
local doubled = sample(earnings, category, 2, {})
if doubled and doubled > 0 then
exponents[#exponents + 1] = math.log(doubled / entry.rate) / math.log(2)
end
end
end
if #exponents > 0 then
local sum = 0
for _, e in ipairs(exponents) do sum = sum + e end
out.scaleExponent = sum / #exponents
end
local probe, probeRate
for category, entry in pairs(out.assets) do
if entry.rate and entry.rate > 0 then probe, probeRate = category, entry.rate break end
end
if probe then
for name in pairs(mutationNames) do
local withIt = sample(earnings, probe, 1, { name })
if withIt and withIt > 0 then
out.mutations[name] = withIt / probeRate
end
end
end
local encoded
local okJson = pcall(function() encoded = svc.HttpService:JSONEncode(out) end)
if not okJson or not encoded then
log.error("could not encode the harvest")
return false
end
exec.ensureFolder("VoidcxzHub")
exec.writeFile(EXPORT_PATH, encoded)
log.info("harvested %d pets, scale exponent %.3f, %d mutations -> %s",
counted, out.scaleExponent, (function()
local n = 0
for _ in pairs(out.mutations) do n = n + 1 end
return n
end)(), EXPORT_PATH)
return true
end
local started = false
function M.start()
if started then return end
started = true
task.delay(12, function()
BX.try("catalog.export", M.export)
end)
end
return M
end)
BX.module("features.eggs", function(BX)
local svc = BX.require("core.services")
local dev = BX.require("core.device")
local data = BX.require("core.data")
local log = BX.require("boot.log").for_module("eggs")
local M = {}
local K = {
CACHE_TTL       = 0.5,   
MIN_REBUILD     = 0.1,   
RAW_TTL         = 0.25,  
FALLBACK_TTL    = 5.0,   
STOLEN_FOR      = 120,   
UNREACHABLE_FOR = 45,    
PARTIAL_FLOOR   = 8,     
FULL_FIELD_MIN  = 10,    
VALUE_CACHE_MAX = 600,   
}
M.K = K
local EggState, AssetEarnings, AssetsDir
local repriceWanted = false
local function resolveModules()
BX.try("eggs.resolveModules", function()
if not EggState then EggState = data.eggState() end
if not AssetEarnings then AssetEarnings = data.assetEarnings() end
if not AssetsDir then
AssetsDir = data.assetsDir()
if AssetsDir then repriceWanted = true end
end
end)
M.ready = EggState ~= nil
return M.ready
end
resolveModules()
M.ready = (EggState ~= nil)
if not M.ready then
log.error("EggState not found - is this Steal An Egg?")
end
local rawSnap, rawSnapAt = nil, 0
local dirty, dirtyReason = false, nil
local list, listAt       = nil, 0
local fallbackAt         = 0
local sawFullField       = false
local saidPartial        = false
local stolen             = {}   
local unreachable        = {}   
local valueCache         = {}   
local valueCacheN        = 0
local stats = {
scans = 0, cacheHits = 0, partialHeld = 0, fallbacks = 0,
signals = 0, dirtyRebuilds = 0,
lastScanMs = 0, lastConsidered = 0, lastKept = 0,
}
BX.profile.watch("eggs.list", function() return list and #list or 0 end)
BX.profile.watch("eggs.values", function() return valueCacheN end)
BX.profile.watch("eggs.unreachable", function()
local n = 0
for _ in pairs(unreachable) do n = n + 1 end
return n
end)
BX.profile.watch("eggs.stolen", function()
local n = 0
for _ in pairs(stolen) do n = n + 1 end
return n
end)
function M.invalidate(reason)
list, listAt = nil, 0
rawSnap, rawSnapAt = nil, 0
dirty = false
if reason then log.trace("invalidated: %s", reason) end
end
function M.markDirty(reason)
dirty = true
dirtyReason = reason
stats.signals = (stats.signals or 0) + 1
end
function M.markStolen(uid)
if uid then stolen[tostring(uid)] = os.clock() end
end
function M.markUnreachable(uid)
if uid then unreachable[tostring(uid)] = os.clock() end
end
function M.clearUnreachable(uid)
if uid then unreachable[tostring(uid)] = nil end
end
local function pruneStolen()
local now = os.clock()
for uid, at in pairs(stolen) do
if (now - at) > K.STOLEN_FOR then stolen[uid] = nil end
end
for uid, at in pairs(unreachable) do
if (now - at) > K.UNREACHABLE_FOR then unreachable[uid] = nil end
end
end
local saidNoRate = false
local RECORD_REMOTE = "RF/EggWorld/AskEggRecord"
local RECORD_SHAPES = {
{ "Uid", function(uid) return { Uid = uid } end },
{ "EggUid", function(uid) return { EggUid = uid } end },
{ "array", function(uid) return { uid } end },
{ "bare", function(uid) return uid end },
}
local recordShape, recordDead, saidRecord = nil, false, false
local recordCache = {}
local function askRecord(uid)
if recordDead or not uid then return nil end
uid = tostring(uid)
local hit = recordCache[uid]
if hit ~= nil then return hit or nil end
local net = BX.require("core.net")
local tries = recordShape and { recordShape } or RECORD_SHAPES
for _, shape in ipairs(tries) do
local res = net.call(RECORD_REMOTE, shape[2](uid))
if type(res) == "table" then
if not recordShape then
recordShape = shape
log.info("egg records via %s with shape %q", RECORD_REMOTE, shape[1])
end
if not saidRecord then
saidRecord = true
local fields = {}
for key, value in pairs(res) do
fields[#fields + 1] = ("%s:%s=%s"):format(tostring(key), typeof(value),
tostring(value):sub(1, 18))
end
table.sort(fields)
log.info("egg record fields: %s", table.concat(fields, ", "))
end
recordCache[uid] = res
return res
end
end
if not recordShape then
recordDead = true
log.warn("%s answered nothing usable - egg prices stay unavailable here", RECORD_REMOTE)
end
recordCache[uid] = false
return nil
end
local function rateFromRecord(rec)
local got = askRecord(rec and rec.Uid)
if type(got) ~= "table" then return nil end
return tonumber(got.EarningRate or got.RatePerSecond or got.IncomePerSecond
or got.Earnings or got.Income or got.Rate or got.Value)
end
local function calcValue(rec)
local uid = rec.Uid
local hit = valueCache[uid]
if hit then return hit end
local item = {
Category  = rec.AssetCategory,
Scale     = tonumber(rec.AssetScale) or 1,
Mutations = rec.Mutations or {},
}
local v = 0
if AssetEarnings then
local ok, rate = pcall(AssetEarnings.LiveRatePerSecond, item, nil, nil, svc.LocalPlayer)
if ok and type(rate) == "number" then
v = rate
else
ok, rate = pcall(AssetEarnings.MutationOnlyRatePerSecond, item)
if ok and type(rate) == "number" then v = rate end
end
end
if v == 0 then
v = tonumber(rec.RatePerSecond or rec.IncomePerSecond or rec.EarningsPerSecond
or rec.Rate or rec.Income or rec.Value or rec.CashPerSecond) or 0
end
if v == 0 and AssetsDir then
local entry = AssetsDir[rec.AssetCategory]
local base = entry and (tonumber(entry.EarningRate)
or tonumber(entry.EarningsRate) or tonumber(entry.IncomeRate)
or tonumber(entry.RatePerSecond) or tonumber(entry.Income)
or tonumber(entry.Earnings)
or (type(entry.Egg) == "table" and (tonumber(entry.Egg.EarningRate)
or tonumber(entry.Egg.Income))) or nil)
if entry and not base and not saidNoRate then
saidNoRate = true
local fields = {}
for key, value in pairs(entry) do
fields[#fields + 1] = ("%s:%s"):format(tostring(key), typeof(value))
end
table.sort(fields)
log.warn("%s has a catalog entry but no readable rate; fields: %s",
tostring(rec.AssetCategory), table.concat(fields, ", "))
end
if base then
v = base * (tonumber(rec.AssetScale) or 1)
if type(rec.Mutations) == "table" then
for _, mutation in pairs(rec.Mutations) do
local key = type(mutation) == "table"
and (mutation.Id or mutation.Name or mutation._id) or mutation
local factor = data.mutationFactor(key)
if factor then v = v * factor end
end
end
end
end
if v == 0 then
v = tonumber(BX.require("features.catalog").rate(rec)) or 0
end
if v == 0 then
v = tonumber(rateFromRecord(rec)) or 0
end
if valueCacheN >= K.VALUE_CACHE_MAX then
log.warn("value cache hit %d entries - clearing", valueCacheN)
valueCache, valueCacheN = {}, 0
end
if v > 0 then
valueCache[uid] = v
valueCacheN = valueCacheN + 1
end
return v
end
M.value = calcValue
local identity = {}
local identityN = 0
local function rememberIdentity(rec)
local uid = rec and rec.Uid and tostring(rec.Uid)
if not uid or not rec.AssetCategory then return end
if identity[uid] == nil then
if identityN > 2000 then identity, identityN = {}, 0 end
identityN = identityN + 1
end
identity[uid] = { category = rec.AssetCategory, scale = rec.AssetScale,
mutations = rec.Mutations }
end
local function enrich(rec)
if not rec or rec.AssetCategory then
rememberIdentity(rec)
return rec
end
local known = rec.Uid and identity[tostring(rec.Uid)]
if known then
rec.AssetCategory = known.category
if rec.AssetScale == nil then rec.AssetScale = known.scale end
if rec.Mutations == nil then rec.Mutations = known.mutations end
end
return rec
end
local function displayName(rec)
local dir = AssetsDir and AssetsDir[rec.AssetCategory]
if dir and dir.DisplayName then return dir.DisplayName end
local baked = BX.require("features.catalog").entry(rec.AssetCategory)
return (baked and baked.name) or rec.AssetCategory
or ("Egg " .. tostring(rec.Uid or "?"):sub(1, 6))
end
local function rarityIdOf(rec)
local dir = AssetsDir and AssetsDir[rec.AssetCategory]
if dir and dir.Rarity then
return dir.Rarity._id or dir.Rarity.DisplayName or "?"
end
local baked = BX.require("features.catalog").entry(rec.AssetCategory)
if baked and baked.rarityId then return baked.rarityId end
return rec.RarityId or rec.RarityName or rec.Rarity or rec.AssetRarity or "?"
end
local function rarityOf(rec)
local dir = AssetsDir and AssetsDir[rec.AssetCategory]
if dir and dir.Rarity then
return dir.Rarity.DisplayName or dir.Rarity._id or "?"
end
local baked = BX.require("features.catalog").entry(rec.AssetCategory)
if baked and baked.rarity then return baked.rarity end
return rec.RarityName or rec.Rarity or rec.AssetRarity or rec.RarityId or "?"
end
local function weightOf(rec)
local dir = AssetsDir and AssetsDir[rec.AssetCategory]
local base = dir and dir.Egg and tonumber(dir.Egg.WeightKg)
if not base then
local baked = BX.require("features.catalog").entry(rec.AssetCategory)
base = baked and tonumber(baked.weight)
end
if not base then return 0 end
return base * (tonumber(rec.AssetScale) or 1)
end
function M.unpriced(rec)
local category = type(rec) == "table" and (rec.assetCategory or rec.AssetCategory) or rec
if not category then return false end
if AssetsDir and AssetsDir[category] then return false end
return BX.require("features.catalog").entry(category) == nil
end
function M.rateText(egg)
if type(egg) == "table" and egg.unpriced then return "rate unknown" end
local v = type(egg) == "table" and egg.value or tonumber(egg)
return M.formatRate(v or 0) .. "/s"
end
function M.formatRate(n)
n = tonumber(n) or 0
for _, u in ipairs({ { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }) do
if n >= u[1] then
local v = n / u[1]
local txt = (v < 10) and string.format("%.2f", v) or string.format("%.1f", v)
return (txt:gsub("%.?0+$", "")) .. u[2]
end
end
return tostring(math.floor(n))
end
local function readField()
local records = nil
BX.try("eggs.readField", function()
local data = EggState and EggState.ReadFieldEggs and EggState.ReadFieldEggs()
if type(data) == "table" and type(data.Records) == "table" then
records = data.Records
end
end)
return records
end
local REMOTE_TTL = 2.0
local remoteAt, remoteDead, saidRemoteShape = 0, false, false
local saidMissing = false
local function readRemoteField(force)
if remoteDead then return nil end
local now = os.clock()
if not force and (now - remoteAt) < REMOTE_TTL then return nil end
remoteAt = now
local snap = BX.require("core.net").call("RF/EggWorld/AskFieldEggSnapshot")
if type(snap) ~= "table" then
log.warn("RF/EggWorld/AskFieldEggSnapshot gave %s", typeof(snap))
return nil
end
local records = snap.Records or snap.records or snap.Eggs or snap.eggs or snap
if type(records) ~= "table" or #records == 0 then
remoteDead = true
log.warn("field snapshot carried no record list - falling back to the workspace walk")
return nil
end
if not saidRemoteShape then
saidRemoteShape = true
local keys = {}
for key, value in pairs(records[1]) do
keys[#keys + 1] = ("%s:%s"):format(tostring(key), typeof(value))
end
table.sort(keys)
log.info("field snapshot: %d records, fields %s", #records, table.concat(keys, ", "))
end
BX.try("eggs.missingCatalog", function()
if saidMissing then return end
saidMissing = true
local missing, seen = {}, {}
for _, rec in ipairs(records) do
local cat = rec.AssetCategory
if cat and not seen[cat] then
seen[cat] = true
if not (AssetsDir and AssetsDir[cat]) then missing[#missing + 1] = tostring(cat) end
end
end
table.sort(missing)
if #missing > 0 then
log.warn("%d field pets have no catalog entry: %s", #missing,
table.concat(missing, ", "):sub(1, 400))
else
log.info("every pet on the field has a catalog entry")
end
end)
BX.try("eggs.noteCategories", function()
local seen = {}
for _, rec in ipairs(records) do
if rec.AssetCategory then seen[#seen + 1] = rec.AssetCategory end
end
data.noteCategories(seen)
end)
return records
end
local function withPositions(records)
local need = false
for _, rec in ipairs(records) do
if not rec.BoundsCFrame then need = true break end
end
if not need then return records end
local where = {}
BX.try("eggs.positions", function()
local slots = workspace:FindFirstChild("AreaEggSlotsClient")
for _, m in ipairs(slots and slots:GetChildren() or {}) do
if m:IsA("Model") then
local uid = m:GetAttribute("Uid") or m:GetAttribute("EggUid") or m.Name
local hit = m:FindFirstChild("Hitbox")
if uid then
where[tostring(uid)] = (hit and hit:IsA("BasePart")) and hit.CFrame or m:GetPivot()
end
end
end
end)
for _, rec in ipairs(records) do
if not rec.BoundsCFrame and rec.Uid then
rec.BoundsCFrame = where[tostring(rec.Uid)]
end
end
return records
end
local saidSchema = false
local function readAttributes(inst)
local ok, attrs = pcall(inst.GetAttributes, inst)
return (ok and type(attrs) == "table") and attrs or {}
end
local function dumpSchema(model, attrs)
saidSchema = true
BX.try("eggs.schema", function()
local names = {}
for key, value in pairs(attrs) do
names[#names + 1] = ("%s=%s"):format(tostring(key), tostring(value):sub(1, 24))
end
table.sort(names)
log.info("egg model %q attributes: %s", model.Name,
#names > 0 and table.concat(names, ", ") or "(none)")
local slots = model.Parent
local shown = 0
for _, m in ipairs(slots and slots:GetChildren() or {}) do
if m:IsA("Model") and shown < 4 then
shown = shown + 1
local bits = {}
for _, d in ipairs(m:GetDescendants()) do
if d:IsA("MeshPart") then
bits[#bits + 1] = ("mesh %s id=%s size=%s"):format(
d.Name, tostring(d.MeshId), tostring(d.Size))
elseif d:IsA("ProximityPrompt") then
bits[#bits + 1] = ("prompt obj=%q action=%q"):format(
tostring(d.ObjectText), tostring(d.ActionText))
elseif d:IsA("TextLabel") or d:IsA("BillboardGui") then
bits[#bits + 1] = ("%s %s %q"):format(d.ClassName, d.Name,
tostring(d:IsA("TextLabel") and d.Text or ""))
end
local a = readAttributes(d)
for key, value in pairs(a) do
bits[#bits + 1] = ("%s.%s=%s"):format(d.Name, tostring(key), tostring(value):sub(1, 20))
end
end
log.info("egg %d %s: %s", shown, m.Name:sub(1, 8),
#bits > 0 and table.concat(bits, " | ") or "(nothing identifying)")
end
end
local prompts = 0
for _, d in ipairs(workspace:GetDescendants()) do
if d:IsA("ProximityPrompt") then
prompts = prompts + 1
if prompts <= 3 then
log.info("prompt %d at %s: obj=%q action=%q", prompts,
d:GetFullName():sub(1, 90), tostring(d.ObjectText), tostring(d.ActionText))
end
end
end
log.info("prompts in workspace: %d", prompts)
end)
end
local function readFallback(force)
local now = os.clock()
if not force and (now - fallbackAt) < K.FALLBACK_TTL then return nil end
fallbackAt = now
stats.fallbacks = stats.fallbacks + 1
local records = {}
BX.try("eggs.fallback", function()
local slots = workspace:FindFirstChild("AreaEggSlotsClient")
if not slots then return end
for _, m in ipairs(slots:GetChildren()) do
if m:IsA("Model") then
local attrs = readAttributes(m)
local uid = attrs.Uid or attrs.EggUid or m.Name
local cf
local hit = m:FindFirstChild("Hitbox")
if hit and hit:IsA("BasePart") then cf = hit.CFrame else cf = m:GetPivot() end
if uid and cf then
if not saidSchema then dumpSchema(m, attrs) end
records[#records + 1] = {
Uid = tostring(uid), BoundsCFrame = cf, State = "Slot",
AssetCategory = attrs.AssetCategory or attrs.Category
or attrs.Asset or attrs.EggCategory or attrs.PetCategory,
AssetScale = tonumber(attrs.AssetScale or attrs.Scale),
Mutations = type(attrs.Mutations) == "table" and attrs.Mutations or nil,
}
end
end
end
end)
local named = 0
for _, rec in ipairs(records) do
if rec.AssetCategory then named = named + 1 end
end
log.info("fallback scan: %d records from AreaEggSlotsClient (%d with a category%s)",
#records, named, AssetsDir and "" or ", no Assets directory")
return #records > 0 and records or nil
end
local function snapshot(force)
local now = os.clock()
if not force and rawSnap and (now - rawSnapAt) < dev.scale(K.RAW_TTL) then
return rawSnap
end
local records = readField()
if not records or #records == 0 then
local remote = readRemoteField(force)
if remote then records = withPositions(remote) end
end
if not records or #records == 0 then
records = readFallback(force) or records
end
if records and #records > 0 then
rawSnap, rawSnapAt = records, now
end
return rawSnap
end
function M.list(opts, force)
opts = opts or {}
resolveModules()
if repriceWanted then
repriceWanted = false
valueCache, valueCacheN = {}, 0
list, listAt = nil, 0
log.info("asset directory resolved - repricing the field")
end
local now = os.clock()
local fresh = (now - listAt) < dev.scale(K.CACHE_TTL)
local mayRebuild = (now - listAt) >= K.MIN_REBUILD
if not force and list and fresh and not (dirty and mayRebuild) then
stats.cacheHits = stats.cacheHits + 1
return list
end
if dirty and mayRebuild then
stats.dirtyRebuilds = (stats.dirtyRebuilds or 0) + 1
dirty = false
end
local t0 = os.clock()
local records = snapshot(force)
local n = records and #records or 0
if n > K.FULL_FIELD_MIN then sawFullField = true end
if sawFullField and n > 0 and n <= K.PARTIAL_FLOOR and list and #list > 0
and not opts.allowPartial then
if not saidPartial then
saidPartial = true
stats.partialHeld = stats.partialHeld + 1
log.info("only %d records replicated - field still loading, keeping the last %d",
n, #list)
end
return list
end
saidPartial = false
if not records then
list = list or {}
listAt = now
return list
end
pruneStolen()
local TAKEABLE = opts.state or { Slot = true, Dropped = true }
local out, seen = {}, {}
local considered, dupes = 0, 0
for _, rec in ipairs(records) do
considered = considered + 1
enrich(rec)
local uid = rec.Uid and tostring(rec.Uid)
if uid and not seen[uid] then
seen[uid] = true
if not TAKEABLE[rec.State] then
elseif stolen[uid] then
elseif unreachable[uid] then
else
local value = calcValue(rec)
local pos = rec.BoundsCFrame and rec.BoundsCFrame.Position
if pos and (not opts.minValue or value >= opts.minValue)
and (not opts.filter or opts.filter(rec, value)) then
out[#out + 1] = {
uid   = uid,
unpriced = M.unpriced(rec.AssetCategory),
state = rec.State,
pos   = pos,          
value = value,
name  = displayName(rec),
rarity = rarityOf(rec),
rarityId = rarityIdOf(rec),
assetCategory = rec.AssetCategory,
assetScale = rec.AssetScale,
mutations = rec.Mutations,
kg    = weightOf(rec),
guardHeld = (rec.State == "GuardCarried"),
dropped   = (rec.State == "Dropped"),
areaId = rec.AreaId,
nestId = rec.NestId,
}
end
end
elseif uid then
dupes = dupes + 1
end
end
table.sort(out, function(a, b) return a.value > b.value end)
if valueCacheN > (#out * 2 + 50) then
local keep, kept = {}, 0
for _, e in ipairs(out) do
local v = valueCache[e.uid]
if v ~= nil then
keep[e.uid] = v
kept = kept + 1
end
end
log.trace("value cache pruned %d -> %d (field %d)", valueCacheN, kept, #out)
valueCache, valueCacheN = keep, kept
end
list, listAt = out, now
stats.scans = stats.scans + 1
stats.lastScanMs = (os.clock() - t0) * 1000
stats.lastConsidered = considered
stats.lastKept = #out
log.trace("scan: %d records -> %d takeable (%d dupes) in %.1fms, best %s %s/s",
considered, #out, dupes, stats.lastScanMs,
out[1] and out[1].name or "-",
out[1] and string.format("%.0f", out[1].value) or "-")
return list
end
function M.best(opts)
local l = M.list(opts)
return l and l[1] or nil
end
local CARRY_REMOTE = "RF/EggWorld/AskFieldEggCarry"
local SHAPES = {
{ "Uid+FirstAreaSlotKey", function(uid, key, ctx)
return { Uid = uid, FirstAreaSlotKey = key } end },
{ "EggUid+FirstAreaSlotKey", function(uid, key, ctx)
return { EggUid = uid, FirstAreaSlotKey = key } end },
{ "Uid+SlotKey", function(uid, key, ctx)
return { Uid = uid, SlotKey = key } end },
{ "EggUid+SlotKey", function(uid, key, ctx)
return { EggUid = uid, SlotKey = key } end },
{ "Uid+AreaId+NestId", function(uid, key, ctx)
return { Uid = uid, AreaId = ctx.areaId, NestId = ctx.nestId } end },
{ "array", function(uid, key, ctx) return { uid, key } end },
{ "Uid only", function(uid) return { Uid = uid } end },
}
local TRIES_PER_SHAPE = 4
local shapeIndex, shapeLocked, shapeTries = 1, false, 0
local saidSlotKey = false
function M.slotKeyFor(uid, areaId, nestId)
if not uid then return nil end
uid = tostring(uid)
local identity = data.slotIdentity()
if identity and type(identity.LooksLikeFirstAreaUid) == "function"
and type(identity.SlotKey) == "function" then
local key
local ok = pcall(function()
if identity.LooksLikeFirstAreaUid(uid) then key = identity.SlotKey(areaId, nestId) end
end)
if ok and key then return key end
end
local tail = uid:match("([%w%s]+:[%w_]+)$")
if tail then
if not saidSlotKey then
saidSlotKey = true
log.info("slot key derived from the uid: %q -> %q", uid, tail)
end
return tail
end
if uid:find("^FirstAreaEgg") and areaId and nestId then
return tostring(areaId) .. ":" .. tostring(nestId)
end
return nil
end
function M.identityOf(uid)
if not uid then return nil end
return identity[tostring(uid)]
end
function M.rarityNumOf(category)
if not category then return nil end
local dir = AssetsDir and AssetsDir[category]
local r = dir and dir.Rarity
local num = r and tonumber(r.RarityNumber)
if num then return num end
local baked = BX.require("features.catalog").entry(category)
return baked and tonumber(baked.rarityNum) or nil
end
function M.bestAtLeast(tier)
if not tier then return M.best() end
local best, bestValue
for _, e in ipairs(M.list({ allowPartial = true }) or {}) do
local num = M.rarityNumOf(e.assetCategory)
if num and num >= tier and (not bestValue or (e.value or 0) > bestValue) then
best, bestValue = e, e.value or 0
end
end
return best
end
function M.carry(uid, slotKey, ctx)
resolveModules()
if EggState and type(EggState.CarryFieldEgg) == "function" then
return EggState.CarryFieldEgg(uid, slotKey)
end
ctx = ctx or {}
local shape = SHAPES[shapeIndex]
local res, msg = BX.require("core.net").call(CARRY_REMOTE, shape[2](uid, slotKey, ctx))
if res == true then
if not shapeLocked then
shapeLocked = true
log.info("carry accepted with shape %q", shape[1])
end
return res, msg
end
if not shapeLocked then
shapeTries = shapeTries + 1
if shapeTries >= TRIES_PER_SHAPE and shapeIndex < #SHAPES then
log.warn("carry shape %q -> %s; trying %q",
shape[1], tostring(msg or res), SHAPES[shapeIndex + 1][1])
shapeIndex, shapeTries = shapeIndex + 1, 0
end
end
return res, msg
end
local ownerAt, ownerCache = 0, nil
local OWNER_TTL = 3
function M.ownerEggs(userId)
resolveModules()
userId = userId or (svc.Players.LocalPlayer and svc.Players.LocalPlayer.UserId)
if not userId then return {} end
if EggState and type(EggState.ReadOwnerEggs) == "function" then
local ok, recs = pcall(EggState.ReadOwnerEggs, userId)
if ok and type(recs) == "table" then return recs end
end
local now = os.clock()
if ownerCache and (now - ownerAt) < OWNER_TTL then return ownerCache end
local snap = BX.require("core.net").call("RF/EggWorld/AskLiveSnapshot")
local mine = {}
if type(snap) == "table" then
for _, row in pairs(snap) do
if type(row) == "table" and tonumber(row.OwnerUserId) == tonumber(userId) then
mine = type(row.Records) == "table" and row.Records or {}
break
end
end
end
ownerCache, ownerAt = mine, now
return mine
end
function M.records(force)
resolveModules()
return snapshot(force) or {}
end
local saidHeld, saidHeldOwn = false, false
function M.heldUid()
local found, sawTool
BX.try("eggs.heldUid", function()
local char = BX.require("core.character").get()
for _, where in ipairs({ char }) do
for _, c in ipairs(where and where:GetChildren() or {}) do
if c:IsA("Tool") and c:GetAttribute("ItemType") == "AssetEgg" then
sawTool = c
local uid = c:GetAttribute("UID")
found = uid and tostring(uid) or nil
break
end
end
if sawTool then break end
end
if not sawTool and not saidHeld then
saidHeld = true
local bits = {}
for _, c in ipairs(char and char:GetChildren() or {}) do
if not c:IsA("BasePart") and not c:IsA("Humanoid") then
local attrs = {}
local okA, all = pcall(c.GetAttributes, c)
if okA and type(all) == "table" then
for key, value in pairs(all) do
attrs[#attrs + 1] = ("%s=%s"):format(tostring(key), tostring(value):sub(1, 24))
end
table.sort(attrs)
end
bits[#bits + 1] = ("%s:%s%s"):format(c.ClassName, c.Name,
#attrs > 0 and ("{" .. table.concat(attrs, ",") .. "}") or "")
end
if #bits >= 14 then break end
end
log.info("no egg tool found; character holds: %s",
#bits > 0 and table.concat(bits, " | ") or "(nothing)")
end
if sawTool and not saidHeld then
saidHeld = true
local attrs = {}
local ok, all = pcall(sawTool.GetAttributes, sawTool)
if ok and type(all) == "table" then
for key, value in pairs(all) do
attrs[#attrs + 1] = ("%s=%s"):format(tostring(key), tostring(value):sub(1, 40))
end
table.sort(attrs)
end
log.info("egg tool %q held: %s", sawTool.Name,
#attrs > 0 and table.concat(attrs, ", ") or "(no attributes)")
end
end)
return found
end
function M.holdingAnyEgg()
local char = BX.require("core.character").get()
for _, c in ipairs(char and char:GetChildren() or {}) do
if c:IsA("Tool") and c:GetAttribute("ItemType") == "AssetEgg" then return true end
end
return false
end
function M.get(uid, force)
if not uid then return nil end
resolveModules()
local rec
BX.try("eggs.get", function()
rec = EggState and EggState.ReadFieldEgg and EggState.ReadFieldEgg(uid)
end)
if not rec then
local want = tostring(uid)
local function findIn(records)
for _, candidate in ipairs(records or {}) do
if tostring(candidate.Uid) == want then return candidate end
end
return nil
end
if not force then rec = findIn(rawSnap) end
if not rec then rec = findIn(snapshot(force and true or false)) end
end
if not rec then return nil end
enrich(rec)
local state = rec.State
if M.heldUid() == tostring(uid) then state = "Carried" end
return {
uid   = tostring(uid),
unpriced = M.unpriced(rec.AssetCategory),
state = state,
carrier = tonumber(rec.CarrierUserId),
pos   = rec.BoundsCFrame and rec.BoundsCFrame.Position,
value = calcValue(rec),
name  = displayName(rec),
rarity = rarityOf(rec),
rarityId = rarityIdOf(rec),
assetCategory = rec.AssetCategory,
assetScale = rec.AssetScale,
mutations = rec.Mutations,
kg    = weightOf(rec),
areaId = rec.AreaId,
nestId = rec.NestId,
}
end
function M.carryingUid()
local held = M.heldUid()
if held then
local inTransit = false
BX.try("eggs.heldInField", function()
for _, r in pairs(M.records()) do
if tostring(r.Uid) == held then
inTransit = (r.State == "Carried" or r.State == "Dropped")
break
end
end
end)
if inTransit then return held end
if not saidHeldOwn then
saidHeldOwn = true
log.info("holding egg %s, but it is not a field egg in transit - yours, not a steal",
held)
end
end
local found
local me = svc.Players.LocalPlayer and svc.Players.LocalPlayer.UserId
BX.try("eggs.carryingUid", function()
local mayOmitCarrier = EggState ~= nil
for _, r in pairs(M.records()) do
if r.State == "Carried" then
local carrier = tonumber(r.CarrierUserId)
if carrier == me or (mayOmitCarrier and carrier == nil) then
found = tostring(r.Uid)
break
end
end
end
end)
return found
end
function M.stillTakeable(uid, states)
local r = M.get(uid)
if not r then return false, "gone" end
local ok = (states or { Slot = true, Dropped = true })[r.state]
return ok and true or false, r.state
end
function M.stats()
local s = table.clone(stats)
s.listSize = list and #list or 0
s.valueCache = valueCacheN
s.sawFullField = sawFullField
return s
end
local WATCH = {
"CarryChanged",      
"FieldShifted",      
"FieldRefreshed",    
"FieldGone",         
"FieldClaimed",      
"SnapshotRefreshed", 
}
local sc = BX.scope("features.eggs")
local watched = 0
if EggState then
for _, name in ipairs(WATCH) do
BX.try("eggs.watch." .. name, function()
local sig = EggState[name]
if sig and type(sig) == "table" and type(sig.Connect) == "function" then
sc:connect(sig, function() M.markDirty(name) end)
watched = watched + 1
end
end)
end
end
log.info("watching %d/%d EggState signals", watched, #WATCH)
BX.require("core.character").onSpawn(sc, "eggs.respawn", function()
M.invalidate("respawn")
end)
return M
end)
BX.module("features.grab", function(BX)
local svc  = BX.require("core.services")
local data = BX.require("core.data")
local exec = BX.require("core.exec")
local ch   = BX.require("core.character")
local dev  = BX.require("core.device")
local scan = BX.require("core.scan")
local eggs = BX.require("features.eggs")
local log  = BX.require("boot.log").for_module("grab")
local RunService = svc.RunService
local M = {}
local K = {
PROMPT_CACHE   = 30,    
PROMPT_NEAR    = 14,    
PROMPT_WAIT    = 0.6,   
STEP_INSIDE    = 3,     
CONFIRM_WINDOW = 1.2,   
TRIES          = 3,
RETRY_GAP      = 0.15,  
TP_PROMPT_WAIT = 1.2,   
}
M.K = K
local EggState = data.eggState()
local prompts, promptsAt = nil, 0
BX.profile.watch("grab.prompts", function() return prompts and #prompts or 0 end)
local function promptList()
local now = os.clock()
if prompts and (now - promptsAt) < K.PROMPT_CACHE then
return prompts
end
local t0 = os.clock()
local found = {}
local function consider(d)
if d:IsA("ProximityPrompt") then
local txt = string.lower(tostring(d.ActionText) .. " "
.. tostring(d.ObjectText) .. " " .. d.Name)
if txt:find("steal") or txt:find("carry") then
found[#found + 1] = d
end
end
end
local sawHome = false
for _, c in ipairs(workspace:GetChildren()) do
if c.Name == "SmartPromptPart" then
sawHome = true
for _, d in ipairs(c:GetDescendants()) do consider(d) end
end
end
if not sawHome and not M._fullScanDone then
M._fullScanDone = true
for _, d in ipairs(scan.snapshot(workspace, 0.0015)) do consider(d) end
end
prompts, promptsAt = found, now
log.trace("prompt cache rebuilt: %d prompts in %.1fms (%s)", #found,
(os.clock() - t0) * 1000, sawHome and "SmartPromptPart" or "full scan")
return prompts
end
local function promptPos(p)
local parent = p.Parent
if not parent then return nil end
if parent:IsA("BasePart") then return parent.Position end
if parent:IsA("Model") then return parent:GetPivot().Position end
return nil
end
function M.waitForPrompt(targetPos, cancel, seconds)
if typeof(targetPos) ~= "Vector3" then return false end
local listed = promptList()
local t0 = os.clock()
local until_ = t0 + dev.scale(seconds or K.TP_PROMPT_WAIT)
repeat
if cancel and cancel() then return false end
for _, d in ipairs(listed) do
if d.Parent and d.Enabled then
local pos = promptPos(d)
if pos and (pos - targetPos).Magnitude <= K.PROMPT_NEAR then
log.trace("prompt arrived after %.2fs", os.clock() - t0)
return true
end
end
end
task.wait(0.05)
until os.clock() > until_
log.trace("prompt never showed after %.2fs", os.clock() - t0)
return false
end
function M.confirm(uid, baseWalkSpeed, carrySignal)
if carrySignal then return true, "CarryChanged" end
local hum = ch.humanoid()
if hum and baseWalkSpeed and hum.WalkSpeed and hum.WalkSpeed < (baseWalkSpeed - 1) then
return true, "walkspeed drop"
end
local char = ch.get()
if char then
for _, c in ipairs(char:GetChildren()) do
if c:IsA("Tool") and c:GetAttribute("ItemType") == "AssetEgg"
and tostring(c:GetAttribute("UID")) == tostring(uid) then
return true, "egg tool in hand"
end
end
end
local rec = eggs.get(uid)
if rec and rec.state == "Carried" then return true, "ReadFieldEgg" end
local any
BX.try("grab.confirmAll", function()
for _, r in pairs(eggs.records()) do
if r.State == "Carried" and tostring(r.Uid) == tostring(uid) then
any = true
break
end
end
end)
if any then return true, "ReadFieldEggs" end
return false, rec and rec.state or "unknown"
end
local function fireAt(targetPos, cancel)
if not exec.can.prompts then
return false, "executor has no fireproximityprompt"
end
local hrp = ch.root()
if not hrp then return false, "no root" end
local listed = promptList()
if typeof(targetPos) == "Vector3" then
M.waitForPrompt(targetPos, cancel, K.PROMPT_WAIT)
if cancel and cancel() then return false, "cancelled" end
end
local best, bestDist = nil, math.huge
for _, d in ipairs(listed) do
if d.Parent and d.Enabled then
local pos = promptPos(d)
if pos then
local onTarget = (typeof(targetPos) ~= "Vector3")
or ((pos - targetPos).Magnitude <= K.PROMPT_NEAR)
local dist = (hrp.Position - pos).Magnitude
if onTarget and dist <= (d.MaxActivationDistance + 8) and dist < bestDist then
best, bestDist = d, dist
end
end
end
end
if not best then return false, "no prompt for this egg" end
local pos = promptPos(best)
local limit = (best.MaxActivationDistance or 8) - K.STEP_INSIDE
if pos and bestDist > limit then
local from = hrp.Position
local step = pos - from
local want = pos - (step.Magnitude > 0.1 and step.Unit or Vector3.new(0, 0, 1))
* math.max(limit * 0.5, 2)
pcall(function()
hrp.CFrame = CFrame.new(Vector3.new(want.X, from.Y, want.Z))
hrp.AssemblyLinearVelocity = Vector3.zero
end)
RunService.Heartbeat:Wait()
local h2 = ch.root()
if h2 then bestDist = (h2.Position - pos).Magnitude end
end
local wasHold, wasLoS = best.HoldDuration, best.RequiresLineOfSight
pcall(function()
best.HoldDuration = 0
best.RequiresLineOfSight = false
end)
local fired = exec.firePrompt(best, 0)
if fired then exec.firePrompt(best) end
pcall(function()
best.HoldDuration = wasHold
best.RequiresLineOfSight = wasLoS
end)
return fired and true or false,
fired and ("fired at %.1f studs"):format(bestDist)
or "fireproximityprompt failed",
bestDist
end
local stats = { attempts = 0, taken = 0, failed = 0, cancelled = 0 }
function M.stats() return table.clone(stats) end
function M.take(uid, opts)
opts = opts or {}
local cancel = opts.cancel
local tries  = opts.tries or K.TRIES
local targetPos = opts.pos
stats.attempts = stats.attempts + 1
local t0 = os.clock()
local hum0 = ch.humanoid()
local baseWS = (hum0 and hum0.WalkSpeed and hum0.WalkSpeed > 0) and hum0.WalkSpeed or nil
local sc = BX.scope("features.grab.attempt")
local carrySignal = false
if EggState and EggState.CarryChanged then
BX.try("grab.watchCarry", function()
sc:connect(EggState.CarryChanged, function(info)
if type(info) ~= "table" or info.Uid == nil
or tostring(info.Uid) == tostring(uid) then
carrySignal = true
end
end)
end)
end
local function finish(ok, reason, attempt, fireDist)
sc:destroy()
local ms = (os.clock() - t0) * 1000
if ok then
stats.taken = stats.taken + 1
eggs.markStolen(uid)
elseif reason == "cancelled" then
stats.cancelled = stats.cancelled + 1
else
stats.failed = stats.failed + 1
end
local level = ok and log.info or log.warn
level("%s uid=%s after %d/%d tries in %.0fms (witness=%s dist=%s tier=%s)",
ok and "TAKEN" or ("FAILED: " .. tostring(reason)),
tostring(uid), attempt or 0, tries, ms, tostring(reason),
fireDist and string.format("%.1f", fireDist) or "-", dev.tier)
return ok, {
reason = reason, attempts = attempt or 0,
ms = ms, distance = fireDist,
}
end
local have, witness = M.confirm(uid, baseWS, carrySignal)
if have then return finish(true, witness, 0) end
for attempt = 1, tries do
if cancel and cancel() then return finish(false, "cancelled", attempt) end
if not ch.root() then return finish(false, "no character", attempt) end
local ok, state = eggs.stillTakeable(uid)
if not ok and not carrySignal then
return finish(false, "egg " .. tostring(state), attempt)
end
local fired, why, dist = fireAt(targetPos, cancel)
if why == "cancelled" then return finish(false, "cancelled", attempt) end
if fired then
local until_ = os.clock() + dev.scale(K.CONFIRM_WINDOW)
repeat
if cancel and cancel() then return finish(false, "cancelled", attempt, dist) end
local got, w = M.confirm(uid, baseWS, carrySignal)
if got then return finish(true, w, attempt, dist) end
RunService.Heartbeat:Wait()
until os.clock() > until_
end
if attempt < tries then task.wait(dev.scale(K.RETRY_GAP)) end
end
local got, w = M.confirm(uid, baseWS, carrySignal)
if got then return finish(true, w, tries) end
return finish(false, "no confirmation", tries)
end
function M.warmPrompts()
local t0 = os.clock()
local n = #promptList()
return (os.clock() - t0) * 1000, n
end
function M.clearCache()
prompts, promptsAt = nil, 0
end
return M
end)
BX.module("features.instant", function(BX)
local svc  = BX.require("core.services")
local data = BX.require("core.data")
local net  = BX.require("core.net")
local ch   = BX.require("core.character")
local dev  = BX.require("core.device")
local eggs  = BX.require("features.eggs")
local guard = BX.require("features.guard")
local log  = BX.require("boot.log").for_module("instant")
local RunService = svc.RunService
local M = {}
local K = {
TIMEOUT       = 3,     
RACE_THREADS  = 3,     
RACE_STAGGER  = 0.05,  
LIFT          = 2,     
PULLBACK_GAP  = 25,
FREE_CALLS    = 12,    
SAME_MSG_GAP  = 0.12,  
SAME_MSG_STOP = 30,    
EARLY_LEAD    = 0.25,  
DOWNED_POLL   = 0.05,  
TAKEN_LOOK    = 0.2,   
TAKEN_CONFIRM = 0.35,  
}
M.K = K
local EggState, SlotIdentity = data.eggState(), data.slotIdentity()
local CARRY_REMOTE = "RF/EggWorld/AskFieldEggCarry"
local function carry(uid, slotKey, ctx)
return eggs.carry(uid, slotKey, ctx)
end
local function ensureModules()
if not EggState then EggState = data.eggState() end
if not SlotIdentity then SlotIdentity = data.slotIdentity() end
local viaModule = (EggState ~= nil and type(EggState.CarryFieldEgg) == "function")
local viaRemote = net.find(CARRY_REMOTE) ~= nil
M.ready = viaModule or viaRemote
M.via = viaModule and "module" or (viaRemote and "remote" or nil)
return M.ready
end
ensureModules()
if not M.ready then
log.warn("no CarryFieldEgg and no %s - instant steal disabled until one resolves", CARRY_REMOTE)
elseif M.via == "remote" then
log.info("instant steal via %s (EggState cannot be required here)", CARRY_REMOTE)
end
local function inOurHand(uid)
local char = ch.get()
if not char then return false end
for _, c in ipairs(char:GetChildren()) do
if c:IsA("Tool") and c:GetAttribute("ItemType") == "AssetEgg"
and tostring(c:GetAttribute("UID")) == tostring(uid) then
return true
end
end
return false
end
local holdGen = 0
local stats = { runs = 0, won = 0, lost = 0, cancelled = 0, calls = 0 }
function M.stats() return table.clone(stats) end
local function slotKeyFor(uid, areaId, nestId)
local key = nil
BX.try("instant.slotKey", function()
key = eggs.slotKeyFor(uid, areaId, nestId)
end)
return key
end
function M.take(uid, eggPos, opts)
opts = opts or {}
local cancel = opts.cancel or function() return false end
if not M.ready and not ensureModules() then return false, { reason = "no carry path" } end
if typeof(eggPos) ~= "Vector3" then return false, { reason = "no egg position" } end
local char = ch.get()
if not char then return false, { reason = "no character" } end
stats.runs = stats.runs + 1
local t0 = os.clock()
local target = CFrame.new(eggPos.X, eggPos.Y + K.LIFT, eggPos.Z)
local slotKey = slotKeyFor(uid, opts.areaId, opts.nestId)
local deadline = os.clock() + dev.scale(opts.timeout or K.TIMEOUT) + 3
local sc = BX.scope("features.instant.race")
holdGen = holdGen + 1
local myGen = holdGen
local won, tries, lastMsg = false, 0, nil
local sameMsg, sameCount = nil, 0
local bailed = false
BX.profile.mark("target_tp")
sc:spawn("hold", function()
while not won and holdGen == myGen and os.clock() < deadline and sc:alive() do
local c = ch.get()
if c then pcall(function() c:PivotTo(target) end) end
local h = ch.root()
if h then
h.AssemblyLinearVelocity = Vector3.zero
h.AssemblyAngularVelocity = Vector3.zero
end
RunService.Heartbeat:Wait()
end
end)
local heldFor, knockdown = guard.waitForServerRelease(cancel, K.EARLY_LEAD)
local raceFrom = os.clock()
deadline = raceFrom + dev.scale(opts.timeout or K.TIMEOUT)
if cancel() then
holdGen = holdGen + 1
sc:destroy()
stats.cancelled = stats.cancelled + 1
return false, { reason = "cancelled", ms = (os.clock() - t0) * 1000 }
end
for i = 1, K.RACE_THREADS do
sc:spawn("invoke" .. i, function()
task.wait((i - 1) * K.RACE_STAGGER)
while not won and not bailed and os.clock() < deadline and sc:alive() do
if cancel() then return end
tries = tries + 1
stats.calls = stats.calls + 1
local ok, res, msg = pcall(function()
return carry(uid, slotKey, { areaId = opts.areaId, nestId = opts.nestId })
end)
if msg ~= nil then lastMsg = tostring(msg) end
local downed = type(msg) == "string" and msg:lower():find("downed") ~= nil
if downed and not won then
local left = guard.ragdollRemaining()
task.wait(math.clamp(left, K.DOWNED_POLL, 0.25))
end
if not won and not downed and type(msg) == "string" then
if msg == sameMsg then
sameCount = sameCount + 1
else
sameMsg, sameCount = msg, 1
end
if sameCount >= K.SAME_MSG_STOP then
bailed = true
return
end
if tries > K.FREE_CALLS and sameCount > 1 then
task.wait(K.SAME_MSG_GAP)
end
end
if ok and res == true and not won then
won = true
return
end
if won then return end
RunService.Heartbeat:Wait()
end
end)
end
local cancelled, takenBy = false, nil
local nextLook, goneSince = 0, nil
while not won and not bailed and os.clock() < deadline do
if cancel() then cancelled = true break end
local now = os.clock()
if now >= nextLook then
nextLook = now + K.TAKEN_LOOK
local rec = eggs.get(uid)
local takeable = rec and (rec.state == "Slot" or rec.state == "Dropped")
local me = svc.Players.LocalPlayer and svc.Players.LocalPlayer.UserId
if rec and rec.state == "Carried" and rec.carrier and rec.carrier ~= me then
takenBy = "carried by another player"
bailed = true
break
elseif takeable or inOurHand(uid)
or (rec and rec.state == "Carried" and rec.carrier == me) then
goneSince = nil
else
goneSince = goneSince or now
if (now - goneSince) >= K.TAKEN_CONFIRM and not won then
takenBy = rec and tostring(rec.state) or "gone"
bailed = true
break
end
end
end
RunService.Heartbeat:Wait()
end
holdGen = holdGen + 1
sc:destroy()
local ms = (os.clock() - t0) * 1000
local gap = (function()
local h = ch.root()
return h and (h.Position - eggPos).Magnitude or -1
end)()
if cancelled then
stats.cancelled = stats.cancelled + 1
log.info("cancelled after %d calls in %.0fms", tries, ms)
return false, { reason = "cancelled", calls = tries, ms = ms }
end
BX.profile.mark(won and "target_landed" or "target_lost")
if won then
stats.won = stats.won + 1
eggs.markStolen(uid)
log.info("WON uid=%s after %d calls in %.0fms (knockdown %.2fs, race %.0fms, %d threads, gap %.1f, tier=%s)",
tostring(uid), tries, ms, knockdown or 0, (os.clock() - raceFrom) * 1000,
K.RACE_THREADS, gap, dev.tier)
return true, { reason = "instant", calls = tries, ms = ms,
gap = gap, heldFor = heldFor }
end
stats.lost = stats.lost + 1
local rec = eggs.get(uid)
local pulledBack = gap > K.PULLBACK_GAP
local diag = ("localGap=%.1f eggState=%s eggMoved=%s pulledBack=%s%s"):format(
gap,
rec and tostring(rec.state) or "gone",
rec and rec.pos and tostring((rec.pos - eggPos).Magnitude > 5) or "?",
tostring(pulledBack),
takenBy and (" taken by someone else (%s)"):format(takenBy)
or (bailed and (" bailed after %d identical refusals"):format(sameCount) or ""))
log.warn("LOST uid=%s after %d calls in %.0fms (%s, last: %s, tier=%s)",
tostring(uid), tries, ms, diag, tostring(lastMsg), dev.tier)
return false, {
reason = takenBy and "egg taken by someone else" or lastMsg or "no accept",
taken = takenBy ~= nil,
calls = tries, ms = ms, gap = gap,
pulledBack = pulledBack,
eggState = rec and rec.state or "gone",
eggGone = rec == nil,
heldFor = heldFor,
}
end
return M
end)
BX.module("features.plot", function(BX)
local svc = BX.require("core.services")
local exec = BX.require("core.exec")
local data = BX.require("core.data")
local log = BX.require("boot.log").for_module("plot")
local M = {}
local K = {
HOME_TTL = 30,      
ARRIVE   = 18,      
}
M.K = K
local PlotState = data.plotState()
local cached, cachedAt, cachedVia = nil, 0, nil
local function resolve()
local pos, via
if PlotState then
BX.try("plot.findRespawn", function()
local cf = PlotState.FindRespawnCFrame and PlotState.FindRespawnCFrame()
if typeof(cf) == "CFrame" then pos, via = cf.Position, "PlotState.FindRespawnCFrame" end
end)
end
if not pos and PlotState then
BX.try("plot.resolveSlot", function()
local slot = PlotState.ResolveLocalSlot and PlotState.ResolveLocalSlot()
local plots = slot and workspace:FindFirstChild("Plots")
local mine = plots and plots:FindFirstChild(tostring(slot))
if mine then
local cf = mine:GetPivot()
if typeof(cf) == "CFrame" then pos, via = cf.Position, "plot " .. tostring(slot) end
end
end)
end
if not pos then
BX.try("plot.spawnLocation", function()
local sl = workspace:FindFirstChildOfClass("SpawnLocation")
if sl and sl:IsA("BasePart") then
pos, via = sl.Position + Vector3.new(0, 4, 0), "SpawnLocation"
end
end)
end
if not pos then
BX.try("plot.spawnTarget", function()
local st = workspace:FindFirstChild("SpawnTarget", true)
if st and st:IsA("BasePart") then
pos, via = st.Position + Vector3.new(0, 4, 0), "SpawnTarget"
end
end)
end
return pos, via
end
function M.home()
local now = os.clock()
if cached and (now - cachedAt) < K.HOME_TTL then
return cached, cachedVia
end
local pos, via = resolve()
if not pos then
log.error("cannot resolve this player's plot - refusing to deliver "
.. "(PlotState=%s)", tostring(PlotState ~= nil))
return nil, "no plot resolved"
end
if via ~= cachedVia then
log.info("home resolved via %s at %s", via, tostring(pos))
end
cached, cachedAt, cachedVia = pos, now, via
return cached, cachedVia
end
function M.forget()
cached, cachedAt = nil, 0
end
local szCache, szAt, szVia = nil, 0, nil
function M.safeZone()
local now = os.clock()
if szCache and (now - szAt) < K.HOME_TTL then
return szCache, szVia
end
local pos, via
BX.try("plot.spawnLocationZone", function()
local sl = workspace:FindFirstChildOfClass("SpawnLocation")
if sl and sl:IsA("BasePart") then
pos, via = sl.Position + Vector3.new(0, 4, 0), "SpawnLocation"
end
end)
if not pos then
BX.try("plot.spawnTargetZone", function()
local st = workspace:FindFirstChild("SpawnTarget", true)
if st and st:IsA("BasePart") then
pos, via = st.Position + Vector3.new(0, 4, 0), "SpawnTarget"
end
end)
end
if not pos then
local p, pvia = M.home()
if p then pos, via = p, "plot fallback (" .. tostring(pvia) .. ")" end
end
if not pos then
log.error("cannot resolve a safe zone - refusing to deliver")
return nil, "unresolved"
end
if via ~= szVia then
log.info("safe zone resolved via %s at %s", via, tostring(pos))
end
szCache, szAt, szVia = pos, now, via
return szCache, szVia
end
function M.forgetSafeZone()
szCache, szAt = nil, 0
end
local lastClaimAt, lastClaimName, lastClaimInfo = 0, nil, nil
local listeners = {}
function M.claimedSince(t)
return lastClaimAt > (t or 0), lastClaimName
end
function M.onClaim(sc, label, fn)
listeners[#listeners + 1] = { scope = sc, label = label, fn = fn }
end
local sc = BX.scope("features.plot")
local EggState
BX.try("plot.resolveEggState", function()
local found = svc.ReplicatedStorage:FindFirstChild("EggState", true)
if found and found:IsA("ModuleScript") then EggState = exec.requireGame(found) end
end)
if EggState and EggState.FieldClaimed then
BX.try("plot.armClaimWatch", function()
sc:connect(EggState.FieldClaimed, function(info)
lastClaimAt = os.clock()
lastClaimInfo = info
lastClaimName = (type(info) == "table"
and (info.DisplayName or info.AssetCategory)) or "egg"
log.info("CLAIM: server claimed our egg -> %s", tostring(lastClaimName))
for i = #listeners, 1, -1 do
local L = listeners[i]
if not L.scope or L.scope.dead then
table.remove(listeners, i)
else
BX.try("plot/" .. L.label, L.fn, lastClaimName, lastClaimInfo)
end
end
end)
end)
else
local re = BX.require("core.net").find("RE/EggWorld/FieldEggRedeemVerdict")
if re and re:IsA("RemoteEvent") then
log.info("deliveries confirmed via RE/EggWorld/FieldEggRedeemVerdict")
local saidShape = false
BX.try("plot.armVerdictWatch", function()
sc:connect(re.OnClientEvent, function(info)
if not saidShape then
saidShape = true
local fields = {}
if type(info) == "table" then
for key, value in pairs(info) do
fields[#fields + 1] = ("%s=%s"):format(tostring(key), tostring(value):sub(1, 20))
end
end
log.info("redeem verdict payload: %s",
#fields > 0 and table.concat(fields, ", ") or typeof(info))
end
if type(info) == "table" and (info.Accepted == false or info.Success == false
or info.Ok == false) then
return
end
lastClaimAt = os.clock()
lastClaimInfo = info
lastClaimName = (type(info) == "table"
and (info.DisplayName or info.AssetCategory)) or "egg"
log.info("CLAIM: redeem verdict -> %s", tostring(lastClaimName))
for i = #listeners, 1, -1 do
local L = listeners[i]
if not L.scope or L.scope.dead then
table.remove(listeners, i)
else
BX.try("plot/" .. L.label, L.fn, lastClaimName, lastClaimInfo)
end
end
end)
end)
else
log.warn("EggState.FieldClaimed unavailable - deliveries cannot be confirmed")
end
end
M._listeners = function() return #listeners end
return M
end)
BX.module("features.regrab", function(BX)
local svc     = BX.require("core.services")
local eggs    = BX.require("features.eggs")
local instant = BX.require("features.instant")
local guard   = BX.require("features.guard")
local ch      = BX.require("core.character")
local dev     = BX.require("core.device")
local log     = BX.require("boot.log").for_module("regrab")
local RunService = svc.RunService
local M = {}
local K = {
SETTLE      = 0.08,   
WAIT        = 8.0,    
POLL        = 0.05,
TRIES       = 4,      
MAX_PER_STEAL = 2,    
}
M.K = K
local stats = { runs = 0, recovered = 0, banked = 0, gone = 0, failed = 0, cancelled = 0 }
function M.stats() return table.clone(stats) end
local function settledPos(uid)
local r = eggs.get(uid)
if not r then return nil, nil end
return r.pos, r.state
end
function M.recover(uid, opts)
opts = opts or {}
local cancel = opts.cancel or function() return false end
stats.runs = stats.runs + 1
local t0 = os.clock()
task.wait(K.SETTLE)
if cancel() then
stats.cancelled = stats.cancelled + 1
return false, { reason = "cancelled", recovery = "cancelled" }
end
local deadline = os.clock() + dev.scale(K.WAIT)
local pos, state, said
repeat
if cancel() then
stats.cancelled = stats.cancelled + 1
return false, { reason = "cancelled", recovery = "cancelled" }
end
pos, state = settledPos(uid)
if state == "Claimed" then
stats.banked = stats.banked + 1
log.info("drop_recovery=banked uid=%s (the egg was claimed)", tostring(uid))
return false, { reason = "claimed", recovery = "banked" }
end
if state == nil then
stats.gone = stats.gone + 1
log.warn("drop_recovery=failed uid=%s (record gone)", tostring(uid))
return false, { reason = "gone", recovery = "failed" }
end
if state == "Slot" or state == "Dropped" then break end
if state == "Carried" and eggs.carryingUid() == tostring(uid) then
stats.recovered = stats.recovered + 1
log.info("drop_recovery=still_ours uid=%s after %.2fs - carrying it home",
tostring(uid), os.clock() - t0)
return true, { recovery = "still ours", attempts = 0,
ms = (os.clock() - t0) * 1000 }
end
if state ~= said then
said = state
log.trace("egg is %s - waiting for it to settle", tostring(state))
end
task.wait(K.POLL)
until os.clock() > deadline
if state ~= "Slot" and state ~= "Dropped" then
stats.failed = stats.failed + 1
log.warn("drop_recovery=failed uid=%s (still %s after %.1fs)",
tostring(uid), tostring(state), os.clock() - t0)
return false, { reason = "never settled (" .. tostring(state) .. ")",
recovery = "failed" }
end
for attempt = 1, K.TRIES do
if cancel() then
stats.cancelled = stats.cancelled + 1
return false, { reason = "cancelled", recovery = "cancelled" }
end
local pNow, sNow = settledPos(uid)
if sNow == "Claimed" then
stats.banked = stats.banked + 1
log.info("drop_recovery=banked uid=%s (claimed on the way)", tostring(uid))
return false, { reason = "claimed", recovery = "banked" }
end
if not pNow then
stats.gone = stats.gone + 1
log.warn("drop_recovery=failed uid=%s (record gone on the way)", tostring(uid))
return false, { reason = "gone", recovery = "failed" }
end
local hrp = ch.root()
local gapBefore = hrp and (pNow - hrp.Position).Magnitude or -1
local got, info = instant.take(uid, pNow, {
cancel = cancel,
areaId = opts.areaId, nestId = opts.nestId,
})
if got then
stats.recovered = stats.recovered + 1
log.info("drop_recovery=tp uid=%s attempt %d/%d in %.2fs "
.. "(was %.0f studs out, %d calls)",
tostring(uid), attempt, K.TRIES, os.clock() - t0,
gapBefore, info and info.calls or -1)
return true, { recovery = "tp", attempts = attempt,
ms = (os.clock() - t0) * 1000 }
end
if info and info.pulledBack then
log.warn("drop_recovery=tp_refused uid=%s attempt %d/%d "
.. "(landed %.0f studs off, reason=%s)",
tostring(uid), attempt, K.TRIES,
info.gap or -1, tostring(info.reason))
elseif info and type(info.reason) == "string"
and (info.reason:lower():find("get closer", 1, true)
or info.reason:lower():find("not currently trusted", 1, true)) then
stats.rebait = (stats.rebait or 0) + 1
log.info("drop_recovery=rebait uid=%s (in-knockdown pickup refused: %s, %.2fs)",
tostring(uid), info.reason, os.clock() - t0)
return false, { reason = "knockdown window missed", recovery = "rebait" }
else
log.trace("attempt %d/%d: %s (egg %s, %.0f studs)",
attempt, K.TRIES, tostring(info and info.reason),
tostring(sNow), gapBefore)
end
task.wait(dev.scale(K.POLL))
end
stats.failed = stats.failed + 1
log.warn("drop_recovery=failed uid=%s after %d attempts in %.2fs",
tostring(uid), K.TRIES, os.clock() - t0)
return false, { reason = "no regrab", recovery = "failed" }
end
return M
end)
BX.module("features.carry", function(BX)
local svc  = BX.require("core.services")
local move = BX.require("features.movement")
local plot = BX.require("features.plot")
local eggs = BX.require("features.eggs")
local ch   = BX.require("core.character")
local dev  = BX.require("core.device")
local log  = BX.require("boot.log").for_module("carry")
local motion = BX.require("core.motion")
local exec   = BX.require("core.exec")
local M = {}
local K = {
SPEED      = 500,   
ARRIVE     = 5,     
CLAIM_WAIT = 6,     
SPEED_TOP  = 800,
STEP       = 60,
SOFT_STRIKES = 2,
}
M.K = K
local stats = { runs = 0, delivered = 0, failed = 0, cancelled = 0, lost = 0 }
function M.stats() return table.clone(stats) end
local SPEED_FILE = "VoidcxzHub/carry_speed.json"
local SPEED_FILE_V = 2
local speed = { current = K.SPEED, ceiling = nil }
BX.try("carry.loadSpeed", function()
if not exec.isFile(SPEED_FILE) then return end
local raw = exec.readFile(SPEED_FILE)
if not raw then return end
local t = svc.HttpService:JSONDecode(raw)
local cur, ceil = tonumber(t.current), tonumber(t.ceiling)
if cur then speed.current = math.clamp(math.floor(cur), K.SPEED, K.SPEED_TOP) end
if ceil and tonumber(t.v) == SPEED_FILE_V then
speed.ceiling = math.max(math.floor(ceil), K.SPEED + K.STEP)
elseif ceil then
log.info("carry speed: discarding the old %d ceiling - re-probed under the current rule",
math.floor(ceil))
end
if speed.ceiling and speed.current >= speed.ceiling then
speed.current = math.max(K.SPEED, speed.ceiling - K.STEP)
end
log.info("carry speed restored: %d studs/s (ceiling %s)", speed.current, tostring(speed.ceiling or "-"))
end)
local function saveSpeed()
BX.try("carry.saveSpeed", function()
exec.ensureFolder("VoidcxzHub")
exec.writeFile(SPEED_FILE, svc.HttpService:JSONEncode({
v = SPEED_FILE_V, current = speed.current, ceiling = speed.ceiling,
}))
end)
end
function M.speedState() return table.clone(speed) end
local liveCarry = nil
function M.progress()
local c = liveCarry
local root = c and ch.root()
if not root then return nil end
local p = root.Position
local left = Vector3.new(c.dest.X - p.X, 0, c.dest.Z - p.Z).Magnitude
return math.clamp(1 - left / c.total, 0, 1)
end
local softStrikes = {}
local function judgeSpeed(used, clean, why, hard)
if clean then
softStrikes[used] = nil
local limit = math.min(K.SPEED_TOP, speed.ceiling and (speed.ceiling - K.STEP) or K.SPEED_TOP)
local nextSpeed = math.min(used + K.STEP, limit)
if nextSpeed > speed.current then
log.info("carry speed: clean at %d - next carry %d studs/s (ceiling %s)",
used, nextSpeed, tostring(speed.ceiling or "-"))
speed.current = nextSpeed
saveSpeed()
end
return
end
if used <= K.SPEED then return end
if not hard then
local n = (softStrikes[used] or 0) + 1
softStrikes[used] = n
if n < K.SOFT_STRIKES then
speed.current = math.max(K.SPEED, used - K.STEP)
log.info("carry speed: %s at %d but the egg arrived (strike %d/%d) - easing to %d, no ceiling",
tostring(why), used, n, K.SOFT_STRIKES, speed.current)
saveSpeed()
return
end
end
speed.ceiling = math.min(speed.ceiling or math.huge, used)
speed.current = math.max(K.SPEED, used - K.STEP)
log.warn("carry speed: %s at %d - backing off to %d, ceiling %d",
tostring(why), used, speed.current, speed.ceiling)
saveSpeed()
end
local GRACE = 3.0
local carryStartedAt = 0
local verdict, verdictAt = true, 0
local function holding(uid)
if eggs.heldUid() == tostring(uid) then return true, "Carried" end
if eggs.holdingAnyEgg() then return true, "Carried(tool)" end
if (os.clock() - carryStartedAt) < GRACE then return true, "Carried(granted)" end
return verdict, verdict and "Carried(watched)" or "gone"
end
local watchToken = 0
local function stopWatch() watchToken = watchToken + 1 end
local function watchHeld(uid)
watchToken = watchToken + 1
local mine = watchToken
task.spawn(function()
local strikes = 0
while mine == watchToken and BX.alive() do
if not liveCarry and (os.clock() - carryStartedAt) > GRACE then break end
local r = eggs.get(uid, true)
if not r then
strikes = 2
elseif r.state == "Carried" then
strikes = 0
else
strikes = strikes + 1
end
verdict = strikes < 2
verdictAt = os.clock()
task.wait(1.0)
end
end)
end
function M.home(uid, opts)
opts = opts or {}
local outerCancel = opts.cancel
stats.runs = stats.runs + 1
carryStartedAt, verdict, verdictAt = os.clock(), true, os.clock()
watchHeld(uid)
local t0 = os.clock()
local stages = {}
local function stage(name, fn)
local s0 = os.clock()
local ok, info = fn()
stages[#stages + 1] = {
name = name, ms = (os.clock() - s0) * 1000, ok = ok and true or false,
}
return ok, info
end
local function report()
local parts = {}
for _, s in ipairs(stages) do
parts[#parts + 1] = ("%s=%.0fms%s"):format(s.name, s.ms, s.ok and "" or "!")
end
return table.concat(parts, " ")
end
local function fail(why)
stats.failed = stats.failed + 1
log.warn("FAILED %s uid=%s after %.2fs [%s] tier=%s",
why, tostring(uid), os.clock() - t0, report(), dev.tier)
return false, { reason = why, stages = stages, elapsed = os.clock() - t0 }
end
local dest, via = plot.safeZone()
if not dest then return fail("no safe zone resolved") end
if not ch.root() then return fail("no character") end
local lastCheck, lastHeld = 0, true
local function carryCancel()
if outerCancel and outerCancel() then return true end
local now = os.clock()
if (now - lastCheck) >= 0.25 then
lastCheck = now
lastHeld = holding(uid)
end
return not lastHeld
end
local quickLift, lostToJump = false, false
if BX._factories["features.antihit"] then
BX.try("carry.antihit", function()
local ah = BX.require("features.antihit")
local result = ah.jump(dest, uid)
if result == "lost" then
lostToJump = true
return
end
if result ~= nil then
carryStartedAt, verdict, verdictAt = os.clock(), true, os.clock()
end
quickLift = ah.protect() == true
end)
if lostToJump then
stopWatch()
stats.lost = stats.lost + 1
return false, { reason = "dropped in transit (anti hit jump)", stages = stages }
end
if not ch.root() then return fail("no character") end
end
local before = ch.root().Position
local distance = (Vector3.new(dest.X, 0, dest.Z)
- Vector3.new(before.X, 0, before.Z)).Magnitude
local carrySpeed = speed.current
local carryFrom = os.clock()
liveCarry = { dest = dest, total = math.max(distance, 1) }
log.info("carrying %s to the safe zone via %s (%.0f studs at %d studs/s, tier=%s)",
tostring(uid), tostring(via), distance, carrySpeed, dev.tier)
local arrived, moveInfo = stage("arc", function()
local ok, info
for leg = 1, 3 do
ok, info = move.travel{
to = dest, speed = carrySpeed, arrive = K.ARRIVE,
carrying = true, cancel = carryCancel, tag = "carry home",
quickLift = quickLift, replan = true,
}
if ok or not info or info.reason ~= "relocated" then break end
log.info("carry home: replanning after a server relocate (leg %d)", leg + 1)
end
return ok, info
end)
local corrected = motion.rejectionsSince(carryFrom)
liveCarry = nil
stopWatch()
local stillOurs, state = holding(uid)
if not stillOurs then
stats.lost = stats.lost + 1
local gone = ch.root()
local travelled = gone and (gone.Position - before).Magnitude or -1
log.warn("carry ended mid-route: egg is %s after %.0f/%.0f studs (%.2fs, %d studs/s)",
tostring(state), travelled, distance, os.clock() - t0, carrySpeed)
judgeSpeed(carrySpeed, false, "dropped in transit", true)
return false, {
reason = "dropped in transit (" .. tostring(state) .. ")",
stages = stages, droppedAt = travelled, distance = distance,
}
end
if outerCancel and outerCancel() then
stats.cancelled = stats.cancelled + 1
return false, { reason = "cancelled", stages = stages }
end
if not arrived then
return fail("could not reach the safe zone ("
.. tostring(moveInfo and moveInfo.reason) .. ")")
end
stage("descend", function()
return move.descend("deliver"), nil
end)
local claimFrom = os.clock()
local claimed = stage("claim", function()
local until_ = os.clock() + dev.scale(K.CLAIM_WAIT)
repeat
if outerCancel and outerCancel() then return false, { reason = "cancelled" } end
local got = plot.claimedSince(claimFrom)
if got then return true, { reason = "claimed" } end
svc.RunService.Heartbeat:Wait()
until os.clock() > until_
return false, { reason = "no claim" }
end)
if not claimed then
local have, st = holding(uid)
judgeSpeed(carrySpeed, false, have and "never claimed" or "lost at the door", true)
return fail(have and "arrived but never claimed"
or ("lost at the door (" .. tostring(st) .. ")"))
end
judgeSpeed(carrySpeed, corrected == 0, ("%d server corrections"):format(corrected), false)
stats.delivered = stats.delivered + 1
log.info("DELIVERED uid=%s in %.2fs via %s at %d studs/s [%s] tier=%s",
tostring(uid), os.clock() - t0, tostring(via), carrySpeed, report(), dev.tier)
return true, { reason = "delivered", stages = stages, elapsed = os.clock() - t0 }
end
return M
end)
BX.module("features.bait", function(BX)
local svc  = BX.require("core.services")
local data = BX.require("core.data")
local eggs = BX.require("features.eggs")
local move = BX.require("features.movement")
local ch   = BX.require("core.character")
local dev  = BX.require("core.device")
local log  = BX.require("boot.log").for_module("bait")
local RunService = svc.RunService
local M = {}
local K = {
AREA_WAIT    = 5,     
APPROACH     = 1200,  
ARRIVE       = 4,
PICKUP_WAIT  = 3,     
REHOPS       = 2,     
HIT_WAIT     = 4.0,   
WITNESS_HOLD = 0.35,  
}
M.K = K
local EggState, SlotIdentity = data.eggState(), data.slotIdentity()
local areaCached = nil
function M.firstAreaId(waitFor)
if areaCached then return areaCached end
if waitFor then
local deadline = os.clock() + waitFor
while os.clock() < deadline do
local there = false
pcall(function()
there = workspace.__OBJECTS.Areas.GuardAreas:GetChildren()[1] ~= nil
end)
if there then break end
task.wait(0.2)
end
end
local best, bestX
BX.try("bait.resolveArea", function()
for _, a in ipairs(workspace.__OBJECTS.Areas.GuardAreas:GetChildren()) do
local b = a:FindFirstChild("Bounds")
if b and b:IsA("BasePart") then
local x = b.Position.X - b.Size.X * 0.5
if not best or x < bestX then best, bestX = a.Name, x end
end
end
end)
if best then
areaCached = best
log.info("first area resolved: %s (leftmost at x=%.0f)", best, bestX)
else
log.warn("guard areas have not streamed in - no bait area")
end
return areaCached
end
local function findGuard(areaId)
if not areaId then return nil end
local live = workspace:FindFirstChild("_Guards")
if live then
for _, g in ipairs(live:GetChildren()) do
if g.Name == areaId or g:GetAttribute("AreaId") == areaId then return g end
end
end
local a
pcall(function() a = workspace.__OBJECTS.Areas.GuardAreas[areaId] end)
return a and a:FindFirstChild("Guard") or nil
end
local function guardPart(guard)
if not guard then return nil end
local root = guard:FindFirstChild("HumanoidRootPart")
or guard:FindFirstChild("Collider")
or guard:FindFirstChild("Head")
if root and root:IsA("BasePart") then return root end
local best
for _, d in ipairs(guard:GetDescendants()) do
if d:IsA("BasePart") then
local v = d.Size.X * d.Size.Y * d.Size.Z
if not best or v > best.v then best = { p = d, v = v } end
end
end
return best and best.p or nil
end
local stats = { runs = 0, hits = 0, noEgg = 0, noPickup = 0, noHit = 0, cancelled = 0 }
function M.stats() return table.clone(stats) end
function M.prime(opts)
opts = opts or {}
local cancel = opts.cancel
stats.runs = stats.runs + 1
local t0 = os.clock()
local areaId = M.firstAreaId(K.AREA_WAIT)
if not areaId then
return false, { reason = "no bait area" }
end
if not EggState then EggState = data.eggState() SlotIdentity = SlotIdentity or data.slotIdentity() end
local records = eggs.records(true)
local rec
BX.try("bait.findEgg", function()
for _, r in pairs(records) do
if r.AreaId == areaId and r.State == "Slot" and r.BoundsCFrame then
rec = r
break
end
end
end)
if not rec then
stats.noEgg = stats.noEgg + 1
local states = {}
BX.try("bait.dumpNoEgg", function()
for _, r in pairs(records) do
if r.AreaId == areaId then states[#states + 1] = ("%s=%s"):format(tostring(r.NestId), tostring(r.State)) end
end
end)
table.sort(states)
log.warn("no Slot egg in %s | area: %s | untilReset=%s", tostring(areaId),
#states > 0 and table.concat(states, " ") or "(no records)",
tostring(data.secondsUntilReset() and math.floor(data.secondsUntilReset())))
return false, { reason = "no bait egg" }
end
local pos = rec.BoundsCFrame.Position
local movedAt = os.clock()
move.travel{ to = pos, speed = K.APPROACH, arrive = K.ARRIVE,
carrying = false, cancel = cancel, tag = "bait approach" }
if cancel and cancel() then
stats.cancelled = stats.cancelled + 1
return false, { reason = "cancelled" }
end
local slotKey = nil
BX.try("bait.slotKey", function()
slotKey = eggs.slotKeyFor(rec.Uid, rec.AreaId, rec.NestId)
end)
local got = false
local deadline = os.clock() + dev.scale(K.PICKUP_WAIT)
local rehops, tries = 0, 0
local lastMsg = nil
local startPos = ch.root() and ch.root().Position
while os.clock() < deadline and not got do
if cancel and cancel() then
stats.cancelled = stats.cancelled + 1
return false, { reason = "cancelled" }
end
local here = ch.root()
if not here then return false, { reason = "no character" } end
if startPos and (here.Position - pos).Magnitude > 60 and rehops < K.REHOPS then
rehops = rehops + 1
log.trace("server pulled us back - hopping again (%d/%d)", rehops, K.REHOPS)
move.travel{ to = pos, speed = K.APPROACH, arrive = K.ARRIVE,
carrying = false, cancel = cancel, tag = "bait rehop" }
deadline = os.clock() + dev.scale(K.PICKUP_WAIT)
end
tries = tries + 1
local ok, res, msg = pcall(function() return eggs.carry(rec.Uid, slotKey, { areaId = rec.AreaId, nestId = rec.NestId }) end)
if ok and res == true then got = true break end
if not ok then lastMsg = "error: " .. tostring(res)
elseif msg ~= nil then lastMsg = tostring(msg) end
RunService.Heartbeat:Wait()
end
if got then BX.profile.mark("bait_grab") end
if not got then
stats.noPickup = stats.noPickup + 1
local states = {}
BX.try("bait.dumpStates", function()
for _, r in pairs(eggs.records()) do
if r.AreaId == areaId then
states[#states + 1] = ("%s=%s"):format(tostring(r.NestId), tostring(r.State))
end
end
end)
table.sort(states)
local here = ch.root()
log.warn("could not pick up in %s after %d tries, %d rehops (%.2fs) - last refusal: %s | chose %s (%s) dist=%.0f | area: %s | untilReset=%s",
tostring(areaId), tries, rehops, os.clock() - t0, tostring(lastMsg),
tostring(rec.NestId), tostring(rec.Uid), here and (here.Position - pos).Magnitude or -1,
table.concat(states, " "), tostring(data.secondsUntilReset() and math.floor(data.secondsUntilReset())))
return false, { reason = "no pickup", tries = tries, rehops = rehops, msg = lastMsg }
end
BX.profile.mark("guard_contact")
local guard = findGuard(areaId)
local gpart = guardPart(guard)
if gpart then
local hh = ch.root()
local char = ch.get()
if hh and char then
local gy = move.groundY(gpart.Position) or hh.Position.Y
pcall(function()
char:PivotTo(CFrame.new(gpart.Position.X, gy, gpart.Position.Z))
end)
end
else
log.warn("no guard found in %s", tostring(areaId))
end
local hrp = ch.root()
local anchorCF = hrp and hrp.CFrame
if hrp then pcall(function() hrp.Anchored = true end) end
local hitAt, witnessAt = nil, nil
local dl = os.clock() + dev.scale(K.HIT_WAIT)
while os.clock() < dl do
if cancel and cancel() then break end
local hh = ch.root()
if not hh then break end
hh.AssemblyLinearVelocity = Vector3.zero
hh.AssemblyAngularVelocity = Vector3.zero
if anchorCF then pcall(function() hh.CFrame = anchorCF end) end
local witnessed = false
local hum = ch.humanoid()
if hum and hum:GetState() == Enum.HumanoidStateType.Physics then
witnessed = true   
end
if not witnessed then
local live = eggs.get(rec.Uid)
local st = live and live.state or nil
witnessed = (st == "Dropped" or st == "GuardCarried")
end
if witnessed and not witnessAt then
witnessAt = os.clock()
log.info("witness seen @%.3f (+%.3fs into the prime)",
witnessAt, witnessAt - t0)
end
if witnessAt and (os.clock() - witnessAt) >= K.WITNESS_HOLD then
BX.profile.mark("hit_detected")
hitAt = os.clock()
log.info("HIT CONFIRMED @%.3f (+%.3fs into the prime, hold=%.3fs)",
hitAt, hitAt - t0, hitAt - witnessAt)
break
end
RunService.Heartbeat:Wait()
end
do
local hh = ch.root()
if hh then pcall(function() hh.Anchored = false end) end
BX.profile.mark("unanchor")
end
local took = hitAt ~= nil
if took then stats.hits = stats.hits + 1 else stats.noHit = stats.noHit + 1 end
log.info("%s in %s after %.2fs (tries=%d rehops=%d witness=%s tier=%s)",
took and "HIT TAKEN" or "no hit", tostring(areaId), os.clock() - t0,
tries, rehops, witnessAt and "yes" or "no", dev.tier)
return took, {
reason = took and "hit" or "no hit",
areaId = areaId, tries = tries, rehops = rehops,
elapsed = os.clock() - t0,
}
end
return M
end)
BX.module("features.autosteal", function(BX)
local svc   = BX.require("core.services")
local dev   = BX.require("core.device")
local ch    = BX.require("core.character")
local st    = BX.require("core.state")
local eggs  = BX.require("features.eggs")
local grab  = BX.require("features.grab")
local move  = BX.require("features.movement")
local carry = BX.require("features.carry")
local bait  = BX.require("features.bait")
local adeath = BX.require("features.antideath")
local guard  = BX.require("features.guard")
local rs     = BX.require("core.restore")
local instant = BX.require("features.instant")
local regrab = BX.require("features.regrab")
local hswap  = BX.require("features.humanoid")
local data  = BX.require("core.data")
local guardwatch = BX.require("features.guardwatch")
local motion = BX.require("core.motion")
local log   = BX.require("boot.log").for_module("autosteal")
local M = {}
local BACKOFF_BASE = 1.0
local BACKOFF_CAP  = 8.0
local IDLE_WAIT = 0.5
local SLOW_IDLE_WAIT = 2.0   
local RESET_LEAD = 30
local TARGET_RETRIES = 2
local MAX_PREPS = 3          
local GONE_PASSES = 6        
local RESPAWN_SETTLE = 1.0
local INVENTORY_FULL = "egg inventory full"
local GUARD_WAIT = "waiting for the guard to go home"
local TRUST_WAIT  = "movement not trusted by the server - cooling down"
local NO_BAIT     = "no bait egg in the Forest"
local REBAIT      = "egg back in its nest - re-baiting"
local TAKEN       = "egg taken by someone else"
local lastGuardWait = nil
local idleNow = nil        
local function isInventoryFull(msg)
return type(msg) == "string" and msg:lower():find("inventory is full", 1, true) ~= nil
end
local TRUST_FIRST, TRUST_MAX = 10, 60
local trustUntil, trustCool = 0, 0
local function isTrustRefusal(msg)
if type(msg) ~= "string" then return false end
local m = msg:lower()
return m:find("not currently trusted", 1, true) ~= nil
or m:find("get closer", 1, true) ~= nil
end
local function distrust(why)
trustCool = math.min(math.max(trustCool * 2, TRUST_FIRST), TRUST_MAX)
trustUntil = os.clock() + trustCool
log.warn("server refused our movement (%s) - no teleports for %.0fs", tostring(why), trustCool)
end
function M.trustCooldown() return math.max(0, trustUntil - os.clock()), trustCool end
local watch = { uid = nil, msg = nil, retries = 0, phase = nil, phaseAt = 0, reported = nil,
passAt = 0 }
M.STATE = {
PREP_DELIVER_HELD = "PREP_DELIVER_HELD",
READY_TO_STEAL    = "READY_TO_STEAL",
BAIT_NOT_DONE     = "BAIT_NOT_DONE",
BAIT_DONE         = "BAIT_DONE",
AT_TARGET         = "AT_TARGET",
TARGET_GRAB_RETRY = "TARGET_GRAB_RETRY",
CARRYING          = "CARRYING",
RETURNING         = "RETURNING",
DELIVERED         = "DELIVERED",
}
M.RUN = {
DISABLED = "DISABLED", IDLE = "IDLE", WAITING_FOR_SPAWN = "WAITING_FOR_SPAWN",
ACQUIRING = "ACQUIRING", MOVING = "MOVING", STEALING = "STEALING",
RECOVERING = "RECOVERING",
}
local BUSY = { ACQUIRING = true, MOVING = true, STEALING = true, RECOVERING = true }
local runState = M.RUN.DISABLED
local function setRunState(s)
if runState == s then return end
local wasBusy, nowBusy = BUSY[runState] == true, BUSY[s] == true
runState = s
st.autoStealState = s
st.autoStealBusy = nowBusy
if nowBusy and not wasBusy then
motion.claim("autosteal")
elseif wasBusy and not nowBusy then
motion.release("autosteal")
end
log.trace("run state -> %s", s)
end
function M.runState() return runState end
function M.isBusy() return BUSY[runState] == true end
local phases = {}
local phaseRun = 0
local function phase(token, name, detail)
if token ~= phaseRun then
phases, phaseRun = {}, token
end
if detail == nil and phases[#phases] == name then return end
if watch.phase ~= name then
watch.phase, watch.phaseAt, watch.reported = name, os.clock(), nil
end
phases[#phases + 1] = name
if #phases > 200 then table.remove(phases, 1) end
log.info("run %d: phase %s%s", token, name,
detail and (" (" .. tostring(detail) .. ")") or "")
end
function M.phases() return table.clone(phases) end
local stopListeners = {}
function M.onStop(fn) stopListeners[#stopListeners + 1] = fn end
local betweenCycles = nil
function M.setBetweenCycles(fn) betweenCycles = fn end
local beforeSteal = nil
function M.setBeforeSteal(fn) beforeSteal = fn end
function M.isParkableWait(why)
if type(why) ~= "string" then return false end
return why:find("^nothing to steal") ~= nil
or why:find("^nothing matches the filter") ~= nil
or why == "field resetting" or why == INVENTORY_FULL or why == NO_BAIT
end
local idleListeners = {}
function M.onIdle(fn) idleListeners[#idleListeners + 1] = fn end
local deliveredListeners = {}
function M.onDelivered(fn) deliveredListeners[#deliveredListeners + 1] = fn end
local startListeners = {}
function M.onStart(fn) startListeners[#startListeners + 1] = fn end
local liveTarget = nil
local function fireDelivered(target)
if not target then return end
for _, fn in ipairs(deliveredListeners) do
task.spawn(function() BX.try("autosteal.onDelivered", fn, target) end)
end
end
local runToken = 0
local running  = false
local cycles   = 0
local sc       = nil
local failures = 0
local spawnGen = 0
local wake = false
local opts     = {}
local optsFor  = {}
local owner    = nil
local function snapshot()
local h = BX.profile.health()
local e = eggs.stats()
return {
scopes = h.scopes, conns = h.conns, insts = h.insts, threads = h.threads,
eggList = e.listSize, eggValues = e.valueCache,
}
end
local SNAP_KEYS = { "scopes", "conns", "insts", "threads", "eggList", "eggValues" }
local function diff(a, b)
local out = {}
for _, k in ipairs(SNAP_KEYS) do
local d = (b[k] or 0) - (a[k] or 0)
if d ~= 0 then out[#out + 1] = ("%s %+d"):format(k, d) end
end
return #out > 0 and table.concat(out, " ") or "no change"
end
local function runCycle(token, cancel)
local cycle = { t0 = os.clock(), stages = {} }
watch.passAt = cycle.t0
watch.uid, watch.msg, watch.retries = nil, nil, 0
if os.clock() < trustUntil then
return false, TRUST_WAIT, cycle
end
BX.profile.mark("cycle_start")
local function stage(name, fn)
if cancel() then return false, { reason = "cancelled" } end
local s0 = os.clock()
local ok, info = fn()
cycle.stages[#cycle.stages + 1] = {
name = name, ms = (os.clock() - s0) * 1000, ok = ok and true or false,
}
return ok, info
end
local held = eggs.carryingUid()
if held then
local isObjective = (opts.uid ~= nil) and (held == opts.uid)
cycle.prep = not isObjective
cycle.state = isObjective and M.STATE.RETURNING or M.STATE.PREP_DELIVER_HELD
setRunState(M.RUN.RECOVERING)
phase(token, cycle.state, "holding " .. tostring(held))
cycle.recovered = held
log.info("already carrying %s - %s", held,
isObjective and "this is the selected egg, delivering to finish"
or "not the selected egg, clearing our hands first")
local ok2, info2 = stage("carry held", function()
return carry.home(held, { cancel = cancel })
end)
if ok2 then
cycle.target = { name = isObjective and "selected egg" or "held egg", uid = held }
if isObjective then
cycle.state = M.STATE.DELIVERED
cycle.terminal = true
phase(token, cycle.state, held)
return true, "delivered", cycle
end
cycle.state = M.STATE.READY_TO_STEAL
cycle.terminal = false
phase(token, cycle.state, "hands clear after prep")
return true, "prep: held egg delivered", cycle
end
return false, "held egg: " .. tostring(info2 and info2.reason), cycle
end
if cycle.state == nil then
cycle.state = M.STATE.READY_TO_STEAL
phase(token, cycle.state)
end
if data.fieldSealed() then
return false, "field resetting", cycle
end
local untilReset = data.secondsUntilReset()
if untilReset and untilReset < RESET_LEAD then
return false, "field resetting", cycle
end
do
local _, invCount, invLimit = data.eggInventory()
if invCount and invLimit then
cycle.inventory = ("%d/%d"):format(invCount, invLimit)
end
end
idleNow = nil
local preTarget = nil
local guardOverride = false
if opts.uid and not eggs.get(opts.uid) then
local known = eggs.identityOf(opts.uid)
local tier = known and eggs.rarityNumOf(known.category) or nil
local replacement = eggs.bestAtLeast(tier)
if not replacement then
return false, "selected egg is gone", cycle
end
log.info("selected egg %s is gone - retargeting to %s (tier >= %s)",
tostring(opts.uid), tostring(replacement.name), tostring(tier or "any"))
opts.uid = replacement.uid
if not cycle.retargeted then
cycle.retargeted = true
for _, fn in ipairs(idleListeners) do
task.spawn(function()
BX.try("autosteal.onRetarget", fn, "your egg was taken - stealing the best one", owner)
end)
end
end
end
if opts.pick and not opts.uid then
local okPre, pre, whyPre, overPre = pcall(opts.pick)
guardOverride = okPre and overPre == true
if not okPre then
return false, "target picker failed: " .. tostring(pre), cycle
end
if not pre then
return false, "nothing to steal"
.. (whyPre and (" (" .. tostring(whyPre) .. ")") or ""), cycle
end
preTarget = pre
end
do
local aim = opts.uid and eggs.get(opts.uid) or preTarget
local blockedBy = aim and not guardOverride and guardwatch.blocking(aim.areaId, aim.pos)
if blockedBy then
cycle.guardWait = blockedBy
if blockedBy ~= lastGuardWait then log.info("guard still moving: %s", blockedBy) end
lastGuardWait = blockedBy
else
lastGuardWait = nil
end
end
local firstArea = bait.firstAreaId(0)
local inBaitArea = nil
if opts.uid then
local want = eggs.get(opts.uid)
inBaitArea = want and firstArea and want.areaId == firstArea or false
elseif preTarget then
inBaitArea = firstArea ~= nil and preTarget.areaId == firstArea
end
setRunState(M.RUN.ACQUIRING)
if beforeSteal then
BX.try("autosteal.beforeSteal", beforeSteal, owner, cancel)
if cancel() then return false, "cancelled", cycle end
if data.fieldSealed() then return false, "field resetting", cycle end
end
local primed = false
setRunState(M.RUN.MOVING)
if inBaitArea then
log.info("target is in the bait area (%s) - not priming, going straight for it",
tostring(firstArea))
cycle.baitSkipped = true
else
local baitInfo
primed, baitInfo = stage("bait", function()
return bait.prime({ cancel = cancel })
end)
if not primed and baitInfo and isInventoryFull(baitInfo.msg) then
return false, INVENTORY_FULL, cycle
end
if not primed and baitInfo then
local r = baitInfo.reason
watch.msg = baitInfo.msg or r
if cancel() then return false, "cancelled", cycle end
if r == "no pickup" and isTrustRefusal(baitInfo.msg) then
distrust("bait pickup: " .. tostring(baitInfo.msg))
return false, TRUST_WAIT, cycle
elseif r == "no bait egg" then
return false, NO_BAIT, cycle
elseif r == "no pickup" or r == "no hit" then
return false, "bait not taken (" .. tostring(r)
.. (baitInfo.msg and (": " .. tostring(baitInfo.msg)) or "") .. ")", cycle
end
end
end
cycle.primed = primed and true or false
if cancel() then return false, "cancelled", cycle end
local target
local want = opts.uid and eggs.get(opts.uid) or nil
if opts.uid and not want then
local known = eggs.identityOf(opts.uid)
local tier = known and eggs.rarityNumOf(known.category) or nil
local replacement = eggs.bestAtLeast(tier)
if not replacement then
return false, "selected egg is gone", cycle
end
log.info("selected egg went during the bait - taking %s instead (tier >= %s)",
tostring(replacement.name), tostring(tier or "any"))
opts.uid = replacement.uid
end
if opts.uid and want then
local takeable = (want.state == "Slot" or want.state == "Dropped")
if not takeable or not want.pos then
return false, "waiting for the selected egg (" .. tostring(want.state) .. ")", cycle
end
target = want
elseif opts.pick then
local ok2, want, why2 = true, preTarget, nil
if not (cycle.baitSkipped and preTarget) then
ok2, want, why2 = pcall(opts.pick)
end
if not ok2 then
return false, "target picker failed: " .. tostring(want), cycle
end
target = want
if not target then
return false, "nothing matches the filter"
.. (why2 and (" (" .. tostring(why2) .. ")") or ""), cycle
end
else
target = eggs.best()
end
if not target then return false, "nothing to steal", cycle end
cycle.target = target
watch.uid = target.uid
liveTarget = { uid = target.uid, name = target.name, rarity = target.rarity, value = target.value }
local here = ch.root()
cycle.distance = here and (target.pos - here.Position).Magnitude or -1
cycle.state = M.STATE.BAIT_DONE
phase(token, cycle.state, cycle.primed and "primed"
or (cycle.baitSkipped and "bait skipped: target in the bait area" or "no bait egg"))
log.info("target uid=%s name=%s area=%s rarity=%s state=%s dist=%.0f primed=%s",
tostring(target.uid), tostring(target.name), tostring(target.areaId),
tostring(target.rarity), tostring(target.state), cycle.distance or -1,
tostring(cycle.primed))
setRunState(M.RUN.STEALING)
local took, inInfo
local retries = 0
for attempt = 0, TARGET_RETRIES do
cycle.state = (attempt == 0) and M.STATE.AT_TARGET or M.STATE.TARGET_GRAB_RETRY
phase(token, cycle.state, target.name)
took, inInfo = stage(attempt == 0 and "instant" or ("regrab" .. attempt), function()
return instant.take(target.uid, target.pos, {
cancel = cancel,
areaId = target.areaId, nestId = target.nestId,
})
end)
watch.msg, watch.retries = inInfo and inInfo.reason, attempt
if took or cancel() then break end
if inInfo and inInfo.taken then break end
if inInfo and type(inInfo.reason) == "string"
and inInfo.reason:lower():find("not currently trusted", 1, true) then
break
end
local es = inInfo and inInfo.eggState
local retryable = inInfo and (inInfo.pulledBack or es == "Slot" or es == "Dropped")
if not retryable or attempt == TARGET_RETRIES then break end
local fresh = eggs.get(target.uid)
if not fresh or not fresh.pos then break end
target.pos = fresh.pos
retries = retries + 1
log.info("target retry %d/%d (reason=%s state=%s pulledBack=%s)",
attempt + 1, TARGET_RETRIES, tostring(inInfo and inInfo.reason),
tostring(es), tostring(inInfo and inInfo.pulledBack))
end
cycle.grabRetries = retries
if cancel() then return false, "cancelled", cycle end
if took then
cycle.state = M.STATE.CARRYING
phase(token, cycle.state, "instant")
cycle.transition = "tp"
cycle.calls = inInfo and inInfo.calls
cycle.tpGap = inInfo and inInfo.gap
else
cycle.transition = "arc_fallback"
cycle.instantFail = inInfo and inInfo.reason
if isInventoryFull(inInfo and inInfo.reason) then
return false, INVENTORY_FULL, cycle
end
if inInfo and inInfo.taken then
return false, TAKEN, cycle
end
if inInfo and not inInfo.pulledBack and isTrustRefusal(inInfo.reason) then
distrust("target pickup: " .. tostring(inInfo.reason))
return false, TRUST_WAIT, cycle
end
cycle.instantDiag = inInfo
setRunState(M.RUN.MOVING)
local takenOnWay, lookAt = false, 0
local function approachCancel()
if cancel() then return true end
local now = os.clock()
if now - lookAt >= 0.4 then
lookAt = now
local rec = eggs.get(target.uid)
if not rec or (rec.state ~= "Slot" and rec.state ~= "Dropped") then
takenOnWay = true
end
end
return takenOnWay
end
local reached, moveInfo = stage("approach", function()
return move.travel{
to = target.pos, speed = move.outboundSpeed(),
arrive = 4, carrying = false, cancel = approachCancel, tag = "approach",
}
end)
if cancel() then return false, "cancelled", cycle end
if takenOnWay then
log.info("target %s left the field while approaching - picking again", tostring(target.uid))
return false, TAKEN, cycle
end
if not reached then
return false, "approach: " .. tostring(moveInfo and moveInfo.reason), cycle
end
setRunState(M.RUN.STEALING)
local grabbed, grabInfo = stage("grab", function()
return grab.take(target.uid, { pos = target.pos, cancel = cancel })
end)
if cancel() then return false, "cancelled", cycle end
if not grabbed then
eggs.markUnreachable(target.uid)
return false, "grab: " .. tostring(grabInfo and grabInfo.reason), cycle
end
cycle.state = M.STATE.CARRYING
phase(token, cycle.state, "prompt")
end
cycle.state = M.STATE.RETURNING
setRunState(M.RUN.RECOVERING)
phase(token, cycle.state, target.name)
local delivered, carryInfo = stage("carry", function()
return carry.home(target.uid, { cancel = cancel })
end)
local recoveries = 0
while not delivered and not cancel()
and carryInfo and carryInfo.reason
and tostring(carryInfo.reason):find("dropped in transit", 1, true)
and recoveries < regrab.K.MAX_PER_STEAL do
svc.RunService.Heartbeat:Wait()
recoveries = recoveries + 1
cycle.recoveries = recoveries
cycle.state = M.STATE.TARGET_GRAB_RETRY
local back, rinfo = stage("recover" .. recoveries, function()
return regrab.recover(target.uid, {
cancel = cancel,
areaId = target.areaId, nestId = target.nestId,
})
end)
cycle.dropRecovery = rinfo and rinfo.recovery or "?"
if not back then
if rinfo and rinfo.recovery == "rebait" then
return false, REBAIT, cycle
end
return false, "drop recovery: " .. tostring(rinfo and rinfo.reason), cycle
end
cycle.state = M.STATE.RETURNING
delivered, carryInfo = stage("carry" .. recoveries, function()
return carry.home(target.uid, { cancel = cancel })
end)
end
if cancel() then return false, "cancelled", cycle end
if not delivered then
return false, "carry: " .. tostring(carryInfo and carryInfo.reason), cycle
end
cycle.state = M.STATE.DELIVERED
cycle.terminal = true
phase(token, cycle.state, target.name)
trustCool = 0    
fireDelivered(target)
return true, "delivered", cycle
end
local function reportCycle(ok, why, cycle, before, after)
local parts = {}
for _, s in ipairs(cycle.stages) do
parts[#parts + 1] = ("%s=%.0fms%s"):format(s.name, s.ms, s.ok and "" or "!")
end
if not ok then
local marks = BX.profile.marksSince(cycle.t0)
if #marks > 0 then
log.warn("timeline: %s", table.concat(marks, " | "))
end
end
local level = ok and log.info or log.warn
level("cycle %s in %.2fs [%s] target=%s dist=%.0f %s | %s",
ok and "DELIVERED" or ("FAILED " .. tostring(why)),
os.clock() - cycle.t0, table.concat(parts, " "),
cycle.target and cycle.target.name or "-",
cycle.distance or -1,
("state=%s transition=%s calls=%s retries=%d recoveries=%d%s primed=%s%s"):format(
cycle.state or "?", cycle.transition or "?",
tostring(cycle.calls or "-"), cycle.grabRetries or 0,
cycle.recoveries or 0,
cycle.dropRecovery and (" drop_recovery=" .. cycle.dropRecovery) or "",
tostring(cycle.primed),
cycle.instantFail and (" instantFail=" .. tostring(cycle.instantFail)
.. " pulledBack=" .. tostring(cycle.instantDiag and cycle.instantDiag.pulledBack)
.. " eggState=" .. tostring(cycle.instantDiag and cycle.instantDiag.eggState)) or ""),
diff(before, after))
end
local lastIdleWhy = nil
local timedCycle = BX.profile.wrapLoop("features.autosteal/pass", IDLE_WAIT, runCycle)
local function isIdleReason(why)
return type(why) == "string"
and (why:find("^nothing to steal") or why:find("^nothing matches the filter")
or why == "field resetting" or why == INVENTORY_FULL or why == GUARD_WAIT
or why == TRUST_WAIT or why == NO_BAIT
or why == "selected egg is gone") or false
end
local function idleWait(seconds, token)
local deadline = os.clock() + seconds
wake = false
while os.clock() < deadline do
if not running or token ~= runToken or not BX.alive() then return end
if wake then return end
task.wait(math.min(0.25, math.max(deadline - os.clock(), 0.05)))
end
end
local function runLoop(token)
log.info("run %d: begin (tier=%s)", token, dev.tier)
phase(token, "START", "tier=" .. tostring(dev.tier))
local preps = 0
local goneStreak = 0
lastIdleWhy = nil
local spawnSeen = spawnGen
local isCancelled = function()
return (not running) or token ~= runToken or (not BX.alive()) or spawnGen ~= spawnSeen
end
while running and token == runToken and BX.alive() do
svc.RunService.Heartbeat:Wait()
if not running or token ~= runToken then break end
if spawnGen ~= spawnSeen then
spawnSeen = spawnGen
failures = 0
log.info("run %d: character respawned - resuming with the new character", token)
task.wait(RESPAWN_SETTLE)
if isCancelled() and (not running or token ~= runToken) then break end
end
setRunState(M.RUN.IDLE)
local before = snapshot()
local ok, why, cycle = timedCycle(token, isCancelled)
liveTarget = nil
local after = snapshot()
if why ~= "selected egg is gone" then goneStreak = 0 end
local idle = isIdleReason(why)
if idle then
idleNow = why
setRunState(M.RUN.WAITING_FOR_SPAWN)
if why ~= lastIdleWhy then
lastIdleWhy = why
log.info("idle: %s", why)
local detail = why
if why == INVENTORY_FULL then
local _, n, lim = data.eggInventory()
if n and lim then detail = ("%s (%d/%d)"):format(why, n, lim) end
end
for _, fn in ipairs(idleListeners) do
task.spawn(function() BX.try("autosteal.onIdle", fn, detail, owner) end)
end
end
else
lastIdleWhy, idleNow = nil, nil
setRunState(M.RUN.IDLE)
if cycle then reportCycle(ok, why, cycle, before, after) end
end
if why == "cancelled" then
if not running or token ~= runToken or not BX.alive() then break end
log.info("run %d: pass cancelled by a respawn", token)
elseif ok and not (cycle and cycle.terminal) then
failures = 0
preps = preps + 1
if preps > MAX_PREPS then
log.warn("%d preparation passes without a steal - continuing after a short reset", preps)
preps = 0
idleWait(dev.scale(SLOW_IDLE_WAIT), token)
else
log.info("preparation complete (%s) - continuing the same run", tostring(why))
end
elseif ok and opts.continuous then
failures = 0
cycles = cycles + 1
log.info("delivered (%d this run) - continuing", cycles)
if betweenCycles and running and token == runToken then
BX.try("autosteal.betweenCycles", betweenCycles, owner)
end
elseif ok then
failures = 0
cycles = cycles + 1
log.info("delivered - run complete")
return "delivered"
elseif why == "selected egg is gone" then
goneStreak = goneStreak + 1
if goneStreak >= GONE_PASSES then
log.info("selected egg is gone (%d checks) - stopping", goneStreak)
return "selected egg is gone"
end
idleWait(dev.scale(IDLE_WAIT), token)
elseif why == REBAIT then
failures = 0
log.info("guard returned the egg to its nest - re-baiting now")
elseif why == TAKEN then
log.info("target taken by someone else - picking again")
idleWait(dev.scale(IDLE_WAIT), token)
elseif why == TRUST_WAIT then
task.wait(math.max(IDLE_WAIT, trustUntil - os.clock()))
elseif why == "field resetting" then
local wait = dev.scale(SLOW_IDLE_WAIT)
local opensIn = data.secondsUntilFieldOpens()
if opensIn then wait = math.clamp(opensIn + 0.05, 0.1, wait) end
idleWait(wait, token)
elseif why == INVENTORY_FULL or why == NO_BAIT then
idleWait(dev.scale(SLOW_IDLE_WAIT), token)
elseif idle or (type(why) == "string" and why:find("waiting for the selected egg", 1, true)) then
idleWait(dev.scale(IDLE_WAIT), token)
else
failures = failures + 1
local wait = math.min(BACKOFF_BASE * (2 ^ (failures - 1)), BACKOFF_CAP)
wait = dev.scale(wait)
log.warn("backing off %.1fs (failure %d)", wait, failures)
task.wait(wait)
end
end
log.info("run %d: ended", token)
return "ended"
end
local function stop(reason)
if not running then return end
running = false
runToken = runToken + 1
st.autoStealOn = false
setRunState(M.RUN.DISABLED)
motion.release("autosteal")
idleNow = nil
if sc then
sc:destroy()
sc = nil
end
failures = 0
local whose = owner
owner = nil
opts = {}
BX.try("autosteal.antideath", adeath.disarm)
BX.try("autosteal.humanoid", hswap.disarm)
BX.try("autosteal.guard", guard.disarm)
BX.try("autosteal.resetMovement", move.reset)
BX.try("autosteal.unanchor", function()
local hrp = ch.root()
if hrp and hrp.Anchored then hrp.Anchored = false end
end)
local restored, skipped, failed = 0, 0, 0
BX.try("autosteal.restore", function()
restored, skipped, failed = rs.restoreAll()
end)
local leftovers = {}
BX.try("autosteal.audit", function() leftovers = rs.audit() end)
if #leftovers == 0 and failed == 0 then
log.info("autosteal cleanup: PASS (%d restored, %d skipped)", restored, skipped)
else
log.warn("autosteal cleanup: %d restored, %d skipped, %d FAILED%s",
restored, skipped, failed,
#leftovers > 0 and (" | still modified: " .. table.concat(leftovers, "; ")) or "")
end
log.info("stopped (%s) after %d cycles", reason or "requested", cycles)
phase(phaseRun, "STOP", reason or "requested")
log.info("run %d trail: %s", phaseRun, table.concat(phases, " -> "))
local why = reason or "requested"
for _, fn in ipairs(stopListeners) do
task.spawn(function() BX.try("autosteal.onStop", fn, why, whose) end)
end
end
function M.capability()
local exec = BX.require("core.exec")
local paths = {}
if instant.ready then paths[#paths + 1] = "instant (CarryFieldEgg)" end
if exec.can.prompts then paths[#paths + 1] = "prompt (" .. tostring(exec.promptVia) .. ")" end
if #paths == 0 then
return false, "Auto Steal cannot run on this executor: no game-module require ("
.. tostring(exec.gameRequireWhy) .. ") and no proximity prompt path"
end
return true, table.concat(paths, " + ")
end
local function start(src)
if running then return end
local okCap, capWhy = M.capability()
if not okCap then
log.error("%s", capWhy)
return false, capWhy
end
owner = tostring(src or "main")
opts = optsFor[owner] or {}
log.info("run starting for %s - pickup via %s", owner, capWhy)
if sc then sc:destroy() end
runToken = runToken + 1
running  = true
st.autoStealOn = true
setRunState(M.RUN.IDLE)
sc = BX.scope("features.autosteal")
local token = runToken
ch.onSpawn(sc, "autosteal.respawn", function()
if not running or token ~= runToken then return end
spawnGen = spawnGen + 1
wake = true
log.info("respawn: run %d cancels the current pass and continues", token)
end)
BX.try("autosteal.wakeSignals", function()
local ES = data.eggState()
for _, name in ipairs({ "FieldRefreshed", "FieldShifted", "CarryChanged", "FieldGone" }) do
local sig = ES and ES[name]
if type(sig) == "table" and type(sig.Connect) == "function" then
sc:connect(sig, function() wake = true end)
end
end
local n = data.onWallChanged(sc, function(sealed, via)
wake = true
log.info("field wall %s (%s)", sealed and "UP" or "down", via)
end)
if n == 0 then log.warn("no wall signal - reset waits run on the schedule alone") end
end)
local armed = {}
for _, a in ipairs({ { "humanoid", hswap.arm }, { "guard", guard.arm },
{ "antideath", adeath.arm } }) do
local ok = BX.try("autosteal.arm." .. a[1], a[2])
armed[#armed + 1] = a[1] .. (ok and "=ok" or "=FAILED")
end
log.info("run %d: armed %s", token, table.concat(armed, " "))
do
local who = owner
for _, fn in ipairs(startListeners) do
task.spawn(function() BX.try("autosteal.onStart", fn, who) end)
end
end
watch.phase, watch.phaseAt, watch.reported, watch.passAt = nil, os.clock(), nil, os.clock()
local worker
worker = sc:spawn("loop", function()
log.info("run %d: worker thread started (owner=%s, options: %s)",
token, tostring(owner),
opts.uid and ("uid=" .. tostring(opts.uid))
or (opts.pick and ("picker" .. (opts.continuous and ", continuous" or ""))
or "best value"))
local reason = runLoop(token)
if token == runToken then
if reason == "delivered" then
stop("delivered")
elseif running then
stop(reason or "ended")
end
end
end)
local LIMIT = { PREP_DELIVER_HELD = 40, READY_TO_STEAL = 30, BAIT_DONE = 12,
AT_TARGET = 10, TARGET_GRAB_RETRY = 25, CARRYING = 5, RETURNING = 35 }
sc:loop("watchdog", 1, function()
if not running or token ~= runToken then return end
local now = os.clock()
local okCo, status = pcall(coroutine.status, worker)
if okCo and status == "dead" and running and token == runToken then
log.error("run %d: worker thread is dead while the run is on - stopping cleanly", token)
task.spawn(stop, "worker died")
return
end
local ph = watch.phase
local limit = ph and LIMIT[ph]
local inPhase = now - (watch.phaseAt or now)
local sinceStart = now - (watch.passAt or now)
local waiting = idleNow ~= nil
if limit and not waiting and inPhase > limit and watch.reported ~= ph then
watch.reported = ph
local hum, root = ch.humanoid(), ch.root()
local full, n, lim = data.eggInventory()
local tLeft = M.trustCooldown()
log.warn("WATCHDOG run %d: %s for %.1fs (limit %ds) uid=%s | state=%s humanoid=%s hp=%s root=%s anchored=%s"
.. " | ragdoll=%.1fs | movement owner=%s | last pickup=%s | retries=%d | inventory=%s/%s"
.. " | trust cooldown=%.0fs | pass started %.1fs ago",
token, ph, inPhase, limit, tostring(watch.uid), runState,
tostring(hum ~= nil and hum.Parent ~= nil), hum and ("%.0f"):format(hum.Health) or "-",
tostring(root ~= nil), tostring(root and root.Anchored),
guard.ragdollRemaining(), tostring(motion.owner()), tostring(watch.msg),
watch.retries or 0, tostring(n), tostring(lim), tLeft, sinceStart)
end
if not waiting and sinceStart > 150 then
log.error("run %d: no progress for %.0fs (phase %s) - stopping the run", token, sinceStart, tostring(ph))
task.spawn(stop, "stalled: no progress for " .. math.floor(sinceStart) .. "s")
end
end)
end
BX.onTeardown("autosteal", function()
if running then stop("hub unloaded") end
end)
function M.setOptions(src, o)
if type(src) == "table" or src == nil then src, o = "main", src end
src = tostring(src)
optsFor[src] = o or {}
if running and owner == src then
opts = optsFor[src]
log.info("%s updated its options mid-run", src)
end
end
function M.setEnabled(on, src)
src = tostring(src or "main")
if on then
if running then
if owner ~= src then
log.info("%s asked to start, but %s owns this run - ignored", src, owner)
return false, "Auto Steal is already running for " .. tostring(owner)
end
return true    
end
local okStart, why = start(src)
if okStart == false then return false, why end
else
if running and owner ~= nil and owner ~= src then
log.info("%s asked to stop, but %s owns this run - ignored", src, owner)
return false
end
stop("toggled off")
end
return true
end
function M.owner() return owner end
function M.isRunning() return running end
function M.runOnce(cancelFn)
local before = snapshot()
local ok, why, cycle = runCycle(runToken, cancelFn or function() return false end)
local after = snapshot()
if cycle then reportCycle(ok, why, cycle, before, after) end
return ok, why, cycle, before, after
end
function M.live()
return {
running = running,
busy = BUSY[runState] == true,
state = runState,
phase = watch.phase,
target = liveTarget,
idle = running and idleNow or nil,
}
end
function M.status()
return {
running  = running,
state    = runState,
busy     = BUSY[runState] == true,
token    = runToken,
cycles   = cycles,
failures = failures,
idle     = running and idleNow or nil,
tier     = dev.tier,
scope    = sc and sc:counts() or nil,
}
end
M.stop = stop
return M
end)
BX.module("features.bossfight", function(BX)
local svc  = BX.require("core.services")
local dev  = BX.require("core.device")
local ch   = BX.require("core.character")
local net  = BX.require("core.net")
local boss = BX.require("features.boss")
local mov  = BX.require("features.movement")
local auto = BX.require("features.autosteal")
local motion = BX.require("core.motion")
local log  = BX.require("boot.log").for_module("bossfight")
local M = {}
local K = {
TICK            = 0.12,
SWING_GAP       = 0.65,
SWING_GAP_EXACT = 0.15,
REACH           = 9,
EQUIP_SETTLE    = 0.25,
RESPAWN_SETTLE  = 0.6,
HAND_REACH_Y    = 30,
HAND_CHASE_Y    = 90,
HAND_RISE_EPS   = 2,      
HAND_COMMIT     = 1.5,    
SURFACE_MARGIN  = -20,
STEP_SPEED      = 420,
MAX_STEP        = 14,
MAX_DT          = 0.05,
SINK_MAX        = 6,      
Y_TAU           = 0.12,   
STUCK_TIME      = 2.5,
RIM_SWEEP       = { 25, 50, 75, 100, 125, 150 },
RIM_LOOKAHEAD   = 6,
MOVE_ARRIVE     = 1.5,
SWING_SLACK     = 4,      
AIM_COS         = 0.906,  
AIM_EASE        = 0.35,
TRACK_TAU       = 0.18,   
TRACK_JUMP      = 60,
WAIT_MAX        = 2.5,    
FLING_UP        = 60,
FLING_MULT      = 2.0,
GROUND_BAND     = 25,
PROBE_UP        = 40,
PROBE_DOWN      = 220,
SOLID_STEPS     = 8,
IGNORE_TTL      = 0.5,    
RING_STEP_DEG   = 22,
RING_RADII      = { 1.0, 0.85, 1.15, 0.7, 1.3 },
AROUND_ANGLES   = { 25, 45, 70, 95, 120, 145 },
AROUND_FRAC     = 0.55,
AROUND_MIN_R    = 90,
HAZARD_CACHE    = 0.1,
HAZARD_CLEAR    = 6,
SLAM_CLEAR      = 12,
RING_CLEAR      = 2,      
HOLE_CLEAR      = 6,
DODGE_GAP       = 0.08,
DODGE_POINTS    = 16,
DODGE           = false,  
ORBIT_TRIGGER   = 34,
ORBIT_STEP      = 0.55,
VOID_GAP        = 0.2,
VOID_MISSES     = 3,
VOID_DROP_PROOF = 25,
MAX_RISE        = 8,
HAND_BONES      = { "UpperHand1.R", "UpperHand1.L", "LowerHand1.R", "LowerHand1.L" },
WALK            = true,
WALK_LOOKAHEAD  = 24,
SNAP_GAP        = 8,
SNAPS           = 3,
SNAP_WINDOW     = 4,
BACKOFF_FIRST   = 1,
BACKOFF_MAX     = 8,
SKIP_AFTER      = 4,
SKIP_STUCK      = 3,
SKIP_FOR        = 15,
LEAVE_GAP       = 3,
LEAVE_TRIES     = 5,
TOWERS_TTL      = 2,      
NOPROG_REEQUIP  = 4,
NOPROG_SKIP     = 10,
COOLDOWN_STUCK  = 3,
}
M.K = K
local sc, enabled = nil, false
local stats = { swings = 0, dodges = 0, flings = 0, voidSaves = 0, rescues = 0, kills = 0 }
function M.stats() return table.clone(stats) end
function M.isOn() return enabled end
local S = nil
local function fresh()
return {
goal = nil, dodge = nil, aim = nil, trackPos = nil,
handY = {}, handPick = nil, handPickAt = 0,
lastSolid = nil, arenaFloorY = nil,
stuckBest = nil, stuckSince = nil, stuckFlip = false, rimSide = 1,
lastSwingAt = 0, batFor = nil, waitAt = nil, idlePhase = false,
arena = nil, hazards = nil, hazardsAt = 0,
ignore = nil, ignoreAt = 0,
inArena = false, noclipped = false, left = false,
settleUntil = 0, batAskedAt = 0,
voidAnchor = nil, voidMisses = 0,
lastLog = {},
phase = nil, kind = nil,
wrote = nil, snaps = {}, holdUntil = 0, backoff = 0, backoffs = 0,
sidesteps = 0, skip = {}, goalKey = nil,
killClaimed = false, leaveTries = 0, leaveAt = 0,
towers = nil, towersAt = 0,
stage = nil,
hitHp = nil, hitFor = nil, noProgress = 0, cooldownSince = nil, altSwing = false,
}
end
local function trail(stage, detail)
if not S or S.stage == stage then return end
S.stage = stage
log.info("fight: %s%s", stage, detail and (" (" .. tostring(detail) .. ")") or "")
end
local function every(key, secs, fmt, ...)
local now = os.clock()
if now - (S.lastLog[key] or 0) < secs then return end
S.lastLog[key] = now
log.info(fmt, ...)
end
local function inArena()
return svc.LocalPlayer:GetAttribute("InBossArena") == true
end
M.inArena = inArena
local function arena()
local a = S.arena
if a and a.Parent then return a end
a = workspace:FindFirstChild("BossArena") or workspace:FindFirstChild("BossArena", true)
S.arena = a
return a
end
local function arenaFloor()
local a = arena()
local f = a and a:FindFirstChild("Floor", true)
if f and f:IsA("BasePart") then return f end
return nil
end
local function arenaCentre()
local f = arenaFloor()
if f then return f.Position end
local a = arena()
if a and a.PrimaryPart then return a.PrimaryPart.Position end
return nil
end
local function bossModel()
local a = arena()
if not a then return nil end
local b = a:FindFirstChild("Boss", true)
if b and b:IsA("Model") then return b end
return nil
end
local function phase()
local b = bossModel()
if not b then return nil end
if b:GetAttribute("Spawning") then return nil end
if b:GetAttribute("PhaseTwoAt") ~= nil then return "hands" end
return "crystals"
end
local probeParams = RaycastParams.new()
probeParams.FilterType = Enum.RaycastFilterType.Exclude
probeParams.IgnoreWater = true
local function refreshIgnore()
local now = os.clock()
if S.ignore and (now - S.ignoreAt) < K.IGNORE_TTL then return end
local ignore = {}
for _, pl in ipairs(svc.Players:GetPlayers()) do
if pl.Character then ignore[#ignore + 1] = pl.Character end
end
local a = arena()
if a then
for _, nm in ipairs({ "CrystalTowers", "Boss", "SlamIndicator",
"SlamArmHitbox", "SlamRestHitbox" }) do
local d = a:FindFirstChild(nm, true)
if d then ignore[#ignore + 1] = d end
end
end
for _, nm in ipairs({ "BossHazards", "BossBlackHole" }) do
local d = workspace:FindFirstChild(nm)
if d then ignore[#ignore + 1] = d end
end
probeParams.FilterDescendantsInstances = ignore
S.ignore, S.ignoreAt = ignore, now
end
local function groundAt(pos)
refreshIgnore()
local top = pos.Y + K.PROBE_UP
local f = arenaFloor()
if f then top = math.max(top, f.Position.Y + K.PROBE_UP) end
local reach = math.max(K.PROBE_DOWN, (top - pos.Y) + K.PROBE_DOWN)
local r = workspace:Raycast(Vector3.new(pos.X, top, pos.Z),
Vector3.new(0, -reach, 0), probeParams)
if not r then return nil end
if f and (r.Position.Y - f.Position.Y) > K.GROUND_BAND then return nil end
return r.Position.Y
end
local function onFloor(pos) return groundAt(pos) ~= nil end
local function lastSolidToward(from, to)
local flat = Vector3.new(to.X - from.X, 0, to.Z - from.Z)
local dist = flat.Magnitude
if dist < 1 then return nil end
local dir = flat.Unit
local best
local step = math.max(dist / K.SOLID_STEPS, 20)
for i = 1, K.SOLID_STEPS do
local d = step * i
if d > dist then break end
local p = from + dir * d
local gy = groundAt(Vector3.new(p.X, from.Y, p.Z))
if not gy then break end
best = Vector3.new(p.X, gy, p.Z)
end
return best
end
local function clearLine(a, b)
local flat = Vector3.new(b.X - a.X, 0, b.Z - a.Z)
local dist = flat.Magnitude
if dist < 1 then return true end
local dir = flat.Unit
local step = math.max(dist / K.SOLID_STEPS, 20)
for i = 1, K.SOLID_STEPS do
local d = step * i
if d >= dist then break end
local p = a + dir * d
if not groundAt(Vector3.new(p.X, a.Y, p.Z)) then return false end
end
return true
end
local function ringWaypoint(from, to)
local mid = arenaCentre()
if not mid then return nil end
local a = Vector3.new(from.X - mid.X, 0, from.Z - mid.Z)
local b = Vector3.new(to.X - mid.X, 0, to.Z - mid.Z)
if a.Magnitude < 20 or b.Magnitude < 20 then return nil end
local ang1, ang2 = math.atan2(a.Z, a.X), math.atan2(b.Z, b.X)
local diff = ang2 - ang1
while diff > math.pi do diff = diff - 2 * math.pi end
while diff < -math.pi do diff = diff + 2 * math.pi end
local step = math.min(math.abs(diff), math.rad(K.RING_STEP_DEG))
if diff < 0 then step = -step end
local want = ang1 + step
for _, mul in ipairs(K.RING_RADII) do
local r = a.Magnitude * mul
local p = Vector3.new(mid.X + math.cos(want) * r, from.Y, mid.Z + math.sin(want) * r)
local gy = groundAt(p)
if gy then
local wp = Vector3.new(p.X, gy, p.Z)
if clearLine(from, wp) then return wp, math.deg(step) end
end
end
return nil
end
local function rotated(dir, a)
return Vector3.new(dir.X * math.cos(a) - dir.Z * math.sin(a), 0,
dir.X * math.sin(a) + dir.Z * math.cos(a))
end
local function detourAround(from, to)
if clearLine(from, to) then return nil end
local flat = Vector3.new(to.X - from.X, 0, to.Z - from.Z)
local dist = flat.Magnitude
if dist < 1 then return nil end
local dir = flat.Unit
local r = math.max(dist * K.AROUND_FRAC, K.AROUND_MIN_R)
for _, deg in ipairs(K.AROUND_ANGLES) do
for _, sign in ipairs({ 1, -1 }) do
local wp = from + rotated(dir, math.rad(deg) * sign) * r
local gy = groundAt(Vector3.new(wp.X, from.Y, wp.Z))
if gy then
wp = Vector3.new(wp.X, gy, wp.Z)
if clearLine(from, wp) and clearLine(wp, to) then return wp, deg * sign end
end
end
end
for _, deg in ipairs(K.AROUND_ANGLES) do
for _, sign in ipairs({ 1, -1 }) do
local wp = from + rotated(dir, math.rad(deg) * sign) * r
local gy = groundAt(Vector3.new(wp.X, from.Y, wp.Z))
if gy and clearLine(from, Vector3.new(wp.X, gy, wp.Z)) then
return Vector3.new(wp.X, gy, wp.Z), deg * sign
end
end
end
return nil
end
local function hazardParts()
local now = os.clock()
if S.hazards and (now - S.hazardsAt) < K.HAZARD_CACHE then return S.hazards end
local out = {}
local folder = workspace:FindFirstChild("BossHazards")
if folder then
for _, d in ipairs(folder:GetDescendants()) do
if d:IsA("BasePart") then out[#out + 1] = d end
end
end
local a = arena()
if a then
for _, name in ipairs({ "SlamIndicator", "SlamArmHitbox", "SlamRestHitbox" }) do
local d = a:FindFirstChild(name)
if d and d:IsA("BasePart") then out[#out + 1] = d end
end
end
local bh = workspace:FindFirstChild("BossBlackHole")
if bh and bh:IsA("BasePart") then out[#out + 1] = bh end
S.hazards, S.hazardsAt = out, now
return out
end
local function hazardClear(part)
local n = part.Name
if n == "BossBlackHole" then return K.HOLE_CLEAR end
if n:find("Slam") then return K.SLAM_CLEAR end
if n:find("Ring") then return K.RING_CLEAR end
return K.HAZARD_CLEAR
end
local function inHazard(part, pos, extra)
local clear = hazardClear(part) + (extra or 0)
if part:IsA("Part") and part.Shape == Enum.PartType.Cylinder then
local flat = Vector3.new(pos.X - part.Position.X, 0, pos.Z - part.Position.Z)
return flat.Magnitude <= part.Size.Y * 0.5 + clear
end
local rel = part.CFrame:PointToObjectSpace(pos)
local half = part.Size * 0.5
return math.abs(rel.X) <= half.X + clear
and math.abs(rel.Z) <= half.Z + clear
and math.abs(rel.Y) <= half.Y + 8
end
local function inAnyHazard(pos, extra)
if not K.DODGE then return nil end
for _, part in ipairs(hazardParts()) do
if inHazard(part, pos, extra) then return part end
end
return nil
end
local function dodgeScore(spot, here)
local aim = S.aim
if typeof(aim) == "Vector3" then
return Vector3.new(spot.X - aim.X, 0, spot.Z - aim.Z).Magnitude
end
return Vector3.new(spot.X - here.X, 0, spot.Z - here.Z).Magnitude
end
local function dodgeHazards()
if not K.DODGE then S.dodge = nil return false end
local h = ch.root()
if not h then return false end
local parts = hazardParts()
if #parts == 0 then S.dodge = nil return false end
local hit = nil
for _, part in ipairs(parts) do
if inHazard(part, h.Position) then hit = part break end
end
if not hit then S.dodge = nil return false end
local here = h.Position
local cands = {}
if hit:IsA("Part") and hit.Shape == Enum.PartType.Cylinder then
local want = hit.Size.Y * 0.5 + K.HOLE_CLEAR + 4
for i = 0, K.DODGE_POINTS - 1 do
local ang = (2 * math.pi / K.DODGE_POINTS) * i
cands[#cands + 1] = Vector3.new(hit.Position.X + math.cos(ang) * want, here.Y,
hit.Position.Z + math.sin(ang) * want)
end
else
local rel = hit.CFrame:PointToObjectSpace(here)
local half = hit.Size * 0.5
local clear = hazardClear(hit) + 4
local outX = (rel.X >= 0 and 1 or -1) * (half.X + clear)
local outZ = (rel.Z >= 0 and 1 or -1) * (half.Z + clear)
local cf = hit.CFrame
cands[#cands + 1] = cf:PointToWorldSpace(Vector3.new(rel.X, rel.Y, outZ))
cands[#cands + 1] = cf:PointToWorldSpace(Vector3.new(outX, rel.Y, rel.Z))
cands[#cands + 1] = cf:PointToWorldSpace(Vector3.new(rel.X, rel.Y, -outZ))
cands[#cands + 1] = cf:PointToWorldSpace(Vector3.new(-outX, rel.Y, rel.Z))
cands[#cands + 1] = cf:PointToWorldSpace(Vector3.new(outX, rel.Y, outZ))
cands[#cands + 1] = cf:PointToWorldSpace(Vector3.new(-outX, rel.Y, outZ))
end
local best, bestScore
for _, spot in ipairs(cands) do
if onFloor(spot) and not inAnyHazard(spot, 0) then
local scr = dodgeScore(spot, here)
if not bestScore or scr < bestScore then best, bestScore = spot, scr end
end
end
if not best then
for _, spot in ipairs(cands) do
if onFloor(spot) then
local scr = dodgeScore(spot, here)
if not bestScore or scr < bestScore then best, bestScore = spot, scr end
end
end
end
if not best then
local mid = arenaCentre()
if mid then
local inward = Vector3.new(mid.X - here.X, 0, mid.Z - here.Z)
if inward.Magnitude > 1 then
best = here + inward.Unit * math.min(inward.Magnitude, 60)
end
end
end
if not best then return true end
S.dodge = { pos = best }
stats.dodges = stats.dodges + 1
return true
end
local function orbitPoint(tpos, reach)
local h = ch.root()
local bh = workspace:FindFirstChild("BossBlackHole")
if not h or not bh or not bh:IsA("BasePart") then return nil end
local toHole = Vector3.new(bh.Position.X - h.Position.X, 0, bh.Position.Z - h.Position.Z)
if toHole.Magnitude > K.ORBIT_TRIGGER then return nil end
local rel = Vector3.new(h.Position.X - tpos.X, 0, h.Position.Z - tpos.Z)
if rel.Magnitude < 1 then rel = Vector3.new(1, 0, 0) end
local ang = math.atan2(rel.Z, rel.X)
local r = math.max(reach, 6)
local function at(a)
return Vector3.new(tpos.X + math.cos(a) * r, h.Position.Y, tpos.Z + math.sin(a) * r)
end
local p1, p2 = at(ang + K.ORBIT_STEP), at(ang - K.ORBIT_STEP)
local function fromHole(p)
return Vector3.new(p.X - bh.Position.X, 0, p.Z - bh.Position.Z).Magnitude
end
local first, second = p1, p2
if fromHole(p2) > fromHole(p1) then first, second = p2, p1 end
if onFloor(first) then return first end
if onFloor(second) then return second end
return nil
end
local function isBatTool(t)
return t:IsA("Tool") and (t:GetAttribute("IsBat") == true or t.Name:find("Bat") ~= nil)
end
local function equipBat()
local char = ch.get()
if not char then return nil end
for _, t in ipairs(char:GetChildren()) do
if isBatTool(t) then return t end
end
local bp = svc.LocalPlayer:FindFirstChild("Backpack")
if bp then
for _, t in ipairs(bp:GetChildren()) do
if isBatTool(t) then
local hum = ch.humanoid()
local ok = hum and pcall(function() hum:EquipTool(t) end)
if not ok or t.Parent ~= char then t.Parent = char end
log.info("equipped %s", t.Name)
return t
end
end
end
return nil
end
local batSeq, batAnimTrack, batAnimFor = 0, nil, nil
local function batSwing(bat, alternate)
if alternate then
pcall(function() bat:Activate() end)
end
local ok = pcall(function()
local rem = net.find("RE/BatSwing/Trigger")
assert(rem, "no BatSwing remote")
batSeq = batSeq + 1
rem:FireServer(nil, ("%d:%d:%d"):format(svc.LocalPlayer.UserId, batSeq,
math.floor(workspace:GetServerTimeNow() * 1000)))
end)
if not ok then
pcall(function() bat:Activate() end)
return
end
pcall(function()
local anim = bat:FindFirstChild("HitAnim")
local hum = ch.humanoid()
local animator = hum and hum:FindFirstChildOfClass("Animator")
if anim and animator then
if batAnimFor ~= animator then
batAnimTrack = animator:LoadAnimation(anim)
batAnimFor = animator
end
batAnimTrack:Play()
end
local snd = bat:FindFirstChild("Slash", true)
if snd and snd:IsA("Sound") then snd:Play() end
end)
end
local function readyAfterRagdoll()
local hm, h = ch.humanoid(), ch.root()
if not hm or not h then return end
hm.PlatformStand = false
hm.Sit = false
hm.AutoRotate = true
local st = hm:GetState()
if st == Enum.HumanoidStateType.Physics
or st == Enum.HumanoidStateType.PlatformStanding
or st == Enum.HumanoidStateType.FallingDown
or st == Enum.HumanoidStateType.Ragdoll
or st == Enum.HumanoidStateType.Seated then
hm:ChangeState(Enum.HumanoidStateType.GettingUp)
end
h.AssemblyLinearVelocity = Vector3.zero
h.AssemblyAngularVelocity = Vector3.zero
end
local function antiFling()
local h, hum = ch.root(), ch.humanoid()
if not h or not hum then return end
local v = h.AssemblyLinearVelocity
local flat = (v * Vector3.new(1, 0, 1)).Magnitude
local cap = math.max((hum.WalkSpeed or 16) * K.FLING_MULT, 120)
if v.Y <= K.FLING_UP and flat <= cap then return end
local keep = Vector3.zero
if flat > 0.001 then
keep = (v * Vector3.new(1, 0, 1)).Unit * math.min(flat, hum.WalkSpeed or 16)
end
h.AssemblyLinearVelocity = Vector3.new(keep.X, math.min(v.Y, 0), keep.Z)
h.AssemblyAngularVelocity = Vector3.zero
stats.flings = stats.flings + 1
every("fling", 2, "cancelled a launch (up %.0f, flat %.0f) - %d so far",
v.Y, flat, stats.flings)
end
local function targetReach(part)
if typeof(part) == "Vector3" then return K.REACH end
if not (part and part:IsA("BasePart")) then return K.REACH end
local half = math.max(part.Size.X, part.Size.Z) * 0.5
return math.max(K.REACH, half + K.SURFACE_MARGIN)
end
local function target()
local h = ch.root()
if not h then return nil end
local ph = phase()
if not ph then return nil end
if ph == "crystals" then
local now = os.clock()
if not S.towers or (now - S.towersAt) > K.TOWERS_TTL then
local a = arena()
local towers = a and a:FindFirstChild("CrystalTowers", true)
local list = {}
if towers then
for _, d in ipairs(towers:GetDescendants()) do
if d:IsA("BasePart") and d.Name == "Hitbox" then list[#list + 1] = d end
end
end
S.towers, S.towersAt = list, now
end
local best, bestD, skipped = nil, nil, nil
for _, d in ipairs(S.towers) do
if d.Parent then
local hp = d:GetAttribute("Health")
if type(hp) == "number" and hp > 0 then
if (S.skip[d] or 0) > now then
skipped = d
else
local dist = (d.Position - h.Position).Magnitude
if not bestD or dist < bestD then best, bestD = d, dist end
end
end
end
end
best = best or skipped
if best then return best, "crystal" end
return nil
end
local b = bossModel()
if not b then return nil end
local myY = h.Position.Y
local low, lowD, any, anyD, anyUp
for _, bn in ipairs(K.HAND_BONES) do
local bone = b:FindFirstChild(bn, true)
if bone and bone:IsA("Bone") then
local pos
pcall(function() pos = bone.TransformedWorldCFrame.Position end)
pos = pos or bone.WorldPosition
if pos then
local prev = S.handY[bn]
S.handY[bn] = pos.Y
local rising = prev ~= nil and (pos.Y - prev) > K.HAND_RISE_EPS
if not rising then
local flat = Vector3.new(pos.X - h.Position.X, 0, pos.Z - h.Position.Z).Magnitude
if not anyD or flat < anyD then any, anyD, anyUp = pos, flat, pos.Y - myY end
if (pos.Y - myY) <= K.HAND_REACH_Y and (not lowD or flat < lowD) then
low, lowD = pos, flat
end
end
end
end
end
local function landable(p)
if not p then return nil end
if onFloor(p) and clearLine(h.Position, p) then return p end
local wp, ang = ringWaypoint(h.Position, p)
if not wp then wp, ang = detourAround(h.Position, p) end
if wp then
every("pit", 2, "pit in the way - walking round the ring (%+.0f deg)", ang or 0)
return wp
end
return lastSolidToward(h.Position, p)
end
low = landable(low)
if any and (anyUp or 0) <= K.HAND_CHASE_Y then any = landable(any) else any = nil end
local now = os.clock()
if S.handPick and (now - S.handPickAt) < K.HAND_COMMIT then
local keep = S.handPick
if (low and (low - keep).Magnitude < 220) or (any and (any - keep).Magnitude < 220) then
return keep, "hand"
end
end
if low then
S.handPick, S.handPickAt = low, now
return low, "hand"
end
if any then
S.handPick, S.handPickAt = any, now
return any, "hand"
end
if anyUp then
every("high", 2, "hands up: nearest is %.0f studs up (need <= %d) - holding for the slam",
anyUp, K.HAND_REACH_Y)
end
return nil
end
local function leaveArena()
local a = arena()
local exit = a and a:FindFirstChild("BossArenaLeaveTeleport", true)
local part = exit and (exit:IsA("BasePart") and exit
or exit:FindFirstChild("Hitbox", true)
or exit:FindFirstChildWhichIsA("BasePart", true))
local c = ch.get()
if not (part and c) then return false end
c:MoveTo(part.Position + Vector3.new(0, 3, 0))
return true
end
local function setNoclip(on)
if on == S.noclipped then return end
S.noclipped = on
if on then
mov.noclip(true)
elseif not auto.isBusy() then
mov.noclip(false)
end
end
local function skipTarget(why)
local key = S.goalKey
if typeof(key) == "Instance" then
S.skip[key] = os.clock() + K.SKIP_FOR
log.warn("fight: NEXT TARGET - skipping this crystal for %ds (%s)", K.SKIP_FOR, why)
else
S.holdUntil = math.max(S.holdUntil, os.clock() + K.SKIP_FOR / 3)
log.warn("fight: holding %ds before chasing the hands again (%s)", math.floor(K.SKIP_FOR / 3), why)
end
S.goal, S.goalKey, S.backoffs, S.sidesteps, S.backoff = nil, nil, 0, 0, 0
end
local function noteSnap(kind)
if not S or not S.inArena then return end
local now = os.clock()
for i = #S.snaps, 1, -1 do
if now - S.snaps[i] > K.SNAP_WINDOW then table.remove(S.snaps, i) end
end
S.snaps[#S.snaps + 1] = now
if #S.snaps < K.SNAPS then return end
S.snaps = {}
S.backoff = math.min(S.backoff > 0 and S.backoff * 2 or K.BACKOFF_FIRST, K.BACKOFF_MAX)
S.backoffs = S.backoffs + 1
S.holdUntil = now + S.backoff
S.goal, S.wrote = nil, nil
stats.snapBackoffs = (stats.snapBackoffs or 0) + 1
log.warn("fight: movement interrupted (%s x%d in %ds) - holding %.0fs (backoff %d/%d)",
tostring(kind), K.SNAPS, K.SNAP_WINDOW, S.backoff, S.backoffs, K.SKIP_AFTER)
readyAfterRagdoll()
if S.backoffs >= K.SKIP_AFTER then skipTarget("server kept moving us back") end
end
local function moverStep(dt)
if not S.inArena or motion.blockedBy("bossfight") then return end
if S.settleUntil and os.clock() < S.settleUntil then return end
if os.clock() < S.holdUntil then return end
do
local hh, hmn = ch.root(), ch.humanoid()
if hh and S.wrote and (os.clock() - (S.wroteAt or 0)) < 0.2 then
if (hh.Position - S.wrote).Magnitude > K.SNAP_GAP then
S.wrote = nil
noteSnap("snap")
return
end
end
if hh and S.walking and S.lastPos then
local reachable = math.max((hmn and hmn.WalkSpeed or 16) * math.min(dt, 0.1) * 3, 25)
if (hh.Position - S.lastPos).Magnitude > reachable then
S.lastPos = hh.Position
noteSnap("walk snap")
return
end
end
S.lastPos = hh and hh.Position or nil
end
antiFling()
local dodging = S.dodge ~= nil
local goal = S.dodge or S.goal
local h, hum = ch.root(), ch.humanoid()
if not goal then
if S.walking and h and hum then hum:MoveTo(h.Position) S.walking = false end
return
end
if not h or not hum then return end
if groundAt(h.Position) then
S.lastSolid = h.Position
elseif S.lastSolid then
local back = Vector3.new(S.lastSolid.X - h.Position.X, 0, S.lastSolid.Z - h.Position.Z)
if back.Magnitude > 1 then
local st2 = math.min(back.Magnitude, math.min(dt, K.MAX_DT) * K.STEP_SPEED, K.MAX_STEP)
local nb = h.Position + back.Unit * st2
local gyb = groundAt(nb) or S.lastSolid.Y
hum.PlatformStand = false
h.CFrame = CFrame.lookAt(Vector3.new(nb.X, gyb, nb.Z), Vector3.new(nb.X, gyb, nb.Z) + back.Unit)
S.wrote, S.wroteAt = Vector3.new(nb.X, gyb, nb.Z), os.clock()
h.AssemblyLinearVelocity = Vector3.zero
stats.rescues = stats.rescues + 1
every("rescue", 1, "no ground underneath - walking back to solid")
end
return
end
local flat = Vector3.new(goal.pos.X - h.Position.X, 0, goal.pos.Z - h.Position.Z)
local reach = dodging and 0 or (goal.reach or K.REACH)
local left = flat.Magnitude - reach
if left <= K.MOVE_ARRIVE then
if dodging then S.dodge = nil else S.goal = nil end
S.backoff, S.backoffs, S.sidesteps = 0, 0, 0
trail("ARRIVED")
return
end
local now = os.clock()
if not S.stuckBest or left < S.stuckBest - 2 then S.stuckBest, S.stuckSince = left, now end
local dirUse = flat.Unit
if S.stuckSince and (now - S.stuckSince) > K.STUCK_TIME then
S.stuckFlip = not S.stuckFlip
local sgn = S.stuckFlip and 1 or -1
dirUse = Vector3.new(-flat.Unit.Z * sgn, 0, flat.Unit.X * sgn)
S.stuckSince, S.stuckBest = now, nil
S.sidesteps = S.sidesteps + 1
every("stuck", 2, "not making progress - sidestepping (%d/%d)", S.sidesteps, K.SKIP_STUCK)
if S.sidesteps >= K.SKIP_STUCK then
skipTarget("no progress after " .. S.sidesteps .. " sidesteps")
return
end
end
local step = math.min(left, math.min(dt, K.MAX_DT) * K.STEP_SPEED, K.MAX_STEP)
local nxt = h.Position + dirUse * step
if not dodging and inAnyHazard(nxt, 0) then return end
local function groundFor(dir, dist)
local probe = h.Position + dir * dist
return groundAt(Vector3.new(probe.X, h.Position.Y, probe.Z))
end
local gy = groundFor(dirUse, step)
if gy then
S.arenaFloorY = gy
elseif S.arenaFloorY and h.Position.Y < S.arenaFloorY - K.SINK_MAX then
h.CFrame = CFrame.new(h.Position.X, S.arenaFloorY, h.Position.Z)
S.wrote, S.wroteAt = Vector3.new(h.Position.X, S.arenaFloorY, h.Position.Z), os.clock()
h.AssemblyLinearVelocity = Vector3.zero
every("sink", 2, "dropped below the floor - lifted back onto it")
return
end
if not gy then
local found = nil
for _, deg in ipairs(K.RIM_SWEEP) do
for _, sgn in ipairs(S.rimSide == -1 and { -1, 1 } or { 1, -1 }) do
local d = rotated(dirUse, math.rad(deg * sgn))
local g = groundFor(d, step)
if g and groundFor(d, step + K.RIM_LOOKAHEAD) then
found, gy = d, g
S.rimSide = sgn
break
end
end
if found then break end
end
if not found then
if dodging then S.dodge = nil else S.goal = nil end
return
end
dirUse = found
nxt = h.Position + dirUse * step
S.stuckSince = now
every("rim", 2, "hole in the way - following the rim round")
end
hum.PlatformStand = false
if K.WALK then
local aim = h.Position + dirUse * math.min(left + 2, K.WALK_LOOKAHEAD)
hum:MoveTo(Vector3.new(aim.X, gy, aim.Z))
S.walking, S.wrote, S.wroteAt = true, nil, os.clock()
return
end
local curY = h.Position.Y
local k = 1 - math.exp(-dt / K.Y_TAU)
local dest = Vector3.new(nxt.X, curY + (gy - curY) * k, nxt.Z)
hum:Move(Vector3.zero, false)
h.CFrame = CFrame.lookAt(dest, dest + flat.Unit)
S.wrote, S.wroteAt = dest, os.clock()
h.AssemblyLinearVelocity = Vector3.new(0, h.AssemblyLinearVelocity.Y, 0)
h.AssemblyAngularVelocity = Vector3.zero
end
local function fightTick()
local inside = inArena()
if inside ~= S.inArena then
S.inArena = inside
setNoclip(inside)
S.goal, S.dodge, S.aim, S.trackPos, S.handPick = nil, nil, nil, nil, nil
S.lastSolid, S.arenaFloorY, S.left = nil, nil, false
S.voidAnchor, S.voidMisses = nil, 0
S.snaps, S.holdUntil, S.backoff, S.backoffs, S.sidesteps = {}, 0, 0, 0, 0
S.wrote, S.goalKey, S.killClaimed, S.leaveTries, S.stage = nil, nil, false, 0, nil
if inside then
S.settleUntil = os.clock() + K.RESPAWN_SETTLE
readyAfterRagdoll()
motion.claim("bossfight")
trail("EVENT", "entered the arena")
else
motion.release("bossfight")
end
log.info(inside and "in the arena - fighting" or "left the arena")
end
if not inside or motion.blockedBy("bossfight") then return end
if S.settleUntil and os.clock() < S.settleUntil then return end
local bat = equipBat()
if not bat then
if os.clock() - (S.batAskedAt or 0) > 5 then
S.batAskedAt = os.clock()
local okW, msgW = net.call("RF/Codex/AskWearFieldBat")
log.info("no bat - AskWearFieldBat -> %s %s", tostring(okW), tostring(msgW or ""))
end
elseif S.batFor ~= bat then
S.batFor = bat
task.wait(K.EQUIP_SETTLE)
end
local hmz = ch.humanoid()
if hmz then
local stt = hmz:GetState()
if hmz.PlatformStand or stt == Enum.HumanoidStateType.Physics
or stt == Enum.HumanoidStateType.PlatformStanding
or stt == Enum.HumanoidStateType.None then
readyAfterRagdoll()
end
end
local inHaz = dodgeHazards()
local snap = boss.snapshot()
local dead = snap and tonumber(snap.BossHealth) and snap.BossHealth <= 0
if dead then
S.goal, S.aim = nil, nil
if not S.killClaimed then
S.killClaimed = true
stats.kills = stats.kills + 1
trail("BOSS UPDATE", "boss dead")
local n = boss.claimMilestones()
log.info("boss dead - claimed %d milestone(s)", n)
end
local now = os.clock()
if S.leaveTries < K.LEAVE_TRIES and (now - S.leaveAt) >= K.LEAVE_GAP then
S.leaveTries, S.leaveAt = S.leaveTries + 1, now
S.wrote = nil
local okLeave = leaveArena()
log.info("walking out of the arena (try %d/%d) -> %s", S.leaveTries, K.LEAVE_TRIES, tostring(okLeave))
elseif S.leaveTries >= K.LEAVE_TRIES then
every("leavefail", 15, "boss dead but still in the arena after %d walk-outs - holding", S.leaveTries)
end
S.left = true
return
elseif S.left then
S.left, S.killClaimed, S.leaveTries = false, false, 0
end
local newPhase = phase()
if newPhase ~= S.phase then
trail(S.phase == nil and "BOSS FOUND" or "BOSS UPDATE", "phase " .. tostring(newPhase or "spawning"))
end
S.phase = newPhase
if os.clock() < S.holdUntil then return end
local part, kind = target()
if typeof(part) == "Instance" and (not part.Parent or (tonumber(part:GetAttribute("Health")) or 1) <= 0) then
part, kind = nil, nil       
S.towersAt = 0
end
if part ~= nil and (typeof(part) == "Instance" and part or "hand") ~= S.goalKey then
S.goalKey = (typeof(part) == "Instance") and part or "hand"
S.backoff, S.backoffs, S.sidesteps = 0, 0, 0
trail("NEXT TARGET", tostring(kind))
end
if not part then
S.goal, S.aim, S.kind = nil, nil, nil
if S.idlePhase ~= S.phase then
S.idlePhase = S.phase
log.info("nothing to hit (phase=%s) - holding position", tostring(S.phase or "spawning"))
end
return
end
S.idlePhase, S.kind = false, kind
local tpos = (typeof(part) == "Vector3") and part or part.Position
local h = ch.root()
if not h then return end
local reach = targetReach(part)
local flatDir = Vector3.new(tpos.X - h.Position.X, 0, tpos.Z - h.Position.Z)
local d = flatDir.Magnitude
local stand = h.Position + (d > 0.001 and flatDir.Unit * math.max(d - reach, 0) or Vector3.zero)
if inAnyHazard(Vector3.new(stand.X, h.Position.Y, stand.Z), 0) then
S.waitAt = S.waitAt or os.clock()
if os.clock() - S.waitAt < K.WAIT_MAX then
S.goal = nil
return
end
else
S.waitAt = nil
end
S.aim = tpos
if d > reach + K.SWING_SLACK then
local smooth = tpos
if kind == "hand" then
local prev = S.trackPos
if prev and (prev - tpos).Magnitude < K.TRACK_JUMP then
smooth = prev:Lerp(tpos, 1 - math.exp(-K.TICK / K.TRACK_TAU))
end
S.trackPos = smooth
else
S.trackPos = nil
end
S.goal = { pos = smooth, reach = reach }
trail("MOVING", tostring(kind))
return
end
local orbit = orbitPoint(tpos, reach)
if orbit then
S.goal = { pos = orbit, reach = 0 }
every("orbit", 3, "black hole is on us - orbiting the target")
else
S.goal = nil
end
if inHaz then return end
local flat = Vector3.new(tpos.X - h.Position.X, 0, tpos.Z - h.Position.Z)
if flat.Magnitude > 0.1 then
local wantDir = flat.Unit
local haveDir = h.CFrame.LookVector * Vector3.new(1, 0, 1)
haveDir = haveDir.Magnitude > 0.001 and haveDir.Unit or wantDir
if haveDir:Dot(wantDir) < K.AIM_COS then
local cur = h.CFrame
h.CFrame = cur:Lerp(CFrame.lookAt(cur.Position, cur.Position + wantDir), K.AIM_EASE)
end
end
if not bat or not bat.Parent then return end
if bat:GetAttribute("CooldownActive") == true then
S.cooldownSince = S.cooldownSince or os.clock()
if os.clock() - S.cooldownSince < K.COOLDOWN_STUCK then return end
every("cooldown", 10, "CooldownActive stuck for %.0fs - ignoring it", os.clock() - S.cooldownSince)
else
S.cooldownSince = nil
end
local endAt = tonumber(bat:GetAttribute("CooldownEndTime"))
local haveExact = endAt ~= nil and endAt > 0
if haveExact and endAt > workspace:GetServerTimeNow() then return end
local gap = haveExact and K.SWING_GAP_EXACT or K.SWING_GAP
if os.clock() - S.lastSwingAt < gap then return end
if kind == "crystal" and typeof(part) == "Instance" then
local hp = part:GetAttribute("Health")
if S.hitFor ~= part then
S.hitFor, S.hitHp, S.noProgress, S.altSwing = part, hp, 0, false
elseif type(hp) == "number" and type(S.hitHp) == "number" and hp < S.hitHp then
S.hitHp, S.noProgress = hp, 0
S.backoff, S.backoffs, S.sidesteps = 0, 0, 0   
elseif stats.swings > 0 then
S.noProgress = S.noProgress + 1
if S.noProgress == K.NOPROG_REEQUIP then
log.warn("fight: %d swings without damage - re-equipping the bat and trying the alternate swing", S.noProgress)
S.batFor, S.altSwing = nil, true
readyAfterRagdoll()
elseif S.noProgress >= K.NOPROG_SKIP then
skipTarget(("no damage after %d swings"):format(S.noProgress))
S.hitFor, S.noProgress = nil, 0
return
end
end
end
S.lastSwingAt = os.clock()
batSwing(bat, S.altSwing)
stats.swings = stats.swings + 1
trail("ATTACKING", tostring(kind))
if stats.swings % 20 == 1 then
log.info("swinging at the %s (%d swings)", tostring(kind), stats.swings)
end
end
local function voidTick()
if not S.inArena then return end
local c, h = ch.get(), ch.root()
if not (c and h) then return end
local pos = h.Position
local gy = groundAt(pos)
if gy and math.abs(pos.Y - gy) <= K.MAX_RISE then
S.voidAnchor = Vector3.new(pos.X, gy, pos.Z)
S.voidMisses = 0
return
end
if not gy then S.voidMisses = S.voidMisses + 1 else S.voidMisses = 0 end
local falling = S.voidAnchor and (pos.Y < S.voidAnchor.Y - K.VOID_DROP_PROOF)
if S.voidMisses >= K.VOID_MISSES and falling then
S.voidMisses = 0
local back = S.voidAnchor or arenaCentre()
if back then
stats.voidSaves = stats.voidSaves + 1
h.AssemblyLinearVelocity = Vector3.zero
h.AssemblyAngularVelocity = Vector3.zero
c:MoveTo(back)
h.CFrame = CFrame.new(back)
S.wrote, S.wroteAt = back, os.clock()
log.info("voidwatch: off the floor at (%.0f, %.0f, %.0f) - pulled back (#%d)",
pos.X, pos.Y, pos.Z, stats.voidSaves)
task.wait(0.3)
end
end
end
function M.status()
if not enabled then return { title = "Auto fight", body = "off" } end
if auto.isBusy() then
return { title = "Auto fight", body = "ON  \u{B7}  waiting for Auto Steal to finish its steal" }
end
if not S.inArena then
local held = boss.held()
if held and held.Open == true then
return { title = "Auto fight", body = boss.autoEnterOn()
and "ON  \u{B7}  boss open - entering"
or "ON  \u{B7}  boss open - press Enter or turn on Auto enter" }
end
return { title = "Auto fight", body = "ON  \u{B7}  waiting for the boss world to open" }
end
if S.left then return { title = "Auto fight", body = "Boss dead  \u{B7}  leaving" } end
local ph = S.phase
if not ph then return { title = "Auto fight", body = "In the arena  \u{B7}  boss spawning" } end
local what = S.kind and ("hitting the " .. S.kind) or "holding"
return { title = "Auto fight",
body = ("Fighting  \u{B7}  %s  \u{B7}  %s  \u{B7}  %d swings"):format(ph, what, stats.swings) }
end
function M.setEnabled(on)
on = on and true or false
if on == enabled then return true end
if not on then
enabled = false
motion.release("bossfight")
if sc then sc:destroy() sc = nil end
if S then
S.goal, S.dodge, S.aim = nil, nil, nil
setNoclip(false)
BX.try("bossfight.offRestore", readyAfterRagdoll)
end
S = nil
log.info("off (%d swings, %d kills this session)", stats.swings, stats.kills)
return true
end
if not boss.isOn() then boss.setEnabled(true) end
S = fresh()
sc = BX.scope("features.bossfight")
enabled = true
sc:onFrame("mover", svc.RunService.Heartbeat, moverStep)
sc:loop("fight", K.TICK, fightTick)
sc:loop("void", K.VOID_GAP, voidTick)
if K.DODGE then
sc:loop("dodge", K.DODGE_GAP, function()
if S.inArena then dodgeHazards() end
end)
end
ch.onSpawn(sc, "bossfight.respawn", function()
if not S then return end
setNoclip(false)
S.goal, S.dodge, S.aim, S.trackPos, S.batFor = nil, nil, nil, nil, nil
S.lastSolid, S.arenaFloorY, S.left = nil, nil, false
S.voidAnchor, S.voidMisses = nil, 0
S.inArena, S.noclipped = false, false
S.snaps, S.holdUntil, S.backoff, S.backoffs, S.sidesteps = {}, 0, 0, 0, 0
S.wrote, S.goalKey, S.stage = nil, nil, nil
motion.release("bossfight")     
S.settleUntil = os.clock() + K.RESPAWN_SETTLE
end)
motion.onRejected(sc, function(kind)
if S and S.inArena and S.wroteAt and (os.clock() - S.wroteAt) < 0.5 then noteSnap(kind) end
end)
log.info("on (tick %.2fs, swing %.2fs, dodge %s) - waiting for the arena",
K.TICK, K.SWING_GAP, K.DODGE and "on" or "off")
return true
end
BX.onTeardown("bossfight", function() M.setEnabled(false) end)
return M
end)
BX.module("features.prewarm", function(BX)
local svc  = BX.require("core.services")
local log  = BX.require("boot.log").for_module("prewarm")
local M = {}
local sc = nil
local steps = {}      
local done = false
function M.report() return table.clone(steps) end
function M.isDone() return done end
local function record(name, ms, detail)
steps[#steps + 1] = { name = name, ms = ms, detail = detail }
end
function M.start()
if sc then return false end
sc = BX.scope("features.prewarm")
sc:spawn("warm", function()
local t0 = os.clock()
local grab = BX.require("features.grab")
svc.RunService.Heartbeat:Wait()
BX.try("prewarm.prompts", function()
local ms, n = grab.warmPrompts()
record("prompts", ms, n .. " prompts")
end)
local plot = BX.require("features.plot")
svc.RunService.Heartbeat:Wait()
BX.try("prewarm.safeZone", function()
local s0 = os.clock()
local _, via = plot.safeZone()
record("safeZone", (os.clock() - s0) * 1000, tostring(via))
end)
svc.RunService.Heartbeat:Wait()
BX.try("prewarm.plotHome", function()
local s0 = os.clock()
local _, via = plot.home()
record("plotHome", (os.clock() - s0) * 1000, tostring(via))
end)
local bait = BX.require("features.bait")
svc.RunService.Heartbeat:Wait()
BX.try("prewarm.baitArea", function()
local s0 = os.clock()
local area = bait.firstAreaId(6)
record("baitArea", (os.clock() - s0) * 1000, tostring(area))
end)
local move = BX.require("features.movement")
local ch = BX.require("core.character")
svc.RunService.Heartbeat:Wait()
BX.try("prewarm.ground", function()
local hrp = ch.root()
if not hrp then record("ground", 0, "no character") return end
local s0 = os.clock()
local y = move.groundY(hrp.Position)
record("ground", (os.clock() - s0) * 1000,
y and ("y=" .. ("%.0f"):format(y)) or "no hit")
end)
done = true
local parts = {}
local total = 0
for _, s in ipairs(steps) do
parts[#parts + 1] = ("%s=%.1fms(%s)"):format(s.name, s.ms, s.detail)
total = total + s.ms
end
log.info("prewarmed in %.0fms wall, %.1fms of work: %s",
(os.clock() - t0) * 1000, total, table.concat(parts, " "))
end)
return true
end
function M.stop()
if not sc then return end
sc:destroy()
sc = nil
end
return M
end)
do
local logmod = BX.require("boot.log")
logmod.level = BX.require("core.config").LOG_LEVEL
local log = logmod.for_module("startup")
logmod.session(("VoidcxzHub %s build %s | generation %d")
:format(BX.version, BX.build, BX.generation))
local startup = { state = "BOOTING", stages = {}, t0 = os.clock(), current = nil }
local env = (type(getgenv) == "function" and getgenv()) or _G
env.VoidcxzStartup = startup
local function setState(s)
startup.state = s
log.info("state -> %s", s)
end
local function timeline(label, detail)
log.info("timeline %7.0fms  %s%s", (os.clock() - startup.t0) * 1000, label,
detail and ("  (" .. tostring(detail) .. ")") or "")
end
BX.timeline = timeline
startup.mark = timeline
timeline("EXECUTE")
local function heapKb()
local ok, kb = pcall(collectgarbage, "count")
return ok and kb or 0
end
local function frameNo()
return BX.profile and BX.profile.frameNo or 0
end
local function record(name, result, detail, ms, kb, frames)
startup.stages[#startup.stages + 1] = {
name = name, result = result, detail = detail,
at = os.clock() - startup.t0, ms = ms, kb = kb, frames = frames,
}
local line = ("stage %-14s %6.0fms %5s %8s  %s%s"):format(name, ms or 0,
(frames or 0) > 0 and (frames .. "f") or "0f",
(frames or 0) > 0 and "-" or ("+" .. math.floor(math.max(kb or 0, 0)) .. "KB"),
result, detail and (": " .. tostring(detail)) or "")
if result == "FAILED" then log.error("%s", line)
elseif result == "FALLBACK" then log.warn("%s", line)
else log.info("%s", line) end
if startup.console then print("[VOIDCXZ] " .. line) end
end
local splash = { step = function() end, fail = function() end,
done = function() end, whenClosed = function(fn) pcall(fn) end }
local function failHub(stageName, why)
startup.failedAt = stageName
startup.error = tostring(why)
setState("FAILED")
splash.fail(("Failed to initialize  |  Stage: %s  |  %s"):format(stageName, tostring(why)))
warn(("[VOIDCXZ] startup failed - stage %s: %s"):format(stageName, tostring(why)))
warn("[VOIDCXZ] see VoidcxzHub_trace.txt")
end
local function stage(name, required, fn)
if not BX.alive() or startup.state == "FAILED" then
record(name, "SKIPPED", BX.alive() and "startup already failed" or "retired by a newer copy", 0, 0, 0)
return false, "skipped"
end
startup.current, startup.currentAt = name, os.clock()
local s0, k0, f0 = os.clock(), heapKb(), frameNo()
local ok, res, detail = pcall(fn)
local ms = (os.clock() - s0) * 1000
local kb, frames = heapKb() - k0, frameNo() - f0
startup.current = nil
if ok and res ~= false then
record(name, res == "FALLBACK" and "FALLBACK" or "OK",
type(res) == "string" and res ~= "FALLBACK" and res or nil, ms, kb, frames)
pcall(logmod.flushNow)
return true, res
end
local failure = ok and detail or res
record(name, "FAILED", failure, ms, kb, frames)
pcall(logmod.flushNow)
if required then
startup.failedAt = name
startup.error = tostring(failure)
end
return false, failure
end
local STAGE_LIMIT = 75
task.spawn(function()
while BX.alive() and startup.state ~= "READY" and startup.state ~= "FAILED" do
task.wait(1)
local cur = startup.current
if cur and (os.clock() - (startup.currentAt or 0)) > STAGE_LIMIT then
failHub(cur, ("stage did not finish within %ds"):format(STAGE_LIMIT))
return
end
end
end)
setState("BOOTING")
if not stage("services", true, function()
BX.require("core.services")
end) then
failHub("services", startup.error)
return
end
stage("exec", false, function()
local exec = BX.require("core.exec")
startup.fragile = exec.fragile
startup.console = exec.fragile or not exec.can.files
if startup.console then print("[VOIDCXZ] fragile/no-file executor: startup stages are printed here") end
end)
stage("device", false, function() BX.require("core.device") end)
stage("state", false, function() BX.require("core.state") end)
stage("util", false, function() BX.require("core.util") end)
stage("character", false, function() BX.require("core.character") end)
timeline("CORE READY")
setState("LOADING")
stage("loading", false, function()
local real = BX.require("ui.splash")
if real then splash = real end
end)
splash.step("Loading modules...", 0.12)
stage("eggs", false, function()
local eggs = BX.require("features.eggs")
if not eggs.ready then return "FALLBACK" end
end)
setState("UI_BUILDING")
splash.step("Building interface...", 0.25)
local win
local okWin = stage("menu", true, function()
win = BX.require("ui.shell")
if not win.ok then return false, win.error or "window unavailable" end
end)
if not okWin or not win or not win.ok then
failHub("menu", (win and win.error) or startup.error or "unknown")
return
end
if not BX.alive() then return end
stage("hide menu", false, function()
if not win.hide() then return "FALLBACK" end
end)
local tabProgress = 0.40
local function breathe()
tabProgress = math.min(tabProgress + 0.05, 0.70)
splash.step(nil, tabProgress)
task.wait()
end
splash.step(nil, 0.40)
timeline("TAB BUILD START")
stage("home", false, function()
BX.require("ui.tabs.home").build(win.tab("Home"))
end)
breathe()
stage("main", false, function()
BX.require("ui.tabs.main").build(win.tab("Main"))
end)
breathe()
if BX._factories["ui.tabs.farm"] then
stage("farm", false, function()
BX.require("ui.tabs.farm").build(win.tab("Farm"))
end)
breathe()
end
stage("event", false, function()
BX.require("ui.tabs.event").build(win.tab("Event"))
end)
breathe()
stage("misc", false, function()
BX.require("ui.tabs.misc").build(win.tab("Misc"))
end)
breathe()
BX.onTeardown("ui", function()
BX.try("teardown.stats", function() BX.require("ui.stats").show(false) end)
BX.try("teardown.window", function() win.unload() end)
end)
BX.onTeardown("tabs", function()
for _, name in ipairs({ "ui.tabs.farm", "ui.tabs.event", "ui.tabs.misc" }) do
local mod = BX._loaded[name]
if mod and type(mod.teardown) == "function" then
BX.try("teardown." .. name, mod.teardown)
end
end
end)
timeline("CONFIG TAB START")
stage("config", false, function()
local prof = BX.require("core.profiles")
prof.setFlagSource(function()
local w = win.window
return (type(w) == "table" and type(w.controls) == "table"
and w.controls) or {}
end)
prof.setWindowGeometryHooks(function()
local w = win.window
return (type(w) == "table" and type(w.getGeometry) == "function")
and w:getGeometry() or nil
end, function(geometry)
local w = win.window
if type(w) == "table" and type(w.setGeometry) == "function" then
w:setGeometry(geometry)
end
end)
BX.require("ui.tabs.config").build(win.tab("Config"))
end)
breathe()
stage("last tab", false, function()
win.restoreLastTab()
end)
splash.step("Starting features...", 0.75)
timeline("FEATURE INIT START")
stage("webhook", false, function()
local hook = BX.require("features.misc.webhook")
BX.require("features.autosteal").onDelivered(function(e)
hook.onDelivered(e)
end)
local plot = BX.require("features.plot")
plot.onClaim(BX.scope("main.webhookClaims"), "webhook", function(name, info)
task.delay(0.18, function()
local egg
if type(info) == "table" then
local ok, record = BX.try("webhook.claimEgg", function()
local uid = info.UID or info.Uid or info.uid or info.Id or info.id
or info.EggUid or info.EggUID or info.FieldEggUid
return uid and BX.require("features.eggs").get(uid) or nil
end)
if ok then egg = record end
end
hook.onDelivered(egg or {
name = tostring(name or "Egg"),
value = type(info) == "table" and (info.Value or info.value
or info.Income or info.IncomePerSecond) or nil,
kg = type(info) == "table" and (info.Kg or info.kg
or info.Weight or info.WeightKg) or nil,
rarity = type(info) == "table" and (info.Rarity or info.rarity) or nil,
mutations = type(info) == "table" and (info.Mutations or info.mutations
or info.Mutation or info.mutation) or nil,
areaId = type(info) == "table" and (info.AreaId or info.areaId
or info.Area or info.area) or nil,
})
end)
end)
end)
stage("treadmill", false, function()
local cfg = BX.require("core.config")
local treadmill = BX.require("features.treadmill")
if cfg.DEFAULT_ANTI_TREADMILL then treadmill.arm() end
end)
stage("fps", false, function()
local cfg = BX.require("core.config")
if cfg.AUTO_FPS_BOOST then BX.require("features.fps").arm() end
end)
stage("catalog", false, function()
BX.require("features.catalog").start()
end)
stage("jump", false, function()
BX.require("features.jump").arm()
end)
stage("prewarm", false, function()
if startup.fragile then return "SKIPPED: fragile executor" end
BX.require("features.prewarm").start()
end)
timeline("FEATURE INIT END")
splash.step(nil, 0.90)
stage("stats", false, function()
if not BX.require("core.config").SHOW_STATS then return "SKIPPED: stats disabled" end
splash.whenClosed(function()
BX.try("startup.stats", function()
BX.require("ui.stats").show(true)
end)
end)
end)
stage("island", false, function()
splash.whenClosed(function()
BX.try("startup.island", function() BX.require("ui.island").start() end)
BX.try("startup.recap", function() BX.require("ui.recap").start() end)
end)
end)
timeline("CONFIG RESTORE START")
stage("autoload", false, function()
local prof = BX.require("core.profiles")
local ok, msg = prof.runAutoLoad()
BX.try("autoload.webhook", function()
BX.require("features.misc.webhook").finishProfileRestore()
local misc = BX._loaded["ui.tabs.misc"]
if misc and misc.syncWebhookState then misc.syncWebhookState() end
end)
BX.try("autoload.mobileFit", function()
local w = win.window
if w and w.fitForDevice then w:fitForDevice() end
end)
prof.startAutoSave()
if not ok then return "SKIPPED: " .. tostring(msg) end
end)
timeline("CONFIG RESTORE END")
if not BX.alive() or startup.state == "FAILED" then return end
splash.whenClosed(function()
BX.try("startup.reveal", function()
win.reveal()
timeline("RAYFIELD VISIBLE")
setState("READY")
startup.readyAt = os.clock() - startup.t0
log.info("ready in %.2fs (init %.2fs, loading screen %.2fs)",
startup.readyAt, startup.initAt or 0,
startup.readyAt - (startup.initAt or 0))
end)
end)
timeline("UI READY")
splash.done()
BX.profile.start()
BX.try("startup.sessionWatch", function()
local ssc = BX.scope("core.sessionwatch")
local GuiService = game:GetService("GuiService")
ssc:connect(GuiService.ErrorMessageChanged, function(msg)
if msg == nil or msg == "" then return end
local code = "?"
pcall(function() code = tostring(GuiService:GetErrorCode()) end)
log.error("ROBLOX ERROR PROMPT (code %s): %s", code, tostring(msg))
end)
local lp = game:GetService("Players").LocalPlayer
if lp then
ssc:connect(lp.OnTeleport, function(state, placeId)
log.error("client teleport %s (place %s)", tostring(state), tostring(placeId))
end)
end
end)
env.VoidcxzAudit = function()
local h = BX.profile.health()
print(("[VOIDCXZ] up %.0fs | mem %.0fMB (%+.0f since start) | %d modules")
:format(h.uptime, h.mem, h.memGrow, h.loaded))
print(("[VOIDCXZ] scopes=%d conns=%d insts=%d threads=%d")
:format(h.scopes, h.conns, h.insts, h.threads))
for _, line in ipairs(BX.scopeReport()) do print("[VOIDCXZ]   " .. line) end
for _, line in ipairs(BX.profile.watched()) do print("[VOIDCXZ]   " .. line) end
local rep = logmod.repeats()
if #rep > 0 then
print("[VOIDCXZ] repeated failures:")
for _, r in ipairs(rep) do print("[VOIDCXZ]   " .. r) end
end
return h
end
env.VoidcxzProfile = function()
for _, line in ipairs(BX.profile.report()) do print("[VOIDCXZ] " .. line) end
end
env.VoidcxzStages = function()
print(("[VOIDCXZ] startup: %s in %.2fs"):format(
startup.state, startup.readyAt or (os.clock() - startup.t0)))
print("[VOIDCXZ]   stage          result      cost      at")
for _, s in ipairs(startup.stages) do
print(("[VOIDCXZ]   %-14s %-9s %7.0fms %6.2fs%s"):format(
s.name, s.result, s.ms or 0, s.at,
s.detail and ("  " .. tostring(s.detail)) or ""))
end
if startup.initAt then
print(("[VOIDCXZ]   init %.2fs | loading screen %.2fs | total %.2fs"):format(
startup.initAt,
(startup.readyAt or startup.initAt) - startup.initAt,
startup.readyAt or startup.initAt))
end
end
startup.initAt = os.clock() - startup.t0
logmod.session(("startup complete - all work done in %.2fs"):format(startup.initAt))
local function diag()
local rep = BX.require("core.exec").report()
local lines = {
("executor = %s  (VoidcxzHub %s build %s, generation %d)")
:format(tostring(rep.executor), tostring(BX.version),
tostring(BX.build), BX.generation),
("capabilities = %s"):format(#rep.have > 0 and table.concat(rep.have, ",") or "(none)"),
("missing = %s"):format(#rep.missing > 0 and table.concat(rep.missing, ",") or "(none)"),
("prompt path = %s  |  game require = %s (%s)%s"):format(
tostring(rep.promptVia), tostring(BX.require("core.exec").can.gameRequire),
tostring(rep.gameRequireWhy),
#rep.denied > 0 and ("  |  SIMULATED DENIES = " .. table.concat(rep.denied, ",")) or ""),
}
local st, failed = {}, {}
for _, s in ipairs(startup.stages) do
st[#st + 1] = s.name .. ":" .. s.result
if s.result == "FAILED" or s.result == "FALLBACK" then
failed[#failed + 1] = s.name .. " = " .. tostring(s.detail or s.result)
end
end
lines[#lines + 1] = ("startup stage = %s  |  %s"):format(startup.state, table.concat(st, " "))
if #failed > 0 then
for _, f in ipairs(failed) do
local mod = tostring(f):match('module "([^"]+)" failed') or "-"
lines[#lines + 1] = ("module failed = %s  |  error = %s"):format(mod, f)
end
else
lines[#lines + 1] = "module failed = none"
end
for _, l in ipairs(lines) do
log.info("diag %s", l)
print("[VOIDCXZ diag] " .. l)
end
return lines
end
env.VoidcxzDiag = diag
BX.try("startup.diag", diag)
end
