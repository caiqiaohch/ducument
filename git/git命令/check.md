#!/usr/bin/env bash
cd /opt/deploy/products/sntf/clients/design/bin-debug && grep 'version' config.js | awk -F',' '{print $1}'

sntf@VM-0-9-ubuntu:~/devops/client$ cat deployDesign.sh
#!/usr/bin/env bash
#cd /opt/deploy/products/sntf/clients && cp -r /opt/deploy/home/gitlab-runner/sntf/client/bin_debug/* design && /opt/deploy/products/sntf/devops/bin/checkDesignVersion
cd /opt/deploy/products/sntf/clients && rsync -aP /opt/deploy/home/gitlab-runner/sntf/client/trunk/bin_debug/ design && /opt/deploy/products/sntf/devops/bin/checkDesignVersion

sntf@VM-0-9-ubuntu:~/devops/client$ cat deploySDK.sh
#!/usr/bin/env bash
cd /opt/deploy/products/sntf/clients && rsync -aP /home/ubuntu/bin_sdk/ sdk
sntf@VM-0-9-ubuntu:~/devops/client$ cat deploywxxl.sh
#!/usr/bin/env bash
cd /opt/deploy/products/sntf/clients && rsync -aP /home/ubuntu/bin_wxxl/ wxxl
