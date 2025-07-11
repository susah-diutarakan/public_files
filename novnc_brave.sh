#!/bin/sh
apt update &&  apt upgrade -y
apt install -y curl apt-transport-https 
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
apt update
apt install -y brave-browser && brave-browser --version
#Install a Minimal X Server and VNC
apt install -y xvfb tightvncserver && apt install -y openbox
#Install noVNC
git clone https://github.com/novnc/noVNC.git /opt/novnc
apt install -y python3 python3-pip
pip3 install websockify
#Install D-Bus
mkdir -p /run/user/0
chown root:root /run/user/0
export XDG_RUNTIME_DIR=/run/user/0
apt install -y dbus-x11
#Configure VNC Server
USER=root tightvncserver :1
USER=root tightvncserver -kill :1
#Clipboard Keyboard SSL TaskBar Black BG
apt install -y autocutsel xserver-xorg xkb-data openssl tint2 feh x11-xserver-utils
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /opt/novnc/novnc.key -out /opt/novnc/novnc.crt
sed -i -e '$a\' /etc/xdg/openbox/autostart  
sed -i -e '$atint2 &' /etc/xdg/openbox/autostart
sed -i -e '$a\' /etc/xdg/openbox/autostart  
sed -i -e '$axsetroot -solid black &' /etc/xdg/openbox/autostart
#Startup file
echo '#!/bin/sh

Xvfb :1 -screen 0 1920x1080x24 -extension XKB -ac +extension GLX +extension RANDR &
export DISPLAY=:1
sleep 2
#setxkbmap -layout us -variant intl &
autocutsel -fork &
setxkbmap us &
dbus-run-session -- sh -c "openbox-session & brave-browser --no-sandbox --disable-dev-shm-usage " & 
#x11vnc -display :1 -forever -shared -repeat
x11vnc -display :1 -noxrecord -noxfixes -noxdamage -repeat -capslock -nomodtweak -forever' > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup
wget -O stop_brave.sh https://raw.githubusercontent.com/susah-diutarakan/public_files/main/stop_brave.sh
wget -O start_brave.sh https://raw.githubusercontent.com/susah-diutarakan/public_files/main/start_brave.sh
wget -O launch_brave.sh https://raw.githubusercontent.com/susah-diutarakan/public_files/main/launch_brave.sh
wget -O launch_brave2.sh https://raw.githubusercontent.com/susah-diutarakan/public_files/main/launch_brave2.sh
wget -O launch_grass.sh https://raw.githubusercontent.com/susah-diutarakan/public_files/main/launch_grass.sh
wget -O menu.xml https://raw.githubusercontent.com/susah-diutarakan/public_files/main/menu.xml
chmod +x *.sh
mv -f menu.xml /etc/xdg/openbox/menu.xml
sed -i '/<\/head>/i \
<script>\
\n  if (!crypto.randomUUID) {\
\n      crypto.randomUUID = function() {\
\n      return '\''xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'\''.replace(/[xy]/g, function(c) {\
\n        const r = Math.random() * 16 | 0;\
\n        return (c === '\''x'\'' ? r : (r & 0x3 | 0x8)).toString(16);\
\n      });\
\n    };\
\n  }\
\n</script>' /opt/novnc/vnc.html
rm -rf /opt/novnc/.git/ /opt/novnc/.github/ /opt/novnc/.gitignore /opt/novnc/.gitmodules
echo -e "\e[32mInstallation completed! \e[0m"
echo "Run \"./start_brave.sh\" to start NoVNC + Brave Browser"
echo "to Stop Press ctrl+c and Run \"./stop_brave.sh\""
