[Вернуться](readme.md)
<p>Ставим Docker https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-docker-ce: </p> 
<ol>
   <li>sudo apt-get update  -обновляем репозитории</li>
   <li>sudo apt-get install \
                   apt-transport-https \
                   ca-certificates \
                   curl \
                   gnupg-agent \
                   software-properties-common   -устанавливаем зависимости</li>
   <li>curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -    -устанавливаем ключ репозитория
</li>
   <li>sudo apt-key fingerprint 0EBFCD88   -проверка ключа</li>
   <li>sudo add-apt-repository \
                 "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
                  $(lsb_release -cs) \
                  stable"</li>
   <li>Для mint нужно глянуть версию https://linuxmint.com/download_all.php 
              для Tara, например, это bionic , и это будет выглядеть так<br> 
              sudo add-apt-repository \
              "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
               bioniс \
               stable"<br>
               sudo apt-get update           -устанавливаем репозитории docker</li>
   <li>sudo apt-get install docker-ce docker-ce-cli containerd.io  -ставим docker и его компоненты</li>
   <li>проверка sudo docker run hello-world   -должно в консоли показать надпись  Hello from Docker! This message shows that your installation appears to be working correctly.
</li>
   <li>sudo apt-get update  -обновляем репозитории</li>
   <li>sudo groupadd docker<br> 
       sudo usermod -aG docker $USER<br>
       делаем ребут системы, чтобы подтянуть новые права<br>
       проверяем возможность работы от текущего<br> 
       docker run hello-world - команде docker теперь не нужны права sudo</li>
</ol>
  
        
<p>Установить compose https://docs.docker.com/compose/install/<p>
     1. sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose<br>   -копируем docker-compose в /usr/local/bin/docker-compose <br>
     2. sudo chmod +x /usr/local/bin/docker-compose - делаем файл исполняемым<br>
     3. docker-compose --version     -проверка, должно показать версию.<br>
