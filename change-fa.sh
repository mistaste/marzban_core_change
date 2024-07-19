#!/bin/bash
# نمایش عنوان
echo '  
██╗  ██╗██████╗  █████╗ ██╗   ██╗     ██████╗ ██████╗ ██████╗ ███████╗    ██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗██████╗ 
╚██╗██╔╝██╔══██╗██╔══██╗╚██╗ ██╔╝    ██╔════╝██╔═══██╗██╔══██╗██╔════╝    ██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔══██╗
 ╚███╔╝ ██████╔╝███████║ ╚████╔╝     ██║     ██║   ██║██████╔╝█████╗      ██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗  ██████╔╝
 ██╔██╗ ██╔══██╗██╔══██║  ╚██╔╝      ██║     ██║   ██║██╔══██╗██╔══╝      ██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝  ██╔══██╗
██╔╝ ██╗██║  ██║██║  ██║   ██║       ╚██████╗╚██████╔╝██║  ██║███████╗    ╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗██║  ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝        ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝     ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
                                                                                                                                    
                                                                                                
███████╗ ██████╗ ██████╗     ███╗   ███╗ █████╗ ██████╗ ███████╗██████╗  █████╗ ███╗   ██╗
██╔════╝██╔═══██╗██╔══██╗    ████╗ ████║██╔══██╗██╔══██╗╚══███╔╝██╔══██╗██╔══██╗████╗  ██║
█████╗  ██║   ██║██████╔╝    ██╔████╔██║███████║██████╔╝  ███╔╝ ██████╔╝███████║██╔██╗ ██║
██╔══╝  ██║   ██║██╔══██╗    ██║╚██╔╝██║██╔══██║██╔══██╗ ███╔╝  ██╔══██╗██╔══██║██║╚██╗██║
██║     ╚██████╔╝██║  ██║    ██║ ╚═╝ ██║██║  ██║██║  ██║███████╗██████╔╝██║  ██║██║ ╚████║
╚═╝      ╚═════╝ ╚═╝  ╚═╝    ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝
                                                                                          

██████╗ ██╗   ██╗    ██████╗ ██╗ ██████╗ ███╗   ██╗███████╗███████╗███████╗███████╗    
██╔══██╗╚██╗ ██╔╝    ██╔══██╗██║██╔════╝ ████╗  ██║██╔════╝╚══███╔╝╚══███╔╝╚══███╔╝    
██████╔╝ ╚████╔╝     ██║  ██║██║██║  ███╗██╔██╗ ██║█████╗    ███╔╝   ███╔╝   ███╔╝     
██╔══██╗  ╚██╔╝      ██║  ██║██║██║   ██║██║╚██╗██║██╔══╝   ███╔╝   ███╔╝   ███╔╝      
██████╔╝   ██║       ██████╔╝██║╚██████╔╝██║ ╚████║███████╗███████╗███████╗███████╗    
╚═════╝    ╚═╝       ╚═════╝ ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝╚══════╝    
                                                                                                                                                                                               
'
echo -e "\e[1m\e[33|جامعه ما: https://openode.xyz\n\e[0m"
sleep 2s

echo -e "\e[1m\e[33mاین اسکریپت هسته Xray را در Marzban و Marzban Node نصب می‌کند\n\e[0m"
sleep 1

# بررسی سیستم عامل
if [[ $(uname) != "Linux" ]]; then
    echo "این اسکریپت فقط برای لینوکس است"
    exit 1
fi

# بررسی معماری
if [[ $(uname -m) != "x86_64" ]]; then
    echo "این اسکریپت فقط برای معماری x64 است"
    exit 1
fi

# تابع دانلود فایل
get_xray_core() {
# ارسال درخواست به GitHub API برای دریافت اطلاعات در مورد چهار نسخه آخر
latest_releases=$(curl -s "https://api.github.com/repos/XTLS/Xray-core/releases?per_page=4")

# استخراج نسخه‌ها از پاسخ JSON
versions=($(echo "$latest_releases" | grep -oP '"tag_name": "\K(.*?)(?=")'))

# چاپ نسخه‌های موجود
echo "نسخه‌های موجود Xray-core:"
for ((i=0; i<${#versions[@]}; i++)); do
    echo "$(($i + 1)): ${versions[i]}"
done

# پیشنهاد به کاربر برای انتخاب نسخه
printf "یک نسخه برای نصب انتخاب کنید (1-${#versions[@]})، یا Enter را فشار دهید تا آخرین نسخه به صورت پیش‌فرض انتخاب شود (${versions[0]}): "
read choice

# بررسی می‌کنیم که آیا کاربر انتخابی انجام داده است
if [ -z "$choice" ]; then
    choice="1"  # انتخاب آخرین نسخه به صورت پیش‌فرض
fi

# تبدیل انتخاب کاربر به ایندکس آرایه
choice=$((choice - 1))

# اطمینان از اینکه انتخاب کاربر در محدوده نسخه‌های موجود است
if [ "$choice" -lt 0 ] || [ "$choice" -ge "${#versions[@]}" ]; then
    echo "انتخاب نادرست. آخرین نسخه (${versions[0]}) به صورت پیش‌فرض انتخاب شد."
    choice=$((${#versions[@]} - 1))  # انتخاب آخرین نسخه به صورت پیش‌فرض
fi

# انتخاب نسخه Xray-core برای نصب
selected_version=${versions[choice]}
echo "نسخه $selected_version برای نصب انتخاب شد."

# بررسی نصب بسته‌های مورد نیاز
if ! dpkg -s unzip >/dev/null 2>&1; then
  echo "نصب بسته‌های مورد نیاز..."
  apt install -y unzip
fi

# ایجاد پوشه /var/lib/marzban/xray-core
mkdir -p /var/lib/marzban/xray-core
# رفتن به پوشه /var/lib/marzban/xray-core
cd /var/lib/marzban/xray-core

# دانلود نسخه انتخاب شده Xray-core
xray_filename="Xray-linux-64.zip"
xray_download_url="https://github.com/XTLS/Xray-core/releases/download/${selected_version}/${xray_filename}"

echo "دانلود Xray-core نسخه ${selected_version}..."
wget "${xray_download_url}"

# استخراج فایل از آرشیو و حذف آرشیو
echo "استخراج Xray-core..."
unzip -o "${xray_filename}"
rm "${xray_filename}"

}

# تابع برای به‌روزرسانی هسته Marzban Main
update_marzban_main() {
get_xray_core
# تغییر هسته Marzban
marzban_folder="/opt/marzban"
marzban_env_file="${marzban_folder}/.env"
xray_executable_path='XRAY_EXECUTABLE_PATH="/var/lib/marzban/xray-core/xray"'

echo "تغییر هسته Marzban..."
# بررسی وجود رشته XRAY_EXECUTABLE_PATH در فایل .env
if ! grep -q "^${xray_executable_path}" "$marzban_env_file"; then
  # اگر رشته وجود ندارد، آن را اضافه می‌کنیم
  echo "${xray_executable_path}" >> "${marzban_env_file}"
fi


# راه‌اندازی مجدد Marzban
echo "راه‌اندازی مجدد Marzban..."
marzban restart -n

echo "نصب به پایان رسید."
}

# تابع برای به‌روزرسانی هسته Marzban Node
update_marzban_node() {
get_xray_core

    # جستجوی مسیر پوشه Marzban-node و فایل docker-compose.yml
    marzban_node_dir=$(find / -type d -name "Marzban-node" -exec test -f "{}/docker-compose.yml" \; -print -quit)

    if [ -z "$marzban_node_dir" ]; then
        echo "پوشه Marzban-node با فایل docker-compose.yml یافت نشد"
        exit 1
    fi

    # بررسی وجود رشته XRAY_EXECUTABLE_PATH در فایل docker-compose.yml
    if ! grep -q "XRAY_EXECUTABLE_PATH: \"/var/lib/marzban/xray-core/xray\"" "$marzban_node_dir/docker-compose.yml"; then
        # اگر رشته وجود ندارد، آن را اضافه می‌کنیم
        sed -i '/environment:/!b;n;/XRAY_EXECUTABLE_PATH/!a\      XRAY_EXECUTABLE_PATH: "/var/lib/marzban/xray-core/xray"' "$marzban_node_dir/docker-compose.yml"
    fi
# بررسی وجود رشته /var/lib/marzban:/var/lib/marzban در فایل docker-compose.yml
if ! grep -q "^\s*- /var/lib/marzban:/var/lib/marzban\s*$" "$marzban_node_dir/docker-compose.yml"; then
    # اگر رشته وجود ندارد، آن را اضافه می‌کنیم
    sed -i '/volumes:/!b;n;/^- \/var\/lib\/marzban:\/var\/lib\/marzban/!a\      - \/var\/lib\/marzban:\/var\/lib\/marzban' "$marzban_node_dir/docker-compose.yml"
fi

    # راه‌اندازی مجدد Marzban-node
    echo "راه‌اندازی مجدد Marzban..."
    cd "$marzban_node_dir" || exit
    docker compose up -d --force-recreate

    echo "به‌روزرسانی هسته در Marzban-node به پایان رسید. هسته نصب شده نسخه $selected_version است"
}

# چاپ گزینه‌های موجود برای کاربر
echo "Marzban را برای به‌روزرسانی هسته انتخاب کنید:"
echo "1. Marzban Main"
echo "2. Marzban Node"

# درخواست از کاربر برای انتخاب گزینه
read -p "شماره گزینه انتخاب شده را وارد کنید: " option

# بررسی انتخاب کاربر و فراخوانی تابع مربوطه
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
