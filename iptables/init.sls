{% from 'iptables/map.jinja' import iptables with context %}
{% from 'iptables/macros.jinja' import sls_block with context %}

{% for pkg in iptables.packages %}
{{ pkg }}:
  pkg.installed:
    - name: {{ pkg }}
{% endfor %}

{% for table in ['filters', 'nat'] %}
{%- for rule in iptables[table] %}
iptables_{{ table }}_{{ loop.index}}:
  iptables.append:
    - table: {{ table }}
    {{ sls_block(rule) | indent(4) }}
    - save: true
{%- endfor %}
{% endfor %}
