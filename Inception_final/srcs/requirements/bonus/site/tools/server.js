const express = require('express');
const path = require('path');
const app = express();

app.use('/site', express.static(path.join(__dirname, 'public')));

app.listen(3000, () => {
    console.log("server running on port 3000");
});