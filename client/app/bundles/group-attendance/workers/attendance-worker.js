let i = 0;

module.exports = function worker(self) {
  self.addEventListener('message', event => {
    console.log('event', event); // DEBUG

    i++;

    self.postMessage(i);
  });
};
