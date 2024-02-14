[Вернуться](readme.md) <br>
Установка ScandiPWA на "чистом" проекте. <br>
проект ставится по адресу https://local.magento2.com/

<ul>
На чистом проекте:
<li>Скомпилировать Docker Helper (./docker-helper/build.sh)</li>
<li>Запустить Docker Helper (./compose/bin/docker-helper)</li>
<li>Выбрать Tools -> Deploy Demo, выбрать пункт 4, потом ещё раз 4</li>
<li>Выбрать Docker -> NodeJs -> Scandi PWA -> Install Scandi PWA</li>
<li>Выбрать Docker -> NodeJs -> Scandi PWA -> Run Scandi PWA</li>
<li>Когда отработает, окно не закрывать. Открыть страницу https://local.magento2.com/admin</li>
<li>Фронт на странице http://localhost:3003/</li>
</ul>

Редактировать проект можно в ./compose/src/vendor/scandipwa/source <br>
Первым делом в ./compose/src/vendor/scandipwa/source/scr/app/util/Request/Request.js поменять строку 16: <br>
const GRAPHQL_URI = '/graphql'; ===> const GRAPHQL_URI = 'https://local.magento2.com/graphql'; <br>
Проект обновляется "на лету" - после изменений автоматически пересоберётся <br>







