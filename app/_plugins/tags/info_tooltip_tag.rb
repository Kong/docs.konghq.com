# frozen_string_literal: true

module Jekyll
  class InfoToolTipTag < Liquid::Block
    def render(_context)
      contents = super
      <<~TAG
        <span class="badge" style="vertical-align: revert; margin-left: 3px;">
        <i class="fa fa-question-circle"></i>
        <div class="tooltip"><span class="tooltiptext" style="width: 300px;">#{contents.strip}</span></div>
        </span>
      TAG
    end
  end
end

Liquid::Template.register_tag('info_tooltip', Jekyll::InfoToolTipTag)
