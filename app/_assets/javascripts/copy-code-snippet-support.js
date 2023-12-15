/**
 * Copy code snippet support
 *
 * By default copy code is enabled for all code blocks. If you want disable it for specific page use class 'no-copy-code' in Front Matter:
 * ---
 * class: no-copy-code
 * ---
 * Additionally, you can still enable it for specific code block using the Inline Attribute as can be seen on the following example:
 *
 * ```bash
 * $ curl -X GET http://kong:8001/basic-auths
 * ```
 * {: .copy-code-snippet data-copy-code="curl -X GET http://kong:8001/basic-auths" }
 *
 * where:
 * data-copy-code="{custom-code}" - (optional) can be used to specify {custom-code} to be copied (only single-line text is supported)
 *
 */
jQuery(function () {
  const copyInput = $('<textarea id="copy-code-input"></textarea>');
  $("body").append(copyInput);
  $(".copy-code-snippet, pre > code").each(function (index, element) {
    function findSnippetElement() {
      const $code = $(element);
      let snippet = $code
        .parent("pre")
        .parent(".highlight")
        .parent(".highlighter-rouge");
      if (snippet.length > 0) {
        return snippet;
      }
      snippet = $code.parent("pre").parent(".highlight");
      if (snippet.length > 0) {
        return snippet;
      }
      snippet = $code.parent("pre");
      if (snippet.length > 0) {
        return snippet;
      }
      return $code;
    }

    const noCode = $("div.page.no-copy-code").length > 0;
    const snippet = findSnippetElement();

    if (!snippet.hasClass("copy-code-snippet") && noCode) {
      return;
    }

    snippet.addClass("copy-code-snippet");

    const action = $('<i class="copy-action fa fa-copy"></i>');
    action.on("click", function () {
      if ($("#copy-code-success-info").length > 0) {
        return;
      }

      copyInput.text(
        snippet.data("copy-code") ||
          snippet
            .find("code")
            .text()
            .replace(/^ /gim, "")
            .replace(/^\s*\$\s*/gim, "")
      );
      copyInput.select();
      document.execCommand("copy");

      const successInfo = $(
        '<div id="copy-code-success-info">Copied to clipboard!</div>'
      );
      successInfo.css({
        top: action[0].getBoundingClientRect().top - action.height(),
        left: action[0].getBoundingClientRect().left + action.width() / 2,
        opacity: 1,
      });
      setTimeout(function () {
        successInfo.animate({ opacity: 0 }, function () {
          successInfo.remove();
        });
      }, 1000);
      $("body").append(successInfo);
    });
    snippet.append(action);
  });
});
