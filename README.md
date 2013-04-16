Django-Vagrant
==============

Django-Vagrant aims to be a quick way to get up and running with a new Django project in a Virtualbox built with Vagrant and Salt.  Out of the box, it provides a pre-configured Nginx installation setup to proxy requests to Django via Gunicorn and includes a pre-configured Postgresql installation as well.  Supervisor is used to monitor Gunicorn.

The packages should be easily extensible to include extra software by adding new Salt states as required and doing a `vagrant reload` or adding Python based dependencies to one of the targetted requirements files.  By default, 'requirements/vagrant.txt' contains all of the Python dependencies (such as Django) in use on the Vagrant box.  There are also requirements files that target production and local environments exclusively, as well as a common requirements file for any requirement that should always be met.

For ease of use, all Python dependencies are installed to a virtualenv, managed by virtualenvwrapper, with the same name as your project.

Getting Started
---------------

Assuming a pre-existing django-admin.py on your path, execute a variant of the following to build your new project:

    django-admin.py startproject --template=https://github.com/notanumber/django_vagrant/archive/master.zip <my_project> --name=Vagrantfile --extension=py --extension=sls


This should result in a source tree like:

    project_name
              |
              +--docs
              +-- log
              +-- project_name
              | |
              | +-- assets
              | | |
              | | +-- css
              | | +-- img
              | | +-- js
              | |
              | +-- media
              | +-- project_name
              | | |
              | | +-- settings
              | | | |
              | | | +- __init__.py
              | | | +- base.py
              | | | +- local.py
              | | | +- production.py
              | | | +- vagrant.py
              | | |
              | | +-- __init__.py
              | | +-- urls.py
              | | +-- wsgi.py
              | |
              | +-- templates
              | +-- __init__.py
              |
              +-- requirements
              | |
              | +-- common.txt
              | +-- local.txt
              | +-- production.txt
              | +-- vagrant.txt
              |
              +-- salt
              | |
              | +-- pillar
              | | |
              | | +-- db.sls
              | | +-- project.sls
              | | +-- top.sls
              | |
              |  -- salt
              | | |
              | | +-- db
              | | | |
              | | | +-- init.sls  
              | | |
              | | +-- project
              | | | |
              | | | +-- .profile  
              | | | +-- _virtualenv_path_extensions.pth
              | | | +-- gunicorn.conf
              | | | +-- init.sls
              | | | +-- vhost.conf  
              | | |
              | | +-- www
              | | | |
              | | | +-- init.sls  
              | |
              | +-- minion.conf
              |
              +-- README
              +-- requirements.txt
              +-- Vagrantfile

Once you have the project layout in place, simply issue the `vagrant up` command to have Vagrant provision your server.  This should take a few minutes, but once it's done, you can access your new server at 'localhost:8080' in your browser!

Requirements
------------

Django-Vagrant has the following requirements.  Versions used in testing are noted alongside.

- `Virtualbox 4.2.12 - https://www.virtualbox.org/<https://www.virtualbox.org/>`
- `Vagrant 1.2.0 - http://www.vagrantup.com/<http://www.vagrantup.com/>`
- `Vagrant-salt 0.4.0 - https://github.com/saltstack/salty-vagrant<https://github.com/saltstack/salty-vagrant>`

Any other requirements should be installed automatically by Salt during the provisioning of the Virtualbox.
