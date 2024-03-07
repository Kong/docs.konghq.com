require 'byebug'
require 'liquid'

template =<<~STRING
  {% ifversion gte:3.5.x %}
  this is a line of code
  another line
  and another one
  ok, last one
  just kidding
  {% else %}
  elsseeee
  elseeeee
  {%endifversion%}
STRING

p Liquid::Template.parse(template).render
