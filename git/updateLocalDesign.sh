#!/usr/bin/env bash
#rsync --timeout=60 -azP -e 'ssh -p 8089' /opt/deploy/home/gitlab-runner/sntf/client/trunk/bin_debug sntf@localhost:/home/sntf/client && ssh -tt -p 8089 sntf@localhost 'bash devops/checkVersion.sh'
rsync --timeout=60 -azP -e 'ssh -p 8090' /opt/deploy/home/gitlab-runner/sntf/client/trunk/bin_debug sntf@localhost:/home/sntf/client && ssh -tt -p 8090 sntf@localhost 'bash devops/checkVersion.sh'
