# Используем официальный образ Nginx
FROM nginx:alpine

# Удаляем дефолтовый конфиг
RUN rm /etc/nginx/conf.d/default.conf

# Копируем наш конфиг в контейнер
COPY default.conf /etc/nginx/conf.d/

# Копируем статические файлы в корневую директорию Nginx
# Предполагаем, что ваши статические файлы лежат в папке ./static
COPY static/ /usr/share/nginx/html/

# Открываем порт 443
EXPOSE 443
EXPOSE 80

# Команда запуска (не обязательна, т. к. у базового образа уже есть ENTRYPOINT)
CMD ["nginx", "-g", "daemon off;"]
