
#!/bin/bash

echo -e "\e[1m\e[33mДанный скрипт устанавливает ядро Xray в Marzban и Marzban Node\n\e[0m"
sleep 1
if [[ $(uname) != "Linux" ]]; then
    echo "Этот скрипт предназначен только для Linux"
    exit 1
fi
if [[ $(uname -m) != "x86_64" ]]; then
    echo "Этот скрипт предназначен только для архитектуры x64"
    exit 1
fi
get_xray_core() {
latest_releases=$(curl -s "https://api.github.com/repos/XTLS/Xray-core/releases?per_page=4")
versions=($(echo "$latest_releases" | grep -oP '"tag_name": "\K(.*?)(?=")'))
echo "Доступные версии Xray-core:"
for ((i=0; i<${#versions[@]}; i++)); do
    echo "$(($i + 1)): ${versions[i]}"
done
printf "Выберите версию для установки (1-${#versions[@]}), или нажмите Enter для выбора последней по умолчанию (${versions[0]}): "
read choice
if [ -z "$choice" ]; then
    choice="1"
fi
choice=$((choice - 1))
if [ "$choice" -lt 0 ] || [ "$choice" -ge "${#versions[@]}" ]; then
    echo "Неверный выбор. Выбрана последняя версия по умолчанию (${versions[0]})."
    choice=$((${#versions[@]} - 1))
fi
selected_version=${versions[choice]}
echo "Выбрана версия $selected_version для установки."
if ! dpkg -s unzip >/dev/null 2>&1; then
  echo "Установка необходимых пакетов..."
  apt install -y unzip
fi
mkdir -p /var/lib/marzban/xray-core
cd /var/lib/marzban/xray-core
xray_filename="Xray-linux-64.zip"
xray_download_url="https://github.com/XTLS/Xray-core/releases/download/${selected_version}/${xray_filename}"
echo "Скачивание Xray-core версии ${selected_version}..."
wget "${xray_download_url}"
echo "Извлечение Xray-core..."
unzip -o "${xray_filename}"
rm "${xray_filename}"
}
detect_marzban_folder() {
    local candidates=(
        "/opt/marzban"
        "/root/marzban"
        "/var/lib/marzban"
    )
    for d in "${candidates[@]}"; do
        if [ -f "$d/.env" ] && [ -f "$d/docker-compose.yml" ]; then
            echo "$d"
            return 0
        fi
    done
    local found
    found=$(grep -rsl --include=docker-compose.yml -E 'gozargah/marzban|marzban:' \
        /opt /root /var/www /var/lib /home /srv 2>/dev/null | head -n1)
    if [ -n "$found" ]; then
        dirname "$found"
        return 0
    fi
    return 1
}
update_marzban_main() {
get_xray_core
marzban_folder="$(detect_marzban_folder || true)"
if [ -z "$marzban_folder" ]; then
    echo "Не удалось автоматически найти папку установки Marzban Main."
    read -rp "Введите полный путь к папке Marzban (где лежит .env и docker-compose.yml): " marzban_folder
fi
marzban_folder="${marzban_folder%/}"
marzban_env_file="${marzban_folder}/.env"
marzban_compose_file="${marzban_folder}/docker-compose.yml"
if [ ! -f "$marzban_env_file" ] || [ ! -f "$marzban_compose_file" ]; then
    echo "Ошибка: в '$marzban_folder' не найдены .env и/или docker-compose.yml."
    exit 1
fi
echo "Используется папка Marzban: $marzban_folder"
xray_executable_path='XRAY_EXECUTABLE_PATH="/var/lib/marzban/xray-core/xray"'
echo "Изменение ядра Marzban..."
sed -ri 's|^[[:space:]]*#[[:space:]]*(XRAY_EXECUTABLE_PATH=.*)$|\1|' "$marzban_env_file"
if ! grep -qE '^[[:space:]]*XRAY_EXECUTABLE_PATH=' "$marzban_env_file"; then
    echo "${xray_executable_path}" >> "${marzban_env_file}"
else
    sed -ri "s|^[[:space:]]*XRAY_EXECUTABLE_PATH=.*$|${xray_executable_path}|" "$marzban_env_file"
fi
if ! grep -qE '^\s*-\s*/var/lib/marzban:/var/lib/marzban\s*$' "$marzban_compose_file"; then
    echo "Добавление volume /var/lib/marzban в docker-compose.yml..."
    sed -i '/volumes:/!b;n;/\/var\/lib\/marzban:\/var\/lib\/marzban/!a\      - /var/lib/marzban:/var/lib/marzban' "$marzban_compose_file"
fi
echo "Перезапуск Marzban..."
if command -v marzban >/dev/null 2>&1; then
    marzban restart -n
else
    if (cd "$marzban_folder" && docker compose version >/dev/null 2>&1); then
        (cd "$marzban_folder" && docker compose down && docker compose up -d)
    elif (cd "$marzban_folder" && docker-compose version >/dev/null 2>&1); then
        (cd "$marzban_folder" && docker-compose down && docker-compose up -d)
    else
        echo "Не найдены ни 'marzban' CLI, ни docker compose. Перезапустите контейнер вручную:"
        echo "  cd $marzban_folder && docker compose down && docker compose up -d"
        exit 1
    fi
fi
echo "Установка завершена. Ядро установлено версии $selected_version"
}
update_marzban_node() {
get_xray_core
    marzban_node_dir="/opt/marzban-node"
    if [ ! -f "$marzban_node_dir/docker-compose.yml" ]; then
        echo "Файл docker-compose.yml не найден в $marzban_node_dir"
        exit 1
    fi
    if ! grep -q "XRAY_EXECUTABLE_PATH: \"/var/lib/marzban/xray-core/xray\"" "$marzban_node_dir/docker-compose.yml"; then
        sed -i '/environment:/!b;n;/XRAY_EXECUTABLE_PATH/!a\      XRAY_EXECUTABLE_PATH: "/var/lib/marzban/xray-core/xray"' "$marzban_node_dir/docker-compose.yml"
    fi
if ! grep -q "^\s*- /var/lib/marzban:/var/lib/marzban\s*$" "$marzban_node_dir/docker-compose.yml"; then
    sed -i '/volumes:/!b;n;/^- \/var\/lib\/marzban:\/var\/lib\/marzban/!a\      - \/var\/lib\/marzban:\/var\/lib\/marzban' "$marzban_node_dir/docker-compose.yml"
fi
    echo "Перезапуск Marzban..."
    cd "$marzban_node_dir" || exit
    docker compose up -d --force-recreate
    echo "Обновление ядра на Marzban-node завершено. Ядро установлено версии $selected_version"
}
echo "Выберите Marzban, для которого необходимо обновить ядро:"
echo "1. Marzban Main"
echo "2. Marzban Node"
read -p "Введите номер выбранной опции: " option
case $option in
    1)
        update_marzban_main
        ;;
    2)
        update_marzban_node
        ;;
    *)
        echo "Неверный выбор. Выберите 1 или 2."
        ;;
esac
