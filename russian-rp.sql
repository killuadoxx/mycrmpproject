-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1
-- Время создания: Июн 27 2024 г., 02:46
-- Версия сервера: 10.4.32-MariaDB
-- Версия PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `new`
--

-- --------------------------------------------------------

--
-- Структура таблицы `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `name` varchar(24) NOT NULL,
  `password` varchar(64) NOT NULL,
  `salt` varchar(10) NOT NULL,
  `email` varchar(64) NOT NULL,
  `regdata` varchar(13) NOT NULL,
  `logindata` varchar(13) NOT NULL,
  `regip` varchar(16) NOT NULL,
  `ref` int(11) NOT NULL,
  `sex` int(11) NOT NULL,
  `age` int(11) NOT NULL,
  `skin` int(11) NOT NULL,
  `lvl` int(11) NOT NULL DEFAULT 1,
  `exp` int(11) NOT NULL,
  `money` int(15) NOT NULL DEFAULT 100,
  `lic` varchar(16) NOT NULL DEFAULT '0,0,0,0,0,0',
  `quest` varchar(16) NOT NULL DEFAULT '0,0,0,0',
  `health` float NOT NULL DEFAULT 100,
  `armor` float NOT NULL DEFAULT 0,
  `thirst` int(11) NOT NULL DEFAULT 100,
  `eat` int(11) NOT NULL DEFAULT 100,
  `bank_pin` varchar(6) NOT NULL DEFAULT '0,0',
  `bank_money` int(15) NOT NULL,
  `bank_check` int(11) NOT NULL DEFAULT 0,
  `leader` int(11) NOT NULL DEFAULT 0,
  `member` int(11) NOT NULL DEFAULT 0,
  `rang` int(11) NOT NULL DEFAULT 0,
  `fskin` int(11) NOT NULL DEFAULT 0,
  `exitx` float NOT NULL,
  `exity` float NOT NULL,
  `exitz` float NOT NULL,
  `exitfa` float NOT NULL,
  `p_world` int(11) NOT NULL DEFAULT 0,
  `p_interior` int(11) NOT NULL DEFAULT 0,
  `hospitaltime` int(11) NOT NULL DEFAULT 0,
  `keyh` int(11) NOT NULL DEFAULT -1,
  `keya` int(11) NOT NULL DEFAULT -1,
  `mutetime` int(11) NOT NULL DEFAULT 0,
  `p_model` int(11) NOT NULL DEFAULT 0,
  `p_posx` float NOT NULL,
  `p_posy` float NOT NULL,
  `p_posz` float NOT NULL,
  `p_posfa` float NOT NULL,
  `p_color1` int(11) NOT NULL DEFAULT 0,
  `p_color2` int(11) NOT NULL DEFAULT 0,
  `baninfo` int(1) NOT NULL DEFAULT 0,
  `golos` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `name` varchar(25) NOT NULL,
  `password` varchar(16) NOT NULL,
  `alevel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `apartament`
--

CREATE TABLE `apartament` (
  `aid` int(11) NOT NULL,
  `a_enterx` float NOT NULL,
  `a_entery` float NOT NULL,
  `a_enterz` float NOT NULL,
  `a_exitx` float NOT NULL,
  `a_exity` float NOT NULL,
  `a_exitz` float NOT NULL,
  `a_owner` varchar(26) NOT NULL,
  `a_owned` int(11) NOT NULL,
  `a_money` int(11) NOT NULL,
  `a_class` int(11) NOT NULL,
  `a_rent` int(11) NOT NULL DEFAULT 0,
  `a_world` int(11) NOT NULL,
  `a_lock` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `ban_accounts`
--

CREATE TABLE `ban_accounts` (
  `id` int(11) NOT NULL,
  `aname` varchar(24) NOT NULL,
  `name` varchar(24) NOT NULL,
  `whendate` varchar(28) NOT NULL,
  `unbandate` varchar(28) NOT NULL,
  `enddate` varchar(28) NOT NULL,
  `dayban` int(11) NOT NULL,
  `reason` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `house`
--

CREATE TABLE `house` (
  `hid` int(11) NOT NULL,
  `h_owned` int(1) NOT NULL DEFAULT 0,
  `h_owner` varchar(25) NOT NULL,
  `h_enterx` float NOT NULL,
  `h_entery` float NOT NULL,
  `h_enterz` float NOT NULL,
  `h_exitx` float NOT NULL,
  `h_exity` float NOT NULL,
  `h_exitz` float NOT NULL,
  `h_money` int(11) NOT NULL,
  `h_class` int(1) NOT NULL,
  `h_rent` int(11) NOT NULL DEFAULT 0,
  `h_lock` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `porch`
--

CREATE TABLE `porch` (
  `pid` int(11) NOT NULL,
  `p_enterx` float NOT NULL,
  `p_entery` float NOT NULL,
  `p_enterz` float NOT NULL,
  `p_exitx` float NOT NULL,
  `p_exity` float NOT NULL,
  `p_exitz` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `apartament`
--
ALTER TABLE `apartament`
  ADD PRIMARY KEY (`aid`);

--
-- Индексы таблицы `ban_accounts`
--
ALTER TABLE `ban_accounts`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `house`
--
ALTER TABLE `house`
  ADD PRIMARY KEY (`hid`);

--
-- Индексы таблицы `porch`
--
ALTER TABLE `porch`
  ADD PRIMARY KEY (`pid`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT для таблицы `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `apartament`
--
ALTER TABLE `apartament`
  MODIFY `aid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `ban_accounts`
--
ALTER TABLE `ban_accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT для таблицы `house`
--
ALTER TABLE `house`
  MODIFY `hid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `porch`
--
ALTER TABLE `porch`
  MODIFY `pid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
