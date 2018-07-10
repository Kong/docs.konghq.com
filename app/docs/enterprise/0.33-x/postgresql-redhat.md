---
title: Installing PostgreSQL on RedHat
---

# Installing PostgreSQL on RedHat

The Kong [installation instructions for RedHat](/install/redhat/) focus on Kong. These instructions add some additional steps to get PostgreSQL setup. These exact installation steps come from an EC2 instance of RedHat Enterprise Linux 7, but can be generally applied to most Linux releases as well.

As the ec2 default user run the following:

```bash
sudo yum install postgresql94 postgresql94-server
sudo /usr/pgsql-9.4/bin/postgresql94-setup initdb
sudo systemctl enable postgresql-9.4
sudo systemctl start postgresql-9.4
sudo -i -u postgres (this drops you into a new shell)
# psql
> CREATE USER kong; CREATE DATABASE kong OWNER kong; ALTER USER kong WITH password 'kong';
> \q
# exit
```

Change “ident" to “md5"

```bash
sudo vi /var/lib/pgsql/9.4/data/pg_hba.conf
```

The configuration line will look like this:

```
host all all 127.0.0.1/32 md5
```

Restart PostgreSQL

```
sudo systemctl restart postgresql-9.4.service
```

Continue with the "migrations up" step from the Kong install instructions.
