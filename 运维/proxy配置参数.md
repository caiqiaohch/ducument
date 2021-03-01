		external_port[0].port = 8991;
		external_port[1].port = 8998;
proxy tcp -p ":8991" -T tcp -P "18.217.242.44:8992" --forever --log proxy.log --daemon
proxy tcp -p ":8998" -T tcp -P "18.217.242.44:8999" --forever --log proxy2.log --daemon

ln /mnt/hgfs/kebie/goproxy/src /mnt/hgfs/kebie/goproxy/src/github.com/snail007/goproxy