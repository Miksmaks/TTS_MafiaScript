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

function count(obj,arr) -- Сколько таких объектов содержиться в массиве?
  local k = 0
  for i = 1,#arr do
    if (arr[i] == obj) then
      k = k + 1
    end
  end
  return k
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
Class_Effect.Time = 0 -- +1 за каждую День или Ночь (промежуточные не учитываются)
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
Class_Ability.Recharge = false
Class_Ability.IndexPhase = 0
Class_Ability.Tag = "custom_ability"

Class_Role = {}
Class_Role.Name = "Название роли"
Class_Role.Description = "Просто роль..."
Class_Role.IndexTeam = 0
Class_Role.isNightSleep = true
Class_Role.Targets = {}
Class_Role.Abilities = {}

Class_Player = {}
Class_Player.Name = "PlayerName"
Class_Player.Color = "Grey"
Class_Player.Role = nil
Class_Player.IndexStatus = 0
Class_Player.Inventory = {}
Class_Player.Effects = {} -- эффекты наложенные на игрока

-- База загрузки
function onLoad() -- Основной архив (категорически не трогать!)
  --[[ Напоминалка!!
  TMafia = {"Мафия","Политик","Проститутка","Шофер","Вышибала","Адвокат","Подтасовщик улик","Портной","Шпион","Вор","Букмекер","Уборщик","Отравитель","Химик","Саботер","Террорист","Новичок"}
  TVillage = {"Мирный","Полицейский","Доктор","Защищенный","Охотник","Пассажир","Пьяница","Тюремщик","Водитель","Телохранитель","Мастер-на-все-руки","Детектив","Заместитель","Кузнец","Пекарь","Репортер","Оружейник","Сосед","Священник","Следователь","Медсестра","Мститель","Сообщник","Смотритель","Выслеживатель","Эльф"}
  TOther = {"Серийный убийца","Ведьма","Крот","Лидер культа","Поджигатель","Оборотень","Забывчивый","Санта Клаус","Выживающий","Пират"}
  ]]
  -- Константы и порядки
  -- перепроверить список (после тестирования)
  OrderRoleList = {"Политик","Пассажир","Пьяница","Проститутка","Тюремщик","Водитель","Шофер","Ведьма","Телохранитель","Вышибала","Мастер-на-все-руки","Адвокат","Подтасовщик улик","Портной","Мафия","Крот","Лидер культа","Поджигатель","Оборотень","Забывчивый","Детектив","Полицейский","Заместитель","Шпион","Санта Клаус","Эльф","Кузнец","Пекарь","Репортер","Оружейник","Вор","Сосед","Священник","Букмекер","Уборщик","Следователь","Отравитель","Химик","Саботер","Террорист","Мститель","Серийный убийца","Выживающий","Пират","Сообщник","Смотритель","Выслеживатель","Новичок","Доктор","Медсестра","Тест","Мирный","Охотник","Защищенный"}
  OrderColorList = {"White","Brown","Red","Orange","Yellow","Green","Teal","Blue","Purple","Pink"}
  OrderPhaseList = {"День: Обсуждение","День: Голосование","Ночь: Голосование","Ночь: Действие","День: Действие"}
  OrderTeamList = {"Мирные","Мафия","Третья сторона"}
  OrderStatusList = {"Жив","Мертв"}
  MaxMafia = 3
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
  Town_Effects = {} -- Эффекты наложенные на город, а не на игрока
  GamePhase = 0
  PhaseActionTag = "" -- Это тег текущего действия для UI. Если охотник ,например, стреляет, то выборка цели будет с таким тегом
  Night_Progress = 0
  Night_Stop = false
  Night_Over = true
  TimeCounter = 0
  -- Настройки
  Setting_SkipFirstDay = false
  Setting_StandartMode = false
  Setting_NightTimer = 30
  Setting_DayTimer = 180
  Setting_VoteTimer = 20
  Setting_NightActionTime = 10
  Setting_DayActionTime = 5
  Setting_GreyTalk = false
  Setting_AdminMode = false
  StartObj = getObjectFromGUID("")
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

function UiSetPlayersList()
  local ListText = "Колода ролей:\n"
  for i=1,#Town_StartRoles do
    ListText = ListText .. Town_StartRoles[i].."\n"
  end
  ListText = ListText .. "\nИгроки:\n"
  for i=1,#Town_Players do
    if (Town_Players[i].IndexStatus == 1) then
      ListText = ListText .. Town_Players[i].Name .. " - " .. "Неизвестно" .."\n"
    else
      ListText = ListText .. Town_Players[i].Name .. " - " .. Town_Players[i].Role.Name .."\n"
    end
  end
  for i=1,#Town_Players do
    UiChangeValue("id-PlayersList-TextList-"..Town_Players[i].Color,ListText)
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

function UiVoteBlankShow(currentPlayer) -- аргумент это игрок
  if (Town_CurrentPhase == 2) then -- Общее дневное голосование
    for i=1,#Town_Players do
      for j=1,#OrderColorList do 
        local plr = FromColorToPlayer(OrderColorList[j])
        if (plr == nil) then
          UiHideElement("id-Vote-Row"..tostring(j).."-"..Town_Players[i].Color)
        elseif (plr.IndexStatus == 2) then
          UiHideElement("id-Vote-Row"..tostring(j).."-"..Town_Players[i].Color)
        end
      end
      UiChangeValue("id-Vote-HeadText-"..Town_Players[i].Color,"Билет для голосования")
      UiShowElement("id-Vote-Table-"..Town_Players[i].Color)
    end
  elseif (Town_CurrentPhase == 3) then -- Мафиозное голосование
    for i=1,#Town_Players do
      if (Town_Players[i].Role.IndexTeam == 2) then
        for j=1,#OrderColorList do 
          local plr = FromColorToPlayer(OrderColorList[j])
          if (plr == nil) then
            UiHideElement("id-Vote-Row"..tostring(j).."-"..Town_Players[i].Color)
          elseif (plr.IndexStatus == 2) then
            UiHideElement("id-Vote-Row"..tostring(j).."-"..Town_Players[i].Color)
          end
        end
        UiChangeValue("id-Vote-HeadText-"..Town_Players[i].Color,"Убить игрока")
        UiShowElement("id-Vote-Table-"..Town_Players[i].Color)
      end
    end
  elseif (Town_CurrentPhase == 4 or Town_CurrentPhase == 5) then -- Выбор цели
    for j=1,#OrderColorList do 
      local plr = FromColorToPlayer(OrderColorList[j])
      if (plr == nil) then
        UiHideElement("id-Vote-Row"..tostring(j).."-"..currentPlayer.Color)
      elseif (plr.IndexStatus == 2 or plr.Name == currentPlayer.Name) then
        UiHideElement("id-Vote-Row"..tostring(j).."-"..currentPlayer.Color)
      end
    end
    UiChangeValue("id-Vote-HeadText-"..currentPlayer.Color,"Выбор цели")
    UiShowElement("id-Vote-Table-"..currentPlayer.Color)
  end
end

function UiAbilitiesSettings()
  for i=1,#Town_Players do
    for j=1,6 do
      if (Town_Players[i].Role.Abilities[j] == nil) then
        UiHideElement("id-AbilityMenu-Row"..tostring(j).."-"..Town_Players[i].Color)
      else
        UiChangeValue("id-AbilityMenu-Button"..tostring(j).."-"..Town_Players[i].Color,Town_Players[i].Role.Abilities[j].Name)
        UiChangeValue("id-AbilityMenu-Counter"..tostring(j).."-"..Town_Players[i].Color,Town_Players[i].Role.Abilities[j].UseTime)
      end
    end
  end
end

function SetNoteRolePool()
  local ListText =  "Колода ролей:\n"
  for i=1,#OrderRoleList do
    if (find(OrderRoleList[i],Town_StartRoles) != 0) then
      ListText = ListText .. OrderRoleList[i] .. " - " .. count(OrderRoleList[i],Town_StartRoles) .. "шт.\n"
    end
  end
  Notes.setNotes(ListText)
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

function UI_VoteBlank(player,message,namef) -- message передает индекс в порядке цветов
  for i=1,#Town_Players do
    if (Town_Players[i].Color == player.color) then
      if (Town_CurrentPhase == 2) then -- дневное голосование
        table.insert(Town_PlayerVotes,{Town_Players[i].Name,FromColorToPlayer(OrderColorList[message]).Name})
      elseif (Town_CurrentPhase == 3) then -- ночное голосование
        table.insert(Town_MafiaVotes,{Town_Players[i].Name,FromColorToPlayer(OrderColorList[message]).Name})
      elseif (Town_CurrentPhase == 4 or Town_CurrentPhase == 5) then -- ночной и дневной выбор
        TwoStepActivateAbility(FromColorToPlayer(OrderColorList[message]),FromColorToPlayer(player.color),PhaseActionTag)
      end
      UiHideElement("id-Vote-Table-"..player.color)
    end
  end
end

function UI_AbilityMenu(player,message,namef)
  for i=1,#Town_Players do
    if (Town_Players[i].Color == player.color) then
      if (Town_CurrentPhase == Town_Players[i].Role.Abilities[message].IndexPhase and Town_Players[i].Role.Abilities[message].UseTime > 0 and !Town_Players[i].Role.Abilities[message].Recharge) then
        Town_Players[i].Role.Abilities[message].UseTime = Town_Players[i].Role.Abilities[message].UseTime - 1
        Town_Players[i].Role.Abilities[message].Recharge = true
        UiChangeValue("id-AbilityMenu-Counter"..tostring(message).."-"..player.color,Town_Players[i].Role.Abilities[message].UseTime)
        ActivateAbility(Town_Players[i],message)
      elseif (Town_Players[i].Role.Abilities[message].Recharge) then
        broadcastToColor("Вы уже использовали эту способность!",player.color,{0.627, 0.125, 0.941})
      elseif (Town_Players[i].Role.Abilities[message].UseTime <= 0) then
        broadcastToColor("Эта способность исчерпана!",player.color,{0.627, 0.125, 0.941})
      else
        broadcastToColor("Эта способность не действует в текущую фазу!",player.color,{0.627, 0.125, 0.941})
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
  UiHideElement("id-Sleep-Button-"..player.color)
end

function UI_Settings(player,message,namef)
  if (player.admin) then
    if (message == "1p") then
      if (Setting_DayTimer < 300) then
        Setting_DayTimer = Setting_DayTimer + 30
        StartObj.UI.setValue("id_setting_daytime",Setting_DayTimer)
      end
    elseif (message == "1m") then
      if (Setting_DayTimer > 60) then
        Setting_DayTimer = Setting_DayTimer - 30
        StartObj.UI.setValue("id_setting_daytime",Setting_DayTimer)
      end
    elseif (message == "2p") then
      if (Setting_VoteTimer < 60) then
        Setting_VoteTimer = Setting_VoteTimer + 10
        StartObj.UI.setValue("id_setting_dayvotetime",Setting_VoteTimer)
      end
    elseif (message == "2m") then
      if (Setting_VoteTimer > 10) then
        Setting_VoteTimer = Setting_VoteTimer - 10
        StartObj.UI.setValue("id_setting_dayvotetime",Setting_VoteTimer)
      end
    elseif (message == "3p") then
      if (Setting_NightTimer < 30) then
        Setting_NightTimer = Setting_NightTimer + 5
        StartObj.UI.setValue("id_setting_nightvotetime",Setting_NightTimer)
      end
    elseif (message == "3m") then
      if (Setting_NightTimer > 5) then
        Setting_NightTimer = Setting_NightTimer - 5
        StartObj.UI.setValue("id_setting_nightvotetime",Setting_NightTimer)
      end
    elseif (message == "4p") then
      if (Setting_NightActionTime < 20) then
        Setting_NightActionTime = Setting_NightActionTime + 2
        StartObj.UI.setValue("id_setting_nightactiontime",Setting_NightActionTime)
      end
    elseif (message == "4m") then
      if (Setting_NightActionTime > 8) then
        Setting_NightActionTime = Setting_NightActionTime - 2
        StartObj.UI.setValue("id_setting_nightactiontime",Setting_NightActionTime)
      end
    elseif (message == "5p") then
      if (Setting_DayActionTime < 8) then
        Setting_DayActionTime = Setting_DayActionTime + 1
        StartObj.UI.setValue("id_setting_dayactiontime",Setting_DayActionTime)
      end
    elseif (message == "5m") then
      if (Setting_DayActionTime > 3) then
        Setting_DayActionTime = Setting_DayActionTime - 1
        StartObj.UI.setValue("id_setting_dayactiontime",Setting_DayActionTime)
      end
    elseif (message == "6p") then
      Setting_SkipFirstDay = true
      StartObj.UI.setValue("id_setting_skipfirstday","Да")
    elseif (message == "6m") then
      Setting_SkipFirstDay = false
      StartObj.UI.setValue("id_setting_skipfirstday","Нет")
    elseif (message == "7p") then
      Setting_StandartMode = true
      StartObj.UI.setValue("id_setting_standartcards","Да")
    elseif (message == "7m") then
      Setting_StandartMode = false
      StartObj.UI.setValue("id_setting_standartcards","Нет")
    end
  else
    broadcastToColor("Настройку могут производить только админы!",player.color,{0.627, 0.125, 0.941})
  end
end

function UI_AddRolePool(player,message,namef)
  if (player.admin) then
    local k = tonumber(message)
    if (count(OrderRoleList[k],Town_StartRoles) <= MaxMafia) then
      table.insert(Town_StartRoles,OrderRoleList[k])
      SetNoteRolePool()
    end
  else
    broadcastToColor("Настройку могут производить только админы!",player.color,{0.627, 0.125, 0.941})
  end
end

function UI_DelRolePool(player,message,namef)
  if (player.admin) then
    local k = tonumber(message)
    local index = find(OrderRoleList[k],Town_StartRoles) 
    if (index != 0) then
      Town_StartRoles[index] = Town_StartRoles[#Town_StartRoles]
      Town_StartRoles[#Town_StartRoles] = nil
      SetNoteRolePool()
    end
  else
    broadcastToColor("Настройку могут производить только админы!",player.color,{0.627, 0.125, 0.941})
  end
end

-- Команды чата
function onChat(message,Player) -- Функция связанная с чатом, а точнее команды (занять после тестирования)
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
        wait(NightProgression,5)
        Night_Over = false
      elseif (Night_Progress != 0 and !Night_Stop) then
        wait(NightProgression,2)
      end
    end
  end
end

-- Основной триггер
function onUpdate() -- оставить пустым на потом

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

function FromColorToPlayer(color) -- Read only!
  for i=1,#Town_Players do
    if (Town_Players[i].Color == color) then
      return Town_Players[i]
    end
  end
  return nil
end

function SimulatePlayer()
  wait(NightProgression,random(10,20))
end

function StartAbilities(role)
  local list = {}
  --[[if (role == "Мафия") then
    local a = copy(Class_Ability)
    a.Name = "Убийство"
    a.UseTime = 99
    a.IndexPhase = 3
    a.Tag = "ability_mafia_kill"
    table.insert(list,a)]]
  if (role == "Полицейский") then
    local a = copy(Class_Ability)
    a.Name = "Проверка деятельности"
    a.UseTime = 99
    a.IndexPhase = 4
    a.Tag = "ability_police_search"
    table.insert(list,a)
  elseif (role == "Доктор") then
    local a1 = copy(Class_Ability)
    a1.Name = "Вызов врача"
    a1.UseTime = 99
    a1.IndexPhase = 4
    a1.Tag = "ability_doctor_heal"
    local a2 = copy(Class_Ability)
    a2.Name = "Самолечение"
    a2.UseTime = 1
    a2.IndexPhase = 4
    a2.Tag = "ability_doctor_selfheal"
    table.insert(list,a1)
    table.insert(list,a2)
  elseif (role == "Детектив") then
    local a = copy(Class_Ability)
    a.Name = "Сбор улик"
    a.UseTime = 99
    a.IndexPhase = 4
    a.Tag = "ability_detective_search"
    table.insert(list,a)
  elseif (role == "Серийный убийца") then
    local a = copy(Class_Ability)
    a.Name = "Убийство"
    a.UseTime = 99
    a.IndexPhase = 4
    a.Tag = "ability_serialkiller_kill"
    table.insert(list,a)
  elseif (role == "Политик") then
    local a = copy(Class_Ability)
    a.Name = "Саботаж ночи"
    a.UseTime = 1
    a.IndexPhase = 4
    a.Tag = "ability_politic_sabotage"
    table.insert(list,a)
  elseif (role == "Подтасовщик улик") then
    local a = copy(Class_Ability)
    a.Name = "Подкинуть улики"
    a.UseTime = 99
    a.IndexPhase = 4
    a.Tag = "ability_framer_sabotage"
    table.insert(list,a)
  elseif (role == "Адвокат") then
    local a = copy(Class_Ability)
    a.Name = "Защитить права"
    a.UseTime = 99
    a.IndexPhase = 4
    a.Tag = "ability_lawyer_sabotage"
    table.insert(list,a)
  end
  return list
end

function CreateRole(role)
  local r = copy(Class_Role)
  if (role == "Мирный") then
    r.Name = "Мирный"
    r.Description = "У тебя нет особых способностей.Просто...будь мирным)"
    r.IndexTeam = 1
    r.isNightSleep = true
    r.Targets = {}
    r.Abilities = StartAbilities(role)
  elseif (role == "Мафия") then
    r.Name = "Мафия"
    r.Description = "Ты принадлежишь клану мафии.Каждую ночь ты голосуешь вместе со своим кланом за убийство мирного игрока.Постарайся, чтобы тебя или твоего союзника не убили мирные."
    r.IndexTeam = 2
    r.isNightSleep = false
    r.Targets = {}
    r.Abilities = StartAbilities(role)
  elseif (role == "Полицейский") then
    r.Name = "Полицейский"
    r.Description = "Ты принадлежишь команде мирных.Ночью ты можешь узнать принадлежит ли выбранный игрок клану мафии или нет.Будь аккуратен,ведь у них может быть тот, кто может обмануть твою способность."
    r.IndexTeam = 1
    r.isNightSleep = false
    r.Targets = {}
    r.Abilities = StartAbilities(role)
  elseif (role == "Доктор") then
    r.Name = "Доктор"
    r.Description = "Ты принадлежишь команде мирных.Ночью ты можешь спасти игрока от смерти.Выбранный тобою игрок будет спасен от одного убийства в эту ночь.Но себя ты можешь спасти только 1 раз.Будь бдителен, ведь ты тот , кто может спасти и узнать невиновных."
    r.IndexTeam = 1
    r.isNightSleep = false
    r.Targets = {}
    r.Abilities = StartAbilities(role)
  elseif (role == "Детектив") then
    r.Name = "Детектив"
    r.Description = "Ты принадлежишь команде мирных.Ночью ты расследуешь дело о клане мафии.Твои расследования каждую ночь приносят информацию о роли , выбранного тобою , игрока.Но аккуратнее, ведь в клане мафии может быть тот, кто может помешать в расследовании."
    r.IndexTeam = 1
    r.isNightSleep = false
    r.Targets = {}
    r.Abilities = StartAbilities(role)
  elseif (role == "Серийный убийца") then
    r.Name = "Серийный убийца"
    r.Description = "Ты одинокий хладнокровный убийца...Ты убиваешь,потому что хочешь услышать чистые...крики жертв ... в тишине...Даже мафия боится тебя.Каждую ночь ты убиваешь игрока.Помни: твой главный враг - мафия,поэтому прими помощь жителей,но они тоже должны будут умереть.Ты победишь в этой игре , если всех ,кроме тебя,умрут..."
    r.IndexTeam = 2
    r.isNightSleep = false
    r.Targets = {}
    r.Abilities = StartAbilities(role)
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

function ActivateAbility(player,indexAbility)  -- Функция только для активации способности
  if (player.Role.Abilities[indexAbility].Tag == "ability_police_search") then
    PhaseActionTag = "ability_police_search"
    UiVoteBlankShow(player)
  elseif (player.Role.Abilities[indexAbility].Tag == "ability_doctor_heal") then
    PhaseActionTag = "ability_doctor_heal"
    UiVoteBlankShow(player)
  elseif (player.Role.Abilities[indexAbility].Tag == "ability_doctor_selfheal") then
    Effect_HealPlayer(player,player)
  elseif (player.Role.Abilities[indexAbility].Tag == "ability_detective_search") then
    PhaseActionTag = "ability_detective_search"
    UiVoteBlankShow(player)
  elseif (player.Role.Abilities[indexAbility].Tag == "ability_serialkiller_kill") then
    PhaseActionTag = "ability_serialkiller_kill"
    UiVoteBlankShow(player)
  elseif (player.Role.Abilities[indexAbility].Tag == "ability_politic_sabotage") then
    Effect_BlockNight(player)
  elseif (player.Role.Abilities[indexAbility].Tag == "ability_framer_sabotage") then
    PhaseActionTag = "ability_framer_sabotage"
    UiVoteBlankShow(player)
  elseif (player.Role.Abilities[indexAbility].Tag == "ability_lawyer_sabotage") then
    PhaseActionTag = "ability_lawyer_sabotage"
    UiVoteBlankShow(player)
  end
end

function TwoStepActivateAbility(target_player,owner_player,ability_tag) -- Функция активации способности, где ранее был выбор
  if (ability_tag == "ability_police_search") then
    Effect_InvestigateSide(target_player,owner_player)
    PhaseActionTag = "tag_phase_night"
  elseif (ability_tag == "ability_doctor_heal") then
    Effect_HealPlayer(target_player,owner_player)
    PhaseActionTag = "tag_phase_night"
  elseif (ability_tag == "ability_detective_search") then
    Effect_InvestigateRole(target_player,owner_player)
    PhaseActionTag = "tag_phase_night"
  elseif (ability_tag == "ability_serialkiller_kill") then
    Effect_KillPlayer(target_player,owner_player)
    PhaseActionTag = "tag_phase_night"
  elseif (ability_tag == "ability_framer_sabotage") then
    Effect_GiveRoleMask(target_player,owner_player,"Мафия")
    PhaseActionTag = "tag_phase_night"
  elseif (ability_tag == "ability_lawyer_sabotage") then
    Effect_BlockAction(target_player,owner_player)
    PhaseActionTag = "tag_phase_night"
  end
end

function AddKill(player)
  table.insert(player.Color,Town_KillList)
end

function AddDead(player)
  player.IndexStatus = 2
  table.insert(player.Name,Town_DeadList)
  Player[player.Color].team = "Spades"
  Player[player.Color].changeColor("Grey")
end

function KillToDead()
  for i=1,#Town_KillList do
    for j=1,#Town_Players do
      if (Town_KillList[i] == Town_Players[j].Color and Town_Players[j].IndexStatus == 1) then
        AddDead(Town_Players[j])
      end
    end
  end
end

function DeleteKill(player) -- подумать про удобство аргумента (после тестирования)
  for i=1,#Town_KillList do
    if (Town_KillList[i] == player.Color) then
      Town_KillList[i] = Town_KillList[#Town_KillList]
      Town_KillList[#Town_KillList] = nil
    end
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
    UiSetPlayersList()
    UiAbilitiesSettings()
    UiStart()
    broadcastToAll("Подготовка к игре завершена",{0.118, 0.53, 1})
    Notes.setNotes("")
    if (!Setting_SkipFirstDay) then
      GamePhase = 1 -- Признак начала игры (день)
      Town_CurrentPhase = 1 
      PhaseChange() -- Начало дня
    else
      GamePhase = 2 -- Признак перехода к ночным фазам
    end
  end
end

function Phase_DaySpeech()
  Town_CurrentPhase = 1
  PhaseActionTag = "tag_phase_day"
  UiSetPhase(OrderPhaseList[1])
  UiSetTime(Setting_DayTimer)
  StartTimer(Phase_DayVote,Setting_DayTimer)
end

function Phase_DayVote()
  Town_CurrentPhase = 2
  PhaseActionTag = "tag_phase_dayvote"
  UiSetPhase(OrderPhaseList[2])
  UiSetTime(Setting_VoteTimer)
  StartTimer(DayVote,Setting_VoteTimer)
end

function Phase_NightVote()
  Town_CurrentPhase = 3
  PhaseActionTag = "tag_phase_nightvote"
  UiSetPhase(OrderPhaseList[3])
  UiSetTime(Setting_VoteTimer)
  StartTimer(NightVote,Setting_VoteTimer)
end

function Phase_NightAction()
  Town_CurrentPhase = 4
  PhaseActionTag = "tag_phase_nightaction"
  UiSetPhase(OrderPhaseList[4])
  UiSetTime(Setting_NightActionTime)
  StartTimer(function()
  PhaseActionTag = "tag_phase_night"
  Night_Stop = false
  end,
  Setting_NightActionTime) 
end

function Phase_DayAction()
  Town_CurrentPhase = 5
  PhaseActionTag = "tag_phase_dayaction"
  UiSetPhase(OrderPhaseList[5])
  UiSetTime(Setting_DayActionTime)
  StartTimer(function()
  KillToDead()
  PhaseActionTag = "tag_phase_day"
  end,
  Setting_DayActionTime) 
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
    for i=1,#Town_Players do
      if (Town_Players[i].Name == finishVote[1][1]) then
        AddKill(Town_Players[i])
      end
    end
    Phase_DayAction() -- Дается 5 секунд на отмену с помощью способности. Убить игрока если действие не отменило казнь
  else
    printToAll("Равное кол-во голосов.Голосование заканчивается.Наступает ночь.",{0.856, 0.1, 0.094})
  end
  Town_PlayerVotes = {}
  GamePhase = 2 -- Разрешение на закрытие глаз
  for i=1,#Town_Players do
    UiShowElement("id-Sleep-Button-"..Town_Players[i].Color) -- Найти способ отключить закрытие глаз в игре от игроков
  end
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
  if (#Town_StartRoles < Night_Progress) then
    Night_Over = true
  end
  if (!Night_Over) then
    if (Town_StartRoles[Night_Progress] == "Мафия") then
      Night_Stop = true
      for i=1,#Town_Players do
        if (Town_Players[i].Role.IndexTeam == 2) then
          Player[Town_Players[i].Color].blindfolded = false
        end
      end
      Phase_NightVote()
      UiVoteBlankShow()
    else
      local check = false
      Night_Stop = true
      for i=1,#Town_Players do
        if (Town_Players[i].Role.Name == Town_StartRoles[Night_Progress]) then
          Player[Town_Players[i].Color].blindfolded = false
          check = true
        end
      end
      if (!check) then
        SimulatePlayer()
      end
      Phase_NightAction()
    end
    Night_Progress = Night_Progress + 1
  else
    GamePhase = 1
    -- Подведение итогов ночи (сделать позже, после тестирования)
    -- работа с UI: обновление списка игроков (сделать позже, после тестирования)
    for i = 1,#Town_Players do
      Player[Town_Players[i].Color].blindfolded = false
    end
    printToAll("Ночь №"..tostring(Town_CounterNights).." окончена",{0.192, 0.701, 0.168})
    printToAll("Итог ночи:",{0.956, 0.392, 0.113})
    KillToDead() -- Перевод списка убийств в смерти
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
    for i=1,#Town_Players do
      if (Town_Players[i].Name == finishVote[1][1]) then
        AddKill(Town_Players[i])
      end
    end
  else
    printToAll("Голосование прошло успешно!",{0.129, 0.694, 0.607})
    -- Голосование не прошло успешно. Но жителям не надо знать.
  end
  Night_Stop = false
  Town_MafiaVotes = {}
  for i=1,#Town_Players do
    if (Town_Players[i].Role.IndexTeam == 2) then
      UiShowElement("id-Sleep-Button-"..Town_Players[i].Color)
    end
  end
end


--[[
  Сделать:
  2. Разработать начальные эффекты
  3. Сделать триггеры для активации эффектов (города, игроков, взаимодействия между способностями)
  ---
  4. Тестирование

  Комментарий:
  1. В билете для голосования сделать 10 кнопок на каждый цвет, скрывать лишние кнопки по требованию
  2. В списке способностей сделать 5-6 кнопок (3 на предметы и 2-3 на способности для любой фазы)
  3. С учетом смертей, надо учитывать это в функциях проверки. Чтоб мертвецы не влияли на живых.
  4. Учитывать прирывание в таймере, когда кто то использует способность.
  5. Доработать систему тегов
  Тестирование:
  1. Night_Progression - отсортирован список для пробуждения. У "Мафия" особенное пробуждение с голосованием.
]]

--[[
  Список эффектов для стандартного пула:
  Доктор - effect_heal
  Защищенный - effect_armor

  Политик - effect_blocknight
  Подтасовщик улик - effect_mafiamask
  Адвокат - effect_blockactions
]]

-- Функции всех эффектов

function Effect_InvestigateRole(player_target,player_owner)

end

function Effect_InvestigateSide(player_target,player_owner)

end

function Effect_HealPlayer(player_target,player_owner)

end

function Effect_KillPlayer(player_target,player_owner)

end

function Effect_BlockNight(player_owner)

end

function Effect_GiveRoleMask(player_target,player_owner, mask)

end

function Effect_BlockAction(player_target,player_owner)

end
