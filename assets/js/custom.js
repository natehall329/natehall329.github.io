/**
 * Custom site JS.
 *
 * Cite button: when clicked, fetch the publication's BibTeX (cite.bib) and copy
 * it straight to the clipboard, with a brief toast for feedback. The theme's
 * own handler still opens the citation modal (auto-populated), so users both
 * see the BibTeX and have it on their clipboard in one click.
 */
(function () {
  function showToast(message) {
    var id = 'cite-copied-toast';
    var el = document.getElementById(id);
    if (!el) {
      el = document.createElement('div');
      el.id = id;
      el.setAttribute('role', 'status');
      el.style.cssText =
        'position:fixed;left:50%;bottom:1.5rem;transform:translateX(-50%);' +
        'background:#323232;color:#fff;padding:.6rem 1rem;border-radius:.4rem;' +
        'font-size:.9rem;line-height:1;z-index:2000;opacity:0;' +
        'transition:opacity .2s ease;pointer-events:none;box-shadow:0 2px 8px rgba(0,0,0,.3);';
      document.body.appendChild(el);
    }
    el.textContent = message;
    el.style.opacity = '1';
    clearTimeout(el._hideTimer);
    el._hideTimer = setTimeout(function () {
      el.style.opacity = '0';
    }, 1800);
  }

  function copyCitation(filename) {
    if (!filename || !navigator.clipboard || !navigator.clipboard.writeText) {
      return;
    }
    fetch(filename)
      .then(function (resp) {
        return resp.ok ? resp.text() : Promise.reject(resp.status);
      })
      .then(function (text) {
        return navigator.clipboard.writeText(text.trim());
      })
      .then(function () {
        showToast('Citation copied to clipboard');
      })
      .catch(function () {
        /* Silently ignore; the modal's Copy button remains as a fallback. */
      });
  }

  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.js-cite-modal').forEach(function (btn) {
      btn.addEventListener('click', function () {
        copyCitation(btn.getAttribute('data-filename'));
      });
    });
  });
})();
