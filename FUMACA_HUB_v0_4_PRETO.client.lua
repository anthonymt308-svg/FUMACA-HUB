-- FUMAÇA HUB v0.4 personalizável | LocalScript em StarterPlayerScripts
-- Interface demonstrativa; não automatiza jogos de terceiros.
local P=game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')
local UIS=game:GetService('UserInputService')
local old=P:FindFirstChild('FumacaHub'); if old then old:Destroy() end
local rgb=Color3.fromRGB
local function ui(class,parent,props,radius)
 local x=Instance.new(class)
 for k,v in pairs(props or {}) do x[k]=v end
 x.Parent=parent
 if radius then local c=Instance.new('UICorner'); c.CornerRadius=UDim.new(0,radius); c.Parent=x end
 return x
end
local function label(parent,text,size,bold,props)
 local p={BackgroundTransparency=1,Text=text,TextSize=size,Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,TextColor3=rgb(238,240,244),TextXAlignment=Enum.TextXAlignment.Left}
 for k,v in pairs(props or {}) do p[k]=v end
 return ui('TextLabel',parent,p)
end
local gui=ui('ScreenGui',P,{Name='FumacaHub',ResetOnSpawn=false,IgnoreGuiInset=true})
local win=ui('Frame',gui,{Name='Janela',AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(760,490),BackgroundColor3=rgb(0,0,0)},14)
local head=ui('Frame',win,{Size=UDim2.new(1,0,0,58),BackgroundColor3=rgb(9,9,9)},14)
label(head,'FUMAÇA HUB',20,true,{Position=UDim2.fromOffset(20,9),Size=UDim2.fromOffset(330,25)})
label(head,'Versão 0.4 • Configurações avançadas',11,false,{Position=UDim2.fromOffset(20,34),Size=UDim2.fromOffset(360,18),TextColor3=rgb(166,175,190)})
local function topButton(txt,x)
 return ui('TextButton',head,{Size=UDim2.fromOffset(35,32),Position=UDim2.new(1,x,0,13),Text=txt,TextSize=24,Font=Enum.Font.GothamBold,TextColor3=Color3.new(1,1,1),BackgroundColor3=rgb(64,70,87)},8)
end
local minimize,close=topButton('−',-82),topButton('×',-42)
local function panel(name,pos,size,scroll)
 local f=ui('ScrollingFrame',win,{Name=name,Position=pos,Size=size,BackgroundColor3=rgb(12,12,12),BorderSizePixel=0,ScrollBarThickness=scroll,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new()},10)
 ui('UIListLayout',f,{Padding=UDim.new(0,name=='Categorias' and 5 or 9)})
 local side=name=='Categorias'
 ui('UIPadding',f,{PaddingTop=UDim.new(0,side and 9 or 14),PaddingBottom=UDim.new(0,side and 9 or 14),PaddingLeft=UDim.new(0,side and 8 or 15),PaddingRight=UDim.new(0,side and 8 or 15)})
 return f
end
local sidebar=panel('Categorias',UDim2.fromOffset(12,70),UDim2.new(0,170,1,-82),3)
local content=panel('Conteudo',UDim2.fromOffset(195,70),UDim2.new(1,-207,1,-82),4)
local categories={
 {'Início','Visão geral','Novidades','Estado dos módulos'},
 {'Farm','Farm de nível','Missões','NPCs','Bosses','Materiais','Maestria','Seleção de ilha','Progresso de missão','Prioridade de alvo','Tipo de arma para farm','Uso de habilidades da fruta'},
 {'Frutas','Localizar frutas','Frutas no chão','Inventário de frutas','Frutas armazenadas','Frutas duplicadas','Histórico de coleta','Desejadas','Raridades','Roleta de frutas'},
 {'Combate','Arma equipada','Seleção de alvo','Distância de combate','Habilidades','Estilo de luta','Preferências de combate','Estado do personagem'},
 {'Estilos','Dark Step','Electric','Water Kung Fu','Dragon Breath','Superhuman','Death Step','Sharkman Karate','Electric Claw','Dragon Talon','Godhuman','Maestria por estilo','Materiais necessários'},
 {'Raças','Raça atual','Evolução V2','Evolução V3','Evolução V4','Requisitos','Progresso de evolução','Materiais e tarefas'},
 {'Raids','Selecionar raid','Estado da raid','Inventário de chips','Verificações de segurança','Posição do personagem','Vida do personagem','Registro de falhas','Interrupção segura'},
 {'Mar','Sea Events','Barcos','Pesca','Leviathan','Terror Shark','Sea Beast','Materiais marítimos','Localização no mar'},
 {'Itens','Espadas','Acessórios','Inventário','Materiais','Itens pendentes','Coleção','Requisitos de obtenção'},
 {'Eventos','Eventos sazonais','Recompensas','Progresso','Missões de evento','Itens limitados'},
 {'Configurações','Notificações','Preferências visuais','Exibir dicas','Modo compacto','Avisos de segurança','Diagnóstico visual','Desabilitar PvP (preferência)','Velocidade de caminhada','Tipo de arma para farm','Usar skills da fruta'}
}
local states,buttons={},{}
local farmWeapon='Melee'
local fruitSkills=false
local speed=16
local pvpPreference=false
local function humanoid()
 local character=game:GetService('Players').LocalPlayer.Character
 return character and character:FindFirstChildOfClass('Humanoid')
end
local function applySpeed()
 local h=humanoid()
 if h then h.WalkSpeed=speed end
end
game:GetService('Players').LocalPlayer.CharacterAdded:Connect(function(character)
 local h=character:WaitForChild('Humanoid',10)
 if h then h.WalkSpeed=speed end
end)
local current=categories[1]
local function notify(message)
 local n=ui('TextLabel',gui,{AnchorPoint=Vector2.new(.5,1),Position=UDim2.fromScale(.5,.96),Size=UDim2.fromOffset(450,36),BackgroundColor3=rgb(45,52,67),TextColor3=rgb(240,243,248),Font=Enum.Font.Gotham,TextSize=13,Text=message},8)
 task.delay(2.5,function() if n.Parent then n:Destroy() end end)
end
local function addText(t,size,color,height)
 label(content,t,size,size>=18,{Size=UDim2.new(1,-8,0,height),TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top,TextColor3=color or rgb(238,240,244)})
end
local function toggle(category,name)
 local key=category..'/'..name
 local row=ui('Frame',content,{Size=UDim2.new(1,-8,0,61),BackgroundColor3=rgb(22,22,22)},8)
 label(row,name,14,true,{Position=UDim2.fromOffset(12,7),Size=UDim2.new(1,-125,0,23)})
 label(row,category=='Configurações' and 'Preferência local • sessão atual' or 'Planejado • integração não implementada',10,false,{Position=UDim2.fromOffset(12,31),Size=UDim2.new(1,-120,0,20),TextColor3=rgb(170,179,192)})
 if category~='Configurações' then return end
 local b=ui('TextButton',row,{Size=UDim2.fromOffset(91,31),Position=UDim2.new(1,-103,0,15),Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.new(1,1,1)},7)
 local function refresh() local on=states[key]==true; b.Text=on and 'LIGADO' or 'DESLIGADO'; b.BackgroundColor3=on and rgb(47,132,106) or rgb(85,91,108) end
 b.MouseButton1Click:Connect(function() states[key]=not states[key]; refresh(); notify(name..': preferência '..(states[key] and 'ligada' or 'desligada')) end)
 refresh()
end
local function show(category)
 current=category
 for _,child in ipairs(content:GetChildren()) do if child:IsA('GuiObject') then child:Destroy() end end
 for name,b in pairs(buttons) do b.BackgroundColor3=rgb(name==category[1] and 65 or 38,name==category[1] and 102 or 43,name==category[1] and 141 or 57) end
 addText(category[1],22,nil,33)
 if category[1]=='Início' then
  addText('Bem-vindo ao FUMAÇA HUB v0.4. As categorias agora mostram um catálogo expandido de recursos planejados. Nenhum módulo controla o personagem ou executa ações no jogo.',13,rgb(197,207,220),83)
  addText('Status: interface pronta • integrações ainda não implementadas.',13,rgb(242,194,112),52)
 else
  addText(category[1]=='Configurações' and 'As preferências abaixo são locais e demonstrativas.' or 'Recursos planejados: os itens abaixo são informativos e ainda não executam ações.',12,rgb(174,184,198),48)
  if category[1]=='Farm' or category[1]=='Configurações' then
   addText('Preferências de combate (não iniciam farm automaticamente)',15,nil,27)
   for _,weapon in ipairs({'Melee','Sword','Gun','Blox Fruit'}) do
    local b=ui('TextButton',content,{Size=UDim2.new(1,-8,0,32),BackgroundColor3=rgb(29,29,29),TextColor3=rgb(245,245,245),Font=Enum.Font.Gotham,TextSize=13,Text='Arma: '..weapon..(farmWeapon==weapon and '  ✓' or '')},7)
    b.MouseButton1Click:Connect(function() farmWeapon=weapon; show(current); notify('Arma preferida: '..weapon) end)
   end
   local skill=ui('TextButton',content,{Size=UDim2.new(1,-8,0,38),BackgroundColor3=rgb(30,30,30),TextColor3=rgb(255,255,255),Font=Enum.Font.GothamBold,TextSize=13,Text='Usar skills da fruta: '..(fruitSkills and 'SIM' or 'NÃO')},7)
   skill.MouseButton1Click:Connect(function() fruitSkills=not fruitSkills; show(current); notify('Skills: preferência atualizada') end)
  end
  if category[1]=='Configurações' then
   addText('Velocidade local do personagem (em experiência própria)',15,nil,30)
   local slow=ui('TextButton',content,{Size=UDim2.new(1,-8,0,35),BackgroundColor3=rgb(30,30,30),TextColor3=rgb(255,255,255),TextSize=14,Text='−  Diminuir velocidade'},7)
   slow.MouseButton1Click:Connect(function() speed=math.max(8,speed-4); applySpeed(); show(current); notify('Velocidade: '..speed) end)
   addText('Velocidade configurada: '..speed,13,nil,23)
   local fast=ui('TextButton',content,{Size=UDim2.new(1,-8,0,35),BackgroundColor3=rgb(30,30,30),TextColor3=rgb(255,255,255),TextSize=14,Text='+  Aumentar velocidade'},7)
   fast.MouseButton1Click:Connect(function() speed=math.min(32,speed+4); applySpeed(); show(current); notify('Velocidade: '..speed) end)
   local pvp=ui('TextButton',content,{Size=UDim2.new(1,-8,0,38),BackgroundColor3=rgb(30,30,30),TextColor3=rgb(255,255,255),TextSize=13,Text='Preferir PvP desligado: '..(pvpPreference and 'SIM' or 'NÃO')},7)
   pvp.MouseButton1Click:Connect(function() pvpPreference=not pvpPreference; show(current); notify('Preferência PvP alterada; depende do servidor') end)
   addText('A opção PvP apenas registra sua preferência. Desativar dano PvP exige lógica autorizada no servidor.',11,rgb(210,174,125),57)
  end
  for i=2,#category do
   local name=category[i]
   if name~='Tipo de arma para farm' and name~='Uso de habilidades da fruta' and name~='Usar skills da fruta' and name~='Velocidade de caminhada' and name~='Desabilitar PvP (preferência)' then toggle(category[1],name) end
  end
  if category[1]=='Configurações' then
   local reset=ui('TextButton',content,{Size=UDim2.new(1,-8,0,38),Text='Restaurar preferências da sessão',Font=Enum.Font.GothamBold,TextSize=13,TextColor3=rgb(255,255,255),BackgroundColor3=rgb(104,67,70)},8)
   reset.MouseButton1Click:Connect(function()
    table.clear(states); farmWeapon='Melee'; fruitSkills=false; speed=16; pvpPreference=false; applySpeed(); show(current); notify('Preferências restauradas')
   end)
  end
 end
end
for _,category in ipairs(categories) do
 local b=ui('TextButton',sidebar,{Name=category[1],Size=UDim2.new(1,0,0,35),BackgroundColor3=rgb(26,26,26),TextColor3=rgb(232,237,243),Font=Enum.Font.GothamMedium,TextSize=13,Text=category[1]},7)
 buttons[category[1]]=b
 b.MouseButton1Click:Connect(function() show(category) end)
end
local collapsed=false
minimize.MouseButton1Click:Connect(function()
 collapsed=not collapsed; sidebar.Visible=not collapsed; content.Visible=not collapsed
 win.Size=UDim2.fromOffset(760,collapsed and 58 or 490); minimize.Text=collapsed and '+' or '−'
end)
close.MouseButton1Click:Connect(function() gui:Destroy() end)
local dragging,startPos,winPos=false,nil,nil
head.InputBegan:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
  dragging=true; startPos=input.Position; winPos=win.Position
  input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end)
 end
end)
UIS.InputChanged:Connect(function(input)
 if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
  local d=input.Position-startPos
  win.Position=UDim2.new(winPos.X.Scale,winPos.X.Offset+d.X,winPos.Y.Scale,winPos.Y.Offset+d.Y)
 end
end)
UIS.InputBegan:Connect(function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.RightShift then
  gui.Enabled=not gui.Enabled
 end
end)
show(categories[1])
