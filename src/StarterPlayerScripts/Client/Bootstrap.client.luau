local Controllers = script.Parent.Controllers

local CoreSelectionController = require(Controllers.CoreSelectionController)
local MatchController = require(Controllers.MatchController)
local InputController = require(Controllers.InputController)
local MutationController = require(Controllers.MutationController)
local VFXController = require(Controllers.VFXController)

CoreSelectionController:Init()
MatchController:Init()
InputController:Init()
VFXController:Init()
MutationController:Init()

CoreSelectionController:Start()
MatchController:Start()
InputController:Start()
MutationController:Start()