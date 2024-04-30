-- Функции поддержки
function copy(t)
	local t2 = {}
    for k,v in pairs(t) do
      t2[k] = v
    end
    return t2
end

function random(a,b)
  return math.random(a,b)
end

function RandomShuffleRole(ArrayRoles,  NumberOfPlayers)
  local arr = copy(ArrayRoles)
  if (#ArrayRoles < NumberOfPlayers) then
    local n = NumberOfPlayers-#ArrayRoles
    for i = 1, n do
      table.insert(arr,"Мирный")
    end
  end
  for i = 1, NumberOfPlayers do
    local rv = random(1,NumberOfPlayers)
    arr[i],arr[rv] = arr[rv],arr[i]
  end
  return arr
end

function find(obj,arr) -- Содержится ли объект в массиве? Если да, то какой первый индекс?
  local k = 0
  local stop = false
  for i = 1,#arr do
    if (arr[i] == obj and !stop) then
      k = i
      stop = true
    end
  end
  return k
end


function F(a,F,O,L,Pos,Rot,S,W,H,FS,Color,FColor) -- Конструктор кнопок
	local p = {}
  p.click_function = F
  p.function_owner = O
  p.label = L
  p.position = Pos
  p.rotation = Rot
  p.scale = S
  p.width = W
  p.height = H
  p.font_size = FS
  p.color = Color
  p.font_color = FColor
  a.createButton(p)
end

function wait(F,i) -- Ожидание
  Wait.frames(F, i*60)
end

function TownTimer()
  if (TimeCounter == 0) then
    UiSetTime(tostring(TimeCounter).."сек.")
    broadcastToAll("Время вышло.",{0.627, 0.125, 0.941})
  else
    TimeCounter = TimeCounter - 1
    UiSetTime(tostring(TimeCounter).."сек.")
    wait(TownTimer,1)
  end
end

function StartTimer(func,delay) -- Основной таймер
  TimeCounter = delay
  TownTimer() -- Запуск таймера
  wait(func,TimeCounter+1)
end

-- Классы (доработать)
Class_Effect = {}
Class_Effect.Name = "Название эффекта"
Class_Effect.Owner = "PlayerName"
Class_Effect.Time = 0
Class_Effect.Tag = "custom_effect"

Class_Item = {}
Class_Item.Name = "Название предмета"
Class_Item.Description = "Просто предмет..."
Class_Item.Tag = "custom_item"

Class_Target = {}
Class_Target.nameTag = "custom_target"
Class_Target.PlayerName = "PlayerName"

Class_Ability = {}
Class_Ability.Name = "Название способности"
Class_Ability.UseTime = 1
Class_Ability.IndexPhase = 0
Class_Ability.Tag = "custom_ability"

Class_Role = {}
Class_Role.Name = "Название роли"
Class_Role.Description = "Просто роль..."
Class_Role.IndexTeam = 0
Class_Role.Targets = {}
Class_Role.Abilities = {}

Class_Player = {}
Class_Player.Name = "PlayerName"
Class_Player.Color = "Grey"
Class_Player.Role = nil
Class_Player.IndexStatus = 0
Class_Player.Inventory = {}
Class_Player.Effects = {}

-- База загрузки
function onLoad() -- Основной архив (категорически не трогать!)
  --[[ Напоминалка!!
  TMafia = {"Мафия","Политик","Проститутка","Шофер","Вышибала","Адвокат","Подтасовщик улик","Портной","Шпион","Вор","Букмекер","Уборщик","Отравитель","Химик","Саботер","Террорист","Новичок"}
  TVillage = {"Мирный","Полицейский","Доктор","Защищенный","Охотник","Пассажир","Пьяница","Тюремщик","Водитель","Телохранитель","Мастер-на-все-руки","Детектив","Заместитель","Кузнец","Пекарь","Репортер","Оружейник","Сосед","Священник","Следователь","Медсестра","Мститель","Сообщник","Смотритель","Выслеживатель","Эльф"}
  TOther = {"Серийный убийца","Ведьма","Крот","Лидер культа","Поджигатель","Оборотень","Забывчивый","Санта Клаус","Выживающий","Пират"}
  ]]
  -- Константы и порядки
  OrderRoleList = {"Политик","Пассажир","Пьяница","Проститутка","Тюремщик","Водитель","Шофер","Ведьма","Телохранитель","Вышибала","Мастер-на-все-руки","Адвокат","Подтасовщик улик","Портной","Мафия","Крот","Лидер культа","Поджигатель","Оборотень","Забывчивый","Детектив","Полицейский","Заместитель","Шпион","Санта Клаус","Эльф","Кузнец","Пекарь","Репортер","Оружейник","Вор","Сосед","Священник","Букмекер","Уборщик","Следователь","Отравитель","Химик","Саботер","Террорист","Мститель","Серийный убийца","Выживающий","Пират","Сообщник","Смотритель","Выслеживатель","Новичок","Доктор","Медсестра","Тест","Мирный","Охотник","Защищенный"}
  OrderColorList = {"White","Brown","Red","Orange","Yellow","Green","Teal","Blue","Purple","Pink"}
  OrderPhaseList = {"День: Обсуждение","День: Голосование","Ночь: Голосование","Ночь: Действие","День: Действие"}
  OrderTeamList = {"Мирные","Мафия","Третья сторона"}
  OrderStatusList = {"Жив","Мертв"}
  -- Данные города
  Town_NumberOfLivingPeople = 0
  Town_StartRoles = {} -- по названиям
  Town_Players = {} -- по классу
  Town_CounterPhases = 0
  Town_CounterDays = 0
  Town_CounterNights = 0
  Town_CurrentPhase = 0
  Town_MafiaChat = {} -- каждый элемент это Владелец надписи и Надпись
  Town_PlayerVotes = {} -- Каждый элемент это Владелец голоса и Голос
  Town_MafiaVotes = {}-- Каждый элемент это Владелец голоса и Голос
  Town_KillList = {} -- По цветам (ибо могут меняться)
  Town_DeadList = {} -- По именам
  Town_Effects = {}
  GamePhase = 0
  Night_Progress = 0
  Night_Stop = false
  Night_Over = true
  TimeCounter = 0
  -- Настройки
  Setting_SkipFirstDay = false
  Setting_NightTimer = 60
  Setting_DayTimer = 60
  Setting_VoteTimer = 20
  Setting_GreyTalk = false
  Setting_AdminMode = false
  F(startObj,"StartGame",self,"Начать игру",{4, 0.25, 1.7},{0.00, 0.00, 0.00},{2, 2, 2},500,300,70,{1, 1, 1},{0.25, 0.25, 0.25})
end

-- UI поддержка (доработать)
function UiShowElement(id) -- Функция показа объекта
	UI.setAttribute(id,"active","true")
end
  
function UiHideElement(id) -- Функция сокрытия объекта
  UI.setAttribute(id,"active","false")
end

function UiChangeColor(id,color) -- Функция смены цвета
  UI.setAttribute(id,"color",color)
end

function UiGetColor(id)
  return UI.getAttribute(id,"color")
end

function UiChangePosition(id,x,y)
  UI.setAttribute(id,"offsetXY",tostring(x).." "..tostring(y))
end

function UiGetPosition(id)
  return UI.getAttribute(id,"offsetXY")
end

function UiChangeValue(id,value) -- Функция смены значения
	UI.setValue(id,value)
end

function UiStart() -- Показать стартовые объекты для игры
  for i=1,#Town_Players do
    UiChangeColor("id-Hide-ButtonChange-"..Town_Players[i].Color,"#00FA9A80")
    UiShowElement("id-Hide-ButtonChange-"..Town_Players[i].Color)
    UiShowElement("id-PlayerMenu-Table-"..Town_Players[i].Color)
    UiShowElement("id-AbilityMenu-Table-"..Town_Players[i].Color)
    UiShowElement("id-PlayersList-Table-"..Town_Players[i].Color)
    UiShowElement("id-Time-Table-"..Town_Players[i].Color)
  end
end

function UiSetPlayersList(text)
  for i=1,#Town_Players do
    UiChangeValue("id-PlayersList-TextList-"..Town_Players[i].Color,text)
  end
end

function UiSetPhase(text)
  for i=1,#Town_Players do
    UiChangeValue("id-Time-TextPhase-"..Town_Players[i].Color,text)
  end
end

function UiSetTime(text)
  for i=1,#Town_Players do
    UiChangeValue("id-Time-TextTime-"..Town_Players[i].Color,text)
  end
end



-- UI связки

function UI_RoleDesc(player,message,namef)
  for i=1,#Town_Players do
    if (Town_Players[i].Color == player.color) then
      broadcastToColor("---\n"..Town_Players[i].Role.Description.."\n---",player.color,{0.118, 0.53, 1})
    end
  end
end

function UI_ChatButton(player,message,namef)
  for i=1,#Town_Players do
    if (Town_Players[i].Color == player.color) then
      local id = "id-PlayerMenu-ButtonChat-"..player.color
      if (UiGetColor(id) == "#80808080") then -- проверка того, что кнопка серая
        UiChangeColor(id,"#800000F0")
        UiShowElement("id-PlayerMenu-RowChat-"..player.color)
        UiShowElement("id-PlayerMenu-RowInput-"..player.color)
      else
        UiChangeColor(id,"#80808080")
        UiHideElement("id-PlayerMenu-RowChat-"..player.color)
        UiHideElement("id-PlayerMenu-RowInput-"..player.color)
      end
    end
  end
end

function UI_MafiaChat(player,message,namef)
  for i=1,#Town_Players do
    if (Town_Players[i].Color == player.color) then
      table.insert(Town_MafiaChat,{Town_Players[i].Name,message})
      UI.setAttribute("id-PlayerMenu-InputChat-"..player.color,"text","")
    end
  end
end

function UI_AbilityShow(player,message,namef)
  for i=1,#Town_Players do
    if (Town_Players[i].Color == player.color) then
      local id = "id-AbilityMenu-Table-"..player.color
      if (UiGetPosition(id) == "-700 -100") then -- проверка того, что открыто
        UiChangePosition(id,-1120,-100) -- закрытое
      else
        UiChangePosition(id,-700,-100) -- открытое
      end
    end
  end
end

function UI_PlayersShow(player,message,namef)
  for i=1,#Town_Players do
    if (Town_Players[i].Color == player.color) then
      local id = "id-PlayersList-Table-"..player.color
      if (UiGetPosition(id) == "700 -100") then -- проверка того, что открыто
        UiChangePosition(id,1120,-100) -- закрытое
      else
        UiChangePosition(id,700,-100) -- открытое
      end
    end
  end
end

function UI_ShowAll(player,message,namef)
  for i=1,#Town_Players do
    if (Town_Players[i].Color == player.color) then
      local id = "id-Hide-ButtonChange-"..player.color
      if (UiGetColor(id) == "#80808080") then -- проверка того, что кнопка серая
        UiChangeColor(id,"#00FA9A80")
        UiShowElement("id-PlayerMenu-Table-"..player.color)
        UiShowElement("id-AbilityMenu-Table-"..player.color)
        UiShowElement("id-PlayersList-Table-"..player.color)
        UiShowElement("id-Time-Table-"..player.color)
      else
        UiChangeColor(id,"#80808080")
        UiHideElement("id-PlayerMenu-Table-"..player.color)
        UiHideElement("id-AbilityMenu-Table-"..player.color)
        UiHideElement("id-PlayersList-Table-"..player.color)
        UiHideElement("id-Time-Table-"..player.color)
      end
    end
  end
end

function UI_ButtonSleep(player,message,namef)
  player.blindfolded = true
end


-- Команды чата
function onChat(message,Player) -- Функция связанная с чатом, а точнее команды
	--[[
    if message == "@admin" and Player.admin == true and admin == 0 then -- Вкл/выкл режим админа
      broadcastToAll("ВНИМАНИЕ: "..tostring(Player.color).." активировал режим админа!",{0.627, 0.125, 0.941})
      admin = 1
      return false
    elseif message == "@admin" and Player.admin == true and admin == 1 then
      broadcastToAll("ВНИМАНИЕ: "..tostring(Player.color).." деактивировал режим админа!",{0.627, 0.125, 0.941})
      admin = 0
      return false
    end
    if message == "@logs" and Player.host == true and admin == 1 then -- Отписать логи
      broadcastToAll("ВНИМАНИЕ: "..tostring(Player.color).." открыл логи!",{0.627, 0.125, 0.941})
      local p = {}
      local a = ""
      p.title = "Логи"
      for i = 1,#Log do
        a = a .. Log[i].."\n".."\n"
      end
      p.body = a
      Notes.addNotebookTab(p)
      return false
    end
    if message == "@greytalk" and Player.admin == true and admin == 1 then -- Позволить или не позволять писать в чат серым игрокам (изначально - нельзя)
      if greytalk == 0 then
        broadcastToAll("ВНИМАНИЕ: "..tostring(Player.color).." включил чат для серых игроков.",{0.627, 0.125, 0.941})
        greytalk = 1
      else
        broadcastToAll("ВНИМАНИЕ: "..tostring(Player.color).." отключил чат для серых игроков.",{0.627, 0.125, 0.941})
        greytalk = 0
      end
      return false
    end
    if message == "@greymute" and Player.admin == true and admin == 1 then -- Мут серых игроков
      broadcastToAll("ВНИМАНИЕ: "..tostring(Player.color).." использовал mute на серых игроках.",{0.627, 0.125, 0.941})
      for s1,s2 in ipairs(getSpectators()) do
        s2.mute()
      end
    end
    if Player.color == "Grey" and greytalk == 0 then -- Само ограничение для серых игроков
      broadcastToColor("Вы умерли.Вам нельзя говорить.",Player.color,{0.5, 0.5, 0.5})
      return false
    end
	]]
end

function onBlindfold(player, blindfolded) --- Триггер сна
  if (GamePhase == 2) then
    if (isAllSleep()) then
      if (Night_Progress == 0) then
        printToAll("Эта ночь начнется через 5 секунд...",{0.192, 0.701, 0.168})
        -- Запуск ночных действий через 5 секунд
        Night_Over = false
      elseif (Night_Progress != 0 and !Night_Stop) then
        -- Продолжение ночных действий
      end
    end
  end
end

-- Основной триггер
function onUpdate() 

end

function isAllSleep()  --- Проверка сна
  local check = true
  for i = 1,#Town_Players do
    if Player[Town_Players[i].Color] != nil then
      if Player[Town_Players[i].Color].blindfolded == false and find(Town_Players[i].Name) == 0 then
        check = false
      end
    end
  end
  return check
end

function SortRoleList() -- Сортировка листа ролей для порядка ночью
  local sort_list = {}
  for i=1,#OrderRoleList do
    if (find(OrderRoleList[i],Town_StartRoles) != 0) then -- по порядку
      table.insert(sort_list,OrderRoleList[i])
    elseif (i == 15) then -- если роли "Мафия" нет, но есть клан мафии, то добавляется
      table.insert(sort_list,OrderRoleList[i])
    end
  end
  Town_StartRoles = copy(sort_list)
end

function CreateRole(role)
  local r = copy(Class_Role)
  if (role == "Мирный") then
    r.Name = "Мирный"
    r.Description = "У тебя нет особых способностей.Просто...будь мирным)"
    r.IndexTeam = 1
    r.Targets = {}
    r.Abilities = {}
  elseif (role == "Мафия") then
    r.Name = "Мафия"
    r.Description = "Ты принадлежишь клану мафии.Каждую ночь ты голосуешь вместе со своим кланом за убийство мирного игрока.Постарайся, чтобы тебя или твоего союзника не убили мирные."
    r.IndexTeam = 2
    r.Targets = {}
    r.Abilities = {}
  elseif (role == "Полицейский") then
    r.Name = "Полицейский"
    r.Description = "Ты принадлежишь команде мирных.Ночью ты можешь узнать принадлежит ли выбранный игрок клану мафии или нет.Будь аккуратен,ведь у них может быть тот, кто может обмануть твою способность."
    r.IndexTeam = 1
    r.Targets = {}
    r.Abilities = {}
  elseif (role == "Доктор") then
    r.Name = "Доктор"
    r.Description = "Ты принадлежишь команде мирных.Ночью ты можешь спасти игрока от смерти.Выбранный тобою игрок будет спасен от одного убийства в эту ночь.Но себя ты можешь спасти только 1 раз.Будь бдителен, ведь ты тот , кто может спасти и узнать невиновных."
    r.IndexTeam = 1
    r.Targets = {}
    r.Abilities = {}
  elseif (role == "Детектив") then
    r.Name = "Детектив"
    r.Description = "Ты принадлежишь команде мирных.Ночью ты расследуешь дело о клане мафии.Твои расследования каждую ночь приносят информацию о роли , выбранного тобою , игрока.Но аккуратнее, ведь в клане мафии может быть тот, кто может помешать в расследовании."
    r.IndexTeam = 1
    r.Targets = {}
    r.Abilities = {}
  elseif (role == "Серийный убийца") then
    r.Name = "Серийный убийца"
    r.Description = "Ты одинокий хладнокровный убийца...Ты убиваешь,потому что хочешь услышать чистые...крики жертв ... в тишине...Даже мафия боится тебя.Каждую ночь ты убиваешь игрока.Помни: твой главный враг - мафия,поэтому прими помощь жителей,но они тоже должны будут умереть.Ты победишь в этой игре , если всех ,кроме тебя,умрут..."
    r.IndexTeam = 2
    r.Targets = {}
    r.Abilities = {}
  end
  return r
end

function PhaseChange()
  if (Town_CurrentPhase == 1) then
    wait(Phase_DaySpeech,2)
  elseif (Town_CurrentPhase== 2) then
    wait(Phase_DayVote,2)
  elseif (Town_CurrentPhase == 3) then
    wait(Phase_NightVote,2)
  elseif (Town_CurrentPhase == 4) then
    wait(Phase_NightAction,2)
  elseif (Town_CurrentPhase == 5) then
    wait(Phase_DayAction,2)
  end
end

function StartGame()
  Town_NumberOfLivingPeople = #Player.getPlayers()
  if (Town_NumberOfLivingPeople < 3) then
    broadcastToAll("Недостаточно игроков для начала игры. Необходимо минимум 3 игрока.",{0.856, 0.1, 0.094})
  elseif (Town_NumberOfLivingPeople < #Town_StartRoles) then
    broadcastToAll("Пул ролей превышает текущее количество игроков. Уберите лишние.",{0.856, 0.1, 0.094})
  else
    local arr = Player.getPlayers()
    local Roles = RandomShuffleRole(Town_StartRoles,  Town_NumberOfLivingPeople)
    for i = 1, Town_NumberOfLivingPeople do
      if (arr[i].seated == true and arr[i].color != "Grey") then
        local player = copy(Class_Player)
        player.Name = arr[i].name
        player.Color = arr[i].color
        player.Role = CreateRole(Roles[i])
        player.IndexStatus = 1
        table.insert(Town_Players,player)
        UiChangeValue("id-PlayerMenu-TextRole-"..player.Color,player.Role.Name)
      end
    end
    SortRoleList()
    -- Доработать тут в виде функции
    local ListText = "Колода ролей:\n"
    for i=1,#Town_StartRoles do
      ListText = ListText .. Town_StartRoles[i].."\n"
    end
    ListText = "\nИгроки:\n"
    for i=1,#Town_Players do
      ListText = ListText .. Town_Players[i].Name .. "Неизвестно" .."\n"
    end
    UiSetPlayersList(ListText)
    UiStart()
    -- Добавить UI расстановку способностей
    broadcastToAll("Подготовка к игре завершена",{0.118, 0.53, 1})
    Notes.setNotes("")
    GamePhase = 1
    if (Setting_SkipFirstDay) then
      -- Если до мафии никого в колоде нет, то фаза ночного голосования, иначе ночное действие
    else
      Town_CurrentPhase = 1 -- Признак начала игры
      PhaseChange() -- Начало дня
    end
    -- Запуск фазы через функцию фаз (придумать так, чтоб было универсально)
  end
end

function Phase_DaySpeech()
  -- Установка фазы и таймера UI
  -- Активация таймера UI
end

function Phase_DayVote()
  -- Установка фазы и таймера UI
  -- Активация таймера UI
end

function Phase_NightVote()
  -- Установка фазы и таймера UI
  -- Активация таймера UI
end

function Phase_NightAction()
  -- Установка фазы и таймера UI
  -- Активация таймера UI
end

function Phase_DayAction()
  -- Установка фазы и таймера UI
  -- Активация таймера UI
end

function DayVote()
  local votes = {}
  local counter = {}
  local maxCount = 0
  local finishVote = {}
  for i=1,#Town_PlayerVotes do
    local indexObj = find(Town_PlayerVotes[i][2],votes)
    if (indexObj == 0) then
      table.insert(votes,Town_PlayerVotes[i][2])
      table.insert(counter,1)
    else  
      counter[indexObj] = counter[indexObj] + 1
    end
  end
  for i=1,#counter do
    if (counter[i]>=maxCount) then
      maxCount = counter[i]
    end
  end
  for i=1,#counter do
    if (counter[i] == maxCount) then
      table.insert(finishVote,{votes[i],maxCount})
    end
  end
  if (#finishVote == 1) then
    printToAll("Голосование прошло успешно!",{0.129, 0.694, 0.607})
    -- Фаза дня - Действие на 5 секунд для активации способности, если игрок пожелает нажать в текущее время
    -- Убить игрока если действие не отменило казнь
  else
    printToAll("Равное кол-во голосов.Голосование заканчивается.Наступает ночь.",{0.856, 0.1, 0.094})
  end
  Town_PlayerVotes = {}
  GamePhase = 2 -- Разрешение на закрытие глаз
  -- Добавить UI кнопку на закрытие глаз. Отключить функцию закрытия глаз в игре
end

function NightProgression()
  if (!isAllSleep()) then 
    Night_Over = true
    broadcastToAll("Ночь отменена!",{0.856, 0.1, 0.094})
    printToAll("Ночь отменена игроками:",{0.856, 0.1, 0.094})
    for i = 1,#Town_Players do
      if Player[Town_Players[i].Color].blindfolded == true then
        Player[Town_Players[i].Color].blindfolded = false
      else
        printToAll(tostring(Town_Players[i].Name),{0.856, 0.1, 0.094})
      end
    end
    return false
  end
  if (!Night_Over) then
    -- Действия ролей
  else
    GamePhase = 1
    -- Подведение итогов ночи
    -- работа с UI
    for i = 1,#Town_Players do
      Player[Town_Players[i].Color].blindfolded = false
    end
    printToAll("Ночь №"..tostring(Town_CounterNights).." окончена",{0.192, 0.701, 0.168})
    printToAll("Итог ночи:",{0.956, 0.392, 0.113})
    -- Перевод списка убийств в смерти
    broadcastToAll("День начинается!",{0.118, 0.53, 1})
    Town_CurrentPhase = 1 -- Перевод в день обсуждения
    PhaseChange() -- Начало дня
  end
end

function NightVote()
  local votes = {}
  local counter = {}
  local maxCount = 0
  local finishVote = {}
  for i=1,#Town_MafiaVotes do
    local indexObj = find(Town_MafiaVotes[i][2],votes)
    if (indexObj == 0) then
      table.insert(votes,Town_MafiaVotes[i][2])
      table.insert(counter,1)
    else  
      counter[indexObj] = counter[indexObj] + 1
    end
  end
  for i=1,#counter do
    if (counter[i]>=maxCount) then
      maxCount = counter[i]
    end
  end
  for i=1,#counter do
    if (counter[i] == maxCount) then
      table.insert(finishVote,{votes[i],maxCount})
    end
  end
  if (#finishVote == 1) then
    printToAll("Голосование прошло успешно!",{0.129, 0.694, 0.607})
    -- Добавить игрока в список убийств
  else
    printToAll("Голосование прошло успешно!",{0.129, 0.694, 0.607})
    -- Голосование не прошло успешно. 
  end
  Night_Stop = false
  Town_MafiaVotes = {}
  -- Добавить Night_Progression когда разберемся с порядком
end


--[[
  Сделать:
  --
  4. Подсоединить данные к UI
  5. Сделать функции воздействия на UI списки с кнопками
  --
  6. Разработать систему эффектов
  7. Проработать ночные фазы
  --
  8. Подсоединить UI к эффектам
  9. Подсоединить UI к пулу ролей на столе
  10. Тестирование

  Тестирование:
  1. Night_Progression - отсортирован список для пробуждения. У "Мафия" особенное пробуждение с голосованием.
]]