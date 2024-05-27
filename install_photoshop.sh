#!/bin/bash
echo;echo;echo "  =================================";echo "  == Photoshop CC 2020 for Linux =="
echo "  =================================";echo "                         by Seb3773";echo;echo
if [ "$EUID" -eq 0 ];then echo " > This script must not be run as root."
echo " > Please run it as normal user, elevated rights will be asked when needed. ";echo;echo " > exiting.";echo;exit;fi
echo " > This script will install Adobe Photoshop CC 2020 on your computer."
echo " > It will use approximatively 4,3Gb of disk space (5Gb with CameraRaw)."
echo " ? Proceed ? (y:yes/enter:quit) ?" && read x
if [ "$x" == "y" ] || [ "$x" == "Y" ]; then

if ! dpkg -l | grep -q winehq-stable; then
echo " > Installing wine and required components...";echo
sudo dpkg --add-architecture i386 >> ./setup.log 2>&1
sudo apt install -y gnupg2 software-properties-common wget cabextract >> ./setup.log 2>&1
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key >> ./setup.log 2>&1
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources >> ./setup.log 2>&1
sudo apt update >> ./setup.log 2>&1
sudo apt install -y --install-recommends winehq-stable >> ./setup.log 2>&1
fi
echo " > Installing winetricks, please wait...";echo
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks >> ./setup.log 2>&1
chmod +x winetricks;sudo mv winetricks /usr/local/bin/

echo " > Creating PhotoshopCC prefix...";echo
mkdir -p "$HOME/PhotoshopCC"
echo " winetricks: installing vcrun2019..."
WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose vcrun2019  >> ./setup.log 2>&1
echo " winetricks: installing vcrun2012..."
WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose vcrun2012 >> ./setup.log 2>&1
echo " winetricks: installing vcrun2013..."
WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose vcrun2013 >> ./setup.log 2>&1
echo " winetricks: installing vcrun2010..."
WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose vcrun2010 >> ./setup.log 2>&1
echo " winetricks: installing gdiplus..."
WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose fontsmooth=rgb gdiplus >> ./setup.log 2>&1
echo " winetricks: installing msxml3 & msxml6..."
WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose msxml3 msxml6 >> ./setup.log 2>&1
echo " winetricks: installing atmlib..."
WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose atmlib >> ./setup.log 2>&1
echo " winetricks: installing corefonts..."
WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose corefonts >> ./setup.log 2>&1
echo " winetricks: installing dxvk..."
WINEPREFIX="$HOME/PhotoshopCC" winetricks win10 --force --unattended --verbose dxvk >> ./setup.log 2>&1
echo

WINEPREFIX="$HOME/PhotoshopCC" winecfg /v win7 >> ./setup.log 2>&1
while pgrep wine > /dev/null; do sleep 1; done
sleep 2

echo " > Extracting archive, please wait...";echo
if [ -f "./files/Microsoft_Office_365.tar.xz" ]; then
tar -xf ./files/PhotoshopCC_folder.tar.xz -C "$HOME/PhotoshopCC"
else
cat ./files/PhotoshopCC_folder_part_* > ./files/PhotoshopCC_folder.tar.xz
rm -f ./files/PhotoshopCC_folder_part_*
tar -xf ./files/PhotoshopCC_folder.tar.xz -C "$HOME/PhotoshopCC"
fi

sudo cp -f ./files/photoshop-cc.png /usr/share/icons/hicolor/128x128/apps
sudo cp -f ./files/photoshop.desktop "$HOME/.local/share/applications/"
sudo cp -f ./files/photoshop.sh "$HOME/PhotoshopCC"
sudo chmod +x "$HOME/PhotoshopCC/photoshop.sh"
sudo sed -i "s|\$HOME|$HOME|g" "$HOME/.local/share/applications/photoshop.desktop"
echo " > Photoshop installation done.";echo
echo " ? Install CameraRaw ? (y:yes/enter:skip) ?" && read x
if [ "$x" == "y" ] || [ "$x" == "Y" ]; then
echo " > Installing CameraRaw...";echo
wget -P "$HOME/PhotoshopCC/" https://download.adobe.com/pub/adobe/photoshop/cameraraw/win/12.x/CameraRaw_12_2_1.exe >> ./setup.log 2>&1
WINEPREFIX=$HOME/PhotoshopCC wine $HOME/PhotoshopCC/CameraRaw_12_2_1.exe >> ./setup.log 2>&1
rm -f "$HOME/PhotoshopCC/CameraRaw_12_2_1.exe"
echo " > CameraRaw installation done.";echo;fi
echo " > Launching photoshop...";echo
WINEPREFIX=$HOME/PhotoshopCC wine $HOME/PhotoshopCC/Photoshop-CC/Photoshop.exe </dev/null >/dev/null 2>&1 &
echo " > script finished.";echo;else echo " > Exited.";echo;fi
