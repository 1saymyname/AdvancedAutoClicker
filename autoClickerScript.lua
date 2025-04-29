local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AdvancedAutoClickerGUI"
gui.ResetOnSpawn = false

-- GUI Çerçevesi
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

-- Durum Yazısı
local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 5)
statusLabel.Text = "Auto Clicker Kapalı"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.TextSize = 20

-- CPS Giriş Kutusu
local cpsBox = Instance.new("TextBox", frame)
cpsBox.Size = UDim2.new(0, 100, 0, 30)
cpsBox.Position = UDim2.new(0, 10, 0, 45)
cpsBox.PlaceholderText = "CPS gir (örn: 20)"
cpsBox.Text = ""
cpsBox.Font = Enum.Font.SourceSans
cpsBox.TextSize = 18
cpsBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
cpsBox.TextColor3 = Color3.new(1, 1, 1)

-- Tema Rengi Seçici
local colorBox = Instance.new("TextBox", frame)
colorBox.Size = UDim2.new(0, 100, 0, 30)
colorBox.Position = UDim2.new(0, 10, 0, 85)
colorBox.PlaceholderText = "Renk (örn: red)"
colorBox.Text = ""
colorBox.Font = Enum.Font.SourceSans
colorBox.TextSize = 16
colorBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
colorBox.TextColor3 = Color3.new(1, 1, 1)

-- Başlat/Durdur Butonu
local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 125)
toggleButton.Text = "Başlat"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
toggleButton.TextColor3 = Color3.new(1, 1, 1)

-- Ses Efekti
local function playBeep()
	local sound = Instance.new("Sound", player:WaitForChild("PlayerGui"))
	sound.SoundId = "rbxassetid://9118823107"
	sound.Volume = 2
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 2)
end

-- Renk Ayarlayıcı
local namedColors = {
	red = Color3.fromRGB(170, 0, 0),
	green = Color3.fromRGB(0, 170, 0),
	blue = Color3.fromRGB(0, 85, 255),
	yellow = Color3.fromRGB(255, 170, 0),
	purple = Color3.fromRGB(170, 0, 255),
	white = Color3.fromRGB(255, 255, 255),
	gray = Color3.fromRGB(80, 80, 80),
	black = Color3.fromRGB(20, 20, 20)
}

local function applyColor(colorName)
	local color = namedColors[string.lower(colorName)]
	if color then
		frame.BackgroundColor3 = color
	else
		statusLabel.Text = "❌ Renk bulunamadı"
	end
end

-- Clicker Değişkeni
local isClicking = false

-- Tıklama Döngüsü
local function startClicking(cps)
	spawn(function()
		local delay = 1 / cps
		while isClicking do
			VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
			VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
			task.wait(delay)
		end
	end)
end

-- Başlat/Durdur
toggleButton.MouseButton1Click:Connect(function()
	local cps = tonumber(cpsBox.Text)
	if not cps or cps <= 0 then
		statusLabel.Text = "❌ Geçersiz CPS!"
		return
	end

	applyColor(colorBox.Text)
	isClicking = not isClicking
	playBeep()

	if isClicking then
		statusLabel.Text = "✅ Auto Clicker Aktif (" .. cps .. " CPS)"
		toggleButton.Text = "Durdur"
		toggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
		startClicking(cps)
	else
		statusLabel.Text = "⛔ Auto Clicker Kapalı"
		toggleButton.Text = "Başlat"
		toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
	end
end)

-- Ctrl ile GUI Gizle/Göster
UserInputService.InputBegan:Connect(function(input, gp)
	if input.KeyCode == Enum.KeyCode.LeftControl then
		frame.Visible = not frame.Visible
	end
end)
