require('dotenv').config();
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

// Debug middleware - add this
app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
});

// Routes
app.use('/', require('./routes/index'));
app.use('/quest', require('./routes/quest'));

// Error handler - add this
app.use((req, res, next) => {
  res.status(404).send('Page not found');
});

module.exports = app;