projectname: '{{ project_name }}'
projectroot: '{{ project_name }}'
vhostname: 'www.{{ project_name }}.com'
{% templatetag openblock %} if 'productname' in grains and grains['productname'] == 'VirtualBox' {% templatetag closeblock %}
username: 'vagrant'
environment: 'vagrant'
groups: ['vagrant', 'adm', 'cdrom', 'sudo', 'dip', 'plugdev', 'lpadmin', 'sambashare', 'admin']
{% templatetag openblock %} else {% templatetag closeblock %}
username: '{{ project_name }}'
environment: 'production'
groups: {{ project_name }}
{% templatetag openblock %} endif {% templatetag closeblock %}
