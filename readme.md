<div  align="center"><h2>Конфигурация docker от компании Mobecls.com</h2></div>
<p>Системные требования:
  Протестировано на linux mint/ubuntu<br>

  Необходимо наличие установленных docker и docker-compose, можно использовать руководство [отсюда](install-docker.md)
</p>
варианты использования:
<p>1: Развернуть демо чистой magento<br>
   Команды выполнять из каталога compose<br>
   bash bin/deploy_demo.sh - запускает демо , нужно выбрать версию Запускать в отдельном проекте, сотрет имеющиеся данные!<br>
</p>
<p>2: Развернуть готовый проект из исходников и дампа бд<br>
   Команды выполнять из каталога compose<br>
   1-скопировать исходники (или клонировать с гит) в каталог compose/src,скопировать дамп в compose/sql/src<br>
   2-bash bin/run.sh - тут предложит выбрать версию magento подождать конца установки<br>
   3-развернуть дамп - bash bin/deploy_database.sh - тут выбрать файл дампа (может быть в архиве gz)<br>
   4-установить base domain  например - bash bin/set_base_url.sh local.domain.com<br>
   5-установить ip для xdebug - bash bin/set_xdebug_ip.sh (настройка xdebug http://wiki.mobsdev.com/docker-phpstorm-config.mkv )<br>
   6-запустить bash bin/rebuild.sh - для обновления конфигурации окружения.
</p>
<p>Есть удобный графический [интерфейс](docker-helper.md), созданный [roman.dmitrenko](https://mobecls.slack.com/messages/@UDQ3W0HU7) </p>
<p>Глюсарий доступных команд</p>
bash bin/clear_env.sh - останавливает, а потом удаляет контейнеры docker в текущем проекте
bash bin/deploy_database.sh - устанавливает базу данных из файла-дампа, дамп нужно положить в compose/sql/src. Он может быть и в архиве gz, главное чтобы файл sql внутри был в корне архива. <br>
bash bin/deploy_demo.sh - распаковывает demo, проект с чистой копией magento, в диалоге можно выбрать требуемую версию. Внимание! Стирает все уже развернутые ранее копии magento! <br> 
bash bin/create_admin.sh - создает/сбрасывает пароль администратора. Но иногда нужно знать email (select * from admin_user;), в файле можно изменить данные на свои. <br>
bash bin/execute.sh - позволяет запускать команды в контейнере phpfpm. Примеры: ls -lh - покажет список файлов и каталогов в каталоге по-умолчанию (/var/www/html), bash bin/execute.sh pwd - покажет путь к текущему каталогу, bash bin/execute.sh mc - запустит mc (двухпанельный файловый менеджер)<br>    
bash bin/magento - команда magento, которая работает в контейнере, например: bash bin/magento c:c - сброс кэша, если в проекте м2<br>
bash bin/rebuild.sh - нужна для обновления окружения, нужно запускать, если что-то менялось в файлах докера, а также для перезапуска сервисов<br>
bash bin/php.sh -v - показать версию php (можно таким образом запускать любые php-скрипты внутри контейнера, скрипты должны находиться в compose/src ) <br>
bash bin/clear.sh - стирает все! Возврат проекта docker к состоянию пустого - стирает бд и мадженто.<br>
bash bin/composer - позволяет запускать composer в контейнере, пример использования bash bin/composer -V  - покажет версию композера, используемого в контейнере <br>
bash grunt - запускает grunt в контейнере, подробно описано [тут](grunt.md)<br>
bash bin/install_magento.sh - запускает установку magento, без этапа composer, запускать, если есть vendor-каталог , но базы данных нету.<br>
bash bin/n98-magerun2 - запуск утилиты n98-magerun2 в контейнере, утилита включает множество полезных возможностей [подробно](n98-magerun2.md)<br>
bash bin/n98-magerun- запуск утилиты n98-magerun (для magento 1) в контейнере<br>
bash bin/redis-cli - запускает клиент redis, в нем можно, например, сбросить кэш flushall<br>
bash bin/restart.sh - перезапускает контейнеры docker, нужно выполнить, если вносили правки в compose/docker-compose.yml или compose/docker-compose.shared.yml <br>
bash bin/run.sh - тут выбор версии magento, развертывание окружения docker, нужно для смены версии php. Внимание! выполнять осторожно, т.к. может возникнуть конфликт версий бд, если бд была кастомной, например, в compose/docker-compose.yml указали maria, вместо mysql<br>
bash bin/set_base_url.sh - устанавливает base_url magento, пример: bash bin/set_base_url.sh local.newdomain.com , записывает также и в /etc/hosts, поэтому просит права root <br>
bash bin/set_xdebug_ip.sh - предоставляет выбор ip для использования xdebug в контейнере, прописывает его в compose/docker-compose.yml , в XDEBUG_CONFIG remote_host , если файл еще не менялся - то в заменяет шаблон строки {place_you_ip} на ip. Внимание! Если ip уже выбирался, то сменить можно только путем редактирования compose/docker-compose.yml. Узнать ip можно командой ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' <br>
bash bin/show_base_url.sh показать secure и unsecure base_url в текущей magento, а также путь в админку, если magento уже развернута в контейнере<br> 
bash bin/start_clean.sh Внимание! выполнять осторожно! Несет в себе команду bash bin/clear.sh , плюс разворачивает окружение docker <br>
bash bin/stop_all.sh останавливает все контейнеры в текщем проекте<br>
bash bin/unpack_demo.sh Внимание! Не выполнять отдельно - команда используетсья в других скриптах. Распаковка демо<br>
bash bin/execute.sh dump-db.sh Делает урезанный дамп бд, в стоке игнорирует таблицы, описанные в пресете @development утилиты n98-magerun, можно применять свое настройки в файлах compose/images/php/{version}/bin/dump-db.sh , путем изменения переменной DEVELOPMENT_TABLES .Файлы по умолчанию складывает в корне magento. Пока только для m2 <br> 
bash bin/execute.sh strip-db.sh Внимание! Запускать осторожно! Удаляет таблицы из бд, в стоке делает TRUNCATE таблиц, описанные в пресете @development утилиты n98-magerun, можно применять свое настройки в файлах compose/images/php/{version}/bin/strip-db.sh , путем изменения переменной DEVELOPMENT_TABLES Пока только для m2 <br> 


   
<br>
<p>Полезная информация</p>

Phpmyadmin - тут http://127.0.0.1:8765/ <br>
docker-compose exec fpm /bin/bash  - позволяет подключиться к bash внутри контейнера, можно выполнять внутри любые команды, например composer update <br>
bash bin/composer - выполняет композер в контейнере, например bin/composer install - запустит уставку зависимостей magento <br>
<br>
<b>Добавлен NodeJs</b>
<br>
<p>NodeJs устанавливается пока <b>только</b> для образа 6-2 (2.3.3 -> 1.13-ssl-nodejs-yarn)</p>
<b>Важно:</b><br>
<p>В каталоге compose надо создать каталог node, в нём будут сидеть приложение (как в src - магента)</p>
<br>
<p>Добавлен PWA Deity Falcon Magento2:</p>
<ul>
После установки в docker-helper выбрать:<br>
<li>Docker -> NodeJs -> Deity PWA -> Install Deity PWA (./bin/install-falcon.sh)</li>
<li>Docker -> NodeJs -> Deity PWA -> Install Deity Magento2 Module (./bin/unpack_deity.sh)</li>
<li>Docker -> NodeJs -> Deity PWA -> Run Deity Falcon Client-Serve (./bin/start_falcon.sh)r</li>
</ul>
<p>Добавлен PWA Studio:</p>
<ul>
После установки в docker-helper выбрать:<br>
<li>Docker -> NodeJs -> Magento PWA Studio -> Install Magento PWA Studio (./bin/install-pwa-studio.sh)</li>
<li>Docker -> NodeJs -> Magento PWA Studio -> Build (./bin/studio-build.sh)</li>
<li>Docker -> NodeJs -> Magento PWA Studio -> Run Venia (./bin/studio-run-venia.sh)r</li>
<li>Docker -> NodeJs -> Magento PWA Studio -> Run Full Studio (./bin/studio-run-full.sh)r</li>
</ul>
<p>Добавлен Scandi PWA:</p>
<ul>
<li> [Руководство по установке](scandipwa.md)
</ul>

<br>
Ссылки на документацию по docker <br>
https://docs.docker.com/install/linux/docker-ce/ubuntu/ - как установить docker <br>
https://docs.docker.com/compose/install/ - как установить docker-compose <br>
<table class="c11">
    <tbody>
        <tr class="c4">
            <td class="c3" colspan="1" rowspan="1"><p class="c0"><span class="c1">&#1074;&#1077;&#1088;&#1089;&#1080;&#1103; Magento</span>
            </p></td>
            <td class="c3" colspan="1" rowspan="1"><p class="c0"><span class="c1">&#1074;&#1077;&#1088;&#1089;&#1080;&#1103; php</span>
            </p></td>
        </tr>
        <tr class="c4">
            <td class="c3" colspan="1" rowspan="1"><p class="c0"><span class="c1">2.1.17</span></p></td>
            <td class="c3" colspan="1" rowspan="1"><p class="c0"><span class="c1">7.0</span></p></td>
        </tr>
        <tr class="c4">
            <td class="c3" colspan="1" rowspan="1"><p class="c0"><span class="c1">2.2.8</span></p></td>
            <td class="c3" colspan="1" rowspan="1"><p class="c0"><span class="c1">7.1</span></p></td>
        </tr>
        <tr class="c4">
            <td class="c3" colspan="1" rowspan="1"><p class="c0"><span class="c1">2.3.1</span></p></td>
            <td class="c3" colspan="1" rowspan="1"><p class="c0"><span class="c1">7.2</span></p></td>
        </tr>
    </tbody>
</table>
Локальная почта собирается в виде .eml-файлов тут compose/sendmail/new<br>
Версии php - 5.6 7.0 7.1 7.2<br>
Используемый вебсервер - nginx 1.13, он же есть в связке с pagespeed В планах добавить apache.<br>
База данных mysql 5.7 - но если нужно что-то другое - можно легко добавить, пишите мне в slack @akulakov - покажу как.<br>
Изменение настроек mysql: При необходимости применить кастомные настройки mysql - вносить в файл compose/images/db/mysql/5.7-custom-config/conf/mysqld.cnf, потом делать bin/rebuild.sh <br>
В compose/images/db/mysql/5.7-custom-config/conf/mysqld.cnf можно включить журналирование запросов, а также журнал медленных запросов - путем удаления коментариев.<br> 
11.09.2019 - Добавлена поддержка Elasticsearch для версий с php 7.2 (2.3.1 opensource and commerce). Настройки в compose/yml/2.3.1/commerce/docker-compose.yml и compose/yml/2.3.1/opensource/docker-compose.yml в секции elasticsearch.
Проверка работы: bin/execute.sh bash
curl -i http://elasticsearch:9200/_cluster/health - покажет статус. Тоже самое из браузера http://localhost:9200/
Настройки magento - https://devdocs.magento.com/guides/v2.3/config-guide/elasticsearch/configure-magento.html<br>
3.11.2019 - добавлена поддержка varnish (для версии 2.3.3) , также добавлен демо 2.3.3.<br>
В magento нужно сделать настройки:<br>
bin/magento config:set --scope=default --scope-code=0 system/full_page_cache/caching_application 2 - включит использование варниша в magento<br>
bin/magento config:set web/secure/use_in_frontend 0 - т.к. ssl не используется<br>
bin/magento config:set web/secure/use_in_adminhtml 0 - т.к. ssl не используется<br>
Если не заводится статика:<br>
bin/magento config:set web/unsecure/base_static_url 0 <br>
bin/magento config:set web/secure/base_static_url 0 <br>

Проверка работы варниша:<br>
curl -I -v --location-trusted 'http://your_magento_url' - в ответе должны появиться заголовки<br>
X-Magento-Cache-Control: max-age=86400, public, s-maxage=86400<br>
Age: 0<br>
X-Magento-Cache-Debug: MISS<br>
Сброс варниша - curl -X PURGE http://your_magento_url, в в ответе будет Error 200 Purged  <br>
после второго обращения будет X-Magento-Cache-Debug: HIT<br>
Способ сброса через cli:<br>
из каталога compose выполнить  docker-compose exec varnish varnishadm<br>
выполнить в открывшемся терминале ban req.http.host == your_magento_host<br>
Внимание! - для обеспечения работы варниша на других версиях м2(на момент написания этой доки) нужно было заменить файл https://github.com/magento/magento2/blob/2.3-develop/pub/health_check.php - иначе не работало <br>

Конфигурация compose/yml/2.3.3/1.13-ssl-varnish4-elastic:<br>
Описание: nginx compose/images/nginx/1.13-ssl-varnish4-elastic, проксируються ssl, трафик передается варнишу, потом варниш - nginx.
bin/varnish_clear.sh - сбрасывает кэш varnish<br>
compose/bin/varnish_clear.sh - проверка базовых урлов (http/https) curl-ом, вывод заголовков.<br>


17.04.2020 - добавлен https://mailcatcher.me/ (ловля емейлов smtp), http://127.0.0.1:1080/ - веб интерфейс. smtp порт 1025, host в сети docker - mailcatcher<br>
16.11.2020 - добавлена поддержка magento 2.4.1 , хост демок изменился на magento2.localhost (просьба внести в свои хосты) <br>
Данный проект находится в стадии постоянной доработки.<br>
