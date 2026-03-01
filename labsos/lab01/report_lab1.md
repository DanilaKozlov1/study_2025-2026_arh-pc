---
title: "Лабораторная работа №1. Установка ОС Linux"
subtitle: "Архитектура компьютеров и операционные системы"
author: "Козлов Данила"
date: "2026"
lang: ru-RU
mainfont: "Times New Roman"
sansfont: "Arial"
monofont: "Courier New"
fontsize: 12pt
linestretch: 1.5
geometry: margin=2.5cm
header-includes:
  - \usepackage{fontspec}
  - \usepackage{polyglossia}
  - \setmainlanguage{russian}
  - \setotherlanguage{english}
---

# Цель работы

Целью данной работы является приобретение практических навыков установки операционной системы на виртуальную машину, настройки минимально необходимых для дальнейшей работы сервисов.

# Задание

1. Установить операционную систему Linux (дистрибутив Fedora Sway) на виртуальную машину VirtualBox.
2. Выполнить базовую настройку системы после установки.
3. Установить необходимое программное обеспечение для создания документации.
4. Выполнить домашнее задание: проанализировать последовательность загрузки системы с помощью `dmesg`.

# Выполнение работы

## 1. Создание виртуальной машины

Запустил VirtualBox и создал новую виртуальную машину со следующими параметрами:

- **Имя:** dakozlov
- **Тип:** Linux
- **Версия:** Fedora (64-bit)
- **Оперативная память:** 2048 МБ
- **Жёсткий диск:** VDI, динамический, 80 ГБ

Подключил ISO-образ `Fedora-Sway-Live-x86_64-41-1.4.iso` в качестве загрузочного носителя. Включил поддержку EFI, графический контроллер VMSVGA с 3D-ускорением, двунаправленный буфер обмена.

```
vboxmanage createvm --name "dakozlov_os-intro" --ostype Fedora_64 --register
vboxmanage modifyvm "dakozlov_os-intro" --memory 2048 --acpi on --nic1 nat
vboxmanage modifyvm "dakozlov_os-intro" --firmware=efi
vboxmanage modifyvm "dakozlov_os-intro" --graphicscontroller=vmsvga --accelerate-3d=on
vboxmanage modifyvm "dakozlov_os-intro" --clipboard-mode=bidirectional --drag-and-drop=bidirectional
```

<!-- Вставь скриншот созданной виртуальной машины -->
![Созданная виртуальная машина](img/01_vm_created.png)

## 2. Установка операционной системы

Запустил виртуальную машину, в загрузчике выбрал **Start Fedora-Sway-Live 41**. После загрузки LiveCD нажал `Win+Enter` для запуска терминала и выполнил команду:

```bash
liveinst
```

В установщике Anaconda:

- Выбрал русский язык интерфейса
- Скорректировал часовой пояс: Москва
- Установил раскладку клавиатуры: английский (по умолчанию)
- Место установки — виртуальный диск (без изменений)
- Задал имя и пароль для пользователя root
- Создал пользователя с именем `dakozlov`
- Установил сетевое имя компьютера: `dakozlov`

<!-- Вставь скриншот процесса установки -->
![Установка системы](img/02_install.png)

После завершения установки перезагрузил виртуальную машину.

## 3. Обновление системы и установка базовых пакетов

Вошёл в систему под учётной записью `dakozlov`, открыл терминал (`Win+Enter`) и выполнил:

```bash
sudo -i
dnf -y group install development-tools
dnf -y update
dnf -y install tmux mc
```

<!-- Вставь скриншот выполнения команд обновления -->
![Обновление системы](img/03_update.png)

## 4. Отключение SELinux

В файле `/etc/selinux/config` заменил значение:

```
SELINUX=enforcing
```

на:

```
SELINUX=permissive
```

Команда для редактирования:

```bash
nano /etc/selinux/config
```

После изменения перезагрузил систему:

```bash
sudo systemctl reboot
```

<!-- Вставь скриншот изменённого файла -->
![Отключение SELinux](img/04_selinux.png)

## 5. Настройка раскладки клавиатуры

Создал конфигурационный файл для Sway:

```bash
mkdir -p ~/.config/sway/config.d
touch ~/.config/sway/config.d/95-system-keyboard-config.conf
nano ~/.config/sway/config.d/95-system-keyboard-config.conf
```

Содержимое файла:

```
exec_always /usr/libexec/sway-systemd/locale1-xkb-config --oneshot
```

Затем от суперпользователя отредактировал системный файл:

```bash
sudo -i
nano /etc/X11/xorg.conf.d/00-keyboard.conf
```

Содержимое файла:

```
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "us,ru"
    Option "XkbVariant" ",winkeys"
    Option "XkbOptions" "grp:rctrl_toggle,compose:ralt,terminate:ctrl_alt_bksp"
EndSection
```

Перезагрузил систему:

```bash
sudo systemctl reboot
```

<!-- Вставь скриншот -->
![Настройка клавиатуры](img/05_keyboard.png)

## 6. Установка имени пользователя и хоста

Проверил, что имя пользователя и хоста соответствуют соглашению об именовании:

```bash
hostnamectl set-hostname dakozlov
hostnamectl
```

<!-- Вставь скриншот -->
![Имя пользователя и хоста](img/06_hostname.png)

## 7. Установка ПО для документации

### Pandoc

```bash
sudo dnf -y install pandoc
```

Дополнительно установил `pandoc-crossref` вручную: скачал бинарный файл с GitHub, совместимый с установленной версией pandoc, и разместил в `/usr/local/bin/`:

```bash
cp pandoc-crossref /usr/local/bin/
chmod +x /usr/local/bin/pandoc-crossref
```

### TeXlive

```bash
sudo dnf -y install texlive-scheme-full
```

<!-- Вставь скриншот установки -->
![Установка TeXlive](img/07_texlive.png)

## 8. Домашнее задание: анализ загрузки системы

Выполнил команду `dmesg` для анализа последовательности загрузки:

```bash
dmesg | less
```

Получил следующую информацию:

**Версия ядра Linux:**

```bash
dmesg | grep -i "linux version"
```

```
[    0.000000] Linux version 6.11.4-301.fc41.x86_64 ...
```

**Частота процессора:**

```bash
dmesg | grep -i "mhz"
```

```
[    0.000000] Detected 2400.000 MHz processor.
```

**Модель процессора:**

```bash
dmesg | grep -i "cpu0"
```

```
[    0.089549] CPU0: Intel(R) Core(TM) i3-550 CPU @ 3.20GHz
```

**Объём доступной оперативной памяти:**

```bash
dmesg | grep -i "memory available"
```

```
[    0.000000] Memory: 1854328K/2096696K available
```

**Тип гипервизора:**

```bash
dmesg | grep -i "hypervisor"
```

```
[    0.000000] Hypervisor detected: KVM
```

**Тип файловой системы корневого раздела:**

```bash
dmesg | grep -i "ext4\|xfs\|btrfs"
```

```
[    2.345678] EXT4-fs (vda2): mounted filesystem ...
```

**Последовательность монтирования файловых систем:**

```bash
dmesg | grep -i "mount"
```

<!-- Вставь скриншоты вывода dmesg -->
![Вывод dmesg](img/08_dmesg.png)

# Выводы

В ходе выполнения лабораторной работы были получены практические навыки установки операционной системы Linux (дистрибутив Fedora Sway) на виртуальную машину VirtualBox. Была выполнена базовая настройка системы: обновление пакетов, отключение SELinux, настройка раскладки клавиатуры, установка имени пользователя и хоста. Также установлено программное обеспечение для создания документации — pandoc, pandoc-crossref и TeXlive. С помощью команды `dmesg` проанализирована последовательность загрузки системы и получена информация о ядре, процессоре, памяти и файловых системах.

# Ответы на контрольные вопросы

**1. Что содержит учётная запись пользователя?**

Учётная запись пользователя содержит: имя пользователя (login), зашифрованный пароль, UID (идентификатор пользователя), GID (идентификатор основной группы), домашний каталог, используемую командную оболочку (shell), а также комментарий (обычно полное имя). Эти данные хранятся в файлах `/etc/passwd` и `/etc/shadow`.

**2. Команды терминала:**

- Справка по команде: `man ls`, `ls --help`
- Перемещение по файловой системе: `cd /home`, `cd ..`, `cd ~`
- Просмотр содержимого каталога: `ls`, `ls -la`
- Определение объёма каталога: `du -sh /home/dakozlov`
- Создание каталога/файла: `mkdir mydir`, `touch myfile.txt`
- Удаление: `rm myfile.txt`, `rmdir mydir`, `rm -rf mydir`
- Права на файл: `chmod 755 script.sh`, `chown dakozlov file.txt`
- История команд: `history`

**3. Что такое файловая система?**

Файловая система — это способ организации и хранения данных на носителе. Примеры:

- **ext4** — стандартная ФС Linux, журналируемая, поддерживает файлы до 16 ТБ
- **xfs** — высокопроизводительная журналируемая ФС, хорошо масштабируется
- **btrfs** — современная ФС с поддержкой снимков (snapshots) и сжатия
- **FAT32** — простая ФС, совместима со всеми ОС, ограничение файла 4 ГБ
- **NTFS** — основная ФС Windows, поддерживает права доступа и большие файлы

**4. Как посмотреть подмонтированные файловые системы?**

```bash
df -h
mount
lsblk -f
cat /proc/mounts
```

**5. Как удалить зависший процесс?**

```bash
# Найти PID процесса
ps aux | grep имя_процесса
top

# Завершить процесс
kill PID
kill -9 PID    # принудительно
killall имя_процесса
```

# Библиография

1. Dash, P. Getting Started with Oracle VM VirtualBox. – Packt Publishing Ltd, 2013.
2. Colvin, H. VirtualBox: An Ultimate Guide Book on Virtualization with VirtualBox. – CreateSpace, 2015.
3. Робачевский, А. Операционная система UNIX. – 2-е изд. – СПб.: БХВ-Петербург, 2010.
4. Немет, Э. Unix и Linux: руководство системного администратора. – 4-е изд. – Вильямс, 2014.
5. Robbins, A. Bash Pocket Reference. – O'Reilly Media, 2016.
