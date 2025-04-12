// routes/index.js
const express = require('express');
const router = express.Router();

// Serve static files from the 'public' directory
router.use(express.static('public'));

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', {
    title: 'Quest DApp',
    fUSDC_ADDRESS: process.env.FUSDC_CONTRACT_ADDRESS || "YOUR_FUSDC_ADDRESS_HERE",
    QUEST_VAULT_ADDRESS: process.env.QUEST_VAULT_ADDRESS || "YOUR_VAULT_ADDRESS_HERE"
   });
});

router.get('/page1', function(req, res, next) {
  res.render('page1', { title: 'Welcome to Web3 BootStrap App', name:null });
});

router.get('/page2', function(req, res, next) {
  res.render('page2', { title: 'ETH Transfer (Page 2)', name:null });
});

router.get('/page3', function(req, res, next) {
  res.render('page3', { title: 'Completed Goals', name:null });
});

module.exports = router;