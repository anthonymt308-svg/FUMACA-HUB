-- FUMAÇA HUB v1.2 gerenciador de frutas | LocalScript em StarterPlayerScripts
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
label(head,'Versão 0.7 • Proteção de frutas',11,false,{Position=UDim2.fromOffset(20,34),Size=UDim2.fromOffset(360,18),TextColor3=rgb(166,175,190)})
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
 {'Farm','Farm de nível','Missões','NPCs','Bosses','Maestria','Seleção de ilha','Progresso de missão','Prioridade de alvo','Tipo de arma para farm','Uso de habilidades da fruta','Velocidade de caminhada','Preferência de PvP'},
 {'Materiais','Selecionar material','Buscar material','Filtrar por Sea'},
 {'Frutas','Localizar frutas','Frutas no chão','Inventário de frutas','Frutas armazenadas','Frutas duplicadas','Histórico de coleta','Desejadas','Raridades','Roleta de frutas'},
 {'Combate','Arma equipada','Seleção de alvo','Distância de combate','Habilidades','Estilo de luta','Preferências de combate','Estado do personagem'},
 {'Estilos','Dark Step','Electric','Water Kung Fu','Dragon Breath','Superhuman','Death Step','Sharkman Karate','Electric Claw','Dragon Talon','Godhuman','Maestria por estilo','Materiais necessários'},
 {'Raças','Raça atual','Evolução V2','Evolução V3','Evolução V4','Requisitos','Progresso de evolução','Materiais e tarefas'},
 {'Raids','Selecionar raid','Estado da raid','Inventário de chips','Verificações de segurança','Posição do personagem','Vida do personagem','Registro de falhas','Interrupção segura'},
 {'Mar','Sea Events','Barcos','Pesca','Leviathan','Terror Shark','Sea Beast','Materiais marítimos','Localização no mar'},
 {'Itens','Espadas','Acessórios','Inventário','Materiais','Itens pendentes','Coleção','Requisitos de obtenção'},
 {'Eventos','Eventos sazonais','Recompensas','Progresso','Missões de evento','Itens limitados'},
 {'Configurações','Notificações','Preferências visuais','Exibir dicas','Modo compacto','Avisos de segurança','Diagnóstico visual'}
}
local states,buttons={},{}
local skillsByWeapon={Melee={Z=true,X=true},Sword={Z=true,X=true},Gun={Z=true,X=true},['Blox Fruit']={Z=true,X=true,C=true}}
local seaFilter='Todos'
local materialSearch=''
local materialSelected='Ectoplasm'
local materialCatalog={
 {'Angel Wings',1},{'Leather',0},{'Scrap Metal',0},{'Fish Tail',1},{'Magma Ore',1},{'Yeti Fur',1},
 {'Ectoplasm',2},{'Mystic Droplet',2},{'Vampire Fang',2},{'Radioactive Material',2},{'Meteorite',2},{'Dark Fragment',2},
 {'Bones',3},{'Dragon Scale',3},{'Conjured Cocoa',3},{'Demonic Wisp',3},{'Mini Tusk',3},{'Gunpowder',3},
 {'Shark Tooth',3},{'Mutant Tooth',3},{'Terror Eyes',3},{'Leviathan Scale',3},{'Leviathan Heart',3},
 {'Mirror Fractal',3},{'Dinosaur Bones',3},{'Dragon Egg',3},{'Fire Flower',3},{'Blaze Ember',3},
 {'Azure Ember',3},{'Volcanic Magnet',3},{'Monster Magnet',3},{'Electric Wing',3},{'Fool\'s Gold',3},
 {'Fire Feather',3},{'Moonstone',3},{'Wooden Plank',0}
}
-- Gerenciador local de decisões: não acessa inventário nem coleta frutas do Blox Fruits.
-- A identidade deve ser única para cada objeto físico, nunca apenas o nome da fruta.
local fruitState={items={},history={},maxAttempts=3,cooldown=60,stats={stored=0,duplicates=0,ignored=0,failed=0}}
local function fruitLog(name,result)
 table.insert(fruitState.history,1,os.date('%H:%M:%S')..' | '..name..' → '..result)
 if #fruitState.history>15 then table.remove(fruitState.history) end
 return result
end
local function fruitDecision(id,name,owned,storageAllowed)
 if type(id)~='string' or id=='' then return fruitLog(name,'ERRO: identidade ausente') end
 local now=os.clock()
 local item=fruitState.items[id]
 if item then
  if item.status=='DESCARTADA' or item.status=='ARMAZENADA' then
   fruitState.stats.ignored+=1
   return fruitLog(name,'IGNORAR: objeto já processado ('..item.status..')')
  end
  if item.nextTry and now<item.nextTry then
   fruitState.stats.ignored+=1
   return fruitLog(name,'AGUARDAR: intervalo entre tentativas')
  end
 else
  item={attempts=0,status='NOVA'}
  fruitState.items[id]=item
 end
 if item.attempts>=fruitState.maxAttempts then
  item.status='FALHOU'; fruitState.stats.failed+=1
  return fruitLog(name,'PARAR: máximo de tentativas')
 end
 item.attempts+=1
 if owned then
  item.status='DESCARTADA'; fruitState.stats.duplicates+=1
  return fruitLog(name,'DUPLICADA: objeto bloqueado permanentemente')
 end
 if storageAllowed then
  -- Simula confirmação de armazenamento. Em integração real, só marcar após resposta do servidor.
  item.status='ARMAZENADA'; fruitState.stats.stored+=1
  return fruitLog(name,'ARMAZENADA: confirmação simulada')
 end
 item.nextTry=now+fruitState.cooldown
 return fruitLog(name,'PENDENTE: armazenamento indisponível')
end
local fruitAuto={enabled=false,collect=true,store=true,drop=true,generation=0,index=1}
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
-- Motor genérico para experiências que usam NPCs e Tools Roblox.
-- Não depende de remotes privados, teleporte ou manipulação de regras do servidor.
local farm={
 enabled=true,generation=0,status='Inicializando',kills=0,target='Nenhum',
 range=9,maxDistance=250,attackInterval=.65,lastAttack=0,
 healthMinimum=.25,retreat=false,pausedForHealth=false,
 targetFilter='',diagnostics={},stuckCount=0,lastPosition=nil,
 trackedHumanoid=nil,deathConnection=nil
}
local function farmLog(message)
 table.insert(farm.diagnostics,1,os.date('%H:%M:%S')..' '..message)
 if #farm.diagnostics>16 then table.remove(farm.diagnostics) end
end
local function getNpcFolder()
 return workspace:FindFirstChild('Enemies') or workspace:FindFirstChild('NPCs')
end
local function nearestNpc(root)
 local folder=getNpcFolder()
 if not folder then return nil,nil end
 local best,bestDistance=nil,math.huge
 for _,model in ipairs(folder:GetChildren()) do
  if model:IsA('Model') and model~=root.Parent then
   local h=model:FindFirstChildOfClass('Humanoid')
   local part=model:FindFirstChild('HumanoidRootPart') or model.PrimaryPart
   local match=farm.targetFilter=='' or string.find(string.lower(model.Name),string.lower(farm.targetFilter),1,true)
   if match and h and h.Health>0 and part then
    local distance=(root.Position-part.Position).Magnitude
    if distance<bestDistance and distance<=farm.maxDistance then best,bestDistance=model,distance end
   end
  end
 end
 return best,bestDistance
end
local function equipTool(character)
 local player=game:GetService('Players').LocalPlayer
 local bag=player:FindFirstChildOfClass('Backpack')
 local function matches(tool)
  if not tool:IsA('Tool') then return false end
  local category=tool:GetAttribute('WeaponType')
  if category then return category==farmWeapon end
  return farmWeapon=='Melee'
 end
 for _,tool in ipairs(character:GetChildren()) do if matches(tool) then return tool end end
 if bag then
  for _,tool in ipairs(bag:GetChildren()) do
   if matches(tool) then
    local h=character:FindFirstChildOfClass('Humanoid')
    if h then h:EquipTool(tool) end
    return tool
   end
  end
 end
 return nil
end
local function trackDeath(target)
 local h=target and target:FindFirstChildOfClass('Humanoid')
 if farm.trackedHumanoid==h then return end
 if farm.deathConnection then farm.deathConnection:Disconnect(); farm.deathConnection=nil end
 farm.trackedHumanoid=h
 if h then
  farm.deathConnection=h.Died:Connect(function()
   farm.kills+=1
   farmLog('NPC morreu: '..target.Name)
   farm.trackedHumanoid=nil
   if farm.deathConnection then farm.deathConnection:Disconnect(); farm.deathConnection=nil end
  end)
 end
end
local function runFarm()
 farm.generation+=1
 local token=farm.generation
 farmLog('Motor iniciado')
 task.spawn(function()
  local lastCheck=0
  while farm.enabled and farm.generation==token and gui.Parent do
   local character=game:GetService('Players').LocalPlayer.Character
   local h=character and character:FindFirstChildOfClass('Humanoid')
   local root=character and character:FindFirstChild('HumanoidRootPart')
   if not h or h.Health<=0 or not root then
    farm.status='Aguardando personagem'; farm.target='Nenhum'
    farm.lastPosition=nil
   elseif h.MaxHealth>0 and h.Health/h.MaxHealth<farm.healthMinimum then
    farm.status='Pausado: vida baixa'; farm.pausedForHealth=true
    h:MoveTo(root.Position)
   elseif farm.pausedForHealth and h.MaxHealth>0 and h.Health/h.MaxHealth<math.min(1,farm.healthMinimum+.2) then
    farm.status='Recuperando vida'
   else
    farm.pausedForHealth=false
    local target,distance=nearestNpc(root)
    if not target then
     farm.target='Nenhum'
     farm.status=getNpcFolder() and 'Nenhum NPC compatível próximo' or 'Pasta Enemies/NPCs não encontrada'
     farm.lastPosition=nil
     trackDeath(nil)
    else
     farm.target=target.Name
     local enemyRoot=target:FindFirstChild('HumanoidRootPart') or target.PrimaryPart
     if enemyRoot then
      trackDeath(target)
      if distance>farm.range then
       farm.status='Aproximando de '..target.Name
       h:MoveTo(enemyRoot.Position)
       if os.clock()-lastCheck>=3 then
        if farm.lastPosition and (root.Position-farm.lastPosition).Magnitude<2 then
         farm.stuckCount+=1
         farmLog('Movimento bloqueado ('..farm.stuckCount..')')
        end
        farm.lastPosition=root.Position
        lastCheck=os.clock()
       end
      else
       farm.lastPosition=nil
       h:MoveTo(root.Position)
       local tool=equipTool(character)
       if tool then
        farm.status='Atacando '..target.Name
        if os.clock()-farm.lastAttack>=farm.attackInterval then
         farm.lastAttack=os.clock()
         local ok,err=pcall(function() tool:Activate() end)
         if not ok then farm.status='Erro na Tool'; farmLog(tostring(err)) end
        end
       else
        farm.status='Sem Tool compatível com '..farmWeapon
       end
      end
     end
    end
   end
   task.wait(.35)
  end
  if farm.generation==token then farm.status='Pausado' end
 end)
end
local function setFarmEnabled(enabled)
 if farm.enabled==enabled then return end
 farm.enabled=enabled
 if enabled then runFarm() else
  farm.generation+=1; farm.status='Pausado'; farm.target='Nenhum'
  if farm.deathConnection then farm.deathConnection:Disconnect(); farm.deathConnection=nil end
  farm.trackedHumanoid=nil
  farmLog('Motor pausado')
 end
end
-- Coordenador central: controla prioridades sem inventar APIs de missões.
local coordinator={
 enabled=true,mode='Nível',priority='Farm',state='Aguardando',
 started=os.clock(),lastLevel=nil,levelsGained=0,
 idleSeconds=0,lastProgress=os.clock(),autoPauseAfter=90,
 pauseReason=nil
}
local function readLevel()
 local player=game:GetService('Players').LocalPlayer
 local stats=player:FindFirstChild('leaderstats')
 local value=stats and (stats:FindFirstChild('Level') or stats:FindFirstChild('Lvl') or stats:FindFirstChild('Nível'))
 if value and (value:IsA('IntValue') or value:IsA('NumberValue')) then return value.Value end
 return nil
end
local function getToolSummary()
 local player=game:GetService('Players').LocalPlayer
 local bag=player:FindFirstChildOfClass('Backpack')
 local names={}
 local function scan(parent)
  if not parent then return end
  for _,child in ipairs(parent:GetChildren()) do
   if child:IsA('Tool') then table.insert(names,child.Name) end
  end
 end
 scan(bag); scan(player.Character)
 table.sort(names)
 return #names,table.concat(names,', ')
end
local function coordinatorTick()
 local level=readLevel()
 if level then
  if coordinator.lastLevel and level>coordinator.lastLevel then
   coordinator.levelsGained+=level-coordinator.lastLevel
   coordinator.lastProgress=os.clock()
   farmLog('Nível atualizado: '..level)
  end
  coordinator.lastLevel=level
 end
 if not coordinator.enabled then
  coordinator.state='Desligado'
  return
 end
 local h=humanoid()
 if not h or h.Health<=0 then
  coordinator.priority='Recuperação'
  coordinator.state='Aguardando reaparecimento'
 elseif farm.pausedForHealth then
  coordinator.priority='Recuperação'
  coordinator.state='Aguardando vida suficiente'
 elseif coordinator.mode=='Monitoramento' then
  coordinator.priority='Monitoramento'
  coordinator.state='Somente leitura'
 else
  coordinator.priority='Farm'
  coordinator.state=farm.status
 end
 coordinator.idleSeconds=math.floor(os.clock()-coordinator.lastProgress)
end
local current=categories[1]
local function stopAll()
 coordinator.enabled=false
 setFarmEnabled(false)
 fruitAuto.enabled=false
 fruitAuto.generation+=1
 coordinator.state='Interrompido pelo usuário'
 coordinator.priority='Parado'
 farmLog('PARAR TUDO acionado')
end

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
  addText('FUMAÇA HUB v1.2 • Motor genérico de combate e monitoramento. Missões e ações do Blox Fruits não estão integradas.',13,rgb(197,207,220),75)
  addText('Coordenador: '..coordinator.state..' | Prioridade: '..coordinator.priority,13,rgb(160,215,179),45)
  addText('Nível observado: '..(coordinator.lastLevel and tostring(coordinator.lastLevel) or 'indisponível')..' | Níveis ganhos nesta sessão: '..coordinator.levelsGained,13,rgb(197,207,220),44)
  local toolCount,toolNames=getToolSummary()
  addText('Tools disponíveis: '..toolCount..' | '..(toolNames~='' and toolNames or 'nenhuma'),12,rgb(197,207,220),65)
  addText('Aba Farm: motor genérico. Frutas: simulação. Materiais, missões e raids: não integrados.',12,rgb(242,194,112),60)
  local panic=ui('TextButton',content,{Size=UDim2.new(1,-8,0,43),Text='PARAR TUDO',Font=Enum.Font.GothamBold,TextSize=15,TextColor3=rgb(255,255,255),BackgroundColor3=rgb(136,45,51)},8)
  panic.MouseButton1Click:Connect(function() stopAll(); show(current); notify('Todos os motores interrompidos') end)
  local refresh=ui('TextButton',content,{Size=UDim2.new(1,-8,0,34),Text='Atualizar painel',TextSize=12,TextColor3=rgb(255,255,255),BackgroundColor3=rgb(34,34,34)},7)
  refresh.MouseButton1Click:Connect(function() show(current) end)
 else
  addText(category[1]=='Configurações' and 'Ajustes gerais do painel. Arma, habilidades, velocidade e PvP ficam na aba Farm.' or 'Recursos planejados: os itens abaixo são informativos e ainda não executam ações.',12,rgb(174,184,198),48)
  if category[1]=='Materiais' then
   addText('Catálogo pesquisável. Selecionar não inicia coleta automática.',12,rgb(190,190,190),38)
   for _,filter in ipairs({'Todos','Sea 1','Sea 2','Sea 3'}) do
    local b=ui('TextButton',content,{Size=UDim2.new(1,-8,0,28),Text=filter..(seaFilter==filter and ' ✓' or ''),TextSize=13,TextColor3=rgb(240,240,240),BackgroundColor3=rgb(29,29,29)},7)
    b.MouseButton1Click:Connect(function() seaFilter=filter; show(current) end)
   end
   local searchBox=ui('TextBox',content,{Size=UDim2.new(1,-8,0,34),Text=materialSearch,PlaceholderText='Pesquisar material...',ClearTextOnFocus=false,TextColor3=rgb(255,255,255),BackgroundColor3=rgb(34,34,34),TextSize=13},7)
   searchBox.FocusLost:Connect(function() materialSearch=searchBox.Text; show(current) end)
   for _,entry in ipairs(materialCatalog) do
    local name,sea=entry[1],entry[2]
    if (seaFilter=='Todos' or sea==0 or seaFilter=='Sea '..sea) and string.find(string.lower(name),string.lower(materialSearch),1,true) then
     local b=ui('TextButton',content,{Size=UDim2.new(1,-8,0,31),Text=name..(materialSelected==name and '  ✓' or ''),TextSize=13,TextColor3=rgb(245,245,245),BackgroundColor3=rgb(28,28,28)},7)
     b.MouseButton1Click:Connect(function() materialSelected=name; show(current); notify('Material selecionado: '..name) end)
    end
   end
   addText('Selecionado: '..materialSelected,13,rgb(139,217,165),28)
  elseif category[1]=='Frutas' then
   addText('Gerenciador automático • simulação local',16,nil,35)
   local master=ui('TextButton',content,{Size=UDim2.new(1,-8,0,45),Text='Gerenciamento automático: '..(fruitAuto.enabled and 'LIGADO' or 'DESLIGADO'),Font=Enum.Font.GothamBold,TextSize=14,TextColor3=rgb(255,255,255),BackgroundColor3=fruitAuto.enabled and rgb(34,112,75) or rgb(65,65,65)},8)
   master.MouseButton1Click:Connect(function()
    fruitAuto.enabled=not fruitAuto.enabled
    fruitAuto.generation+=1
    local generation=fruitAuto.generation
    if fruitAuto.enabled then
     task.spawn(function()
      local cases={
       {'Fruta nova','teste_nova',false,true},
       {'Fruta duplicada','teste_duplicada',true,false},
       {'Reencontrar duplicada','teste_duplicada',true,false},
       {'Reencontrar armazenada','teste_nova',false,true},
       {'Armazenamento indisponível','teste_falha',false,false}
      }
      while fruitAuto.enabled and fruitAuto.generation==generation and gui.Parent do
       local item=cases[fruitAuto.index]
       if fruitAuto.collect then
        if item[3] and fruitAuto.drop then
         fruitDecision(item[2],item[1],true,false)
        elseif (not item[3]) and fruitAuto.store then
         fruitDecision(item[2],item[1],false,item[4])
        end
       end
       fruitAuto.index=fruitAuto.index%#cases+1
       -- Não reconstruir a interface a cada ciclo: evita perder cliques e foco.
       task.wait(2)
      end
     end)
    end
    show(current)
    notify(fruitAuto.enabled and 'Simulação automática iniciada' or 'Simulação automática pausada')
   end)
   for _,opt in ipairs({
    {'collect','Coletar frutas'},
    {'store','Guardar frutas novas'},
    {'drop','Descartar duplicadas'}
   }) do
    local key,title=opt[1],opt[2]
    local b=ui('TextButton',content,{Size=UDim2.new(1,-8,0,35),Text=title..': '..(fruitAuto[key] and 'SIM' or 'NÃO'),TextSize=13,TextColor3=rgb(255,255,255),BackgroundColor3=rgb(29,29,29)},7)
    b.MouseButton1Click:Connect(function() fruitAuto[key]=not fruitAuto[key]; show(current) end)
   end
   addText('Proteção contra loops: SEMPRE ATIVA',13,rgb(139,217,165),28)
   local stats=fruitState.stats
   addText('Simulação: armazenadas '..stats.stored..' | duplicadas '..stats.duplicates..' | ignoradas '..stats.ignored..' | falhas '..stats.failed,12,rgb(160,218,179),54)
   local reset=ui('TextButton',content,{Size=UDim2.new(1,-8,0,36),Text='Limpar histórico e reiniciar cenário',TextSize=13,TextColor3=rgb(255,255,255),BackgroundColor3=rgb(85,55,55)},7)
   reset.MouseButton1Click:Connect(function()
    fruitState.items={}; fruitState.history={}; fruitState.stats={stored=0,duplicates=0,ignored=0,failed=0}
    fruitAuto.index=1
    show(current); notify('Cenário reiniciado')
   end)
   local refresh=ui('TextButton',content,{Size=UDim2.new(1,-8,0,32),Text='Atualizar histórico',TextSize=12,TextColor3=rgb(255,255,255),BackgroundColor3=rgb(35,35,35)},7)
   refresh.MouseButton1Click:Connect(function() show(current) end)
   addText('Histórico das decisões',15,nil,30)
   for _,entry in ipairs(fruitState.history) do addText(entry,12,rgb(192,204,193),38) end
   addText('Este modo executa cenários simulados automaticamente. Não detecta, coleta, guarda ou descarta frutas reais.',11,rgb(218,181,125),68)
  end
  if category[1]=='Farm' then
   addText('Coordenador de tarefas',16,nil,31)
   local coordinatorButton=ui('TextButton',content,{Size=UDim2.new(1,-8,0,37),Text='COORDENADOR: '..(coordinator.enabled and 'LIGADO' or 'DESLIGADO'),TextSize=13,TextColor3=rgb(255,255,255),BackgroundColor3=rgb(33,65,67)},7)
   coordinatorButton.MouseButton1Click:Connect(function()
    coordinator.enabled=not coordinator.enabled
    if not coordinator.enabled then setFarmEnabled(false) elseif coordinator.mode=='Nível' then setFarmEnabled(true) end
    coordinatorTick(); show(current)
   end)
   for _,mode in ipairs({'Nível','Monitoramento'}) do
    local b=ui('TextButton',content,{Size=UDim2.new(1,-8,0,32),Text='Modo: '..mode..(coordinator.mode==mode and ' ✓' or ''),TextSize=12,TextColor3=rgb(255,255,255),BackgroundColor3=rgb(30,30,30)},7)
    b.MouseButton1Click:Connect(function()
     coordinator.mode=mode
     if mode=='Monitoramento' then setFarmEnabled(false)
     elseif coordinator.enabled then setFarmEnabled(true) end
     coordinatorTick(); show(current)
    end)
   end
   addText('Prioridade: '..coordinator.priority..' | Estado: '..coordinator.state,12,rgb(160,215,179),47)
   addText('Nível observado: '..(coordinator.lastLevel and tostring(coordinator.lastLevel) or 'indisponível')..' | Ganhos: '..coordinator.levelsGained..' | Tempo sem nível novo: '..coordinator.idleSeconds..'s',12,rgb(195,207,222),50)
   addText('Motor de combate genérico • início automático',15,nil,32)
   local run=ui('TextButton',content,{Size=UDim2.new(1,-8,0,43),Text='AUTO FARM: '..(farm.enabled and 'LIGADO' or 'DESLIGADO'),TextSize=14,Font=Enum.Font.GothamBold,TextColor3=rgb(255,255,255),BackgroundColor3=farm.enabled and rgb(35,113,80) or rgb(74,65,65)},8)
   run.MouseButton1Click:Connect(function() if coordinator.enabled and coordinator.mode=='Nível' then setFarmEnabled(not farm.enabled) else notify('Selecione coordenador ligado e modo Nível') end; show(current) end)
   addText('Estado: '..farm.status..' | Alvo: '..farm.target..' | Mortes de NPC observadas: '..farm.kills,12,rgb(161,217,182),58)
   addText('Busca NPCs em workspace.Enemies ou workspace.NPCs. Não aceita missões nem garante combate no Blox Fruits.',11,rgb(218,181,125),62)
   local targetBox=ui('TextBox',content,{Size=UDim2.new(1,-8,0,34),Text=farm.targetFilter,PlaceholderText='Filtrar NPC pelo nome (vazio = todos)',ClearTextOnFocus=false,TextColor3=rgb(255,255,255),BackgroundColor3=rgb(34,34,34),TextSize=13},7)
   targetBox.FocusLost:Connect(function() farm.targetFilter=targetBox.Text; show(current) end)
   for _,opt in ipairs({{'range','Distância de ataque',5,18,2},{'maxDistance','Alcance de busca',50,500,50},{'healthMinimum','Pausar com vida abaixo de (%)',.1,.7,.1}}) do
    local key,name,lo,hi,step=opt[1],opt[2],opt[3],opt[4],opt[5]
    local display=key=='healthMinimum' and math.floor(farm[key]*100+.5)..'%' or tostring(farm[key])
    local b=ui('TextButton',content,{Size=UDim2.new(1,-8,0,33),Text=name..': '..display..' (toque para aumentar)',TextSize=12,TextColor3=rgb(255,255,255),BackgroundColor3=rgb(29,29,29)},7)
    b.MouseButton1Click:Connect(function()
     farm[key]=farm[key]+step
     if farm[key]>hi+.001 then farm[key]=lo end
     show(current)
    end)
   end
   addText('Movimentos bloqueados: '..farm.stuckCount..' | Ataques usam Tool:Activate (sem skills especiais)',12,rgb(180,195,210),48)
   addText('Diagnóstico do motor',15,nil,29)
   for i=1,math.min(5,#farm.diagnostics) do addText(farm.diagnostics[i],11,rgb(180,195,210),27) end
   for _,weapon in ipairs({'Melee','Sword','Gun','Blox Fruit'}) do
    local b=ui('TextButton',content,{Size=UDim2.new(1,-8,0,32),BackgroundColor3=rgb(29,29,29),TextColor3=rgb(245,245,245),Font=Enum.Font.Gotham,TextSize=13,Text='Arma: '..weapon..(farmWeapon==weapon and '  ✓' or '')},7)
    b.MouseButton1Click:Connect(function() farmWeapon=weapon; show(current); notify('Arma preferida: '..weapon) end)
   end
   addText('Habilidades preferidas para '..farmWeapon..' (configuração local)',13,nil,40)
   local chosen=skillsByWeapon[farmWeapon]
   for _,skillName in ipairs({'Z','X','C','V','F'}) do
    local b=ui('TextButton',content,{Size=UDim2.new(1,-8,0,30),BackgroundColor3=rgb(29,29,29),TextColor3=rgb(245,245,245),TextSize=13,Text=skillName..(chosen[skillName] and '  ✓' or '  —')},7)
    b.MouseButton1Click:Connect(function() chosen[skillName]=not chosen[skillName]; show(current) end)
   end
   for _,action in ipairs({'Selecionar todas','Desmarcar todas'}) do
    local b=ui('TextButton',content,{Size=UDim2.new(1,-8,0,30),BackgroundColor3=rgb(38,38,38),TextColor3=rgb(245,245,245),TextSize=13,Text=action},7)
    b.MouseButton1Click:Connect(function() for _,key in ipairs({'Z','X','C','V','F'}) do chosen[key]=(action=='Selecionar todas') or nil end; show(current) end)
   end
   local skill=ui('TextButton',content,{Size=UDim2.new(1,-8,0,38),BackgroundColor3=rgb(30,30,30),TextColor3=rgb(255,255,255),Font=Enum.Font.GothamBold,TextSize=13,Text='Habilitar uso de skills: '..(fruitSkills and 'SIM' or 'NÃO')},7)
   skill.MouseButton1Click:Connect(function() fruitSkills=not fruitSkills; show(current); notify('Skills: preferência atualizada') end)
  end
  if category[1]=='Farm' then
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
   if category[1]~='Materiais' and category[1]~='Frutas' and name~='Tipo de arma para farm' and name~='Uso de habilidades da fruta' and name~='Usar skills da fruta' and name~='Velocidade de caminhada' and name~='Desabilitar PvP (preferência)' and name~='Preferência de PvP' then toggle(category[1],name) end
  end
  if category[1]=='Configurações' then
   local reset=ui('TextButton',content,{Size=UDim2.new(1,-8,0,38),Text='Restaurar preferências da sessão',Font=Enum.Font.GothamBold,TextSize=13,TextColor3=rgb(255,255,255),BackgroundColor3=rgb(104,67,70)},8)
   reset.MouseButton1Click:Connect(function()
    table.clear(states); skillsByWeapon={Melee={Z=true,X=true},Sword={Z=true,X=true},Gun={Z=true,X=true},['Blox Fruit']={Z=true,X=true,C=true}}; farmWeapon='Melee'; fruitSkills=false; speed=16; pvpPreference=false; applySpeed(); show(current); notify('Preferências restauradas')
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
close.MouseButton1Click:Connect(function() stopAll(); gui:Destroy() end)
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
runFarm()
task.spawn(function()
 while gui.Parent do
  coordinatorTick()
  if (not coordinator.enabled or coordinator.mode=='Monitoramento') and farm.enabled then setFarmEnabled(false) end
  task.wait(1)
 end
end)
