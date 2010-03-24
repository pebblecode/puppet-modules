# Class: postfix::mysql
#
# This class sets up a Postfix with Mysql backend.
# The configurations used follow the standards set and necessary by the software postfixadmin
# Postfix Admin homepage: http://sourceforge.net/projects/postfixadmin/
# You mayb need to include postfix::postfixadmin to set up the Postfix Admin web interface

# PREREQUISITES
# You need to set the following variables (here with example values)
# $postfix_mysqluser = "postfix"
# $postfix_mysqlpassword = "example42"
# $postfix_mysqlhost = "127.0.0.1"
# $postfix_mysqldbname = "postfix"
# $postfix_mynetworks = $network/$netmask
#
# You may have these components on separated servers or included on the same host
# Postfix (with Mysql support): include postfix::mysql
# Mysql: include mysql
# Apache+PHP+PostfixAdmin Web interface with Mysql support: include postfix::postfixadmin



class postfix::mysql inherits postfix::base {

        File["main.cf"] {
                content => template("postfix/main.cf-mysql"),
        }

        package { postfix-mysql:
                name   => $operatingsystem ? {
                        default => "postfix-mysql",
                        },
                ensure => $operatingsystem ? {
                        debian  => "present",
                        ubuntu  => "present",
                        default => "absent",
                        },
        }

        file {
                "mysql_virtual_alias_maps.cf":
                mode => 644, owner => root, group => root,
                require => File["main.cf"],
                ensure => present,
                path => $operatingsystem ?{
                        default => "/etc/postfix/mysql_virtual_alias_maps.cf",
                        },
                content => template("postfix/mysql_virtual_alias_maps.cf"),
        }

        file {
                "mysql_virtual_domains_maps.cf":
                mode => 644, owner => root, group => root,
                require => File["main.cf"],
                ensure => present,
                path => $operatingsystem ?{
                        default => "/etc/postfix/mysql_virtual_domains_maps.cf",
                        },
                content => template("postfix/mysql_virtual_domains_maps.cf"),
        }

        file {
                "mysql_virtual_mailbox_maps.cf":
                mode => 644, owner => root, group => root,
                require => File["main.cf"],
                ensure => present,
                path => $operatingsystem ?{
                        default => "/etc/postfix/mysql_virtual_mailbox_maps.cf",
                        },
                content => template("postfix/mysql_virtual_mailbox_maps.cf"),
        }

        file {
                "mysql_virtual_mailbox_limit_maps.cf":
                mode => 644, owner => root, group => root,
                require => File["main.cf"],
                ensure => present,
                path => $operatingsystem ?{
                        default => "/etc/postfix/mysql_virtual_mailbox_limit_maps.cf",
                        },
                content => template("postfix/mysql_virtual_mailbox_limit_maps.cf"),
        }

        file {
                "mysql_virtual_relay_domains_maps.cf":
                mode => 644, owner => root, group => root,
                require => File["main.cf"],
                ensure => present,
                path => $operatingsystem ?{
                        default => "/etc/postfix/mysql_virtual_relay_domains_maps.cf",
                        },
                content => template("postfix/mysql_virtual_relay_domains_maps.cf"),
        }

        file {
                "/usr/local/virtual":
                mode => 770, owner => postfix, group => postfix,
                require => [ Package["postfix"] , File["main.cf"] ],
                ensure => directory,
        }

}