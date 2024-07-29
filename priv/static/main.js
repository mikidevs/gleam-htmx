// allow 422 and rerender with errors
document.addEventListener('DOMContentLoaded', () => {
  document.body.addEventListener('htmx:beforeSwap', function(evt) {
    if (evt.detail.xhr.status === 422) {
      evt.detail.shouldSwap = true;
      evt.detail.isError = false;
    }
  });
});
