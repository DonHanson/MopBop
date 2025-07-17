
MopBop = {};
MopBop.fully_loaded = false;
MopBop.default_options = {

	-- main frame position
	frameRef = "CENTER",
	frameX = 0,
	frameY = 0,
	hide = false,

	-- sizing
	frameW = 200,
	frameH = 200,
};


function MopBop.OnReady()

	-- set up default options
	_G.MopBopPrefs = _G.MopBopPrefs or {};

	for k,v in pairs(MopBop.default_options) do
		if (not _G.MopBopPrefs[k]) then
			_G.MopBopPrefs[k] = v;
		end
	end

	MopBop.CreateUIFrame();
end

function MopBop.OnSaving()

	if (MopBop.UIFrame) then
		local point, relativeTo, relativePoint, xOfs, yOfs = MopBop.UIFrame:GetPoint()
		_G.MopBopPrefs.frameRef = relativePoint;
		_G.MopBopPrefs.frameX = xOfs;
		_G.MopBopPrefs.frameY = yOfs;
	end
end

function MopBop.OnUpdate()
	if (not MopBop.fully_loaded) then
		return;
	end

	if (MopBopPrefs.hide) then 
		return;
	end

	MopBop.UpdateFrame();
end

function MopBop.OnEvent(frame, event, ...)

	if (event == 'ADDON_LOADED') then
		local name = ...;
		if name == 'MopBop' then
			MopBop.OnReady();
		end
		return;
	end

	if (event == 'PLAYER_LOGIN') then

		MopBop.fully_loaded = true;
		return;
	end

	if (event == 'PLAYER_LOGOUT') then
		MopBop.OnSaving();
		return;
	end
end

function MopBop.CreateUIFrame()

	-- create the UI frame
	MopBop.UIFrame = CreateFrame("Frame",nil,UIParent);
	MopBop.UIFrame:SetFrameStrata("BACKGROUND")
	MopBop.UIFrame:SetWidth(_G.MopBopPrefs.frameW);
	MopBop.UIFrame:SetHeight(_G.MopBopPrefs.frameH);

	-- make it black
	MopBop.UIFrame.texture = MopBop.UIFrame:CreateTexture();
	MopBop.UIFrame.texture:SetAllPoints(MopBop.UIFrame);
	MopBop.UIFrame.texture:SetTexture(0, 0, 0);

	-- position it
	MopBop.UIFrame:SetPoint(_G.MopBopPrefs.frameRef, _G.MopBopPrefs.frameX, _G.MopBopPrefs.frameY);

	-- make it draggable
	MopBop.UIFrame:SetMovable(true);
	MopBop.UIFrame:EnableMouse(true);

	-- create a button that covers the entire addon
	MopBop.Cover = CreateFrame("Button", nil, MopBop.UIFrame);
	MopBop.Cover:SetFrameLevel(128);
	MopBop.Cover:SetPoint("TOPLEFT", 0, 0);
	MopBop.Cover:SetWidth(_G.MopBopPrefs.frameW);
	MopBop.Cover:SetHeight(_G.MopBopPrefs.frameH);
	MopBop.Cover:EnableMouse(true);
	MopBop.Cover:RegisterForClicks("AnyUp");
	MopBop.Cover:RegisterForDrag("LeftButton");
	MopBop.Cover:SetScript("OnDragStart", MopBop.OnDragStart);
	MopBop.Cover:SetScript("OnDragStop", MopBop.OnDragStop);
	MopBop.Cover:SetScript("OnClick", MopBop.OnClick);

	-- add a main label - just so we can show something
	MopBop.Label = MopBop.Cover:CreateFontString(nil, "OVERLAY");
	MopBop.Label:SetPoint("CENTER", MopBop.UIFrame, "CENTER", 2, 0);
	MopBop.Label:SetJustifyH("LEFT");
	MopBop.Label:SetFont([[Fonts\FRIZQT__.TTF]], 12, "OUTLINE");
	MopBop.Label:SetText(" ");
	MopBop.Label:SetTextColor(1,1,1,1);
	MopBop.SetFontSize(MopBop.Label, 20);
end

function MopBop.SetFontSize(string, size)

	local Font, Height, Flags = string:GetFont()
	if (not (Height == size)) then
		string:SetFont(Font, size, Flags)
	end
end

function MopBop.OnDragStart(frame)
	MopBop.UIFrame:StartMoving();
	MopBop.UIFrame.isMoving = true;
	GameTooltip:Hide()
end

function MopBop.OnDragStop(frame)
	MopBop.UIFrame:StopMovingOrSizing();
	MopBop.UIFrame.isMoving = false;
end

function MopBop.OnClick(self, aButton)
	if (aButton == "RightButton") then
		print("show menu here!");
	end
end

function MopBop.UpdateFrame()

	-- update the main frame state here
	MopBop.Label:SetText(string.format("%d", GetTime()));
end


MopBop.EventFrame = CreateFrame("Frame");
MopBop.EventFrame:Show();
MopBop.EventFrame:SetScript("OnEvent", MopBop.OnEvent);
MopBop.EventFrame:SetScript("OnUpdate", MopBop.OnUpdate);
MopBop.EventFrame:RegisterEvent("ADDON_LOADED");
MopBop.EventFrame:RegisterEvent("PLAYER_LOGIN");
MopBop.EventFrame:RegisterEvent("PLAYER_LOGOUT");
