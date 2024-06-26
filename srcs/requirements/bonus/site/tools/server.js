// // server.js
// const express = require('express');
// const path = require('path');

// const app = express();
// const PORT = process.env.PORT || 3000;

// // Serve static files from the "public" directory
// app.use(express.static(path.join(__dirname, 'public')));

// // Start the server
// app.listen(PORT, () => {
//   console.log(`Server is running on http://localhost:${PORT}`);
// });

const express = require('express')

const app = express()

app.use(express.static('public'))


app.listen(3000, () => {
    console.log("server running on port 3000")
})