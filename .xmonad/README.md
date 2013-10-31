modm -> Alt
mod4m -> Win Key

If you are using xephyr->

Cntl(R) + Shift -> To UnCapture input.
Alt + Shift + Cntl(R) -> To Capture input 

Add this to your bashrc:
`
alias xphr="Xephyr -ac -br -noreset -host-cursor -screen 1366x764 -fullscreen -dpi 100 :1 &sleep 1 ;DISPLAY=:1;feh --bg-fill /home/xadmin/Pictures/waterfall.jpg;xmonad &" 
`
(Change the image location)
Also This:
`
alias syncx="/home/xadmin/.xmonad/syncx :0 :1"
`
(Use syncx to sync Xephyr clipboard)

Or if otherwise paste xmonad.desktop (after altering the username) in
"/usr/share/xsessions/"

Or 
`
xinit -- :1
`
Then execute
`
~/.xmonad/xintrc
`

##Required:
`
sudo apt-get install xserver-xephyr xmonad suckless-tools xmobar trayer pcmanfm xfe lxappearance ttf-liberation  xfce4-mixer gmrun feh scrot nitrogen 
`

##Optional:

`
sudo apt-get install zim artha terminator indicator-keylock synapse guake xautolock xrandr indicator-remindor xfce4-volumed xfce4-power-manager pulseaudio thunar xfce4-terminal
`
