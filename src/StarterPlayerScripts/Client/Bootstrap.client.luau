local Controllers = script.Parent.Controllers

local MatchController = require(Controllers.MatchController)
local InputController = require(Controllers.InputController)
-- local VFXController = require(Controllers.VFXController)
local MutationController = require(Controllers.MutationController)
local VFXController = require(Controllers.VFXController)

MatchController:Init()
InputController:Init()
-- VFXController:Init()
VFXController:Init()
MutationController:Init()

MatchController:Start()
InputController:Start()
-- VFXController:Start()
-- VFXController:Start()
MutationController:Start()