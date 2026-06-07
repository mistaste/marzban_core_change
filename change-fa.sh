
#!/bin/bash

echo '
_  _ ____ ____ _   _    ____ ____ ____ ____    _  _ ___  ___  ____ ___ ____
 \/  |__/ |__|  \_/     |    |  | |__/ |___    |  | |__] |  \ |__|  |  |___
_/\_ |  \ |  |   |      |___ |__| |  \ |___    |__| |    |__/ |  |  |  |___
___  _   _    ____ ___  ____ _  _ ____ ___  ____  _  _ _   _ ___
|__]  \_/     |  | |__] |___ |\ | |  | |  \ |___   \/   \_/    /
|__]   |      |__| |    |___ | \| |__| |__/ |___ ._/\_   |    /__
'
echo -e "\e[1m\e[33|جامعه ما: https://openode.xyz\n\e[0m"
sleep 2s
echo -e "\e[1m\e[33mاین اسکریپت هسته Xray را در Marzban و Marzban Node نصب می‌کند\n\e[0m"
sleep 1
if [[ $(uname) != "Linux" ]]; then
    echo "این اسکریپت فقط برای لینوکس است"
    exit 1
fi
if [[ $(uname -m) != "x86_64" ]]; then
    echo "این اسکریپت فقط برای معماری x64 است"
    exit 1
fi
get_xray_core() {
latest_releases=$(curl -s "https://api.github.com/repos/XTLS/Xray-core/releases?per_page=4")
versions=($(echo "$latest_releases" | grep -oP '"tag_name": "\K(.*?)(?=")'))
echo "نسخه‌های موجود Xray-core:"
for ((i=0; i<${#versions[@]}; i++)); do
    echo "$(($i + 1)): ${versions[i]}"
done
printf "یک نسخه برای نصب انتخاب کنید (1-${#versions[@]})، یا Enter را فشار دهید تا آخرین نسخه به صورت پیش‌فرض انتخاب شود (${versions[0]}): "
read choice
if [ -z "$choice" ]; then
    choice="1"
fi
choice=$((choice - 1))
if [ "$choice" -lt 0 ] || [ "$choice" -ge "${#versions[@]}" ]; then
    echo "انتخاب نادرست. آخرین نسخه (${versions[0]}) به صورت پیش‌فرض انتخاب شد."
    choice=$((${#versions[@]} - 1))
fi
selected_version=${versions[choice]}
echo "نسخه $selected_version برای نصب انتخاب شد."
if ! dpkg -s unzip >/dev/null 2>&1; then
  echo "نصب بسته‌های مورد نیاز..."
  apt install -y unzip
fi
mkdir -p /var/lib/marzban/xray-core
cd /var/lib/marzban/xray-core
xray_filename="Xray-linux-64.zip"
xray_download_url="https://github.com/XTLS/Xray-core/releases/download/${selected_version}/${xray_filename}"
echo "دانلود Xray-core نسخه ${selected_version}..."
wget "${xray_download_url}"
echo "استخراج Xray-core..."
unzip -o "${xray_filename}"
rm "${xray_filename}"
}
update_marzban_main() {
get_xray_core
marzban_folder="/opt/marzban"
marzban_env_file="${marzban_folder}/.env"
xray_executable_path='XRAY_EXECUTABLE_PATH="/var/lib/marzban/xray-core/xray"'
echo "تغییر هسته Marzban..."
if ! grep -q "^${xray_executable_path}" "$marzban_env_file"; then
  echo "${xray_executable_path}" >> "${marzban_env_file}"
fi
echo "راه‌اندازی مجدد Marzban..."
marzban restart -n
echo "نصب به پایان رسید."
}
update_marzban_node() {
get_xray_core
    marzban_node_dir=$(find / -type d -name "Marzban-node" -exec test -f "{}/docker-compose.yml" \; -print -quit)
    if [ -z "$marzban_node_dir" ]; then
        echo "پوشه Marzban-node با فایل docker-compose.yml یافت نشد"
        exit 1
    fi
    if ! grep -q "XRAY_EXECUTABLE_PATH: \"/var/lib/marzban/xray-core/xray\"" "$marzban_node_dir/docker-compose.yml"; then
        sed -i '/environment:/!b;n;/XRAY_EXECUTABLE_PATH/!a\      XRAY_EXECUTABLE_PATH: "/var/lib/marzban/xray-core/xray"' "$marzban_node_dir/docker-compose.yml"
    fi
if ! grep -q "^\s*- /var/lib/marzban:/var/lib/marzban\s*$" "$marzban_node_dir/docker-compose.yml"; then
    sed -i '/volumes:/!b;n;/^- \/var\/lib\/marzban:\/var\/lib\/marzban/!a\      - \/var\/lib\/marzban:\/var\/lib\/marzban' "$marzban_node_dir/docker-compose.yml"
fi
    echo "راه‌اندازی مجدد Marzban..."
    cd "$marzban_node_dir" || exit
    docker compose up -d --force-recreate
    echo "به‌روزرسانی هسته در Marzban-node به پایان رسید. هسته نصب شده نسخه $selected_version است"
}
echo "Marzban را برای به‌روزرسانی هسته انتخاب کنید:"
echo "1. Marzban Main"
echo "2. Marzban Node"
read -p "شماره گزینه انتخاب شده را وارد کنید: " option
case $option in
    1)
        update_marzban_main
        ;;
    2)
        update_marzban_node
        ;;
    *)
        echo "انتخاب نادرست. گزینه 1 یا 2 را انتخاب کنید."
        ;;
esac
