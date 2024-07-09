#!/bin/bash

# This script updates the Xray core in Marzban and Marzban Node.
# Этот скрипт обновляет ядро Xray в Marzban и Marzban Node.
# این اسکریپت هسته Xray را در Marzban و Marzban Node به‌روزرسانی می‌کند.

echo -e "\e[1;32m"
echo "┌────────────────────────────────────────────────────────────────────────┐"
echo "│ This script updates the Xray core in Marzban and Marzban Node.          │"
echo "└────────────────────────────────────────────────────────────────────────┘"
echo -e "\e[0m"

echo -e "\e[1;32m"
echo "┌────────────────────────────────────────────────────────────────────────┐"
echo "│ Этот скрипт обновляет ядро Xray в Marzban и Marzban Node.               │"
echo "└────────────────────────────────────────────────────────────────────────┘"
echo -e "\e[0m"

echo -e "\e[1;32m"
echo "┌────────────────────────────────────────────────────────────────────────┐"
echo "│ این اسکریپت هسته Xray را در Marzban و Marzban Node به‌روزرسانی می‌کند. │"
echo "└────────────────────────────────────────────────────────────────────────┘"
echo -e "\e[0m"

execute_script() {
    local script_url=$1
    bash <(wget -qO- $script_url)
}

echo "Выберите язык скрипта / Choose the script language / زبان اسکریپت را انتخاب کنید:"
echo -e "\e[41m1. \e[0m Русский / Russian / روسی"    # Red for Russia
echo -e "\e[44m2. \e[0m English / Английский / انگلیسی"  # Blue for USA/UK
echo -e "\e[42m3. \e[0m فارسی / Farsi / Persian"  # Green for Iran

read -p "Введите номер выбранного языка / Enter the number of the selected language / شماره زبان انتخابی را وارد کنید: " lang_choice

case $lang_choice in
    1)
        script_url="https://raw.githubusercontent.com/DigneZzZ/marzban_core_change/main/change.sh"
        ;;
    2)
        script_url="https://raw.githubusercontent.com/DigneZzZ/marzban_core_change/main/change-en.sh"
        ;;
    3)
        script_url="https://raw.githubusercontent.com/DigneZzZ/marzban_core_change/main/change-fa.sh"
        ;;
    *)
        echo "Неверный выбор. Пожалуйста, выберите 1, 2 или 3. / Invalid choice. Please select 1, 2, or 3. / انتخاب نامعتبر. لطفا 1، 2 یا 3 را انتخاب کنید."
        exit 1
        ;;
esac

execute_script $script_url
