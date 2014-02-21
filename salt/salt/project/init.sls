include:
    - db
    - www

git-core:
    pkg:
        - installed

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

{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}:
    user:
        - present
        - shell: /bin/bash
        - groups: {% templatetag openvariable %} pillar['groups'] {% templatetag closevariable %}
    ssh_auth:
        - present
        - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - source: salt://keys/id_dsa.pub
        - require:
            - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}

virtualenvwrapper:
    pip:
        - installed
        - require:
            - pip: virtualenv

/home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/.virtualenvs/{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}:
    virtualenv:
        - managed
        - no_site_packages: True
        - distribute: True
        - requirements: /home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/requirements/{% templatetag openvariable %} pillar['environment'] {% templatetag closevariable %}.txt
        - require:
            - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
            - pip: virtualenvwrapper
            - pkg: libpq-dev
            - pkg: python-dev
            - pkg: postgresql

/home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/.virtualenvs:
    file:
        - directory
        - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - group: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - mode: 775
        - recurse:
            - user
            - group
            - mode
        - require:
            - virtualenv: /home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/.virtualenvs/{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}

/home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/.virtualenvs/{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}/lib/python2.7/site-packages/_virtualenv_path_extensions.pth:
    file:
        - managed
        - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - group: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - mode: 600
        - source: salt://project/_virtualenv_path_extensions.pth
        - require:
            - pip: virtualenvwrapper
            - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - template: jinja
        - context:
            projectname: '{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}'
            projectroot: '{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}'
            username: '{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}'

/home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/.profile:
    file:
        - managed
        - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - group: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - mode: 664
        - source: salt://project/.profile
        - require:
            - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}

/home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/.bashrc:
    file:
        - managed
        - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - group: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - mode: 664
        - source: salt://project/.bashrc
        - template: jinja
        - require:
            - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - context:
            secret_key: 'my-secret-key-only-for-development'
            django_settings_module: '{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}.settings.{% templatetag openvariable %} pillar['environment'] {% templatetag closevariable %}'

/etc/nginx/sites-available/{% templatetag openvariable %} pillar['vhostname'] {% templatetag closevariable %}.conf:
    file:
        - managed
        - source: salt://project/vhost.conf
        - template: jinja
        - context:
            vhostname: '{% templatetag openvariable %} pillar['vhostname'] {% templatetag closevariable %}'
            projectname: '{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}'
            projectroot: '{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}'
            username: '{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}'
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
            username: '{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}'
            environment: '{% templatetag openvariable %} pillar['environment'] {% templatetag closevariable %}'
        - require:
            - pkg: nginx
            - pkg: supervisor
            - virtualenv: /home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/.virtualenvs/{% templatetag openvariable %} pillar['projectname'] {% templatetag closevariable %}

/home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/log:
    file:
        - directory
        - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - group: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - require:
            - file: /home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}
            - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}

/home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}:
    file:
        - directory
        - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - group: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - recurse:
            - user
            - group
        - require:
            - user: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}

/home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/log/nginx-access.log:
    file:
        - touch
        - require:
            - file: /home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/log

/home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/log/nginx-error.log:
    file:
        - touch
        - require:
            - file: /home/{% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}/{% templatetag openvariable %} pillar['projectroot'] {% templatetag closevariable %}/log

gunicorn:
    supervisord:
        - running
        - restart: False
        - require:
            - pkg: supervisor
            - file: /etc/supervisor/conf.d/gunicorn.conf

