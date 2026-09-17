-- Nebula V1 | logo.lua
-- Hosted: GitHub Raw

local function typewrite(text, delay)
    for i = 1, #text do
        io.write(text:sub(i,i))
        io.flush()
        task.wait(delay or 0.03)
    end
    print()
end

local logo = {
    "",
    "  ███╗   ██╗███████╗██████╗ ██╗   ██╗██╗      █████╗ ",
    "  ████╗  ██║██╔════╝██╔══██╗██║   ██║██║     ██╔══██╗",
    "  ██╔██╗ ██║█████╗  ██████╔╝██║   ██║██║     ███████║",
    "  ██║╚██╗██║██╔══╝  ██╔══██╗██║   ██║██║     ██╔══██║",
    "  ██║ ╚████║███████╗██████╔╝╚██████╔╝███████╗██║  ██║",
    "  ╚═╝  ╚═══╝╚══════╝╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝",
    "",
    "              [ V1 ] — Premium Cali Cheat              ",
    "                  github.com/NebulaV1                  ",
    "",
}

for _, line in ipairs(logo) do
    typewrite(line, 0.01)
end

task.wait(0.5)
print("  Loading modules...")
task.wait(0.3)
print("  [✓] GUI loaded")
task.wait(0.2)
print("  [✓] Core loaded")
task.wait(0.2)
print("  [✓] Anti-detect active")
task.wait(0.3)
print("  [✓] Nebula V1 ready — enjoy\n")
