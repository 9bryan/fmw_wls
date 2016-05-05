# fmw_wls

#### Table of Contents

1. [Overview - What is the fmw_wls module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with fmw_wls](#setup)
4. [Usage - The manifests available for configuration](#usage)
    * [Manifests](#manifests)
        * [Manifest: init](#manifest-init)
        * [Manifest: setup](#manifest-setup)
        * [Manifest: install](#manifest-install)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
    * [Contributing to the fmw_wls module](#contributing)
    * [Running tests - A quick guide](#running-tests)

## Overview

The fmw_wls module allows you to install Oracle WebLogic on a Windows, Linux or Solaris host.

## Module description

This modules allows you to install any WebLogic 11g (10.3.6, 12.1.1) or 12c (12.1.2, 12.1.3, 12.2.1 ) version on any Windows, Linux or Solaris host or VM.

## Setup

Add this module to your puppet environment modules folder

## Usage

### Manifests

#### Manifest init

This is an manifest for overriding the defaults

    class { 'fmw_wls':
      version             => '12.1.3',
      middleware_home_dir => '/opt/oracle/middleware',
      ora_inventory_dir   => '/home/oracle/oraInventory',
      orainst_dir         => '/etc',
      os_user             => 'oracle',
      os_user_uid         => '500',
      os_group            => 'oinstall',
      os_shell            => '/bin/bash',
      user_home_dir       => '/home',
      tmp_dir             => '/tmp',
    }

with all the defaults

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
        default   => '/tmp',
      }

      $orainst_dir = $::kernel? {
        'SunOS' => '/var/opt/oracle',
        default => '/etc',
      }
    }

#### Manifest setup

This optional step to make sure your host it's ready for installing WebLogic, like creating the webLogic operating user and group on a linux or solaris host.

    class { 'fmw_wls::setup': }

#### Manifest install

This will install the webLogic on a host and has a dependency with the fmw_jdk::install manifest

    include fmw_jdk::rng_service

    $java_home_dir = '/usr/java/jdk1.7.0_75'

    Class['fmw_wls::setup'] ->
      Class['fmw_wls::install']

    class { 'fmw_jdk::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/jdk-7u75-linux-x64.tar.gz',
    }

    # can be removed when all the default are used.
    class { 'fmw_wls':
      version             => '12.1.3',  # this is also the default
      middleware_home_dir => '/opt/oracle/middleware', # this is the default for linux and solaris
    }

    include fmw_wls::setup

    # this requires fmw_jdk::install
    class { 'fmw_wls::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/fmw_12.1.3.0.0_infrastructure.jar',
      install_type  => 'infra', # 'wls' is the default
    }

or in hiera

    # executed manifest classes
    classes:
      - fmw_jdk::rng_service
      - fmw_jdk::install
      - fmw_wls::setup
      - fmw_wls::install

    # general variables
    java_home_dir:                   &java_home_dir     '/usr/java/jdk1.7.0_75'

    # class parameters
    fmw_jdk::install::java_home_dir: *java_home_dir
    fmw_jdk::install::source_file:   '/software/jdk-7u75-linux-x64.tar.gz'

    fmw_wls::version:                '12.1.3'                 # this is also the default
    fmw_wls::middleware_home_dir:    '/opt/oracle/middleware' # this is the default for linux and solaris

    fmw_wls::install::java_home_dir: *java_home_dir
    fmw_wls::install::source_file:   '/software/fmw_12.1.3.0.0_infrastructure.jar'
    fmw_wls::install::install_type:  'infra'                  # 'wls' is the default

Windows

    $java_home_dir = 'c:\\java\\jdk1.7.0_75'

    class { 'fmw_jdk::install':
      java_home_dir => $java_home_dir,
      source_file   => 'c:\\software\\jdk-7u75-windows-x64.exe',
    }

    # can be removed when all the default are used.
    class { 'fmw_wls':
      version             => '10.3.6',
      middleware_home_dir => 'C:\\Oracle\\middleware_1036',
    }

    # this requires fmw_jdk::install
    class { 'fmw_wls::install':
      java_home_dir => $java_home_dir,
      source_file   => 'c:\\software\\wls1036_generic.jar',
    }

Solaris ( tar.gz or tar.Z SVR4 package)

    $java_home_dir = '/usr/jdk/instances/jdk1.7.0_75'

    Class['fmw_wls::setup'] ->
      Class['fmw_wls::install']

    class { 'fmw_jdk::install':
      java_home_dir   => $java_home_dir,
      source_file     => '/software/jdk-7u75-solaris-i586.tar.gz',
      source_x64_file => '/software/jdk-7u75-solaris-x64.tar.gz',
    }

    # can be removed when all the default are used.
    class { 'fmw_wls':
      version             => '12.1.3',  # this is also the default
      middleware_home_dir => '/opt/oracle/middleware', # this is the default for linux and solaris
    }

    include fmw_wls::setup

    # this requires fmw_jdk::install
    class { 'fmw_wls::install':
      java_home_dir => $java_home_dir,
      source_file   => '/software/fmw_12.1.3.0.0_infrastructure.jar',
      install_type  => 'infra', # 'wls' is the default
    }

## Limitations

This should work on Windows, Solaris, Linux (Any RedHat or Debian platform family distribution)

## Development

### Contributing

Community contributions are essential for keeping them great. We want to keep it as easy as possible to contribute changes so that our cookbooks work in your environment. There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

### Running-tests

This project contains tests for puppet-lint, puppet-syntax, puppet-rspec, rubocop and beaker. For in-depth information please see their respective documentation.

Quickstart:

    yum install -y ruby-devel gcc zlib-devel libxml2 libxslt
    yum install -y libxml2-devel libxslt-devel
    gem install bundler -v 1.7.15 --no-rdoc --no-ri

    bundle install --without development

    bundle exec rake syntax
    bundle exec rake lint
    # symbolic error under windows , https://github.com/mitchellh/vagrant/issues/713#issuecomment-13201507. start vagrant in admin cmd session
    bundle exec rake spec
    bundle exec rubocop

    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true bundle exec rspec spec/acceptance
    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true BEAKER_set=centos-70-x64 bundle exec rspec spec/acceptance
    SOFTWARE_FOLDER=/software BEAKER_destroy=onpass BEAKER_debug=true BEAKER_set=debian-78-x64 bundle exec rspec spec/acceptance

    # Ruby on Windows
    use only 32-bits, its more stable, http://rubyinstaller.org/downloads/

    Ruby 2.0.0-p598 to C:\Ruby\200
    Ruby Development kit to C:\Ruby\2_devkit, so you can optionally build your gems

    set PATH=%PATH%;C:\Ruby\200\bin
    C:\Ruby\2_devkit\devkitvars.bat
    ruby -v

    set SOFTWARE_FOLDER=c:/software
    set BEAKER_destroy=onpass
    set BEAKER_debug=true
    set BEAKER_set=debian-78-x64
    set BEAKER_set=win-2012r2-standard
    bundle exec rspec spec/acceptance

