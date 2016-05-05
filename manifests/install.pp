#
# fmw_wls::install
#
# Copyright 2015 Oracle. All Rights Reserved
#
class fmw_wls::install(
  $java_home_dir   = undef,
  $source_file     = undef,
  $install_type    = $fmw_wls::params::install_type,
) inherits fmw_wls::params {

  require fmw_wls

  unless $::kernel in ['windows', 'Linux', 'SunOS'] {
    fail('Not supported Operation System, please use it on windows, linux or solaris host')
  }
  if ( $java_home_dir == undef or is_string($java_home_dir) == false ) {
    fail("java_home_dir parameter cannot be empty ${java_home_dir}")
  }
  if ( $source_file == undef or is_string($source_file) == false ) {
    fail('source_file parameter cannot be empty')
  }

  require fmw_jdk::install

  if $::kernel == 'Linux' {
    class{'fmw_wls::internal::wls_linux':
      java_home_dir => $java_home_dir,
      source_file   => $source_file,
      install_type  => $install_type,
    }
    contain fmw_wls::internal::wls_linux
  } elsif $::kernel == 'SunOS' {
    class{'fmw_wls::internal::wls_solaris':
      java_home_dir => $java_home_dir,
      source_file   => $source_file,
      install_type  => $install_type,
    }
    contain fmw_wls::internal::wls_solaris
  } elsif $::kernel == 'windows' {
    class{'fmw_wls::internal::wls_windows':
      java_home_dir => $java_home_dir,
      source_file   => $source_file,
      install_type  => $install_type,
    }
    contain fmw_wls::internal::wls_windows
  }
}
