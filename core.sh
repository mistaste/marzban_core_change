#!/bin/bash

# Function to download and execute the script based on language selection
execute_script() {
    local script_url=$1
    bash <(wget -qO- $script_url)
}

# Display language selection menu
echo "Выберите язык скрипта / Choose the script language / زبان اسکریپت را انتخاب کنید:"
echo "1. Русский / Russian / روسی"
echo "2. English / Английский / انگلیسی"
echo "3. فارسی / Farsi / Persian"

# Prompt user for language selection
read -p "Введите номер выбранного языка / Enter the number of the selected language / شماره زبان انتخابی را وارد کنید: " lang_choice

# Determine the corresponding script URL based on user's choice
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

# Execute the selected script
execute_script $script_url
