#! /bin/bash
set -x
set -e
PROJECT=$USER
BRANCH=$1
SERVERS=/opt/deploy/products/$PROJECT/servers
sourcePath=$SERVERS/$BRANCH
configPaht=$SERVERS/$BRANCH/config
resourcePath=$SERVERS/$BRANCH/resource
updatePaths=( $sourcePath $configPaht $resourcePath )
for path in ${updatePaths[@]};
do
    git -C $path reset --hard
    git -C $path checkout $BRANCH
    git -C $path pull
done
pm2 l | grep $BRANCH | grep -v master | awk '{cmd="pm2 restart "$4";"; print cmd; system(cmd);}'
echo "update server done. "$BRANCH
