// routes/index.js
var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', {
    title: 'Quest DApp',
    fUSDC_ADDRESS: process.env.FUSDC_CONTRACT_ADDRESS || "YOUR_FUSDC_ADDRESS_HERE",
    QUEST_VAULT_ADDRESS: process.env.QUEST_VAULT_ADDRESS || "YOUR_VAULT_ADDRESS_HERE"
   });
});

router.get('/page2', function(req, res, next) {
  
  res.render('page2', { title: 'ETH Transfer (Page 2)', name:null });
});

router.get('/page1', function(req, res, next) {
  res.render('page1', { title: 'Welcome to Web3 BootStrap App', name:null });
});

module.exports = router;