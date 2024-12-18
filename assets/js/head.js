---
dir_path: js/
scripts:
  - initial.js
  - gwern_sidenotes.js
---
{% for script in scripts %}
    {% assign script_path = dir_path | append: script %}
    {% include_relative script_path %}
{% endfor %}
