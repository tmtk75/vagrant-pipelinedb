class pipelinedb {

  include install
  include config
  include service
  Class[install] -> Class[config] -> Class[service]

}

class pipelinedb::install {

  package { pipelinedb:
    ensure   => installed,
    provider => rpm,
    source   => "https://s3-us-west-2.amazonaws.com/download.pipelinedb.com/pipelinedb-0.8.4-centos7-x86_64.rpm",
  }

}

class pipelinedb::config {

  file { "/var/lib/pipelinedb":
    ensure => directory,
    owner  => vagrant,
    group  => vagrant,
  }

  -> exec { "pipeline-init":
    command => "/usr/bin/pipeline-init -D /var/lib/pipelinedb",
    creates => "/var/lib/pipelinedb/PG_VERSION",
    user    => vagrant,
  }

  -> file { "/etc/sysconfig/pipelinedb":
    content => template("pipelinedb/sysconfig.erb"),
  }

  -> file { "/var/lib/pipelinedb/pipelinedb.conf":
    content => template("pipelinedb/pipelinedb.conf.erb"),
  }

  -> file { "/var/lib/pipelinedb/pg_hba.conf":
    content => template("pipelinedb/pg_hba.conf.erb"),
  }

  file { "/var/log/pipelinedb":
    ensure => directory,
    owner  => vagrant,
    group  => vagrant,
  }

  file { "/etc/systemd/system/pipelinedb.service":
    content => file("pipelinedb/pipelinedb.service"),
  }

  exec { "daemon-reload":
    command   => "/usr/bin/systemctl daemon-reload",
    subscribe => File["/etc/systemd/system/pipelinedb.service"],
  }
}

class pipelinedb::service {

  service { pipelinedb:
    ensure => running,
    enable => true,
  }

}
