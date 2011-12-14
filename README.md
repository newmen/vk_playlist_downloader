#vk_playlist_downloader
Данный код позволяет скачивать музыку из ВКонтакта, указывая ID пользователя, чей плейлист необходимо скачать.

Код работает на Ruby 1.9 и не работает на 1.8. Не работает конкретно момент позволяющий сохранять файлы в соответствующие папки, игнорируя регистр символов (мультибайт и иже с ним)...

## Как этим пользоваться?
Сначала необходимо склонировать себе код командой
``
 git clone git@github.com:newmen/vk_playlist_downloader.git 
``

Потом настроить сие, отредактировав файл config.yml, и запустить командой
``
 ruby vk_playlist_downloader.rb 
``

## Параметры загрузки
Параметры загрузки указываются в конфигурационном файле config.yml, среди них:

- ID приложения, посредством которого осуществляется доступ к API ВКонтакта (всегда можно зарегистрировать новое и указать его ID здесь) - заполнять этот параметр не обязательно, по умолчанию будет взято ID уже созданного автором приложения
- Email пользователя (ваш) для авторизации на ВКонтакте
- Пароль (ваш) для авторизации на ВКонтакте
- ID пользователя, чей плейлист нужно скачать (по видимому тоже ваш) - можно указывать никнейм (он же адрес страницы)
- Директория для сохранения загруженных треков
- Перечень артистов, треки которых только и нужно скачивать, а остальных не нужно
- Перечень артистов, которых не нужно скачивать, поскольку, возможно, у вас итак уже есть полная коллекция треков этих артистов
- Границы загружаемых песенок от (start) и до (stop)

Указываемые в конфигурационном файле параметры - не обязательны. Они могут либо отсутствовать, либо соответствовать '?'. В таком случае, программа спросит необходимый параметр.
Параметры исключаемых артистов, и границы загружаемых треков - не обязательны и спрошены не будут. Не обязательно указывать сразу 2 границы, можно только одну.

При запуске, приложение проверяет указанную папку для загрузок на наличие уже загруженных треков, и если трек уже загружен - повторная его загрузка не происходит.
Загруженные файлы складываются в директории с названием исполнителя.

## Гемы необходимые для работы кода
- active_support
- json
- ruby-mp3info
- vk-console

