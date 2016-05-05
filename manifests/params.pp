#
# fmw_wls::params
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_wls::params()
{
  $version       = '12.1.3' # 10.3.6|12.1.1|12.1.2|12.1.3|12.2.1
  $install_type  = 'wls' # infra or wls

  $os_user       = 'oracle'
  $os_user_uid   = '500'
  $os_group      = 'oinstall'
  $os_shell      = '/bin/bash'

  $user_home_dir = $::kernel? {
    'Linux'  => '/home',
    'SunOS'  => '/export/home',
    default  => '/home',
  }

  $middleware_home_dir = $::kernel? {
    'windows' => 'C:/oracle/middleware',
    default   => '/opt/oracle/middleware',
  }

  $ora_inventory_dir = $::kernel? {
    'windows' => 'C:\\Program Files\\Oracle\\Inventory',
    'SunOS'   => '/export/home/oracle/oraInventory',
    default   => '/home/oracle/oraInventory',
  }

  $tmp_dir = $::kernel? {
    'windows' => 'C:/temp',
    'SunOS'   => '/var/tmp',
    default   => '/tmp',
  }

  $orainst_dir = $::kernel? {
    'SunOS' => '/var/opt/oracle',
    default => '/etc',
  }
}
