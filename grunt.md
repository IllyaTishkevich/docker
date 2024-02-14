[Вернуться](readme.md)
Установка Grunt проект magento
Для работы нужен node.js (у меня установлен 8.16.0), можно использовать наш docker-проект - там нода уже установлен.
1.Добавляем свою кастомную тему в {magento root}/dev/tools/grunt/configs/themes.js
ниже пример , добавлена porto_child после существующей backend
    },
    backend: {
        area: 'adminhtml',
        name: 'Magento/backend',
        locale: 'en_US',
        files: [
            'css/styles-old',
            'css/styles'
        ],
        dsl: 'less'
    },
    porto_child: {
        area: 'frontend',
        name: 'Smartwave/porto_child',
        locale: 'en_US',
        files: [
            'css/styles-m',
            'css/styles-l'
        ],
        dsl: 'less'
    },

2. скопировать  {magento root}/package.json.sample в  {magento root}/package.json
3. скопировать  {magento root}/Gruntfile.js.sample в  {magento root}/Gruntfile.js
4. выполнить npm install  - в корневом каталоге magento
5. выполнить npm update
6. проверить установку Grunt командой grunt --version
7. если предыдущий шаг был успешен делаем команду grunt exec:{you theme} например, grunt exec:porto_child , дождаться выполнения.
8. Запускать grunt watch во время работы со стилями - gunt будет после каждой правки компилировать нужный стиль в static

остановить grunt watch ctrl+c

Браузерное расширение livereload у меня не заработало
