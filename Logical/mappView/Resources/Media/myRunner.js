(function () {
  const ID = 'gAssembly6D_Big-svg';
  const MAX_TRIES = 100;   // 100 × 100 ms = 10 s
  let tries = 0;

  const timer = setInterval(() => {
    const el = document.getElementById(ID);

    if (el) {
      clearInterval(timer);
      el.setAttribute('transform', 'rotate(90)');
      console.log('6D widget rotated!');
      return;
    }

    if (++tries >= MAX_TRIES) {
      clearInterval(timer);
      console.warn(`6D widget (${ID}) not found, giving up.`);
    }
  }, 100);
})();