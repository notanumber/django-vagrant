postgresql:
    pkg:
        - installed
    service:
        - running
        - require:
            - pkg: postgresql
    postgres_user:
        - name: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - present
        - createdb: True
        - createuser: False
        - superuser: False
        - runas: postgres
        - require:
            - pkg: postgresql
    postgres_database:
        - present
        - owner: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - name: {% templatetag openvariable %} pillar['username'] {% templatetag closevariable %}
        - require:
            - pkg: postgresql
            - postgres_user: postgresql
