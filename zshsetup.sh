#!/bin/bash

# Spinner Animation Function
spinner() {
    local spinner='_-‾-_-‾-_-‾-_-‾'
    local delay=0.1
    local duration=$1
    local length=${#spinner}

    for (( i=0; i<duration; i++ )); do
        # Calculate the part of the spinner to display
        local part=${spinner:i%length:6}
        # Add remaining part if needed to maintain the bar length
        if [ ${#part} -lt 6 ]; then
            part=$part${spinner:0:$((6 - ${#part}))}
        fi
        # Print the current spinner state
        printf "\r%s" "$part"
        sleep $delay
    done
    printf "\r"
}

# Error Check Function
checkerror() {
    if [ $? -ne 0 ]; then
        echo -e "\e[31mNOTICE! Check here for any error!\e[0m"  
        return 0
    fi
}

# Timeout Function
read_with_timeout() {
    local prompt="$1"
    local timeout=$2
    local response

    # Read user input with a timeout
    read -t "$timeout" -p "$prompt" response || {
        # Handle timeout (15 seconds in this case)
        echo -e "\e[33mTime Out! Proceeding (RISKY!)...\e[0m"
        return 0
    }

    # Return the user's response
    echo "$response"
}

# User/Root verification
userverify() {
    
    username=$(whoami)
    hostname=$(hostname)

    # Print username and hostname to the terminal
    echo "User: $username"
    response=$(read_with_timeout "Is the above user root? (y/n): " 20)

    # Check user response
    if [[ "$response" == "n" ]]; then
        echo -e "\e[32mStarting...\e[0m"
    else
        echo -e "\e[33mDon't use sudo to run this script, instead type:\e[0m"
        echo -e 'chmod +x zshsetup.sh'
        sleep 1
        exit 1
    fi
}

# Starting Here!
userverify

# Updating packages and installing wget, git, curl 
echo -e "\e[33mUpdating Packages\e[0m"
sudo apt update
sudo apt upgrade -y
echo Installing dependencies
sudo apt install wget git curl -y

	checkerror "packages"
	echo -e "\e[36mUpdate successful!\e[0m"
	echo _________________________________________

# Installing zsh and setting it to default
echo -e "\e[33mInstalling 'zsh'\e[0m"
rm -fv .zshrc
rm -fv .zshrc.pre-oh-my-zsh
rm -fv .zshenv
rm -fv .zprofile
sudo apt install zsh
#chsh -s $(which zsh)

	checkerror "zsh"
	echo -e "\e[36mInstalled zsh!\e[0m"
	echo _________________________________________

# Installing OMZ!
rm -rfv .oh-my-zsh
rm -fv .p10k.zsh
echo -e "\e[33mStep 4 - Installing 'ohmyzsh'\e[0m"
echo -e "\e[41mNOTE! Type 'bye' after omz install finishes to resume the script\e[0m"
echo "Press any key to continue..."
read -n 1 
spinner 30
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo -e "\e[36mInstalled omz!\e[0m"
echo _________________________________________

# Installing Powerlevel10k
echo -e "\e[33mStep 5 - Installing 'powerlevel10k'\e[0m"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
	
    checkerror "p10k"
    echo -e "\e[36mDefault zsh theme is now - powerlevel0k!\e[0m"
    echo _________________________________________

echo -e "\e[35mPlugin: 'htop'\e[0m"
sudo apt install htop -y

	checkerror "htop"
	echo -e "\e[36mDownloaded and installed htop!\e[0m"
	echo _________________________________________


echo -e "\e[35mPlugin: 'micro'\e[0m"
sudo apt install micro -y

	checkerror "micro"
	echo -e "\e[36mDownloaded and installed micro!\e[0m"
	echo _________________________________________

echo -e "\e[35mPlugin: 'neofetch'\e[0m"
sudo apt install neofetch -y

	checkerror "neofetch"
	echo -e "\e[36mDownloaded and installed neofetch!\e[0m"
	echo _________________________________________

echo -e "\e[35mPlugin: 'thefuck'\e[0m"
sudo apt install thefuck -y
echo ' ' >> $HOME/.zshrc
echo '# ----------------the fuck----------------' >> $HOME/.zshrc
echo 'eval $(thefuck --alias)' >> $HOME/.zshrc

	checkerror "thefuck"
	echo -e "\e[36mInstalled thefuck!\e[0m"
	echo _________________________________________

echo -e "\e[35mPlugin: 'eza'\e[0m"
sudo apt install -y gpg
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza
echo ' ' >> $HOME/.zshrc
echo '# ----------------eza----------------' >> $HOME/.zshrc
echo 'alias el="eza -alhM --icons --group --no-quotes"' >> $HOME/.zshrc
echo 'export EZA_COLORS="ur=38;5;211:uw=38;5;211:ue=38;5;211:ux=38;5;211:gr=38;5;099:gw=38;5;099:gx=38;5;099:tr=38;5;111:tw=38;5;111:tx=38;5;111:hd=1;4;38;5;254:ln=1;38;5;142:xa=38;5;111:nb=38;5;022:ub=38;5;064:nk=38;5;070:uk=38;5;070:nm=38;5;220:um=38;5;220:ng=1;38;5;203:ug=1;38;5;220:uu=38;5;218:uR=3;38;5;118:gu=38;5;223:gR=3;38;5;130:un=38;5;245:gn=2;38;5;245"' >> $HOME/.zshrc

	checkerror "eza"
	echo -e "\e[36mInstalled eza!\e[0m"
	echo _________________________________________

echo -e "\e[35mPlugin: 'zoxide'\e[0m"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
echo ' ' >> $HOME/.zshrc
echo '# ----------------zoxide----------------' >> $HOME/.zshrc
echo 'eval "$(zoxide init zsh)"' >> $HOME/.zshrc

	checkerror "zoxide"
	echo -e "\e[36mInstalled zoxide! Don't Forget to edit Path\e[0m"
	echo _________________________________________

echo -e "\e[35mPlugin: 'zsh-syntax-highlighting'\e[0m"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

ZSHRC_PATH="$HOME/.zshrc"
PLUGINSYNTAXH="zsh-syntax-highlighting"
if grep -q "plugins=.*$PLUGINSYNTAXH" "$ZSHRC_PATH"; then
  echo "$PLUGINSYNTAXH is already in the plugins array."
else
  sed -i "s/plugins=(\(.*\))/plugins=(\1 $PLUGINSYNTAXH)/" "$ZSHRC_PATH"
  echo "$PLUGINSYNTAXH has been added to the plugins array."
fi

	checkerror "zsh-syntaxhighlighting"
	echo -e "\e[36mInstalled zsh syntax highlighting!\e[0m"
	echo _________________________________________


echo -e "\e[35mPlugin: 'zsh-autocomplete'\e[0m"
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
echo ' ' >> $HOME/.zshrc
echo '# ----------------zsh zutocomplete----------------' >> $HOME/.zshrc
echo 'source $HOME/zsh-autocomplete/zsh-autocomplete.plugin.zsh' >> $HOME/.zshrc

	checkerror "zsh-autocomplete"
	echo -e "\e[36mInstalled zsh-automplete!\e[0m"
	echo _________________________________________

echo finished!

