# Роль для проверки возможности подключения Ansible к роутеру #

----------
Нужна, чтобы отлавливать ошибки при подключении RouterOS, такие как:

- Изменение отпечатка сертификата ssh сервера

----------

    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
    Someone could be eavesdropping o
    n you right now (man-in-the-middle attack)!
    It is also possible that a host key has just been changed.
    The fingerprint for the DSA key sent by the remote host is
    ...

----------

- Не верного логина\пароля 
- Отсутствие хоста в .ssh/known_hosts


----------
Оповещения о проблемах на email.

Нужно отредактировать tasks\main.yml и указать корректные учетные данные для подключения к почтовому серверу.