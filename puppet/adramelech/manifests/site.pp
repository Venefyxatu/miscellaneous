
node 'adramelech' {
    import 'adramelech/*.pp'

    class { 'mysql::server':
      config_hash => {
        'root_password' => 'DB_ROOT_PASSWORD',
        'bind_address'  => '127.0.0.1',
        'default_engine' => 'MyISAM',
      },

     }
      database { 'test':
        ensure => absent
      }

    include common::packages

    include phenny::packages
    include phenny::configuration
    include phenny::bots

    include tech::database
    include tech::configuration
}
