--[[
                          Neverlose.cc / HeadShot UI Library
    Author: 4lpaca (Fixed Architecture & Settings Integration)
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

		BaseWorkspace.Name = 'PRI\0.'..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)));

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
			local success , message = pcall(function() return __get_path(path); end);
			return success and not message:IsA("Folder");
		end;

		getgenv().isfolder = function(path)
			local success , message = pcall(function() return __get_path(path); end);
			return success and message:IsA("Folder");
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
	return string.rep(string.char(math.random(97,122)), 6) .. "_" .. tostring(math.random(100000, 999999));
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

function NeverLose:MoreThanHalfY(Value: number)
	return (NeverLose.ScreenGui.AbsoluteSize.Y / 2) < Value
end;

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
		NeverLose.PlayAnimate(MoveFrame,Tween,{ Position = position });
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
	local k = {};
	for i,v in next , Fixed do
		k[i] = Params[i] or v;
	end;
	return k;
end);

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

	Shadow.Render = LPH_NO_VIRTUALIZE(function(self , value)
		local target = value and 0.900 or 1;
		NeverLose.PlayAnimate(UIShadowSafe85 , SlowyTween , { Transparency = target })
		NeverLose.PlayAnimate(UIShadowSafe65 , SlowyTween , { Transparency = target })
		NeverLose.PlayAnimate(UIShadowSafe50 , SlowyTween , { Transparency = target })
		NeverLose.PlayAnimate(UIShadowSafe45 , SlowyTween , { Transparency = target })
	end);

	return Shadow;
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
	TooltipContent.Font = Enum.Font.GothamMedium; TooltipContent.Text = Content
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

	ToolTip.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if value then
			Tooltips.Position = UDim2.fromOffset(Container.AbsolutePosition.X + Container.AbsoluteSize.X , Container.AbsolutePosition.Y + 10);
			Tooltips.Parent = NeverLose.ScreenGui;
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
	NeverLose:AddSignal(Container.MouseEnter:Connect(function()
		if DelayThread then task.cancel(DelayThread) end;
		DelayThread = task.delay(0.6, ToolTip.SetRender, true);
	end));
	NeverLose:AddSignal(Container.MouseLeave:Connect(function()
		if DelayThread then task.cancel(DelayThread) end;
		ToolTip.SetRender(false);
	end));

	return ToolTip;
end;

function NeverLose:RegisiterHandler(Handler: Frame , Signal)
	local handle = {};
	local ZINdex = Handler.ZIndex;

	function handle:AddToggle(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = false,
			Flag = nil,
			Callback = function() end,
		});

		local Toggle = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Circle = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")

		Toggle.Name = NeverLose.RandomString();
		Toggle.Parent = Handler
		Toggle.BackgroundColor3 = Color3.fromRGB(10, 13, 21)
		Toggle.BorderSizePixel = 0
		Toggle.ClipsDescendants = true
		Toggle.Size = UDim2.new(0, 32, 0, 18)
		Toggle.ZIndex = ZINdex + 13
		Toggle.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = UDim.new(1, 0); UICorner.Parent = Toggle

		Circle.Name = NeverLose.RandomString(); Circle.Parent = Toggle
		Circle.AnchorPoint = Vector2.new(0.5, 0.5); Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 0.500; Circle.Position = UDim2.new(0.3, 0, 0.5, 0)
		Circle.Size = UDim2.new(0, 14, 0, 14); Circle.ZIndex = ZINdex + 14
		UICorner_2.CornerRadius = UDim.new(1, 0); UICorner_2.Parent = Circle

		local ToggleLib = { Root = Toggle };

		ToggleLib.SetUI = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(Toggle,SlowyTween,{ BackgroundTransparency = 0, BackgroundColor3 = NeverLose.AccentColor })
				NeverLose.PlayAnimate(Circle,SlowyTween,{ BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0, Position = UDim2.new(0.7, 0, 0.5, 0) })
			else
				NeverLose.PlayAnimate(Toggle,SlowyTween,{ BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(10, 13, 21) })
				NeverLose.PlayAnimate(Circle,SlowyTween,{ BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.500, Position = UDim2.new(0.3, 0, 0.5, 0) })
			end;
		end);

		ToggleLib.SetUI(Config.Default);

		NeverLose:CreateInput(Toggle , LPH_NO_VIRTUALIZE(function()
			Config.Default = not Config.Default;
			ToggleLib.SetUI(Config.Default);
			Config.Callback(Config.Default)
		end))

		function ToggleLib:GetValue() return Config.Default; end;
		function ToggleLib:SetValue(v)
			Config.Default = v;
			ToggleLib.SetUI(Config.Default);
			Config.Callback(Config.Default);
		end;

		if Config.Flag then NeverLose.Flags[Config.Flag] = ToggleLib; end;
		return ToggleLib;
	end;

	function handle:AddSlider(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = 50,
			Min = 0,
			Max = 100,
			Type = "",
			Rounding = 0,
			Flag = nil,
			Size = 125,
			Callback = function() end,
		});

		local SliderLib = {};
		SliderLib.GetSize = function() return (Config.Default - Config.Min) / (Config.Max - Config.Min); end;

		local Slider = Instance.new("Frame")
		local ValueLabel = Instance.new("TextBox")
		local SlideMain = Instance.new("Frame")
		local SlideFrame = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local SlideMoving = Instance.new("Frame")
		local UICorner_4 = Instance.new("UICorner")

		Slider.Name = NeverLose.RandomString(); Slider.Parent = Handler
		Slider.BackgroundTransparency = 1; Slider.Size = UDim2.new(0, Config.Size, 0, 18)
		Slider.ZIndex = ZINdex + 13

		SlideMain.Name = "SlideMain"; SlideMain.Parent = Slider
		SlideMain.AnchorPoint = Vector2.new(0, 0.5); SlideMain.BackgroundTransparency = 1
		SlideMain.Position = UDim2.new(0, 0, 0.5, 0); SlideMain.Size = UDim2.new(1, -35, 0, 18)
		SlideMain.ZIndex = ZINdex + 13

		SlideFrame.Name = "SlideFrame"; SlideFrame.Parent = SlideMain
		SlideFrame.AnchorPoint = Vector2.new(0, 0.5); SlideFrame.BackgroundColor3 = Color3.fromRGB(30, 29, 36)
		SlideFrame.Position = UDim2.new(0, 0, 0.5, 0); SlideFrame.Size = UDim2.new(1, 0, 0, 5)
		SlideFrame.ZIndex = ZINdex + 13
		UICorner_3.CornerRadius = UDim.new(1, 0); UICorner_3.Parent = SlideFrame

		SlideMoving.Name = "SlideMoving"; SlideMoving.Parent = SlideFrame
		SlideMoving.BackgroundColor3 = NeverLose.AccentColor
		SlideMoving.Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0); SlideMoving.ZIndex = ZINdex + 14
		UICorner_4.CornerRadius = UDim.new(1, 0); UICorner_4.Parent = SlideMoving

		ValueLabel.Name = "ValueLabel"; ValueLabel.Parent = Slider
		ValueLabel.AnchorPoint = Vector2.new(1, 0.5); ValueLabel.BackgroundTransparency = 1
		ValueLabel.Position = UDim2.new(1, 0, 0.5, 0); ValueLabel.Size = UDim2.new(0, 30, 1, 0)
		ValueLabel.ZIndex = ZINdex + 14; ValueLabel.Font = Enum.Font.GothamMedium
		ValueLabel.Text = tostring(Config.Default)..tostring(Config.Type);
		ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255); ValueLabel.TextSize = 10.000
		ValueLabel.TextTransparency = 0.350

		local Update = function(Input)
			local SizeScale = math.clamp((((Input.Position.X) - SlideMain.AbsolutePosition.X) / SlideMain.AbsoluteSize.X), 0, 1);
			local Main = ((Config.Max - Config.Min) * SizeScale) + Config.Min;
			local Value = NeverLose.Rounding(Main,Config.Rounding);
			Config.Default = Value;
			SlideMoving.Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0);
			ValueLabel.Text = tostring(Config.Default)..tostring(Config.Type);
			Config.Callback(Value);
		end;

		local IsHold = false;
		SlideMain.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsHold = true; Update(Input);
			end
		end);
		SlideMain.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsHold = false;
			end
		end);
		UserInputService.InputChanged:Connect(function(Input)
			if IsHold and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
				Update(Input);
			end;
		end);

		function SliderLib:GetValue() return Config.Default; end;
		function SliderLib:SetValue(v)
			Config.Default = v;
			SlideMoving.Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0);
			ValueLabel.Text = tostring(Config.Default)..tostring(Config.Type);
			Config.Callback(Config.Default);
		end;

		if Config.Flag then NeverLose.Flags[Config.Flag] = SliderLib; end;
		return SliderLib;
	end;

	function handle:AddDropdown(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = nil,
			Values = {},
			Multi = false,
			Callback = function() end,
			Flag = nil,
			Size = 110
		});

		local Dropdown = Instance.new("Frame")
		local DropdownIcon = Instance.new("TextLabel")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local BasedLabel = Instance.new("TextLabel")

		Dropdown.Name = NeverLose.RandomString(); Dropdown.Parent = Handler
		Dropdown.BackgroundColor3 = Color3.fromRGB(26, 28, 36); Dropdown.Size = UDim2.new(0, Config.Size, 0, 18)
		Dropdown.ZIndex = ZINdex + 13

		DropdownIcon.Parent = Dropdown; DropdownIcon.AnchorPoint = Vector2.new(1, 0.5)
		DropdownIcon.BackgroundTransparency = 1.000; DropdownIcon.Position = UDim2.new(1, -2, 0.5, 0)
		DropdownIcon.Size = UDim2.new(0, 18, 0, 18); DropdownIcon.FontFace = NeverLose.BuiltInBold
		DropdownIcon.Text = "chevron-small-down"; DropdownIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
		DropdownIcon.TextSize = 15; DropdownIcon.TextTransparency = 0.250

		UICorner.CornerRadius = UDim.new(0, 4); UICorner.Parent = Dropdown
		UIStroke.Transparency = 0.650; UIStroke.Color = Color3.fromRGB(45, 48, 58); UIStroke.Parent = Dropdown

		BasedLabel.Parent = Dropdown; BasedLabel.AnchorPoint = Vector2.new(0, 0.5)
		BasedLabel.BackgroundTransparency = 1.000; BasedLabel.Position = UDim2.new(0, 5, 0.5, 0)
		BasedLabel.Size = UDim2.new(1, -25, 0, 15); BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = tostring(Config.Default or "Select"); BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 11.000; BasedLabel.TextTransparency = 0.4; BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		local DropdownLib = { Values = Config.Values, Current = Config.Default };

		function DropdownLib:GetValue() return DropdownLib.Current; end;
		function DropdownLib:SetValue(val)
			DropdownLib.Current = val;
			BasedLabel.Text = tostring(val);
			Config.Callback(val);
		end;

		if Config.Flag then NeverLose.Flags[Config.Flag] = DropdownLib; end;
		return DropdownLib;
	end;

	function handle:AddKeybind(Config)
		Config = NeverLose:ProcessParams(Config,{
			Default = "None",
			Callback = function() end,
			Flag = nil
		});

		local Keybind = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ValueLabel = Instance.new("TextLabel")

		Keybind.Name = NeverLose.RandomString(); Keybind.Parent = Handler
		Keybind.BackgroundColor3 = Color3.fromRGB(26, 28, 36); Keybind.Size = UDim2.new(0, 45, 0, 18)
		Keybind.ZIndex = ZINdex + 13

		UICorner.CornerRadius = UDim.new(0, 4); UICorner.Parent = Keybind
		UIStroke.Transparency = 0.650; UIStroke.Color = Color3.fromRGB(45, 48, 58); UIStroke.Parent = Keybind

		ValueLabel.Parent = Keybind; ValueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueLabel.BackgroundTransparency = 1.000; ValueLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueLabel.Size = UDim2.new(1, 0, 1, 0); ValueLabel.Font = Enum.Font.GothamMedium
		ValueLabel.Text = NeverLose:KeyCodeToStr(Config.Default)
		ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255); ValueLabel.TextSize = 10.000
		ValueLabel.TextTransparency = 0.500

		local KeybindLib = {};
		local IsBinding = false;

		NeverLose:CreateInput(Keybind, function()
			if IsBinding then return end;
			IsBinding = true;
			ValueLabel.Text = "...";

			local Selected = nil;
			while not Selected do
				local Key = UserInputService.InputBegan:Wait();
				if Key.KeyCode ~= Enum.KeyCode.Unknown then
					Selected = Key.KeyCode.Name;
				elseif Key.UserInputType == Enum.UserInputType.MouseButton1 then
					Selected = "M1";
				elseif Key.UserInputType == Enum.UserInputType.MouseButton2 then
					Selected = "M2";
				end;
			end;

			IsBinding = false;
			Config.Default = Selected;
			ValueLabel.Text = NeverLose:KeyCodeToStr(Selected);
			Config.Callback(Selected);
		end);

		function KeybindLib:GetValue() return Config.Default; end;
		function KeybindLib:SetValue(v)
			Config.Default = v;
			ValueLabel.Text = NeverLose:KeyCodeToStr(v);
			Config.Callback(v);
		end;

		if Config.Flag then NeverLose.Flags[Config.Flag] = KeybindLib; end;
		return KeybindLib;
	end;

	return handle;
end;

-- Registrator for Items (MUST BE DECLARED BEFORE CREATEWINDOW)
function NeverLose:RegisiterItem(Frame: Frame , Signel)
	local idx = {};
	local LayerIndex = Frame.ZIndex;

	function idx:AddLabel(Name: string)
		local BasedFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local BasedHandler = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local UICorner = Instance.new("UICorner")

		BasedFrame.Name = NeverLose.RandomString();
		BasedFrame.Parent = Frame
		BasedFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		BasedFrame.BackgroundTransparency = 1.000
		BasedFrame.Size = UDim2.new(1, 0, 0, 30)
		BasedFrame.ZIndex = LayerIndex + 8

		NeverLose:AddQuery(BasedFrame , Name);

		BasedLabel.Name = "Label"; BasedLabel.Parent = BasedFrame
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.Position = UDim2.new(0, 11, 0, 6)
		BasedLabel.Size = UDim2.new(0,1, 0, 15)
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = Name
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 13.000
		BasedLabel.TextTransparency = 0.35
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = "Line"; LineFrame.Parent = BasedFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)

		BasedHandler.Name = "Handler"; BasedHandler.Parent = BasedFrame
		BasedHandler.AnchorPoint = Vector2.new(1, 0)
		BasedHandler.BackgroundTransparency = 1.000
		BasedHandler.Position = UDim2.new(1, -11, 0, 2)
		BasedHandler.Size = UDim2.new(1, -20, 0, 25)
		BasedHandler.ZIndex = LayerIndex + 12

		UIListLayout.Parent = BasedHandler
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 5)

		UICorner.CornerRadius = UDim.new(0, 10); UICorner.Parent = BasedFrame

		local handle = NeverLose:RegisiterHandler(BasedHandler , Signel);
		handle.Root = BasedFrame;

		function handle:SetText(t) BasedLabel.Text = t; end;
		function handle:ToolTip(Content: string)
			handle.ToolTip = NeverLose:CreateToolTips(BasedFrame , Name , Content);
			return handle;
		end;

		return handle;
	end;

	function idx:AddButton(Config)
		Config = NeverLose:ProcessParams(Config , {
			Icon = 'chevron-large-right',
			Name = "Button",
			Callback = function() end,
			ToolTip = nil,
		});

		local Button = {};
		local ButtonFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")

		NeverLose:AddQuery(ButtonFrame , Config.Name);

		ButtonFrame.Name = NeverLose.RandomString();
		ButtonFrame.Parent = Frame
		ButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		ButtonFrame.BackgroundTransparency = 1.000
		ButtonFrame.Size = UDim2.new(1, 0, 0, 30)
		ButtonFrame.ZIndex = LayerIndex + 8

		BasedLabel.Name = "ButtonLabel"; BasedLabel.Parent = ButtonFrame
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.Position = UDim2.new(0, 15, 0, 6)
		BasedLabel.Size = UDim2.new(1, -30, 0, 15)
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = Config.Name;
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 13.000
		BasedLabel.TextTransparency = 0.200
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Center

		LineFrame.Name = "Line"; LineFrame.Parent = ButtonFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)

		UICorner.CornerRadius = UDim.new(0, 10); UICorner.Parent = ButtonFrame

		local bth = NeverLose:CreateInput(ButtonFrame , function()
			Config.Callback();
		end);

		NeverLose:AddSignal(bth.MouseEnter:Connect(function()
			NeverLose.PlayAnimate(ButtonFrame , SlowyTween , { BackgroundTransparency = 0.35 });
		end));

		NeverLose:AddSignal(bth.MouseLeave:Connect(function()
			NeverLose.PlayAnimate(ButtonFrame , SlowyTween , { BackgroundTransparency = 1 });
		end));

		if Config.ToolTip then
			Button.ToolTip = NeverLose:CreateToolTips(ButtonFrame , Config.Name , Config.ToolTip);
		end;

		return Button;
	end;

	return idx;
end;

-- Aliases to avoid typo errors
NeverLose.RegisterItem = NeverLose.RegisiterItem;
NeverLose.RegisterHandler = NeverLose.RegisiterHandler;

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

	-- Drag
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
	LeftScrollingFrame.Size = UDim2.new(1, -10, 1, -70)
	LeftScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = LeftScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		LeftScrollingFrame.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y + 5)
	end)

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

	HeaderAvatar.Parent = RightHeader
	HeaderAvatar.AnchorPoint = Vector2.new(1, 0.5)
	HeaderAvatar.Position = UDim2.new(1, -15, 0.5, 0)
	HeaderAvatar.Size = UDim2.new(0, 30, 0, 30)
	HeaderAvatar.Image = NeverLose.UserProfile
	HeaderAvatar.BackgroundTransparency = 1
	HeaderAvatar.ZIndex = 12
	HeaderAvatarCorner.CornerRadius = UDim.new(1, 0); HeaderAvatarCorner.Parent = HeaderAvatar
	HeaderAvatarStroke.Thickness = 1.5; HeaderAvatarStroke.Color = Color3.fromRGB(255, 255, 255); HeaderAvatarStroke.Transparency = 0.4; HeaderAvatarStroke.Parent = HeaderAvatar

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

	-- Init HUD Widget
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

	-- Configs Helper System
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

	-- Built-in Settings Tab (Guaranteed to populate with all sections)
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

	-- Configs Section Elements
	local TypedConfigName = "default";
	local ConfigInputLabel = ConfigSection:AddLabel("default");

	ConfigSection:AddButton({
		Name = "Save Config",
		Callback = function()
			if TypedConfigName ~= "" then
				writefile(Window.ConfigFolder .. "/" .. TypedConfigName, ConfigEngine:GetData());
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
			end;
		end
	});

	ConfigSection:AddButton({
		Name = "Load Typed",
		Callback = function()
			local path = Window.ConfigFolder .. "/" .. TypedConfigName;
			if isfile(path) then
				ConfigEngine:LoadData(readfile(path));
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
