# Работа с данными игрока

## Что изменено

Добавлен единый слой для изменения параметров игрока:

- `SetPlayerParam` — целочисленные параметры;
- `SetPlayerParamFloat` — параметры с плавающей точкой;
- после изменения значение сразу записывается в `player_info`;
- затем выполняется асинхронный `UPDATE` таблицы `accounts`;
- для уровня дополнительно обновляется scoreboard;
- для здоровья и брони дополнительно обновляется значение у игрока в игре.

Основная реализация находится в [library/a_stocks.inc](library/a_stocks.inc), идентификаторы параметров — в [library/a_define.inc](library/a_define.inc).

## Использование

Для целочисленного параметра:

```pawn
SetPlayerParam(playerid, PLAYER_PARAM_MONEY, 5000);
SetPlayerParam(playerid, PLAYER_PARAM_LEVEL, 5);
SetPlayerParam(playerid, PLAYER_PARAM_EXP, 10);
SetPlayerParam(playerid, PLAYER_PARAM_EAT, 100);
SetPlayerParam(playerid, PLAYER_PARAM_THIRST, 100);
```

Для здоровья и брони:

```pawn
SetPlayerParamFloat(playerid, PLAYER_PARAM_HEALTH, 100.0);
SetPlayerParamFloat(playerid, PLAYER_PARAM_ARMOR, 50.0);
```

`playerid` — ID подключённого игрока. Функции возвращают:

- `1` — параметр принят и запрос поставлен в очередь;
- `0` — игрок не подключён, аккаунт ещё не загружен или указан неизвестный параметр.

Пример проверки:

```pawn
if(!SetPlayerParam(playerid, PLAYER_PARAM_MONEY, 5000))
{
    return 0;
}
return 1;
```

## Доступные параметры

| Константа | Поле в `accounts` | Тип |
|---|---|---|
| `PLAYER_PARAM_MONEY` | `money` | integer |
| `PLAYER_PARAM_LEVEL` | `lvl` | integer |
| `PLAYER_PARAM_EXP` | `exp` | integer |
| `PLAYER_PARAM_AGE` | `age` | integer |
| `PLAYER_PARAM_EAT` | `eat` | integer |
| `PLAYER_PARAM_THIRST` | `thirst` | integer |
| `PLAYER_PARAM_MEMBER` | `member` | integer |
| `PLAYER_PARAM_RANG` | `rang` | integer |
| `PLAYER_PARAM_FSKIN` | `fskin` | integer |
| `PLAYER_PARAM_MUTETIME` | `mutetime` | integer |
| `PLAYER_PARAM_HEALTH` | `health` | float |
| `PLAYER_PARAM_ARMOR` | `armor` | float |

Не передавай в функцию имя SQL-поля строкой. Используй только перечисленные константы: так нельзя случайно обновить произвольное поле базы.

## Уже переведённые команды

На новую систему переведены команды из [library/a_admincmd.inc](library/a_admincmd.inc):

- `/sethp`;
- `/setarm`;
- `/seteat`;
- `/setwater`;
- `/mute`;
- `/unmute`;
- `/set_lvl`.

## Полное сохранение игрока

Для сохранения всех поддерживаемых полей enum `player_info[playerid]` используй:

```pawn
SavePlayerAccount(playerid);
```

Функция сохраняет одним запросом основные данные аккаунта: здоровье, броню, уровень, опыт, возраст, голод, жажду, деньги, организацию, ранг, позицию, виртуальный мир, интерьер, больницу, мут и лицензии.

Используй её после операции, которая меняет сразу несколько полей:

```pawn
player_info[playerid][member] = 1;
player_info[playerid][rang] = 1;
player_info[playerid][fskin] = 187;
SavePlayerAccount(playerid);
```

Для одного поля предпочтительнее `SetPlayerParam` или `SetPlayerParamFloat`: они сразу меняют enum и сохраняют только нужное поле. `SavePlayerAccount` также вызывается при выходе игрока.

`SavePlayerAccount` отправляет запрос через `mysql_tquery`, поэтому игровой поток не блокируется синхронным `mysql_query`.

## Важные правила

1. Не вызывай `SetPlayerParam` до завершения загрузки аккаунта: проверка `player_info[playerid][id] > 0` защищает от записи в несуществующий аккаунт.
2. Не нужно сразу после вызова вручную писать такой же `UPDATE accounts`: функция уже ставит запрос в очередь.
3. Для `health` и `armor` используй `SetPlayerParamFloat`, а не целочисленную функцию.
4. Для нескольких изменений можно вызвать функцию несколько раз, но для массового изменения лучше сделать одну отдельную функцию сохранения.
5. Асинхронный запрос не означает, что результат уже записан в базу в следующей строке кода. Если нужен код после завершения SQL, используй callback `mysql_tquery`.

## Кодировка

Исходники Pawn (`.pwn` и `.inc`) хранятся в CP1251. В корне проекта есть `.gitattributes`:

```gitattributes
*.pwn text working-tree-encoding=CP1251
*.inc text working-tree-encoding=CP1251
```

В VS Code открывай Pawn-файлы через **Reopen with Encoding → Windows 1251**. Не сохраняй их как UTF-8: старый Pawn Compiler может аварийно завершиться или превратить русский текст в `�`.

Markdown-документация может оставаться в UTF-8 — это отдельный формат и на Pawn Compiler не влияет.

## Сборка

Сборка выполняется задачей VS Code `build-normal`. Она компилирует:

```text
gamemodes/new.pwn
```

Успешная сборка должна завершаться без ошибок компилятора. Предупреждения от сторонних include-файлов нужно рассматривать отдельно от ошибок.
