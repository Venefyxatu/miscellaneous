pg_user {'openerp':
    ensure   => present,
    password => 'PASSWORD_HERE',
    createdb => true,
}
