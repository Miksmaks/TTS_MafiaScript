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
  Town_MafiaChat = {} -- каждый элемент это Владелец надписи и Надпись
  Town_PlayerVotes = {} -- Каждый элемент это Владелец голоса и Голос
  Town_MafiaVotes = {}-- Каждый элемент это Владелец голоса и Голос
  Town_KillList = {} -- По цветам (ибо могут меняться)
  Town_DeadList = {} -- По именам
  Town_Effects = {}
  GamePhase = 0
  -- Настройки
  Setting_SkipFirstNight = false
  Setting_NightTimer = 60
  Setting_DayTimer = 60
  Setting_VoteTimer = 20
  Setting_GreyTalk = false
  Setting_AdminMode = false
  F(startObj,"StartGame",self,"Начать игру",{4, 0.25, 1.7},{0.00, 0.00, 0.00},{2, 2, 2},500,300,70,{1, 1, 1},{0.25, 0.25, 0.25})
end

-- UI поддержка (доработать)
function ShowElement(id) -- Функция показа объекта
	UI.setAttribute(id,"active","true")
end
  
function HideElement(id) -- Функция сокрытия объекта
    UI.setAttribute(id,"active","false")
end

function startUI() -- Показать стартовые объекты для игры
	--[[
    for i = 1,#roles do
      ShowElement(roles[i][2].."Phase1")
      ShowElement(roles[i][2].."Phase2")
      ShowElement(roles[i][2].."Time1")
      ShowElement(roles[i][2].."Time2")
      ShowElement(roles[i][2].."Role1")
      ShowElement(roles[i][2].."Role2")
      ShowElement(roles[i][2].."tabplayers")
      ShowElement(roles[i][2].."chat")
      ShowElement(roles[i][2].."tab")
      ShowElement(roles[i][2].."time")
      ShowElement(roles[i][2].."role")
      ShowElement(roles[i][2].."move")
    end
	]]
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

-- Основной триггер
function onUpdate()  --- Триггер сна
	--[[
    if start == 1 then
      if sleep() == 1 and night1 == 0 and upd == 0 then
        upd = 1
        printToAll("Эта ночь начнется через 5 секунд...",{0.192, 0.701, 0.168})
        Logs("Запуск ночи")
        Logs("Начало ночной фазы:Действия")
        wait(night,5)
      elseif sleep() == 1 and night1 != 0 and upd == 2 then
        if MafTimer != 1 then
          Logs("Продолжается фаза ночи")
          upd = 1
          time = 0
          wait(night,2)
        end
      end
    end
	]]
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
        -- Добавить UI включение и расстановку
      end
    end
    -- Добавить UI расстановку
    broadcastToAll("Подготовка к игре завершена",{0.118, 0.53, 1})
    GamePhase = 1
    -- Запуск фазы через функцию фаз (придумать так, чтоб было универсально)
  end
end