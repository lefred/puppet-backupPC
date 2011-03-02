# Class: backupPC
#
# This module manages backupPC
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class backupPC {

    @user { "backuppc":
        ensure  => "present",
        uid     => 101,
        gid     => "backuppc",
        comment => "backuppc user",
        home    => "/var/lib/BackupPC",
        shell   => "/bin/bash",
        managehome => true,
    }

    @ssh_authorized_key { "backuppc_main":
       ensure  => "present",
       user    => "backuppc",
       type    => "ssh-rsa",
       require => User["backuppc"],
       key     => 'put the key here',
    }

    package {
        "BackupPC":
            ensure => "installed"
    }
    
    file { "/etc/BackupPC/":
               source => "puppet:///backup/$hostname/",
               sourceselect => all,
               mode    => 0644,
               owner   => "backuppc",
               group   => "backuppc",               
               recurse => true,
               purge => false,
               replace => true,
               require => Package["BackupPC"],
    }
    
    file {
        "/etc/BackupPC/apache.users":
               source => "puppet:///backup/apache.users",
               require => Package["BackupPC"],
    }

    file {
        "/etc/BackupPC/config.pl":
               content => template("backupPC/config.pl.erb"),
               require => Package["BackupPC"],
               notify  =>  Service["backuppc"],
    }
    
    file {
        "/etc/httpd/conf.d/BackupPC.conf":
               source => "puppet:///backup/BackupPC.conf",
               require => Package["BackupPC"],
               notify  => Service["httpd"];
    }

    file {
        "/etc/BackupPC/hosts":
               source => [
                            "puppet:///backup/$hostname/hosts",
                            "puppet:///backup/default/hosts",
                         ],
               require => Package["BackupPC"],
               notify  => Service[backuppc];
    }

    file {
        "/etc/BackupPC/pc/":
               source => [
                            "puppet:///backup/$hostname/pc/",
                            "puppet:///backup/default/pc/",
                         ],
               require => Package["BackupPC"],
               sourceselect => all,
               mode    => 0644,
               owner   => "backuppc",
               group   => "backuppc",
               recurse => true,
               purge => false,
               replace => true,
               notify  => Service["backuppc"];
    }

    
    service {
        "backuppc":
            ensure => running,
            enable => true,
            require => Package["BackupPC"]
    }
    
    service {
        "httpd":
            ensure => running,
            enable => true,
            require => Package["BackupPC"]
    }
    
    realize(
            User["backuppc"],
            Ssh_authorized_key["backuppc_main"],
    )


}
