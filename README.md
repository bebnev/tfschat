# TFS Homeworks

## Intro

- [x] - создать проект
- [x] - поменять Deploy target на 12
- [x] - добавить иконку приложения
- [x] - AppDelegate прологировать методы ЖЦ
- [x] - ViewController прологировать методы ЖЦ
- [x] - Добавить условие для включения/отключения логов перед компиляцией 

По заданию со звездочкой добавлен кастомный флаг: `LOGS_ARE_ENABLED`

###  После замечаний

- [x] - переименован флал `LOGS_ARE_ENABLED` в `IS_LOGS_ENABLED` 
- [x] - функция log переделана на класс со статичным методом

## UI

- [x] - реализовать интерфейс по макету
- [x] - добавить возможность подгрузки автара с камеры или из галереи 

## Navigation && Table view

- [x] - Создать экран списка бесед (ConversationsListViewController),
- [x] - Экран должен быть в UINavigationController
- [x] - Заголовок экрана: Tinkoff Chat
- [x] - В таблице две секции:
          - Online: в ней будут отображаться диалоги, чьи адресаты на текущий момент доступны для переписки
          - History: в ней будут храниться непустые диалоги с адресатами, недоступными для переписки
- [x] - Ячейка для чатов
          - name - Заполняет лейбл для имени текстом
          - message - Заполняет лейбл последнего сообщения текстом (Если был передан nil - нужно отображать в лейбле «No messages yet» отличным от стандартного шрифтом)
          - date - Отображаем время в формате HH:mm (если была передана дата вчерашняя или ранее - отображаем дату, т.е. формат dd MMM)
- [x] - Признак доступности адресата для переписки - Если пользователь online - то делаем фон ячейки бледно-желтым цветом. Оффлайн - оставляем белым.
- [x] - Признак наличия в диалоге непрочитанных сообщений - Если есть непрочитанные сообщения — текст последнего сообщения отображается жирным.
- [x] - Инстанс класса ячейки должен соответствовать протоколу
```
protocol ConfigurableView {...}
```
- [x] - Модель ячейки
```
let name: String
let message: String
let date: Date
let isOnline: Bool
let hasUnreadMessages: Bool
```
- [x] - В каждой секции должно быть минимум по 10 ячеек с разными данными,
- [x] - Создать экран беседы для отображения диалога с входящими и исходящими сообщениями (ConversationViewController),
- [x] - Заголовок экрана будет таким же, как имя из ячейки с которой был осуществлен переход (картинка + текст)
- [x] - Ячейка для сообщений: 
        - Для входящих сообщений - Текст сообщения не должен заходить на последнюю четверть ширины ячейки
        - Для исходящих сообщений - Текст сообщения не должен заходить на первую четверть ширины ячейки
- [x] - ConfigurableView + Модель
- [x] - Организовать навигацию между контроллерами согласно схеме: List -> push -> Chat, List -> modal -> Profile
- [x] - Экран профиля открывается модально
