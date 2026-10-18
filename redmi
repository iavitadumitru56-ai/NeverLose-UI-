Документация UI-библиотеки Neverlose.cc для Roblox

Neverlose.cc UI Library — это интерфейсная библиотека в стиле чита Neverlose
(CS:GO / CS2), адаптированная под Roblox. Библиотека поддерживает акцентные
темы, кастомную систему блюра (Glass/DoF), 3D-рендеринг в мире, конфиг-менеджер,
водяные знаки (Watermark), систему уведомлений, логов и индикаторов.

1. Архитектура библиотеки

Структура интерфейса строится по следующей иерархии:

NeverLose (Библиотека)
└── Window (Главное окно)
    └── Tab (Вкладки слева)
        └── Section (Секции / Блоки)
            ├── Button (Кнопка)
            └── Label (Строка с элементами)
                ├── Toggle (Переключатель)
                ├── Slider (Слайдер)
                ├── Dropdown (Выпадающий список)
                ├── ColorPicker (Выбор цвета)
                ├── Keybind (Бинды)
                ├── TextInput (Поле ввода)
                └── Option (Всплывающее меню настроек)

Важно: Интерактивные элементы управления (переключатели, слайдеры, селекторы и
т.д.) привязываются к строкам (Label) с помощью цепочки вызовов или сохранения
дескриптора (handle).

2. Глобальные настройки библиотеки

Все глобальные свойства настраиваются до или после создания окна:

local NeverLose = loadstring(game:HttpGet("..."))() -- или подключение через модуль

NeverLose.AccentColor = Color3.fromRGB(78, 127, 252) -- Акцентный цвет
NeverLose.IconColor   = Color3.fromRGB(255, 255, 255) -- Цвет иконок
NeverLose.EnabledBlur = true                         -- Включение/выключение размытия фона
NeverLose.UnloadEnabled = true                       -- Разрешить выгрузку (для :Unload())

Пресеты размеров окна (NeverLose.Scales)

  - NeverLose.Scales.Small — (540, 380)
  - NeverLose.Scales.Mobile — (640, 385)
  - NeverLose.Scales.Default — (640, 480)
  - NeverLose.Scales.Large — (800, 600)

Выгрузка интерфейса

NeverLose:Unload() -- Полностью очищает GUI и отключает зарегистрированные события

3. Инициализация окна (CreateWindow)

Создает базовое окно с поиском, левым меню и панелью профиля.

local Window = NeverLose:CreateWindow({
    Name = "Neverlose",
    Content = "Counter-Strike 2",
    Logo = NeverLose.GlobalLogo, -- rbxassetid или кастомная текстура
    Size = NeverLose.Scales.Default,
    ConfigFolder = "MyScriptConfigs", -- Папка сохранения конфигов
    Enable3DRenderer = false,        -- 3D-режим на SurfaceGui
    Keybind = "Insert"               -- Клавиша открытия/скрытия меню (строка или Enum.KeyCode)
})

Параметры CreateWindow:

| Параметр           | Тип             | По умолчанию                | Описание                               |
| :----------------- | :-------------- | :-------------------------- | :------------------------------------- |
| `Name`             | `string`        | `"Neverlose"`               | Название в левой верхней части         |
| `Content`          | `string`        | `"Counter-Strike 2"`        | Подзаголовок окна                      |
| `Logo`             | `string`        | `NeverLose.GlobalLogo`      | Идентификатор ассета логотипа          |
| `Size`             | `UDim2`         | `UDim2.new(0, 640, 0, 480)` | Размер окна                            |
| `ConfigFolder`     | `string`        | `"NeverLoseConfigs"`        | Название папки в эксплойте под конфиги |
| `Enable3DRenderer` | `boolean`       | `false`                     | Рендер окна на парте перед камерой     |
| `Keybind`          | `string`/`Enum` | `"Insert"`                  | Кнопка скрытия/показа интерфейса       |

Методы окна (Window):

  - Window:ToggleInterface() — переключает видимость окна (открыть/закрыть).
  - Window:SetSize(UDim2) — плавно анимирует изменение размера окна.
  - Window:SetAccount({ Username = "...", Profile = "...", Expires = "..." }) —
    обновляет блок профиля в левом нижнем углу.
  - Window:AddTabLabel("Название") — создает некликабельный текстовый
    разделитель в списке вкладок.
  - Window:AddTab(Config) — создает новую вкладку.
  - Window:Watermark() — инициализирует систему водяного знака в правом верхнем
    углу.

4. Вкладки (AddTab)

local Tab = Window:AddTab({
    Name = "Ragebot",
    Icon = "crosshairs", -- Иконка из встроенного шрифта BuilderIcons
    Type = "Double"      -- "Double" (две колонки) или "Single" (одна колонка)
})

Параметры:

  - Name (string) — заголовок вкладки.
  - Icon (string) — название иконки (список встроенных иконок: crosshairs, gear,
    house, shield-check, eye, folder, star, bell и т.д.).
  - Type (string) — "Double" (по умолчанию: левая и правая стороны) или
    "Single".

5. Секции (AddSection)

Секции группируют элементы управления в контейнеры с рамкой.

local Section = Tab:AddSection({
    Name = "MAIN EXPLOITS",
    Position = "left" -- "left" или "right" (для Double-вкладок)
})

6. Элементы интерфейса

6.1. Кнопка (AddButton)

Создает полноразмерную интерактивную строку с иконкой.

local Button = Section:AddButton({
    Name = "Execute Script",
    Icon = "chevron-large-right",
    ToolTip = "Нажмите для запуска функции", -- Опционально
    Callback = function()
        print("Button Clicked!")
    end
})

-- Методы:
Button:SetText("New Text")
Button:SetIcon("gear")

6.2. Строка-контейнер (AddLabel)

Базовый элемент для размещения элементов справа от текста.

local LabelHandle = Section:AddLabel("Auto Fire", false)
-- Параметры: (Name: string, Warp: boolean)
-- Warp = true автоматически переносит и растягивает длинный текст.

-- Методы Label:
LabelHandle:SetText("New Label Text")
LabelHandle:SetVisible(true)
LabelHandle:ToolTip("Подробное описание данного переключателя")

К LabelHandle прикрепляются следующие элементы:

Toggle (Переключатель)

local Toggle = LabelHandle:AddToggle({
    Default = false,
    Flag = "AutoFire_Enabled", -- Ключ сохранения в конфиге
    Callback = function(value)
        print("Состояние:", value)
    end
})

-- Методы:
Toggle:SetValue(true)
local current = Toggle:GetValue()

Slider (Слайдер)

local Slider = LabelHandle:AddSlider({
    Default = 50,
    Min = 0,
    Max = 100,
    Type = "%",          -- Суффикс значения (например: "%", "ms", " studs")
    Rounding = 0,        -- Количество знаков после запятой
    Size = 125,          -- Ширина слайдера в пикселях
    Flag = "HitChance_Val",
    Callback = function(value)
        print("Слайдер:", value)
    end
})

-- Методы:
Slider:SetValue(75)
local val = Slider:GetValue()

Dropdown (Выпадающий список)

Поддерживает как одиночный, так и множественный выбор.

-- Одиночный выбор:
local Dropdown = LabelHandle:AddDropdown({
    Default = "Head",
    Values = {"Head", "Torso", "Arms", "Legs"},
    Multi = false,
    Size = 110,
    Flag = "TargetHitbox",
    Callback = function(selected)
        print("Выбрано:", selected)
    end
})

-- Множественный выбор (Multi):
local MultiDropdown = LabelHandle:AddDropdown({
    Default = { Head = true, Torso = true },
    Values = {"Head", "Torso", "Arms", "Legs"},
    Multi = true,
    Flag = "HitboxMulti",
    Callback = function(selectedTable)
        -- selectedTable вернет таблицу вида { Head = true, Arms = false, ... }
    end
})

-- Методы:
Dropdown:SetValue("Torso")
Dropdown:SetValues({"New1", "New2", "New3"})
local current = Dropdown:GetValue()

ColorPicker (Выбор цвета)

Открывает палитру выбора оттенка, насыщенности и яркости (HSV + HEX вывод).

local ColorPicker = LabelHandle:AddColorPicker({
    Default = Color3.fromRGB(78, 127, 252), -- или HEX: "#4e7ffc"
    Flag = "ESP_Color",
    Callback = function(color)
        print("Новый цвет:", color)
    end
})

-- Методы:
ColorPicker:SetValue(Color3.fromRGB(255, 0, 0))
local col = ColorPicker:GetValue()

Keybind (Выбор клавиши)

Поддерживает клавиатуру и клавиши мыши (M1B, M2B).

local Keybind = LabelHandle:AddKeybind({
    Default = Enum.KeyCode.F, -- или "F", "M2B"
    Blacklist = { Enum.KeyCode.Unknown, "W", "A", "S", "D" }, -- Запрещенные клавиши
    Flag = "AimbotKey",
    Callback = function(keyName)
        print("Бинд изменен на:", keyName)
    end
})

-- Методы:
Keybind:SetValue("V")
local currentKey = Keybind:GetValue()

TextInput (Поле текстового ввода)

local Input = LabelHandle:AddTextInput({
    Default = "Player1",
    Placeholder = "Никнейм...",
    Numeric = false, -- true оставляет только цифры и точку
    Size = 110,
    Flag = "TargetPlayerName",
    Callback = function(text)
        print("Введено:", text)
    end
})

-- Методы:
Input:SetValue("New Target")
local currentText = Input:GetValue()

Option (Всплывающее меню настроек)

Создает шестеренку или стрелку, открывающую отдельное всплывающее подменю.
Подменю поддерживает добавление внутренних элементов через те же самые AddLabel!

-- GearIcon: 1 = шестерёнка, 2 = стрелка, nil = троеточие
local SubMenu = LabelHandle:AddOption(1)

-- Добавление элементов внутрь контекстного меню:
local SubOption = SubMenu:AddLabel("Sub Option 1")
SubOption:AddToggle({
    Default = true,
    Callback = function(v) end
})

7. Флаги и сохранение конфигов

Каждый элемент с заполненным полем Flag автоматически регистрируется в таблице:

NeverLose.Flags["ВашФлаг"]:GetValue()
NeverLose.Flags["ВашФлаг"]:SetValue(val)

Система конфигов встроена в заголовок окна:

  - При первом старте генерируется конфиг Default.
  - Каждые ~5.75 секунд дефолтный конфиг автоматически обновляется.
  - Пользователь может вводить название и нажимать +, чтобы сохранять отдельные
    профили настроек, удалять их или загружать обратно через GUI.

8. Дополнительные компоненты

8.1. Водяной знак (Watermark)

Отображается в верхнем правом углу экрана. Поддерживает динамические блоки
текста.

local Watermark = Window:Watermark()
Watermark:SetRender(true)

local FpsBlock = Watermark:AddBlock("chart-line", "FPS: 60")
local PingBlock = Watermark:AddBlock("globe-detailed", "Ping: 25ms")
local UserBlock = Watermark:AddBlock("circle-person", "User: Alpaca")

-- Динамическое обновление значений:
task.spawn(function()
    while true do
        task.wait(1)
        FpsBlock:SetText("FPS: " .. math.floor(workspace:GetRealPhysicsFPS()))
    end
end)

-- Реакция на клик по блоку:
FpsBlock:Input(function()
    print("Клик по FPS блоку")
end)

8.2. Всплывающие уведомления (Notifications)

local Notifier = NeverLose:CreateNotification()

Notifier.new({
    Title = "Aimbot",
    Content = "Target locked on head!",
    Logo = NeverLose.GlobalLogo,
    Duration = 4
})

8.3. Логгер (Screen Logger)

Компактные строки сообщений, всплывающие в верхнем левом углу.

local Logger = NeverLose:CreateLogger()

-- Logger.new(IconName, MessageText, DurationInSeconds)
Logger.new("check", "Скрипт успешно активирован", 3)
Logger.new("trash-can", "Конфиг удален", 3.5)

8.4. Индикаторы состояния (Indicators)

Индикаторы статуса (Crosshair / Anti-Aim / Ragebot) в левой центральной части
экрана.

local IndicatorHandler = NeverLose:CreateIndicator()

local DtIndicator = IndicatorHandler.new({
    Name = "DOUBLETAP",
    Icon = "lightning-bolt",
    Color = "Green" -- "Red" | "Green" | "White"
})

DtIndicator:SetRender(true) -- Показать индикатор
DtIndicator:SetColor("Red")  -- Изменить цвет
DtIndicator:SetText("DOUBLETAP [CHARGING]")

9. Полный рабочий пример

-- Загрузка библиотеки
local NeverLose = loadstring(readfile("Neverlose.lua"))()

NeverLose.AccentColor = Color3.fromRGB(0, 150, 255)
NeverLose.EnabledBlur = true

-- Создание окна
local Window = NeverLose:CreateWindow({
    Name = "Neverlose",
    Content = "Universal Edition",
    Size = NeverLose.Scales.Default,
    ConfigFolder = "UniversalNL",
    Keybind = Enum.KeyCode.RightShift
})

-- Информация об аккаунте
Window:SetAccount({
    Username = game.Players.LocalPlayer.DisplayName,
    Expires = "Lifetime"
})

-- Создание вкладки
local CombatTab = Window:AddTab({
    Name = "Combat",
    Icon = "crosshairs",
    Type = "Double"
})

-- Левая секция
local AimbotSection = CombatTab:AddSection({
    Name = "AIMBOT SETTINGS",
    Position = "left"
})

-- Переключатель Aimbot
local AimLabel = AimbotSection:AddLabel("Enable Aimbot"):ToolTip("Включает автоматическое наведение на цель")
AimLabel:AddToggle({
    Default = true,
    Flag = "Aim_Enabled",
    Callback = function(state)
        print("Aimbot state:", state)
    end
})

-- Бинд для Aimbot
local KeyLabel = AimbotSection:AddLabel("Aimbot Key")
KeyLabel:AddKeybind({
    Default = "M2B",
    Flag = "Aim_Key",
    Callback = function(key)
        print("Bind set to:", key)
    end
})

-- Слайдер плавности наводки
local SmoothLabel = AimbotSection:AddLabel("Smoothness")
SmoothLabel:AddSlider({
    Default = 15,
    Min = 1,
    Max = 100,
    Type = "%",
    Rounding = 0,
    Flag = "Aim_Smooth",
    Callback = function(val)
        print("Smooth:", val)
    end
})

-- Выпадающий список хитбоксов
local HitboxLabel = AimbotSection:AddLabel("Target Hitbox")
HitboxLabel:AddDropdown({
    Default = "Head",
    Values = {"Head", "Chest", "Pelvis"},
    Flag = "Aim_Hitbox",
    Callback = function(val)
        print("Hitbox:", val)
    end
})

-- Цвет фокуса
local ColorLabel = AimbotSection:AddLabel("FOV Color")
ColorLabel:AddColorPicker({
    Default = Color3.fromRGB(255, 50, 50),
    Flag = "FOV_Color",
    Callback = function(c)
        print("Color updated:", c)
    end
})

-- Правая секция
local MiscSection = CombatTab:AddSection({
    Name = "MISCELLANEOUS",
    Position = "right"
})

MiscSection:AddButton({
    Name = "Reset Everything",
    Icon = "trash-can",
    Callback = function()
        NeverLose:CreateNotification().new({
            Title = "Config",
            Content = "Настройки сброшены!",
            Duration = 3
        })
    end
})

-- Настройка Watermark
local Watermark = Window:Watermark()
local PingBlock = Watermark:AddBlock("globe-detailed", "60 ms")
