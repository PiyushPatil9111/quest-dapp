// routes/index.js
var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', {
    title: 'Quest DApp',
    // Pass contract addresses needed by index.ejs
    fUSDC_ADDRESS: process.env.FUSDC_CONTRACT_ADDRESS || "YOUR_FUSDC_ADDRESS_HERE",
    QUEST_VAULT_ADDRESS: process.env.QUEST_VAULT_ADDRESS || "YOUR_VAULT_ADDRESS_HERE"
   });
});

// --- Keep this route for page2.ejs ---
router.get('/page2', function(req, res, next) {
  // page2.ejs doesn't need the fUSDC/QuestVault addresses passed here
  res.render('page2', { title: 'ETH Transfer (Page 2)', name:null });
});
// --- End of page2 route ---

// Remove /page1, /page3, /page4, /page5, /page6 routes if unused
// Example:
/*
router.get('/page1', function(req, res, next) {
  res.render('page1', { title: 'Welcome to Web3 BootStrap App', name:null });
});
*/
// ...etc...

module.exports = router;