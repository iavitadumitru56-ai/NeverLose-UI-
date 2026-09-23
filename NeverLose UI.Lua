--[[
                          Neverlose.cc / HeadShot UI Library
    Author: 4lpaca (Full Engine Edition with HeadShot Redesign)
    License: MIT
]]

do
	local Constant = 'L'..'P'..'H'..'_NO_VIRTUALIZE';
	getfenv()[Constant] = getfenv()[Constant] or function(f) return f end;
end;

cloneref = cloneref or function(i) return i end;
gethui = gethui or get_hidden_gui;
getcustomasset = getcustomasset or getsynasset;
getgenv = getgenv or getfenv;

local LOAD_ENV = LPH_NO_VIRTUALIZE(function()
	if game:GetService('RunService'):IsStudio() then
		local BaseWorkspace = game:GetService("ReplicatedFirst"):FindFirstChild('PRI_WORKSPACE') or Instance.new('Folder',game:GetService("ReplicatedFirst"));

		BaseWorkspace.Name = 'PRI\0.'..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)));

		local __get_path_c = function(path)
			return (string.find(path,'/',1,true) and string.split(path,'/')) or (string.find(path,'\\',1,true) and string.split(path,'\\')) or {path};
		end;

		local __get_path = function(path)
			local main = __get_path_c(path);
			local block = BaseWorkspace;

			for i,v in next , main do
				block = block[v];
			end;

			return block;
		end;

		getgenv().readfile = function(path)
			local path_obj : StringValue = __get_path(path);
			return path_obj.Value;
		end;

		getgenv().isfile = function(path)
			local success , message = pcall(function()
				return __get_path(path);
			end);

			if success and not message:IsA("Folder") then
				return true;
			end;

			return false;
		end;

		getgenv().isfolder = function(path)
			local success , message = pcall(function()
				return __get_path(path);
			end);

			if success and message:IsA("Folder") then
				return true;
			end;

			return false;
		end;

		getgenv().writefile = function(path,content)
			local main = __get_path_c(path);
			local block = BaseWorkspace;

			for i,v in next , main do
				local item = block:FindFirstChild(v);
				if not item then
					local c = Instance.new('StringValue',block);
					c.Name = tostring(v);
					c.Value = content;
				else
					if item:IsA('StringValue') and tostring(item) == v then
						item.Name = tostring(v);
						item.Value = content;
					end;

					block = item;
				end;
			end;
		end;

		getgenv().listfiles = function(path)
			local fold = __get_path(path);
			local pa = {};

			for i,v in next , fold:GetChildren() do
				if v:IsA('StringValue') then
					table.insert(pa,path..'/'..tostring(v));
				end;
			end;

			return pa;
		end;

		getgenv().makefolder = function(path)
			local main = __get_path_c(path);
			local block = BaseWorkspace;

			for i,v in next , main do
				local item = block:FindFirstChild(v);
				if not item then
					local c = Instance.new('Folder',block);
					c.Name = tostring(v);
				else
					block = item;
				end;
			end;
		end;

		getgenv().delfile = function(path)
			local main = __get_path_c(path);
			local block = BaseWorkspace;

			for i,v in next , main do
				local item = block:FindFirstChild(v);
				if item and item:IsA('StringValue') then
					item:Destroy();
				else
					block = item;
				end;
			end;
		end;
	end;
end)

LOAD_ENV();

writefile = writefile or getgenv().writefile;
makefolder = makefolder or getgenv().makefolder;
readfile = readfile or getgenv().readfile;
delfolder = delfolder or getgenv().delfolder;
delfile = delfile or getgenv().delfile;
listfiles = listfiles or getgenv().listfiles;
isfolder = isfolder or getgenv().isfolder;
isfile = isfile or getgenv().isfile;

local NeverLose = {};

NeverLose.BuiltInRegular = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Regular,Enum.FontStyle.Normal);
NeverLose.BuiltInBold = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Bold,Enum.FontStyle.Normal);
NeverLose.GlobalSignals = {};
NeverLose.UnloadEnabled = false;

local TweenService: TweenService = cloneref(game:GetService('TweenService'));
local UserInputService: UserInputService = cloneref(game:GetService('UserInputService'));
local TextService: TextService = cloneref(game:GetService('TextService'));
local RunService: RunService = cloneref(game:GetService('RunService'));
local Players: Players = cloneref(game:GetService('Players'));
local HttpService: HttpService = cloneref(game:GetService('HttpService'));
local Stats: Stats = cloneref(game:GetService('Stats'));
local LocalPlayer: Player = Players.LocalPlayer;
local CoreGui: PlayerGui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or cloneref(game:FindFirstChild('CoreGui')) or cloneref(LocalPlayer.PlayerGui);
local Mouse: Mouse = LocalPlayer:GetMouse();
local CurrentCamera: Camera = cloneref(workspace.CurrentCamera);
local ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function(s) return s; end;
local GlobalWindow = Instance.new('ScreenGui');

local ManualTween = TweenInfo.new(0.1);
local SlowyTween = TweenInfo.new(0.175);
local FastTween = TweenInfo.new(0.05);
local VSlowTween = TweenInfo.new(0.5,Enum.EasingStyle.Quint);
local Encryption = {};

NeverLose.UserProfile = Players:GetUserThumbnailAsync(LocalPlayer.UserId , Enum.ThumbnailType.HeadShot , Enum.ThumbnailSize.Size150x150)
NeverLose.RandomString = LPH_NO_VIRTUALIZE(function()
	return string.rep(string.char(math.random(97,122)),math.random(3,6)).."_"..tostring(math.random(100000,999999));
end);

ProtectGui(GlobalWindow);

GlobalWindow.Name = NeverLose.RandomString();
GlobalWindow.IgnoreGuiInset = true;
GlobalWindow.ZIndexBehavior = Enum.ZIndexBehavior.Global;
GlobalWindow.ResetOnSpawn = false;
GlobalWindow.Parent = CoreGui;

NeverLose.Scales = {
	Small = UDim2.fromOffset(540,380),
	Mobile = UDim2.fromOffset(640,385),
	Default = UDim2.fromOffset(680 , 500),
	Large = UDim2.fromOffset(800 , 600)
};

NeverLose.IconColor = Color3.fromRGB(255, 255, 255);
NeverLose.ScreenGui = GlobalWindow;
NeverLose.Flags = {};
NeverLose.AccentColor = Color3.fromRGB(78, 127, 252);
NeverLose.MainColor = Color3.fromRGB(8, 8, 13);
NeverLose.RegisiteryColor = {};
NeverLose.NameRegisitry = {};
NeverLose.IsMosueOverOtherFrame = false;
NeverLose.GlobalLogo = "rbxassetid://120358385035996";
NeverLose.ImageColorMapping = "rbxassetid://4155801252";

function NeverLose:AddSignal(RBXSignal)
	if NeverLose.UnloadEnabled then
		table.insert(NeverLose.GlobalSignals,RBXSignal);
	end;
	return RBXSignal;
end;

function NeverLose:AddQuery(ItemRoot: Frame , Name : string)
	table.insert(NeverLose.NameRegisitry , {
		Root = ItemRoot,
		Idx = Name,
	});
end;

function Encryption.new(data: string)
	local bytes = {};
	local encrypt_seed = ((#data + 3782) % 111) + 1;

	string.gsub(data , '.', LPH_NO_VIRTUALIZE(function(dt)
		table.insert(bytes , tostring(dt:byte() + encrypt_seed));
	end));

	local concatbyte = table.concat(bytes,'?');
	table.clear(bytes);
	return "{"..tostring(encrypt_seed + 72667).."}?"..concatbyte;
end;

function Encryption.reverse(data: string)
	local main_data = string.split(data,'?');
	local seed_str = main_data[1]:gsub('{',''):gsub('}','');
	local seed = tonumber(seed_str);

	local ks = {};
	local real_seed = seed - 72667;

	for i,v in next , main_data do
		if i > 1 then
			local fake_byte = tonumber(v);
			table.insert(ks , string.char(fake_byte - real_seed))	
		end;
	end;

	local data_res = table.concat(ks);
	table.clear(ks);
	return data_res;
end;

do
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

	NeverLose.Base64Encode = LPH_NO_VIRTUALIZE(function(data)
		return ((data:gsub('.', function(x) 
			local r,bv='',x:byte()
			for i=8,1,-1 do r=r..(bv%2^i-bv%2^(i-1)>0 and '1' or '0') end
			return r;
		end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
			if (#x < 6) then return '' end
			local c=0
			for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
			return b:sub(c+1,c+1)
		end)..({ '', '==', '=' })[#data%3+1])
	end);

	NeverLose.Base64Decode = LPH_NO_VIRTUALIZE(function(data)
		data = string.gsub(data, '[^'..b..'=]', '')
		return (data:gsub('.', function(x)
			if (x == '=') then return '' end
			local r,f='',(b:find(x)-1)
			for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
			return r;
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if (#x ~= 8) then return '' end
			local c=0
			for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
			return string.char(c)
		end))
	end);
end;

NeverLose.IsMouseOverFrame = LPH_NO_VIRTUALIZE(function(self , Frame)
	if not Frame then return false; end;
	if NeverLose.Global3DRenderMode then
		if Frame.GuiState == Enum.GuiState.Hover or Frame.GuiState == Enum.GuiState.Press then
			return true;
		end;
		return false;
	end;

	local AbsPos: Vector2, AbsSize: Vector2 = Frame.AbsolutePosition, Frame.AbsoluteSize;
	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
	return false;
end);

NeverLose.CreateSignal = LPH_NO_VIRTUALIZE(function(self , DefaultValue)
	local __cache = Instance.new('BindableEvent');
	local bind = {
		Value = DefaultValue,
		__event = __cache
	};

	function bind:GetValue() return bind.Value; end;
	function bind:SetValue(f)
		bind.Value = f;
		return __cache:Fire(f);
	end;
	function bind:Connect(f)
		local signal = __cache.Event:Connect(f);
		NeverLose:AddSignal(signal);
		return signal;
	end;
	return bind;
end);

NeverLose.SetIconMode = LPH_NO_VIRTUALIZE(function(self , Label: TextLabel , Icon: string)
	local useBold = string.lower(string.sub(Icon , -5)) == '-bold';
	if useBold then
		Label.Text = Icon:sub(1,-6);
		Label.FontFace = NeverLose.BuiltInBold;
	else
		Label.Text = Icon;
		Label.FontFace = NeverLose.BuiltInRegular;
	end;
end);

function NeverLose:MoreThanHalfY(Value: number)
	return (NeverLose.ScreenGui.AbsoluteSize.Y / 2) < Value
end;

NeverLose.IsStudio = RunService:IsStudio();
NeverLose.IsMobile = UserInputService.TouchEnabled;

NeverLose.CreateInput = LPH_NO_VIRTUALIZE(function(self , Frame , Callback)
	local Button = Instance.new('ImageButton',Frame);
	Button.ZIndex = Frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.ImageTransparency = 1;
	if Callback then
		local bth_signal = Button.MouseButton1Click:Connect(Callback);
		return Button , bth_signal;
	end;
	return Button;
end);

NeverLose.PlayAnimate = LPH_NO_VIRTUALIZE(function(Self , Info , Property)
	local Tween = TweenService:Create(Self , Info or TweenInfo.new(0.25) , Property);
	Tween:Play();
	return Tween;
end);

NeverLose.Drag = LPH_NO_VIRTUALIZE(function(InputFrame: Frame, MoveFrame: Frame, Speed : number)
	local dragToggle: boolean = false;
	local dragStart: Vector3 = nil;
	local startPos: UDim2 = nil;
	local Tween = TweenInfo.new(Speed or 0.15);

	local updateInput = function(input)
		local delta = input.Position - dragStart;
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y);

		if NeverLose.Global3DRenderMode then
			NeverLose.PlayAnimate(MoveFrame,Tween,{ Position = UDim2.fromScale(0.5,0.5) });
		else
			NeverLose.PlayAnimate(MoveFrame,Tween,{ Position = position });
		end;
	end;

	NeverLose:AddSignal(InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true;
			dragStart = input.Position;
			startPos = MoveFrame.Position;

			local input_end;
			input_end = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false;
					input_end:Disconnect();
				end
			end)
		end
	end));

	NeverLose:AddSignal(UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end));
end);

NeverLose.Rounding = LPH_NO_VIRTUALIZE(function(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end);

NeverLose.ProcessParams = LPH_NO_VIRTUALIZE(function(self , Params , Fixed)
	Params = Params or {};
	local k = Params or {};
	for i,v in next , Fixed do
		k[i] = Params[i] or v;
	end;
	table.clear(Fixed);
	return k;
end);

NeverLose.EnabledBlur = true;
NeverLose.BlurModuleParent = workspace.CurrentCamera;

NeverLose.GetCalculatePosition = LPH_NO_VIRTUALIZE(function(planePos, planeNormal, rayOrigin, rayDirection)
	local n = planeNormal;
	local d = rayDirection;
	local v = rayOrigin - planePos;
	local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a = -num / den;
	return rayOrigin + (a * rayDirection);
end);

NeverLose.CreateBlurModule = LPH_NO_VIRTUALIZE(function(self , Frame , Signal)
	if not NeverLose.EnabledBlur then
		return NeverLose:AddSignal(Instance.new('BindableEvent').Event:Connect(function() return "nl"; end));	
	end;

	local Part = Instance.new('Part',NeverLose.BlurModuleParent);
	local DepthOfField = Instance.new('DepthOfFieldEffect',cloneref(game:GetService('Lighting')));
	local BlockMesh = Instance.new("BlockMesh");

	BlockMesh.Parent = Part;
	Part.Material = Enum.Material.Glass;
	Part.Transparency = 1;
	Part.Reflectance = 1;
	Part.CastShadow = false;
	Part.Anchored = true;
	Part.CanCollide = false;
	Part.CanQuery = false;
	Part.CollisionGroup = NeverLose.RandomString();
	Part.Size = Vector3.new(1, 1, 1) * 0.01;
	Part.Color = Color3.fromRGB(0,0,0);

	DepthOfField.Enabled = true;
	DepthOfField.FarIntensity = 0;
	DepthOfField.FocusDistance = 0;
	DepthOfField.InFocusRadius = 1000;
	DepthOfField.NearIntensity = 1;
	DepthOfField.Name = NeverLose.RandomString();
	Part.Name = NeverLose.RandomString();

	local disconnect;

	local UpdateFunction = function()
		local IsWindowActive = Signal:GetValue();

		if IsWindowActive and not NeverLose.Global3DRenderMode then
			NeverLose.PlayAnimate(DepthOfField,TweenInfo.new(0.1),{ NearIntensity = 1 })
			NeverLose.PlayAnimate(Part,TweenInfo.new(0.1),{ Transparency = 0.97, Size = Vector3.new(1, 1, 1) * 0.01; })
			Part.Parent = NeverLose.BlurModuleParent;
		else
			NeverLose.PlayAnimate(DepthOfField,TweenInfo.new(0.1),{ NearIntensity = 0 })
			NeverLose.PlayAnimate(Part,TweenInfo.new(0.1),{ Size = Vector3.zero, Transparency = 1.5 })
			Part.Parent = nil;
			return false;
		end;

		if IsWindowActive then
			local corner0 = Frame.AbsolutePosition;
			local corner1 = corner0 + Frame.AbsoluteSize;
			local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
			local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);
			local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);
			local planeNormal = CurrentCamera.CFrame.LookVector;

			local pos0 = NeverLose.GetCalculatePosition(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
			local pos1 = NeverLose.GetCalculatePosition(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);

			pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
			pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);

			local size   = pos1 - pos0;
			local center = (pos0 + pos1) / 2;

			BlockMesh.Offset = center
			BlockMesh.Scale  = size / 0.0101;
			Part.CFrame = CurrentCamera.CFrame;
		end;
	end;

	local rbxsignal = NeverLose:AddSignal(CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(UpdateFunction))
	local loopThread = NeverLose:AddSignal(UserInputService.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			pcall(UpdateFunction);
		end;
	end));

	local THREAD = task.spawn(function()
		while true do task.wait(0.1)
			pcall(UpdateFunction);
		end;
	end);

	disconnect = function()
		rbxsignal:Disconnect();
		loopThread:Disconnect();
		task.cancel(THREAD);
		Part:Destroy();
		DepthOfField:Destroy();
	end;

	Frame.Destroying:Connect(disconnect);
	return rbxsignal;
end);

local EmptyFunction = function() end;

function NeverLose:RollingEffect(parent)
	local UIGradient = Instance.new("UIGradient")
	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.4), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient.Parent = parent
	return UIGradient;
end;

function NeverLose:CreateShadow(parent , RollingEffect)
	local Shadow = {};
	local UIShadowSafe85 = Instance.new("UIStroke")
	local UIShadowSafe65 = Instance.new("UIStroke")
	local UIShadowSafe50 = Instance.new("UIStroke")
	local UIShadowSafe45 = Instance.new("UIStroke")

	UIShadowSafe85.Thickness = 6.000; UIShadowSafe85.Transparency = 1; UIShadowSafe85.Parent = parent
	UIShadowSafe65.Thickness = 5.000; UIShadowSafe65.Transparency = 1; UIShadowSafe65.Parent = parent
	UIShadowSafe50.Thickness = 4.000; UIShadowSafe50.Transparency = 1; UIShadowSafe50.Parent = parent
	UIShadowSafe45.Thickness = 3.000; UIShadowSafe45.Transparency = 1; UIShadowSafe45.Parent = parent

	local RollingEffectThread;
	local r1,r2,r3,r4;

	if RollingEffect then
		r1 = NeverLose:RollingEffect(UIShadowSafe85);
		r2 = NeverLose:RollingEffect(UIShadowSafe65);
		r3 = NeverLose:RollingEffect(UIShadowSafe50);
		r4 = NeverLose:RollingEffect(UIShadowSafe45);
	end;

	Shadow.Render = LPH_NO_VIRTUALIZE(function(self , value)
		if RollingEffectThread then
			task.cancel(RollingEffectThread);
			RollingEffectThread = nil;
		end;

		if value then
			NeverLose.PlayAnimate(UIShadowSafe85 , SlowyTween , { Transparency = 0.900 })
			NeverLose.PlayAnimate(UIShadowSafe65 , SlowyTween , { Transparency = 0.900 })
			NeverLose.PlayAnimate(UIShadowSafe50 , SlowyTween , { Transparency = 0.900 })
			NeverLose.PlayAnimate(UIShadowSafe45 , SlowyTween , { Transparency = 0.900 })

			if RollingEffect then
				RollingEffectThread = task.spawn(function()
					local level = 20;
					while true do task.wait(0.025)
						NeverLose.PlayAnimate(r1 , SlowyTween , { Rotation = r1.Rotation + level });
						NeverLose.PlayAnimate(r2 , SlowyTween , { Rotation = r2.Rotation + level });
						NeverLose.PlayAnimate(r3 , SlowyTween , { Rotation = r3.Rotation + level });
						NeverLose.PlayAnimate(r4 , SlowyTween , { Rotation = r4.Rotation + level });
					end;
				end);
			end;
		else
			NeverLose.PlayAnimate(UIShadowSafe85 , SlowyTween , { Transparency = 1 })
			NeverLose.PlayAnimate(UIShadowSafe65 , SlowyTween , { Transparency = 1 })
			NeverLose.PlayAnimate(UIShadowSafe50 , SlowyTween , { Transparency = 1 })
			NeverLose.PlayAnimate(UIShadowSafe45 , SlowyTween , { Transparency = 1 })
		end;
	end);

	return Shadow;
end;

function NeverLose:CreateOptionWindow(Frame: Frame , Zindex)
	Zindex = Zindex or 9;
	local Window = { Signal = NeverLose:CreateSignal(false) };

	local OptionHandler = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIListLayout = Instance.new("UIListLayout")
	local UIStroke = Instance.new("UIStroke")
	local shadow = NeverLose:CreateShadow(OptionHandler);

	OptionHandler.Name = NeverLose.RandomString();
	OptionHandler.Parent = NeverLose.ScreenGui
	OptionHandler.AnchorPoint = Vector2.new(0, 0)
	OptionHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	OptionHandler.BackgroundTransparency = 0.035
	OptionHandler.BorderSizePixel = 0
	OptionHandler.ClipsDescendants = true
	OptionHandler.Position = UDim2.new(255,255,255,255)
	OptionHandler.Size = UDim2.new(0, 220, 0, 75)
	OptionHandler.ZIndex = Zindex + 9

	UICorner.CornerRadius = UDim.new(0, 10); UICorner.Parent = OptionHandler
	UIListLayout.Parent = OptionHandler; UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIStroke.Transparency = 0.650; UIStroke.Color = Color3.fromRGB(45, 48, 58); UIStroke.Parent = OptionHandler

	NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
		NeverLose.PlayAnimate(OptionHandler , SlowyTween , { Size = UDim2.new(0, 220, 0, UIListLayout.AbsoluteContentSize.Y - 1) })
	end)));

	NeverLose:AddSignal(OptionHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if OptionHandler.BackgroundTransparency > 0.9 then
			OptionHandler.Visible = false;
			UIListLayout.Parent = nil;
			OptionHandler.Parent = nil;
		else
			OptionHandler.Visible = true;
			UIListLayout.Parent = OptionHandler
			OptionHandler.Parent = (NeverLose.Global3DRenderMode and NeverLose.GlobalSurfaceGui) or NeverLose.ScreenGui;
		end
	end)));

	local FollowingThread;
	local SetPosition = LPH_NO_VIRTUALIZE(function()
		if NeverLose:MoreThanHalfY(Frame.AbsolutePosition.Y + 65) then
			OptionHandler.AnchorPoint = Vector2.new(0,1)
		else
			OptionHandler.AnchorPoint = Vector2.new(0,0)
		end;
		OptionHandler.Position = UDim2.fromOffset(Frame.AbsolutePosition.X + 18 , Frame.AbsolutePosition.Y + 65);
	end);

	Window.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if FollowingThread then task.cancel(FollowingThread); FollowingThread = nil; end;

		if value then
			SetPosition();
			NeverLose.PlayAnimate(OptionHandler , SlowyTween , { BackgroundTransparency = 0.035 })
			NeverLose.PlayAnimate(UIStroke , SlowyTween , { Transparency = 0.650 })
			shadow:Render(true);
			OptionHandler.Parent = (NeverLose.Global3DRenderMode and NeverLose.GlobalSurfaceGui) or NeverLose.ScreenGui;

			FollowingThread = task.spawn(function()
				while true do task.wait() SetPosition(); end
			end)
		else
			NeverLose.PlayAnimate(OptionHandler , SlowyTween , { BackgroundTransparency = 1 })
			NeverLose.PlayAnimate(UIStroke , SlowyTween , { Transparency = 1 })
			shadow:Render(false);
		end;
	end);

	Window.SetRender(false);
	Window.Signal:Connect(Window.SetRender)

	local Payback = NeverLose:RegisiterItem(OptionHandler , Window.Signal);
	Payback.Winbdow = Window; Payback.Root = OptionHandler; Payback.Signal = Window.Signal;
	return Payback;
end;

function NeverLose:CreateColorPicker(HandleFrame: Frame)
	local ZIndex = HandleFrame.ZIndex;
	local ColorPickerLib = {};

	local ColorPickerHandler = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local SaViMap = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local ColorZoneSelection = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local ColorMap = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_4 = Instance.new("UICorner")
	local ColorMapSelection = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local UICorner_5 = Instance.new("UICorner")
	local RGBLabel = Instance.new("TextLabel")
	local UICorner_6 = Instance.new("UICorner")
	local Shadow = NeverLose:CreateShadow(ColorPickerHandler);

	ColorPickerHandler.Name = NeverLose.RandomString();
	ColorPickerHandler.Parent = NeverLose.ScreenGui
	ColorPickerHandler.AnchorPoint = Vector2.new(0, 0)
	ColorPickerHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	ColorPickerHandler.BackgroundTransparency = 0.035
	ColorPickerHandler.BorderSizePixel = 0
	ColorPickerHandler.ClipsDescendants = true
	ColorPickerHandler.Position = UDim2.new(255, 0, 255, 20)
	ColorPickerHandler.Size = UDim2.new(0, 200, 0, 240)
	ColorPickerHandler.ZIndex = ZIndex + 125

	NeverLose:AddSignal(ColorPickerHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if ColorPickerHandler.BackgroundTransparency > 0.9 then
			ColorPickerHandler.Visible = false;
			ColorPickerHandler.Parent = nil
		else
			ColorPickerHandler.Visible = true;
			ColorPickerHandler.Parent = (NeverLose.Global3DRenderMode and NeverLose.GlobalSurfaceGui) or NeverLose.ScreenGui;
		end;
	end)));

	UICorner.CornerRadius = UDim.new(0, 10); UICorner.Parent = ColorPickerHandler
	UIStroke.Transparency = 0.650; UIStroke.Color = Color3.fromRGB(45, 48, 58); UIStroke.Parent = ColorPickerHandler

	SaViMap.Name = NeverLose.RandomString(); SaViMap.Parent = ColorPickerHandler
	SaViMap.AnchorPoint = Vector2.new(0.5, 0); SaViMap.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
	SaViMap.BorderSizePixel = 0; SaViMap.Position = UDim2.new(0.5, 0, 0, 5); SaViMap.Size = UDim2.new(0, 185, 0, 185)
	SaViMap.ZIndex = ZIndex + 126; SaViMap.Image = NeverLose.ImageColorMapping
	UICorner_2.CornerRadius = UDim.new(0, 5); UICorner_2.Parent = SaViMap

	ColorZoneSelection.Name = NeverLose.RandomString(); ColorZoneSelection.Parent = SaViMap
	ColorZoneSelection.AnchorPoint = Vector2.new(0.5, 0.5); ColorZoneSelection.BackgroundTransparency = 1.000
	ColorZoneSelection.Position = UDim2.new(0.5, 0, 0.5, 0); ColorZoneSelection.Size = UDim2.new(0, 10, 0, 10)
	ColorZoneSelection.ZIndex = ZIndex + 127
	UICorner_3.CornerRadius = UDim.new(1, 0); UICorner_3.Parent = ColorZoneSelection
	UIStroke_2.Color = Color3.fromRGB(255, 255, 255); UIStroke_2.Parent = ColorZoneSelection

	ColorMap.Name = NeverLose.RandomString(); ColorMap.Parent = ColorPickerHandler
	ColorMap.AnchorPoint = Vector2.new(0.5, 0); ColorMap.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorMap.BorderSizePixel = 0; ColorMap.Position = UDim2.new(0.5, 0, 0, 200); ColorMap.Size = UDim2.new(1, -15, 0, 10)
	ColorMap.ZIndex = ZIndex + 126

	UIGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)),
		ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)),
		ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)),
		ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)),
		ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)),
		ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)),
		ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)),
		ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
	}
	UIGradient.Parent = ColorMap
	UICorner_4.CornerRadius = UDim.new(0, 3); UICorner_4.Parent = ColorMap

	ColorMapSelection.Name = NeverLose.RandomString(); ColorMapSelection.Parent = ColorMap
	ColorMapSelection.AnchorPoint = Vector2.new(0.5, 0.5); ColorMapSelection.BackgroundTransparency = 1.000
	ColorMapSelection.Position = UDim2.new(0, 0, 0.5, 0); ColorMapSelection.Size = UDim2.new(0, 5, 1, 0)
	ColorMapSelection.ZIndex = ZIndex + 126
	UIStroke_3.Thickness = 2.000; UIStroke_3.Color = Color3.fromRGB(255, 255, 255); UIStroke_3.Parent = ColorMapSelection
	UICorner_5.CornerRadius = UDim.new(0, 3); UICorner_5.Parent = ColorMapSelection

	RGBLabel.Name = NeverLose.RandomString(); RGBLabel.Parent = ColorPickerHandler
	RGBLabel.BackgroundColor3 = Color3.fromRGB(26, 28, 36); RGBLabel.BackgroundTransparency = 0.750
	RGBLabel.Position = UDim2.new(0, 10, 0, 217); RGBLabel.Size = UDim2.new(1, -20, 0, 15)
	RGBLabel.ZIndex = ZIndex + 127; RGBLabel.Font = Enum.Font.GothamBold
	RGBLabel.Text = "#FFFFFF"; RGBLabel.TextColor3 = Color3.fromRGB(255, 255, 255); RGBLabel.TextSize = 12.000
	RGBLabel.TextTransparency = 0.400; RGBLabel.TextXAlignment = Enum.TextXAlignment.Left
	UICorner_6.CornerRadius = UDim.new(0, 4); UICorner_6.Parent = RGBLabel

	ColorPickerLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if value then
			ColorPickerHandler.Position = UDim2.new(0,HandleFrame.AbsolutePosition.X + 20 , 0 ,HandleFrame.AbsolutePosition.Y + 75);
			NeverLose.PlayAnimate(ColorPickerHandler,SlowyTween , { BackgroundTransparency = 0.035 })
			NeverLose.PlayAnimate(UIStroke,SlowyTween , { Transparency = 0.650 })
			NeverLose.PlayAnimate(SaViMap,SlowyTween , { BackgroundTransparency = 0, ImageTransparency = 0 })
			NeverLose.PlayAnimate(UIStroke_2,SlowyTween , { Transparency = 0 })
			NeverLose.PlayAnimate(ColorMap,SlowyTween , { BackgroundTransparency = 0 })
			NeverLose.PlayAnimate(UIStroke_3,SlowyTween , { Transparency = 0 })
			NeverLose.PlayAnimate(RGBLabel,SlowyTween , { BackgroundTransparency = 0.750, TextTransparency = 0.400 })
			Shadow:Render(true)
		else
			NeverLose.PlayAnimate(ColorPickerHandler,SlowyTween , { BackgroundTransparency = 1 })
			NeverLose.PlayAnimate(UIStroke,SlowyTween , { Transparency = 1 })
			NeverLose.PlayAnimate(SaViMap,SlowyTween , { BackgroundTransparency = 1, ImageTransparency = 1 })
			NeverLose.PlayAnimate(UIStroke_2,SlowyTween , { Transparency = 1 })
			NeverLose.PlayAnimate(ColorMap,SlowyTween , { BackgroundTransparency = 1 })
			NeverLose.PlayAnimate(UIStroke_3,SlowyTween , { Transparency = 1 })
			NeverLose.PlayAnimate(RGBLabel,SlowyTween , { BackgroundTransparency = 1, TextTransparency = 1 })
			Shadow:Render(false)
		end;
	end);

	ColorPickerLib.SetRender(false);
	ColorPickerLib.Root = ColorPickerHandler;
	ColorPickerLib.H = 1; ColorPickerLib.S = 1; ColorPickerLib.V = 1;
	ColorPickerLib.Callback = EmptyFunction;

	function ColorPickerLib:Update()
		local RealColor = Color3.fromHSV(ColorPickerLib.H , ColorPickerLib.S , ColorPickerLib.V);
		NeverLose.PlayAnimate(ColorZoneSelection,ManualTween,{ Position = UDim2.fromScale(ColorPickerLib.S , 1 - ColorPickerLib.V) });
		NeverLose.PlayAnimate(SaViMap,ManualTween,{ BackgroundColor3 = Color3.fromHSV(ColorPickerLib.H , 1 , 1) });
		NeverLose.PlayAnimate(ColorMapSelection,ManualTween,{ Position = UDim2.fromScale(ColorPickerLib.H,0.5) });
		RGBLabel.Text = "#"..RealColor:ToHex();
		ColorPickerLib.Callback(RealColor);
	end;

	function ColorPickerLib:SetValue(Color)
		if typeof(Color) == 'string' then Color = Color3.fromHex(Color); end;
		local H , S , V = Color:ToHSV();
		ColorPickerLib.H = H; ColorPickerLib.S = S; ColorPickerLib.V = V;
		ColorPickerLib:Update();
	end;

	ColorPickerLib.IsHold = false;
	NeverLose:AddSignal(ColorPickerHandler.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;
		end;
	end));

	NeverLose:AddSignal(ColorPickerHandler.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = false;
		end;
	end));

	NeverLose:AddSignal(ColorMap.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;
			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or ColorPickerLib.IsHold) do task.wait()
				local ColorY = ColorMap.AbsolutePosition.X
				local ColorYM = ColorY + ColorMap.AbsoluteSize.X;
				local Value = math.clamp(Mouse.X, ColorY, ColorYM)
				ColorPickerLib.H = ((Value - ColorY) / (ColorYM - ColorY));
				ColorPickerLib:Update();
			end;
		end;
	end)));

	NeverLose:AddSignal(SaViMap.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;
			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or ColorPickerLib.IsHold) do task.wait();
				local PosX = SaViMap.AbsolutePosition.X;
				local ScaleX = PosX + SaViMap.AbsoluteSize.X;
				local Value, PosY = math.clamp(Mouse.X, PosX, ScaleX), SaViMap.AbsolutePosition.Y;
				local ScaleY = PosY + SaViMap.AbsoluteSize.Y;
				local Vals = math.clamp(Mouse.Y, PosY, ScaleY);

				ColorPickerLib.S = (Value - PosX) / (ScaleX - PosX);
				ColorPickerLib.V = (1 - ((Vals - PosY) / (ScaleY - PosY)));
				ColorPickerLib:Update();
			end
		end
	end)));

	return ColorPickerLib;
end;

NeverLose.KeyEnum = {
	One = '1', Two = '2', Three = '3', Four = '4', Five = '5',
	Six = '6', Seven = '7', Eight = '8', Nine = '9', Zero = '0',
	['Minus'] = "-", ['Plus'] = "+", BackSlash = "\\", Slash = "/",
	Period = '.', Semicolon = ';', Colon = ":", LeftControl = "LCtrl",
	RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift",
	Return = "Enter", LeftBracket = "[", RightBracket = "]", Quote = "'",
	Comma = ",", Equals = "=", LeftAlt = "LAlt", RightAlt = "RAlt", Escape = "Esc",
};

NeverLose.EnumReverse = {};
for i,v in next , NeverLose.KeyEnum do NeverLose.EnumReverse[v] = i; end;

function NeverLose:KeyCodeToStr(K: Enum.KeyCode)
	if typeof(K) == 'string' then
		return NeverLose.KeyEnum[K] or K;
	end;
	return (NeverLose.KeyEnum[K.Name] or K.Name);
end;

function NeverLose:StrToKeyCode(str: string)
	if NeverLose.EnumReverse[str] then
		return Enum.KeyCode[NeverLose.EnumReverse[str]];
	end;
	return Enum.KeyCode[str];
end;

function NeverLose.ProcessDropdown(value)
	if typeof(value) == 'table' then
		local data = {};
		for i,v in next , value do
			if typeof(v) == 'boolean' and typeof(i) ~= 'number' then
				data[i] = v;
			else
				data[v] = true;
			end;
		end;
		return data;
	else
		return value;
	end;
end;

function NeverLose.ParseDropdown(value)
	if not value then return 'Select'; end;
	local Out;

	if typeof(value) == 'table' then
		if #value > 0 then
			local x = {};
			for i,v in next , value do table.insert(x , tostring(v)) end;
			Out = table.concat(x,' , ');
			table.clear(x);
		else
			local x = {};
			for i,v in next , value do
				if v == true then table.insert(x , tostring(i)); end			
			end;
			Out = table.concat(x,' , ');
			table.clear(x)
			if not Out:byte() then Out = 'Select'; end
		end;
	else
		Out = tostring(value or 'Select');
	end;
	return Out;
end;

function NeverLose:ParseInput(Value , Numeric)
	if not Value then return (Numeric and nil) or ""; end;
	if Numeric then
		local out = string.gsub(tostring(Value), '[^0-9.%-]', '')
		if tonumber(out) then return tonumber(out); end;
		return nil;
	end;
	return Value;
end;

function NeverLose:CreateToolTips(Container: Frame , Name: string , Content: string)
	local Tooltips = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local TooltipName = Instance.new("TextLabel")
	local TooltipContent = Instance.new("TextLabel")
	local Shadow = NeverLose:CreateShadow(Tooltips);

	Tooltips.Name = NeverLose.RandomString();
	Tooltips.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	Tooltips.BackgroundTransparency = 0.075
	Tooltips.BorderSizePixel = 0
	Tooltips.ClipsDescendants = true
	Tooltips.Position = UDim2.new(255,255,255,255)
	Tooltips.Size = UDim2.new(0,0,0,0)
	Tooltips.ZIndex = 130

	UICorner.CornerRadius = UDim.new(0, 10); UICorner.Parent = Tooltips
	UIStroke.Transparency = 0.650; UIStroke.Color = Color3.fromRGB(45, 48, 58); UIStroke.Parent = Tooltips

	TooltipName.Name = NeverLose.RandomString(); TooltipName.Parent = Tooltips
	TooltipName.BackgroundTransparency = 1.000; TooltipName.Position = UDim2.new(0, 15, 0, 5)
	TooltipName.Size = UDim2.new(0, 1, 0, 20); TooltipName.ZIndex = 132
	TooltipName.Font = Enum.Font.GothamBold; TooltipName.Text = Name
	TooltipName.TextColor3 = Color3.fromRGB(255, 255, 255); TooltipName.TextSize = 15.000
	TooltipName.TextXAlignment = Enum.TextXAlignment.Left

	TooltipContent.Name = NeverLose.RandomString(); TooltipContent.Parent = Tooltips
	TooltipContent.BackgroundTransparency = 1.000; TooltipContent.Position = UDim2.new(0, 15, 0, 30)
	TooltipContent.Size = UDim2.new(0, 1, 0, 15); TooltipContent.ZIndex = 132
	TooltipContent.Font = Enum.Font.GothamBold; TooltipContent.Text = Content
	TooltipContent.TextColor3 = Color3.fromRGB(255, 255, 255); TooltipContent.TextSize = 12.000
	TooltipContent.TextTransparency = 0.650; TooltipContent.TextXAlignment = Enum.TextXAlignment.Left
	TooltipContent.TextYAlignment = Enum.TextYAlignment.Top

	local ToolTip = {};

	ToolTip.Update = LPH_NO_VIRTUALIZE(function()
		local SizeName = TextService:GetTextSize(TooltipName.Text , TooltipName.TextSize , TooltipName.Font , Vector2.new(math.huge,math.huge));
		local SizeContent = TextService:GetTextSize(TooltipContent.Text , TooltipContent.TextSize , TooltipContent.Font , Vector2.new(math.huge,math.huge));
		local MaxX = math.max(SizeName.X , SizeContent.X) + 65;
		local MaxY = SizeName.Y + SizeContent.Y + 30;
		NeverLose.PlayAnimate(Tooltips,SlowyTween , { Size = UDim2.new(0,MaxX,0,MaxY) })
	end)

	NeverLose:AddSignal(Tooltips:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if Tooltips.BackgroundTransparency > 0.9 then
			Tooltips.Visible = false; Tooltips.Parent = nil;
		else
			Tooltips.Visible = true;
			Tooltips.Parent = (NeverLose.Global3DRenderMode and NeverLose.GlobalSurfaceGui) or NeverLose.ScreenGui;
		end
	end)));

	ToolTip.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if value then
			Tooltips.Position = UDim2.fromOffset(Container.AbsolutePosition.X + Container.AbsoluteSize.X , Container.AbsolutePosition.Y + (Container.AbsoluteSize.Y + 25));
			NeverLose.PlayAnimate(Tooltips , SlowyTween , { BackgroundTransparency = 0.075 })
			NeverLose.PlayAnimate(UIStroke , SlowyTween , { Transparency = 0.650 })
			NeverLose.PlayAnimate(TooltipName , SlowyTween , { TextTransparency = 0 })
			NeverLose.PlayAnimate(TooltipContent , SlowyTween , { TextTransparency = 0.650 })
			ToolTip.Update();
			Shadow:Render(true);
		else
			NeverLose.PlayAnimate(Tooltips , SlowyTween , { BackgroundTransparency = 1 })
			NeverLose.PlayAnimate(UIStroke , SlowyTween , { Transparency = 1 })
			NeverLose.PlayAnimate(TooltipName , SlowyTween , { TextTransparency = 1 })
			NeverLose.PlayAnimate(TooltipContent , SlowyTween , { TextTransparency = 1 })
			Shadow:Render(false);
		end;
	end);

	ToolTip.SetRender(false);
	ToolTip.Update();

	local DelayThread;
	NeverLose:AddSignal(Container.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
		if DelayThread then task.cancel(DelayThread); DelayThread = nil; end;
		DelayThread = task.delay(1,ToolTip.SetRender,true);
	end)));

	NeverLose:AddSignal(Container.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
		if DelayThread then task.cancel(DelayThread); DelayThread = nil; end;
		ToolTip.SetRender(false);
		ToolTip.Update();
	end)))

	return ToolTip;
end;

-- Indicator System
function NeverLose:CreateIndicator()
	local IndicatorFrame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	IndicatorFrame.Name = NeverLose.RandomString(); IndicatorFrame.Parent = NeverLose.ScreenGui;
	IndicatorFrame.AnchorPoint = Vector2.new(0, 0.5); IndicatorFrame.BackgroundTransparency = 1.000
	IndicatorFrame.Position = UDim2.new(0, 15, 0.5, 0); IndicatorFrame.Size = UDim2.new(0, 100, 0, 100)
	IndicatorFrame.ZIndex = 15

	UIListLayout.Parent = IndicatorFrame; UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder; UIListLayout.Padding = UDim.new(0, 10)

	local Indicators = {
		Color = {
			Red = Color3.fromRGB(255, 102, 105),
			Green = Color3.fromRGB(135, 255, 143),
			White = Color3.fromRGB(186, 186, 186),
		},
		Root = IndicatorFrame
	};

	function Indicators.new(Config)
		Config = NeverLose:ProcessParams(Config , {
			Name = "Indicator",
			Icon = 'crosshairs',
			Color = 'Red',
		});

		local Indicator = { CurrentColor = Config.Color, Visible = false };

		local IndicatorItem = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Line = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIGradient = Instance.new("UIGradient")
		local Icon = Instance.new("TextLabel")
		local Content = Instance.new("TextLabel")
		local Shadow = NeverLose:CreateShadow(IndicatorItem);

		IndicatorItem.Name = NeverLose.RandomString();
		IndicatorItem.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
		IndicatorItem.BackgroundTransparency = 1
		IndicatorItem.Size = UDim2.new(0, 85, 0, 40); IndicatorItem.ZIndex = 16
		IndicatorItem.Visible = false;

		IndicatorItem:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if IndicatorItem.BackgroundTransparency > 0.9 then
				IndicatorItem.Parent = nil; IndicatorItem.Visible = false;
			else
				IndicatorItem.Parent = IndicatorFrame; IndicatorItem.Visible = true;
			end;
		end))

		UICorner.CornerRadius = UDim.new(0, 25); UICorner.Parent = IndicatorItem

		Line.Name = "Line"; Line.Parent = IndicatorItem
		Line.AnchorPoint = Vector2.new(0, 0.5); Line.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Line.Position = UDim2.new(0, 2, 0.5, 0); Line.BackgroundTransparency = 1; Line.Size = UDim2.new(0, 3, 0.65, 0); Line.ZIndex = 17
		UICorner_2.CornerRadius = UDim.new(0, 25); UICorner_2.Parent = Line

		UIGradient.Rotation = 90
		UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
		UIGradient.Parent = Line

		Icon.Name = "Icon"; Icon.Parent = IndicatorItem
		Icon.AnchorPoint = Vector2.new(0, 0.5); Icon.BackgroundTransparency = 1.000
		Icon.Position = UDim2.new(0, 10, 0.5, 0); Icon.Size = UDim2.new(0, 25, 0, 25); Icon.ZIndex = 17
		Icon.FontFace = NeverLose.BuiltInBold; Icon.Text = Config.Icon; Icon.TextColor3 = Color3.fromRGB(186, 186, 186)
		Icon.TextSize = 21.000; Icon.TextTransparency = 1

		Content.Name = "Content"; Content.Parent = IndicatorItem
		Content.AnchorPoint = Vector2.new(0, 0.5); Content.BackgroundTransparency = 1.000
		Content.Position = UDim2.new(0, 40, 0.5, 0); Content.Size = UDim2.new(1, -40, 0, 25); Content.ZIndex = 17
		Content.Font = Enum.Font.GothamBold; Content.Text = Config.Name; Content.TextColor3 = Color3.fromRGB(186, 186, 186)
		Content.TextSize = 20.000; Content.TextTransparency = 1; Content.TextXAlignment = Enum.TextXAlignment.Left

		Indicator.Update = LPH_NO_VIRTUALIZE(function()
			local text = TextService:GetTextSize(Content.Text,Content.TextSize , Content.Font , Vector2.new(math.huge,math.huge));
			NeverLose.PlayAnimate(IndicatorItem , SlowyTween , { Size = UDim2.new(0, text.X + 60, 0, 40) })
		end);

		Indicator.SetRender = LPH_NO_VIRTUALIZE(function(self , value)
			Indicator.Visible = value;
			if value then
				NeverLose.PlayAnimate(IndicatorItem , SlowyTween , { BackgroundTransparency = 0.200 });
				NeverLose.PlayAnimate(Line , SlowyTween , { BackgroundTransparency = 0, BackgroundColor3 = Indicators.Color[Indicator.CurrentColor] });
				NeverLose.PlayAnimate(Icon , VSlowTween , { TextTransparency = 0.250, TextColor3 = Indicators.Color[Indicator.CurrentColor] });
				NeverLose.PlayAnimate(Content , VSlowTween , { TextTransparency = 0.2, TextColor3 = Indicators.Color[Indicator.CurrentColor] });
				Shadow:Render(true);
			else
				NeverLose.PlayAnimate(IndicatorItem , SlowyTween , { BackgroundTransparency = 1 });
				NeverLose.PlayAnimate(Line , SlowyTween , { BackgroundTransparency = 1, BackgroundColor3 = Indicators.Color[Indicator.CurrentColor] });
				NeverLose.PlayAnimate(Icon , VSlowTween , { TextTransparency = 1, TextColor3 = Indicators.Color[Indicator.CurrentColor] });
				NeverLose.PlayAnimate(Content , VSlowTween , { TextTransparency = 1, TextColor3 = Indicators.Color[Indicator.CurrentColor] });
				Shadow:Render(false);
			end;
			Indicator.Update();
		end);

		Indicator.Update();
		Indicator:SetRender(false);

		function Indicator:SetColor(new_color)
			Indicator.CurrentColor = new_color;
			if Indicator.Visible then Indicator:SetRender(true); end;
		end;

		function Indicator:SetText(name)
			Config.Name = name;
			Content.Text = Config.Name;
			Indicator.Update();
		end;

		return Indicator;
	end;

	return Indicators;
end;

-- Logger Module
function NeverLose:CreateLogger()
	if NeverLose.__LogSystem then return NeverLose.__LogSystem; end;

	local Logging = {};
	local Log = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Log.Name = NeverLose.RandomString(); Log.Parent = NeverLose.ScreenGui
	Log.BackgroundTransparency = 1.000; Log.Position = UDim2.new(0, 25, 0, 5 + math.abs(NeverLose.ScreenGui.AbsolutePosition.Y))
	Log.Size = UDim2.new(0, 25, 0, 25)

	UIListLayout.Parent = Log; UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder; UIListLayout.Padding = UDim.new(0, 12)
	NeverLose.__LogSystem = Logging;

	function Logging.new(IconStr: string , Message: string , Duration: number)
		Duration = Duration or 3; Message = Message or "Log"; IconStr = IconStr or "crosshairs";

		local LogFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local LogContent = Instance.new("TextLabel")
		local Line = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local Icon = Instance.new("TextLabel")
		local Shadow = NeverLose:CreateShadow(LogFrame , true);

		LogFrame.Name = NeverLose.RandomString(); LogFrame.Parent = Log
		LogFrame.AnchorPoint = Vector2.new(0.5, 0); LogFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		LogFrame.BackgroundTransparency = 1; LogFrame.Size = UDim2.new(0, 0, 0, 20); LogFrame.ZIndex = 130

		UICorner.CornerRadius = UDim.new(0, 4); UICorner.Parent = LogFrame
		UIStroke.Transparency = 1; UIStroke.Color = Color3.fromRGB(45, 48, 58); UIStroke.Parent = LogFrame

		LogContent.Parent = LogFrame; LogContent.BackgroundTransparency = 1.000
		LogContent.Position = UDim2.new(0, 25, 0, 2); LogContent.Size = UDim2.new(0, 200, 0, 15); LogContent.ZIndex = 132
		LogContent.Font = Enum.Font.GothamBold; LogContent.Text = Message; LogContent.TextColor3 = Color3.fromRGB(255, 255, 255)
		LogContent.TextSize = 12.000; LogContent.TextTransparency = 1; LogContent.TextXAlignment = Enum.TextXAlignment.Left

		Line.Parent = LogFrame; Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.BackgroundColor3 = NeverLose.AccentColor; Line.BackgroundTransparency = 1; Line.Position = UDim2.new(0, -2, 0.5, 0)
		Line.Size = UDim2.new(0, 5, 1, 0); Line.ZIndex = 131
		UICorner_2.CornerRadius = UDim.new(0, 4); UICorner_2.Parent = Line

		Icon.Parent = LogFrame; Icon.BackgroundTransparency = 1.000
		Icon.Position = UDim2.new(0, 7, 0, 3); Icon.Size = UDim2.new(0, 15, 0, 15); Icon.ZIndex = 133
		Icon.FontFace = NeverLose.BuiltInBold; Icon.Text = IconStr; Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
		Icon.TextSize = 13.000; Icon.TextTransparency = 1

		local size = TextService:GetTextSize(LogContent.Text,LogContent.TextSize,LogContent.Font,Vector2.new(math.huge,math.huge));

		NeverLose.PlayAnimate(LogFrame , SlowyTween , { Size = UDim2.new(0, size.X + 35, 0, 20), BackgroundTransparency = 0.075 });

		task.delay(0.15,LPH_NO_VIRTUALIZE(function()
			Shadow:Render(true);
			NeverLose.PlayAnimate(UIStroke , SlowyTween , { Transparency = 0.650 });
			NeverLose.PlayAnimate(LogContent , SlowyTween , { TextTransparency = 0.25 });
			NeverLose.PlayAnimate(Line , SlowyTween , { BackgroundTransparency = 0 });
			NeverLose.PlayAnimate(Icon , SlowyTween , { TextTransparency = 0.25 });

			task.wait(Duration + 0.1);

			Shadow:Render(false);
			NeverLose.PlayAnimate(LogFrame , SlowyTween , { BackgroundTransparency = 1 });
			NeverLose.PlayAnimate(UIStroke , SlowyTween , { Transparency = 1 });
			NeverLose.PlayAnimate(LogContent , SlowyTween , { TextTransparency = 1 });
			NeverLose.PlayAnimate(Line , SlowyTween , { BackgroundTransparency = 1 });
			NeverLose.PlayAnimate(Icon , SlowyTween , { TextTransparency = 1 });

			task.wait(0.25);
			LogFrame:Destroy();
		end))
	end;

	return Logging
end;

-- Notifications Module
function NeverLose:CreateNotification()
	if NeverLose.__Notification_Cache then return NeverLose.__Notification_Cache; end;

	local Notifier = {};
	local Notification = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Notification.Name = NeverLose.RandomString(); Notification.Parent = NeverLose.ScreenGui;
	Notification.AnchorPoint = Vector2.new(1, 0); Notification.BackgroundTransparency = 1.000
	Notification.Position = UDim2.new(1, -25, 0, 25); Notification.Size = UDim2.new(0, 25, 0, 25)

	UIListLayout.Parent = Notification; UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	NeverLose.__Notification_Cache = Notifier;

	function Notifier.new(Config)
		Config = NeverLose:ProcessParams(Config , {
			Title = "Notification",
			Content = "Notification body text",
			Logo = NeverLose.GlobalLogo or "rbxasset://textures/ui/VerifiedBadgeNameIcon.png",
			Duration = 5,
		});

		local ContainerFrame = Instance.new("Frame")
		local NotifyFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local LogoImage = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local NotifyName = Instance.new("TextLabel")
		local NotifyContent = Instance.new("TextLabel")
		local shadow = NeverLose:CreateShadow(NotifyFrame , true);

		ContainerFrame.Parent = Notification; ContainerFrame.BackgroundTransparency = 1.000; ContainerFrame.Size = UDim2.new(0, 0, 0, 100)

		NotifyFrame.Parent = ContainerFrame; NotifyFrame.AnchorPoint = Vector2.new(1, 0)
		NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27); NotifyFrame.BackgroundTransparency = 0.075
		NotifyFrame.Position = UDim2.new(0, 750, 0, 0); NotifyFrame.Size = UDim2.new(0, 220, 0, 55); NotifyFrame.ZIndex = 130
		UICorner.CornerRadius = UDim.new(0, 10); UICorner.Parent = NotifyFrame
		UIStroke.Transparency = 0.650; UIStroke.Color = Color3.fromRGB(45, 48, 58); UIStroke.Parent = NotifyFrame

		LogoImage.Parent = NotifyFrame; LogoImage.AnchorPoint = Vector2.new(0, 0.5)
		LogoImage.BackgroundTransparency = 1.000; LogoImage.Position = UDim2.new(0, 10, 0.5, 0)
		LogoImage.Size = UDim2.new(0, 35, 0, 35); LogoImage.ZIndex = 131
		LogoImage.Image = Config.Logo; LogoImage.ImageColor3 = NeverLose.IconColor;
		UICorner_2.CornerRadius = UDim.new(0, 7); UICorner_2.Parent = LogoImage

		NotifyName.Parent = NotifyFrame; NotifyName.BackgroundTransparency = 1.000
		NotifyName.Position = UDim2.new(0, 50, 0, 7); NotifyName.Size = UDim2.new(0, 200, 0, 20); NotifyName.ZIndex = 132
		NotifyName.Font = Enum.Font.GothamBold; NotifyName.Text = Config.Title; NotifyName.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifyName.TextSize = 17.000; NotifyName.TextXAlignment = Enum.TextXAlignment.Left

		NotifyContent.Parent = NotifyFrame; NotifyContent.BackgroundTransparency = 1.000
		NotifyContent.Position = UDim2.new(0, 50, 0, 28); NotifyContent.Size = UDim2.new(0, 200, 0, 15); NotifyContent.ZIndex = 132
		NotifyContent.Font = Enum.Font.GothamBold; NotifyContent.Text = Config.Content; NotifyContent.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifyContent.TextSize = 12.000; NotifyContent.TextTransparency = 0.650; NotifyContent.TextXAlignment = Enum.TextXAlignment.Left

		local Size1 = TextService:GetTextSize(NotifyName.Text,NotifyName.TextSize,NotifyName.Font,Vector2.new(math.huge,math.huge));
		local Size2 = TextService:GetTextSize(NotifyContent.Text,NotifyContent.TextSize,NotifyContent.Font,Vector2.new(math.huge,math.huge));
		local MainSize = math.max(Size1.X , Size2.X);

		NotifyFrame.Size = UDim2.new(0, MainSize + 65, 0, 55);
		shadow:Render(true)
		NeverLose.PlayAnimate(NotifyFrame , VSlowTween , { Position = UDim2.new(1, 0, 0, 0) })
		ContainerFrame.Size = UDim2.new(0, 0, 0, 65)

		task.delay(Config.Duration or 5 , LPH_NO_VIRTUALIZE(function()
			shadow:Render(false)
			NeverLose.PlayAnimate(NotifyFrame , SlowyTween , { BackgroundTransparency = 1 })
			NeverLose.PlayAnimate(UIStroke , SlowyTween , { Transparency = 1 })
			NeverLose.PlayAnimate(LogoImage , SlowyTween , { ImageTransparency = 1 })
			NeverLose.PlayAnimate(NotifyName , SlowyTween , { TextTransparency = 1 })
			NeverLose.PlayAnimate(NotifyContent , SlowyTween , { TextTransparency = 1 })
			task.wait(0.125);
			NeverLose.PlayAnimate(ContainerFrame , SlowyTween , { Size = UDim2.new(0, 0, 0, 0) })
			task.wait(0.125);
			ContainerFrame:Destroy();
		end))
	end;

	return Notifier;
end;

-- Capsule HUD Widget
function NeverLose:CreateHUDWidget(Config)
	Config = NeverLose:ProcessParams(Config, {
		Title = "<b>Head</b><font color=\"rgb(78, 127, 252)\">Shot</font>",
	});

	local HUD = {};
	local HUDFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")

	local TitleLabel = Instance.new("TextLabel")
	local PingLabel = Instance.new("TextLabel")
	local FpsLabel = Instance.new("TextLabel")
	local TimeLabel = Instance.new("TextLabel")

	local Avatar = Instance.new("ImageLabel")
	local AvatarCorner = Instance.new("UICorner")
	local AvatarStroke = Instance.new("UIStroke")

	HUDFrame.Name = NeverLose.RandomString();
	HUDFrame.Parent = NeverLose.ScreenGui;
	HUDFrame.AnchorPoint = Vector2.new(0.5, 0)
	HUDFrame.Position = UDim2.new(0.5, 0, 0, 15)
	HUDFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 19)
	HUDFrame.BackgroundTransparency = 0.15
	HUDFrame.Size = UDim2.new(0, 310, 0, 34)
	HUDFrame.ZIndex = 200
	HUDFrame.ClipsDescendants = true

	UICorner.CornerRadius = UDim.new(1, 0); UICorner.Parent = HUDFrame
	UIStroke.Thickness = 1; UIStroke.Color = Color3.fromRGB(45, 48, 58); UIStroke.Transparency = 0.5; UIStroke.Parent = HUDFrame

	NeverLose.Drag(HUDFrame, HUDFrame, 0.1)

	TitleLabel.Parent = HUDFrame; TitleLabel.BackgroundTransparency = 1; TitleLabel.Position = UDim2.new(0, 15, 0, 0); TitleLabel.Size = UDim2.new(0, 75, 1, 0)
	TitleLabel.Font = Enum.Font.GothamBold; TitleLabel.Text = Config.Title; TitleLabel.RichText = true; TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); TitleLabel.TextSize = 13; TitleLabel.ZIndex = 201; TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	PingLabel.Parent = HUDFrame; PingLabel.BackgroundTransparency = 1; PingLabel.Position = UDim2.new(0, 95, 0, 0); PingLabel.Size = UDim2.new(0, 50, 1, 0)
	PingLabel.Font = Enum.Font.GothamMedium; PingLabel.Text = "0 ms"; PingLabel.TextColor3 = Color3.fromRGB(220, 220, 220); PingLabel.TextSize = 12; PingLabel.ZIndex = 201

	FpsLabel.Parent = HUDFrame; FpsLabel.BackgroundTransparency = 1; FpsLabel.Position = UDim2.new(0, 150, 0, 0); FpsLabel.Size = UDim2.new(0, 50, 1, 0)
	FpsLabel.Font = Enum.Font.GothamMedium; FpsLabel.Text = "60 fps"; FpsLabel.TextColor3 = Color3.fromRGB(220, 220, 220); FpsLabel.TextSize = 12; FpsLabel.ZIndex = 201

	TimeLabel.Parent = HUDFrame; TimeLabel.BackgroundTransparency = 1; TimeLabel.Position = UDim2.new(0, 205, 0, 0); TimeLabel.Size = UDim2.new(0, 55, 1, 0)
	TimeLabel.Font = Enum.Font.GothamMedium; TimeLabel.Text = "00:00"; TimeLabel.TextColor3 = Color3.fromRGB(220, 220, 220); TimeLabel.TextSize = 12; TimeLabel.ZIndex = 201

	Avatar.Parent = HUDFrame; Avatar.AnchorPoint = Vector2.new(1, 0.5); Avatar.Position = UDim2.new(1, -5, 0.5, 0); Avatar.Size = UDim2.new(0, 26, 0, 26)
	Avatar.Image = NeverLose.UserProfile; Avatar.BackgroundTransparency = 1; Avatar.ZIndex = 202
	AvatarCorner.CornerRadius = UDim.new(1, 0); AvatarCorner.Parent = Avatar
	AvatarStroke.Thickness = 1.5; AvatarStroke.Color = Color3.fromRGB(255, 255, 255); AvatarStroke.Transparency = 0.2; AvatarStroke.Parent = Avatar

	local fpsCount, lastUpdate = 0, tick()
	local connection = RunService.RenderStepped:Connect(function()
		fpsCount += 1
		if tick() - lastUpdate >= 1 then
			FpsLabel.Text = tostring(fpsCount).." fps"
			fpsCount = 0
			lastUpdate = tick()

			local ping = 0
			pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
			PingLabel.Text = tostring(ping).." ms"
			TimeLabel.Text = os.date("%H:%M")
		end
	end)
	NeverLose:AddSignal(connection);

	function HUD:SetRender(val)
		HUDFrame.Visible = val;
	end;

	HUD:SetRender(false);
	return HUD;
end;

-- Main Window Creation
function NeverLose:CreateWindow(Config)
	Config = NeverLose:ProcessParams(Config , {
		Logo = NeverLose.GlobalLogo,
		Name = "HeadShot",
		Content = "get good, get headshot",
		Size = UDim2.new(0, 680, 0, 500),
		ConfigFolder = "HeadShotConfigs",
		Keybind = "Insert",
		Mascot = {
			Enabled = true,
			IsVideo = false,
			AssetId = "rbxassetid://135894103135848"
		}
	});

	local Window = {
		Name = Config.Name,
		Content = Config.Content,
		Size = Config.Size,
		ConfigFolder = Config.ConfigFolder,
		Signal = NeverLose:CreateSignal(true),
		Tabs = {},
		CurrentTab = 1,
		Keybind = Config.Keybind,
		MascotConfig = Config.Mascot
	};

	local Logging = NeverLose:CreateLogger();

	if not isfolder(Window.ConfigFolder) then
		makefolder(Window.ConfigFolder);
	end;

	local WindowFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local LeftMenuFrame = Instance.new("Frame")
	local HeadFrame = Instance.new("Frame")
	local LogoImage = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local WindowName = Instance.new("TextLabel")
	local WindowContent = Instance.new("TextLabel")
	local LineFrame = Instance.new("Frame")
	local LeftScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")

	local BottomFrame = Instance.new("Frame")
	local AccountProfile = Instance.new("ImageLabel")
	local UICorner_3 = Instance.new("UICorner")
	local AccountName = Instance.new("TextLabel")
	local ExpireLabel = Instance.new("TextLabel")
	local LineFrame_2 = Instance.new("Frame")
	local UserSettingButton = Instance.new("TextLabel")

	local RightMenuFrame = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UICorner_4 = Instance.new("UICorner")
	local RightHeader = Instance.new("Frame")
	local LineFrame_3 = Instance.new("Frame")

	local HeaderTitle = Instance.new("TextLabel")
	local HeaderDescription = Instance.new("TextLabel")

	local SearchFrame = Instance.new("Frame")
	local SearchIcon = Instance.new("TextLabel")
	local SearchBox = Instance.new("TextBox")
	local HeaderAvatar = Instance.new("ImageLabel")
	local HeaderAvatarCorner = Instance.new("UICorner")
	local HeaderAvatarStroke = Instance.new("UIStroke")

	local TabContainer = Instance.new("Frame")
	local MascotElement = nil;

	WindowFrame.Name = NeverLose.RandomString();
	WindowFrame.Parent = NeverLose.ScreenGui;
	WindowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	WindowFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
	WindowFrame.BackgroundTransparency = 0.05
	WindowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	WindowFrame.Size = Window.Size
	WindowFrame.Active = true;
	UICorner.Parent = WindowFrame

	Window.Shadow = NeverLose:CreateShadow(WindowFrame);
	Window.Shadow:Render(true);

	if NeverLose.EnabledBlur then
		NeverLose:CreateBlurModule(WindowFrame, Window.Signal);
	end;

	-- Mascot System
	if Window.MascotConfig and Window.MascotConfig.AssetId then
		if Window.MascotConfig.IsVideo then
			MascotElement = Instance.new("VideoFrame")
			MascotElement.Looped = true
			MascotElement.Playing = true
			MascotElement.Video = Window.MascotConfig.AssetId
		else
			MascotElement = Instance.new("ImageLabel")
			MascotElement.Image = Window.MascotConfig.AssetId
		end;

		MascotElement.Name = "Mascot";
		MascotElement.Parent = WindowFrame;
		MascotElement.AnchorPoint = Vector2.new(1, 1);
		MascotElement.Position = UDim2.new(1, -20, 0, 10);
		MascotElement.Size = UDim2.new(0, 160, 0, 200);
		MascotElement.BackgroundTransparency = 1;
		MascotElement.ZIndex = 4;
		MascotElement.Visible = Window.MascotConfig.Enabled or false;
	end;

	function Window:SetMascotVisible(val)
		if MascotElement then
			MascotElement.Visible = val;
		end;
	end;

	-- Drag Frame
	local DragBar = Instance.new("Frame", WindowFrame)
	DragBar.BackgroundTransparency = 1
	DragBar.Size = UDim2.new(1, 0, 0, 50)
	DragBar.ZIndex = 15
	NeverLose.Drag(DragBar, WindowFrame, 0.15)

	-- Left Sidebar
	LeftMenuFrame.Parent = WindowFrame
	LeftMenuFrame.BackgroundTransparency = 1
	LeftMenuFrame.Size = UDim2.new(0, 175, 1, 0)

	HeadFrame.Parent = LeftMenuFrame
	HeadFrame.BackgroundTransparency = 1
	HeadFrame.Size = UDim2.new(1, 0, 0, 55)

	LogoImage.Parent = HeadFrame
	LogoImage.AnchorPoint = Vector2.new(0, 0.5)
	LogoImage.BackgroundTransparency = 1
	LogoImage.Position = UDim2.new(0, 10, 0.5, 0)
	LogoImage.Size = UDim2.new(0, 40, 0, 40)
	LogoImage.Image = Config.Logo
	UICorner_2.CornerRadius = UDim.new(0, 7); UICorner_2.Parent = LogoImage

	WindowName.Parent = HeadFrame
	WindowName.BackgroundTransparency = 1
	WindowName.Position = UDim2.new(0, 55, 0, 8)
	WindowName.Size = UDim2.new(0, 110, 0, 20)
	WindowName.Font = Enum.Font.GothamBold
	WindowName.Text = Window.Name
	WindowName.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowName.TextSize = 17.000
	WindowName.TextXAlignment = Enum.TextXAlignment.Left

	WindowContent.Parent = HeadFrame
	WindowContent.BackgroundTransparency = 1
	WindowContent.Position = UDim2.new(0, 55, 0, 27)
	WindowContent.Size = UDim2.new(0, 110, 0, 15)
	WindowContent.Font = Enum.Font.GothamMedium
	WindowContent.Text = Window.Content
	WindowContent.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowContent.TextSize = 9.000
	WindowContent.TextTransparency = 0.650
	WindowContent.TextXAlignment = Enum.TextXAlignment.Left

	LineFrame.Parent = HeadFrame
	LineFrame.AnchorPoint = Vector2.new(0.5, 1)
	LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame.BackgroundTransparency = 0.650
	LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
	LineFrame.Size = UDim2.new(1, -10, 0, 1)

	LeftScrollingFrame.Parent = LeftMenuFrame
	LeftScrollingFrame.BackgroundTransparency = 1
	LeftScrollingFrame.Position = UDim2.new(0.5, 0, 0, 60)
	LeftScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
	LeftScrollingFrame.Size = UDim2.new(1, -10, 1, -115)
	LeftScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = LeftScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		LeftScrollingFrame.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y + 5)
	end)

	-- Bottom User Profile Card
	BottomFrame.Parent = LeftMenuFrame
	BottomFrame.AnchorPoint = Vector2.new(0, 1)
	BottomFrame.BackgroundTransparency = 1.000
	BottomFrame.Position = UDim2.new(0, 0, 1, 0)
	BottomFrame.Size = UDim2.new(1, 0, 0, 50)
	BottomFrame.ZIndex = 7

	AccountProfile.Parent = BottomFrame; AccountProfile.AnchorPoint = Vector2.new(0, 0.5)
	AccountProfile.BackgroundTransparency = 1.000; AccountProfile.Position = UDim2.new(0, 10, 0.5, 0)
	AccountProfile.Size = UDim2.new(0, 35, 0, 35); AccountProfile.ZIndex = 7; AccountProfile.Image = NeverLose.UserProfile or ""
	UICorner_3.CornerRadius = UDim.new(1, 0); UICorner_3.Parent = AccountProfile

	AccountName.Parent = BottomFrame; AccountName.BackgroundTransparency = 1.000
	AccountName.Position = UDim2.new(0, 55, 0, 5); AccountName.Size = UDim2.new(0, 100, 0, 25); AccountName.ZIndex = 7
	AccountName.Font = Enum.Font.GothamBold; AccountName.Text = LocalPlayer.DisplayName; AccountName.TextColor3 = Color3.fromRGB(255, 255, 255); AccountName.TextSize = 14.000; AccountName.TextXAlignment = Enum.TextXAlignment.Left

	ExpireLabel.Parent = BottomFrame; ExpireLabel.BackgroundTransparency = 1.000
	ExpireLabel.Position = UDim2.new(0, 55, 0, 25); ExpireLabel.Size = UDim2.new(0, 200, 0, 15); ExpireLabel.ZIndex = 7
	ExpireLabel.Font = Enum.Font.GothamBold; ExpireLabel.Text = "never"; ExpireLabel.TextColor3 = Color3.fromRGB(255, 255, 255); ExpireLabel.TextSize = 10.000; ExpireLabel.TextTransparency = 0.650; ExpireLabel.TextXAlignment = Enum.TextXAlignment.Left

	LineFrame_2.Parent = BottomFrame; LineFrame_2.AnchorPoint = Vector2.new(0.5, 0)
	LineFrame_2.BackgroundColor3 = Color3.fromRGB(45, 48, 58); LineFrame_2.BackgroundTransparency = 0.650
	LineFrame_2.Position = UDim2.new(0.5, 0, 0, 0); LineFrame_2.Size = UDim2.new(1, -10, 0, 1)

	UserSettingButton.Parent = BottomFrame; UserSettingButton.AnchorPoint = Vector2.new(1, 0.5)
	UserSettingButton.BackgroundTransparency = 1.000; UserSettingButton.Position = UDim2.new(1, -7, 0.5, 0)
	UserSettingButton.Size = UDim2.new(0, 25, 0, 25); UserSettingButton.ZIndex = 7
	UserSettingButton.FontFace = NeverLose.BuiltInBold; UserSettingButton.Text = "chevron-large-right"
	UserSettingButton.TextColor3 = Color3.fromRGB(255, 255, 255); UserSettingButton.TextSize = 13.000; UserSettingButton.TextTransparency = 0.5

	-- Right Content Area
	RightMenuFrame.Parent = WindowFrame
	RightMenuFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
	RightMenuFrame.BackgroundTransparency = 0.600
	RightMenuFrame.Position = UDim2.new(0, 176, 0, 0)
	RightMenuFrame.Size = UDim2.new(1, -176, 1, 0)
	RightMenuFrame.ClipsDescendants = true
	RightMenuFrame.ZIndex = 8

	UIStroke.Transparency = 0.650; UIStroke.Color = Color3.fromRGB(45, 48, 58); UIStroke.Parent = RightMenuFrame
	UICorner_4.CornerRadius = UDim.new(0, 13); UICorner_4.Parent = RightMenuFrame

	RightHeader.Parent = RightMenuFrame
	RightHeader.BackgroundTransparency = 1.000
	RightHeader.Size = UDim2.new(1, 0, 0, 50)
	RightHeader.ZIndex = 9

	LineFrame_3.Parent = RightHeader
	LineFrame_3.AnchorPoint = Vector2.new(0.5, 1)
	LineFrame_3.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame_3.BackgroundTransparency = 0.650
	LineFrame_3.Position = UDim2.new(0.5, 0, 1, 0)
	LineFrame_3.Size = UDim2.new(1, -10, 0, 1)
	LineFrame_3.ZIndex = 9

	-- Breadcrumb / Tab title & description
	HeaderTitle.Parent = RightHeader
	HeaderTitle.BackgroundTransparency = 1
	HeaderTitle.Position = UDim2.new(0, 15, 0, 8)
	HeaderTitle.Size = UDim2.new(0, 220, 0, 18)
	HeaderTitle.Font = Enum.Font.GothamBold
	HeaderTitle.Text = Window.Name .. " / Tab"
	HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	HeaderTitle.TextSize = 14
	HeaderTitle.TextTransparency = 0.1
	HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

	HeaderDescription.Parent = RightHeader
	HeaderDescription.BackgroundTransparency = 1
	HeaderDescription.Position = UDim2.new(0, 15, 0, 26)
	HeaderDescription.Size = UDim2.new(0, 220, 0, 15)
	HeaderDescription.Font = Enum.Font.GothamMedium
	HeaderDescription.Text = "Tab description"
	HeaderDescription.TextColor3 = Color3.fromRGB(200, 200, 200)
	HeaderDescription.TextSize = 10
	HeaderDescription.TextTransparency = 0.5
	HeaderDescription.TextXAlignment = Enum.TextXAlignment.Left

	-- Rightmost Header Avatar
	HeaderAvatar.Parent = RightHeader
	HeaderAvatar.AnchorPoint = Vector2.new(1, 0.5)
	HeaderAvatar.Position = UDim2.new(1, -15, 0.5, 0)
	HeaderAvatar.Size = UDim2.new(0, 30, 0, 30)
	HeaderAvatar.Image = NeverLose.UserProfile
	HeaderAvatar.BackgroundTransparency = 1
	HeaderAvatar.ZIndex = 12
	HeaderAvatarCorner.CornerRadius = UDim.new(1, 0); HeaderAvatarCorner.Parent = HeaderAvatar
	HeaderAvatarStroke.Thickness = 1.5; HeaderAvatarStroke.Color = Color3.fromRGB(255, 255, 255); HeaderAvatarStroke.Transparency = 0.4; HeaderAvatarStroke.Parent = HeaderAvatar

	-- Search Box
	SearchFrame.Parent = RightHeader
	SearchFrame.AnchorPoint = Vector2.new(1, 0.5)
	SearchFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	SearchFrame.BackgroundTransparency = 0.5
	SearchFrame.Position = UDim2.new(1, -55, 0.5, 0)
	SearchFrame.Size = UDim2.new(0, 140, 0, 28)
	SearchFrame.ZIndex = 12

	local SearchFrameCorner = Instance.new("UICorner", SearchFrame)
	SearchFrameCorner.CornerRadius = UDim.new(0, 6)
	local SearchFrameStroke = Instance.new("UIStroke", SearchFrame)
	SearchFrameStroke.Color = Color3.fromRGB(45, 48, 58); SearchFrameStroke.Transparency = 0.65

	SearchIcon.Parent = SearchFrame
	SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
	SearchIcon.BackgroundTransparency = 1.000
	SearchIcon.Position = UDim2.new(0, 5, 0.5, 0)
	SearchIcon.Size = UDim2.new(0, 20, 0, 20)
	SearchIcon.ZIndex = 12
	SearchIcon.FontFace = NeverLose.BuiltInBold
	SearchIcon.Text = "magnifying-glass"
	SearchIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
	SearchIcon.TextSize = 13.000
	SearchIcon.TextTransparency = 0.45

	SearchBox.Parent = SearchFrame
	SearchBox.AnchorPoint = Vector2.new(0, 0.5)
	SearchBox.BackgroundTransparency = 1.000
	SearchBox.Position = UDim2.new(0, 25, 0.5, 0)
	SearchBox.Size = UDim2.new(1, -30, 0, 20)
	SearchBox.ZIndex = 12
	SearchBox.ClearTextOnFocus = false
	SearchBox.Font = Enum.Font.GothamMedium
	SearchBox.PlaceholderText = "Search..."
	SearchBox.Text = ""
	SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.TextSize = 11.000
	SearchBox.TextTransparency = 0.2
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	NeverLose:AddSignal(SearchBox:GetPropertyChangedSignal('Text'):Connect(function()
		local text = string.lower(SearchBox.Text);
		for _, v in next, NeverLose.NameRegisitry do
			if text == "" or string.find(string.lower(v.Idx), text, 1, true) then
				v.Root.Visible = true;
			else
				v.Root.Visible = false;
			end;
		end;
	end));

	TabContainer.Parent = RightMenuFrame
	TabContainer.BackgroundTransparency = 1.000
	TabContainer.Position = UDim2.new(0, 0, 0, 50)
	TabContainer.Size = UDim2.new(1, 0, 1, -50)
	TabContainer.ZIndex = 5

	-- Init Capsule HUD Widget
	Window.HUDWidget = NeverLose:CreateHUDWidget({
		Title = "<b>"..Window.Name:sub(1,4).."</b><font color=\"rgb(78, 127, 252)\">"..Window.Name:sub(5).."</font>"
	});

	function Window:AddTab(Config)
		Config = NeverLose:ProcessParams(Config , {
			Icon = "crosshairs",
			Name = "Tab",
			Description = "Tab settings & modifications",
			Type = "Double"
		});

		local Tab = {
			Name = Config.Name,
			Description = Config.Description,
			Signal = NeverLose:CreateSignal(false);
		};

		local TabButton = Instance.new("Frame")
		local UICorner_T = Instance.new("UICorner")
		local TabIcon = Instance.new("TextLabel")
		local TabContentLabel = Instance.new("TextLabel")

		Tab.Idx = TabButton;
		TabButton.Name = NeverLose.RandomString();
		TabButton.Parent = LeftScrollingFrame
		TabButton.BackgroundColor3 = Color3.fromRGB(41, 45, 49)
		TabButton.BackgroundTransparency = 1
		TabButton.Size = UDim2.new(1, -1, 0, 30)
		TabButton.ZIndex = 8

		UICorner_T.CornerRadius = UDim.new(0, 6); UICorner_T.Parent = TabButton

		TabIcon.Parent = TabButton
		TabIcon.AnchorPoint = Vector2.new(0, 0.5)
		TabIcon.BackgroundTransparency = 1.000
		TabIcon.Position = UDim2.new(0, 4, 0.5, 0)
		TabIcon.Size = UDim2.new(0, 22, 0, 22)
		TabIcon.ZIndex = 9
		TabIcon.FontFace = NeverLose.BuiltInBold
		TabIcon.Text = Config.Icon;
		TabIcon.TextColor3 = NeverLose.AccentColor
		TabIcon.TextSize = 15.000

		TabContentLabel.Parent = TabButton
		TabContentLabel.AnchorPoint = Vector2.new(0, 0.5)
		TabContentLabel.BackgroundTransparency = 1.000
		TabContentLabel.Position = UDim2.new(0, 30, 0.5, 0)
		TabContentLabel.Size = UDim2.new(1, -35, 0, 15)
		TabContentLabel.ZIndex = 9
		TabContentLabel.Font = Enum.Font.GothamMedium
		TabContentLabel.Text = Config.Name
		TabContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabContentLabel.TextSize = 12.000
		TabContentLabel.TextTransparency = 0.5
		TabContentLabel.TextXAlignment = Enum.TextXAlignment.Left

		local TabFrame = Instance.new("Frame")
		local LeftScroll = Instance.new("ScrollingFrame")
		local UIListLayout_L = Instance.new("UIListLayout")
		local RightScroll = Instance.new("ScrollingFrame")
		local UIListLayout_R = Instance.new("UIListLayout")

		TabFrame.Parent = TabContainer
		TabFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		TabFrame.BackgroundTransparency = 1.000
		TabFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.Visible = false;

		LeftScroll.Parent = TabFrame; LeftScroll.BackgroundTransparency = 1
		LeftScroll.Position = UDim2.new(0.25, 0, 0.5, 0); LeftScroll.AnchorPoint = Vector2.new(0.5, 0.5)
		LeftScroll.Size = UDim2.new(0.5, 0, 1, -5); LeftScroll.ScrollBarThickness = 0

		UIListLayout_L.Parent = LeftScroll; UIListLayout_L.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout_L.SortOrder = Enum.SortOrder.LayoutOrder; UIListLayout_L.Padding = UDim.new(0, 8)
		UIListLayout_L:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			LeftScroll.CanvasSize = UDim2.fromOffset(0, UIListLayout_L.AbsoluteContentSize.Y + 5)
		end)

		RightScroll.Parent = TabFrame; RightScroll.BackgroundTransparency = 1
		RightScroll.Position = UDim2.new(0.75, 0, 0.5, 0); RightScroll.AnchorPoint = Vector2.new(0.5, 0.5)
		RightScroll.Size = UDim2.new(0.5, 0, 1, -5); RightScroll.ScrollBarThickness = 0

		UIListLayout_R.Parent = RightScroll
		UIListLayout_R.SortOrder = Enum.SortOrder.LayoutOrder; UIListLayout_R.Padding = UDim.new(0, 8)
		UIListLayout_R:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			RightScroll.CanvasSize = UDim2.fromOffset(0, UIListLayout_R.AbsoluteContentSize.Y + 5)
		end)

		if Config.Type == "Single" then
			RightScroll:Destroy();
			LeftScroll.Size = UDim2.new(1, 0, 1, -5);
			LeftScroll.Position = UDim2.new(0.5, 0, 0.5, 0)
		end;

		Tab.SetValue = LPH_NO_VIRTUALIZE(function(value)
			Tab.Signal:SetValue(value);
			TabFrame.Visible = value;

			if value then
				HeaderTitle.Text = Window.Name .. " / " .. Tab.Name;
				HeaderDescription.Text = Tab.Description;

				NeverLose.PlayAnimate(TabButton , SlowyTween , { BackgroundTransparency = 0.500 })
				NeverLose.PlayAnimate(TabIcon , SlowyTween , { TextTransparency = 0, TextColor3 = NeverLose.AccentColor })
				NeverLose.PlayAnimate(TabContentLabel , SlowyTween , { TextTransparency = 0 })
			else
				NeverLose.PlayAnimate(TabButton , SlowyTween , { BackgroundTransparency = 1 })
				NeverLose.PlayAnimate(TabIcon , SlowyTween , { TextTransparency = 0.5, TextColor3 = Color3.fromRGB(252, 252, 252) })
				NeverLose.PlayAnimate(TabContentLabel , SlowyTween , { TextTransparency = 0.5 })
			end;
		end);

		table.insert(Window.Tabs, Tab);

		NeverLose:CreateInput(TabButton, function()
			for i, v in next, Window.Tabs do
				if v.Idx == TabButton then
					v.SetValue(true);
					Window.CurrentTab = i;
				else
					v.SetValue(false);
				end;
			end;
		end);

		function Tab:AddSection(SectionConfig)
			SectionConfig = NeverLose:ProcessParams(SectionConfig , {
				Name = "SECTION",
				Position = 'left'
			});

			local SectionFrame = Instance.new("Frame")
			local SectionLabel = Instance.new("TextLabel")
			local SectionHandler = Instance.new("Frame")
			local SectionStroke = Instance.new("UIStroke")
			local SectionCorner = Instance.new("UICorner")
			local SectionLayout = Instance.new("UIListLayout")

			SectionFrame.Parent = (string.lower(SectionConfig.Position) == 'left' and LeftScroll) or RightScroll
			SectionFrame.BackgroundTransparency = 1.000
			SectionFrame.Size = UDim2.new(1, -10, 0, 0)
			SectionFrame.ZIndex = 9

			SectionLabel.Parent = SectionFrame
			SectionLabel.AnchorPoint = Vector2.new(0.5, 0)
			SectionLabel.BackgroundTransparency = 1.000
			SectionLabel.Position = UDim2.new(0.5, 0, 0, 0)
			SectionLabel.Size = UDim2.new(1, -20, 0, 15)
			SectionLabel.Font = Enum.Font.GothamMedium
			SectionLabel.Text = SectionConfig.Name
			SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionLabel.TextSize = 11.000
			SectionLabel.TextTransparency = 0.500
			SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

			SectionHandler.Parent = SectionFrame
			SectionHandler.AnchorPoint = Vector2.new(0.5, 0)
			SectionHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
			SectionHandler.BackgroundTransparency = 0.500
			SectionHandler.Position = UDim2.new(0.5, 0, 0, 20)
			SectionHandler.Size = UDim2.new(1, 0, 1, -21)
			SectionHandler.ZIndex = 9

			SectionStroke.Transparency = 0.650; SectionStroke.Color = Color3.fromRGB(45, 48, 58); SectionStroke.Parent = SectionHandler
			SectionCorner.CornerRadius = UDim.new(0, 10); SectionCorner.Parent = SectionHandler

			SectionLayout.Parent = SectionHandler
			SectionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder

			SectionLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				SectionFrame.Size = UDim2.new(1, -10, 0, SectionLayout.AbsoluteContentSize.Y + 24)
			end);

			local Section = NeverLose:RegisiterItem(SectionHandler , Tab.Signal);
			return Section;
		end;

		return Tab;
	end;

	-- Configs Engine with full encryption
	local ConfigEngine = {};
	function ConfigEngine:GetData()
		local data = {};
		for Flag, v in next, NeverLose.Flags do
			if v and v.GetValue then
				local val = v:GetValue();
				if typeof(val) == 'Color3' then
					table.insert(data, { Idx = Flag, Value = val:ToHex() });
				else
					table.insert(data, { Idx = Flag, Value = val });
				end;
			end;
		end;
		return NeverLose.Base64Encode(Encryption.new(HttpService:JSONEncode(data)));
	end;

	function ConfigEngine:LoadData(raw)
		local success, coded = pcall(function()
			return HttpService:JSONDecode(Encryption.reverse(NeverLose.Base64Decode(raw)));
		end);
		if success and type(coded) == "table" then
			for _, item in next, coded do
				if item.Idx and NeverLose.Flags[item.Idx] and NeverLose.Flags[item.Idx].SetValue then
					task.spawn(function()
						NeverLose.Flags[item.Idx]:SetValue(item.Value);
					end);
				end;
			end;
		end;
	end;

	-- Built-in Settings Tab (Default)
	local SettingsTab = Window:AddTab({
		Name = "Settings",
		Icon = "three-sliders-horizontal",
		Description = Window.Name .. " / Settings"
	});

	local InterfaceSection = SettingsTab:AddSection({
		Name = "Interface",
		Position = "left"
	});

	local ConfigSection = SettingsTab:AddSection({
		Name = "Configs / " .. Window.ConfigFolder,
		Position = "right"
	});

	-- Interface Elements
	InterfaceSection:AddLabel("HUD Widget"):AddToggle({
		Default = false,
		Callback = function(val)
			Window.HUDWidget:SetRender(val);
		end
	});

	InterfaceSection:AddLabel("Show the mascot"):AddToggle({
		Default = (Window.MascotConfig and Window.MascotConfig.Enabled) or false,
		Callback = function(val)
			Window:SetMascotVisible(val);
		end
	});

	-- Configs Elements
	local TypedConfigName = "default";
	local ConfigInputLabel = ConfigSection:AddLabel("default");

	ConfigSection:AddButton({
		Name = "Save Config",
		Callback = function()
			if TypedConfigName ~= "" then
				writefile(Window.ConfigFolder .. "/" .. TypedConfigName, ConfigEngine:GetData());
				Logging.new("folder", "Saved " .. tostring(TypedConfigName), 3.5);
			end;
		end
	});

	ConfigSection:AddButton({
		Name = "Browse Configs",
		Callback = function()
			local files = listfiles(Window.ConfigFolder);
			if #files > 0 then
				local clean = string.gsub(files[1], Window.ConfigFolder .. "/", "");
				TypedConfigName = clean;
				ConfigInputLabel:SetText(clean);
				Logging.new("folder", "Selected " .. clean, 2.5);
			end;
		end
	});

	ConfigSection:AddButton({
		Name = "Load Typed",
		Callback = function()
			local path = Window.ConfigFolder .. "/" .. TypedConfigName;
			if isfile(path) then
				ConfigEngine:LoadData(readfile(path));
				Logging.new("folder", "Loaded " .. tostring(TypedConfigName), 3.5);
			else
				Logging.new("trash-can", "Config file not found!", 3.5);
			end;
		end
	});

	-- Keybind Toggling
	NeverLose:AddSignal(UserInputService.InputBegan:Connect(function(input, isTyping)
		if isTyping then return end;
		if input.KeyCode == Enum.KeyCode[Window.Keybind] or input.KeyCode.Name == Window.Keybind then
			WindowFrame.Visible = not WindowFrame.Visible;
		end;
	end));

	task.delay(0.05, function()
		if #Window.Tabs > 0 then
			Window.Tabs[1].SetValue(true);
		end;
	end);

	return Window;
end;

return NeverLose;
