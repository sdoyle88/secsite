const express = require('express');
const _ = require('lodash');

const app = express();

app.get('/', (req, res) => {
  const data = { name: 'PSPlay', version: '1.0.0' };
  const result = _.pick(data, ['name']);
  res.send(result);
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
