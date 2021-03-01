How To Install Nagios 4.4.x on Debian 9 Stretch

    apt update 

libgd2-xpm-dev
    apt install -y build-essential apache2 php openssl perl make php-gd libapache2-mod-php libperl-dev libssl-dev daemon wget apache2-utils unzip
    
    
    useradd nagios
    groupadd nagcmd
    usermod -a -G nagcmd nagios
    usermod -a -G nagcmd www-data


    cd /tmp 
    wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.3.tar.gz
    tar -zxvf nagios-4.4.3.tar.gz 
    cd /tmp/nagios-4.4.3/
    


    ./configure --with-nagios-group=nagios --with-command-group=nagcmd --with-httpd_conf=/etc/apache2/sites-enabled/
    make all
    make install
    make install-init
    make install-config
    make install-commandmode
    make install-webconf

ln -s /etc/apache2/conf-available/mysite.conf /etc/apache2/conf-enabled/mysite.conf
/usr/local/apache/conf/httpd.conf

    cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
    chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers

Configure Nagios
The installer has now placed configuration files in the /usr/local/nagios/etc directory. You don’t need to modify Nagios configuration files for now to start Nagios monitoring tool.

All you need is to update email address in the /usr/local/nagios/etc/objects/contacts.cfg file for nagiosadmin before you start the Nagios server.


vi /usr/local/nagios/etc/objects/contacts.cfg
Change to the email address of your choice to receive the notification.


    define contact{
    contact_namenagiosadmin ; Short name of user
    use generic-contact ; Inherit default values from generic-contact template (defined above)
    alias   Nagios Admin; Full name of user
    
    email   nagios@itzgeek.com  ; <<***** CHANGE THIS TO YOUR EMAIL ADDRESS ******
    
    }


Configure Nagios Web Interface
Create a user nagiosadmin account for logging into the Nagios web interface. Remember the password you assign to user nagiosadmin – you’ll need it later.

    htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
To enable CGI, run:

    a2enmod cgi
Restart Apache web service to make the new settings take effect.

    systemctl restart apache2


# **Install Nagios Plugins** #

Now, it’s time to download and install Nagios plugins for monitoring the services.

    cd /tmp
    wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
    tar -zxvf /tmp/nagios-plugins-2.2.1.tar.gz
    cd /tmp/nagios-plugins-2.2.1/

Compile and install the plugins.

    ./configure --with-nagios-user=nagios --with-nagios-group=nagios
    make
    make install

Start Nagios Server
Verify the sample Nagios configuration files.

/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
Output:

Nagios Core 4.4.3
Copyright (c) 2009-present Nagios Core Development Team and Community Contributors
Copyright (c) 1999-2009 Ethan GalstadInstall Nagios Plugins
Last Modified: 2019-01-15
License: GPL

Website: https://www.nagios.org
Reading configuration data...
   Read main config file okay...
   Read object config files okay...

Running pre-flight check on configuration data...

Checking objects...
        Checked 8 services.
        Checked 1 hosts.
        Checked 1 host groups.
        Checked 0 service groups.
        Checked 1 contacts.
        Checked 1 contact groups.
        Checked 24 commands.
        Checked 5 time periods.
        Checked 0 host escalations.
        Checked 0 service escalations.
Checking for circular paths...
        Checked 1 hosts
        Checked 0 service dependencies
        Checked 0 host dependencies
        Checked 5 timeperiods
Checking global event handlers...
Checking obsessive compulsive processor commands...
Checking misc settings...

Total Warnings: 0
Total Errors:   0

Things look okay - No serious problems were detected during the pre-flight check
Start Nagios monitoring tool using the following command.

systemctl start nagios
Enable Nagios to start automatically at the system startup.

systemctl enable nagios
Firewall
Configure the firewall so that the Nagios Web Interface can be accessible from external machines.

FirewallD
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload
systemctl restart firewalld
UFW
ufw allow 80/tcp
ufw reload
ufw enable
Access Nagios Web Interface
Now, go and access the Nagios web interface using the below URL.

http://ip-add-re-ss/nagios/
The browser will prompt you to enter the username nagiosadmin and the password you specified earlier.

Click the Services link in the left pane to see the services being monitored by Nagios.


![](https://www.itzgeek.com/wp-content/uploads/2017/06/Install-Nagios-4.4.x-on-Debian-9-Monitoring-Services-With-Nagios-1024x597.jpg)
