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
name = "VoidcxzHub-custom-picture-logo.png",
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
local INVITE = "https://discord.gg/ePHR9Eb69"
local LOGO = BX.require("ui.logo").image()
local FAMILY = "rbxassetid://12187365364"
local SIZE_TITLE, SIZE_PRIMARY, SIZE_SMALL = 30, 14, 12
local WHITE = Color3.fromRGB(255, 255, 255)
local BLACK = Color3.fromRGB(0, 0, 0)
local PANEL = Color3.fromRGB(12, 12, 12)
local ELEMENT = Color3.fromRGB(22, 22, 24)
local LINE = Color3.fromRGB(40, 40, 46)
local TEXT = Color3.fromRGB(236, 236, 240)
local MUTED = Color3.fromRGB(120, 120, 128)
local TRACK = Color3.fromRGB(30, 30, 33)
local WARN = Color3.fromRGB(255, 140, 128)
local ok, errorMessage = pcall(function()
local createdAt = os.clock()
local parent = exec.hiddenParent()
local old = parent:FindFirstChild("VoidcxzSplash")
if old then old:Destroy() end
local EXPO = Enum.EasingStyle.Exponential
local tweenCount = 0
local function tween(object, info, properties)
local okTween, animation = pcall(svc.TweenService.Create, svc.TweenService, object, info, properties)
if not okTween then return nil end
tweenCount = tweenCount + 1
animation:Play()
return animation
end
local function ease(duration, style, direction, repeats, reverses, delay)
return TweenInfo.new(duration, style or EXPO, direction or Enum.EasingDirection.Out,
repeats or 0, reverses or false, delay or 0)
end
local function font(weight)
local okFont, face = pcall(Font.new, FAMILY, weight)
return okFont and face or Font.fromEnum(Enum.Font.GothamMedium)
end
local faders = {}
local function fade(object, properties)
local rest = {}
for property, value in pairs(properties) do
rest[property] = value
pcall(function() object[property] = 1 end)
end
faders[#faders + 1] = { object = object, rest = rest }
return object
end
local function playFade(info, hidden)
for _, entry in ipairs(faders) do
if entry.object.Parent then
local target = {}
for property, value in pairs(entry.rest) do
target[property] = hidden and 1 or value
end
tween(entry.object, info, target)
end
end
end
local function new(className, props, parentObject)
local object = Instance.new(className)
for key, value in pairs(props) do object[key] = value end
object.Parent = parentObject
return object
end
local function round(object, radius)
return new("UICorner", { CornerRadius = radius or UDim.new(0, 10) }, object)
end
local function shadow(object, color, blur, transparency)
local okShadow, instance = pcall(function()
return new("UIShadow", { Color = color, BlurRadius = UDim.new(0, blur), ZIndex = -1 }, object)
end)
if okShadow and instance then fade(instance, { Transparency = transparency }) end
return okShadow and instance or nil
end
local gui = new("ScreenGui", {
Name = "VoidcxzSplash", DisplayOrder = 999997, IgnoreGuiInset = true,
ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, parent)
local dim = new("Frame", {
Name = "Backdrop", Size = UDim2.fromScale(1, 1), BorderSizePixel = 0,
BackgroundColor3 = BLACK, BackgroundTransparency = 1,
}, gui)
new("UIGradient", {
Rotation = 90,
Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0),
NumberSequenceKeypoint.new(0.5, 0.35),
NumberSequenceKeypoint.new(1, 0),
}),
}, dim)
local holder = new("Frame", {
Name = "Holder", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(WIDTH, HEIGHT), BackgroundTransparency = 1,
}, gui)
local baseScale = 1
pcall(function()
local viewport = workspace.CurrentCamera.ViewportSize
baseScale = math.clamp(math.min((viewport.X - 32) / WIDTH, (viewport.Y - 32) / HEIGHT), 0.55, 1)
end)
local scale = new("UIScale", { Scale = baseScale * 0.92 }, holder)
local panel = fade(new("Frame", {
Name = "Panel", Size = UDim2.fromScale(1, 1), BorderSizePixel = 0, BackgroundColor3 = WHITE,
}, holder), { BackgroundTransparency = 0 })
round(panel, UDim.new(0, 18))
new("UIGradient", {
Rotation = 90,
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 27)),
ColorSequenceKeypoint.new(0.45, Color3.fromRGB(13, 13, 14)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 9, 10)),
}),
}, panel)
shadow(panel, BLACK, 60, 0.35)
local panelStroke = fade(new("UIStroke", {
Color = WHITE, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, panel), { Transparency = 0.35 })
new("UIGradient", {
Rotation = 90,
Color = ColorSequence.new(Color3.fromRGB(58, 58, 64), Color3.fromRGB(22, 22, 25)),
}, panelStroke)
local function text(name, props)
props.Name = name
props.BackgroundTransparency = 1
props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center
props.TextTruncate = props.TextTruncate or Enum.TextTruncate.AtEnd
props.ZIndex = props.ZIndex or 3
local parentObject = props.Parent or panel
props.Parent = nil
return fade(new("TextLabel", props, parentObject), { TextTransparency = 0 })
end
local chip = new("Frame", {
Name = "Welcome", Position = UDim2.fromOffset(4, 16), Size = UDim2.fromOffset(0, 44),
AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = ELEMENT, BorderSizePixel = 0, ZIndex = 3,
}, panel)
local okWelcome, welcomeError = pcall(function()
local player = game:GetService("Players").LocalPlayer
if not player then chip:Destroy() return end
fade(chip, { BackgroundTransparency = 0 })
round(chip, UDim.new(1, 0))
fade(new("UIStroke", { Color = LINE, Thickness = 1 }, chip), { Transparency = 0 })
new("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 16) }, chip)
new("UIListLayout", {
FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 10),
}, chip)
local avatar = fade(new("ImageLabel", {
Name = "Avatar", Size = UDim2.fromOffset(32, 32), LayoutOrder = 1,
BackgroundColor3 = Color3.fromRGB(34, 34, 38), BorderSizePixel = 0, ZIndex = 4,
Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=60&h=60"):format(player.UserId),
}, chip), { BackgroundTransparency = 0, ImageTransparency = 0 })
round(avatar, UDim.new(1, 0))
local lines = new("Frame", {
Name = "Lines", Size = UDim2.fromOffset(0, 34), AutomaticSize = Enum.AutomaticSize.X,
BackgroundTransparency = 1, LayoutOrder = 2, ZIndex = 4,
}, chip)
new("UIListLayout", {
FillDirection = Enum.FillDirection.Vertical, VerticalAlignment = Enum.VerticalAlignment.Center,
SortOrder = Enum.SortOrder.LayoutOrder,
}, lines)
text("Greeting", {
Parent = lines, Size = UDim2.fromOffset(0, 15), AutomaticSize = Enum.AutomaticSize.X,
FontFace = font(Enum.FontWeight.Regular), Text = "Welcome back,",
TextColor3 = MUTED, TextSize = SIZE_SMALL, TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.None, LayoutOrder = 1, ZIndex = 4,
})
local nameLabel = text("Name", {
Parent = lines, Size = UDim2.fromOffset(0, 18), AutomaticSize = Enum.AutomaticSize.X,
FontFace = font(Enum.FontWeight.SemiBold),
Text = (player.DisplayName ~= "" and player.DisplayName) or player.Name,
TextColor3 = WHITE, TextSize = SIZE_PRIMARY, TextXAlignment = Enum.TextXAlignment.Left,
LayoutOrder = 2, ZIndex = 4,
})
new("UISizeConstraint", { MaxSize = Vector2.new(190, 18) }, nameLabel)
end)
if not okWelcome then
log.error("welcome chip failed: %s", tostring(welcomeError))
pcall(function() chip:Destroy() end)
end
local emblem = new("Frame", {
Name = "Emblem", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 54),
Size = UDim2.fromOffset(92, 92), BackgroundTransparency = 1, ZIndex = 2,
}, panel)
local core = fade(new("Frame", {
Name = "Core", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(72, 72), BackgroundColor3 = ELEMENT, BorderSizePixel = 0, ZIndex = 2,
}, emblem), { BackgroundTransparency = 0 })
round(core, UDim.new(1, 0))
local glow = shadow(core, WHITE, 44, 0.9)
fade(new("UIStroke", { Color = LINE, Thickness = 1 }, core), { Transparency = 0 })
fade(new("ImageLabel", {
Name = "Logo", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(38, 38), BackgroundTransparency = 1, Image = LOGO,
ImageColor3 = WHITE, ScaleType = Enum.ScaleType.Fit, ZIndex = 3,
}, core), { ImageTransparency = 0 })
local ripple = new("Frame", {
Name = "Ripple", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(72, 72), BackgroundTransparency = 1, ZIndex = 1,
}, emblem)
round(ripple, UDim.new(1, 0))
local rippleStroke = new("UIStroke", { Color = WHITE, Thickness = 1.5, Transparency = 1 }, ripple)
local function ring(name, restTransparency)
local frame = new("Frame", {
Name = name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 2,
}, emblem)
round(frame, UDim.new(1, 0))
local stroke = fade(new("UIStroke", { Color = WHITE, Thickness = 1.5 }, frame),
{ Transparency = restTransparency })
return frame, stroke
end
local _, trackStroke = ring("RingTrack", 0.9)
local _, arcStroke = ring("RingArc", 0)
local arc = new("UIGradient", {
Transparency = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0),
NumberSequenceKeypoint.new(0.45, 1),
NumberSequenceKeypoint.new(1, 1),
}),
}, arcStroke)
local title = text("Title", {
Position = UDim2.fromOffset(PAD, 160), Size = UDim2.new(1, -PAD * 2, 0, 36),
FontFace = font(Enum.FontWeight.Bold), Text = "VoidcxzHub", TextColor3 = WHITE, TextSize = SIZE_TITLE,
})
local titleSheen = new("UIGradient", {
Offset = Vector2.new(-1, 0), Rotation = 20,
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(196, 196, 204)),
ColorSequenceKeypoint.new(0.42, Color3.fromRGB(196, 196, 204)),
ColorSequenceKeypoint.new(0.5, WHITE),
ColorSequenceKeypoint.new(0.58, Color3.fromRGB(196, 196, 204)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(196, 196, 204)),
}),
}, title)
text("Subtitle", {
Position = UDim2.fromOffset(PAD, 196), Size = UDim2.new(1, -PAD * 2, 0, 16),
FontFace = font(Enum.FontWeight.Medium), Text = string.upper(BX.game or "Steal An Egg"),
TextColor3 = MUTED, TextSize = SIZE_SMALL,
})
local PERCENT_WIDTH = 44 
local status = text("Status", {
Position = UDim2.fromOffset(PAD, 244), Size = UDim2.new(1, -PAD * 2 - PERCENT_WIDTH - 8, 0, 18),
FontFace = font(Enum.FontWeight.Medium), Text = "Starting…", TextColor3 = TEXT,
TextSize = SIZE_PRIMARY, TextXAlignment = Enum.TextXAlignment.Left,
})
local percent = text("Percentage", {
AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -PAD, 0, 245),
Size = UDim2.fromOffset(PERCENT_WIDTH, 18), FontFace = font(Enum.FontWeight.Medium),
Text = "0%", TextColor3 = MUTED, TextSize = SIZE_SMALL,
TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.None,
})
local track = fade(new("Frame", {
Name = "ProgressTrack", Position = UDim2.fromOffset(PAD, 272), Size = UDim2.new(1, -PAD * 2, 0, 3),
BackgroundColor3 = TRACK, BorderSizePixel = 0, ZIndex = 2,
}, panel), { BackgroundTransparency = 0 })
round(track, UDim.new(1, 0))
local fill = fade(new("Frame", {
Name = "ProgressFill", Size = UDim2.fromScale(0, 1), BackgroundColor3 = WHITE,
BorderSizePixel = 0, ZIndex = 3,
}, track), { BackgroundTransparency = 0 })
round(fill, UDim.new(1, 0))
local fillGlow = shadow(fill, WHITE, 10, 0.8)
local barSheen = new("UIGradient", {
Offset = Vector2.new(-1, 0),
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 188)),
ColorSequenceKeypoint.new(0.4, Color3.fromRGB(180, 180, 188)),
ColorSequenceKeypoint.new(0.5, WHITE),
ColorSequenceKeypoint.new(0.6, Color3.fromRGB(180, 180, 188)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 188)),
}),
}, fill)
local ACTION_Y, ACTION_H = 306, 40
local unlocked = false
local link = new("TextButton", {
Name = "Continue", Position = UDim2.fromOffset(PAD, ACTION_Y), Size = UDim2.fromOffset(80, ACTION_H),
BackgroundTransparency = 1, AutoButtonColor = false, Text = "", ZIndex = 3,
}, panel)
local linkLabel = text("Label", {
Parent = link, Size = UDim2.fromScale(1, 1),
FontFace = font(Enum.FontWeight.Medium), Text = "Continue  →", TextColor3 = MUTED,
TextSize = SIZE_PRIMARY, TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.None, ZIndex = 4,
})
local underlineTrack = fade(new("Frame", {
Name = "UnderlineTrack", AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 0.5, 12),
Size = UDim2.fromOffset(80, 1), BackgroundColor3 = MUTED, BorderSizePixel = 0,
ClipsDescendants = true, ZIndex = 4,
}, link), { BackgroundTransparency = 0.75 })
local function fitLink()
local width = math.ceil(linkLabel.TextBounds.X)
if width <= 0 then return end
link.Size = UDim2.fromOffset(width, ACTION_H)
underlineTrack.Size = UDim2.fromOffset(width, 1)
end
linkLabel:GetPropertyChangedSignal("TextBounds"):Connect(fitLink)
fitLink()
local meter = new("Frame", {
Name = "AutoContinue", Size = UDim2.fromScale(0, 1), BackgroundColor3 = TEXT,
BorderSizePixel = 0, ZIndex = 5,
}, underlineTrack)
local discordButton = new("TextButton", {
Name = "JoinDiscord", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -PAD, 0, ACTION_Y),
Size = UDim2.fromOffset(196, ACTION_H), BackgroundColor3 = WHITE, BorderSizePixel = 0,
AutoButtonColor = false, Text = "", ZIndex = 3,
}, panel)
fade(discordButton, { BackgroundTransparency = 0 })
round(discordButton, UDim.new(0, 10))
local discordGlow = shadow(discordButton, WHITE, 22, 0.88)
local discordLabel = text("Label", {
Parent = discordButton, Size = UDim2.fromScale(1, 1), ZIndex = 5,
FontFace = font(Enum.FontWeight.SemiBold), Text = "Join Discord  ↗", TextColor3 = PANEL,
TextSize = SIZE_PRIMARY,
})
local discordScale = new("UIScale", { Scale = 1 }, discordButton)
link.MouseEnter:Connect(function()
if unlocked then tween(linkLabel, ease(0.25), { TextColor3 = TEXT }) end
end)
link.MouseLeave:Connect(function()
tween(linkLabel, ease(0.3), { TextColor3 = MUTED })
end)
discordButton.MouseEnter:Connect(function()
if not unlocked then return end
tween(discordButton, ease(0.25), { BackgroundColor3 = Color3.fromRGB(230, 230, 236) })
if discordGlow then tween(discordGlow, ease(0.3), { Transparency = 0.7 }) end
end)
discordButton.MouseLeave:Connect(function()
tween(discordButton, ease(0.3), { BackgroundColor3 = WHITE })
tween(discordScale, ease(0.3), { Scale = 1 })
if discordGlow and unlocked then tween(discordGlow, ease(0.3), { Transparency = 0.82 }) end
end)
discordButton.MouseButton1Down:Connect(function()
if unlocked then tween(discordScale, ease(0.15), { Scale = 0.97 }) end
end)
discordButton.MouseButton1Up:Connect(function()
tween(discordScale, ease(0.3), { Scale = 1 })
end)
local function setLocked(locked, info)
link.Active = not locked
discordButton.Active = not locked
tween(linkLabel, info, { TextTransparency = locked and 0.6 or 0 })
tween(discordButton, info, { BackgroundTransparency = locked and 0.9 or 0 })
tween(discordLabel, info, { TextTransparency = locked and 0.6 or 0 })
if discordGlow then tween(discordGlow, info, { Transparency = locked and 1 or 0.82 }) end
end
local barValue = new("NumberValue", { Name = "ProgressValue", Value = 0 }, gui)
local closed, closing, drawn = false, false, false
local realProgress = 0
local closedCallbacks = {}
local fillTween, countdown
local BLUR_SIZE = 14
local blur, blurReason
local function startBlur()
local lite = false
pcall(function() lite = BX.require("core.device").lite() end)
if lite then blurReason = "device tier low" return end
pcall(function()
local level = UserSettings().GameSettings.SavedQualityLevel
if level ~= Enum.SavedQualitySetting.Automatic and level.Value <= 3 then
blurReason = "graphics quality " .. level.Value
end
end)
if blurReason then return end
local frames, started = 0, os.clock()
while frames < 12 and not closing do
svc.RunService.RenderStepped:Wait()
frames = frames + 1
end
local fps = frames / math.max(os.clock() - started, 1e-3)
if fps < 45 then blurReason = ("fps %.0f"):format(fps) return end
if closing or closed then return end
local camera = workspace.CurrentCamera
if not camera then return end
blur = new("BlurEffect", { Name = "VoidcxzSplashBlur", Size = 0 }, camera)
tween(blur, ease(0.6, Enum.EasingStyle.Quad), { Size = BLUR_SIZE })
blurReason = ("on (fps %.0f)"):format(fps)
end
local function startBlurLogged()
startBlur()
log.info("background blur: %s", tostring(blurReason or "skipped"))
end
local shownPercent = -1
barValue.Changed:Connect(function(value)
if not fill or not fill.Parent then return end
fill.Size = UDim2.fromScale(math.clamp(value, 0, 1), 1)
local whole = math.floor(math.clamp(value, 0, 1) * 100 + 0.5)
if whole ~= shownPercent then
shownPercent = whole
percent.Text = whole .. "%"
end
end)
local function animateProgress(value)
if not drawn or not barValue or value <= barValue.Value + 0.0005 then return end
if fillTween then fillTween:Cancel() end
fillTween = tween(barValue, ease(math.clamp(0.45 + (value - barValue.Value) * 1.2, 0.45, 1.1),
Enum.EasingStyle.Quart), { Value = value })
end
local function setText(object, value)
if object.Text == value then return end
object.Text = value
if drawn then
object.TextTransparency = 0.75
tween(object, ease(0.35), { TextTransparency = 0 })
end
end
local function cleanup()
if fillTween then fillTween:Cancel() end
if countdown then countdown:Cancel() end
if blur then blur:Destroy() blur = nil end
if gui then gui:Destroy() end
gui, fill, barValue = nil, nil, nil
end
local function notifyClosed()
for i = #closedCallbacks, 1, -1 do
pcall(closedCallbacks[i])
closedCallbacks[i] = nil
end
end
local function close()
if closing or closed then return end
closing = true
if countdown then countdown:Pause() end
timeline("SPLASH EXIT START")
notifyClosed()
playFade(ease(0.3, Enum.EasingStyle.Quad), true)
tween(meter, ease(0.3, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 })
if blur then tween(blur, ease(0.4, Enum.EasingStyle.Quad), { Size = 0 }) end
tween(dim, ease(0.4, Enum.EasingStyle.Quad), { BackgroundTransparency = 1 })
tween(scale, ease(0.4, EXPO, Enum.EasingDirection.InOut), { Scale = baseScale * 0.82 })
task.delay(0.42, function()
closed = true
cleanup()
timeline("SPLASH DESTROYED")
sc:destroy()
end)
end
local secondsLeft, paused, flashUntil = AUTO_CONTINUE, false, 0
local function readyText()
if paused then return "Ready — paused" end
return ("Ready — opening in %ds"):format(secondsLeft)
end
local function refreshReady()
if unlocked and not closing and os.clock() >= flashUntil then
status.Text = readyText()
end
end
local function flash(message)
flashUntil = os.clock() + 1.6
setText(status, message)
task.delay(1.65, refreshReady)
end
discordButton.Activated:Connect(function()
if not unlocked or closing then return end
local opened = pcall(function()
game:GetService("GuiService"):OpenBrowserWindow(INVITE)
end)
local copied = exec.clipboard(INVITE)
flash(copied and "Invite copied to your clipboard" or
(opened and "Opening Discord…" or "discord.gg/ePHR9Eb69"))
end)
link.Activated:Connect(function()
if unlocked then close() end
end)
local function setPaused(value)
if not countdown or closing or paused == value then return end
paused = value
if value then countdown:Pause() else countdown:Play() end
refreshReady()
end
for _, action in ipairs({ link, discordButton }) do
action.MouseEnter:Connect(function() setPaused(true) end)
action.MouseLeave:Connect(function() setPaused(false) end)
end
local function unlock()
if unlocked or closing or closed then return end
unlocked = true
setLocked(false, ease(0.5))
tween(arcStroke, ease(0.6), { Transparency = 1 })
tween(trackStroke, ease(0.6), { Transparency = 0.6 })
if glow then
tween(glow, ease(0.18, Enum.EasingStyle.Quad), { Transparency = 0.35 })
task.delay(0.2, function()
if glow.Parent then tween(glow, ease(1), { Transparency = 0.82 }) end
end)
end
rippleStroke.Transparency = 0.3
tween(rippleStroke, ease(0.7, Enum.EasingStyle.Quad), { Transparency = 1 })
tween(ripple, ease(0.7, Enum.EasingStyle.Quart), { Size = UDim2.fromOffset(128, 128) })
local progress = new("NumberValue", { Value = 0 }, gui)
progress.Changed:Connect(function(v)
if meter.Parent then meter.Size = UDim2.fromScale(v, 1) end
local left = math.max(1, math.ceil(AUTO_CONTINUE * (1 - v) - 1e-3))
if left ~= secondsLeft then
secondsLeft = left
refreshReady()
end
end)
countdown = svc.TweenService:Create(progress,
TweenInfo.new(AUTO_CONTINUE, Enum.EasingStyle.Linear), { Value = 1 })
tweenCount = tweenCount + 1
countdown.Completed:Connect(function(state)
if state == Enum.PlaybackState.Completed then close() end
end)
paused = false
countdown:Play()
setText(status, readyText())
end
sc:spawn("entrance", function()
svc.RunService.RenderStepped:Wait()
if closing or closed then return end
drawn = true
tween(dim, ease(0.5, Enum.EasingStyle.Quad), { BackgroundTransparency = 0.3 })
tween(scale, ease(0.8), { Scale = baseScale })
playFade(ease(0.6), false)
setLocked(true, ease(0.6))
if chip.Parent then
tween(chip, ease(0.9, EXPO, Enum.EasingDirection.Out, 0, false, 0.15),
{ Position = UDim2.fromOffset(16, 16) })
end
task.spawn(startBlurLogged)
tween(arc, ease(1.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 360 })
if glow then
tween(glow, ease(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Transparency = 0.7 })
end
tween(barSheen, ease(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), { Offset = Vector2.new(1, 0) })
tween(titleSheen, ease(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false, 1.2),
{ Offset = Vector2.new(1, 0) })
animateProgress(realProgress)
end)
local function tidy(value)
return (tostring(value):gsub("%.%.%.$", "…"))
end
function M.step(textValue, value)
if closed or closing or unlocked then return end
if textValue ~= nil then setText(status, tidy(textValue)) end
local nextProgress = math.clamp(tonumber(value) or realProgress, 0, 1)
if nextProgress <= realProgress then return end
realProgress = nextProgress
animateProgress(realProgress)
end
function M.fail(message)
if closed or closing then return end
status.TextColor3 = WARN
fill.BackgroundColor3 = WARN
arcStroke.Color = WARN
if fillGlow then fillGlow.Color = WARN end
setText(status, tidy(message or "Startup failed"))
M.step(nil, 1)
task.delay(2, close)
end
function M.whenClosed(fn)
if type(fn) ~= "function" then return end
if closed then pcall(fn) else closedCallbacks[#closedCallbacks + 1] = fn end
end
function M.done()
if closed or closing or unlocked then return end
status.TextColor3 = TEXT
M.step(nil, 1)
task.spawn(function()
while not drawn and not closing and not closed do task.wait() end
if fillTween and fillTween.PlaybackState == Enum.PlaybackState.Playing then
fillTween.Completed:Wait()
end
if closed or closing then return end
unlock()
end)
end
function M.stats()
return { tweensMade = tweenCount, instancesTotal = #faders, gate = "auto_continue", blur = blurReason }
end
function M.geometry()
if closed or not panel or not panel.Parent then return nil end
local g = { }
local ok = pcall(function()
g.panel = { pos = panel.AbsolutePosition, size = panel.AbsoluteSize }
if core and core.Parent then
g.logo = { pos = core.AbsolutePosition, size = core.AbsoluteSize }
end
end)
return ok and g.panel and g or nil
end
BX.onTeardown("ui.splash", function()
if not closed then
notifyClosed()
cleanup()
end
end)
M.step("Starting…", 0.10)
timeline("SPLASH CREATED")
log.info("created loading card in %.0fms", (os.clock() - createdAt) * 1000)
end)
if not ok then log.error("construction failed: %s", tostring(errorMessage)) end
return M
end)
BX.module("ui.stats", function(BX)
local svc = BX.require("core.services")
local cfg = BX.require("core.config")
local st  = BX.require("core.state")
local exec = BX.require("core.exec")
local logo = BX.require("ui.logo")
local log = BX.require("boot.log").for_module("stats")
local M = {}
local Stats, RunService = svc.Stats, svc.RunService
local UIS, TS, HS       = svc.UserInputService, svc.TweenService, svc.HttpService
local TextService       = svc.TextService
local T = nil
pcall(function()
if BX._factories and BX._factories["ui.lib.theme"] then
T = BX.require("ui.lib.theme")
end
end)
local function themed(key, fallback)
local v = T and T[key]
if v ~= nil then return v end
return fallback
end
local BG_TOP  = themed("PANEL", Color3.fromRGB(24, 24, 27))
local BG_BOT  = Color3.fromRGB(24, 14, 42)
local ELEMENT = themed("LINE", Color3.fromRGB(40, 40, 46))
local ACCENT  = themed("ACCENT", Color3.fromRGB(124, 77, 255))
local ICON    = themed("MUTED", Color3.fromRGB(120, 120, 128))
local TEXT    = themed("TEXT", Color3.fromRGB(236, 236, 240))
local MUTED   = themed("MUTED", Color3.fromRGB(120, 120, 128))
local WARN    = Color3.fromRGB(240, 190, 90)
local BAD     = Color3.fromRGB(240, 110, 110)
local FAMILY = "rbxassetid://12187365364"
local FONT, TEXT_SIZE, UNIT_SIZE = Enum.Font.GothamMedium, 14, 12
local function face(weight)
local ok, f = pcall(Font.new, FAMILY, weight)
return ok and f or Font.fromEnum(FONT)
end
local STROKE_T = 0.35
local POS_FILE = "VoidcxzHub_stats_pos.json"   
local NUM_EASE_K = 12     
local TONE_FADE  = 0.45   
local FPS_ALPHA  = 0.28   
local PING_ALPHA = 0.30
local BANDS = {
fps  = { dir = -1,
warn = { enter = 50,  exit = 54  },
bad  = { enter = 25,  exit = 29  } },
ping = { dir = 1,
warn = { enter = 150, exit = 132 },
bad  = { enter = 250, exit = 220 } },
}
local SPIKE_FACTOR  = 2.5   
local SPIKE_FLOOR   = 120   
local SPIKE_CONFIRM = 2     
local STALE_AFTER = 6       
local BLANK = "--"
local ICON_ROOT = "VoidcxzHub/icons"
local ICON_DIR  = ICON_ROOT .. "/v1"
local ICON_BASE = "https://raw.githubusercontent.com/google/material-design-icons/3.0.1/"
local ICON_SRC  = {
clock = "action/2x_web/ic_schedule_white_48dp.png",
pulse = "editor/2x_web/ic_show_chart_white_48dp.png",
wifi  = "notification/2x_web/ic_wifi_white_48dp.png",
}
local iconAsset = {}   
local iconTone  = {}   
local iconsAsked = false   
local sessionT0 = os.clock()
local gui, pill, scaler, stroke, brandFrame
local launcher, launcherTitle, launcherSub
local chevron, chevronGlyph   
local sc   
local bars, labels, fadeList, iconBoxes = {}, {}, {}, {}
local momentRow, momentDot, momentTitle, momentSub, momentBar
local momentNodes = {}
local momentTrack = nil
local momentActive, momentToken, momentSignature, momentWidth, momentProgress = false, 0, nil, nil, nil
local momentMeasurePending, momentLastTitle, momentLastSub = false, nil, nil
local applyCompact
local cellFrames = {}          
local tip, tipLabel, tipStroke, tipScale 
local hovering = false
local frames, shownFps = 0, nil
local fpsLevel, pingLevel = 0, 0
local pingEma, pingSuspect, pingSeenAt = nil, 0, nil
local hoverKind, hoverUntil = nil, 0
local target, moving, dragging = nil, false, false
local docked = false
local windowOpen = false
function M.setDock(_) docked = false end
function M.isDocked() return false end
function M.setWindowOpen(_)
windowOpen = false
if pill and pill.Parent then pill.Visible = true end
end
local function positionLauncher()
if not launcher or not launcher.Parent or not pill or not pill.Parent then return end
local ok = pcall(function()
local vp = workspace.CurrentCamera.ViewportSize
local a, sz = pill.AbsolutePosition, pill.AbsoluteSize
launcher.Position = UDim2.fromScale(
(a.X + sz.X / 2) / vp.X,
(a.Y + sz.Y + 10) / vp.Y)
end)
if not ok then launcher.Visible = false end
end
local grabInput, grabStart, grabPos
local baseScale, closing = 1, false
local function mk(class, props, parent)
local o = Instance.new(class)
for k, v in pairs(props) do o[k] = v end
o.Parent = parent
return o
end
local function tw(o, t, props, style)
BX.try("stats.tween", function()
TS:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quint,
Enum.EasingDirection.Out), props):Play()
end)
end
local function line(parent, x1, y1, x2, y2)
local dx, dy = x2 - x1, y2 - y1
mk("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2),
Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) + 1, 1.5),
Rotation = math.deg(math.atan2(dy, dx)),
BackgroundColor3 = ICON, BorderSizePixel = 0,
}, parent)
end
local function drawIcon(box, kind)
if kind == "clock" then
local ring = mk("Frame", {
Position = UDim2.fromOffset(2, 2), Size = UDim2.fromOffset(12, 12),
BackgroundTransparency = 1,
}, box)
mk("UICorner", { CornerRadius = UDim.new(1, 0) }, ring)
mk("UIStroke", { Color = ICON, Thickness = 1.5 }, ring)
line(box, 8, 8, 8, 5)
line(box, 8, 8, 10.5, 8)
elseif kind == "pulse" then
local p = { {1, 9}, {4.5, 9}, {6.5, 4}, {9.5, 13}, {11.5, 9}, {15, 9} }
for i = 1, #p - 1 do line(box, p[i][1], p[i][2], p[i + 1][1], p[i + 1][2]) end
else
bars = {}
for i = 1, 3 do
local h = 2 + i * 3.5
bars[i] = mk("Frame", {
Position = UDim2.fromOffset(2 + (i - 1) * 4.5, 14 - h),
Size = UDim2.fromOffset(3, h),
BackgroundColor3 = ICON, BorderSizePixel = 0,
}, box)
mk("UICorner", { CornerRadius = UDim.new(0, 1) }, bars[i])
end
end
end
local function validPng(data)
if type(data) ~= "string" or #data < 200 then return false end
if data:sub(2, 4) ~= "PNG" then return false end
local function be32(at)
local a, b, c, d = data:byte(at, at + 3)
if not d then return 0 end
return ((a * 256 + b) * 256 + c) * 256 + d
end
local w, h = be32(17), be32(21)
return w >= 16 and w <= 512 and h >= 16 and h <= 512
end
local function fillIcon(box, kind)
for _, c in ipairs(box:GetChildren()) do c:Destroy() end
if kind == "wifi" then bars = {} end   
if iconAsset[kind] then
mk("ImageLabel", {
Name = "Img", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
Image = iconAsset[kind], ImageColor3 = iconTone[kind] or ICON,
ScaleType = Enum.ScaleType.Fit,
}, box)
else
drawIcon(box, kind)
end
end
function M.fetchIcon(kind, src, cb)
if not (exec.can.customAsset and exec.can.files) or exec.fragile then return false end
if iconAsset[kind] then
task.spawn(cb, iconAsset[kind])
return true
end
task.spawn(function()
local ok = BX.try("stats.icon." .. kind, function()
exec.ensureFolder(ICON_DIR)
local path = ICON_DIR .. "/" .. kind .. ".png"
local have = exec.isFile(path) and validPng(exec.readFile(path))
if not have then
local png = game:HttpGet(ICON_BASE .. src)
assert(validPng(png), "not a usable png")
assert(exec.writeFile(path, png), "writefile refused")
end
iconAsset[kind] = assert(exec.customAsset(path), "no custom asset")
end)
if ok and iconAsset[kind] then BX.try("stats.icon.cb." .. kind, cb, iconAsset[kind]) end
end)
return true
end
local function icon(parent, kind)
local box = mk("Frame", { Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1 }, parent)
iconBoxes[kind] = box
fillIcon(box, kind)
return box
end
local function cell(parent, order, kind, widest, unit)
local c = mk("Frame", {
Name = kind, LayoutOrder = order, AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.fromOffset(0, 18), BackgroundTransparency = 1,
}, parent)
mk("UIListLayout", {
FillDirection = Enum.FillDirection.Horizontal,
VerticalAlignment = Enum.VerticalAlignment.Center,
Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder,
}, c)
icon(c, kind).LayoutOrder = 1
cellFrames[kind] = c
local w = 0
BX.try("stats.measure", function()
w = TextService:GetTextSize(widest, TEXT_SIZE, FONT, Vector2.new(1000, 100)).X
end)
local value = mk("TextLabel", {
LayoutOrder = 2, AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.fromOffset(math.ceil(w), 18), BackgroundTransparency = 1,
FontFace = face(Enum.FontWeight.SemiBold), TextSize = TEXT_SIZE, TextColor3 = TEXT,
TextXAlignment = unit and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left,
Text = BLANK,
}, c)
if unit then
mk("TextLabel", {
Name = "Unit", LayoutOrder = 3, AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.fromOffset(0, 18), BackgroundTransparency = 1,
FontFace = face(Enum.FontWeight.Medium), TextSize = UNIT_SIZE, TextColor3 = MUTED,
Text = unit,
}, c)
end
return value
end
local function divider(parent, order, name)
local gap = mk("Frame", {
Name = name or "Divider", LayoutOrder = order, Size = UDim2.fromOffset(12, 14),
BackgroundTransparency = 1, ClipsDescendants = true,
}, parent)
mk("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(1, 14), BackgroundColor3 = ACCENT, BackgroundTransparency = 0.85,
BorderSizePixel = 0,
}, gap)
return gap
end
local TextService = game:GetService("TextService")
local MOMENT_IN, MOMENT_OUT, MOMENT_XFADE = 0.36, 0.30, 0.12
local momentStatsWidth = nil     
local momentWasVisible = {}      
local function measure(label, text)
local ok, size = pcall(function()
return TextService:GetTextSize(text, label.TextSize, Enum.Font.Gotham,
Vector2.new(1000, 40))
end)
if ok and size then return size.X end
return #text * label.TextSize * 0.55
end
local GHOST = {
TextLabel = "TextTransparency", ImageLabel = "ImageTransparency",
Frame = "BackgroundTransparency", TextButton = "BackgroundTransparency",
UIStroke = "Transparency",
}
local function ghostNodes(on, t)
for _, node in ipairs(momentNodes) do
local list = node:GetDescendants()
list[#list + 1] = node
for _, d in ipairs(list) do
local prop = GHOST[d.ClassName]
if prop then
local rest = d:GetAttribute("ghostRest")
if rest == nil and d[prop] < 1 then rest = d[prop] d:SetAttribute("ghostRest", rest) end
if rest and rest < 1 then
if t and t > 0 then tw(d, t, { [prop] = on and rest or 1 })
else d[prop] = on and rest or 1 end
end
end
end
end
end
local function rowWidthOfStats()
if not pill or not pill.Parent then return 200 end
local k = (scaler and scaler.Scale) or baseScale
local w = pill.AbsoluteSize.X / (k > 0.01 and k or 1)
return math.max(120, w - 28)     
end
local function layoutProgress(width, progress, animate)
local trackWidth = math.max(0, width - 48)
if momentTrack then momentTrack.Size = UDim2.fromOffset(trackWidth, 3) end
local target = UDim2.fromOffset(trackWidth * progress, 3)
if animate then tw(momentBar, 0.25, { Size = target })
else momentBar.Size = target end
end
local function setMoment(spec)
if not pill or not pill.Parent or closing then return false end
if not spec then
if not momentActive then return true end
momentToken += 1
local token = momentToken
momentActive = false
momentSignature, momentWidth, momentProgress = nil, nil, nil
momentMeasurePending, momentLastTitle, momentLastSub = false, nil, nil
tw(momentSub, MOMENT_XFADE, { TextTransparency = 1 })
tw(momentTitle, MOMENT_XFADE, { TextTransparency = 1 })
tw(momentDot, MOMENT_XFADE, { BackgroundTransparency = 1 })
tw(momentBar, MOMENT_XFADE, { BackgroundTransparency = 1 })
if momentTrack then tw(momentTrack, MOMENT_XFADE, { BackgroundTransparency = 1 }) end
local back = momentStatsWidth or rowWidthOfStats()
tw(momentRow, MOMENT_OUT, { Size = UDim2.fromOffset(back, 24) })
task.delay(MOMENT_OUT, function()
if token ~= momentToken or not pill or not pill.Parent then return end
for _, node in ipairs(momentNodes) do
local was = momentWasVisible[node]
node.Visible = was == nil and true or was
end
momentRow.Visible = false
M.bump(0.025)
task.delay(0.05, function()
if token ~= momentToken or not pill or not pill.Parent then return end
ghostNodes(true, MOMENT_XFADE + 0.06)
end)
if compact then applyCompact(false) end
end)
return true
end
local titleText, subText = tostring(spec.title or ""), tostring(spec.sub or "")
local signature = table.concat({ titleText, subText, tostring(spec.tone or "normal") }, "\0")
local entering = not momentActive
if entering then momentToken += 1 end
local token = momentToken
local titleChanged, subChanged = momentTitle.Text ~= titleText, momentSub.Text ~= subText
momentActive, momentSignature = true, signature
local tw_ = measure(momentTitle, titleText)
local sw_ = subText ~= "" and measure(momentSub, subText) or 0
local maxWidth = math.clamp(tonumber(spec.maxWidth) or 360, 170, 360)
local width = math.clamp(tw_ + sw_ + 66, 170, maxWidth)
if entering then
momentStatsWidth = rowWidthOfStats()
ghostNodes(false, MOMENT_XFADE)
momentTitle.TextTransparency, momentSub.TextTransparency = 1, 1
momentDot.BackgroundTransparency = 1
momentBar.BackgroundTransparency, momentBar.Size = 1, UDim2.fromOffset(0, 3)
if momentTrack then momentTrack.BackgroundTransparency = 1 end
momentRow.Size = UDim2.fromOffset(momentStatsWidth, 24)
task.delay(MOMENT_XFADE * 0.5, function()
if token ~= momentToken then return end
for _, node in ipairs(momentNodes) do
momentWasVisible[node] = node.Visible
node.Visible = false
end
momentRow.Size = UDim2.fromOffset(momentStatsWidth, 24)
momentRow.Visible = true
tw(momentRow, MOMENT_IN, { Size = UDim2.fromOffset(width, 24) })
M.bump(0.03)
task.delay(0.08, function()
if token ~= momentToken then return end
tw(momentDot, MOMENT_XFADE, { BackgroundTransparency = 0 })
tw(momentTitle, 0.16, { TextTransparency = 0 })
end)
task.delay(0.14, function()
if token ~= momentToken then return end
tw(momentSub, 0.16, { TextTransparency = 0 })
if momentProgress ~= nil then
tw(momentBar, 0.16, { BackgroundTransparency = 0 })
if momentTrack then tw(momentTrack, 0.16, { BackgroundTransparency = 0.82 }) end
end
end)
end)
elseif not momentWidth or math.abs(momentWidth - width) > 12 then
tw(momentRow, 0.2, { Size = UDim2.fromOffset(width, 24) })
end
momentWidth = width
if titleChanged and not entering then
tw(momentTitle, 0.08, { TextTransparency = 1 })
task.delay(0.09, function()
if token ~= momentToken then return end
momentTitle.Text = titleText
tw(momentTitle, 0.14, { TextTransparency = 0 })
end)
else
momentTitle.Text = titleText
end
local liveProgressText = type(spec.progress) == "number"
and titleText == momentTitle.Text
if subChanged and not entering and liveProgressText then
momentSub.Text = subText
elseif subChanged and not entering then
tw(momentSub, 0.08, { TextTransparency = 1 })
task.delay(0.09, function()
if token ~= momentToken then return end
momentSub.Text = subText
tw(momentSub, 0.14, { TextTransparency = 0 })
end)
else
momentSub.Text = subText
end
momentSub.Position = UDim2.fromOffset(tw_ + 30, 1)
momentDot.BackgroundColor3 = spec.tone == "warn" and WARN
or spec.tone == "bad" and BAD or TEXT
local progress = type(spec.progress) == "number" and math.clamp(spec.progress, 0, 1) or nil
local hadProgress = momentProgress ~= nil
momentProgress = progress
momentBar.Visible = progress ~= nil
if momentTrack then momentTrack.Visible = progress ~= nil end
if progress ~= nil then
layoutProgress(width, progress, hadProgress)
if not hadProgress and not entering then
momentBar.BackgroundTransparency = 1
tw(momentBar, 0.16, { BackgroundTransparency = 0 })
if momentTrack then
momentTrack.BackgroundTransparency = 1
tw(momentTrack, 0.16, { BackgroundTransparency = 0.82 })
end
end
end
momentLastTitle, momentLastSub = titleText, subText
return true
end
local function clock(s)
s = math.floor(s)
local h, m = math.floor(s / 3600), math.floor(s / 60) % 60
if h > 0 then return ("%d:%02d:%02d"):format(h, m, s % 60) end
return ("%02d:%02d"):format(m, s % 60)
end
local function readPing()
local ok, v = pcall(function()
return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
end)
if ok and type(v) == "number" and v > 0 then return v end
ok, v = pcall(function() return svc.LocalPlayer:GetNetworkPing() * 1000 end)
return (ok and type(v) == "number") and v or nil
end
local function paint(obj, prop, color)
if obj and obj[prop] ~= color then tw(obj, TONE_FADE, { [prop] = color }) end
end
local function ema(prev, value, alpha)
if prev == nil then return value end
return prev + (value - prev) * alpha
end
local LEVEL_COLOR = { [0] = TEXT, [1] = WARN, [2] = BAD }
local function grade(band, v, cur)
cur = cur or 0
local function worseThan(x)
if band.dir < 0 then return v <= x else return v >= x end
end
local function betterThan(x)
if band.dir < 0 then return v >= x else return v <= x end
end
if cur >= 2 then
if not betterThan(band.bad.exit) then return 2 end
return betterThan(band.warn.exit) and 0 or 1
elseif cur == 1 then
if worseThan(band.bad.enter) then return 2 end
return betterThan(band.warn.exit) and 0 or 1
else
if worseThan(band.bad.enter) then return 2 end
return worseThan(band.warn.enter) and 1 or 0
end
end
local QUALITY = {
fps  = { [0] = "Smooth",    [1] = "Fair", [2] = "Poor" },
ping = { [0] = "Excellent", [1] = "Good", [2] = "Poor" },
}
local function tintIcon(kind, color)
if iconTone[kind] == color then return end
iconTone[kind] = color
local box = iconBoxes[kind]
if not box or not box.Parent then return end
for _, d in ipairs(box:GetDescendants()) do
if d:IsA("ImageLabel") then
paint(d, "ImageColor3", color)
elseif d:IsA("UIStroke") then
paint(d, "Color", color)
elseif d:IsA("Frame") and d.BackgroundTransparency < 1 then
paint(d, "BackgroundColor3", color)
end
end
end
local NUM = {
{ key = "fps",  fmt = "%d" },   
{ key = "ping", fmt = "%d" },
}
local function entry(key)
for i = 1, #NUM do
if NUM[i].key == key then return NUM[i] end
end
end
local function setTarget(key, value)
local e = entry(key)
if not e then return end
e.target = value
if e.shown == nil then e.shown = value end
end
local function setUnavailable(key)
local e = entry(key)
if not e or e.target == nil then return end
e.shown, e.target, e.lastWhole = nil, nil, nil
local label = labels[key]
if label and label.Text ~= BLANK then label.Text = BLANK end
end
local function easeNumbers(dt)
local k = 1 - math.exp(-dt * NUM_EASE_K)
for i = 1, #NUM do
local e = NUM[i]
local label = labels[e.key]
if e.target and label then
local diff = e.target - e.shown
if diff < 0.01 and diff > -0.01 then
e.shown = e.target
else
e.shown += diff * k
end
local whole = math.floor(e.shown + 0.5)
if whole ~= e.lastWhole then
e.lastWhole = whole
label.Text = e.fmt:format(whole)
end
end
end
end
local function resetNumbers()
for i = 1, #NUM do
local e = NUM[i]
e.shown, e.target, e.lastWhole = nil, nil, nil
end
end
local DETAIL_HOLD = 2.5   
local function detailFor(kind)
if kind == "clock" then
return "Session time"
end
local key = (kind == "pulse") and "fps" or "ping"
local e = entry(key)
if not e or not e.target then
return (key == "fps" and "FPS" or "Ping") .. "  \u{B7}  no reading"
end
local level = (key == "fps") and fpsLevel or pingLevel
local word  = QUALITY[key][level]
if key == "fps" then
return ("%d FPS  \u{B7}  %s"):format(math.floor(e.target + 0.5), word)
end
return ("%d ms  \u{B7}  %s"):format(math.floor(e.target + 0.5), word)
end
local function hideTip()
hoverKind, hoverUntil = nil, 0
if not tip then return end
tw(tip, 0.18, { BackgroundTransparency = 1 })
tw(tipLabel, 0.18, { TextTransparency = 1 })
if tipStroke then tw(tipStroke, 0.18, { Transparency = 1 }) end
end
local function placeTip()
if not tip or not pill or not hoverKind then return end
local cellF = cellFrames[hoverKind]
local cx = cellF and cellF.Parent
and (cellF.AbsolutePosition.X + cellF.AbsoluteSize.X / 2)
or (pill.AbsolutePosition.X + pill.AbsoluteSize.X / 2)
local halfW = tip.AbsoluteSize.X / 2
local vpX = gui.AbsoluteSize.X
cx = math.clamp(cx, halfW + 6, math.max(vpX - halfW - 6, halfW + 6))
local origin = gui.AbsolutePosition
tip.Position = UDim2.fromOffset(cx - origin.X, pill.AbsolutePosition.Y + pill.AbsoluteSize.Y + 6 - origin.Y)
end
local function showTip(kind)
if not tip or not pill or hoverKind == kind then return end
hoverKind = kind
tipLabel.Text = detailFor(kind)
placeTip()
tw(tip, 0.16, { BackgroundTransparency = 0.08 })
tw(tipLabel, 0.16, { TextTransparency = 0 })
if tipStroke then tw(tipStroke, 0.16, { Transparency = 0.55 }) end
end
local function kindAtX(x)
for kind, f in pairs(cellFrames) do
if f.Parent then
local left = f.AbsolutePosition.X
if x >= left and x <= left + f.AbsoluteSize.X then return kind end
end
end
return nil
end
local function pickScale()
local vp = gui and gui.AbsoluteSize or Vector2.new(1000, 1000)
local touch = UIS.TouchEnabled and not UIS.KeyboardEnabled
if not touch then return 1.2 end
local short = math.min(vp.X, vp.Y)
if short < 10 then return 0.85 end
return math.clamp(short / 620, 0.78, 1.25)
end
local function defaultPos()
local vy = gui and gui.AbsoluteSize.Y or 0
return UDim2.fromScale(0.5, vy > 0 and (8 / vy) or 0.01)
end
local function clampPos(p)
local vp, sz = gui.AbsoluteSize, pill.AbsoluteSize
if vp.X < 1 or vp.Y < 1 then return p end
local hx, hy = (sz.X / 2 + 4) / vp.X, (sz.Y + 4) / vp.Y
local top = 4 / vp.Y
return UDim2.fromScale(
math.clamp(p.X.Scale, math.min(hx, 0.5), math.max(1 - hx, 0.5)),
math.clamp(p.Y.Scale, top, math.max(1 - hy, top)))
end
local function readPrefs()
local raw = exec.readFile(POS_FILE)
if not raw then return {} end
local ok, t = pcall(function() return HS:JSONDecode(raw) end)
return (ok and type(t) == "table") and t or {}
end
local function writePrefs(change)
BX.try("stats.savePrefs", function()
local t = readPrefs()
for k, v in pairs(change) do t[k] = v end
exec.writeFile(POS_FILE, HS:JSONEncode(t))
end)
end
local function loadPos()
local t = readPrefs()
if tonumber(t.x) and tonumber(t.y) then
return UDim2.fromScale(tonumber(t.x), tonumber(t.y))
end
return nil
end
local function savePos(p)
if not p then return end
writePrefs({ x = p.X.Scale, y = p.Y.Scale })
end
local function moveTo(p)
target = clampPos(p)
moving = true
end
local function dragTo(at)
if not gui or not grabStart then return end
local vp = gui.AbsoluteSize
if vp.X < 1 or vp.Y < 1 then return end
local dx, dy = at.X - grabStart.X, at.Y - grabStart.Y
moveTo(UDim2.fromScale(grabPos.X.Scale + dx / vp.X, grabPos.Y.Scale + dy / vp.Y))
end
local function release()
if not dragging then return end
dragging, grabInput = false, nil
if scaler then tw(scaler, 0.25, { Scale = baseScale }, Enum.EasingStyle.Back) end
if stroke then tw(stroke, 0.3, { Transparency = STROKE_T }) end
savePos(target)
end
local function collectFade()
fadeList = {}
if not pill then return end
local function add(o, prop) fadeList[#fadeList + 1] = { o, prop, o[prop] } end
add(pill, "BackgroundTransparency")
add(stroke, "Transparency")
for _, d in ipairs(pill:GetDescendants()) do
if d:IsA("TextLabel") then
add(d, "TextTransparency")
elseif d:IsA("ImageLabel") then
add(d, "ImageTransparency")
elseif d:IsA("UIStroke") or d:IsA("UIShadow") then
add(d, "Transparency")
elseif d:IsA("Frame") and d.BackgroundTransparency < 1 then
add(d, "BackgroundTransparency")
end
end
end
local compact = readPrefs().compact == true
local COMPACT_T = 0.4
local collapsible = {}   
local function contentsOf(frame)
local list = {}
for _, d in ipairs(frame:GetDescendants()) do
if d:IsA("TextLabel") then list[#list + 1] = { d, "TextTransparency" }
elseif d:IsA("ImageLabel") then list[#list + 1] = { d, "ImageTransparency" }
elseif d:IsA("UIStroke") then list[#list + 1] = { d, "Transparency" }
elseif d:IsA("Frame") and d.BackgroundTransparency < 1 then list[#list + 1] = { d, "BackgroundTransparency" } end
end
return list
end
local function restingValue(obj, prop)
for _, f in ipairs(fadeList) do
if f[1] == obj and f[2] == prop then return f[3] end
end
return 0
end
applyCompact = function(animate)
for _, part in ipairs(collapsible) do
local frame = part.frame
if frame.Parent then
local t = animate and COMPACT_T or 0
local info = TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
if compact then
local s = scaler and scaler.Scale or baseScale
if frame.AbsoluteSize.X > 0 then part.width = frame.AbsoluteSize.X / math.max(s, 0.01) end
frame.AutomaticSize = Enum.AutomaticSize.None
frame.ClipsDescendants = true
frame.Size = UDim2.fromOffset(part.width or 0, frame.Size.Y.Offset)
for _, c in ipairs(contentsOf(frame)) do
if t > 0 then tw(c[1], t * 0.6, { [c[2]] = 1 }) else c[1][c[2]] = 1 end
end
if t > 0 then
TS:Create(frame, info, { Size = UDim2.fromOffset(0, frame.Size.Y.Offset) }):Play()
else
frame.Size = UDim2.fromOffset(0, frame.Size.Y.Offset)
end
else
local width = part.width or 60
for _, c in ipairs(contentsOf(frame)) do
local rest = restingValue(c[1], c[2])
if t > 0 then tw(c[1], t, { [c[2]] = rest }) else c[1][c[2]] = rest end
end
local function settle()
if not frame.Parent or compact then return end
frame.ClipsDescendants = part.isDivider == true
if not part.isDivider then
frame.Size = UDim2.fromOffset(0, frame.Size.Y.Offset)
frame.AutomaticSize = Enum.AutomaticSize.X
end
end
if t > 0 then
local anim = TS:Create(frame, info, { Size = UDim2.fromOffset(width, frame.Size.Y.Offset) })
anim.Completed:Connect(settle)
anim:Play()
else
frame.Size = UDim2.fromOffset(width, frame.Size.Y.Offset)
settle()
end
end
end
end
if chevronGlyph and chevronGlyph.Parent then
local rot = compact and 180 or 0
if animate then
tw(chevronGlyph, COMPACT_T, { Rotation = rot })
else
chevronGlyph.Rotation = rot
end
end
if pill and target then
task.delay(animate and COMPACT_T + 0.05 or 0.05, function()
if pill and target then moveTo(target) end
end)
end
end
function M.isCompact() return compact end
function M.setLauncher(on)
if not launcher or not launcher.Parent then return false end
launcher.Visible = on and true or false
if launcher.Visible then positionLauncher() end
return true
end
function M.setCompact(on)
on = on and true or false
if on == compact then return end
compact = on
writePrefs({ compact = on })
if pill and not closing then applyCompact(true) end
end
local function fade(on, t, pop)
for _, f in ipairs(fadeList) do
if f[1].Parent then tw(f[1], t, { [f[2]] = on and f[3] or 1 }) end
end
if scaler then
tw(scaler, t, { Scale = on and baseScale or baseScale * 0.9 },
(on and pop) and Enum.EasingStyle.Back or Enum.EasingStyle.Exponential)
end
end
local function hits(obj, inp)
if not obj or not obj.Parent then return false end
local p, s = obj.AbsolutePosition, obj.AbsoluteSize
local inset = 0
pcall(function() inset = game:GetService("GuiService"):GetGuiInset().Y end)
local x, y = inp.Position.X, inp.Position.Y
return x >= p.X and x <= p.X + s.X
and ((y >= p.Y and y <= p.Y + s.Y) or (y + inset >= p.Y and y + inset <= p.Y + s.Y))
end
local menu, menuScale, menuOpenedAt = nil, nil, 0
local LONG_PRESS = 0.5     
local LONG_PRESS_SLOP = 10 
local function notify(title, text)
BX.try("stats.menuNotify", function()
local win = BX._loaded["ui.window"]
if win and win.notify then win.notify(title, text, 4) end
end)
end
local function closeMenu()
if not menu then return end
local m = menu
menu = nil
for _, d in ipairs(m:GetDescendants()) do
if d:IsA("TextLabel") then tw(d, 0.15, { TextTransparency = 1 })
elseif d:IsA("UIStroke") or d:IsA("UIShadow") then tw(d, 0.15, { Transparency = 1 })
elseif d:IsA("Frame") and d.BackgroundTransparency < 1 then tw(d, 0.15, { BackgroundTransparency = 1 }) end
end
tw(m, 0.15, { BackgroundTransparency = 1 })
if menuScale then tw(menuScale, 0.15, { Scale = 0.95 }) end
task.delay(0.17, function() pcall(function() m:Destroy() end) end)
end
local function fpsBoostOn()
local ok, on = pcall(function() return BX.require("features.fps").isOn() end)
return ok and on == true
end
local function openMenu()
if not gui or not pill or closing then return end
if menu then closeMenu() return end
hideTip()
menuOpenedAt = os.clock()
local touch = UIS.TouchEnabled and not UIS.KeyboardEnabled
local ROW_H, WIDTH = touch and 40 or 32, 176
menu = mk("Frame", {
Name = "QuickMenu", AnchorPoint = Vector2.new(0.5, 0.5),
Size = UDim2.fromOffset(WIDTH, ROW_H * 3 + 12), BackgroundColor3 = Color3.new(1, 1, 1),
BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 20,
}, gui)
mk("UICorner", { CornerRadius = UDim.new(0, 10) }, menu)
mk("UIGradient", {
Rotation = 90, Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, BG_TOP),
ColorSequenceKeypoint.new(0.45, Color3.fromRGB(13, 13, 14)),
ColorSequenceKeypoint.new(1, BG_BOT),
}),
}, menu)
local mStroke = mk("UIStroke", {
Color = Color3.new(1, 1, 1), Thickness = 1, Transparency = 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, menu)
mk("UIGradient", {
Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(58, 58, 64), Color3.fromRGB(22, 22, 25)),
}, mStroke)
local mShadow
pcall(function()
mShadow = mk("UIShadow", {
Color = Color3.new(0, 0, 0), BlurRadius = UDim.new(0, 26), Transparency = 1, ZIndex = -1,
}, menu)
end)
mk("UIPadding", {
PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
}, menu)
mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, menu)
menuScale = mk("UIScale", { Scale = baseScale * 0.95 }, menu)
local fadeIn = {}
local function row(order, label, onPick, withSwitch)
local b = mk("TextButton", {
LayoutOrder = order, Size = UDim2.new(1, 0, 0, ROW_H),
BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1,
AutoButtonColor = false, Text = "", ZIndex = 21,
}, menu)
mk("UICorner", { CornerRadius = UDim.new(0, 7) }, b)
local t = mk("TextLabel", {
Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -20, 1, 0),
BackgroundTransparency = 1, FontFace = face(Enum.FontWeight.Medium),
TextSize = TEXT_SIZE, TextColor3 = TEXT, TextTransparency = 1,
TextXAlignment = Enum.TextXAlignment.Left, Text = label, ZIndex = 22,
}, b)
fadeIn[#fadeIn + 1] = { t, "TextTransparency", 0 }
local knob, track
if withSwitch then
track = mk("Frame", {
AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
Size = UDim2.fromOffset(28, 16), BackgroundColor3 = Color3.new(1, 1, 1),
BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 22,
}, b)
mk("UICorner", { CornerRadius = UDim.new(1, 0) }, track)
knob = mk("Frame", {
AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0),
Size = UDim2.fromOffset(12, 12), BackgroundColor3 = BG_BOT,
BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 23,
}, track)
mk("UICorner", { CornerRadius = UDim.new(1, 0) }, knob)
end
local function paintSwitch(on, animate)
if not track then return end
local trackT, knobPos = on and 0 or 0.8, on and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
local knobColor = on and BG_BOT or ICON
if animate then
tw(track, 0.25, { BackgroundTransparency = trackT })
tw(knob, 0.25, { Position = knobPos, BackgroundTransparency = 0, BackgroundColor3 = knobColor })
else
knob.Position, knob.BackgroundColor3 = knobPos, knobColor
fadeIn[#fadeIn + 1] = { track, "BackgroundTransparency", trackT }
fadeIn[#fadeIn + 1] = { knob, "BackgroundTransparency", 0 }
end
end
if withSwitch then paintSwitch(withSwitch(), false) end
b.MouseEnter:Connect(function() tw(b, 0.2, { BackgroundTransparency = 0.94 }) end)
b.MouseLeave:Connect(function() tw(b, 0.2, { BackgroundTransparency = 1 }) end)
b.Activated:Connect(function()
BX.try("stats.menuPick", function() onPick(paintSwitch) end)
end)
end
row(1, "FPS Boost", function(paintSwitch)
local want = not fpsBoostOn()
local misc = BX._loaded["ui.tabs.misc"]
if misc and misc.setFpsBoost then misc.setFpsBoost(want)
else BX.require("features.fps").setEnabled(want) end
paintSwitch(want, true)
end, fpsBoostOn)
row(2, "Server Hop", function()
closeMenu()
task.spawn(function()
local ok, msg = BX.require("features.misc.servers").hop()
notify("Servers", tostring(msg))
end)
end)
row(3, "Rejoin", function()
closeMenu()
task.spawn(function()
local ok, msg = BX.require("features.misc.servers").rejoin()
notify("Servers", tostring(msg))
end)
end)
local vp = gui.AbsoluteSize
local below = pill.AbsolutePosition.Y + pill.AbsoluteSize.Y + 8
local height = (ROW_H * 3 + 12) * baseScale
local bottomEdge = gui.AbsolutePosition.Y + vp.Y
local y = (below + height > bottomEdge - 8) and (pill.AbsolutePosition.Y - 8 - height) or below
local halfW = WIDTH * baseScale / 2
local x = math.clamp(pill.AbsolutePosition.X + pill.AbsoluteSize.X / 2, halfW + 6, math.max(vp.X - halfW - 6, halfW + 6))
local origin = gui.AbsolutePosition
menu.Position = UDim2.fromOffset(x - origin.X, y + height / 2 - origin.Y)
tw(menu, 0.25, { BackgroundTransparency = 0.02 })
tw(mStroke, 0.25, { Transparency = STROKE_T })
if mShadow then tw(mShadow, 0.25, { Transparency = 0.45 }) end
tw(menuScale, 0.25, { Scale = baseScale })
for _, f in ipairs(fadeIn) do tw(f[1], 0.25, { [f[2]] = f[3] }) end
end
local function teardown()
if sc then sc:destroy(); sc = nil end
if gui then pcall(function() gui:Destroy() end) end
gui, pill, scaler, stroke, brandFrame = nil, nil, nil, nil, nil
launcher, launcherTitle, launcherSub = nil, nil, nil
chevron, chevronGlyph = nil, nil
menu, menuScale = nil, nil
bars, labels, fadeList, iconBoxes = {}, {}, {}, {}
cellFrames = {}
momentRow, momentDot, momentTitle, momentSub, momentBar, momentTrack = nil, nil, nil, nil, nil, nil
momentNodes, momentActive = {}, false
momentSignature, momentWidth, momentProgress = nil, nil, nil
momentMeasurePending, momentLastTitle, momentLastSub = false, nil, nil
tip, tipLabel, tipStroke = nil, nil, nil
dragging, moving, closing, shownFps, grabInput = false, false, false, nil, nil
resetNumbers()
iconTone = {}
fpsLevel, pingLevel = 0, 0
pingEma, pingSuspect, pingSeenAt = nil, 0, nil
hoverKind, hoverUntil, hovering = nil, 0, false
end
local function build()
sc = BX.scope("ui.stats")
local parent = exec.hiddenParent()
local old = parent:FindFirstChild("VoidcxzStats")
if old then old:Destroy() end
gui = mk("ScreenGui", {
Name = "VoidcxzStats", DisplayOrder = 100000, IgnoreGuiInset = true,
ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, parent)
local touch = UIS.TouchEnabled and not UIS.KeyboardEnabled
pill = mk("TextButton", {
AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromScale(0.5, 0.01),
AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.fromOffset(0, touch and 46 or 42),
BackgroundColor3 = BG_TOP, BackgroundTransparency = 0.18,
BorderSizePixel = 0, Active = true, AutoButtonColor = false,
Text = "", Selectable = false,
}, gui)
pill.Visible = not windowOpen
mk("UICorner", { CornerRadius = UDim.new(0, 22) }, pill)
mk("UIGradient", {
Rotation = 90,
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, BG_TOP),
ColorSequenceKeypoint.new(1, BG_TOP),
}),
}, pill)
stroke = mk("UIStroke", {
Color = Color3.fromRGB(167, 139, 250), Transparency = 0.48, Thickness = 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, pill)
pcall(function()
local glow = Instance.new("UIShadow")
glow.Color = Color3.fromRGB(91, 43, 216)
glow.BlurRadius = UDim.new(0, 30)
glow.Transparency = 0.72
glow.ZIndex = -1
glow.Parent = pill
end)
pcall(function()
mk("UIShadow", {
Color = Color3.new(0, 0, 0), BlurRadius = UDim.new(0, 22),
Transparency = 0.45, ZIndex = -1,
}, pill)
end)
mk("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }, pill)
mk("UIListLayout", {
FillDirection = Enum.FillDirection.Horizontal,
VerticalAlignment = Enum.VerticalAlignment.Center,
Padding = UDim.new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder,
}, pill)
launcher = mk("TextButton", {
Name = "VoidcxzHubLauncher", AnchorPoint = Vector2.new(0.5, 0),
Position = UDim2.fromScale(0.5, 0.08), Size = UDim2.fromOffset(250, 58),
BackgroundColor3 = Color3.fromRGB(12, 12, 16), BackgroundTransparency = 0.04,
BorderSizePixel = 0, AutoButtonColor = false, Text = "", Visible = false,
Active = true, ZIndex = 20,
}, gui)
mk("UICorner", { CornerRadius = UDim.new(0, 29) }, launcher)
mk("UIStroke", {
Color = Color3.fromRGB(91, 91, 105), Transparency = 0.48, Thickness = 1,
}, launcher)
mk("ImageLabel", {
Name = "Logo", AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.fromOffset(18, 29), Size = UDim2.fromOffset(30, 30),
BackgroundTransparency = 1, Image = logo.image(),
ScaleType = Enum.ScaleType.Fit, ZIndex = 21,
}, launcher)
launcherTitle = mk("TextLabel", {
Name = "Title", Position = UDim2.fromOffset(62, 11),
Size = UDim2.fromOffset(170, 22), BackgroundTransparency = 1,
FontFace = face(Enum.FontWeight.SemiBold), TextSize = 16,
TextColor3 = TEXT, TextXAlignment = Enum.TextXAlignment.Left,
Text = "VoidcxzHub", ZIndex = 21,
}, launcher)
launcherSub = mk("TextLabel", {
Name = "Subtitle", Position = UDim2.fromOffset(62, 32),
Size = UDim2.fromOffset(170, 18), BackgroundTransparency = 1,
FontFace = face(Enum.FontWeight.Medium), TextSize = 12,
TextColor3 = MUTED, TextXAlignment = Enum.TextXAlignment.Left,
Text = "Tap to show", ZIndex = 21,
}, launcher)
sc:connect(launcher.Activated, BX.guard("stats.revealLauncher", function()
local shell = BX._loaded["ui.shell"]
if shell and type(shell.reveal) == "function" then shell.reveal() end
end))
baseScale = pickScale()
scaler = mk("UIScale", { Scale = baseScale }, pill)
brandFrame = mk("Frame", {
Name = "VoidcxzBrand", LayoutOrder = 0, Size = UDim2.fromOffset(108, 30),
BackgroundTransparency = 1, BorderSizePixel = 0,
}, pill)
mk("ImageLabel", {
Name = "Logo", AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.fromOffset(0, 15), Size = UDim2.fromOffset(26, 26),
BackgroundTransparency = 1, Image = logo.image(),
ScaleType = Enum.ScaleType.Fit,
}, brandFrame)
mk("TextLabel", {
Name = "Title", Position = UDim2.fromOffset(32, 1),
Size = UDim2.fromOffset(76, 18), BackgroundTransparency = 1,
FontFace = face(Enum.FontWeight.SemiBold), TextSize = 13,
TextColor3 = TEXT, TextXAlignment = Enum.TextXAlignment.Left,
Text = "VoidcxzHub",
}, brandFrame)
mk("TextLabel", {
Name = "Subtitle", Position = UDim2.fromOffset(32, 17),
Size = UDim2.fromOffset(76, 13), BackgroundTransparency = 1,
FontFace = face(Enum.FontWeight.Medium), TextSize = 9,
TextColor3 = MUTED, TextXAlignment = Enum.TextXAlignment.Left,
Text = BX.game or "Steal An Egg",
}, brandFrame)
momentRow = mk("Frame", {
Name = "DynamicIslandRow", LayoutOrder = 1, Visible = false,
AutomaticSize = Enum.AutomaticSize.None, Size = UDim2.fromOffset(0, 24),
BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true,
}, pill)
momentDot = mk("Frame", {
AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromOffset(8, 12),
Size = UDim2.fromOffset(7, 7), BackgroundColor3 = ACCENT, BorderSizePixel = 0,
}, momentRow)
mk("UICorner", { CornerRadius = UDim.new(1, 0) }, momentDot)
momentTitle = mk("TextLabel", {
Position = UDim2.fromOffset(24, 1), Size = UDim2.fromOffset(0, 22),
AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1,
FontFace = face(Enum.FontWeight.SemiBold), TextSize = TEXT_SIZE,
TextColor3 = TEXT, TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd, Text = "",
}, momentRow)
momentSub = mk("TextLabel", {
Position = UDim2.fromOffset(0, 1), Size = UDim2.fromOffset(0, 22),
AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1,
FontFace = face(Enum.FontWeight.Medium), TextSize = UNIT_SIZE,
TextColor3 = MUTED, TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd, Text = "",
}, momentRow)
momentTrack = mk("Frame", {
Name = "ProgressTrack", AnchorPoint = Vector2.new(0, 1),
Position = UDim2.new(0, 24, 1, -1), Size = UDim2.new(0, 0, 0, 3),
BackgroundColor3 = TEXT, BackgroundTransparency = 0.82,
BorderSizePixel = 0, Visible = false,
}, momentRow)
mk("UICorner", { CornerRadius = UDim.new(1, 0) }, momentTrack)
momentBar = mk("Frame", {
Name = "Progress", AnchorPoint = Vector2.new(0, 1),
Position = UDim2.new(0, 24, 1, -1), Size = UDim2.new(0, 0, 0, 3),
BackgroundColor3 = TEXT, BorderSizePixel = 0, Visible = false, ZIndex = 2,
}, momentRow)
mk("UICorner", { CornerRadius = UDim.new(1, 0) }, momentBar)
labels.time = cell(pill, 2, "clock", "00:00")
local d1 = divider(pill, 3, "TimeDivider")
labels.fps  = cell(pill, 4, "pulse", "000", "FPS")
local d2 = divider(pill, 5, "PingDivider")
labels.ping = cell(pill, 6, "wifi", "000", "ms")
local spacer = mk("Frame", { LayoutOrder = 7, Size = UDim2.fromOffset(4, 18), BackgroundTransparency = 1, Visible = false }, pill)
local hit = touch and 34 or 24
chevron = mk("TextButton", {
Name = "Collapse", LayoutOrder = 8, Size = UDim2.fromOffset(hit, hit),
BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1,
AutoButtonColor = false, Text = "", Selectable = false, Visible = false,
}, pill)
mk("UICorner", { CornerRadius = UDim.new(0, 7) }, chevron)
chevronGlyph = mk("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(10, 10), BackgroundTransparency = 1,
Rotation = compact and 180 or 0,
}, chevron)
line(chevronGlyph, 6.5, 1.5, 3, 5)
line(chevronGlyph, 3, 5, 6.5, 8.5)
local function glyphTone(color)
for _, b in ipairs(chevronGlyph:GetChildren()) do
if b:IsA("Frame") then b.BackgroundColor3 = color end
end
end
glyphTone(ICON)
sc:connect(chevron.MouseEnter, function()
glyphTone(TEXT)
tw(chevron, 0.25, { BackgroundTransparency = 0.94 })
end)
sc:connect(chevron.MouseLeave, function()
glyphTone(ICON)
tw(chevron, 0.25, { BackgroundTransparency = 1 })
end)
sc:connect(chevron.Activated, BX.guard("stats.collapse", function()
M.setCompact(not compact)
end))
collapsible = {
{ frame = cellFrames.clock },
{ frame = d1, width = 21, isDivider = true },
{ frame = d2, width = 21, isDivider = true },
{ frame = cellFrames.wifi },
}
momentNodes = { brandFrame, cellFrames.clock, d1, cellFrames.pulse, d2, cellFrames.wifi, spacer, chevron }
if not iconsAsked and exec.can.customAsset and exec.can.files and not exec.fragile then
iconsAsked = true
sc:spawn("icons", function()
BX.try("stats.iconDirs", function() exec.ensureFolder(ICON_DIR) end)
local got = 0
for kind, src in pairs(ICON_SRC) do
local path = ICON_DIR .. "/" .. kind .. ".png"
local ok = BX.try("stats.icon." .. kind, function()
local have = exec.isFile(path) and validPng(exec.readFile(path))
if not have then
local png = game:HttpGet(ICON_BASE .. src)
assert(validPng(png), "not a usable png")
assert(exec.writeFile(path, png), "writefile refused")
end
iconAsset[kind] = assert(exec.customAsset(path), "no custom asset")
end)
if ok then got += 1 end
end
log.info("material icons ready: %d/3", got)
if got > 0 and gui and not closing and sc and sc:alive() then
for kind, box in pairs(iconBoxes) do
if box.Parent and iconAsset[kind] then
fillIcon(box, kind)
local img = box:FindFirstChild("Img")
if img then fadeList[#fadeList + 1] = { img, "ImageTransparency", 0 } end
end
end
end
end)
end
tip = mk("Frame", {
AnchorPoint = Vector2.new(0.5, 0), AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.fromOffset(0, 22), BackgroundColor3 = BG_BOT,
BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 5,
}, gui)
mk("UICorner", { CornerRadius = UDim.new(0, 7) }, tip)
tipStroke = mk("UIStroke", {
Color = ELEMENT, Transparency = 1, Thickness = 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
}, tip)
mk("UIPadding", { PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 9) }, tip)
tipScale = mk("UIScale", { Scale = baseScale }, tip)
tipLabel = mk("TextLabel", {
AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 22),
BackgroundTransparency = 1, FontFace = face(Enum.FontWeight.Medium), TextSize = UNIT_SIZE,
TextColor3 = TEXT, TextTransparency = 1, Text = "", ZIndex = 5,
}, tip)
target = clampPos(loadPos() or defaultPos())
pill.Position = target
sc:connect(gui:GetPropertyChangedSignal("AbsoluteSize"), BX.guard("stats.resize", function()
baseScale = pickScale()
if scaler and not dragging then scaler.Scale = baseScale end
if tipScale then tipScale.Scale = baseScale end
if target then moveTo(target) end
end))
sc:connect(pill.MouseEnter, function() hovering = true end)
sc:connect(pill.MouseLeave, function() hovering = false; hideTip() end)
local lastTap = 0
sc:connect(pill.InputBegan, BX.guard("stats.grab", function(inp)
local kind = inp.UserInputType
if kind == Enum.UserInputType.MouseButton2 then
openMenu()
return
end
if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then
return
end
if hits(chevron, inp) then return end
if kind == Enum.UserInputType.Touch then
local startPos = inp.Position
task.delay(LONG_PRESS, function()
if not dragging or grabInput ~= inp or closing then return end
local moved = (inp.Position - startPos).Magnitude
if moved > LONG_PRESS_SLOP then return end
release()
openMenu()
end)
end
local now = os.clock()
if now - lastTap < 0.3 then
lastTap = 0
release()
moveTo(defaultPos())
savePos(target)
return
end
lastTap = now
if kind == Enum.UserInputType.Touch then
local k = kindAtX(inp.Position.X)
if k then
showTip(k)
hoverUntil = now + DETAIL_HOLD
end
end
dragging, grabInput, grabPos = true, inp, target or pill.Position
grabStart = (kind == Enum.UserInputType.MouseButton1)
and UIS:GetMouseLocation() or inp.Position
tw(scaler, 0.2, { Scale = baseScale * 1.05 }, Enum.EasingStyle.Back)
tw(stroke, 0.2, { Transparency = 0.1 })
end))
sc:connect(pill.Activated, BX.guard("stats.revealWindow", function()
local shell = BX._loaded["ui.shell"]
local hidden = shell and type(shell.isHidden) == "function" and shell.isHidden()
if shell and hidden then
shell.reveal()
end
end))
sc:connect(UIS.InputChanged, BX.guard("stats.dragTouch", function(inp)
if dragging and grabInput and inp == grabInput
and inp.UserInputType == Enum.UserInputType.Touch then
dragTo(inp.Position)
end
end))
sc:connect(UIS.InputBegan, BX.guard("stats.menuDismiss", function(inp)
if not menu then return end
if inp.KeyCode == Enum.KeyCode.Escape then closeMenu() return end
local kind = inp.UserInputType
if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.MouseButton2
and kind ~= Enum.UserInputType.Touch then return end
if os.clock() - menuOpenedAt < 0.15 then return end
if not hits(menu, inp) then closeMenu() end
end))
sc:connect(UIS.InputEnded, BX.guard("stats.release", function(inp)
if not dragging or not grabInput then return end
if inp == grabInput or (inp.UserInputType == Enum.UserInputType.MouseButton1
and grabInput.UserInputType == Enum.UserInputType.MouseButton1) then
release()
end
end))
collectFade()
end
function M.show(on)
if not on then
if not gui or closing then return end
closing = true
release()
fade(false, 0.22)
local g = gui
task.delay(0.25, function()
if gui == g and closing then teardown() end
end)
return
end
if gui then
if closing then closing = false; fade(true, 0.3) end
return
end
local built, why = pcall(build)
if not built then
log.error("could not build: %s", tostring(why))
teardown()
return
end
for _, f in ipairs(fadeList) do
if f[1].Parent then f[1][f[2]] = 1 end
end
scaler.Scale = baseScale * 0.9
BX.try("stats.entryPos", function()
local vy = math.max(gui.AbsoluteSize.Y, 1)
pill.Position = UDim2.fromScale(target.X.Scale, target.Y.Scale - 12 / vy)
end)
local entering = gui
sc:spawn("entrance", function()
for _ = 1, 2 do RunService.RenderStepped:Wait() end
if gui ~= entering or closing or not BX.alive() then return end
if compact then applyCompact(false) end
fade(true, 0.4)
moving = true
end)
sc:delay("settle", 0.1, function()
if pill and target then moveTo(target) end
end)
frames = 0
sc:onFrame("frame", RunService.RenderStepped, function(dt)
frames += 1
easeNumbers(dt)
if launcher and launcher.Visible then positionLauncher() end
if hovering and not dragging then
local k = kindAtX(UIS:GetMouseLocation().X)
if k then showTip(k) elseif hoverKind then hideTip() end
elseif hoverUntil > 0 and os.clock() > hoverUntil then
hideTip()
end
if hoverKind then placeTip() end
if dragging and grabInput
and grabInput.UserInputType == Enum.UserInputType.MouseButton1 then
dragTo(UIS:GetMouseLocation())
end
if moving and target and pill then
local p = pill.Position:Lerp(target, 1 - math.exp(-math.min(dt, 1 / 30) * 20))
if math.abs(p.X.Scale - target.X.Scale) < 1e-4
and math.abs(p.Y.Scale - target.Y.Scale) < 1e-4 then
p = target
if not dragging then moving = false end
end
pill.Position = p
end
end)
local myGui = gui
sc:spawn("ticker", function()
local last = os.clock()
local interval = 1 / math.max(cfg.STATS_HZ / 2, 1)
local tick = BX.profile.wrapLoop("ui.stats/ticker", interval, function()
local now = os.clock()
local t = clock(now - sessionT0)
if labels.time.Text ~= t then labels.time.Text = t end
local rawFps = frames / math.max(now - last, 0.001)
frames, last = 0, now
shownFps = ema(shownFps, rawFps, FPS_ALPHA)
st.lastFps = shownFps
setTarget("fps", shownFps)
fpsLevel = grade(BANDS.fps, shownFps, fpsLevel)
local fpsTone = LEVEL_COLOR[fpsLevel]
paint(labels.fps, "TextColor3", fpsTone)
tintIcon("pulse", fpsLevel == 0 and ICON or fpsTone)
if hoverKind and tipLabel then
local fresh = detailFor(hoverKind)
if tipLabel.Text ~= fresh then tipLabel.Text = fresh end
end
local raw = readPing()
if raw and pingEma and raw > math.max(pingEma * SPIKE_FACTOR, SPIKE_FLOOR) then
pingSuspect = pingSuspect + 1
if pingSuspect < SPIKE_CONFIRM then
log.trace("ping outlier held: %.0fms (settled %.0fms)", raw, pingEma)
raw = nil
end
elseif raw then
pingSuspect = 0
end
if raw then
pingEma    = ema(pingEma, raw, PING_ALPHA)
pingSeenAt = now
setTarget("ping", pingEma)
pingLevel = grade(BANDS.ping, pingEma, pingLevel)
local pingTone = LEVEL_COLOR[pingLevel]
paint(labels.ping, "TextColor3", pingTone)
tintIcon("wifi", pingLevel == 0 and ICON or pingTone)
if not closing then
local lit = 3 - pingLevel
for i, b in ipairs(bars) do
local want = i <= lit and 0 or 0.7
if b.Parent and b.BackgroundTransparency ~= want then
tw(b, 0.3, { BackgroundTransparency = want })
end
end
end
elseif pingSeenAt and (now - pingSeenAt) > STALE_AFTER then
setUnavailable("ping")
pingEma, pingLevel, pingSeenAt = nil, 0, nil
tintIcon("wifi", ICON)
end
end)
while gui == myGui and myGui.Parent and BX.alive() do
task.wait(interval)
if gui ~= myGui then return end
BX.try("stats.tick", tick)
end
if not BX.alive() then teardown() end
end)
end
function M.bump(strength)
if not scaler or not scaler.Parent or closing then return false end
local k = baseScale * (1 + (strength or 0.06))
tw(scaler, 0.12, { Scale = k }, Enum.EasingStyle.Quad)
task.delay(0.12, function()
if scaler and scaler.Parent then
tw(scaler, 0.32, { Scale = baseScale }, Enum.EasingStyle.Back)
end
end)
return true
end
function M.anchor()
if not pill or not pill.Parent or closing then return nil end
return pill, (scaler and scaler.Scale) or baseScale
end
function M.surface()
if not gui or not gui.Parent or closing then return nil end
return gui, pill, (scaler and scaler.Scale) or baseScale
end
function M.moment(spec)
return setMoment(spec)
end
M._probe = function()
return {
guiAlive = gui ~= nil and gui.Parent ~= nil,
time     = labels.time and labels.time.Text,
fps      = labels.fps and labels.fps.Text,
ping     = labels.ping and labels.ping.Text,
scale    = scaler and scaler.Scale,
pillSize = pill and tostring(pill.AbsoluteSize),
conns    = sc and #sc.conns or 0,
fadeN    = #fadeList,
}
end
return M
end)
BX.module("ui.island", function(BX)
local svc = BX.require("core.services")
local M = {}
local shown, current = false, nil
local persistent, persistentOrder = {}, {}
local transient
local started = false
local function stats()
return BX._loaded["ui.stats"] or BX.require("ui.stats")
end
local function resolve()
if transient and os.clock() < transient.untilT then
return transient.spec, transient.key
end
transient = nil
for i = #persistentOrder, 1, -1 do
local key = persistentOrder[i]
local spec = persistent[key]
if spec then return spec, key end
end
end
local function refresh()
if not BX.alive() then return end
local spec, key = resolve()
local hud = stats()
if hud and hud.moment then hud.moment(spec) end
shown, current = spec ~= nil, key
end
function M.show(key, spec)
spec = spec or {}
transient = { key = key, spec = spec, untilT = os.clock() + (spec.hold or 3) }
BX.try("island.show", refresh)
local untilT = transient.untilT
task.delay((spec.hold or 3) + 0.05, function()
if transient and transient.untilT == untilT then BX.try("island.expire", refresh) end
end)
end
function M.set(key, spec)
spec = spec or {}
if persistent[key] == nil then
if spec.low then table.insert(persistentOrder, 1, key)
else persistentOrder[#persistentOrder + 1] = key end
end
persistent[key] = spec
if not transient then BX.try("island.set", refresh) end
end
function M.clear(key)
if persistent[key] == nil then return end
persistent[key] = nil
for i = #persistentOrder, 1, -1 do
if persistentOrder[i] == key then table.remove(persistentOrder, i) end
end
if not transient then BX.try("island.clear", refresh) end
end
function M.isShowing() return shown end
function M.start()
if started then return end
started = true
local auto = BX.require("features.autosteal")
local carry = BX.require("features.carry")
local eggs = BX.require("features.eggs")
local phases = {
READY_TO_STEAL = "baiting the guard", BAIT_DONE = "heading to the egg",
AT_TARGET = "grabbing", TARGET_GRAB_RETRY = "grabbing",
CARRYING = "carrying", RETURNING = "carrying",
}
local hud = stats()
if hud and hud.show then hud.show(true) end
local sc = BX.scope("ui.island")
sc:loop("steal", 0.2, function()
local live = auto.live()
if not (live.running and live.target and live.busy) then
M.clear("steal")
return
end
local progress = carry.progress()
M.set("steal", {
title = "Stealing " .. tostring(live.target.name or "egg"),
sub = progress and ("carrying %d%%"):format(math.floor(progress * 100 + 0.5))
or phases[live.phase or ""] or "stealing",
progress = progress,
})
end)
auto.onDelivered(function(target)
local rate = target and tonumber(target.value)
M.clear("steal")
M.show("delivered", {
title = "Egg delivered!",
sub = rate and rate > 0 and ("+%s/s"):format(eggs.formatRate(rate))
or tostring(target and target.name or ""),
tone = "good", hold = 3, pulse = true,
})
end)
BX.try("island.boss", function()
local boss = BX.require("features.boss")
local wasOpen = false
boss.onChange(function()
local state = boss.status()
local open = type(state.body) == "string" and state.body:find("^Open") ~= nil
if open and not wasOpen then
M.show("boss", { title = "Boss world open",
sub = state.body:gsub("^Open%s*·%s*", ""), tone = "warn", hold = 4, pulse = true })
end
wasOpen = open
end)
end)
BX.try("island.rift", function()
local rift = BX.require("features.rift")
local lastNeed
rift.onChange(function()
local state = rift.status()
local need = type(state.body) == "string" and state.body:match("^Steal (.-) now") or nil
if need and need ~= lastNeed then
M.show("rift", { title = "Rift needs " .. need,
sub = "it's on the field", tone = "warn", hold = 4, pulse = true })
end
lastNeed = need
end)
end)
BX.try("island.luck", function()
local remote = svc.ReplicatedStorage.Packages.Networking:FindFirstChild("RE/LuckWindow/StateRefreshed")
if not (remote and remote:IsA("RemoteEvent")) then return end
local endsAt
local function findEnd(value, depth)
if type(value) ~= "table" or depth > 2 then return nil end
local now = workspace:GetServerTimeNow()
for key, item in pairs(value) do
if type(item) == "number" and item > now and item < now + 86400 then
local name = tostring(key):lower()
if name:find("end") or name:find("expire") or name:find("until") or name:find("close") then return item end
elseif type(item) == "table" then
local nested = findEnd(item, depth + 1)
if nested then return nested end
end
end
end
sc:connect(remote.OnClientEvent, function(payload)
endsAt = findEnd(payload, 0)
if not endsAt then M.clear("luck") end
end)
sc:loop("luck", 1, function()
if not endsAt then return end
local left = endsAt - workspace:GetServerTimeNow()
if left <= 0 then endsAt = nil M.clear("luck") return end
M.set("luck", { title = "Luck window",
sub = ("%d:%02d left"):format(math.floor(left / 60), math.floor(left % 60)), tone = "good" })
end)
end)
end
function M.stop()
shown, current, started = false, nil, false
persistent, persistentOrder, transient = {}, {}, nil
local hud = BX._loaded["ui.stats"]
if hud and hud.moment then BX.try("island.stop", hud.moment, nil) end
end
BX.onTeardown("ui.island", M.stop)
return M
end)
BX.module("ui.recap", function(BX)
local svc = BX.require("core.services")
local exec = BX.require("core.exec")
local log = BX.require("boot.log").for_module("recap")
local M = {}
local TS = svc.TweenService
local FAMILY = "rbxassetid://12187365364"
local TEXT, MUTED = Color3.fromRGB(236, 236, 240), Color3.fromRGB(120, 120, 128)
local HOLD, MIN_EGGS, MIN_SECONDS = 7, 2, 60
local function face(w)
local ok, f = pcall(Font.new, FAMILY, w)
return ok and f or Font.fromEnum(Enum.Font.GothamMedium)
end
local function mk(class, props, parent)
local o = Instance.new(class)
for k, v in pairs(props) do o[k] = v end
o.Parent = parent
return o
end
local function tw(o, t, props, dir)
if not o or not o.Parent then return end
pcall(function()
TS:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props):Play()
end)
end
local function duration(seconds)
seconds = math.floor(seconds)
if seconds >= 3600 then return ("%dh %02dm"):format(seconds // 3600, (seconds % 3600) // 60) end
if seconds >= 60 then return ("%dm"):format(seconds // 60) end
return ("%ds"):format(seconds)
end
local sc, card = nil, nil
local function dismiss(target)
if not target or not target.Parent then return end
local cardScale = target:FindFirstChildOfClass("UIScale")
for _, d in ipairs(target:GetDescendants()) do
if d:IsA("TextLabel") then tw(d, 0.25, { TextTransparency = 1 })
elseif d:IsA("UIStroke") or d:IsA("UIShadow") then tw(d, 0.25, { Transparency = 1 }) end
end
tw(target, 0.3, { BackgroundTransparency = 1 })
if cardScale then tw(cardScale, 0.3, { Scale = cardScale.Scale * 0.96 }, Enum.EasingDirection.In) end
task.delay(0.32, function() pcall(function() target:Destroy() end) end)
if card == target then card = nil end
end
function M.show(s)
if not sc then return end
local eggs = BX.require("features.eggs")
local island = BX._loaded["ui.island"] or BX.require("ui.island")
local bestText = s.best and ("best: %s%s"):format(tostring(s.best.name or "?"),
s.best.rarity and s.best.rarity ~= "?" and (" (" .. tostring(s.best.rarity) .. ")") or "") or "no eggs"
if island and island.show then
if card then dismiss(card) end
island.show("recap", {
title = ("Session recap · %d egg%s · +%s/s"):format(
s.eggs, s.eggs == 1 and "" or "s", eggs.formatRate(s.income)),
sub = ("%s  ·  %s"):format(bestText, duration(s.seconds)),
tone = "good", hold = HOLD,
})
log.info("recap: %d eggs, +%s/s, %s, %s", s.eggs, eggs.formatRate(s.income), bestText, duration(s.seconds))
return
end
local parent = exec.hiddenParent()
local gui = parent:FindFirstChild("VoidcxzIsland") or parent:FindFirstChild("VoidcxzStats")
if not gui then
gui = sc:own(mk("ScreenGui", { Name = "VoidcxzRecap", DisplayOrder = 999998, IgnoreGuiInset = true,
ResetOnSpawn = false }, parent))
end
local stats = BX._loaded["ui.stats"]
local pill, scaleNow = nil, 1
if stats and stats.anchor then pill, scaleNow = stats.anchor() end
scaleNow = scaleNow or 1
local c = mk("TextButton", {
Name = "RecapCard", AnchorPoint = Vector2.new(0.5, 0), AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.fromOffset(0, 70), BackgroundColor3 = Color3.new(1, 1, 1),
BackgroundTransparency = 1, BorderSizePixel = 0, AutoButtonColor = false, Text = "", ZIndex = 30,
}, gui)
card = c
mk("UICorner", { CornerRadius = UDim.new(0, 12) }, c)
mk("UIGradient", { Rotation = 90, Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 27)),
ColorSequenceKeypoint.new(0.45, Color3.fromRGB(13, 13, 14)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(9, 9, 10)) }) }, c)
local stroke = mk("UIStroke", { Color = Color3.new(1, 1, 1), Transparency = 1, Thickness = 1,
ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, c)
mk("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(58, 58, 64), Color3.fromRGB(22, 22, 25)) }, stroke)
local shadow
pcall(function()
shadow = mk("UIShadow", { Color = Color3.new(0, 0, 0), BlurRadius = UDim.new(0, 26), Transparency = 1, ZIndex = -1 }, c)
end)
mk("UIPadding", { PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18),
PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10) }, c)
mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2) }, c)
local cardScale = mk("UIScale", { Scale = scaleNow * 0.96 }, c)
local function line(order, text, size, weight, color)
return mk("TextLabel", { LayoutOrder = order, AutomaticSize = Enum.AutomaticSize.X,
Size = UDim2.fromOffset(0, size + 4), BackgroundTransparency = 1, FontFace = face(weight),
TextSize = size, TextColor3 = color, TextTransparency = 1, Text = text,
TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 31 }, c)
end
line(1, "Session recap", 12, Enum.FontWeight.Medium, MUTED)
line(2, ("%d egg%s  \u{B7}  +%s/s"):format(s.eggs, s.eggs == 1 and "" or "s", eggs.formatRate(s.income)),
14, Enum.FontWeight.SemiBold, TEXT)
local bestText = s.best and ("best: %s%s"):format(tostring(s.best.name or "?"),
s.best.rarity and s.best.rarity ~= "?" and (" (" .. tostring(s.best.rarity) .. ")") or "") or "no eggs"
line(3, ("%s  \u{B7}  %s"):format(bestText, duration(s.seconds)), 12, Enum.FontWeight.Medium, MUTED)
local origin = gui.AbsolutePosition
local x, y
if pill then
x = pill.AbsolutePosition.X + pill.AbsoluteSize.X / 2 - origin.X
y = pill.AbsolutePosition.Y + pill.AbsoluteSize.Y + 12 - origin.Y
else
x, y = nil, 52 - origin.Y
end
local final = x and UDim2.fromOffset(x, y) or UDim2.new(0.5, 0, 0, y)
c.Position = final - UDim2.fromOffset(0, 10)
tw(c, 0.4, { Position = final, BackgroundTransparency = 0.02 })
tw(stroke, 0.4, { Transparency = 0.35 })
if shadow then tw(shadow, 0.4, { Transparency = 0.45 }) end
tw(cardScale, 0.4, { Scale = scaleNow })
for _, d in ipairs(c:GetChildren()) do
if d:IsA("TextLabel") then tw(d, 0.4, { TextTransparency = 0 }) end
end
c.Activated:Connect(function() dismiss(c) end)
task.delay(HOLD, function() dismiss(c) end)
log.info("recap: %d eggs, +%s/s, %s, %s", s.eggs, eggs.formatRate(s.income), bestText, duration(s.seconds))
end
local session = nil
function M.start()
if sc then return end
sc = BX.scope("ui.recap")
local auto = BX.require("features.autosteal")
auto.onStart(function(owner)
session = { owner = owner, t0 = os.clock(), eggs = 0, income = 0, best = nil }
end)
auto.onDelivered(function(target)
if not session or not sc then return end
session.eggs = session.eggs + 1
local v = tonumber(target and target.value) or 0
session.income = session.income + v
if not session.best or v > (tonumber(session.best.value) or 0) then
session.best = { name = target.name, rarity = target.rarity, value = v }
end
end)
auto.onStop(function()
local s = session
session = nil
if not s or not sc then return end
s.seconds = os.clock() - s.t0
if s.eggs >= MIN_EGGS or (s.eggs >= 1 and s.seconds >= MIN_SECONDS) then
BX.try("recap.show", M.show, s)
end
end)
end
BX.onTeardown("ui.recap", function()
if card then pcall(function() card:Destroy() end) card = nil end
if sc then sc:destroy() sc = nil end
session = nil
end)
return M
end)
BX.module("ui.lib.theme", function(BX)
local T = {}
T.PANEL     = Color3.fromRGB(13, 13, 16)    
T.RAIL_BG   = T.PANEL
T.WORKSPACE = T.PANEL
T.GROUP_BG  = Color3.fromRGB(29, 30, 34)    
T.HAIRLINE  = Color3.fromRGB(255, 255, 255) 
T.HAIRLINE_A = 0.92
T.ROW_WASH_HOV = 0.94                       
T.ROW_WASH_HELD = 0.91
T.PANEL_2   = T.WORKSPACE                   
T.LINE      = Color3.fromRGB(52, 53, 58)    
T.CARD_TOP    = Color3.fromRGB(29, 30, 34)
T.CARD_BOT    = Color3.fromRGB(29, 30, 34)
T.CARD_TOP_H  = Color3.fromRGB(33, 34, 38)  
T.CARD_BOT_H  = Color3.fromRGB(33, 34, 38)
T.CARD_ROT    = 55
T.ELEMENT   = Color3.fromRGB(31, 32, 36)
T.ELEMENT_H = Color3.fromRGB(38, 39, 44)
T.CARD_EDGE   = Color3.fromRGB(58, 59, 65)
T.CARD_EDGE_ALPHA   = 1        
T.CARD_EDGE_ALPHA_H = 0.5      
T.CARD_EDGE_H = Color3.fromRGB(128, 103, 163)   
T.TRACK     = Color3.fromRGB(67, 68, 74)    
T.COMMUNITY_TOP  = Color3.fromRGB(29, 30, 34)
T.COMMUNITY_BOT  = Color3.fromRGB(29, 30, 34)
T.COMMUNITY_EDGE = Color3.fromRGB(48, 40, 61)
T.UPDATE_TOP     = Color3.fromRGB(29, 30, 34)
T.UPDATE_BOT     = Color3.fromRGB(29, 30, 34)
T.CTA_BG    = Color3.fromRGB(24, 20, 31)
T.CTA_BG_H  = Color3.fromRGB(33, 26, 45)
T.CTA_EDGE  = Color3.fromRGB(64, 50, 79)
T.CTA_TEXT  = Color3.fromRGB(232, 226, 240)
T.CARD_TITLE  = Color3.fromRGB(243, 239, 248)   
T.BADGE_BG    = Color3.fromRGB(115, 81, 176)    
T.ROW_TAG     = Color3.fromRGB(169, 154, 192)
T.ROW_TEXT    = Color3.fromRGB(225, 221, 235)
T.ROW_TEXT_LAST = Color3.fromRGB(242, 239, 255)
T.TEXT      = Color3.fromRGB(235, 235, 238)
T.MUTED     = Color3.fromRGB(153, 154, 161)   
T.PAGE_TITLE = Color3.fromRGB(235, 235, 238)
T.SECTION   = Color3.fromRGB(151, 152, 159)
T.TAB_OFF   = Color3.fromRGB(160, 161, 168)
T.TAB_ON    = Color3.fromRGB(245, 245, 246)
T.SELECT_TEXT = Color3.fromRGB(205, 180, 255)
T.ACCENT    = Color3.fromRGB(167, 139, 250)  
T.ACCENT_DEEP = Color3.fromRGB(91, 43, 180)
T.ACCENT_2  = T.ACCENT
T.ACCENT_D  = T.TRACK
T.WARN      = Color3.fromRGB(224, 123, 138)
T.GOOD      = Color3.fromRGB(52, 199, 89)     
T.WHITE     = Color3.fromRGB(255, 255, 255)
T.BLACK     = Color3.fromRGB(0, 0, 0)
T.TOGGLE_ON = ColorSequence.new(T.ACCENT_DEEP, T.ACCENT)          
T.TAB_ACTIVE = ColorSequence.new(
Color3.fromRGB(67, 51, 96), Color3.fromRGB(43, 33, 63))
T.TAB_ACTIVE_ROT = 20
T.TAB_WASH      = Color3.fromRGB(255, 255, 255)
T.TAB_WASH_ON   = 0.9
T.TAB_WASH_HOV  = 0.94
T.TAB_EDGE  = Color3.fromRGB(111, 81, 166)
T.SELECT_BG = Color3.fromRGB(88, 62, 128)    
T.SELECT_EDGE = Color3.fromRGB(116, 88, 155) 
T.CAPSULE_EDGE = T.ACCENT                    
T.WORDMARK_GRADIENT = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.55, Color3.fromRGB(229, 220, 255)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(167, 139, 250)),
})
T.WORDMARK_GLASS = ColorSequence.new({
ColorSequenceKeypoint.new(0,    Color3.fromRGB(139, 61, 255)),
ColorSequenceKeypoint.new(0.32, Color3.fromRGB(176, 140, 255)),
ColorSequenceKeypoint.new(0.47, Color3.fromRGB(236, 228, 255)),
ColorSequenceKeypoint.new(0.53, Color3.fromRGB(255, 255, 255)),
ColorSequenceKeypoint.new(0.68, Color3.fromRGB(176, 140, 255)),
ColorSequenceKeypoint.new(1,    Color3.fromRGB(139, 61, 255)),
})
T.GLASS_ROT   = 20      
T.GLASS_SWEEP = 3.2     
T.GLASS_EDGE  = Color3.fromRGB(255, 255, 255)  
T.GLASS_EDGE_ALPHA = 0.78
local COMMON_FONT = Font.fromEnum(Enum.Font.GothamMedium)
local BOLD_FONT = Font.fromEnum(Enum.Font.GothamBold)
local okTitle, TITLE_FONT = pcall(Font.new, "rbxassetid://12187365364", Enum.FontWeight.SemiBold)
if not okTitle or not TITLE_FONT then TITLE_FONT = COMMON_FONT end
T.FONT_TITLE = TITLE_FONT
T.FONT       = COMMON_FONT
T.FONT_MED   = COMMON_FONT
T.FONT_BOLD  = BOLD_FONT
T.MEASURE_FONT = Enum.Font.Gotham
T.SIZE_TITLE   = 20     
T.SIZE_SUB     = 12     
T.SIZE_PAGE    = 26     
T.SIZE_CARD_TITLE = 15  
T.SIZE_SECTION = 11     
T.SIZE_ROW     = 16     
T.SIZE_DESC    = 13     
T.SIZE_TAB     = 17
T.SIZE_BADGE   = 11
T.SIZE_VERSION_TAG = 14
T.SIZE_SELECT  = 13
T.WIN_W = 760
T.WIN_H = 480
T.WIN_W_NARROW = 520
T.WIN_H_NARROW = 540
T.WIN_MIN_W = 560
T.WIN_MIN_H = 340
T.WIN_MIN_W_NARROW = 300
T.WIN_MIN_H_NARROW = 360
T.RADIUS_WIN = 10
T.TITLEBAR_H  = 56
T.TITLEBAR_PAD_X = 16
T.TABBAR_W  = 176       
T.TABBAR_H  = 44        
T.RAIL_PAD_X = 12
T.RAIL_PAD_Y = 10
T.TAB_H     = 38
T.TAB_GAP   = 1
T.TAB_PAD_X = 14
T.RADIUS_TAB = 10
T.WORKSPACE_PAD_X = 24
T.WORKSPACE_PAD_Y = 8
T.PAGE_HEADER_H = 36
T.ROW_H      = 46
T.SECTION_H  = 28       
T.PAD        = 24
T.GAP        = 6
T.FADE_H     = 60     
T.CARD_PAD_X = 14
T.CARD_PAD_Y = 8
T.CARD_GAP   = 12
T.RADIUS     = 10
T.RADIUS_SM  = 8
T.CONTROL_INSET = 14
T.CONTROL_RESERVE = 190     
T.VALUE_RESERVE   = 190
T.TOGGLE_W = 36
T.TOGGLE_H = 20
T.TOGGLE_KNOB = 16
T.TOGGLE_KNOB_WIDE = 18    
T.SELECT_W = 190
T.SELECT_H = 38
T.ACTION_W = 78
T.ACTION_H = 22
T.STATUS_W = 76
T.STATUS_H = 26
T.SIZE_PILL = 10
T.USER_CHIP_H = 58
T.USER_CHIP_RADIUS = 16
T.LOGO       = BX.require("ui.logo").image()
T.LOGO_FLAT  = T.LOGO
T.LOGO_GLOSS = T.LOGO
T.LOGO_SIZE  = 40       
T.LOGO_RADIUS = 13
T.LOGO_FILE  = nil
T.SIDE_W        = 160       
T.SIDE_BTN_H    = 50
T.SIDE_GAP      = 8         
T.SIDE_COL_GAP  = 12        
T.SIDE_RADIUS   = 10
T.SIDE_BG       = Color3.fromRGB(88, 52, 186)   
T.SIDE_BG_HOV   = Color3.fromRGB(104, 64, 208)
T.SIDE_BG_ON    = Color3.fromRGB(139, 104, 239) 
T.SIDE_EDGE     = Color3.fromRGB(24, 12, 46)    
T.SIDE_EDGE_ON  = Color3.fromRGB(214, 198, 255)
T.SIDE_TEXT     = Color3.fromRGB(255, 255, 255)
T.SIDE_STROKE_W = 2.5       
T.SIDE_TEXT_SIZE = 16
T.SEARCH_H      = 44
T.SEARCH_GAP    = 12
T.SEARCH_BG     = Color3.fromRGB(20, 18, 28)
T.SEARCH_FIELD  = Color3.fromRGB(30, 27, 41)
T.SEARCH_EDGE   = Color3.fromRGB(64, 50, 99)
T.STROKE_REST  = 0.55
T.STROKE_HOVER = 0.30
T.SHADOW_BLUR  = 60
T.SHADOW_ALPHA = 0.35
T.BLOOM_BLUR   = 120
T.BLOOM_ALPHA  = 0.78
T.CAPSULE_W      = 292
T.CAPSULE_W_WIDE = 320
T.CAPSULE_H      = 42
T.CAPSULE_H_WIDE = 46
T.CAPSULE_TOP    = 20
T.CAPSULE_RADIUS = 22
T.CAPSULE_EDGE_A = 0.48     
T.OVERLAY_Z    = 50
T.OVERLAY_SHADOW = 34
T.DIM_ALPHA    = 0.42
T.DIM_GRADIENT = NumberSequence.new({
NumberSequenceKeypoint.new(0, 0.25),
NumberSequenceKeypoint.new(0.5, 0),
NumberSequenceKeypoint.new(1, 0.25),
})
T.EASE_UI     = Enum.EasingStyle.Quint
T.EASE_WINDOW = Enum.EasingStyle.Quint
T.FADE        = 0.2
T.MOVE        = 0.35
T.ENTER       = 0.35
T.TAB_FADE    = 0.12    
T.TAB_PAGE    = 0.20    
T.SLIDE_IN    = 3       
T.PRESS_SCALE = 0.98
T.PRESS_IN    = 0.06    
T.PRESS_OUT   = 0.22    
T.MORPH       = 0.35
T.MORPH_CHROME = 0.16
T.LIFT_SCALE   = 1.015
T.LIFT_SHADOW  = 0.22    
T.DRAG_K       = 180     
T.DRAG_C       = 26.8    
T.THROW        = 0.12    
T.EDGE_GIVE    = 0.25    
T.EDGE_MAX     = 48      
T.CLOSE_TINT   = Color3.fromRGB(255, 95, 86)
T.MORPH_IN    = 0.35
T.MORPH_OUT   = 0.35
T.EASE_SPRING = Enum.EasingStyle.Quint
function T.asset(path, fallback)
if not path then return fallback end
local got = nil
pcall(function()
local exec = BX.require("core.exec")
if exec.can.customAsset and exec.isFile(path) then
got = exec.customAsset(path)
end
end)
return got or fallback
end
function T.corner(radius)
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, radius or T.RADIUS)
return c
end
function T.stroke(colour, thickness, transparency)
local s = Instance.new("UIStroke")
s.Color = colour or T.LINE
s.Thickness = thickness or 1
s.Transparency = transparency or 0
s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
return s
end
function T.roundTopLeftOnly(frame, radius, colour)
radius = radius or T.RADIUS_WIN
local function patch(name, anchor, pos)
local f = Instance.new("Frame")
f.Name = name
f.AnchorPoint = anchor
f.Position = pos
f.Size = UDim2.fromOffset(radius, radius)
f.BackgroundColor3 = colour or T.WORKSPACE
f.BorderSizePixel = 0
f.ZIndex = 0
f.Parent = frame
end
patch("SquareTR", Vector2.new(1, 0), UDim2.new(1, 0, 0, 0))
patch("SquareBL", Vector2.new(0, 1), UDim2.new(0, 0, 1, 0))
patch("SquareBR", Vector2.new(1, 1), UDim2.new(1, 0, 1, 0))
end
function T.roundBottomLeftOnly(frame, radius, colour)
radius = radius or T.RADIUS_WIN
local function patch(name, anchor, pos)
local f = Instance.new("Frame")
f.Name = name
f.AnchorPoint = anchor
f.Position = pos
f.Size = UDim2.fromOffset(radius, radius)
f.BackgroundColor3 = colour or T.PANEL
f.BorderSizePixel = 0
f.ZIndex = 0
f.Parent = frame
end
patch("SquareTL", Vector2.new(0, 0), UDim2.new(0, 0, 0, 0))
patch("SquareTR", Vector2.new(1, 0), UDim2.new(1, 0, 0, 0))
patch("SquareBR", Vector2.new(1, 1), UDim2.new(1, 0, 1, 0))
end
function T.roundTopLeftBottomRight(frame, radius, colour)
radius = radius or T.RADIUS_WIN
local function patch(name, anchor, pos)
local f = Instance.new("Frame")
f.Name = name
f.AnchorPoint = anchor
f.Position = pos
f.Size = UDim2.fromOffset(radius, radius)
f.BackgroundColor3 = colour or T.WORKSPACE
f.BorderSizePixel = 0
f.ZIndex = 0
f.Parent = frame
end
patch("SquareTR", Vector2.new(1, 0), UDim2.new(1, 0, 0, 0))
patch("SquareBL", Vector2.new(0, 1), UDim2.new(0, 0, 1, 0))
end
function T.roundBottomRightOnly(frame, radius, colour)
radius = radius or T.RADIUS_WIN
local function patch(name, anchor, pos)
local f = Instance.new("Frame")
f.Name = name
f.AnchorPoint = anchor
f.Position = pos
f.Size = UDim2.fromOffset(radius, radius)
f.BackgroundColor3 = colour or T.WORKSPACE
f.BorderSizePixel = 0
f.ZIndex = 0
f.Parent = frame
end
patch("SquareTL", Vector2.new(0, 0), UDim2.new(0, 0, 0, 0))
patch("SquareTR", Vector2.new(1, 0), UDim2.new(1, 0, 0, 0))
patch("SquareBL", Vector2.new(0, 1), UDim2.new(0, 0, 1, 0))
end
function T.roundBottomOnly(frame, radius, colour)
radius = radius or T.RADIUS_WIN
local function patch(name, anchor, pos)
local f = Instance.new("Frame")
f.Name = name
f.AnchorPoint = anchor
f.Position = pos
f.Size = UDim2.fromOffset(radius, radius)
f.BackgroundColor3 = colour or T.PANEL
f.BorderSizePixel = 0
f.ZIndex = 0
f.Parent = frame
end
patch("SquareTL", Vector2.new(0, 0), UDim2.new(0, 0, 0, 0))
patch("SquareTR", Vector2.new(1, 0), UDim2.new(1, 0, 0, 0))
end
function T.gradient(sequence, rotation, transparency)
local g = Instance.new("UIGradient")
g.Color = sequence
g.Rotation = rotation or 90
if transparency then g.Transparency = transparency end
return g
end
function T.cardGradient(hovered)
return T.gradient(ColorSequence.new(
hovered and T.CARD_TOP_H or T.CARD_TOP,
hovered and T.CARD_BOT_H or T.CARD_BOT), T.CARD_ROT)
end
function T.shadow(object, blur, transparency)
local ok, s = pcall(function()
local sh = Instance.new("UIShadow")
sh.Color = T.BLACK
sh.BlurRadius = UDim.new(0, blur or T.SHADOW_BLUR)
sh.Transparency = transparency or T.SHADOW_ALPHA
sh.ZIndex = -1
sh.Parent = object
return sh
end)
return ok and s or nil
end
function T.fitScale(width, height)
local scale = 1
pcall(function()
local vp = workspace.CurrentCamera.ViewportSize
scale = math.clamp(
math.min((vp.X - 64) / width, (vp.Y - 64) / height), 0.35, 1)
end)
return scale
end
return T
end)
BX.module("ui.lib.render", function(BX)
local svc = BX.require("core.services")
local log = BX.require("boot.log").for_module("ui.render")
local M = {}
local pending = setmetatable({}, { __mode = "k" })
local pendingN = 0
local jobs = {}
local stats = { sets = 0, coalesced = 0, applied = 0, jobs = 0, frames = 0,
errors = 0, maxBatch = 0, requeued = 0 }
function M.stats() return table.clone(stats) end
function M.set(inst, prop, value)
if typeof(inst) ~= "Instance" then return false end
stats.sets = stats.sets + 1
local props = pending[inst]
if not props then
props = {}
pending[inst] = props
pendingN = pendingN + 1
elseif props[prop] ~= nil then
stats.coalesced = stats.coalesced + 1
end
props[prop] = value
return true
end
function M.setAll(inst, props)
if typeof(inst) ~= "Instance" then return false end
for k, v in pairs(props) do M.set(inst, k, v) end
return true
end
function M.call(fn)
if type(fn) ~= "function" then return false end
jobs[#jobs + 1] = fn
return true
end
function M.tween(inst, seconds, props, style, direction)
if typeof(inst) ~= "Instance" then return false end
return M.call(function()
local info = TweenInfo.new(seconds,
style or Enum.EasingStyle.Quint,
direction or Enum.EasingDirection.Out)
local t = svc.TweenService:Create(inst, info, props)
t:Play()
return t
end)
end
local function applyOne(inst, props)
if not inst.Parent and not inst:IsA("ScreenGui") then
return
end
for prop, value in pairs(props) do
local ok, err = pcall(function() inst[prop] = value end)
if ok then
stats.applied = stats.applied + 1
elseif tostring(err):find("capability", 1, true) then
stats.requeued = stats.requeued + 1
M.set(inst, prop, value)
else
stats.errors = stats.errors + 1
log.warn("write %s.%s failed: %s", inst.Name, tostring(prop), tostring(err))
end
end
end
local draining = false
local function drain()
if draining then return end
draining = true
local batch = 0
if pendingN > 0 then
local work = pending
pending, pendingN = setmetatable({}, { __mode = "k" }), 0
for inst, props in pairs(work) do
batch = batch + 1
applyOne(inst, props)
end
end
if #jobs > 0 then
local work = jobs
jobs = {}
for _, fn in ipairs(work) do
stats.jobs = stats.jobs + 1
local ok, err = pcall(fn)
if not ok then
stats.errors = stats.errors + 1
log.warn("render job failed: %s", tostring(err))
end
end
end
if batch > stats.maxBatch then stats.maxBatch = batch end
draining = false
end
M.drain = drain
local sc = nil
local started = false
function M.start()
if started then return true end
started = true
sc = BX.scope("ui.lib.render")
sc:spawn("drain", function()
while sc:alive() do
svc.RunService.RenderStepped:Wait()
stats.frames = stats.frames + 1
drain()
end
end)
log.info("render queue started")
return true
end
function M.stop()
if sc then sc:destroy() sc = nil end
started = false
pending, pendingN, jobs = setmetatable({}, { __mode = "k" }), 0, {}
end
function M.build(fn, timeout)
local limit = timeout or 5
local result, done, failure = BX.offthread(fn, limit)
if not done then
failure = ("timed out after %ss"):format(tostring(limit))
log.warn("render.build %s", failure)
end
if failure then log.error("render.build failed: %s", tostring(failure)) end
return result, done, failure
end
function M.flush() drain() end
return M
end)
BX.module("ui.lib.widgets", function(BX)
local svc = BX.require("core.services")
local T   = BX.require("ui.lib.theme")
local R   = BX.require("ui.lib.render")
local log = BX.require("boot.log").for_module("ui.widgets")
local W = {}
local UIS = svc.UserInputService
local ctx = { overlay = nil, scale = nil, root = nil }
function W.setContext(c) ctx = c or {} end
local function scaleK()
local s = ctx.scale
local k = s and s.Scale or 1
return (k > 0.01) and k or 1
end
local function mk(class, props, children)
local o = Instance.new(class)
local parent = props and props.Parent
for k, v in pairs(props or {}) do
if k ~= "Parent" then o[k] = v end
end
for _, c in ipairs(children or {}) do c.Parent = o end
if parent then o.Parent = parent end
return o
end
W.mk = mk
local function label(text, size, colour, bold)
return mk("TextLabel", {
BackgroundTransparency = 1,
Text = text or "",
FontFace = bold and T.FONT_BOLD or T.FONT,
TextSize = size or T.SIZE_ROW,
TextColor3 = colour or T.TEXT,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Center,
RichText = false,
})
end
local function hitbox(parent, height)
return mk("TextButton", {
Name = "Hit",
BackgroundTransparency = 1,
Text = "",
Size = height and UDim2.new(1, 0, 0, height) or UDim2.fromScale(1, 1),
AutoButtonColor = false,
ZIndex = 5,
Parent = parent,
})
end
local function chevron(parent, size, colour)
size = size or 9
local holder = mk("Frame", {
Name = "Chevron",
BackgroundTransparency = 1,
Size = UDim2.fromOffset(size * 2, size * 2),
Parent = parent,
})
local function bar(rot, xOff)
return mk("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.new(0.5, xOff, 0.5, 0),
Size = UDim2.fromOffset(size, 1.6),
BackgroundColor3 = colour or T.MUTED,
BorderSizePixel = 0,
Rotation = rot,
Parent = holder,
}, { T.corner(1) })
end
local a = bar(45, -size * 0.32)
local b = bar(-45, size * 0.32)
return holder, a, b
end
W.chevron = chevron
local function smallPill(parent, text, width, height)
local pill = mk("Frame", {
Name = "Pill",
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -T.CONTROL_INSET, 0.5, 0),
Size = UDim2.fromOffset(width, height),
BackgroundColor3 = T.SELECT_BG,
BackgroundTransparency = 0.88,
BorderSizePixel = 0,
Parent = parent,
}, {
T.corner(height / 2),
T.stroke(T.SELECT_EDGE, 1, 0.68),
})
local lbl = label(text, T.SIZE_PILL, T.SELECT_TEXT, false)
lbl.Size = UDim2.fromScale(1, 1)
lbl.TextXAlignment = Enum.TextXAlignment.Center
lbl.Parent = pill
return pill, lbl
end
local groups = setmetatable({}, { __mode = "k" })
local function groupFor(parent)
if parent:GetAttribute("Grouped") then return nil, true end
local g = groups[parent]
if g and g.Parent then return g, true end
return nil, false
end
local function card(parent, opts)
local group, grouped = groupFor(parent)
if group then parent = group end
local hasDesc = opts.description ~= nil and opts.description ~= ""
local reserve = opts.reserve or T.CONTROL_RESERVE
local ctrlH = opts.controlHeight or 26
local expandable = opts.expandable == true
local cardHeight = opts.minHeight or (expandable and 62 or (hasDesc and 52 or 44))
local root = mk("Frame", {
Name = "Card_" .. tostring(opts.name or "?"),
BackgroundColor3 = T.WHITE,
BackgroundTransparency = 0,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, cardHeight),
AutomaticSize = Enum.AutomaticSize.None,
LayoutOrder = opts.order or 0,
ClipsDescendants = false,
Parent = parent,
}, {
T.corner(T.RADIUS),
T.cardGradient(false),
T.stroke(T.CARD_EDGE, 1, T.CARD_EDGE_ALPHA),
mk("UISizeConstraint", { MinSize = Vector2.new(0, opts.minHeight or T.ROW_H) }),
mk("UIPadding", {
PaddingLeft = UDim.new(0, T.CARD_PAD_X),
PaddingRight = UDim.new(0, T.CARD_PAD_X),
PaddingTop = UDim.new(0, T.CARD_PAD_Y),
PaddingBottom = UDim.new(0, T.CARD_PAD_Y),
}),
mk("UIListLayout", {
FillDirection = expandable and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal,
VerticalAlignment = Enum.VerticalAlignment.Center,
Padding = UDim.new(0, expandable and 6 or T.CARD_GAP),
SortOrder = Enum.SortOrder.LayoutOrder,
}),
})
local header = root
if expandable then
header = mk("Frame", {
Name = "Header",
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = 1,
Parent = root,
})
end
local col = mk("Frame", {
Name = "TextCol",
BackgroundTransparency = 1,
Size = UDim2.new(1, -(reserve + T.CONTROL_INSET + T.CARD_GAP), 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = 1,
Parent = header,
}, {
mk("UIListLayout", {
Padding = UDim.new(0, 3),
SortOrder = Enum.SortOrder.LayoutOrder,
}),
})
if not expandable then
col.AutomaticSize = Enum.AutomaticSize.None
col.Size = UDim2.new(1, -(reserve + T.CONTROL_INSET + T.CARD_GAP),
0, hasDesc and 37 or 18)
col.Position = UDim2.fromOffset(T.CARD_PAD_X, T.CARD_PAD_Y)
end
local title = label(opts.name, T.SIZE_ROW, T.TEXT, true)
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, hasDesc and 18 or 18)
title.AutomaticSize = Enum.AutomaticSize.None
title.TextYAlignment = Enum.TextYAlignment.Top
title.LayoutOrder = 1
title.Parent = col
local desc = nil
if hasDesc then
desc = label(opts.description, T.SIZE_DESC, T.MUTED, false)
desc.Name = "Desc"
desc.Size = UDim2.new(1, 0, 0, 16)
desc.AutomaticSize = Enum.AutomaticSize.None
desc.TextWrapped = false
desc.TextTruncate = Enum.TextTruncate.AtEnd
desc.TextYAlignment = Enum.TextYAlignment.Top
desc.LayoutOrder = 2
desc.Parent = col
end
local ctrl = (reserve > 0) and mk("Frame", {
Name = "Ctrl",
BackgroundTransparency = 1,
Size = UDim2.fromOffset(reserve + T.CONTROL_INSET, ctrlH),
LayoutOrder = 2,
Parent = header,
}) or nil
if not expandable then
local list = root:FindFirstChildOfClass("UIListLayout")
if list then list:Destroy() end
col.Visible = false
title.Parent = root
title.Position = UDim2.fromOffset(0, 0)
title.Size = UDim2.new(1, -(reserve + T.CONTROL_INSET + T.CARD_GAP), 0, 18)
title.ZIndex = 11
if desc then
desc.Parent = root
desc.Position = UDim2.fromOffset(0, 21)
desc.Size = UDim2.new(1, -(reserve + T.CONTROL_INSET + T.CARD_GAP), 0, 16)
desc.ZIndex = 11
end
if ctrl then
ctrl.AnchorPoint = Vector2.new(1, 0.5)
ctrl.Position = UDim2.new(1, 0, 0.5, 0)
end
end
if expandable then
col.Position = UDim2.fromOffset(0, 0)
col.Size = UDim2.new(1, -(reserve + T.CARD_GAP), 0, 0)
if ctrl then
ctrl.AnchorPoint = Vector2.new(1, 0.5)
ctrl.Position = UDim2.new(1, 0, 0.5, 0)
end
end
local edge = root:FindFirstChildOfClass("UIStroke")
local fill = root:FindFirstChildOfClass("UIGradient")
local press = nil
local wash = nil
local shell = {
root = root, header = header, col = col, title = title, desc = desc,
ctrl = ctrl, edge = edge, fill = fill, press = press, wash = wash,
grouped = grouped,
order = opts.order or 0,
}
return shell
end
local function makeHoverable(shell, hit)
local inside, held = false, false
local function paint()
if shell.fill then
R.set(shell.fill, "Color", ColorSequence.new(
(inside or held) and T.CARD_TOP_H or T.CARD_TOP,
(inside or held) and T.CARD_BOT_H or T.CARD_BOT))
end
if shell.edge then
R.tween(shell.edge, T.FADE, {
Color = (inside or held) and T.CARD_EDGE_H or T.CARD_EDGE,
Transparency = held and 0.72 or (inside and 0.88 or T.CARD_EDGE_ALPHA),
Thickness = 1,
})
end
if shell.wash then
R.tween(shell.wash, held and T.PRESS_IN or T.FADE, {
BackgroundTransparency = held and T.ROW_WASH_HELD
or (inside and T.ROW_WASH_HOV or 1),
})
end
if shell.press then
R.tween(shell.press, held and T.PRESS_IN or T.PRESS_OUT, {
Scale = held and T.PRESS_SCALE or 1,
}, held and Enum.EasingStyle.Quad or T.EASE_UI)
end
end
hit.MouseEnter:Connect(function() inside = true paint() end)
hit.MouseLeave:Connect(function() inside = false held = false paint() end)
hit.MouseButton1Down:Connect(function() held = true paint() end)
hit.MouseButton1Up:Connect(function() held = false paint() end)
return paint
end
local function newHandle(kind, shell)
local h = { kind = kind, _root = shell and shell.root or nil, _dead = false }
function h:instance() return self._root end
function h:setTitle(text)
if shell and shell.title then R.set(shell.title, "Text", tostring(text)) end
end
function h:setDescription(text)
if shell and shell.desc then R.set(shell.desc, "Text", tostring(text)) end
end
function h:setVisible(on)
if self._root then R.set(self._root, "Visible", on and true or false) end
end
function h:destroy()
if self._dead then return end
self._dead = true
local root = self._root
if root then R.call(function() root:Destroy() end) end
end
return h
end
function W.subnav(parent, opts)
opts = opts or {}
local root = mk("Frame", {
Name = "Subnav",
BackgroundColor3 = T.BLACK,
BackgroundTransparency = 0.86,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, 32),
LayoutOrder = opts.order or 0,
Parent = parent,
}, {
T.corner(9),
mk("UIPadding", {
PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3),
}),
mk("UIListLayout", {
FillDirection = Enum.FillDirection.Horizontal,
VerticalAlignment = Enum.VerticalAlignment.Center,
Padding = UDim.new(0, 2),
SortOrder = Enum.SortOrder.LayoutOrder,
}),
})
local buttons = {}
local active = nil
local function paint(name, on)
local b = buttons[name]
if not b then return end
R.tween(b, T.TAB_FADE, {
BackgroundTransparency = on and 0.72 or 1,
TextColor3 = on and T.TAB_ON or T.TAB_OFF,
}, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
end
local function select(name)
if active == name then return end
if active then paint(active, false) end
active = name
paint(name, true)
end
for i, item in ipairs(opts.items or {}) do
local name = tostring(item)
local b = mk("TextButton", {
Name = "Filter_" .. name,
AutoButtonColor = false,
AutomaticSize = Enum.AutomaticSize.X,
BackgroundColor3 = T.ACCENT_DEEP,
BackgroundTransparency = 1,
BorderSizePixel = 0,
FontFace = T.FONT,
LayoutOrder = i,
Text = name,
TextColor3 = T.TAB_OFF,
TextSize = 12,
Size = UDim2.fromOffset(0, 26),
Parent = root,
}, {
T.corner(7),
mk("UIPadding", {
PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
}),
})
buttons[name] = b
b.Activated:Connect(function()
select(name)
if opts.callback then opts.callback(name) end
end)
end
if opts.items and opts.items[1] then select(tostring(opts.items[1])) end
local h = newHandle("subnav", { root = root })
function h:select(name) select(tostring(name)) end
return h
end
function W.section(parent, opts)
local root = mk("Frame", {
Name = "Section",
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = opts.order or 0,
Parent = parent,
}, {
mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
})
local head = mk("Frame", {
Name = "Head",
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, T.SECTION_H),
LayoutOrder = 1,
Parent = root,
})
local group = mk("Frame", {
Name = "Group",
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = 2,
Parent = root,
}, {
mk("UIListLayout", {
Padding = UDim.new(0, T.GAP),
SortOrder = Enum.SortOrder.LayoutOrder,
}),
})
groups[parent] = group
local text = label(string.upper(tostring(opts.name or "")),
T.SIZE_SECTION, T.SECTION, true)
text.Name = "Label"
text.AnchorPoint = Vector2.new(0, 1)
text.Position = UDim2.new(0, 2, 1, -8)
text.Size = UDim2.new(1, -4, 0, 14)
text.TextYAlignment = Enum.TextYAlignment.Bottom
text.Parent = head
local h = newHandle("section", { root = root, title = text })
h.group = group
function h:set(v) R.set(text, "Text", string.upper(tostring(v))) end
function h:get() return text.Text end
return h
end
function W.label(parent, opts)
local shell = card(parent, {
name = opts.name, description = opts.description, order = opts.order,
reserve = T.VALUE_RESERVE, controlHeight = T.STATUS_H,
})
local cell = mk("Frame", {
Name = "Status",
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -T.CONTROL_INSET, 0.5, 0),
Size = UDim2.fromOffset(T.VALUE_RESERVE, T.STATUS_H),
BackgroundTransparency = 1,
Parent = shell.ctrl,
})
local value = label(tostring(opts.text or ""), T.SIZE_DESC, T.TEXT, true)
value.Name = "Value"
value.AnchorPoint = Vector2.new(1, 0.5)
value.Position = UDim2.new(1, 0, 0.5, 0)
value.Size = UDim2.new(1, -16, 1, 0)
value.TextXAlignment = Enum.TextXAlignment.Right
value.TextTruncate = Enum.TextTruncate.AtEnd
value.Parent = cell
local dot = mk("Frame", {
Name = "Dot",
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -(value.TextBounds.X + 12), 0.5, 0),
Size = UDim2.fromOffset(8, 8),
BackgroundColor3 = T.TEXT,
BorderSizePixel = 0,
Parent = cell,
}, { T.corner(4) })
local function tone(text)
if opts.tone then return opts.tone end
local t = tostring(text):lower()
if t:match("^open") or t:match("^on%f[%A]") or t:match("^ready") or t:match("^unlocked")
or t:match("^active") or t:match("^running") or t:match("^connected") then return "good" end
if t:match("^closed") or t:match("^off%f[%A]") or t:match("^locked") or t:find("expired")
or t:find("failed") or t:find("error") or t:match("^not ") then return "bad" end
return "normal"
end
local TONE = { good = T.GOOD, bad = T.WARN, warn = T.WARN, normal = T.TEXT }
local function place()
local w = math.min(value.TextBounds.X, cell.AbsoluteSize.X - 16)
R.set(dot, "Position", UDim2.new(1, -(w + 12), 0.5, 0))
end
local function paintTone(text)
R.tween(dot, T.FADE, { BackgroundColor3 = TONE[tone(text)] or T.TEXT })
end
value:GetPropertyChangedSignal("TextBounds"):Connect(place)
place()
paintTone(opts.text)
local current = tostring(opts.text or "")
local h = newHandle("label", shell)
function h:set(v)
v = tostring(v)
if v == current then return end
current = v
R.set(value, "Text", v)
paintTone(v)
end
function h:get() return current end
function h:setTone(t) opts.tone = t paintTone(current) end
return h
end
local function directControlText(shell, opts)
local inset = 0
if shell.title then shell.title.Visible = false end
if shell.desc then shell.desc.Visible = false end
local title = label(tostring(opts.name or ""), T.SIZE_ROW, T.TEXT, true)
title.Name = "ControlTitle"
title.Position = UDim2.fromOffset(inset, 0)
title.Size = UDim2.new(1, -(inset + T.CARD_PAD_X + (opts.reserve or 0)
+ T.CONTROL_INSET + T.CARD_GAP), 0, 18)
title.TextYAlignment = Enum.TextYAlignment.Top
title.ZIndex = 12
title.Parent = shell.root
if opts.description and opts.description ~= "" then
local desc = label(tostring(opts.description), T.SIZE_DESC, T.MUTED, false)
desc.Name = "ControlDescription"
desc.Position = UDim2.fromOffset(inset, 21)
desc.Size = UDim2.new(1, -(inset + T.CARD_PAD_X + (opts.reserve or 0)
+ T.CONTROL_INSET + T.CARD_GAP), 0, 16)
desc.TextWrapped = false
desc.TextTruncate = Enum.TextTruncate.AtEnd
desc.TextYAlignment = Enum.TextYAlignment.Top
desc.ZIndex = 12
desc.Parent = shell.root
end
end
function W.button(parent, opts)
local shell = card(parent, {
name = opts.name, description = opts.description, order = opts.order,
reserve = 0, controlHeight = 0,
})
directControlText(shell, {
name = opts.name, description = opts.description,
reserve = 0,
})
local hit = hitbox(shell.root)
R.set(hit, "Size", UDim2.new(1, T.CARD_PAD_X * 2, 1, T.CARD_PAD_Y * 2))
R.set(hit, "Position", UDim2.fromOffset(-T.CARD_PAD_X, -T.CARD_PAD_Y))
makeHoverable(shell, hit)
local h = newHandle("button", shell)
hit.Activated:Connect(function()
if h._dead then return end
if opts.callback then
task.spawn(function() BX.try("ui.button/" .. tostring(opts.name), opts.callback) end)
end
end)
function h:set() end
function h:get() return nil end
return h
end
function W.toggle(parent, opts)
local shell = card(parent, {
name = opts.name, description = opts.description, order = opts.order,
reserve = T.TOGGLE_W, controlHeight = T.TOGGLE_H,
})
directControlText(shell, {
name = opts.name, description = opts.description,
reserve = T.TOGGLE_W,
})
local track = mk("Frame", {
Name = "Track",
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, 0, 0.5, 0),
Size = UDim2.fromOffset(T.TOGGLE_W, T.TOGGLE_H),
BackgroundColor3 = T.ACCENT_D,
BorderSizePixel = 0,
Parent = shell.ctrl,
}, { T.corner(T.TOGGLE_H / 2) })
local knobSize = T.TOGGLE_KNOB
local inset = (T.TOGGLE_H - knobSize) / 2
local knob = mk("Frame", {
Name = "Knob",
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, inset, 0.5, 0),
Size = UDim2.fromOffset(knobSize, knobSize),
BackgroundColor3 = T.WHITE,
BorderSizePixel = 0,
Parent = track,
}, {
T.corner(knobSize / 2),
})
local initialState = opts.value
if initialState == nil then initialState = opts.currentValue end
local state = initialState and true or false
local h = newHandle("toggle", shell)
local hit = hitbox(shell.root)
R.set(hit, "Size", UDim2.new(1, T.CARD_PAD_X * 2, 1, T.CARD_PAD_Y * 2))
R.set(hit, "Position", UDim2.fromOffset(-T.CARD_PAD_X, -T.CARD_PAD_Y))
makeHoverable(shell, hit)
local function paint(animate)
local w = knobSize
local pos = state and UDim2.new(1, -(w + inset), 0.5, 0)
or UDim2.new(0, inset, 0.5, 0)
local size = UDim2.fromOffset(w, knobSize)
local col = state and T.ACCENT or T.ACCENT_D
if animate then
R.tween(knob, 0.16, { Position = pos, Size = size }, Enum.EasingStyle.Cubic,
Enum.EasingDirection.Out)
R.tween(track, 0.16, { BackgroundColor3 = col }, Enum.EasingStyle.Cubic,
Enum.EasingDirection.Out)
else
R.set(knob, "Position", pos)
R.set(knob, "Size", size)
R.set(track, "BackgroundColor3", col)
end
end
paint(false)
hit.InputEnded:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
paint(true)
end)
function h:set(v)
v = v and true or false
if v == state then return end
state = v
paint(true)
end
function h:get() return state end
hit.Activated:Connect(function()
if h._dead then return end
state = not state
paint(true)
if opts.callback then
local v = state
task.spawn(function()
BX.try("ui.toggle/" .. tostring(opts.name), opts.callback, v)
end)
end
end)
return h
end
function W.slider(parent, opts)
local min = tonumber(opts.min) or 0
local max = tonumber(opts.max) or 100
local step = tonumber(opts.step) or 1
if max <= min then max = min + 1 end
local shell = card(parent, {
name = opts.name, description = opts.description, order = opts.order,
reserve = 104, controlHeight = 20,
})
local readout = label("", T.SIZE_DESC, T.MUTED, false)
readout.Name = "Readout"
readout.Size = UDim2.fromScale(1, 1)
readout.TextXAlignment = Enum.TextXAlignment.Right
readout.Parent = shell.ctrl
local barRow = mk("Frame", {
Name = "BarRow",
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 18),
LayoutOrder = 3,
Parent = shell.col,
})
local track = mk("Frame", {
Name = "Track",
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, 0, 0.5, 0),
Size = UDim2.new(1, 0, 0, 5),
BackgroundColor3 = T.TRACK,
BorderSizePixel = 0,
Parent = barRow,
}, { T.corner(3) })
local fill = mk("Frame", {
Name = "Fill",
Size = UDim2.fromScale(0, 1),
BackgroundColor3 = T.ACCENT,
BorderSizePixel = 0,
Parent = track,
}, { T.corner(3) })
local knob = mk("Frame", {
Name = "Knob",
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0, 0.5),
Size = UDim2.fromOffset(14, 14),
BackgroundColor3 = T.WHITE,
BorderSizePixel = 0,
ZIndex = T.OVERLAY_Z + 3,
Parent = track,
}, { T.corner(7) })
local grab = mk("TextButton", {
Name = "Grab",
BackgroundTransparency = 1,
Text = "",
Size = UDim2.new(1, 20, 1, 12),
Position = UDim2.fromOffset(-10, -6),
AutoButtonColor = false,
ZIndex = 6,
Parent = barRow,
})
local value = math.clamp(tonumber(opts.value) or min, min, max)
local function quantise(v)
v = math.clamp(v, min, max)
if step > 0 then v = math.floor((v - min) / step + 0.5) * step + min end
return math.clamp(v, min, max)
end
local function fmt(v)
if step >= 1 then return tostring(math.floor(v + 0.5)) end
return string.format("%.2f", v)
end
local function paint(animate)
local a = (value - min) / (max - min)
if animate then
R.tween(fill, 0.1, { Size = UDim2.fromScale(a, 1) })
R.tween(knob, 0.1, { Position = UDim2.fromScale(a, 0.5) })
else
R.set(fill, "Size", UDim2.fromScale(a, 1))
R.set(knob, "Position", UDim2.fromScale(a, 0.5))
end
R.set(readout, "Text", fmt(value) .. (opts.suffix or ""))
end
paint(false)
local h = newHandle("slider", shell)
function h:set(v)
v = quantise(tonumber(v) or value)
if v == value then return end
value = v
paint(true)
end
function h:get() return value end
local dragging = false
local function fromX(x)
local abs = track.AbsolutePosition.X
local w = math.max(track.AbsoluteSize.X, 1)
return quantise(min + math.clamp((x - abs) / w, 0, 1) * (max - min))
end
local function drive(x, final)
local v = fromX(x)
if v ~= value then
value = v
paint(false)
if opts.callback and opts.live ~= false then
task.spawn(function()
BX.try("ui.slider/" .. tostring(opts.name), opts.callback, v)
end)
end
end
if final and opts.callback and opts.live == false then
task.spawn(function()
BX.try("ui.slider/" .. tostring(opts.name), opts.callback, value)
end)
end
end
grab.InputBegan:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
dragging = true
R.tween(knob, T.FADE, { Size = UDim2.fromOffset(17, 17) })
drive(input.Position.X, false)
end)
UIS.InputChanged:Connect(function(input)
if not dragging or h._dead then return end
if input.UserInputType ~= Enum.UserInputType.MouseMovement
and input.UserInputType ~= Enum.UserInputType.Touch then return end
drive(input.Position.X, false)
end)
UIS.InputEnded:Connect(function(input)
if not dragging then return end
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
dragging = false
R.tween(knob, T.FADE, { Size = UDim2.fromOffset(14, 14) })
drive(input.Position.X, true)
end)
return h
end
function W.input(parent, opts)
local shell = card(parent, {
name = opts.name, description = opts.description, order = opts.order,
reserve = T.VALUE_RESERVE, controlHeight = 30,
})
local box = mk("TextBox", {
Name = "Box",
Size = UDim2.fromScale(1, 1),
BackgroundColor3 = T.PANEL,
BackgroundTransparency = 0.25,
BorderSizePixel = 0,
Text = tostring(opts.value or ""),
PlaceholderText = tostring(opts.placeholder or ""),
PlaceholderColor3 = T.MUTED,
FontFace = T.FONT,
TextSize = T.SIZE_DESC,
TextColor3 = T.TEXT,
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
ClipsDescendants = true,
ClearTextOnFocus = false,
Parent = shell.ctrl,
}, {
T.corner(T.RADIUS_SM),
T.stroke(T.LINE, 1, T.STROKE_REST),
mk("UIPadding", {
PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
}),
})
local h = newHandle("input", shell)
local current = tostring(opts.value or "")
local edge = box:FindFirstChildOfClass("UIStroke")
box.Focused:Connect(function()
if edge then R.tween(edge, T.FADE, { Transparency = T.STROKE_HOVER }) end
end)
box.FocusLost:Connect(function(enterPressed)
if edge then R.tween(edge, T.FADE, { Transparency = T.STROKE_REST }) end
local v = box.Text
if v == current then return end
current = v
if opts.callback then
task.spawn(function()
BX.try("ui.input/" .. tostring(opts.name), opts.callback, v, enterPressed)
end)
end
end)
function h:set(v)
v = (v == nil) and "" or tostring(v)
if v == current then return end
current = v
R.set(box, "Text", v)
end
function h:get() return current end
h.input = box
return h
end
local openDropdown = nil
local scrim, scrimClose = nil, nil
function W.scrim(on, onTap)
if not ctx.overlay then return end
if not scrim or not scrim.Parent then
scrim = mk("TextButton", {
Name = "Scrim",
Text = "",
AutoButtonColor = false,
BackgroundColor3 = T.BLACK,
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = UDim2.fromScale(1, 1),
Visible = false,
ZIndex = T.OVERLAY_Z,
Parent = ctx.overlay,
}, { T.corner(T.RADIUS_WIN) })
scrim.Activated:Connect(function()
if scrimClose then scrimClose() end
end)
end
scrimClose = onTap
if on then
R.set(scrim, "Visible", true)
R.tween(scrim, T.FADE, { BackgroundTransparency = 0.6 })
else
R.tween(scrim, T.FADE, { BackgroundTransparency = 1 })
R.call(function()
task.delay(T.FADE + 0.02, function()
if scrim and scrim.BackgroundTransparency >= 0.99 then scrim.Visible = false end
end)
end)
end
end
function W.setOpenDropdown(h) openDropdown = h end
function W.clearOpenDropdown(h)
if openDropdown == h then openDropdown = nil end
end
function W.closeOpenDropdown(except)
local cur = openDropdown
if cur and cur ~= except and cur.isOpen and cur:isOpen() then
cur:setOpen(false)
end
end
function W.dropdown(parent, opts)
local multi = opts.multi and true or false
local ARROW = 8
local shell = card(parent, {
name = opts.name, description = opts.description, order = opts.order,
reserve = T.SELECT_W, controlHeight = T.SELECT_H, expandable = true,
})
local pill = mk("Frame", {
Name = "Select",
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -T.CONTROL_INSET, 0.5, 0),
Size = UDim2.fromOffset(T.SELECT_W, T.SELECT_H),
BackgroundColor3 = T.SELECT_BG,
BackgroundTransparency = 0.88,
BorderSizePixel = 0,
Parent = shell.ctrl,
}, {
T.corner(T.SELECT_H / 2),
T.stroke(T.SELECT_EDGE, 1, 0.68),
})
local arrowHolder = chevron(pill, ARROW, T.SELECT_TEXT)
arrowHolder.AnchorPoint = Vector2.new(1, 0.5)
arrowHolder.Position = UDim2.new(1, -8, 0.5, 0)
local chosen = label("", T.SIZE_SELECT, T.SELECT_TEXT, true)
chosen.Name = "Chosen"
chosen.AnchorPoint = Vector2.new(0, 0.5)
chosen.Position = UDim2.new(0, 14, 0.5, 0)
chosen.Size = UDim2.new(1, -(14 + ARROW * 2 + 14), 1, 0)
chosen.TextXAlignment = Enum.TextXAlignment.Left
chosen.TextTruncate = Enum.TextTruncate.AtEnd
chosen.Parent = pill
local hit = mk("TextButton", {
Name = "Hit",
BackgroundTransparency = 1,
Text = "",
Size = UDim2.new(1, T.CARD_PAD_X * 2, 0, 0),
Position = UDim2.fromOffset(-T.CARD_PAD_X, -T.CARD_PAD_Y),
AutoButtonColor = false,
ZIndex = 5,
Parent = shell.header,
})
local function fitHit()
R.set(hit, "Size", UDim2.new(1, T.CARD_PAD_X * 2, 0,
shell.col.AbsoluteSize.Y + T.CARD_PAD_Y * 2))
end
shell.col:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitHit)
shell.header:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitHit)
fitHit()
makeHoverable(shell, hit)
local panel = mk("Frame", {
Name = "DropPanel",
BackgroundColor3 = T.ELEMENT,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, 0),
Visible = false,
LayoutOrder = 2,
ZIndex = T.OVERLAY_Z + 1,
ClipsDescendants = true,
Parent = ctx.overlay,
}, {
T.corner(T.RADIUS),
T.stroke(T.LINE, 1, 0.45),
})
T.shadow(panel, T.OVERLAY_SHADOW, 0.45)
local inner = mk("ScrollingFrame", {
Name = "Inner",
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
BorderSizePixel = 0,
ScrollBarThickness = 3,
ScrollBarImageColor3 = T.LINE,
CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollingDirection = Enum.ScrollingDirection.Y,
ZIndex = T.OVERLAY_Z + 2,
Parent = panel,
}, {
mk("UIListLayout", {
Padding = UDim.new(0, 4),
SortOrder = Enum.SortOrder.LayoutOrder,
}),
mk("UIPadding", {
PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
}),
})
local search
local SEARCH_H = 30
local open = false
local wantHeight
local function layoutInner()
local top = 44
R.set(inner, "Position", UDim2.fromOffset(6, 6 + top))
R.set(inner, "Size", UDim2.new(1, -12, 1, -(12 + top)))
end
local SHEET_HEAD = 44
local SHEET_MARGIN = 16
local sheetHead = mk("Frame", {
Name = "SheetHead",
Size = UDim2.new(1, 0, 0, SHEET_HEAD),
BackgroundTransparency = 1,
ZIndex = T.OVERLAY_Z + 2,
Parent = panel,
})
mk("Frame", {
Name = "Grab",
AnchorPoint = Vector2.new(0.5, 0),
Position = UDim2.new(0.5, 0, 0, 8),
Size = UDim2.fromOffset(36, 4),
BackgroundColor3 = T.MUTED,
BackgroundTransparency = 0.5,
BorderSizePixel = 0,
ZIndex = T.OVERLAY_Z + 3,
Parent = sheetHead,
}, { T.corner(2) })
local sheetTitle = label(tostring(opts.name or ""), T.SIZE_ROW, T.TEXT, true)
sheetTitle.Name = "Title"
sheetTitle.Position = UDim2.fromOffset(T.CARD_PAD_X, 16)
sheetTitle.Size = UDim2.new(1, -T.CARD_PAD_X * 2, 0, 24)
sheetTitle.ZIndex = T.OVERLAY_Z + 3
sheetTitle.Parent = sheetHead
local function sheetHeight()
return SHEET_HEAD + wantHeight()
end
local function sheetRest()
return UDim2.new(0, SHEET_MARGIN, 1, -(sheetHeight() + SHEET_MARGIN))
end
local function positionPanel()
R.set(panel, "Position", sheetRest())
R.set(panel, "Size", UDim2.new(1, -SHEET_MARGIN * 2, 0, sheetHeight()))
end
local OPT_H, MAX_SHOWN = 38, 7
local SEARCH_MIN = 8
local query = ""
search = mk("TextBox", {
Name = "Search",
Position = UDim2.fromOffset(6, 6),
Size = UDim2.new(1, -12, 0, SEARCH_H),
BackgroundColor3 = T.WHITE,
BackgroundTransparency = 0.975,
BorderSizePixel = 0,
Text = "",
PlaceholderText = "Search",
PlaceholderColor3 = Color3.fromRGB(129, 123, 140),
FontFace = T.FONT,
TextSize = 11,
TextColor3 = Color3.fromRGB(238, 238, 238),
TextXAlignment = Enum.TextXAlignment.Left,
ClearTextOnFocus = false,
Visible = false,
ZIndex = 4,
Parent = nil,
}, {
T.corner(9),
T.stroke(Color3.fromRGB(139, 111, 177), 1, 0.74),
mk("UIPadding", {
PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
}),
})
search.Parent = panel
local frames, options = {}, {}
local selected = multi and {} or nil
local single = nil
local h = newHandle("dropdown", shell)
local function chosenText()
if multi then
local n, first = 0, nil
for _, o in ipairs(options) do
if selected[o] then n = n + 1 first = first or o end
end
if n == 0 then return opts.placeholder or "SELECT" end
if n == 1 then return first end
return ("%d selected"):format(n)
end
return single or (opts.placeholder or "SELECT")
end
local function isSelected(text)
if multi then return selected[text] == true end
return single == text
end
local paintRows
local function pick(text)
if multi then
selected[text] = (not selected[text]) or nil
else
single = text
end
R.set(chosen, "Text", chosenText())
paintRows()
if not multi then h:setOpen(false) end
if opts.callback then
local payload
if multi then
payload = {}
for _, o in ipairs(options) do
if selected[o] then payload[#payload + 1] = o end
end
else
payload = single
end
task.spawn(function()
BX.try("ui.dropdown/" .. tostring(opts.name), opts.callback, payload)
end)
end
end
local function ensureFrame(i)
local f = frames[i]
if f then return f end
local btn = mk("TextButton", {
Name = "Opt" .. i,
BackgroundColor3 = T.WHITE,
BackgroundTransparency = 0.965,
BorderSizePixel = 0,
Size = UDim2.new(1, -4, 0, OPT_H),
LayoutOrder = i,
AutoButtonColor = false,
Text = "",
ZIndex = T.OVERLAY_Z + 3,
Parent = inner,
}, { T.corner(10), T.stroke(T.WHITE, 1, 0.94) })
local marker = mk("Frame", {
Name = "Check",
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, 12, 0.5, 0),
Size = UDim2.fromOffset(16, 16),
BackgroundColor3 = T.ACCENT,
BackgroundTransparency = 0.94,
BorderSizePixel = 0,
ZIndex = T.OVERLAY_Z + 4,
Parent = btn,
}, { T.corner(5), T.stroke(T.ACCENT, 1, 0.58) })
local txt = label("", 11, T.SELECT_TEXT, true)
txt.Position = UDim2.new(0, 38, 0, 0)
txt.Size = UDim2.new(1, -50, 1, 0)
txt.TextTruncate = Enum.TextTruncate.AtEnd
txt.ZIndex = T.OVERLAY_Z + 4
txt.Parent = btn
f = { btn = btn, txt = txt, marker = marker, text = nil, shown = true }
btn.MouseEnter:Connect(function()
if isSelected(f.text) then return end
R.set(btn, "BackgroundColor3", T.ACCENT_D)
R.set(btn, "BackgroundTransparency", 0.72)
R.set(txt, "TextColor3", T.TEXT)
local edge = btn:FindFirstChildOfClass("UIStroke")
if edge then R.tween(edge, T.FADE, { Color = T.ACCENT, Transparency = 0.5, Thickness = 1.1 }) end
end)
btn.MouseLeave:Connect(function()
if isSelected(f.text) then return end
R.set(btn, "BackgroundColor3", T.PANEL_2)
R.set(btn, "BackgroundTransparency", 0.22)
R.set(txt, "TextColor3", T.TEXT)
local edge = btn:FindFirstChildOfClass("UIStroke")
if edge then R.tween(edge, T.FADE, { Color = T.WHITE, Transparency = 0.94, Thickness = 1 }) end
end)
btn.Activated:Connect(function()
if h._dead or not f.text then return end
pick(f.text)
end)
frames[i] = f
return f
end
paintRows = function()
for i, o in ipairs(options) do
local f = frames[i]
if f then
local on = isSelected(o)
R.set(f.btn, "BackgroundColor3", on and Color3.fromRGB(130, 96, 181) or T.WHITE)
R.set(f.btn, "BackgroundTransparency", on and 0.8 or 0.965)
R.set(f.marker, "BackgroundTransparency", on and 0.66 or 0.94)
local mEdge = f.marker:FindFirstChildOfClass("UIStroke")
if mEdge then
R.set(mEdge, "Color", on and Color3.fromRGB(182, 156, 255) or T.ACCENT)
R.set(mEdge, "Transparency", on and 0 or 0.58)
end
local bEdge = f.btn:FindFirstChildOfClass("UIStroke")
if bEdge then
R.set(bEdge, "Color", on and T.ACCENT or T.WHITE)
R.set(bEdge, "Transparency", on and 0.66 or 0.94)
end
R.set(f.txt, "TextColor3", T.TEXT)
R.set(f.btn, "BackgroundTransparency", on and 0 or 0.22)
R.set(f.btn, "BackgroundColor3", on and T.ACCENT_D or T.PANEL_2)
R.set(f.marker, "BackgroundColor3", on and T.ACCENT or T.PANEL_2)
end
end
end
local function matches(text)
if query == "" then return true end
return tostring(text):lower():find(query, 1, true) ~= nil
end
local function applyFilter()
local n = 0
for i, o in ipairs(options) do
local f = frames[i]
if f then
local vis = matches(o)
f.shown = vis
R.set(f.btn, "Visible", vis)
if vis then n = n + 1 end
end
end
return n
end
wantHeight = function()
local n = 0
for i = 1, #options do
local f = frames[i]
if not f or f.shown ~= false then n = n + 1 end
end
local shown = math.min(math.max(n, 1), MAX_SHOWN)
local base = shown * (OPT_H + 4) + 12
return base
end
search:GetPropertyChangedSignal("Text"):Connect(function()
query = tostring(search.Text):lower()
local n = applyFilter()
if open then
R.tween(panel, T.FADE, { Size = UDim2.new(1, -SHEET_MARGIN * 2, 0, sheetHeight()),
Position = sheetRest() })
end
return n
end)
function h:setOpen(on)
on = on and true or false
if on == open then return end
if on then
open = true
if search.Visible and query ~= "" then
query = ""
R.set(search, "Text", "")
applyFilter()
end
W.closeOpenDropdown(h)
layoutInner()
local hgt = sheetHeight()
R.set(panel, "Size", UDim2.new(1, -SHEET_MARGIN * 2, 0, hgt))
R.set(panel, "Position", UDim2.new(0, SHEET_MARGIN, 1, SHEET_MARGIN))
R.set(panel, "Visible", true)
W.scrim(true, function() h:setOpen(false) end)
R.tween(panel, T.MOVE, { Position = sheetRest() }, T.EASE_UI)
W.setOpenDropdown(h)
else
open = false
W.scrim(false)
R.tween(panel, T.FADE, { Position = UDim2.new(0, SHEET_MARGIN, 1, SHEET_MARGIN) }, T.EASE_UI)
R.call(function()
task.delay(T.FADE + 0.02, function()
if not open then R.set(panel, "Visible", false) end
end)
end)
W.clearOpenDropdown(h)
end
R.set(arrowHolder, "Rotation", on and 180 or 0)
end
function h:isOpen() return open end
shell.root:GetPropertyChangedSignal("Visible"):Connect(function()
if open and not shell.root.Visible then h:setOpen(false) end
end)
hit.Activated:Connect(function()
if h._dead then return end
h:setOpen(not open)
end)
function h:setOptions(newOptions)
if type(newOptions) ~= "table" then return false end
local same = #newOptions == #options
if same then
for i = 1, #newOptions do
if newOptions[i] ~= options[i] then same = false break end
end
end
if same then return true end
options = table.clone(newOptions)
for i = 1, #options do
local f = ensureFrame(i)
if f.text ~= options[i] then
f.text = options[i]
R.set(f.txt, "Text", options[i])
end
R.set(f.btn, "Visible", true)
end
for i = #options + 1, #frames do
frames[i].text = nil
R.set(frames[i].btn, "Visible", false)
end
if multi then
local keep = {}
for _, o in ipairs(options) do
if selected[o] then keep[o] = true end
end
selected = keep
elseif single and not table.find(options, single) then
single = nil
end
R.set(search, "Visible", false)
layoutInner()
applyFilter()
R.set(chosen, "Text", chosenText())
paintRows()
if open then
open = false
h:setOpen(true)
end
return true
end
function h:set(v)
if multi then
local want = {}
if type(v) == "table" then
for _, o in ipairs(v) do want[o] = true end
elseif v ~= nil then
want[v] = true
end
selected = want
else
single = (v ~= nil) and tostring(v) or nil
end
R.set(chosen, "Text", chosenText())
paintRows()
end
function h:get()
if multi then
local out = {}
for _, o in ipairs(options) do
if selected[o] then out[#out + 1] = o end
end
return out
end
return single
end
function h:options() return table.clone(options) end
h:setOptions(opts.options or {})
local initialOption = opts.value
if initialOption == nil then initialOption = opts.currentOption end
if initialOption ~= nil then h:set(initialOption) end
R.set(chosen, "Text", chosenText())
return h
end
function W.richCard(parent, opts)
local root = mk("Frame", {
Name = "Rich_" .. tostring(opts.name or "?"),
BackgroundColor3 = T.WHITE,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = opts.order or 0,
Parent = parent,
}, {
T.corner(T.RADIUS),
T.gradient(ColorSequence.new(T.COMMUNITY_TOP, T.COMMUNITY_BOT), T.CARD_ROT),
T.stroke(T.COMMUNITY_EDGE, 1, 0),
mk("UIPadding", {
PaddingLeft = UDim.new(0, T.CARD_PAD_X), PaddingRight = UDim.new(0, T.CARD_PAD_X),
PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14),
}),
mk("UIListLayout", {
Padding = UDim.new(0, 10),
SortOrder = Enum.SortOrder.LayoutOrder,
}),
})
local title = label(opts.name, opts.titleSize or T.SIZE_CARD_TITLE, T.CARD_TITLE, true)
title.Size = UDim2.new(1, 0, 0, 0)
title.AutomaticSize = Enum.AutomaticSize.Y
title.TextYAlignment = Enum.TextYAlignment.Top
title.LayoutOrder = 1
title.Parent = root
local body = label(tostring(opts.text or ""), opts.textSize or T.SIZE_DESC, T.MUTED, false)
body.Size = UDim2.new(1, 0, 0, 0)
body.AutomaticSize = Enum.AutomaticSize.Y
body.TextWrapped = true
body.TextYAlignment = Enum.TextYAlignment.Top
body.LayoutOrder = 2
body.Parent = root
local h = newHandle("richCard", { root = root, title = title, desc = body })
if opts.action then
local cta = mk("TextButton", {
Name = "Action",
Text = "",
AutoButtonColor = false,
BackgroundColor3 = T.WHITE,
BorderSizePixel = 0,
Size = UDim2.fromOffset(0, 40),
AutomaticSize = Enum.AutomaticSize.X,
LayoutOrder = 3,
Parent = root,
}, {
T.corner(20),
mk("UIPadding", {
PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18),
}),
})
local ctaLabel = label(tostring(opts.action.label or "Open"), opts.action.textSize or 14,
T.PANEL, true)
ctaLabel.Size = UDim2.fromOffset(0, 40)
ctaLabel.AutomaticSize = Enum.AutomaticSize.X
ctaLabel.Parent = cta
cta.MouseEnter:Connect(function()
R.tween(cta, T.FADE, { BackgroundColor3 = Color3.fromRGB(232, 232, 236) })
end)
cta.MouseLeave:Connect(function()
R.tween(cta, T.FADE, { BackgroundColor3 = T.WHITE })
end)
cta.MouseButton1Down:Connect(function()
R.tween(cta, 0.08, { BackgroundColor3 = Color3.fromRGB(226, 226, 231) },
Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
end)
cta.MouseButton1Up:Connect(function()
R.tween(cta, 0.14, { BackgroundColor3 = T.WHITE },
Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
end)
cta.Activated:Connect(function()
if opts.action.callback then
task.spawn(function()
BX.try("ui.richCard/" .. tostring(opts.action.label),
opts.action.callback)
end)
end
end)
h.action = cta
end
function h:set(v) R.set(body, "Text", tostring(v)) end
function h:get() return body.Text end
return h
end
function W.listCard(parent, opts)
local root = mk("Frame", {
Name = "List_" .. tostring(opts.name or "?"),
BackgroundColor3 = T.WHITE,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = opts.order or 0,
Parent = parent,
}, {
T.corner(T.RADIUS),
T.gradient(ColorSequence.new(T.UPDATE_TOP, T.UPDATE_BOT), T.CARD_ROT),
T.stroke(T.CARD_EDGE, 1, 0),
mk("UIPadding", {
PaddingLeft = UDim.new(0, T.CARD_PAD_X), PaddingRight = UDim.new(0, T.CARD_PAD_X),
PaddingTop = UDim.new(0, T.CARD_PAD_Y), PaddingBottom = UDim.new(0, T.CARD_PAD_Y),
}),
mk("UIListLayout", {
Padding = UDim.new(0, 12),
SortOrder = Enum.SortOrder.LayoutOrder,
}),
})
local head = mk("Frame", {
Name = "Head",
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 24),
LayoutOrder = 1,
Parent = root,
})
local title = label(opts.name, opts.titleSize or T.SIZE_CARD_TITLE, T.TEXT, true)
title.Size = UDim2.new(1, -120, 1, 0)
title.Parent = head
if opts.badge then
local bl = label(string.upper(tostring(opts.badge)), opts.badgeSize or 10, T.MUTED, true)
bl.Name = "Badge"
bl.AnchorPoint = Vector2.new(1, 0.5)
bl.Position = UDim2.new(1, 0, 0.5, 0)
bl.Size = UDim2.fromOffset(0, 20)
bl.AutomaticSize = Enum.AutomaticSize.X
bl.TextXAlignment = Enum.TextXAlignment.Right
bl.Parent = head
end
local list = mk("Frame", {
Name = "Rows",
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = 2,
Parent = root,
}, {
mk("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
})
local rows = opts.rows or {}
for i, row in ipairs(rows) do
local line = mk("Frame", {
Name = "Row" .. i,
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 34),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = i,
Parent = list,
}, {
mk("UIPadding", {
PaddingTop = UDim.new(0, 7), PaddingBottom = UDim.new(0, 7),
}),
})
local tag = label(string.upper(tostring(row[1])), opts.tagSize or 9, T.ROW_TAG, true)
tag.Position = UDim2.fromOffset(0, 0)
tag.Size = UDim2.new(0, 70, 0, 20)
tag.TextYAlignment = Enum.TextYAlignment.Top
tag.Parent = line
local body = label(tostring(row[2]), opts.rowTextSize or 12,
(i == #rows) and T.ROW_TEXT_LAST or T.ROW_TEXT, false)
body.Position = UDim2.fromOffset(80, 0)
body.Size = UDim2.new(1, -80, 0, 0)
body.AutomaticSize = Enum.AutomaticSize.Y
body.TextWrapped = true
body.TextYAlignment = Enum.TextYAlignment.Top
body.Parent = line
if i < #rows then
mk("Frame", {
Name = "Rule",
AnchorPoint = Vector2.new(0, 1),
Position = UDim2.new(0, 80, 1, 0),
Size = UDim2.new(1, -80, 0, 1),
BackgroundColor3 = T.WHITE,
BackgroundTransparency = 0.955,
BorderSizePixel = 0,
Parent = line,
})
end
end
local h = newHandle("listCard", { root = root, title = title })
function h:set() end
function h:get() return nil end
return h
end
function W.popover(anchor, items, opts)
opts = opts or {}
local width = opts.width or 200
local ROW, PADV = 34, 6
local panel = mk("Frame", {
Name = "Popover",
BackgroundColor3 = T.ELEMENT,
BorderSizePixel = 0,
Size = UDim2.fromOffset(width, 0),
Visible = false,
ClipsDescendants = true,
ZIndex = T.OVERLAY_Z + 10,
Parent = ctx.overlay,
}, {
T.corner(T.RADIUS),
T.stroke(T.LINE, 1, 0.4),
mk("UIListLayout", {
Padding = UDim.new(0, 2),
SortOrder = Enum.SortOrder.LayoutOrder,
}),
mk("UIPadding", {
PaddingTop = UDim.new(0, PADV), PaddingBottom = UDim.new(0, PADV),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
}),
})
T.shadow(panel, T.OVERLAY_SHADOW, 0.4)
local h = { _open = false }
local rows = 0
for i, item in ipairs(items or {}) do
if item.divider then
rows = rows + 1
mk("Frame", {
Name = "Divider",
Size = UDim2.new(1, 0, 0, 1),
BackgroundColor3 = T.LINE,
BackgroundTransparency = 0.4,
BorderSizePixel = 0,
LayoutOrder = i,
ZIndex = T.OVERLAY_Z + 11,
Parent = panel,
})
else
rows = rows + 1
local tone = (item.tone == "warn" and T.WARN)
or (item.tone == "muted" and T.MUTED) or T.TEXT
local btn = mk("TextButton", {
Name = "Item" .. i,
Text = "",
AutoButtonColor = false,
BackgroundColor3 = T.ELEMENT_H,
BackgroundTransparency = 1,
BorderSizePixel = 0,
Size = UDim2.new(1, 0, 0, ROW),
LayoutOrder = i,
ZIndex = T.OVERLAY_Z + 11,
Parent = panel,
}, { T.corner(T.RADIUS_SM) })
local txt = label(tostring(item.text or ""), T.SIZE_DESC, tone, false)
txt.Position = UDim2.new(0, 10, 0, 0)
txt.Size = UDim2.new(1, -20, 1, 0)
txt.ZIndex = T.OVERLAY_Z + 12
txt.Parent = btn
btn.MouseEnter:Connect(function()
R.tween(btn, T.FADE, { BackgroundTransparency = 0 })
local edge = btn:FindFirstChildOfClass("UIStroke")
if edge then R.tween(edge, T.FADE, { Color = T.ACCENT, Transparency = 0.5, Thickness = 1.1 }) end
end)
btn.MouseLeave:Connect(function()
R.tween(btn, T.FADE, { BackgroundTransparency = 1 })
local edge = btn:FindFirstChildOfClass("UIStroke")
if edge then R.tween(edge, T.FADE, { Color = T.WHITE, Transparency = 0.94, Thickness = 1 }) end
end)
btn.Activated:Connect(function()
h:setOpen(false)
if item.callback then
task.spawn(function()
BX.try("ui.popover/" .. tostring(item.text), item.callback)
end)
end
end)
end
end
local function contentHeight()
local n, dividers = 0, 0
for _, item in ipairs(items or {}) do
if item.divider then dividers = dividers + 1 else n = n + 1 end
end
return n * ROW + dividers * 1 + (rows - 1) * 2 + PADV * 2
end
function h:setOpen(on)
on = on and true or false
if on == h._open then return end
if on and not (ctx.overlay and ctx.root and anchor) then return end
h._open = on
if on then
W.closeOpenDropdown(nil)
local k = scaleK()
local a, rootAbs = anchor.AbsolutePosition, ctx.root.AbsolutePosition
local x = (a.X - rootAbs.X) / k
local y = (a.Y - rootAbs.Y) / k
local aH = anchor.AbsoluteSize.Y / k
local wantH = contentHeight()
local top = (opts.align == "above") and (y - wantH - 8) or (y + aH + 8)
R.set(panel, "Visible", true)
R.set(panel, "Position", UDim2.fromOffset(x, top + 6))
R.set(panel, "Size", UDim2.fromOffset(width, 0))
R.tween(panel, T.MOVE, {
Size = UDim2.fromOffset(width, wantH),
Position = UDim2.fromOffset(x, top),
}, T.EASE_UI)
else
R.tween(panel, T.MOVE, { Size = UDim2.fromOffset(width, 0) })
R.call(function()
task.delay(T.MOVE, function()
if not h._open then R.set(panel, "Visible", false) end
end)
end)
end
end
function h:isOpen() return h._open end
function h:toggle() h:setOpen(not h._open) end
function h:destroy() R.call(function() panel:Destroy() end) end
return h
end
function W.row(parent, opts)
local group, grouped = groupFor(parent)
if group then parent = group end
local root = mk("Frame", {
Name = "Row",
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = (opts and opts.order) or 0,
Parent = parent,
}, {
mk("UIListLayout", {
FillDirection = Enum.FillDirection.Horizontal,
Padding = UDim.new(0, T.GAP),
SortOrder = Enum.SortOrder.LayoutOrder,
VerticalAlignment = Enum.VerticalAlignment.Top,
}),
})
local h = newHandle("row", { root = root })
local cells = {}
local function cell()
local c = mk("Frame", {
Name = "Cell" .. (#cells + 1),
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 0),
AutomaticSize = Enum.AutomaticSize.Y,
LayoutOrder = #cells + 1,
Parent = root,
})
cells[#cells + 1] = c
local n = #cells
for _, existing in ipairs(cells) do
R.set(existing, "Size",
UDim2.new(1 / n, -(T.GAP * (n - 1)) / n, 0, 0))
end
return c
end
function h:toggle(o) return W.toggle(cell(), o) end
function h:button(o) return W.button(cell(), o) end
function h:label(o)  return W.label(cell(), o) end
return h
end
return W
end)
BX.module("ui.lib", function(BX)
local svc = BX.require("core.services")
local exec = BX.require("core.exec")
local dev = BX.require("core.device")
local T   = BX.require("ui.lib.theme")
local R   = BX.require("ui.lib.render")
local W   = BX.require("ui.lib.widgets")
local log = BX.require("boot.log").for_module("ui.lib")
local M = {}
M.theme, M.render, M.widgets = T, R, W
local notifier = nil
function M.setNotifier(fn) notifier = fn end
local function islandNotify(title, body, o)
local island = BX._loaded["ui.island"]
if not island then
local ok, mod = pcall(BX.require, "ui.island")
island = ok and mod or nil
end
if not island or type(island.show) ~= "function" then return false end
island.show(o.key or "notify", {
title = tostring(title or "VoidcxzHub"),
sub = body and tostring(body) or nil,
tone = o.tone or "normal",
hold = o.hold or 4,
pulse = o.pulse,
})
return true
end
function M.notify(title, body, o)
o = o or {}
if notifier then
return (BX.try("ui.notify", notifier, title, body, o))
end
local ok = BX.try("ui.notify.island", islandNotify, title, body, o)
if not ok then
log.info("notify (no surface): %s - %s", tostring(title), tostring(body))
end
return ok
end
function M.build(fn, timeout) return R.build(fn, timeout) end
local UIS = svc.UserInputService
local mk = W.mk
function M.window(opts)
opts = opts or {}
R.start()
local windowScope = BX.scope("ui.lib.window")
local initialViewport = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize)
or Vector2.new(0, 0)
local mobileLandscape = dev.isTouch and initialViewport.X > initialViewport.Y * 1.18
local narrow = dev.smallScreen or (dev.isTouch and not mobileLandscape)
local topTabs = not narrow
local wantW = opts.width or (narrow and T.WIN_W_NARROW or T.WIN_W)
local wantH = opts.height or (narrow and T.WIN_H_NARROW or T.WIN_H)
local gui = mk("ScreenGui", {
Name = opts.guiName or ("Voidcxz_" .. tostring(math.random(1e6, 9e6))),
ResetOnSpawn = false,
ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
DisplayOrder = 1000,
IgnoreGuiInset = true,
})
gui.Parent = exec.hiddenParent()
local dim = mk("Frame", {
Name = "Backdrop",
Size = UDim2.fromScale(1, 1),
BackgroundColor3 = T.BLACK,
BackgroundTransparency = 1,
BorderSizePixel = 0,
Active = false,
ZIndex = 0,
Parent = gui,
}, {
mk("UIGradient", { Rotation = 90, Transparency = T.DIM_GRADIENT }),
})
local sideW     = (narrow or topTabs) and 0 or T.SIDE_W
local sideGap   = narrow and 0 or T.SIDE_COL_GAP
local searchH   = 0
local searchGap = 0
local fullW = wantW
local fullH = wantH
local holder = mk("Frame", {
Name = "Holder",
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(fullW, fullH),
BackgroundTransparency = 1,
Parent = gui,
})
local fit = T.fitScale(fullW, fullH)
local scale = mk("UIScale", { Scale = fit, Parent = holder })
local root = mk("Frame", {
Name = "Window",
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromScale(1, 1),
BackgroundColor3 = T.PANEL,
BackgroundTransparency = 0.18,
BorderSizePixel = 0,
Active = true,
ClipsDescendants = true,
Parent = holder,
}, {
T.corner(T.RADIUS_WIN),
})
local shadow = T.shadow(root, T.SHADOW_BLUR, T.SHADOW_ALPHA)
local overlay = mk("Frame", {
Name = "Overlay",
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
ClipsDescendants = false,
ZIndex = T.OVERLAY_Z,
Parent = root,
})
W.setContext({ overlay = overlay, scale = scale, root = root })
local win = {}
local bar = mk("Frame", {
Name = "TitleBar",
Size = UDim2.new(1, 0, 0, T.TITLEBAR_H),
BackgroundTransparency = 1,
Active = true,
ZIndex = 2,
Parent = root,
})
local logo = mk("ImageLabel", {
Name = "Logo",
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, T.TITLEBAR_PAD_X, 0.5, 0),
Size = UDim2.fromOffset(T.LOGO_SIZE, T.LOGO_SIZE),
BackgroundTransparency = 1,
Image = T.asset(T.LOGO_FILE, T.LOGO_FLAT),
ImageColor3 = T.WHITE,
ScaleType = Enum.ScaleType.Fit,
Parent = bar,
})
local lockup = mk("Frame", {
Name = "Lockup",
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, T.TITLEBAR_PAD_X + 38, 0.5, 0),
Size = UDim2.fromOffset(0, 40),
AutomaticSize = Enum.AutomaticSize.X,
BackgroundTransparency = 1,
Visible = not topTabs,
Parent = bar,
}, {
mk("UIListLayout", {
Padding = UDim.new(0, 1),
SortOrder = Enum.SortOrder.LayoutOrder,
VerticalAlignment = Enum.VerticalAlignment.Center,
}),
})
local title = mk("TextLabel", {
Name = "Title",
BackgroundTransparency = 1,
Text = tostring(opts.title or "VoidcxzHub"),
FontFace = T.FONT_TITLE or T.FONT_BOLD,
TextSize = T.SIZE_TITLE,
TextColor3 = T.WHITE,
TextXAlignment = Enum.TextXAlignment.Left,
Size = UDim2.fromOffset(0, 22),
AutomaticSize = Enum.AutomaticSize.X,
Visible = false,
LayoutOrder = 1,
Parent = lockup,
}, {
T.gradient(T.WORDMARK_GLASS, T.GLASS_ROT),
mk("UIStroke", {
ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
Color = T.GLASS_EDGE,
Transparency = T.GLASS_EDGE_ALPHA,
Thickness = 0.6,
}),
})
BX.try("ui.lib.glass", function()
local g = title:FindFirstChildOfClass("UIGradient")
if not g then return end
g.Offset = Vector2.new(-0.6, 0)
R.call(function()
svc.TweenService:Create(g, TweenInfo.new(T.GLASS_SWEEP,
Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
{ Offset = Vector2.new(0.6, 0) }):Play()
end)
end)
mk("TextLabel", {
Name = "Subtitle",
BackgroundTransparency = 1,
Text = tostring(opts.subtitle or ""),
FontFace = T.FONT,
TextSize = T.SIZE_SUB,
TextColor3 = T.MUTED,
TextXAlignment = Enum.TextXAlignment.Left,
Size = UDim2.fromOffset(0, 16),
AutomaticSize = Enum.AutomaticSize.X,
Visible = opts.subtitle ~= nil and not topTabs,
LayoutOrder = 2,
Parent = lockup,
})
local badgePill = nil
if opts.badge then
local pill = mk("Frame", {
Name = "Badge",
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, 0, 0.5, 0),
Size = UDim2.fromOffset(0, 32),
AutomaticSize = Enum.AutomaticSize.X,
BackgroundColor3 = T.ACCENT_D,
BackgroundTransparency = 0.16,
BorderSizePixel = 0,
Parent = bar,
}, {
T.corner(16),
T.stroke(T.ACCENT, 1, 0.28),
mk("UIPadding", {
PaddingLeft = UDim.new(0, 13), PaddingRight = UDim.new(0, 13),
}),
})
mk("TextLabel", {
BackgroundTransparency = 1,
Text = tostring(opts.badge),
FontFace = T.FONT_TITLE or T.FONT_BOLD,
TextSize = T.SIZE_VERSION_TAG,
TextColor3 = T.WHITE,
Size = UDim2.fromOffset(0, 32),
AutomaticSize = Enum.AutomaticSize.X,
Parent = pill,
})
local function fitPill()
local x
if topTabs then
x = T.TITLEBAR_PAD_X + T.LOGO_SIZE + 4
else
x = T.TITLEBAR_PAD_X + 38 + lockup.AbsoluteSize.X + 12
end
R.set(pill, "Position", UDim2.new(0, x, 0.5, 0))
end
if not topTabs then lockup:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitPill) end
fitPill()
badgePill = pill
end
local controls = mk("Frame", {
Name = "Controls",
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -(T.PAD - 8), 0.5, 0),
Size = UDim2.fromOffset(0, 32),
AutomaticSize = Enum.AutomaticSize.X,
BackgroundTransparency = 1,
Parent = bar,
}, {
mk("UIListLayout", {
FillDirection = Enum.FillDirection.Horizontal,
Padding = UDim.new(0, 2),
SortOrder = Enum.SortOrder.LayoutOrder,
VerticalAlignment = Enum.VerticalAlignment.Center,
}),
})
local ctlButtons = {}
local function iconButton(order, draw, o)
o = o or {}
local b = mk("TextButton", {
Name = "Ctl" .. order,
Text = "",
AutoButtonColor = false,
BackgroundTransparency = 1,
Size = UDim2.fromOffset(24, 24),
LayoutOrder = order,
Parent = controls,
})
local disc = mk("Frame", {
Name = "Disc",
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(22, 22),
BackgroundColor3 = o.tint or T.TEXT,
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = b,
}, { T.corner(6) })
local press = mk("UIScale", { Scale = 1, Parent = b })
local marks = draw(b)
local hover, held = false, false
local restWash = 0.92
local function paint()
local on = hover or held
R.tween(disc, T.FADE, { BackgroundTransparency = on and restWash or 1 })
for _, m in ipairs(marks) do
R.tween(m, T.FADE, { BackgroundColor3 = on and T.WHITE or T.MUTED })
if o.spin then
R.tween(m, 0.2, { Rotation = m:GetAttribute("rest") + (on and o.spin or 0) })
elseif o.widen then
R.tween(m, 0.2, { Size = UDim2.fromOffset(on and o.widen or 13, 1.6) })
end
end
end
for _, m in ipairs(marks) do m:SetAttribute("rest", m.Rotation) end
b.MouseEnter:Connect(function() hover = true paint() end)
b.MouseLeave:Connect(function() hover = false held = false paint()
R.tween(press, 0.22, { Scale = 1 }, Enum.EasingStyle.Back) end)
b.InputBegan:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
held = true
R.tween(press, 0.06, { Scale = 0.86 }, Enum.EasingStyle.Quad)
paint()
end)
b.InputEnded:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
held = false
R.tween(press, 0.22, { Scale = 1 }, Enum.EasingStyle.Back)
paint()
end)
ctlButtons[#ctlButtons + 1] = { button = b, disc = disc, marks = marks }
return b
end
local function fadeControls(on, t)
for _, c in ipairs(ctlButtons) do
for _, m in ipairs(c.marks) do
R.tween(m, t or 0.1, { BackgroundTransparency = on and 0 or 1 })
end
if not on then R.tween(c.disc, t or 0.1, { BackgroundTransparency = 1 }) end
end
end
local function barMark(parent, rot)
return mk("Frame", {
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(10, 1.4),
BackgroundColor3 = T.MUTED,
BorderSizePixel = 0,
Rotation = rot,
Parent = parent,
}, { T.corner(1) })
end
local minBtn = iconButton(1, function(b) return { barMark(b, 0) } end, { widen = 11 })
local closeBtn = iconButton(2, function(b)
return { barMark(b, 45), barMark(b, -45) }
end, {})
local capsuleSlot = mk("Frame", {
Name = "CapsuleSlot",
AnchorPoint = Vector2.new(0.5, 0),
Position = UDim2.new(0.5, 0, 0, 2),
Size = UDim2.fromOffset(320, 46),
BackgroundTransparency = 1,
Parent = bar,
})
win.capsuleSlot = capsuleSlot
local railW = (narrow or topTabs) and 0 or sideW
local railH = narrow and T.TABBAR_H or 0
local function column(name, xOffset)
return mk("ScrollingFrame", {
Name = name,
Position = topTabs and UDim2.fromOffset(0, T.TITLEBAR_H)
or UDim2.fromOffset(xOffset, 0),
Size = topTabs
and UDim2.new(1, 0, 0, railH)
or UDim2.new(0, sideW, 1, -(searchH + searchGap)
- (opts.user and T.USER_CHIP_H or 0)),
BackgroundTransparency = 1,
BorderSizePixel = 0,
ScrollBarThickness = 0,
CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollingDirection = Enum.ScrollingDirection.Y,
Parent = root,
}, {
mk("UIListLayout", {
FillDirection = topTabs and Enum.FillDirection.Horizontal
or Enum.FillDirection.Vertical,
HorizontalAlignment = Enum.HorizontalAlignment.Center,
VerticalAlignment = topTabs and Enum.VerticalAlignment.Center
or Enum.VerticalAlignment.Top,
Padding = UDim.new(0, topTabs and T.TAB_GAP or T.SIDE_GAP),
SortOrder = Enum.SortOrder.LayoutOrder,
}),
mk("UIPadding", {
PaddingTop = UDim.new(0, topTabs and 0 or T.TITLEBAR_H + 10),
PaddingLeft = UDim.new(0, topTabs and 18 or 8),
PaddingRight = UDim.new(0, topTabs and 18 or 8),
}),
})
end
local rail, railRight
local topTabBed = nil
local sidebarFade = nil
if narrow or topTabs then
if topTabs then
topTabBed = mk("Frame", {
Name = "TabButtonContainer",
Position = UDim2.fromOffset(T.TITLEBAR_PAD_X + T.LOGO_SIZE + 4, 8),
Size = UDim2.fromOffset(8, 40),
BackgroundColor3 = T.BLACK,
BackgroundTransparency = 0.76,
BorderSizePixel = 0,
Parent = root,
}, { T.corner(12) })
end
rail = mk("ScrollingFrame", {
Name = "Tabs",
Position = topTabs and UDim2.fromOffset(T.TITLEBAR_PAD_X + T.LOGO_SIZE + 8, 8)
or UDim2.new(0, 0, 0, T.TITLEBAR_H + 1),
Size = topTabs and UDim2.new(1, -(T.TITLEBAR_PAD_X + T.LOGO_SIZE + 150), 0, 40)
or UDim2.new(1, 0, 0, railH),
BackgroundTransparency = 1,
BorderSizePixel = 0,
ScrollBarThickness = 0,
CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.X,
ScrollingDirection = Enum.ScrollingDirection.X,
Parent = root,
}, {
mk("UIListLayout", {
FillDirection = Enum.FillDirection.Horizontal,
VerticalAlignment = topTabs and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Center,
Padding = UDim.new(0, T.TAB_GAP),
SortOrder = Enum.SortOrder.LayoutOrder,
}),
mk("UIPadding", {
PaddingTop = UDim.new(0, topTabs and 4 or 14),
PaddingLeft = UDim.new(0, topTabs and 0 or 14),
PaddingRight = UDim.new(0, topTabs and 0 or 14),
PaddingBottom = UDim.new(0, topTabs and 4 or 14),
}),
})
if topTabs and topTabBed then
local list = rail:FindFirstChildOfClass("UIListLayout")
local function fitTopTabBed()
if list then
R.set(topTabBed, "Size", UDim2.fromOffset(list.AbsoluteContentSize.X + 8, 40))
end
end
if list then
list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(fitTopTabBed)
end
fitTopTabBed()
end
elseif not topTabs then
local railBg = mk("Frame", {
Name = "RailBg",
Position = UDim2.fromOffset(0, 0),
Size = UDim2.new(0, sideW, 1, 0),
BackgroundColor3 = T.RAIL_BG,
BorderSizePixel = 0,
ZIndex = 0,
Parent = root,
}, { T.corner(T.RADIUS_WIN) })
for _, spec in ipairs({ { "SquareTR", Vector2.new(1, 0), UDim2.new(1, 0, 0, 0) },
{ "SquareBR", Vector2.new(1, 1), UDim2.new(1, 0, 1, 0) } }) do
mk("Frame", {
Name = spec[1], AnchorPoint = spec[2], Position = spec[3],
Size = UDim2.fromOffset(T.RADIUS_WIN, T.RADIUS_WIN),
BackgroundColor3 = T.RAIL_BG, BorderSizePixel = 0, ZIndex = 0,
Parent = railBg,
})
end
rail = column("TabsLeft", 0)
railRight = nil
end
if not narrow and not topTabs then
sidebarFade = mk("Frame", {
Name = "SidebarFade",
AnchorPoint = Vector2.new(0, 1),
Position = UDim2.new(0, 0, 1, 0),
Size = UDim2.new(0, sideW, 0, T.FADE_H),
BackgroundColor3 = T.WHITE,
BorderSizePixel = 0,
Active = false,
ZIndex = 6,
Parent = root,
}, {
T.corner(T.RADIUS_WIN),
T.gradient(ColorSequence.new(T.RAIL_BG, T.RAIL_BG), 90,
NumberSequence.new({
NumberSequenceKeypoint.new(0, 1),
NumberSequenceKeypoint.new(0.35, 0.85),
NumberSequenceKeypoint.new(0.7, 0.35),
NumberSequenceKeypoint.new(1, 0),
}))
})
end
if not narrow then
mk("Frame", {
Name = "SidebarDivider",
Position = UDim2.fromOffset(railW, T.TITLEBAR_H),
Size = UDim2.new(0, 1, 1, -T.TITLEBAR_H),
BackgroundColor3 = T.WHITE,
BackgroundTransparency = 0.93,
BorderSizePixel = 0,
ZIndex = 2,
Parent = root,
})
end
if false and not narrow then
local _ = nil
if opts.user then
local chip = mk("TextButton", {
Name = "UserChip",
Text = "",
AutoButtonColor = false,
AnchorPoint = Vector2.new(0, 1),
Position = UDim2.new(0, 2, 0, wantH - 4),
Size = UDim2.new(0, railW - 4, 0, T.USER_CHIP_H),
BackgroundColor3 = T.WHITE,
BackgroundTransparency = 0.957,
BorderSizePixel = 0,
Parent = root,
}, {
T.corner(T.USER_CHIP_RADIUS),
T.stroke(T.WHITE, 1, 0.9),
})
chip.MouseEnter:Connect(function()
R.tween(chip, T.FADE, { BackgroundTransparency = 0.94 })
end)
chip.MouseLeave:Connect(function()
R.tween(chip, T.FADE, { BackgroundTransparency = 0.957 })
end)
win.userChip = chip
R.set(chip, "ZIndex", 4)
local COLLAPSED, EXPANDED = T.USER_CHIP_H, 96
local DETAILS_H = 38
local expanded = false
R.set(chip, "ClipsDescendants", true)
mk("UIListLayout", {
SortOrder = Enum.SortOrder.LayoutOrder,
Padding = UDim.new(0, 0),
Parent = chip,
})
mk("UIPadding", {
PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6),
Parent = chip,
})
local details = mk("Frame", {
Name = "Details",
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 0),
LayoutOrder = 1,
Visible = false,
Parent = chip,
}, {
mk("UIListLayout", {
SortOrder = Enum.SortOrder.LayoutOrder,
Padding = UDim.new(0, 3),
}),
mk("UIPadding", {
PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4),
}),
})
local function detailRow(order, key, value)
local row = mk("Frame", {
Name = key,
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 14),
LayoutOrder = order,
Parent = details,
})
mk("TextLabel", {
BackgroundTransparency = 1,
Text = key,
FontFace = T.FONT,
TextSize = 10,
TextColor3 = Color3.fromRGB(143, 137, 152),
TextXAlignment = Enum.TextXAlignment.Left,
Size = UDim2.new(0.5, 0, 1, 0),
Parent = row,
})
local val = mk("TextLabel", {
Name = "Value",
BackgroundTransparency = 1,
Text = tostring(value),
FontFace = T.FONT_BOLD,
TextSize = 10,
TextColor3 = Color3.fromRGB(217, 211, 225),
TextXAlignment = Enum.TextXAlignment.Right,
TextTruncate = Enum.TextTruncate.AtEnd,
AnchorPoint = Vector2.new(1, 0),
Position = UDim2.new(1, 0, 0, 0),
Size = UDim2.new(0.55, 0, 1, 0),
Parent = row,
})
return val
end
local execName = "Unknown"
BX.try("ui.lib.chipExec", function()
local n = exec.name
if type(n) == "string" and #n > 0 then execName = n end
end)
local deviceName = "PC"
BX.try("ui.lib.chipDevice", function()
if dev.isTouch then
deviceName = dev.smallScreen and "Phone" or "Tablet"
end
end)
detailRow(1, "Executor", execName)
detailRow(2, "Device", deviceName)
local base = mk("Frame", {
Name = "Base",
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 38),
LayoutOrder = 2,
Parent = chip,
})
mk("ImageLabel", {
Name = "Avatar",
AnchorPoint = Vector2.new(0, 0.5),
Position = UDim2.new(0, 8, 0.5, 0),
Size = UDim2.fromOffset(34, 34),
BackgroundColor3 = T.WHITE,
BorderSizePixel = 0,
Image = tostring(opts.userImage or ""),
Parent = base,
}, {
T.corner(17),
T.gradient(ColorSequence.new(
Color3.fromRGB(74, 70, 84), Color3.fromRGB(36, 33, 42)), 55),
T.stroke(T.WHITE, 1, 0.84),
})
local realName = tostring(opts.user)
local masked = string.rep("*", math.clamp(#realName, 6, 12))
local revealed = false
local nameLabel = mk("TextLabel", {
Name = "Name",
BackgroundTransparency = 1,
Text = masked,
FontFace = T.FONT_BOLD,
TextSize = 12,
TextColor3 = Color3.fromRGB(232, 230, 237),
TextXAlignment = Enum.TextXAlignment.Left,
TextTruncate = Enum.TextTruncate.AtEnd,
Position = UDim2.new(0, 50, 0, 0),
Size = UDim2.new(1, -(50 + 34), 1, 0),
Parent = base,
})
local eye = mk("TextButton", {
Name = "Reveal",
Text = "",
AutoButtonColor = false,
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -2, 0.5, 0),
Size = UDim2.fromOffset(26, 26),
BackgroundColor3 = T.WHITE,
BackgroundTransparency = 0.965,
BorderSizePixel = 0,
Parent = base,
}, { T.corner(8), T.stroke(T.WHITE, 1, 0.9) })
local ring = mk("Frame", {
Name = "Ring",
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(13, 9),
BackgroundTransparency = 1,
Parent = eye,
}, { T.corner(5), T.stroke(Color3.fromRGB(170, 162, 178), 1, 0) })
mk("Frame", {
Name = "Pupil",
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(4, 4),
BackgroundColor3 = Color3.fromRGB(170, 162, 178),
BorderSizePixel = 0,
Parent = ring,
}, { T.corner(2) })
local slash = mk("Frame", {
Name = "Slash",
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(17, 1.5),
Rotation = -35,
BackgroundColor3 = Color3.fromRGB(170, 162, 178),
BorderSizePixel = 0,
Parent = eye,
}, { T.corner(1) })
local function paintName()
R.set(nameLabel, "Text", revealed and realName or masked)
R.set(slash, "Visible", not revealed)
end
eye.Activated:Connect(function()
revealed = not revealed
paintName()
end)
local function setExpanded(on)
on = on and true or false
if on == expanded then return end
expanded = on
if on then R.set(details, "Visible", true) end
R.tween(chip, T.MOVE, {
Size = UDim2.new(0, railW - 20, 0, on and EXPANDED or COLLAPSED),
}, T.EASE_UI)
R.tween(details, T.MOVE, {
Size = UDim2.new(1, 0, 0, on and DETAILS_H or 0),
}, T.EASE_UI)
if not on then
R.call(function()
task.delay(T.MOVE, function()
if not expanded then R.set(details, "Visible", false) end
end)
end)
end
end
chip.Activated:Connect(function() setExpanded(not expanded) end)
win.setChipExpanded = function(_, on) setExpanded(on) end
end
end
local contentInset = (narrow or topTabs) and 0 or railW
local body = mk("Frame", {
Name = "Body",
Position = UDim2.new(0, contentInset, 0, T.TITLEBAR_H + railH),
Size = UDim2.new(1, -contentInset,
1, -(T.TITLEBAR_H + railH + searchH + searchGap)),
BackgroundColor3 = T.PANEL,
BackgroundTransparency = 1,
BorderSizePixel = 0,
Parent = root,
}, { T.corner(T.RADIUS_WIN) })
if topTabs then
T.roundBottomOnly(body, T.RADIUS_WIN, T.PANEL)
elseif not narrow then
T.roundBottomRightOnly(body, T.RADIUS_WIN, T.PANEL)
end
do
local minW = narrow and T.WIN_MIN_W_NARROW or T.WIN_MIN_W
local minH = narrow and T.WIN_MIN_H_NARROW or T.WIN_MIN_H
local tile = dev.isTouch and 40 or 30
local grip = mk("TextButton", {
Name = "ResizeGrip",
AnchorPoint = Vector2.new(1, 1),
Position = UDim2.new(1, -8, 1, -8),
Size = UDim2.fromOffset(tile, tile),
BackgroundColor3 = T.ELEMENT,
BackgroundTransparency = 0.35,
Text = "",
AutoButtonColor = false,
ZIndex = 20,
Parent = root,
}, {
T.corner(T.RADIUS),
mk("UIStroke", { Color = T.CARD_EDGE, Transparency = 0.2, Thickness = 1 }),
})
local iconSize = dev.isTouch and 24 or 18
local ticks = {}
for i, len in ipairs({ 12, 6 }) do
ticks[i] = mk("Frame", {
AnchorPoint = Vector2.new(1, 1),
Position = UDim2.new(1, -8 - (i - 1) * 2, 1, -8 - (i - 1) * 2),
Size = UDim2.fromOffset(len, 1.5),
BackgroundColor3 = T.TEXT,
BackgroundTransparency = 0.3,
BorderSizePixel = 0,
Rotation = -45,
ZIndex = 21,
Parent = grip,
}, { T.corner(1) })
end
local gripIcon = mk("ImageLabel", {
Name = "Icon",
AnchorPoint = Vector2.new(0.5, 0.5),
Position = UDim2.fromScale(0.5, 0.5),
Size = UDim2.fromOffset(iconSize, iconSize),
BackgroundTransparency = 1,
ImageColor3 = T.TEXT,
ImageTransparency = 0.3,
ScaleType = Enum.ScaleType.Fit,
Visible = false,
ZIndex = 21,
Parent = grip,
})
BX.try("ui.lib.gripIcon", function()
local st = BX.require("ui.stats")
if not (st and type(st.fetchIcon) == "function") then return end
st.fetchIcon("resize", "maps/2x_web/ic_zoom_out_map_white_48dp.png", function(asset)
R.set(gripIcon, "Image", asset)
R.set(gripIcon, "Visible", true)
for _, t in ipairs(ticks) do R.set(t, "Visible", false) end
end)
end)
local function paint(on)
R.tween(grip, T.FADE, {
BackgroundColor3 = on and T.ACCENT or T.ELEMENT,
BackgroundTransparency = on and 0.15 or 0.35,
})
R.tween(gripIcon, T.FADE, { ImageTransparency = on and 0 or 0.3 })
for _, t in ipairs(ticks) do
R.tween(t, T.FADE, { BackgroundTransparency = on and 0 or 0.3 })
end
end
grip.MouseEnter:Connect(function() paint(true) end)
grip.MouseLeave:Connect(function() paint(false) end)
local NEAR = 140
local near = dev.isTouch
local function setNear(on)
if on == near then return end
near = on
R.tween(grip, 0.2, { BackgroundTransparency = on and 0.35 or 0.92 })
R.tween(gripIcon, 0.2, { ImageTransparency = on and 0.3 or 0.95 })
for _, t in ipairs(ticks) do
R.tween(t, 0.2, { BackgroundTransparency = on and 0.3 or 0.95 })
end
end
if not dev.isTouch then
grip.BackgroundTransparency = 0.92
gripIcon.ImageTransparency = 0.95
for _, t in ipairs(ticks) do t.BackgroundTransparency = 0.95 end
windowScope:connect(UIS.InputChanged, function(input)
if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
if not gui.Enabled then return end
local corner = grip.AbsolutePosition + grip.AbsoluteSize
local d = (Vector2.new(input.Position.X, input.Position.Y) - corner).Magnitude
setNear(d < NEAR)
end)
end
local resizing, startMouse, startSize, startPos = false, nil, nil, nil
local function maxSize()
local cam = workspace.CurrentCamera
local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
local k = scale.Scale
return Vector2.new((vp.X - 32) / k, (vp.Y - 32) / k)
end
grip.InputBegan:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
resizing = true
startMouse = input.Position
startSize = Vector2.new(holder.Size.X.Offset, holder.Size.Y.Offset)
local c = holder.AbsolutePosition + holder.AbsoluteSize / 2 - gui.AbsolutePosition
startPos = c
paint(true)
end)
windowScope:connect(UIS.InputChanged, function(input)
if not resizing then return end
if input.UserInputType ~= Enum.UserInputType.MouseMovement
and input.UserInputType ~= Enum.UserInputType.Touch then return end
local k = scale.Scale
local d = (input.Position - startMouse) / k
local lim = maxSize()
local w = math.clamp(startSize.X + d.X, minW, math.max(minW, lim.X))
local h = math.clamp(startSize.Y + d.Y, minH, math.max(minH, lim.Y))
local cx = startPos.X + (w - startSize.X) * k / 2
local cy = startPos.Y + (h - startSize.Y) * k / 2
R.set(holder, "Size", UDim2.fromOffset(w, h))
R.set(holder, "Position", UDim2.fromOffset(cx, cy))
end)
windowScope:connect(UIS.InputEnded, function(input)
if not resizing then return end
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
resizing = false
paint(false)
R.call(function()
if win.rememberPosition then win.rememberPosition() end
if win.rememberSize then win.rememberSize() end
local prof = BX._loaded["core.profiles"]
if prof and prof.rememberWindowGeometry then
prof.rememberWindowGeometry()
end
end)
end)
end
local pageFade = mk("Frame", {
Name = "PageFade",
AnchorPoint = Vector2.new(0, 1),
Position = UDim2.new(0, 0, 1, 0),
Size = UDim2.new(1, 0, 0, T.FADE_H),
BackgroundColor3 = T.WHITE,     
BorderSizePixel = 0,
Active = false,
ZIndex = 6,
Parent = body,
}, {
T.corner(T.RADIUS_WIN),
T.gradient(ColorSequence.new(T.WORKSPACE, T.WORKSPACE), 90,
NumberSequence.new({
NumberSequenceKeypoint.new(0, 1),
NumberSequenceKeypoint.new(0.35, 0.85),
NumberSequenceKeypoint.new(0.7, 0.35),
NumberSequenceKeypoint.new(1, 0),
})),
})
if topTabs then
T.roundBottomOnly(pageFade, T.RADIUS_WIN, T.PANEL)
elseif not narrow then
T.roundBottomRightOnly(pageFade, T.RADIUS_WIN, T.PANEL)
end
local dragHandle = mk("Frame", {
Name = "DragHandle",
AnchorPoint = Vector2.new(0.5, 1),
Position = UDim2.new(0.5, 0, 1, 8),
Size = UDim2.fromOffset(86, 4),
BackgroundColor3 = T.MUTED,
BackgroundTransparency = 0.35,
BorderSizePixel = 0,
Active = true,
ZIndex = 18,
Parent = holder,
}, { T.corner(2) })
dragHandle.MouseEnter:Connect(function()
R.tween(dragHandle, T.FADE, {
BackgroundColor3 = T.ACCENT,
BackgroundTransparency = 0.05,
})
end)
dragHandle.MouseLeave:Connect(function()
R.tween(dragHandle, T.FADE, {
BackgroundColor3 = T.MUTED,
BackgroundTransparency = 0.35,
})
end)
do
local lift = mk("UIScale", { Scale = 1, Parent = root })
local dragging, startCenter, startMouse = false, nil, nil
local visualOffset = Vector2.zero
local target, pos, vel = nil, nil, Vector2.zero
local lastMouse, lastMouseAt, mouseVel = nil, 0, Vector2.zero
local bounds = nil
local function screenBounds()
local cam = workspace.CurrentCamera
local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
local half = holder.AbsoluteSize / 2
local margin = 8
return {
minX = half.X + margin, maxX = vp.X - half.X - margin,
minY = half.Y + margin, maxY = vp.Y - half.Y - margin - 12,
}
end
local function band(v, lo, hi)
if v < lo then
local over = lo - v
return lo - math.min(over * T.EDGE_GIVE, T.EDGE_MAX)
elseif v > hi then
local over = v - hi
return hi + math.min(over * T.EDGE_GIVE, T.EDGE_MAX)
end
return v
end
local function setLift(on)
R.tween(lift, on and 0.08 or 0.32, { Scale = on and T.LIFT_SCALE or 1 },
on and Enum.EasingStyle.Quad or Enum.EasingStyle.Back)
if shadow then
R.tween(shadow, on and 0.08 or 0.25,
{ Transparency = on and T.LIFT_SHADOW or T.SHADOW_ALPHA })
end
end
local function grabbable(input)
local pg = svc.Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
if not pg then return true end
local ok, objs = pcall(pg.GetGuiObjectsAtPosition, pg, input.Position.X, input.Position.Y)
if not ok or type(objs) ~= "table" then return true end
local ours = false
for _, o in ipairs(objs) do
if not o:IsDescendantOf(holder) then continue end
ours = true
if o:IsA("GuiButton") or o:IsA("TextBox") then return false end
if o:IsA("ScrollingFrame") and o ~= rail then return false end
if o:IsDescendantOf(controls) then return false end
if o ~= overlay and o:IsDescendantOf(overlay) then return false end
end
if ours then return true end
local p, sz = bar.AbsolutePosition, bar.AbsoluteSize
return input.Position.X >= p.X and input.Position.X <= p.X + sz.X
and input.Position.Y >= p.Y and input.Position.Y <= p.Y + sz.Y
end
local function beginDrag(input, fromHandle)
if dragging then return end
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
if not fromHandle and not grabbable(input) then return end
dragging = true
local holderCenter = holder.AbsolutePosition + holder.AbsoluteSize / 2
local visualCenter = root.AbsolutePosition + root.AbsoluteSize / 2
visualOffset = visualCenter - holderCenter
startCenter = visualCenter
startMouse = input.Position
lastMouse, lastMouseAt, mouseVel = input.Position, os.clock(), Vector2.zero
bounds = screenBounds()
pos = visualCenter - visualOffset - gui.AbsolutePosition
vel = Vector2.zero
target = pos
setLift(true)
end
root.InputBegan:Connect(function(input) beginDrag(input, false) end)
bar.InputBegan:Connect(function(input) beginDrag(input, false) end)
dragHandle.InputBegan:Connect(function(input) beginDrag(input, true) end)
windowScope:connect(UIS.InputChanged, function(input)
if not dragging then return end
if input.UserInputType ~= Enum.UserInputType.MouseMovement
and input.UserInputType ~= Enum.UserInputType.Touch then return end
local now = os.clock()
local dt = now - lastMouseAt
if dt > 0 then
local v = (input.Position - lastMouse) / dt
mouseVel = mouseVel:Lerp(Vector2.new(v.X, v.Y), 0.5)
end
lastMouse, lastMouseAt = input.Position, now
local d = input.Position - startMouse
local x = band(startCenter.X + d.X, bounds.minX, bounds.maxX)
local y = band(startCenter.Y + d.Y, bounds.minY, bounds.maxY)
target = Vector2.new(x, y) - visualOffset - gui.AbsolutePosition
end)
windowScope:onFrame("drag", svc.RunService.RenderStepped, function(dt)
if not target or not pos then return end
dt = math.min(dt, 1 / 30)
local a = (target - pos) * T.DRAG_K - vel * T.DRAG_C
vel = vel + a * dt
pos = pos + vel * dt
holder.Position = UDim2.fromOffset(pos.X, pos.Y)
if not dragging and (target - pos).Magnitude < 0.3 and vel.Magnitude < 4 then
holder.Position = UDim2.fromOffset(target.X, target.Y)
target, pos = nil, nil
if win.rememberPosition then win.rememberPosition() end
end
end)
windowScope:connect(UIS.InputEnded, function(input)
if not dragging then return end
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
dragging = false
setLift(false)
if os.clock() - lastMouseAt > 0.08 then mouseVel = Vector2.zero end
local origin = gui.AbsolutePosition
local rest = (target or pos) + visualOffset + origin + mouseVel * T.THROW
rest = Vector2.new(
math.clamp(rest.X, bounds.minX, bounds.maxX),
math.clamp(rest.Y, bounds.minY, bounds.maxY))
target = rest - visualOffset - origin
end)
end
win.gui, win.root, win.overlay, win.scale = gui, root, overlay, scale
win.notify = function(_, title, body, o)
if type(_) == "string" then return M.notify(_, title, body) end
return M.notify(title, body, o)
end
local tabs, order, current = {}, 0, nil
local visible = not opts.startHidden
if opts.startHidden then
gui.Enabled = false
dim.BackgroundTransparency = 1
end
function win:setVisible(on)
on = on and true or false
if on == visible then return end
visible = on
if not on then W.closeOpenDropdown(nil) end
R.tween(dim, T.FADE, { BackgroundTransparency = on and T.DIM_ALPHA or 1 })
if on then
R.set(gui, "Enabled", true)
else
R.call(function()
task.delay(T.FADE, function()
if not visible then R.set(gui, "Enabled", false) end
end)
end)
end
end
function win:isVisible() return visible end
function win:toggle()
if visible then
self:minimise()
else
self:restore()
end
end
function win:destroy()
R.call(function() gui:Destroy() end)
end
minBtn.Activated:Connect(function()
win:minimise()
end)
closeBtn.Activated:Connect(function()
if opts.onClose then
task.spawn(function() BX.try("ui.window.close", opts.onClose) end)
else
win:minimise()
end
end)
local function selectTab(name)
if current == name then return end
current = name
W.closeOpenDropdown(nil)
if type(win.clearSearch) == "function" then
BX.try("ui.lib.clearSearch", win.clearSearch)
end
for n, t in pairs(tabs) do
local on = (n == name)
if on then
R.set(t.wrap, "Position", UDim2.fromOffset(0, 0))
R.set(t.wrap, "Visible", true)
elseif t.wrap.Visible then
R.set(t.wrap, "Visible", false)
R.set(t.wrap, "Position", UDim2.fromOffset(0, 0))
end
local tabEdge = t.button:FindFirstChildOfClass("UIStroke")
if narrow or topTabs then
R.tween(t.button, T.TAB_FADE, {
BackgroundColor3 = topTabs and T.ACCENT or T.WHITE,
BackgroundTransparency = on and (topTabs and 0.78 or 0) or 1,
})
R.tween(t.label, T.TAB_FADE, { TextColor3 = on and T.TAB_ON or T.TAB_OFF })
if tabEdge then
R.tween(tabEdge, T.TAB_FADE, { Transparency = on and (topTabs and 1 or 0) or 1 })
end
else
R.tween(t.button, T.TAB_FADE, {
BackgroundColor3 = T.TAB_WASH,
BackgroundTransparency = on and T.TAB_WASH_ON or 1,
})
R.tween(t.label, T.TAB_FADE, { TextColor3 = on and T.TAB_ON or T.TAB_OFF })
if t.icon then R.tween(t.icon, T.FADE, { ImageColor3 = on and T.TAB_ON or T.TAB_OFF }) end
if t.accent then R.set(t.accent, "Visible", on) end
if tabEdge then
R.tween(tabEdge, T.FADE, {
Color = on and T.SIDE_EDGE_ON or T.SIDE_EDGE,
Transparency = 1,
Thickness = 1,
})
end
end
end
end
win.select = function(_, name) selectTab(name) end
function win:selected() return current end
if false then
local quickRail = mk("Frame", {
Name = "QuickActionRail",
AnchorPoint = Vector2.new(1, 0.5),
Position = UDim2.new(1, -12, 0.5, 0),
Size = UDim2.fromOffset(74, 286),
BackgroundColor3 = T.PANEL,
BackgroundTransparency = 0.02,
BorderSizePixel = 0,
ZIndex = 100,
Parent = root,
}, {
T.corner(8),
T.stroke(T.LINE, 1, 0.1),
mk("UIPadding", {
PaddingTop = UDim.new(0, 12),
PaddingBottom = UDim.new(0, 12),
}),
mk("UIListLayout", {
HorizontalAlignment = Enum.HorizontalAlignment.Center,
VerticalAlignment = Enum.VerticalAlignment.Top,
Padding = UDim.new(0, 10),
SortOrder = Enum.SortOrder.LayoutOrder,
}),
})
local function quickAction(order, labelText, colour, target, badgeText)
local button = mk("TextButton", {
Name = "Quick_" .. target,
LayoutOrder = order,
Size = UDim2.fromOffset(48, 48),
BackgroundColor3 = colour,
BorderSizePixel = 0,
AutoButtonColor = false,
Text = labelText,
TextColor3 = T.WHITE,
FontFace = T.FONT_BOLD,
TextSize = 22,
ZIndex = 101,
Parent = quickRail,
}, { T.corner(6), T.stroke(T.BLACK, 2, 0) })
button.Activated:Connect(function() win:select(target) end)
button.MouseEnter:Connect(function() R.tween(button, T.FADE, {
BackgroundColor3 = colour:Lerp(T.WHITE, 0.12),
}) end)
button.MouseLeave:Connect(function() R.tween(button, T.FADE, {
BackgroundColor3 = colour,
}) end)
if badgeText then
local badge = mk("TextLabel", {
Name = "Badge",
AnchorPoint = Vector2.new(1, 1),
Position = UDim2.new(1, 7, 1, 7),
Size = UDim2.fromOffset(22, 22),
BackgroundColor3 = Color3.fromRGB(79, 212, 108),
BorderSizePixel = 0,
Text = badgeText,
TextColor3 = Color3.fromRGB(16, 35, 25),
FontFace = T.FONT_BOLD,
TextSize = 12,
ZIndex = 102,
Parent = button,
}, { T.corner(11), T.stroke(T.PANEL, 2, 0) })
end
return button
end
quickAction(1, "◆", Color3.fromRGB(28, 120, 168), "Event")
quickAction(2, "◉", Color3.fromRGB(215, 38, 56), "Main", "6")
quickAction(3, "✿", Color3.fromRGB(240, 139, 47), "Farm")
quickAction(4, "ϟ", Color3.fromRGB(137, 87, 216), "Misc")
end
function win:tab(name)
if tabs[name] then return tabs[name].api end
order = order + 1
local side = (opts.tabSide and opts.tabSide[name]) or "left"
local host = (not narrow and not topTabs and side == "right" and railRight) or rail
local topTabWidth = math.clamp(28 + #tostring(name) * 9, 72, 102)
local btn = mk("TextButton", {
Name = "Tab_" .. name,
Text = "",
AutoButtonColor = false,
BackgroundColor3 = (narrow or topTabs) and T.ELEMENT or T.TAB_WASH,
BackgroundTransparency = 1,
BorderSizePixel = 0,
LayoutOrder = order,
Size = (narrow or topTabs) and UDim2.fromOffset(topTabs and topTabWidth or 104, topTabs and 32 or railH - 14)
or UDim2.new(1, -16, 0, T.SIDE_BTN_H),
Parent = host,
}, topTabs and {
T.corner(10),
} or narrow and {
T.corner(T.RADIUS_TAB),
T.gradient(T.TAB_ACTIVE, T.TAB_ACTIVE_ROT),
T.stroke(T.TAB_EDGE, 1, 1),
} or { T.corner(T.SIDE_RADIUS), T.stroke(T.SIDE_EDGE, 1, 1) })
local lbl = mk("TextLabel", {
BackgroundTransparency = 1,
Text = name,
FontFace = T.FONT,
TextSize = (narrow or topTabs) and T.SIZE_TAB or T.SIDE_TEXT_SIZE,
TextColor3 = T.TAB_OFF,
TextXAlignment = Enum.TextXAlignment.Center,
Position = UDim2.fromOffset(0, 0),
Size = UDim2.fromScale(1, 1),
Parent = btn,
})
local accent = nil
if false and not narrow then
accent = mk("Frame", {
Name = "ActiveAccent",
Position = UDim2.fromOffset(0, 7),
Size = UDim2.new(0, 2, 1, -14),
BackgroundColor3 = T.ACCENT,
BackgroundTransparency = 0,
BorderSizePixel = 0,
Visible = false,
ZIndex = 2,
Parent = btn,
}, { T.corner(1) })
end
if topTabs then
btn.MouseEnter:Connect(function()
if current == name then
R.tween(btn, T.FADE, { BackgroundTransparency = 0.70 })
else
R.tween(btn, T.FADE, {
BackgroundColor3 = T.WHITE,
BackgroundTransparency = 0.90,
})
R.tween(lbl, T.FADE, { TextColor3 = T.TAB_ON })
end
end)
btn.MouseLeave:Connect(function()
if current == name then
R.tween(btn, T.FADE, {
BackgroundColor3 = T.ACCENT,
BackgroundTransparency = 0.78,
})
else
R.tween(btn, T.FADE, { BackgroundTransparency = 1 })
R.tween(lbl, T.FADE, { TextColor3 = T.TAB_OFF })
end
end)
elseif not narrow then
btn.MouseEnter:Connect(function()
R.tween(btn, T.FADE, {
BackgroundColor3 = T.TAB_WASH,
BackgroundTransparency = current == name and T.TAB_WASH_ON or T.TAB_WASH_HOV,
})
local edge = btn:FindFirstChildOfClass("UIStroke")
if edge then R.tween(edge, T.FADE, { Color = T.ACCENT, Transparency = 0.5, Thickness = 1.1 }) end
if current ~= name then
R.tween(lbl, T.FADE, { TextColor3 = T.TAB_ON })
end
end)
btn.MouseLeave:Connect(function()
R.tween(btn, T.FADE, {
BackgroundTransparency = current == name and T.TAB_WASH_ON or 1,
})
local edge = btn:FindFirstChildOfClass("UIStroke")
if edge then R.tween(edge, T.FADE, {
Color = current == name and T.SIDE_EDGE_ON or T.SIDE_EDGE,
Transparency = 1,
Thickness = 1,
}) end
if current ~= name then
R.tween(lbl, T.FADE, { TextColor3 = T.TAB_OFF })
end
end)
end
local wrap = mk("Frame", {
Name = "Page_" .. name,
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
Visible = false,
Parent = body,
})
local page = mk("ScrollingFrame", {
Name = "Scroll",
Size = UDim2.fromScale(1, 1),
BackgroundTransparency = 1,
BorderSizePixel = 0,
Active = true,
ScrollingEnabled = true,
ScrollBarThickness = 0,
ScrollBarImageColor3 = T.LINE,
ScrollBarImageTransparency = 0.15,
CanvasSize = UDim2.new(),
AutomaticCanvasSize = Enum.AutomaticSize.Y,
ScrollingDirection = Enum.ScrollingDirection.Y,
ElasticBehavior = Enum.ElasticBehavior.Always,
Parent = wrap,
}, {
mk("UIListLayout", {
Padding = UDim.new(0, T.GAP),
SortOrder = Enum.SortOrder.LayoutOrder,
}),
mk("UIPadding", {
PaddingTop = UDim.new(0, T.WORKSPACE_PAD_Y),
PaddingLeft = UDim.new(0, T.WORKSPACE_PAD_X),
PaddingRight = UDim.new(0, T.WORKSPACE_PAD_X),
PaddingBottom = UDim.new(0, 96),
}),
})
local head = mk("Frame", {
Name = "PageHeader",
BackgroundTransparency = 1,
Size = UDim2.new(1, 0, 0, 0),
LayoutOrder = 0,
Visible = false,
Parent = page,
})
mk("TextLabel", {
Name = "Title",
BackgroundTransparency = 1,
Text = name,
FontFace = T.FONT_BOLD,
TextSize = T.SIZE_PAGE,
TextColor3 = T.PAGE_TITLE,
TextXAlignment = Enum.TextXAlignment.Left,
TextYAlignment = Enum.TextYAlignment.Top,
Position = UDim2.fromOffset(2, 0),
Size = UDim2.new(1, -4, 0, 32),
Parent = head,
})
btn.Activated:Connect(function() selectTab(name) end)
local n = 0
local function nextOrder() n = n + 1 return n end
local api = { name = name, page = page }
function api:section(o) o = o or {} o.order = nextOrder() return W.section(page, o) end
function api:subnav(o) o = o or {} o.order = nextOrder() return W.subnav(page, o) end
function api:label(o)   o = o or {} o.order = nextOrder() return W.label(page, o) end
function api:button(o)  o = o or {} o.order = nextOrder() return W.button(page, o) end
function api:toggle(o)  o = o or {} o.order = nextOrder() return W.toggle(page, o) end
function api:slider(o)  o = o or {} o.order = nextOrder() return W.slider(page, o) end
function api:dropdown(o) o = o or {} o.order = nextOrder() return W.dropdown(page, o) end
function api:input(o)   o = o or {} o.order = nextOrder() return W.input(page, o) end
function api:row(o)     o = o or {} o.order = nextOrder() return W.row(page, o) end
function api:richCard(o) o = o or {} o.order = nextOrder() return W.richCard(page, o) end
function api:listCard(o) o = o or {} o.order = nextOrder() return W.listCard(page, o) end
function api:heading(text)
local lbl = head:FindFirstChild("Title")
if lbl then
R.set(lbl, "Text", tostring(text))
R.set(head, "Visible", true)
R.set(head, "Size", UDim2.new(1, 0, 0, T.PAGE_HEADER_H))
end
end
function api:scrollTo(sectionName)
local target
for _, child in ipairs(page:GetChildren()) do
if child:IsA("Frame") and child.Name == "Section" then
local label = child:FindFirstChild("Head")
and child.Head:FindFirstChild("Label")
if label and label.Text == string.upper(tostring(sectionName)) then
target = child
break
end
end
end
if target then
local y = target.AbsolutePosition.Y - page.AbsolutePosition.Y + page.CanvasPosition.Y - 4
page.CanvasPosition = Vector2.new(0, math.max(0, y))
end
end
function api:select()   selectTab(name) end
tabs[name] = { api = api, button = btn, label = lbl, accent = accent, page = page,
wrap = wrap }
if not current then selectTab(name) end
return api
end
function win:tabNames()
local out = {}
for n in pairs(tabs) do out[#out + 1] = n end
table.sort(out)
return out
end
local searchRow = nil
if false and not narrow then
searchRow = mk("Frame", {
Name = "SearchRow",
Position = UDim2.new(0, contentInset, 1, -(searchH + 8)),
Size = UDim2.new(1, -contentInset, 0, searchH),
BackgroundColor3 = T.SEARCH_BG,
BorderSizePixel = 0,
Parent = root,
}, {
T.corner(T.SIDE_RADIUS),
T.stroke(T.SIDE_EDGE, T.SIDE_STROKE_W, 0),
mk("UIPadding", {
PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
PaddingTop = UDim.new(0, 7), PaddingBottom = UDim.new(0, 7),
}),
})
mk("TextLabel", {
Name = "SearchLabel",
BackgroundTransparency = 1,
Text = "Search",
FontFace = T.FONT_BOLD,
TextSize = 14,
TextColor3 = T.SIDE_TEXT,
TextXAlignment = Enum.TextXAlignment.Left,
Size = UDim2.new(0, 62, 1, 0),
Parent = searchRow,
})
local field = mk("TextBox", {
Name = "SearchField",
Position = UDim2.fromOffset(68, 0),
Size = UDim2.new(1, -68, 1, 0),
BackgroundColor3 = T.SEARCH_FIELD,
BorderSizePixel = 0,
Text = "",
PlaceholderText = "Filter features...",
PlaceholderColor3 = Color3.fromRGB(129, 123, 140),
FontFace = T.FONT,
TextSize = 13,
TextColor3 = T.TEXT,
TextXAlignment = Enum.TextXAlignment.Left,
ClearTextOnFocus = false,
Parent = searchRow,
}, {
T.corner(8),
T.stroke(T.SEARCH_EDGE, 1, 0),
mk("UIPadding", {
PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
}),
})
local function cardText(node)
local parts = {}
for _, d in ipairs(node:GetDescendants()) do
if d:IsA("TextLabel") or d:IsA("TextButton") then
local t = tostring(d.Text or "")
if #t > 0 then parts[#parts + 1] = t end
end
end
return table.concat(parts, " "):lower()
end
local function applySearch(query)
query = tostring(query or ""):lower()
local page = current and tabs[current]
if not page or not page.wrap then return end
local scroll = page.wrap:FindFirstChild("Scroll")
if not scroll then return end
local nodes = {}
for _, node in ipairs(scroll:GetChildren()) do
if node:IsA("GuiObject") and node.Name ~= "PageHeader" then
if node.Name:match("^Section") then
local label = node:FindFirstChild("Label", true)
if label then R.set(label, "Visible", query == "") end
local group = node:FindFirstChild("Group")
if group then
for _, row in ipairs(group:GetChildren()) do
if row:IsA("GuiObject") then nodes[#nodes + 1] = row end
end
end
else
nodes[#nodes + 1] = node
end
end
end
for _, node in ipairs(nodes) do
do
if query == "" then
R.set(node, "Visible", true)
else
R.set(node, "Visible",
cardText(node):find(query, 1, true) ~= nil)
end
end
end
end
field:GetPropertyChangedSignal("Text"):Connect(function()
BX.try("ui.lib.search", applySearch, field.Text)
end)
win.clearSearch = function()
if field.Text ~= "" then R.set(field, "Text", "") end
end
else
win.clearSearch = function() end
end
local chrome = {}
local function addChrome(o) if o then chrome[#chrome + 1] = o end end
addChrome(lockup)     addChrome(badgePill)  addChrome(controls)
addChrome(rail)       addChrome(body)       addChrome(railRight)
addChrome(sidebarFade)
addChrome(dragHandle)
addChrome(searchRow)  addChrome(win.userChip)
local function setChrome(on)
for _, o in ipairs(chrome) do
R.set(o, "Visible", on and true or false)
end
end
local restPos = UDim2.fromScale(0.5, 0.5)
local restSize = UDim2.fromOffset(fullW, fullH)
win.rememberPosition = function() restPos = holder.Position end
win.rememberSize = function() restSize = holder.Size end
function win:getGeometry()
return {
w = math.floor(holder.Size.X.Offset + 0.5),
h = math.floor(holder.Size.Y.Offset + 0.5),
}
end
function win:setGeometry(geometry)
if type(geometry) ~= "table" then return false end
local w, h = tonumber(geometry.w), tonumber(geometry.h)
if not w or not h then return false end
local minW = narrow and T.WIN_MIN_W_NARROW or T.WIN_MIN_W
local minH = narrow and T.WIN_MIN_H_NARROW or T.WIN_MIN_H
w = math.clamp(math.floor(w + 0.5), minW, 2400)
h = math.clamp(math.floor(h + 0.5), minH, 1600)
R.set(holder, "Size", UDim2.fromOffset(w, h))
R.set(scale, "Scale", T.fitScale(w, h))
win.rememberSize()
return true
end
function win:fitForDevice()
if not mobileLandscape then return false end
R.set(holder, "Size", UDim2.fromOffset(fullW, fullH))
R.set(holder, "Position", UDim2.fromScale(0.5, 0.5))
R.set(scale, "Scale", T.fitScale(fullW, fullH))
win.rememberSize()
win.rememberPosition()
return true
end
BX.try("ui.lib.viewport", function()
local cam = workspace.CurrentCamera
if not cam then return end
windowScope:connect(cam:GetPropertyChangedSignal("ViewportSize"), function()
task.defer(function()
if not gui.Parent then return end
local w, h = holder.Size.X.Offset, holder.Size.Y.Offset
local k = T.fitScale(w, h)
R.set(scale, "Scale", k)
local vp = cam.ViewportSize
local half = Vector2.new(w * k / 2, h * k / 2)
local p = holder.Position
local cx = p.X.Scale * vp.X + p.X.Offset
local cy = p.Y.Scale * vp.Y + p.Y.Offset
cx = math.clamp(cx, half.X + 8, math.max(half.X + 8, vp.X - half.X - 8))
cy = math.clamp(cy, half.Y + 8, math.max(half.Y + 8, vp.Y - half.Y - 20))
R.set(holder, "Position", UDim2.fromOffset(cx, cy))
win.rememberPosition()
end)
end)
end)
local function rectOf(inst)
if not (inst and inst.Parent) then return nil end
local ok, p, sz = pcall(function()
return inst.AbsolutePosition, inst.AbsoluteSize
end)
if not ok or not p or sz.X < 1 then return nil end
local origin = gui.AbsolutePosition
return {
centre = UDim2.fromOffset(p.X - origin.X + sz.X / 2, p.Y - origin.Y + sz.Y / 2),
size = UDim2.fromOffset(sz.X / fit, sz.Y / fit),
}
end
local morphed = false
function win:morphFrom(geom)
if morphed or dev.lite()
or not (geom and geom.panel and geom.panel.size and geom.panel.size.X > 1) then
self:setVisible(true)
return false
end
morphed = true
R.set(holder, "Size", UDim2.fromOffset(
geom.panel.size.X / fit, geom.panel.size.Y / fit))
R.set(scale, "Scale", fit)      
if geom.logo and geom.logo.size and geom.logo.size.X > 1 then
local rel = geom.logo.pos - geom.panel.pos
local lw = geom.logo.size.X / fit
R.set(logo, "Size", UDim2.fromOffset(lw, lw))
R.set(logo, "Position",
UDim2.fromOffset(rel.X / fit, (rel.Y / fit) + lw / 2))
end
setChrome(false)
self:setVisible(true)
R.flush()
R.tween(holder, T.MORPH, { Size = restSize }, T.EASE_WINDOW)
R.tween(logo, T.MORPH, {
Size = UDim2.fromOffset(T.LOGO_SIZE, T.LOGO_SIZE),
Position = UDim2.new(0, T.TITLEBAR_PAD_X, 0.5, 0),
}, T.EASE_WINDOW)
R.call(function()
task.delay(T.MORPH_CHROME, function() setChrome(true) end)
end)
return true
end
local launcherFn = nil
local launcherBound = nil
local minimised = false
local morphing = false
local morphSeq = 0     
function win:isMinimised() return minimised end
function win:isMorphing() return morphing end
local function launcher()
if not launcherFn then return nil end
local ok, inst = pcall(launcherFn)
return ok and inst or nil
end
local function bumpLauncher(strength)
R.call(function()
local st = BX._loaded["ui.stats"]
if st and type(st.bump) == "function" then pcall(st.bump, strength) end
end)
end
function win:minimise()
if morphing or minimised or not visible then return false end
local rect = rectOf(launcher())
if not rect then
return false
end
minimised = true
morphing = true
win.rememberSize()
win.rememberPosition()
R.call(function()
local prof = BX._loaded["core.profiles"]
if prof and prof.rememberWindowGeometry then
prof.rememberWindowGeometry()
end
end)
morphSeq = morphSeq + 1
local seq = morphSeq
W.closeOpenDropdown(nil)
fadeControls(false, 0.1)
R.call(function()
task.delay(T.MORPH_CHROME * 0.5, function()
if minimised and seq == morphSeq then setChrome(false) end
end)
end)
R.tween(holder, T.MORPH_IN, { Position = rect.centre, Size = rect.size },
T.EASE_WINDOW)
R.tween(dim, T.MORPH_IN * 0.7, { BackgroundTransparency = 1 })
R.call(function()
task.delay(T.MORPH_IN + 0.02, function()
if minimised and seq == morphSeq then
R.set(gui, "Enabled", false)
visible = false
morphing = false
if opts.onMinimised then
task.spawn(function() BX.try("ui.window.minimised", opts.onMinimised) end)
end
end
end)
end)
return true
end
function win:restore()
if morphing then return false end
if not minimised then
self:setVisible(true)
return false
end
minimised = false
morphing = true
local rect = rectOf(launcher())
if not rect then
minimised = false
morphing = false
self:setVisible(true)
return false
end
morphSeq = morphSeq + 1
local seq = morphSeq
R.set(holder, "Position", rect.centre)
R.set(holder, "Size", rect.size)
setChrome(false)
R.set(gui, "Enabled", true)
visible = true
R.flush()
R.tween(holder, T.MORPH_OUT, { Position = restPos, Size = restSize },
T.EASE_WINDOW)
R.tween(dim, T.MORPH_OUT * 0.8, { BackgroundTransparency = T.DIM_ALPHA })
R.call(function()
task.delay(T.MORPH_OUT * 0.55, function()
if not minimised and seq == morphSeq then
setChrome(true)
fadeControls(true, 0.15)
end
end)
task.delay(T.MORPH_OUT + 0.03, function()
if not minimised and seq == morphSeq then morphing = false end
end)
end)
return true
end
local TAP_TIME, TAP_SLOP = 0.35, 8
function win:setLauncher(fn)
launcherFn = fn
local inst = launcher()
if not inst or inst == launcherBound then return inst ~= nil end
launcherBound = inst
local downAt, downPos = 0, nil
inst.InputBegan:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
downAt, downPos = os.clock(), input.Position
end)
inst.InputEnded:Connect(function(input)
if input.UserInputType ~= Enum.UserInputType.MouseButton1
and input.UserInputType ~= Enum.UserInputType.Touch then return end
if downAt == 0 or not downPos then return end
local heldFor = os.clock() - downAt
local moved = (Vector2.new(input.Position.X, input.Position.Y)
- Vector2.new(downPos.X, downPos.Y)).Magnitude
downAt, downPos = 0, nil
if heldFor > TAP_TIME or moved > TAP_SLOP then return end
task.spawn(function()
BX.try("ui.lib.launcherTap", function()
if minimised or not visible then win:restore() else win:minimise() end
end)
end)
end)
return true
end
if not opts.deferEntrance then
R.tween(dim, T.ENTER, { BackgroundTransparency = T.DIM_ALPHA })
R.tween(scale, T.ENTER, { Scale = fit }, T.EASE_WINDOW)
if not dev.lite() then
bar.Visible = false
rail.Visible = false
R.call(function()
task.delay(0.06, function() R.set(bar, "Visible", true) end)
task.delay(0.12, function() R.set(rail, "Visible", true) end)
end)
end
end
log.info("window built (%dx%d at scale %.2f, %s layout)", wantW, wantH, fit,
narrow and "narrow/top-tabs" or "wide/left-rail")
return win
end
return M
end)
BX.module("ui.adapter", function(BX)
local log = BX.require("boot.log").for_module("ui.adapter")
local M = {}
local backend = "rayfield"
function M.backend() return backend end
function M.setBackend(name)
backend = (name == "lib") and "lib" or "rayfield"
log.info("backend: %s", backend)
return backend
end
local stats = { created = 0, silentSets = 0, echoesSwallowed = 0, callbacks = 0 }
function M.stats() return table.clone(stats) end
local function wrapNative(el, kind, name)
local h = {
kind = kind, name = name, _el = el, _native = true,
}
function h:set(v) stats.silentSets = stats.silentSets + 1 el:set(v) end
function h:get() return el:get() end
function h:setOptions(o) if el.setOptions then return el:setOptions(o) end end
function h:Set(v) self:set(v) end
function h:Refresh(o, force) return self:setOptions(o, force) end
function h:Destroy() if el.destroy then el:destroy() end end
h.input = rawget(el, "input")
function h:options() return el.options and el:options() or {} end
function h:setTitle(t) if el.setTitle then el:setTitle(t) end end
function h:SetTitle(t) self:setTitle(t) end
function h:setDescription(t) if el.setDescription then el:setDescription(t) end end
function h:setVisible(v) if el.setVisible then el:setVisible(v) end end
function h:destroy() if el.destroy then el:destroy() end end
function h:raw() return el end
return h
end
local function rayValue(el)
if type(el) ~= "table" then return el end
local v = el.CurrentOption
if v ~= nil then return v end
v = el.CurrentValue
if v == nil then v = el.Value end
if v == nil then v = el.value end
return v
end
local function wrapRayfield(el, kind, name, guard)
local h = { kind = kind, name = name, _el = el, _native = false }
function h:set(v)
if el == nil then return end
stats.silentSets = stats.silentSets + 1
guard.writes = guard.writes + 1
local ok = BX.try("adapter.set/" .. tostring(name), function()
if type(el.Set) == "function" then
el:Set(v)
else
error("element has no Set()", 0)
end
end)
if not ok then
guard.writes = math.max(0, guard.writes - 1)
end
end
function h:get()
if el == nil then return nil end
return rayValue(el)
end
function h:Set(v) self:set(v) end
function h:setOptions(options, force)
if el == nil or type(options) ~= "table" then return false end
local sig = table.concat(options, "\0")
if not force and sig == self._sig then return true end
self._sig = sig
local applied = BX.try("adapter.setOptions/" .. tostring(name), function()
el:Refresh(options)
end)
if not applied then
task.wait()
applied = BX.try("adapter.setOptions.retry/" .. tostring(name), function()
el:Refresh(options)
end)
if not applied then self._sig = nil end
end
return applied
end
function h:Refresh(options, force)
return self:setOptions(options, force)
end
function h:options() return (type(el) == "table" and el.options) or {} end
function h:setTitle(t)
BX.try("adapter.setTitle", function()
if el.Set and self.kind == "label" then el:Set(t) end
end)
end
function h:SetTitle(t) self:setTitle(t) end
function h:setDescription() end
local function frame()
local m = type(el) == "table" and rawget(el, "main") or nil
return typeof(m) == "Instance" and m or nil
end
function h:setVisible(v)
BX.try("adapter.setVisible", function()
if type(el.SetVisible) == "function" then
el:SetVisible(v and true or false)
elseif frame() then
frame().Visible = v and true or false
end
end)
end
function h:destroy()
BX.try("adapter.destroy", function()
if type(el.Destroy) == "function" then
el:Destroy()
return
end
local conns = rawget(el, "connections")
if type(conns) == "table" then
for _, c in pairs(conns) do
if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
end
end
if frame() then frame():Destroy() end
end)
end
function h:raw() return el end
return h
end
function M.wrapTab(raw)
if raw == nil then return nil end
local native = type(raw.toggle) == "function"
local tab = { _raw = raw, native = native }
local function wrapCallback(name, fn, guard)
return function(value)
if guard.writes > 0 then
guard.writes = guard.writes - 1
stats.echoesSwallowed = stats.echoesSwallowed + 1
return
end
if not fn then return end
stats.callbacks = stats.callbacks + 1
BX.try("adapter.touchProfile", function()
local prof = BX._loaded["core.profiles"]
if prof and prof.touch then prof.touch() end
end)
task.spawn(function()
BX.try("ui/" .. tostring(name), fn, value)
end)
end
end
local function create(kind, opts)
opts = opts or {}
stats.created = stats.created + 1
local name = opts.name or kind
if native then
local el = raw[kind](raw, opts)
return wrapNative(el, kind, name)
end
local guard = { writes = 0 }
local o = table.clone(opts)
if o.callback then o.callback = wrapCallback(name, opts.callback, guard) end
if kind == "dropdown" and o.multi ~= nil then
o.multiSelect = o.multi and true or false
o.multi = nil
end
local method = ({
section = "CreateSection", label = "CreateText",
button = "CreateButton", toggle = "CreateToggle",
slider = "CreateSlider", dropdown = "CreateDropdown",
input = "CreateInput",
})[kind]
if not method or type(raw[method]) ~= "function" then
log.warn("backend has no %s", tostring(method or kind))
return wrapRayfield(nil, kind, name, guard)
end
local el = raw[method](raw, o)
return wrapRayfield(el, kind, name, guard)
end
function tab:CreateSection(o)  return create("section", o) end
function tab:CreateSubnav(o)
if native and type(raw.subnav) == "function" then
return wrapNative(raw:subnav(o or {}), "subnav", o and o.name)
end
local names = {}
for _, item in ipairs((o and o.items) or {}) do names[#names + 1] = tostring(item) end
return tab:CreateText({ name = "", text = table.concat(names, "   ") })
end
function tab:CreateText(o)     return create("label", o) end
function tab:CreateLabel(o)    return create("label", o) end
function tab:CreateButton(o)   return create("button", o) end
function tab:CreateToggle(o)   return create("toggle", o) end
function tab:CreateSlider(o)   return create("slider", o) end
function tab:CreateDropdown(o) return create("dropdown", o) end
function tab:CreateInput(o)    return create("input", o) end
function tab:CreateRichCard(o)
o = o or {}
if native then
local el = raw:richCard(o)
return wrapNative(el, "richCard", o.name)
end
local text = tab:CreateText({ name = o.name, text = o.text })
if o.action then
tab:CreateButton({ name = o.action.label, callback = o.action.callback })
end
return text
end
function tab:CreateListCard(o)
o = o or {}
if native then
local el = raw:listCard(o)
return wrapNative(el, "listCard", o.name)
end
local lines = {}
for _, row in ipairs(o.rows or {}) do
lines[#lines + 1] = ("%s  %s"):format(tostring(row[1]), tostring(row[2]))
end
return tab:CreateText({ name = o.name, text = table.concat(lines, "\n") })
end
function tab:SetHeading(text)
if native and type(raw.heading) == "function" then raw:heading(text) end
end
function tab:CreateGroup(o)
if native and type(raw.row) == "function" then
local row = raw:row(o)
local g = { _row = row, native = true }
function g:CreateToggle(opts)
local el = row:toggle(opts)
return wrapNative(el, "toggle", opts and opts.name)
end
function g:CreateButton(opts)
local el = row:button(opts)
return wrapNative(el, "button", opts and opts.name)
end
return g
end
if type(raw.CreateGroup) == "function" then
local ok, row = pcall(raw.CreateGroup, raw, o)
if ok and row then return M.wrapTab(row) end
end
return tab
end
return tab
end
return M
end)
BX.module("ui.shell", function(BX)
local log = BX.require("boot.log").for_module("shell")
local ad = BX.require("ui.adapter")
local native = BX.require("ui.lib")
local ORDER = {
Home = 10,
Main = 20,
Farm = 30,
Event = 40,
Misc = 50,
Config = 60,
}
local major = tostring(BX.version or "6"):match("^(%d+)") or "6"
local raw
raw = native.window({
title = "VoidcxzHub",
subtitle = "Steal An Egg",
badge = nil,
startHidden = true,
deferEntrance = true,
onMinimised = function()
BX.try("shell.statsResume", function()
BX.require("ui.stats").setWindowOpen(false)
end)
local island = BX.require("ui.island")
island.set("closed", {
title = "VoidcxzHub",
sub = "Tap to open",
maxWidth = 230,
low = true,
})
end,
})
local M = {
ok = raw ~= nil,
error = raw and nil or "native UI failed to initialize",
window = raw,
screen = raw and raw.gui or nil,
ORDER = ORDER,
backend = "lib",
}
if not M.ok then
log.error("native menu unavailable: %s", tostring(M.error))
return M
end
ad.setBackend("lib")
local tabs = {}
function M.tab(name)
if tabs[name] then return tabs[name] end
local tab = raw:tab(name)
if not tab then return nil end
local wrapped = ad.wrapTab(tab)
tabs[name] = wrapped
return wrapped
end
local function bindIsland()
BX.try("shell.island", function()
local st = BX.require("ui.stats")
if not (st and type(st.anchor) == "function") then return end
raw:setLauncher(function() return (st.anchor()) end)
end)
end
function M.hide()
bindIsland()
if not raw:minimise() then raw:setVisible(false) end
return true
end
function M.reveal()
BX.try("shell.stats", function()
local cfg = BX.require("core.config")
if cfg.SHOW_STATS then
local stats = BX.require("ui.stats")
stats.setDock(nil)
stats.show(true)
end
end)
bindIsland()
local restored = raw:restore()
BX.try("shell.statsResume", function()
BX.require("ui.stats").setWindowOpen(false)
end)
if restored then
BX.try("shell.islandClear", function()
BX.require("ui.island").clear("closed")
end)
else
BX.try("shell.islandClear", function() BX.require("ui.island").clear("closed") end)
end
return true
end
function M.isVisible()
return raw:isVisible()
end
function M.isHidden()
return not M.isVisible()
end
function M.notify(title, content, duration)
return raw:notify(title, content, { hold = duration })
end
M.hasNotify = true
function M.restoreLastTab()
if raw:selected() then return true end
raw:select("Home")
return true
end
function M.unload()
local stats = BX._loaded["ui.stats"]
if stats and type(stats.show) == "function" then
BX.try("shell.stats.hide", function() stats.show(false) end)
end
raw:destroy()
return true
end
M.win = raw
log.info("menu built on native VoidcxzHub UI")
return M
end)
BX.module("ui.tabs.home", function(BX)
local exec = BX.require("core.exec")
local win  = BX.require("ui.shell")
local log  = BX.require("boot.log").for_module("home")
local M = {}
local INVITE = "https://discord.gg/ePHR9Eb69"
local UPDATES = type(BX.releaseNotes) == "table" and BX.releaseNotes or {
{ "New",      "Native V6 UI — no Rayfield download, cache, or CDN dependency." },
{ "Polished", "Premium motion, Dynamic Island, drag, resize, and touch controls." },
{ "Improved", "One dark-violet visual system with clearer, more readable type." },
{ "Fixed",    "Reliable tabs, profiles, fades, window morphs, and layout." },
}
local function openDiscord()
BX.try("home.openBrowser", function()
game:GetService("GuiService"):OpenBrowserWindow(INVITE)
end)
local copied = exec.clipboard(INVITE)
log.info("discord: opened (copied=%s)", tostring(copied))
win.notify("VoidcxzHub", copied and "Discord opened and invite copied"
or ("Join at " .. INVITE))
end
function M.build(tab)
if not tab then return M end
if type(tab.SetHeading) == "function" then
tab:SetHeading("VoidcxzHub Community")
end
tab:CreateRichCard({
name = "Community",
text = "Release notes, support, and early access for VoidcxzHub users.",
titleSize = 16,
textSize = 13,
action = { label = "Join Discord", textSize = 14, callback = openDiscord },
})
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
-- Key system removed: farm access is now keyless.
function M.build(tab)
if not tab then return M end
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
description = "Discord webhook. Stored on this device, not in your profile.",
placeholder = "https://discord.com/api/webhooks/...",
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
