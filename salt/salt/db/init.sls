postgresql:
    pkg:
        - installed
    service:
        - running
        - require:
            - pkg: postgresql
    postgres_user:
        - name: {{ pillar['username'] }}
        - present
        - createdb: True
        - createuser: False
        - superuser: False
        - runas: postgres
        - require:
            - pkg: postgresql
    postgres_database:
        - present
        - owner: {{ pillar['username'] }}
        - name: {{ pillar['username'] }}
        - require:
            - pkg: postgresql
            - postgres_user: postgresql
