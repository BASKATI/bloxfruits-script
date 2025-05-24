local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({Name = "Blox Fruits GUI by BASKATI", HidePremium = false, IntroEnabled = false})

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddButton({
    Name = "แสดงแจ้งเตือน Hello!",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "แจ้งเตือน",
            Content = "Hello World!",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
})

Tab:AddToggle({
    Name = "ทดสอบเปิด/ปิดฟีเจอร์",
    Default = false,
    Callback = function(Value)
        print("Toggle is: "..tostring(Value))
    end
})

Tab:AddTextbox({
    Name = "พิมพ์ข้อความ",
    Default = "",
    TextDisappear = false,
    Callback = function(Value)
        print("TextBox Value:", Value)
    end
})

Tab:AddSlider({
    Name = "ตัวอย่าง Slider",
    Min = 1,
    Max = 100,
    Default = 25,
    Increment = 1,
    Callback = function(Value)
        print("Slider Value:", Value)
    end
})

Tab:AddDropdown({
    Name = "เลือกบางอย่าง",
    Default = "A",
    Options = {"A", "B", "C"},
    Callback = function(Value)
        print("Dropdown Value:", Value)
    end
})

Tab:AddLabel("นี่คือตัวอย่าง OrionLib GUI")
