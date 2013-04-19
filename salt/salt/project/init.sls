include:
    - db
    - www

libpq-dev:
    pkg:
        - installed

python-dev:
    pkg:
        - installed

python-pip:
    pkg:
        - installed

supervisor:
    pkg:
        - installed

virtualenv:
    pip:
        - installed
        - require:
            - pkg: python-pip

virtualenvwrapper:
    pip:
        - installed
        - require:
            - pip: virtualenv

/home/vagrant/.virtualenvs/{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}:
    virtualenv:
        - managed
        - no_site_packages: True
        - distribute: True
        - requirements: /home/vagrant/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/requirements/vagrant.txt
        # - runas: vagrant
        - require:
            - pip: virtualenvwrapper
            - pkg: libpq-dev
            - pkg: python-dev
            - pkg: postgresql

/home/vagrant/.virtualenvs:
    file:
        - directory
        - user: vagrant
        - group: vagrant
        - mode: 775
        - recurse:
            - user
            - group
            - mode
        - require:
            - virtualenv: /home/vagrant/.virtualenvs/{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}

/home/vagrant/.virtualenvs/{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}/lib/python2.7/site-packages/_virtualenv_path_extensions.pth:
    file:
        - managed
        - user: vagrant
        - group: vagrant
        - mode: 600
        - source: salt://project/_virtualenv_path_extensions.pth
        - require:
            - pip: virtualenvwrapper
        - template: jinja
        - context:
            projectname: '{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}'
            projectroot: '{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}'

/home/vagrant/.profile:
    file:
        - managed
        - user: vagrant
        - group: vagrant
        - mode: 664
        - source: salt://project/.profile
        - template: jinja
        - context:
            secret_key: 'my-secret-key-only-for-development'
            django_settings_module: '{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}.settings.vagrant'

/etc/nginx/sites-available/{% templatetag openvariable %} pillar['vhostname'] {% templatetag closevariable %}.conf:
    file:
        - managed
        - source: salt://project/vhost.conf
        - template: jinja
        - context:
            vhostname: '{% templatetag openvariable %} pillar['vhostname'] {% templatetag closevariable %}'
            projectname: '{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}'
            projectroot: '{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}'
        - require:
            - pkg: nginx

/etc/nginx/sites-enabled/{% templatetag openvariable %} pillar['vhostname'] {% templatetag closevariable %}.conf:
    file:
        - symlink
        - target: /etc/nginx/sites-available/{% templatetag openvariable %} pillar['vhostname'] {% templatetag closevariable %}.conf
        - require:
            - file: /etc/nginx/sites-available/{% templatetag openvariable %} pillar['vhostname'] {% templatetag closevariable %}.conf
            - file: /home/vagrant/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/log/nginx-access.log
            - file: /home/vagrant/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/log/nginx-error.log

/etc/nginx/sites-enabled/default:
    file:
        - absent
        - target: /etc/nginx/sites-available/default

/etc/supervisor/conf.d/gunicorn.conf:
    file:
        - managed
        - source: salt://project/gunicorn.conf
        - template: jinja
        - context:
            projectname: '{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}'
            projectroot: '{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}'
            secret_key: 'my-secret-key-only-for-development'
            django_settings_module: '{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}.settings.vagrant'
        - require:
            - pkg: nginx
            - pkg: supervisor
            - virtualenv: /home/vagrant/.virtualenvs/{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}

/home/vagrant/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/log:
    file:
        - directory
        - user: vagrant
        - group: vagrant

/home/vagrant/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/log/nginx-access.log:
    file:
        - touch
        - require:
            - file: /home/vagrant/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/log

/home/vagrant/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/log/nginx-error.log:
    file:
        - touch
        - require:
            - file: /home/vagrant/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/log

gunicorn:
    supervisord:
        - running
        - restart: False
        - require:
            - pkg: supervisor
            - file: /etc/supervisor/conf.d/gunicorn.conf
