#!/bin/bash
# Display the header
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
echo -e "\e[1m\e[33|Our community: https://openode.xyz\n\e[0m"
sleep 2s

echo -e "\e[1m\e[33mThis script installs the Xray core in Marzban and Marzban Node\n\e[0m"
sleep 1

# Check the operating system
if [[ $(uname) != "Linux" ]]; then
    echo "This script is intended for Linux only"
    exit 1
fi

# Check the architecture
if [[ $(uname -m) != "x86_64" ]]; then
    echo "This script is intended for x64 architecture only"
    exit 1
fi

# Function to download the file
get_xray_core() {
# Send a request to GitHub API to get information about the latest four releases
latest_releases=$(curl -s "https://api.github.com/repos/XTLS/Xray-core/releases?per_page=4")

# Extract versions from the JSON response
versions=($(echo "$latest_releases" | grep -oP '"tag_name": "\K(.*?)(?=")'))

# Print available versions
echo "Available Xray-core versions:"
for ((i=0; i<${#versions[@]}; i++)); do
    echo "$(($i + 1)): ${versions[i]}"
done

# Prompt the user to choose a version
printf "Choose a version to install (1-${#versions[@]}), or press Enter to select the latest by default (${versions[0]}): "
read choice

# Check if a choice was made by the user
if [ -z "$choice" ]; then
    choice="1"  # Choose the latest version by default
fi

# Convert the user's choice to an array index
choice=$((choice - 1))

# Ensure the user's choice is within available versions
if [ "$choice" -lt 0 ] || [ "$choice" -ge "${#versions[@]}" ]; then
    echo "Invalid choice. The latest version (${versions[0]}) is selected by default."
    choice=$((${#versions[@]} - 1))  # Choose the latest version by default
fi

# Select the version of Xray-core to install
selected_version=${versions[choice]}
echo "Selected version $selected_version for installation."

# Check if the required packages are installed
if ! dpkg -s unzip >/dev/null 2>&1; then
  echo "Installing required packages..."
  apt install -y unzip
fi

# Create the /var/lib/marzban/xray-core folder
mkdir -p /var/lib/marzban/xray-core
# Go to the /var/lib/marzban/xray-core folder
cd /var/lib/marzban/xray-core

# Download the selected version of Xray-core
xray_filename="Xray-linux-64.zip"
xray_download_url="https://github.com/XTLS/Xray-core/releases/download/${selected_version}/${xray_filename}"

echo "Downloading Xray-core version ${selected_version}..."
wget "${xray_download_url}"

# Extract the file from the archive and delete the archive
echo "Extracting Xray-core..."
unzip -o "${xray_filename}"
rm "${xray_filename}"

}

# Function to update the Marzban Main core
update_marzban_main() {
get_xray_core
# Change the Marzban core
marzban_folder="/opt/marzban"
marzban_env_file="${marzban_folder}/.env"
xray_executable_path='XRAY_EXECUTABLE_PATH="/var/lib/marzban/xray-core/xray"'

echo "Changing the Marzban core..."
# Check if the XRAY_EXECUTABLE_PATH string already exists in the .env file
if ! grep -q "^${xray_executable_path}" "$marzban_env_file"; then
  # If the string does not exist, add it
  echo "${xray_executable_path}" >> "${marzban_env_file}"
fi


# Restart Marzban
echo "Restarting Marzban..."
marzban restart -n

echo "Installation completed."
}

# Function to update the Marzban Node core
update_marzban_node() {
get_xray_core

    # Find the path to the Marzban-node folder and the docker-compose.yml file
    marzban_node_dir=$(find / -type d -name "Marzban-node" -exec test -f "{}/docker-compose.yml" \; -print -quit)

    if [ -z "$marzban_node_dir" ]; then
        echo "Marzban-node folder with docker-compose.yml file not found"
        exit 1
    fi

    # Check if the XRAY_EXECUTABLE_PATH string already exists in the docker-compose.yml file
    if ! grep -q "XRAY_EXECUTABLE_PATH: \"/var/lib/marzban/xray-core/xray\"" "$marzban_node_dir/docker-compose.yml"; then
        # If the string does not exist, add it
        sed -i '/environment:/!b;n;/XRAY_EXECUTABLE_PATH/!a\      XRAY_EXECUTABLE_PATH: "/var/lib/marzban/xray-core/xray"' "$marzban_node_dir/docker-compose.yml"
    fi
# Check if the /var/lib/marzban:/var/lib/marzban string already exists in the docker-compose.yml file
if ! grep -q "^\s*- /var/lib/marzban:/var/lib/marzban\s*$" "$marzban_node_dir/docker-compose.yml"; then
    # If the string does not exist, add it
    sed -i '/volumes:/!b;n;/^- \/var\/lib\/marzban:\/var\/lib\/marzban/!a\      - \/var\/lib\/marzban:\/var\/lib\/marzban' "$marzban_node_dir/docker-compose.yml"
fi

    # Restart Marzban-node
    echo "Restarting Marzban..."
    cd "$marzban_node_dir" || exit
    docker compose up -d --force-recreate

    echo "Marzban-node core update completed. The core version installed is $selected_version"
}

# Print available options for the user
echo "Select Marzban to update the core:"
echo "1. Marzban Main"
echo "2. Marzban Node"

# Prompt the user to choose an option
read -p "Enter the number of the selected option: " option

# Check the user's choice and call the appropriate function
case $option in
    1)  
        update_marzban_main
        ;;
    2)
        update_marzban_node
        ;;
    *)
        echo "Invalid choice. Choose 1 or 2."
        ;;
esac
