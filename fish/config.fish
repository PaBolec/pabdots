#source /usr/share/cachyos-fish-config/cachyos-config.fish

#overwrite greeting
#set -g fish_greeting (fastfetch --logo arch)

if status is-interactive
    set -g fish_greeting
    fastfetch
end

# Start KVM services when needed
function vm-start
    sudo systemctl start libvirtd.service libvirtd.socket virtlogd.service
    echo "KVM Services Started!"
end

# Stop KVM services completely
function vm-stop
    sudo systemctl stop libvirtd.service libvirtd.socket virtlogd.service
    echo "KVM Services Stopped!"
end

function hack-maciek=yes
    cat ~/Documents/maciek.txt
end

function fuck-you
    cat ~/Documents/sad.txt
end

function nigger
    cat ~/Documents/racist.txt
end

fish_add_path /home/paul/.spicetify
