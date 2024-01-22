document.addEventListener("turbo:load", function() {
  const element = document.getElementById('line-text');
  if (element) {
    const element_w = element.offsetWidth;
    const line_width = element_w + 40 + 24 * 2 + 2;
    document.documentElement.style.setProperty('--line-width', `${line_width}px`);
  }
});