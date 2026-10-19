-- FUMAÇA HUB v0.1 compacto | LocalScript em StarterPlayerScripts
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
local win=ui('Frame',gui,{Name='Janela',AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(760,490),BackgroundColor3=rgb(22,25,33)},14)
local head=ui('Frame',win,{Size=UDim2.new(1,0,0,58),BackgroundColor3=rgb(32,36,47)},14)
label(head,'FUMAÇA HUB',20,true,{Position=UDim2.fromOffset(20,9),Size=UDim2.fromOffset(330,25)})
label(head,'Versão 0.1 • Interface demonstrativa',11,false,{Position=UDim2.fromOffset(20,34),Size=UDim2.fromOffset(360,18),TextColor3=rgb(166,175,190)})
local function topButton(txt,x)
 return ui('TextButton',head,{Size=UDim2.fromOffset(35,32),Position=UDim2.new(1,x,0,13),Text=txt,TextSize=24,Font=Enum.Font.GothamBold,TextColor3=Color3.new(1,1,1),BackgroundColor3=rgb(64,70,87)},8)
end
local minimize,close=topButton('−',-82),topButton('×',-42)
local function panel(name,pos,size,scroll)
 local f=ui('ScrollingFrame',win,{Name=name,Position=pos,Size=size,BackgroundColor3=rgb(28,32,42),BorderSizePixel=0,ScrollBarThickness=scroll,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new()},10)
 ui('UIListLayout',f,{Padding=UDim.new(0,name=='Categorias' and 5 or 9)})
 local side=name=='Categorias'
 ui('UIPadding',f,{PaddingTop=UDim.new(0,side and 9 or 14),PaddingBottom=UDim.new(0,side and 9 or 14),PaddingLeft=UDim.new(0,side and 8 or 15),PaddingRight=UDim.new(0,side and 8 or 15)})
 return f
end
local sidebar=panel('Categorias',UDim2.fromOffset(12,70),UDim2.new(0,170,1,-82),3)
local content=panel('Conteudo',UDim2.fromOffset(195,70),UDim2.new(1,-207,1,-82),4)
local categories={
 {'Início','Sobre o projeto','Estado dos módulos'},
 {'Farm','Nível','Missões','NPCs','Materiais'},
 {'Frutas','Localização','Coleta','Armazenamento','Duplicadas'},
 {'Combate','Seleção de alvo','Preferências de combate'},
 {'Estilos','Maestria','Progresso Godhuman'},
 {'Raças','Requisitos','Progresso de evolução'},
 {'Raids','Painel de raid','Verificações de segurança'},
 {'Mar','Eventos marítimos','Barcos','Pesca'},
 {'Itens','Espadas','Acessórios','Inventário'},
 {'Eventos','Eventos sazonais','Recompensas'},
 {'Configurações','Notificações','Preferências visuais'}
}
local states,buttons={},{}
local function addText(t,size,color,height)
 label(content,t,size,size>=18,{Size=UDim2.new(1,-8,0,height),TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top,TextColor3=color or rgb(238,240,244)})
end
local function toggle(category,name)
 local key=category..'/'..name
 local row=ui('Frame',content,{Size=UDim2.new(1,-8,0,61),BackgroundColor3=rgb(37,42,55)},8)
 label(row,name,14,true,{Position=UDim2.fromOffset(12,7),Size=UDim2.new(1,-125,0,23)})
 label(row,'Demonstração • sem integração com o jogo',10,false,{Position=UDim2.fromOffset(12,31),Size=UDim2.new(1,-120,0,20),TextColor3=rgb(170,179,192)})
 local b=ui('TextButton',row,{Size=UDim2.fromOffset(91,31),Position=UDim2.new(1,-103,0,15),Font=Enum.Font.GothamBold,TextSize=12,TextColor3=Color3.new(1,1,1)},7)
 local function refresh() local on=states[key]==true; b.Text=on and 'LIGADO' or 'DESLIGADO'; b.BackgroundColor3=on and rgb(47,132,106) or rgb(85,91,108) end
 b.MouseButton1Click:Connect(function() states[key]=not states[key]; refresh() end)
 refresh()
end
local function show(category)
 for _,child in ipairs(content:GetChildren()) do if child:IsA('GuiObject') then child:Destroy() end end
 for name,b in pairs(buttons) do b.BackgroundColor3=rgb(name==category[1] and 65 or 38,name==category[1] and 102 or 43,name==category[1] and 141 or 57) end
 addText(category[1],22,nil,33)
 if category[1]=='Início' then
  addText('Bem-vindo ao FUMAÇA HUB. Esta versão demonstra a interface e a navegação. Nenhum módulo controla o personagem ou executa ações no jogo.',13,rgb(197,207,220),83)
  addText('Status: interface pronta • integrações ainda não implementadas.',13,rgb(242,194,112),52)
 else
  addText('Os controles abaixo guardam apenas o estado nesta sessão. Eles não ativam automações.',12,rgb(174,184,198),48)
  for i=2,#category do toggle(category[1],category[i]) end
 end
end
for _,category in ipairs(categories) do
 local b=ui('TextButton',sidebar,{Name=category[1],Size=UDim2.new(1,0,0,35),BackgroundColor3=rgb(38,43,57),TextColor3=rgb(232,237,243),Font=Enum.Font.GothamMedium,TextSize=13,Text=category[1]},7)
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
show(categories[1])
