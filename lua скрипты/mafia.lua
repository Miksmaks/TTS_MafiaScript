function table.copy(t)
    local t2 = {}
    for k,v in pairs(t) do
      t2[k] = v
    end
    return t2
  end
  

function onLoad() --- Основной архив (категорически не трогать!)
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
  --------
  
  ------------------------------------------------
  
  function ShowElement(id) -- Функция показа объекта
    UI.setAttribute(id,"active","true")
  end
  
  function HideElement(id) -- Функция сокрытия объекта
    UI.setAttribute(id,"active","false")
  end
  
  function actionChat(player,message,namef) -- Функция сокрытия и показа чата мафии
    local obL = player.color.."chat"
    if In(player.color,Mafia) == 1 then
      if UI.getAttribute(obL,"color") == "Red" then
        UI.setAttribute(obL,"color","Grey")
        UI.setAttribute(player.color.."Role1","height","100")
      else
        UI.setAttribute(obL,"color","Red")
        UI.setAttribute(player.color.."Role1","height","510")
      end
    end
  end
  
  function actionTab(player,message,namef) -- Функция сокрытия и показа списка игроков и ролей
    local obL = player.color.."tab"
    if UI.getAttribute(obL,"color") == "Green" then
      UI.setAttribute(obL,"color","Grey")
      UI.hide(player.color .. "tabplayers")
    else
      UI.setAttribute(obL,"color","Green")
      UI.setAttribute(player.color.."tabplayers","active","true")
    end
  end
  
  function actionTime(player,message,namef) -- Функция сокрытия и показа времени
    local obL = player.color.."time"
    if UI.getAttribute(obL,"color") == "Green" then
      UI.setAttribute(obL,"color","Grey")
      UI.hide(player.color.."Phase1")
      UI.hide(player.color.."Phase2")
      UI.hide(player.color.."Time1")
      UI.hide(player.color.."Time2")
    else
      UI.setAttribute(obL,"color","Green")
      ShowElement(player.color.."Phase1")
      ShowElement(player.color.."Phase2")
      ShowElement(player.color.."Time1")
      ShowElement(player.color.."Time2")
    end
  end
  
  
  function actionRole(player,message,namef) -- Функция описания роли (немного креативные истории)
    roleinfo(ColorToPlayer(player.color),player.color)
  end
  
  
  function RoleAction(role) -- Функция особых действий ролей
  
  end
  
  function ButtonSleep(player,message,namef) -- Кнопка сна
    Player[player.color].blindfolded = true
    UI.hide(player.color .. "sleep")
  end
  
  function MafiaChat(player,message,namef) -- Функция обновления чата мафии
    local text = player.color .. " : " .. UI.getAttribute(player.color.."MafChat2","text")
    MafiaText(text)
    local lines = ""
    for i = 1,#MafiaC do
      lines = lines .. MafiaC[i] .. "\n"
    end
    for i = 1,#Mafia do
      UI.setAttribute(Mafia[i] .. "MafText","text",lines)
    end
    UI.setAttribute(player.color .. "MafChat2","text","")
  end
  
  function MafiaText(text) -- Функция добавления текста в чат мафии
    local nk = 1
    while MafiaC[nk] != nil do
      nk = nk + 1
    end
    MafiaC[nk] = text
    if #MafiaC > 30 then
      local f = #MafiaC
      for i = 2,f do
        MafiaC[i-1] = MafiaC[i]
      end
      MafiaC[f] = nil
    end
  end
  
  function changetext(player,message,namef) -- Обновление вашего текста в чате мафии
    UI.setAttribute(player.color .. "MafChat2","text",message)
  end
  
  function startUI() -- Показать стартовые объекты для игры
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
  end
  
  function TimerFunction() -- Функция времени
    if time == 0 then
      for i = 1,#roles do
        UI.setAttribute(tostring(roles[i][2]).."Time2","text",tostring(time).." сек")
      end
      broadcastToAll("Время вышло.",{0.627, 0.125, 0.941})
    else
      time = time - 1
      for i = 1,#roles do
        UI.setAttribute(tostring(roles[i][2]).."Time2","text",tostring(time).." сек")
      end
      wait(TimerFunction,1)
    end
  end
  
  function PhaseToken(ops,tok)
    VoteBlank(ops)
    VoteToken = tok
  end
  
  function PhaseGame(n) -- Функция фазы игры
    if n == 1 then
      for i = 1,#roles do
        UI.setAttribute(tostring(roles[i][2]).."Phase2","text","День: Обсуждение")
        UI.setAttribute(tostring(roles[i][2]).."Phase1","color","Green")
      end
    elseif n == 2 then
      for i = 1,#roles do
        UI.setAttribute(tostring(roles[i][2]).."Phase2","text","День: Голосование")
        UI.setAttribute(tostring(roles[i][2]).."Phase1","color","Teal")
      end
    elseif n == 3 then
      for i = 1,#roles do
         UI.setAttribute(tostring(roles[i][2]).."Phase2","text","Ночь: Голосование")
         UI.setAttribute(tostring(roles[i][2]).."Phase1","color","Red")
      end
    elseif n == 4 then
      for i = 1,#roles do
        UI.setAttribute(tostring(roles[i][2]).."Phase2","text","Ночь: Действия")
        UI.setAttribute(tostring(roles[i][2]).."Phase1","color","Orange")
      end
    elseif n == 5 then
      for i = 1,#roles do
        UI.setAttribute(tostring(roles[i][2]).."Phase2","text","День: Действия")
        UI.setAttribute(tostring(roles[i][2]).."Phase1","color","Teal")
      end
    end
  end
  
  function TabAdd(i,str) -- Функция добавления строки в список игроков и ролей
    TabDeck[i+2] = tostring(str)
    local tf = ""
    for i = 1,#TabDeck do
      tf = tf .. TabDeck[i]
    end
    for i = 1,#roles do
      UI.setAttribute(roles[i][2].."tabtext","text",tf)
    end
  end
  
  function VoteBlank(ops) -- Функция показа и сокрытия кнопок для голосования и выбора цели
    if ops == 1 then
      UpdateRoles() -- Обновление списка команд
      UpdateUndead() -- Обновление "живых" игроков
      for i = 1,#roles do
        if In(roles[i][2],Dead) == 0 then
          ShowElement(roles[i][2].."tablevote")
          for j = 1,#TabColors do
            if In(TabColors[j],Undead) == 1 then
              ShowElement(roles[i][2].."vote"..tostring(j))
            end
          end
        end
      end
    elseif ops == 2 then
      for i = 1,#roles do
        UI.hide(roles[i][2].."tablevote")
        for j = 1,#TabColors do
          UI.hide(roles[i][2].."vote"..tostring(j))
        end
      end
    elseif ops == 3 then
      UpdateRoles() -- Обновление списка команд
      UpdateUndead() -- Обновление "живых" игроков
      for i = 1,#roles do
        if In(roles[i][2],Dead) == 0 and In(roles[i][2],Mafia) == 1 and roles[i][1] != "Террорист" then
          ShowElement(roles[i][2].."tablevote")
          for j = 1,#TabColors do
            if In(TabColors[j],Undead) == 1 and In(TabColors[j],Mafia) == 0 then
              ShowElement(roles[i][2].."vote"..tostring(j))
            end
          end
        end
      end
    end
  end
  
  function actionVote(player,message,namef) -- Функция работающая после голосования или выбора цели (очистка и заготовка для скрипта)
    if VoteToken == 1 then
      local fool = UI.getAttribute(namef,"color")
      for i = 1,#roles do
        if roles[i][2] == player.color and In(player.color,Dead) == 0 and In(fool,Dead) == 0 then
          Votes[i] = fool
        end
      end
      UI.hide(player.color.."tablevote")
      for j = 1,#TabColors do
        UI.hide(player.color.."vote"..tostring(j))
      end
    elseif VoteToken == 2 then
      local fool = UI.getAttribute(namef,"color")
      for i = 1,#Mafia do
        if Mafia[i] == player.color and In(player.color,Dead) == 0 and In(fool,Dead) == 0 then
          MafiaVotes[i] = fool
        end
      end
      UI.hide(player.color.."tablevote")
      for j = 1,#TabColors do
        UI.hide(player.color.."vote"..tostring(j))
      end
    elseif VoteToken == 3 then
      BlankTarget[1] = player.color
      BlankTarget[2] = UI.getAttribute(namef,"color")
      effects(NightPos)
      PhaseToken(2,0)
    elseif VoteToken == 4 then
      BlankTarget[1] = player.color
      BlankTarget[2] = UI.getAttribute(namef,"color")
      PhaseToken(2,0)
    end
  end
  ----------------Функции описания------------------------------
  function roleinfo(role,color) -- Склад моих творений, а точнее историй
    infol = "Нет инструкции."
    if role == "Мирный" then
      infol = "У тебя нет особых способностей.Просто...будь мирным)"
    elseif role == "Мафия" then
      infol = "Ты принадлежишь клану мафии.Каждую ночь ты голосуешь вместе со своим кланом за убийство мирного игрока.Постарайся, чтобы тебя или твоего союзника не убили мирные."
    elseif role == "Полицейский" then
      infol = "Ты принадлежишь команде мирных.Ночью ты можешь узнать принадлежит ли выбранный игрок клану мафии или нет.Будь аккуратен,ведь у них может быть тот, кто может обмануть твою способность."
    elseif role == "Доктор" then
      infol = "Ты принадлежишь команде мирных.Ночью ты можешь спасти игрока от смерти.Выбранный тобою игрок будет спасен от одного убийства в эту ночь.Но себя ты можешь спасти только 1 раз.Будь бдителен, ведь ты тот , кто может спасти и узнать невиновных."
    elseif role == "Детектив" then
      infol = "Ты принадлежишь команде мирных.Ночью ты расследуешь дело о клане мафии.Твои расследования каждую ночь приносят информацию о роли , выбранного тобою , игрока.Но аккуратнее, ведь в клане мафии может быть тот, кто может помешать в расследовании."
    elseif role == "Защищенный" then
      infol = "Ты принадлежишь команде мирных.Ты любишь быть в безопасности,поэтому надел свой счастливый бронежилет.Он спасет тебя от 1 выстрела.На большее он не способен.Хотя...ты веришь в удачу?"
    elseif role == "Охотник" then
      infol = "Ты принадлежишь команде мирных.Ты охотишься с детства,поэтому хорошо обращаешься с оружием.Если тебя захотят повесить (уже выбрали), то ,благодаря своей железной воли, ты сможешь сделать выстрел в одного из жителей, чтобы попасть в виновного.Будь осторожен,ты опасен для всех."
    elseif role == "Адвокат" then
      infol = "Ты принадлежишь клану мафии.Каждую ночь ты посещаешь игрока и даешь ему свои услуги.Любознательный детектив не сможет проверить этого игрока.Так можно защитить от проверки.Но помни: это очень подозрительно."
    elseif role == "Подтасовщик улик" then
      infol = "Ты принадлежишь клану мафии.Каждую ночь ты посещаешь игрока и подкидываешь ложные улики.Любой любознательный полицейский примет его , как одного из клана мафии.Таким образом можно подставить невиновного.Воспользуйся этим."
    elseif role == "Политик" then
      infol = "Ты принадлежишь клану мафии.Ты коррупционер,поэтому находишься среди мафии.В бюрократии никто не силен,поэтому никто из жителей слова не скажет.Один раз за игру ты можешь заблокировать ночные события, чтобы никто не помешал вашим планам.Такой трюк рискованный,потому что мафия тоже не сможет действовать."
    elseif role == "Серийный убийца" then
      infol = "Ты одинокий хладнокровный убийца...Ты убиваешь,потому что хочешь услышать чистые...крики жертв ... в тишине...Даже мафия боится тебя.Каждую ночь ты убиваешь игрока.Помни: твой главный враг - мафия,поэтому прими помощь жителей,но они тоже должны будут умереть.Ты победишь в этой игре , если всех ,кроме тебя,умрут..."
    end
    broadcastToColor("---\n"..infol.."\n---",color,{0.118, 0.53, 1})
  end
  
  function NightText(tl)
    if tl == 22 then
      printToAll("Просыпается "..Coloristic("Полицейский").."."..Coloristic("Полицейский").. " проверяет сторону игрока.",{0.129, 0.694, 0.607})
      Logs("Просыпается Полицейский")
    elseif tl == 49 then
      printToAll("Просыпается "..Coloristic("Доктор").."."..Coloristic("Доктор").." лечит игрока.Он может вылечить себя сам только 1 раз за игру.",{0.129, 0.694, 0.607})
      Logs("Просыпается Доктор")
    elseif tl == 21 then
      printToAll("Просыпается " .. Coloristic("Детектив") .."."..Coloristic("Детектив").. "расследует дело о банде Мафий.Он проверяет роль игрока.",{0.129, 0.694, 0.607})
      Logs("Просыпается Детектив")
    elseif tl == 13 then
      printToAll("Просыпается "..Coloristic("Подтасовщик улик").. ".Выбери игрока и подставь его.",{0.129, 0.694, 0.607})
      Logs("Просыпается Подтасовщик улик")
    elseif tl == 12 then
      printToAll("Просыпается "..Coloristic("Адвокат")..".Выбери игрока и защити от закона.",{0.129, 0.694, 0.607})
      Logs("Просыпается Адвокат")
    elseif tl == 1 then
      printToAll("Просыпается "..Coloristic("Политик")..".Он решает проводить эту ночь или нет.Отказ от ночи может быть только 1 раз.",{0.129, 0.694, 0.607})
      Logs("Просыпается Политик")
    elseif tl == 42 then
      printToAll("Просыпается "..Coloristic("Серийный убийца")..".Он выбирает себе жертву.",{0.129, 0.694, 0.607})
      Logs("Просыпается Серийный Убийца")
    end
  end
  
  function Coloristic(role)
    local text = role
    if role == "Мафия" then
      text = "[FF0000]" .. role .. "[-]"
    elseif role == "Мирный" then
      text = "[87CEEB]" .. role .. "[-]"
    elseif role == "Полицейский" then
      text = "[191970]" .. role .. "[-]"
    elseif role == "Доктор" then
      text = "[7FFFD4]" .. role .. "[-]"
    elseif role == "Охотник" then
      text = "[D2691E]" .. role .. "[-]"
    elseif role == "Защищенный" then
      text = "[FFFFFF]" .. role .. "[-]"
    elseif role == "Детектив" then
      text = "[6A5ACD]" .. role .. "[-]"
    elseif role == "Политик" then
      text = "[B22222]" .. role .. "[-]"
    elseif role == "Подтасовщик улик" then
      text = "[CD5C5C]" .. role .. "[-]"
    elseif role == "Адвокат" then
      text = "[CD5C5C]" .. role .. "[-]"
    elseif role == "Серийный убийца" then
      text = "[800000]" .. role .. "[-]"
    end
    return text
  end
  
  ------------------------------------------------
  
  function DayTime(obj,color,alt) -- Функция кнопки дневного времени (обсуждение)
    if DayT == 0 and alt == false then
      DayT = DayT + 30
    elseif DayT > 270 and alt == false then
      DayT = 30
    elseif DayT < 31 and alt == true then
      DayT = 300
    elseif alt == false then
      DayT = DayT + 30
    elseif alt == true then
      DayT = DayT - 30
    end
    startObj.editButton({index=1, label=tostring(DayT).." сек"})
  end
  
  function NightTime(obj,color,alt) -- Функция кнопки ночного времени (голосование и действия ночью)
    if NightT == 0 and alt == false then
      NightT = NightT + 5
    elseif NightT > 55 and alt == false then
      NightT = 5
    elseif NightT < 6 and alt == true then
      NightT = 60
    elseif alt == false then
      NightT = NightT + 5
    elseif alt == true then
      NightT = NightT - 5
    end
    startObj.editButton({index=2, label=tostring(NightT).." сек"})
  end
  
  function FirstDay() -- Функция кнопки первого дня (пропуск голосования в первый день)
    if FirstDaySkip == 0 then
      FirstDaySkip = 1
      startObj.editButton({index=3, label="Вкл"})
    else
      FirstDaySkip = 0
      startObj.editButton({index=3, label="Выкл"})
    end
  end
  
  function ColorToPlayer(color) -- Функция перевода цвета в роль
    for i = 1,#roles do
      if roles[i][2] == color and In(roles[i][2],Dead) == 0 then
        PlayerRoleTab = roles[i][1]
      end
    end
    return PlayerRoleTab
  end
  
  function KillToDead() -- Перевести убийства в смерти
    for i = 1,#Kill do
      local l = ColorToNumber(Kill[i])
      if In("Armor",Status[l]) == 1 then
        delElement("Armor",Status[l])
        delElement("Armor",Inventory[l])
      elseif In(Kill[i],Dead) == 0 then
        addDead(Kill[i])
      end
    end
  end
  
  function addDead(color) -- Добавить имя мертвого
    local i = 1
    local role = ""
    while Dead[i] != nil do
      i = i + 1
    end
    for i = 1,#roles do
      if roles[i][2] == color then
        role = roles[i][1]
        TabAdd(i,tostring(color).." - "..tostring(roles[i][1]).."\n")
      end
    end
    Dead[i] = color
    Player[color].team = "Spades"
    Player[color].changeColor("Grey")
    Logs("Убит: "..color.." - ".. role)
    printToAll("Убит: "..color.." - ".. role,{0.956, 0.392, 0.113})
    UpdateRoles()
    UpdateUndead()
  end
  
  function clearB()  -- Очистить кнопки голосования
    for i = 1,#TabColors do
      if ParColors[i].getButtons() != nil then
          ParColors[i].removeButton(0)
      end
    end
  end
  
  function UpdateUndead()  --- Функция обновления живых игроков
    Undead = {}
    for i = 1,#roles do
      if In(roles[i][2],Dead) == 0 then
        Undead[i] = roles[i][2]
      end
    end
  end
  -----------------Зона логов----
  
  function onChat(message,Player) -- Функция связанная с чатом, а точнее команды
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
  end
  
  function Logs(a) -- Функция записи логов
    local i = 1
    while Log[i] != nil do
      i = i + 1
    end
    Log[i] = a
  end
  
  --------------Зона логов
  function UpdateRoles()  --- Функция обновления мафий и мирных
    Village = {}
    Mafia = {}
    for i = 1,#roles do
      if In(roles[i][1],TVillage) == 1 and In(roles[i][2],Dead) == 0  then
        addElement(roles[i][2],Village)
      end
    end
    for i = 1,#roles do
      if In(roles[i][1],TMafia) == 1 and In(roles[i][2],Dead) == 0 then
        addElement(roles[i][2],Mafia)
      end
    end
  end
  
  
  
  ----
  
  
  function addKill(color) -- Добавить имя в убийство с приоритетом
    addElement(color,Kill)
  end
  
  function ColorToNumber(a)   --- Найти цвет в массиве и выдать его номер
    for i = 1,#TabColors do
      if TabColors[i] == a then
        return i
      end
    end
  end
  
  function team(name)   --- Распределение команд
    if In(name,TMafia) == 1 then
      return 1
    elseif In(name,TVillage) == 1 then
      return 0
    elseif In(name,TOther) == 1 then
      return 2
    else
      broadcastToAll("Ошибка:Нескриптованная зона игры",{0.856, 0.1, 0.094})
      return 3
    end
  end
  
  function MafiaHint()   ---Стартовая подсказка для мафий
    local mas = {}
    local g = 1
    for i = 1,#roles do
      if roles[i][3] == 1 then
        mas[g] = roles[i]
        g = g + 1
      end
    end
    for i = 1,#mas do
      printToColor("Список твоей команды:",mas[i][2], {0.956, 0.392, 0.113})
      for j = 1,#mas do
          printToColor(Coloristic(mas[j][2]),mas[i][2],{0.956, 0.392, 0.113})
      end
    end
  end
  
  function TimerMain(F,ti,fase) -- Основной таймер
    time = ti
    TimerFunction() -- Запуск таймера
    PhaseGame(fase)
    wait(F,ti+1)
  end
  
  function ScanHand()   --- Сканирование рук
    local numberRole = 0
    TabDeck[2] = "Список игроков:\n"
    handR = 3
    NumPlayers = #Player.getPlayers()-#Player.getSpectators()
    for k,l in ipairs(TabColors) do
      if Player[l].seated == true then
        Tokens[k].setColorTint({0.192, 0.701, 0.168}) -- Отметка живого игрока
        numberRole = numberRole + 1
        if #Player[l].getHandObjects() == 1 then
          if In(Player[l].getHandObjects()[1].getName(),Sroles) == 1 then
            roles[numberRole] = {Player[l].getHandObjects()[1].getName(),l,team(Player[l].getHandObjects()[1].getName())} -- Занесение в базу данных
            giveEffect(Player[l].getHandObjects()[1].getName(),l)
            UI.setAttribute(tostring(roles[numberRole][2]).."Role2","text","Роль: ".. roles[numberRole][1]) -- Раздача ролей на экране
            UI.setAttribute(tostring(roles[numberRole][2]).."Role2","alignment","MiddleLeft")
            TabDeck[handR] = tostring(roles[numberRole][2]) .. " - Неизвестно\n"
            handR = handR + 1
            Player[l].getHandObjects()[1].destruct()
            Logs("Игрок "..roles[numberRole][2].." получил роль "..roles[numberRole][1].." и в команде ".. roles[numberRole][3])
          end
        else
          broadcastToAll("Ошибка:Лишние карты в руке",{0.856, 0.1, 0.094})
        end
      else
        Tokens[k].setColorTint({0.25, 0.25, 0.25})
      end
    end
    if NumPlayers == #roles then -- Запуск игры
      local textPanel = ""
      for i = 1,#TabDeck do
        textPanel = textPanel .. TabDeck[i]
      end
      for i = 1,#roles do
        UI.setAttribute(tostring(roles[i][2]).."tabtext","text",textPanel)
      end
      UpdateRoles() -- Обновление списка команд
      UpdateUndead() -- Обновление "живых" игроков
      MafiaHint() -- Подсказка мафии
      broadcastToAll("Подготовка к игре завершена",{0.118, 0.53, 1})
      start = 1
      startUI()
      TimerMain(Day,DayT,1) -- Запуск таймер до голосования
      broadcastToAll("День начинается!",{0.118, 0.53, 1})
      Logs("Начало дня: Обсуждение")
    end
  end
  
  function wait(F,i)   -- Ожидание
    Wait.frames(F, i*60)
  end
  
  function In(Obj,M) -- Содержится ли объект в массиве?
    local k = 0
    for i = 1,#M do
      if M[i] == Obj then
        k = 1
      end
    end
    for i = 1,50 do
      if M[i] != nil then
        if M[i] == Obj then
          k = 1
        end
      end
    end
    return k
  end
  
  function ScanDeck(Obj)  --- Сканирование колоды и занесение в список
    local textCounter = 0
    text = "Состав колоды:\n"
    for k,l in ipairs(Obj.getObjects()) do
      if In(l.name,Sroles) == 0 then
         textCounter = textCounter + 1
         text = text .. "***\n"
      else
         text = text .. l.name .. "\n"
      end
    end
    TabDeck[1] = text
    if textCounter > 0 then
      broadcastToAll("Ошибка:Есть " .. textCounter .. " незарегистрированных ролей.",{0.856, 0.1, 0.094})
    end
  end
  
  function Start()   --- Старт игры/подготовка
    for s1,player in ipairs(Player.getPlayers()) do -- Убрать команды
      player.team = "None"
    end
    ZoneDeck = getObjectFromGUID("8f28b3")
    Deck = nil
    NumPlayers = #Player.getPlayers()-#Player.getSpectators()
    for k,l in ipairs(ZoneDeck.getObjects()) do
      if #l.getObjects() == NumPlayers then
        Deck = l
      end
    end
    if NumPlayers < 3 then -- Проверка на кол-во игроков
      broadcastToAll("Ошибка:Мало игроков",{0.856, 0.1, 0.094})
    elseif DayT == 0 or NightT == 0 then
      broadcastToAll("Ошибка:Нет настроек",{0.856, 0.1, 0.094})
    elseif Deck != nil then
      if #Deck.getObjects() == NumPlayers then -- Проверка на совпадение ролей и игроков
        ScanDeck(Deck)
        Deck.shuffle()
        Deck.shuffle()
        Deck.deal(1)
        wait(ScanHand,2)
        startObj.destruct()
        Notes.setNotes("")
      else
        broadcastToAll("Ошибка:Кол-во ролей не совпадает с кол-вом игроков",{0.856, 0.1, 0.094})
      end
    else
      broadcastToAll("Ошибка:Кол-во ролей не совпадает с кол-вом игроков",{0.856, 0.1, 0.094})
    end
  end
  -------------------------------------------------
  function night()   --- Ночная функция
    local Ms = 0
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    if sleep() == 1 then -- Проверка сна
      local f = 0 -- Существование роли на ночь
      night1 = night1 + 1
      if night1 < 51 then -- Фазы ролей
        for i = 1,#roles do
          if BlockNight != 1 then -- Блокировка ночи
            if Sroles[night1] == roles[i][1] and In(roles[i][2],Dead) == 0 and night1 != 15 then
              f = 1
              UpdateRoles() -- Обновление списка команд
              UpdateUndead() -- Обновление "живых" игроков
              NightPos = night1
              NightText(night1)
              ShowElement(roles[i][2].."tablevote")
              for j = 1,#TabColors do
                if In(TabColors[j],Undead) == 1 and Sroles[night1] != "Политик" then
                  ShowElement(roles[i][2].."vote"..tostring(j))
                elseif In(TabColors[j],Undead) == 1 and Sroles[night1] == "Политик" and TabColors[j] == roles[i][2] then
                  ShowElement(roles[i][2].."vote"..tostring(j))
                end
              end
              PhaseGame(4)
              VoteToken = 3
              time = NightT
              TimerFunction()
              Player[roles[i][2]].blindfolded = false
              ShowElement(roles[i][2].."sleep")
              upd = 2
            elseif night1 == 15 and Ms == 0 then -- Фаза голосования мафии
              UpdateRoles() -- Обновление списка команд
              UpdateUndead() -- Обновление "живых" игроков
              f = 1
              for j = 1,#roles do
                if roles[j][3] == 1 then
                  Player[roles[j][2]].blindfolded = false
                  ShowElement(roles[j][2].."sleep")
                end
              end
              upd = 2
              Logs("Обсуждение мафии:Голосование")
              effect15()
              Ms = 1
              TimerMain(MafiaVote,NightT,3)
              MafTimer = 1
              printToAll("Просыпается Мафия.Мафия голосует за убийство игрока.",{0.129, 0.694, 0.607})
            end
          end
        end
      elseif night1 > 50 then -- Итог ночи
        UpdateRoles() -- Обновление списка команд
        UpdateUndead() -- Обновление "живых" игроков
        if BlockNight == 1 then
          BlockNight = 2
        end
        f = 1
        night1 = 0
        for i = 1,#roles do
          Player[roles[i][2]].blindfolded = false
          UI.hide(roles[i][2].."sleep")
        end
        NUMnight = NUMnight + 1
        MafTimer = 0
        Logs("Ночь №"..tostring(NUMnight).." окончена")
        Logs("Итог этой ночи:")
        printToAll("Ночь №"..tostring(NUMnight).." окончена",{0.192, 0.701, 0.168})
        upd = 0
        printToAll("Итог ночи:",{0.956, 0.392, 0.113})
        KillToDead()
        Kill = {}
        Votes = {}
        MafiaVotes = {}
        Maska = {}
        UpdateRoles() -- Обновление списка команд
        UpdateUndead() -- Обновление "живых" игроков
        if #Mafia > #Village then
          broadcastToAll("Внимание: кол-во игроков команды мафии больше игроков команды мирных!",{0.118, 0.53, 1})
        end
        TimerMain(Day,DayT,1)
        Logs("Начало дня: Обсуждение")
        broadcastToAll("День начинается!",{0.118, 0.53, 1})
      end
      if f == 0 then -- Пропуск "пустой" роли
        night()
      end
    else -- Отмена ночи.Это нужно для тех кто любит ломать скрипты.
      broadcastToAll("Ночь отменена!",{0.856, 0.1, 0.094})
      Logs("Игроки отменили фазу ночи:")
      printToAll("Ночь отменена игроками:",{0.856, 0.1, 0.094})
      for i = 1,#roles do
        if Player[roles[i][2]].blindfolded == true then
          Player[roles[i][2]].blindfolded = false
        else
          Logs(tostring(roles[i][2]))
          printToAll(tostring(roles[i][2]),{0.856, 0.1, 0.094})
        end
      end
      night1 = 0
      upd = 0
    end
  end
  
  function sleep()  --- Проверка сна
    pr = 1
    for i = 1,#roles do
      if Player[roles[i][2]] != nil then
        if Player[roles[i][2]].blindfolded == false and In(roles[i][2],Dead) == 0 then
          pr = 0
        end
      end
    end
    return pr
  end
  
  function onUpdate()  --- Триггер сна
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
  end
  
  ---
  function giveEffect(role,i)
    local P = ColorToNumber(i)
    if role == "Доктор" then
      addElement("DoctorOneHeal",Status[P])
    elseif role == "Защищенный" then
      addElement("Armor",Status[P])
      addElement("Armor",Inventory[P])
    end
  end
  
  function addElement(obj,Mas)
    local l = 0
    local n = 0
    if #Mas == 0 then
      n = 1
    else
      n = #Mas
    end
    for i= 1,n do
      if Mas[i] == nil and l == 0 then
        l = i
      end
    end
    if l == 0 then
      l = n + 1
    end
    Mas[l] = obj
  end
  
  function delElement(obj,Mas)
    local l = 0
    local n = 0
    if #Mas == 0 then
      n = 1
    else
      n = #Mas
    end
    for i= 1,n do
      if Mas[i] == obj and l == 0 then
        l = i
      end
    end
    if l != 0 then
      Mas[l] = nil
    end
  end
  ---
  
  function effects(k)  -- Функция эффектов
    if k == 15 then
      effect15()
    elseif k == 22 then
      effect22()
    elseif k == 49 then
      effect49()
    elseif k == 21 then
      effect21()
    elseif k == 13 then
      effect13()
    elseif k == 12 then
      effect12()
    elseif k == 1 then
      effect1()
    elseif k == 42 then
      effect42()
    end
  end
  ---------------День---------------------
  function Day() -- Дневная функция
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    if FirstDaySkip == 1 and NUMnight == 0 then -- Доп.настройка
      for i = 1,#roles do
        if In(roles[i][2],Dead) == 0 then
          ShowElement(roles[i][2].."sleep")
        end
      end
      Logs("Жители города слишком ленивы, чтобы проводить голосование в первый день.Наступает ночь.")
      printToAll("Жители города слишком ленивы, чтобы проводить голосование в первый день.Наступает ночь.",{0.856, 0.1, 0.094})
    else
      Logs("Дневное повешевание:Голосование")
      broadcastToAll("Начинается голосование за убийство мафии",{0.118, 0.53, 1})
      PhaseToken(1,1) -- Запуск кнопок голосования
      TimerMain(TownVote,NightT,2) -- Время на голосование
    end
  end
  
  function TownVote() --- Функция голосования
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    PhaseToken(2,0)
    local golos = 0 -- кандидат
    local golosm = 0 -- жертва
    local Z = 0 -- проверка на сброс голосования
    local V = "" -- Выбранная цель
    local a = "" -- текст
    for i = 1,#roles do
      for j = 1,10 do
        if roles[i][2] == Votes[j] and Votes[j] != nil then
          golos = golos + 1
          a = a .. roles[j][2] .." "
        end
      end
      Logs("За игрока "..roles[i][2].." было дано ".. golos .." голосов.")
      Logs("Голосовали: ".. a)
      if golos > 0 then
        printToAll("За игрока "..roles[i][2].." проголосовали: ".. a,{0.627, 0.125, 0.941})
      end
      a = ""
      if golos > golosm then
        golosm = golos
        Z = 0
        V = roles[i][2]
      elseif golos == golosm then
        Z = 1
      end
      golos = 0
    end
    if Z == 0 then -- Успешное голосование
      UpdateRoles() -- Обновление списка команд
      UpdateUndead() -- Обновление "живых" игроков
      printToAll("Голосование прошло успешно!",{0.129, 0.694, 0.607})
      Logs("Город выбрал на казнь : ".. V)
      AfterVoteRoles(V)
      if #Mafia == 0 then
        broadcastToAll("Победа мирных: вся команда мафии умерла.",{0.118, 0.53, 1})
      end
    else -- Неудачное голосование
      UpdateRoles()
      UpdateUndead()
      for i = 1,#roles do
        if In(roles[i][2],Dead) == 0 then
          ShowElement(roles[i][2].."sleep")
        end
      end
      Logs("Город не пришел к единому мнению.Голосование окончено.")
      printToAll("Равное кол-во голосов.Голосование заканчивается.Наступает ночь.",{0.856, 0.1, 0.094})
    end
  end
  
  ----------Эффекты------------------
  
  function MafiaVote() -- Функция голосования
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    PhaseToken(2,0)
    local golos = 0 -- кандидат
    local golosm = 0 -- жертва
    local Z = 0 -- проверка на сброс голосования
    local V = "" -- Выбранная цель
    local a = "" -- текст
    for i = 1,#roles do
      for j = 1,10 do
        if roles[i][2] == MafiaVotes[j] and MafiaVotes[j] != nil then
          golos = golos + 1
          a = a .. roles[j][2] .." "
        end
      end
      Logs("За игрока "..roles[i][2].." было дано ".. golos .." голосов.")
      Logs("Голосовали: ".. a)
      a = ""
      if golos > golosm then
        golosm = golos
        Z = 0
        V = roles[i][2]
      elseif golos == golosm then
        Z = 1
      end
      golos = 0
    end
    MafTimer = 2
    if Z == 0 then -- Успешное голосование
      UpdateRoles() -- Обновление списка команд
      UpdateUndead() -- Обновление "живых" игроков
      Logs("Мафия выбрала жертву "..tostring(V))
      addKill(V)
      printToAll("Голосование прошло успешно!",{0.129, 0.694, 0.607})
      MafiaVotes = {}
      UpdateRoles() -- Обновление списка команд
      UpdateUndead() -- Обновление "живых" игроков
    else -- Повтор голосования
      UpdateRoles() -- Обновление списка команд
      UpdateUndead() -- Обновление "живых" игроков
      Logs("Мафия не определилась с выбором.Голосование не проходит.")
      printToAll("Голосование прошло успешно!",{0.129, 0.694, 0.607})
      MafiaVotes = {}
    end
  end
  
  
  function AfterVoteRoles(color)
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    if ColorToPlayer(color) == "Охотник" then
      Logs("Охотник выбирает цель")
      BlankTarget = {"",""}
      VoteToken = 4
      ShowElement(color.."tablevote")
      for j = 1,#TabColors do
        if In(TabColors[j],Undead) == 1 then
          ShowElement(color.."vote"..tostring(j))
        end
      end
      TimerMain(Hunter,NightT,5)
    else
      addDead(color)
      printToAll("Жители казнили: ".. color .." - "..ColorToPlayer(color),{0.192, 0.701, 0.168})
      Votes = {}
      for i = 1,#roles do
        if In(roles[i][2],Dead) == 0 then
          ShowElement(roles[i][2].."sleep")
        end
      end
      --
    end
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
  end
  
  
  function effect15() --Эффект 15 (Голосование мафии)
    VoteBlank(3)
    VoteToken = 2
  end
  
  function effect22()  -- Эффект 22 (Полицейский)
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    local team = -1
    local number = ColorToNumber(BlankTarget[2])
    if In(ColorToPlayer(BlankTarget[2]),TMafia) == 1 then
      team = 1
    else
      team = 0
    end
    if In("Proof",Status[number]) == 0 then
      if team == 1 then
        printToColor("#Принадлежит клану мафия#",BlankTarget[1], {0.129, 0.694, 0.607})
        Logs("Полицейский "..tostring(BlankTarget[1]).." посетил игрока "..tostring(BlankTarget[2]).." и узнал , что он мафия")
      else
        printToColor("#Не принадлежит клану мафия#",BlankTarget[1], {0.129, 0.694, 0.607})
        Logs("Полицейский "..tostring(BlankTarget[1]).." посетил игрока "..tostring(BlankTarget[2]).." и узнал , что он не мафия")
      end
    else
      delElement("Proof",Status[number])
      printToColor("#Принадлежит клану мафия#",BlankTarget[1], {0.129, 0.694, 0.607})
      Logs("Полицейский "..tostring(BlankTarget[1]).." посетил игрока "..tostring(BlankTarget[2]).." и узнал , что он мафия "..",но улики подтасованы.")
    end
    printToAll("Полицейский посетил игрока.", {0.129, 0.694, 0.607})
    BlankTarget = {"",""}
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
  end
  
  function effect49() -- Эффект  49 (Доктор)
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    local number = ColorToNumber(BlankTarget[2])
    if BlankTarget[1] == BlankTarget[2] and In("DoctorOneHeal",Status[number]) == 1 then
      while In(BlankTarget[2],Kill) == 1 do
        delElement(BlankTarget[2],Kill)
      end
      delElement("DoctorOneHeal",Status[number])
      Logs("Доктор "..tostring(BlankTarget[1]).." вылечил себя.Больше не может сделать это.")
      printToAll("Доктор посетил игрока.", {0.129, 0.694, 0.607})
    elseif BlankTarget[1] == BlankTarget[2] and In("DoctorOneHeal",Status[number]) == 0 then
      printToColor("Доктор,ты не можешь этого сделать уже.",BlankTarget[1],{0.129, 0.694, 0.607})
      printToAll("Доктор посетил игрока.", {0.129, 0.694, 0.607})
    else
      while In(BlankTarget[2],Kill) == 1 do
        delElement(BlankTarget[2],Kill)
      end
      Logs("Доктор "..tostring(BlankTarget[1]).." посетил игрока "..tostring(BlankTarget[2]))
      printToAll("Доктор посетил игрока.", {0.129, 0.694, 0.607})
    end
    BlankTarget = {"",""}
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
  end
  
  function effect42() -- эффект 42 (Серийный убийца)
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    PhaseToken(2,0)
    addKill(BlankTarget[2])
    BlankTarget = {"",""}
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
  end
  
  function effect53(obj, color, alt_click) -- Эффект 53 (Охотник)
    for i = 1,#roles do
        if color == roles[i][2] and roles[i][1] == "Охотник" then
          for j = 1,#ParColors do
            if ParColors[j] == obj then
              for h = 1,#roles do
                if roles[h][2] == VColors[j] then
                  addKill(roles[h][2],0)
                  KillToDead()
                  if In(roles[h][2],Dead) == 1 then
                    for l = 1,#roles do
                      if roles[h][2] == roles[l][2] then
                        for l1 = 1,#VColors do
                          if roles[l][2] == VColors[l1] then
                            ParColors[l1].setColorTint({0.856, 0.1, 0.094})
                            ParColors[l1].setName(roles[l][1])
                          end
                        end
                        Logs("Охотник застрелил: "..tostring(roles[l][2]).." - "..tostring(roles[l][1]))
                        printToAll("Охотник застрелил: "..tostring(roles[l][2]).." - "..tostring(roles[l][1]),{0.192, 0.701, 0.168})
                      end
                    end
                    printToAll("Охотник пристрелил жителя города на глазах у всех.", {0.129, 0.694, 0.607})
                  else
                    Logs("Охотник попытался убить: ".. roles[h][2])
                    printToAll("Пуля попала в жителя, но...он живой...", {0.129, 0.694, 0.607})
                  end
                  clearB()
                end
              end
            end
          end
        end
    end
  end
  
  function effect21() -- Эффект 21 (Детектив)
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    local team = ColorToPlayer(BlankTarget[2])
    local number = ColorToNumber(BlankTarget[2])
    if In("Block",Status[number]) == 0 then
      printToColor("Этот человек: " .. team,BlankTarget[1], {0.129, 0.694, 0.607})
      Logs("Детектив "..tostring(BlankTarget[1]).." посетил игрока "..tostring(BlankTarget[2]).." и узнал , что он "..team)
      printToAll("Детектив опросил игрока.", {0.129, 0.694, 0.607})
    else
      delElement("Block",Status[number])
      printToColor("Проверка недопустима.",BlankTarget[1], {0.129, 0.694, 0.607})
      Logs("Детектив "..tostring(BlankTarget[1]).." не смог посетить игрока.")
      printToAll("Детектив опросил игрока.", {0.129, 0.694, 0.607})
    end
    BlankTarget = {"",""}
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
  end
  
  function Hunter()
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    PhaseToken(2,0)
    addKill(BlankTarget[2])
    KillToDead()
    addDead(BlankTarget[1])
    printToAll("Жители казнили: ".. BlankTarget[1] .." - "..ColorToPlayer(BlankTarget[1]),{0.192, 0.701, 0.168})
    Votes = {}
    for i = 1,#roles do
      if In(roles[i][2],Dead) == 0 then
        ShowElement(roles[i][2].."sleep")
      end
    end
    BlankTarget = {"",""}
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
  end
  
  function effect13() -- Эффект 13 (Подтасовщик улик)
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    PhaseToken(2,0)
    addElement("Proof",Status[ColorToNumber(BlankTarget[2])])
    BlankTarget = {"",""}
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
  end
  
  function effect12() -- Эффект 12 (Адвокат)
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    PhaseToken(2,0)
    addElement("Block",Status[ColorToNumber(BlankTarget[2])])
    BlankTarget = {"",""}
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
  end
  
  function effect1() -- Эффект 1 (Политик)
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
    PhaseToken(2,0)
    if BlankTarget[1] == BlankTarget[2] then
      if BlockNight == 0 then
        BlockNight = 1
      end
    end
    BlankTarget = {"",""}
    UpdateRoles() -- Обновление списка команд
    UpdateUndead() -- Обновление "живых" игроков
  end
  