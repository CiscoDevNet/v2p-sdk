#!/bin/sh

#
# Application install script template.
#
# Command line arguements:
#
# --apprepourls <Application URLs list>   (Comma-separated list of URL strings)
# --sysrepoids  <System Repo ID list>     (Comma-separated list of ID strings)
# --appver  <Application version> 
# --rolever <Role version>
#

# Validate parameters
V2PPATH="/opt/cisco/v2p/v2pc/script/v2p-vm-mgr"
${V2PPATH}/v2pValidateWorkerParams.py $@
if [ $? -ne 0 ]; then
    echo "ERROR: Invalid command line arguements; exiting ..."
    exit 1
fi

# Pickup params
VENDORID=v2pc_learning_lab
APPID=aic_104
ROLEID=nginx

# Extract application repo URLs.
# Application URLs are formatted as follows:
# http://$repoVmIp/$VENDORID/aic/$APPID/$appver/$ROLEID/$rolever
#
declare -a appRepoUrls=$(${V2PPATH}/v2pGetWorkerParam.py "apprepourls")

# Extract system repo IDs.
# Each system repo ID corresponds to the worker node's 
# "imageTag" system repo list (e.g., third-party RPM list).
#
declare -a sysRepoIds=$(${V2PPATH}/v2pGetWorkerParam.py "sysrepoids")

# Configure yum to point to $APPID-$ROLEID repo
sudo cat << app-install-repo > /tmp/$APPID-$ROLEID-install.repo
[$APPID-$ROLEID]
name=$APPID-$ROLEID
baseurl=${appRepoUrls[0]}
enabled=1
gpgcheck=0
app-install-repo
sudo cp -f /tmp/$APPID-$ROLEID-install.repo /etc/yum.repos.d/

# Install nginx RPMs
sudo yum -y -v --disablerepo=* --enablerepo=$APPID-$ROLEID,${sysRepoIds[0]},${sysRepoIds[1]} install nginx

# Enable and Start nginx
sudo systemctl enable nginx
