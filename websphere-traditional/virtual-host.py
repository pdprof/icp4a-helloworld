AdminConfig.create('HostAlias', AdminConfig.getid('/Cell:DefaultCell01/VirtualHost:admin_host/'), '[[hostname "twas-admin-route-default.apps-crc.testing"] [port "80"]]')
AdminConfig.remove('(cells/DefaultCell01|virtualhosts.xml#HostAlias_2)')
AdminConfig.create('HostAlias', AdminConfig.getid('/Cell:DefaultCell01/VirtualHost:default_host/'), '[[hostname "twas-route-default.apps-crc.testing"] [port "80"]]')
AdminConfig.save()
