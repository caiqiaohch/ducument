# 安装wxWidgets3.0 gen_iface.py:No such file or directory

If you receive weird errors during compiling, or running wx-config after installing, it might be because the line endings of the files are in DOS format.
cd ./src/stc && ./gen_iface.py
: No such file or directory
make: *** [include/wx/stc/stc.h] Error 127
root@CubieTruck:~/wxWidgets-3.0.0# cd src/stc/
root@CubieTruck:~/wxWidgets-3.0.0/src/stc# ./gen_iface.py
: No such file or directory
root@CubieTruck:~/wxWidgets-3.0.0/src/stc# dos2unix gen_iface.py
dos2unix: converting file gen_iface.py to Unix format ...

root@CubieTruck:~/wxWidgets-3.0.0# wx-config
bash: /usr/local/bin/wx-config: /bin/sh^M: bad interpreter: No such file or directory
root@CubieTruck:~/wxWidgets-3.0.0# ls -l /usr/local/bin/wx-config
lrwxrwxrwx 1 root root 41 Aug 12 22:56 /usr/local/bin/wx-config -> /usr/local/lib/wx/config/gtk2-unicode-3.0
root@CubieTruck:~/wxWidgets-3.0.0# dos2unix /usr/local/lib/wx/config/gtk2-unicode-3.0
dos2unix: converting file /usr/local/lib/wx/config/gtk2-unicode-3.0 to Unix format ...