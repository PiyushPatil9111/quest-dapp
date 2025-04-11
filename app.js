require('dotenv').config(); // Loading environment variables
const express = require('express');
const path = require('path');
const app = express();

// View engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')));

// Routes
app.use('/', require('./routes/index'));
app.use('/quest', require('./routes/quest'));

// Remove this line - let bin/www handle listening
// app.listen(3000, () => console.log('Server running on port 3000'));

module.exports = app; // Keep this as the last line