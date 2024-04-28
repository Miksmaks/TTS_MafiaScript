function table.copy(t)
	local t2 = {}
    for k,v in pairs(t) do
      t2[k] = v
    end
    return t2
end

function onLoad() -- Основной архив (категорически не трогать!)
	--[[
    Village = {}
    roles = {}
    hands = {}
    Sroles = {"Политик","Пассажир","Пьяница","Проститутка","Тюремщик","Водитель","Шофер","Ведьма","Телохранитель","Вышибала","Мастер-на-все-руки","Адвокат","Подтасовщик улик","Портной","Мафия","Крот","Лидер культа","Поджигатель","Оборотень","Забывчивый","Детектив","Полицейский","Заместитель","Шпион","Санта Клаус","Эльф","Кузнец","Пекарь","Репортер","Оружейник","Вор","Сосед","Священник","Букмекер","Уборщик","Следователь","Отравитель","Химик","Саботер","Террорист","Мститель","Серийный убийца","Выживающий","Пират","Сообщник","Смотритель","Выслеживатель","Новичок","Доктор","Медсестра","Тест","Мирный","Охотник","Защищенный"}
    TabColors = {"White","Brown","Red","Orange","Yellow","Green","Teal","Blue","Purple","Pink"}
    Tokens = {getObjectFromGUID("421454"),getObjectFromGUID("26ee7d"),getObjectFromGUID("d28074"),getObjectFromGUID("09189f"),getObjectFromGUID("24d90d"),getObjectFromGUID("b7fa1a"),getObjectFromGUID("18f082"),getObjectFromGUID("fe41f0"),getObjectFromGUID("115d5d"),getObjectFromGUID("73a13c")}
    Colors = {}
    startObj = getObjectFromGUID("2b55dc")
    F(startObj,"Start",self,"Старт",{0, 0.25, 0},{0.00, 0.00, 0.00},{5, 5, 5},500,300,70,{1, 1, 1},{0.25, 0.25, 0.25})
    TMafia = {"Мафия","Политик","Проститутка","Шофер","Вышибала","Адвокат","Подтасовщик улик","Портной","Шпион","Вор","Букмекер","Уборщик","Отравитель","Химик","Саботер","Террорист","Новичок"}
    TVillage = {"Мирный","Полицейский","Доктор","Защищенный","Охотник","Пассажир","Пьяница","Тюремщик","Водитель","Телохранитель","Мастер-на-все-руки","Детектив","Заместитель","Кузнец","Пекарь","Репортер","Оружейник","Сосед","Священник","Следователь","Медсестра","Мститель","Сообщник","Смотритель","Выслеживатель","Эльф"}
    TOther = {"Серийный убийца","Ведьма","Крот","Лидер культа","Поджигатель","Оборотень","Забывчивый","Санта Клаус","Выживающий","Пират"}
    night1 = 0
    NUMnight = 0
    start = 0
    upd = 0
    MafiaVotes = {}
    Votes = {}
    Undead = {}
    Mafia = {}
    Status = {{},{},{},{},{},{},{},{},{},{}}
    Inventory = {{},{},{},{},{},{},{},{},{},{}}
    F(startObj,"DayTime",self,"Время дня",{4, 0.25, -1.7},{0.00, 0.00, 0.00},{2, 2, 2},500,300,70,{1, 1, 1},{0.25, 0.25, 0.25})
    F(startObj,"NightTime",self,"Время ночи",{4, 0.25, 0},{0.00, 0.00, 0.00},{2, 2, 2},500,300,70,{1, 1, 1},{0.25, 0.25, 0.25})
    F(startObj,"FirstDay",self,"FirstDaySkip",{4, 0.25, 1.7},{0.00, 0.00, 0.00},{2, 2, 2},500,300,70,{1, 1, 1},{0.25, 0.25, 0.25})
    DayT = 0
    NightT = 0
    FirstDaySkip = 0
    docheal = 0
    Kill = {}
    Dead = {}
    Log = {}
    admin = 0
    greytalk = 0
    armorZ = 1
    BlockNight = 0
    Maska = {}
    MafiaC = {}
    time = 0
    TabDeck = {}
    VoteToken = 0
    BlankTarget = {"@","@"}
    NightPos = 0
    MafTimer = 0
	]]
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