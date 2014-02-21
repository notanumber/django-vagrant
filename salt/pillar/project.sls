projectname: '{{ project_name }}'
projectroot: '{{ project_name }}'
vhostname: 'www.{{ project_name }}.com'
{% if 'productname' in grains and grains['productname'] == 'VirtualBox' %}
username: 'vagrant'
environment: 'vagrant'
groups: ['vagrant', 'adm', 'cdrom', 'sudo', 'dip', 'plugdev', 'lpadmin', 'sambashare', 'admin']
{% else %}
username: '{{ project_name }}'
environment: 'production'
groups: {{ project_name }}
{% endif %}
