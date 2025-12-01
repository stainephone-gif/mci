# Flappy Bird - Android Game

Классическая игра Flappy Bird, написанная на Java для Android.

## Описание

Это нативное Android-приложение, реализующее популярную игру Flappy Bird. Управляйте птицей, нажимая на экран, и старайтесь пролететь между зелеными трубами!

## Особенности

- Полностью нативная реализация на Java
- Простое управление одним касанием
- Сохранение лучшего результата
- Плавная анимация (60 FPS)
- Портретная ориентация экрана

## Требования для сборки

- Android Studio (рекомендуется последняя версия)
- Android SDK (API Level 21+)
- JDK 8 или выше

## Как собрать APK

### Вариант 1: Через Android Studio

1. Откройте проект в Android Studio
2. Подождите, пока Gradle синхронизирует зависимости
3. Выберите `Build` → `Build Bundle(s) / APK(s)` → `Build APK(s)`
4. APK будет создан в `app/build/outputs/apk/debug/app-debug.apk`

### Вариант 2: Через командную строку

```bash
# Убедитесь, что у вас установлен Android SDK
# и переменная ANDROID_HOME настроена

# Сборка debug APK
./gradlew assembleDebug

# APK будет создан в app/build/outputs/apk/debug/app-debug.apk
```

### Вариант 3: Сборка release APK (подписанный)

```bash
# Сначала создайте keystore (если ещё не создан)
keytool -genkey -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias

# Затем соберите release APK
./gradlew assembleRelease
```

## Установка на устройство

### Через ADB

```bash
adb install app/build/outputs/apk/debug/app-debug.apk
```

### Вручную

1. Скопируйте APK файл на устройство
2. Откройте файл на устройстве
3. Разрешите установку из неизвестных источников (если требуется)
4. Установите приложение

## Управление

- **Нажатие на экран** - птица подпрыгивает вверх
- Старайтесь пролететь между трубами
- Игра заканчивается при столкновении с трубой или краем экрана

## Структура проекта

```
app/
├── src/main/
│   ├── java/com/flappybird/
│   │   ├── MainActivity.java      # Главная активность
│   │   ├── GameView.java          # Игровая логика и отрисовка
│   │   ├── Bird.java              # Класс птицы
│   │   └── Pipe.java              # Класс трубы
│   ├── res/
│   │   └── values/
│   │       ├── strings.xml        # Строковые ресурсы
│   │       └── colors.xml         # Цвета
│   └── AndroidManifest.xml        # Манифест приложения
└── build.gradle                    # Конфигурация сборки
```

## Лицензия

Этот проект создан в образовательных целях.