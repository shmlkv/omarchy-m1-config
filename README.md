# Omarchy M1 config

Личный конфиг Omarchy на MacBook Air M1: привычные Mac-сочетания, русская раскладка, жесты тачпада и полный Go launcher. Снимок настроек от 17 сентября 2026 года.

Основа: Omarchy с Lua-конфигурацией Hyprland. Использовался Hyprland 0.56.2. Это набор пользовательских настроек, а не дистрибутив или установщик драйверов. На других машинах конфигурация не проверена.

## Клавиши и жесты

| Действие | Сочетание |
|---|---|
| Английский / русский Mac | Cmd+Space |
| Полное меню Go | F4 / Apple Spotlight key |
| Выбрать область и сохранить скриншот | Option+1 |
| Список сочетаний с названиями Command/Option | Cmd+K |
| Эмодзи | Cmd+Ctrl+E или Emoji в Go |
| Telegram, если установлен | Option+T |
| Локальная диктовка Voxtype, если установлена | Caps Lock / Compose |
| Панель Noctalia, если установлена | Option+N |
| Переключить рабочий стол | 4 пальца влево/вправо |
| Приложения | 4 пальца вверх |
| Scratchpad | 4 пальца вниз |
| Открыть / закрыть Noctalia | 3 пальца влево/вправо |

Клик касанием, перетаскивание касанием, естественная прокрутка и правый клик двумя пальцами включены. Скринсейвер показывает `shmlkv` со штатной анимацией Omarchy.

`mac-editing.lua` добавляет Cmd+C/V/X/A/Z, поиск, сохранение, вкладки, перемещение и выделение текста. Для терминалов некоторые действия отличаются или отключены. Команды отправляются по физическим кодам клавиш, чтобы работать и в русской раскладке. Эти сочетания заменяют часть стандартных команд управления окнами Omarchy; полный список находится в файле.

## Состав

- `home/.config/hypr/`: ввод, жесты, горячие клавиши, редактирование текста, автозапуск и пример настройки дисплея.
- `home/.config/omarchy/`: панель, пункт Emoji и текст скринсейвера.
- `home/.local/bin/omarchy-menu-keybindings-mac`: меню сочетаний с Mac-обозначениями.
- `home/.config/fontconfig/`: предпочтение Apple Color Emoji и FiraCode Nerd Font.
- `home/.config/noctalia/`: дополнительная панель без второго бара и фоновых служб уведомлений.
- `home/.config/voxtype/` и `home/.config/systemd/user/voxtype.service`: настройки локальной диктовки.
- `shell/codex-aliases.bash`: необязательные `x` и `ч` для Codex.

## Применение

Сначала сравните файлы со своими. Не копируйте каталог `home` целиком поверх существующего профиля: он содержит личные предпочтения, а Noctalia и Voxtype требуют отдельных установок.

Для основной клавиатуры и тачпада, из корня репозитория:

```bash
backup_dir="$HOME/.local/state/omarchy-m1-config/backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"
cp -a "$HOME/.config/hypr" "$backup_dir/hypr"
mkdir -p "$HOME/.local/bin"
if [ -e "$HOME/.local/bin/omarchy-menu-keybindings-mac" ]; then
  cp -a "$HOME/.local/bin/omarchy-menu-keybindings-mac" "$backup_dir/"
fi
cp home/.config/hypr/{bindings,input,mac-editing}.lua "$HOME/.config/hypr/"
install -m 755 home/.local/bin/omarchy-menu-keybindings-mac "$HOME/.local/bin/"
hyprctl reload
hyprctl configerrors
```

Штатный `hyprland.lua` должен загружать `hypr.input` и `hypr.bindings` после настроек Omarchy. При ошибках восстановите прежние файлы из указанного каталога и выполните `hyprctl reload`.

Остальные файлы переносите выборочно с резервной копией соответствующих настроек:

- **Экран:** `monitors.lua` использует автоматический масштаб Hyprland и `GDK_SCALE=2`; второе значение подходит не всем дисплеям.
- **Noctalia:** нужен исполняемый файл `noctalia`, поддерживающий `--daemon` и `msg panel-*`. Автозапуск находится в `autostart.lua`. Без Noctalia удалите её сочетания и трёхпальцевые жесты либо оставьте эти команды неиспользуемыми.
- **Voxtype:** нужен `~/.local/bin/voxtype` и локальная модель Whisper `small`. Файл службы использует `%h` вместо пути конкретного пользователя. После настройки можно выполнить `systemctl --user daemon-reload` и `systemctl --user enable --now voxtype.service`. Без Voxtype привязка Caps Lock не запускает диктовку.
- **Emoji:** сам выбор эмодзи — штатный `omarchy.emojis`. Fontconfig меняет их отрисовку на Apple Color Emoji при наличии шрифта. Файл шрифта не распространяется в этом репозитории; установите его отдельно при наличии права использования. FiraCode Nerd Font также не включён.
- **Скринсейвер:** сохраните прежний `~/.config/omarchy/branding/screensaver.txt`, затем скопируйте одноимённый файл. Для своего текста: `omarchy ascii "yourname" > ~/.config/omarchy/branding/screensaver.txt`.

## Необязательные aliases Codex

```bash
alias x='codex --dangerously-bypass-approvals-and-sandbox'
alias ч='codex --dangerously-bypass-approvals-and-sandbox'
```

Добавляйте их в `~/.bashrc` только осознанно: они отключают подтверждения и песочницу Codex. `ч` соответствует клавише `x` в русской раскладке. Они не применяются автоматически.

## Происхождение

Основа Mac-пресета и оболочка меню: [niraj-envision/omarchy-mac-keybinding](https://github.com/niraj-envision/omarchy-mac-keybinding), MIT, Copyright © 2026 Niraj Envision. Текст лицензии сохранён в `LICENSES/omarchy-mac-keybinding.txt`. Шаблоны конфигурации происходят из [Omarchy](https://github.com/omacom/omarchy); его лицензия приложена отдельно.

Снимок не содержит токенов, аккаунтов, SSH-ключей, истории команд, моделей диктовки, бинарных программ и файлов шрифтов. Проверены синтаксис Bash, JSON/TOML/XML и загрузка текущей конфигурации Hyprland; перенос на другую машину не проверялся.
