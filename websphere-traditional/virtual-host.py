print "set default-host..."
AdminConfig.create('HostAlias', AdminConfig.getid('/Cell:DefaultCell01/VirtualHost:admin_host/'), '[[hostname "twas-admin-route-default.apps-crc.testing"] [port "80"]]')
print "delete *:80..."
AdminConfig.remove('(cells/DefaultCell01|virtualhosts.xml#HostAlias_2)')
print "set admin-host..."
AdminConfig.create('HostAlias', AdminConfig.getid('/Cell:DefaultCell01/VirtualHost:default_host/'), '[[hostname "twas-route-default.apps-crc.testing"] [port "80"]]')
print "save..."
AdminConfig.save()
