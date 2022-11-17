$(document).ready(function () {
  // Top right CTA
  const cta = $("#top-cta").text("");
  const ctaOptions = {
    incubator: {
      url: "https://incubator.konghq.com/",
      text: "Early Access",
    },
    sales_demo: {
      url: "https://konghq.com/contact-sales",
      text: "Personalized Demo",
    },
  };

  let selectedCtaKey = Cookies.get("top_cta");
  if (!selectedCtaKey) {
    const ctaKeys = Object.keys(ctaOptions);
    selectedCtaKey = ctaKeys[Math.floor(Math.random() * ctaKeys.length)];
    Cookies.set("top_cta", selectedCtaKey, { expires: 1 });
  }

  const selectedCta = ctaOptions[selectedCtaKey];

  cta
    .attr("href", selectedCta.url + "?utm_source=docs.konghq.com")
    .text(selectedCta.text)
    .click(function () {
      analytics.track("top_cta_click", selectedCta);
    });

  // End Top right CTA
});
