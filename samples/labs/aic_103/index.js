"use strict";
var Aic = require('aic');
 
var opts = {
    templatePath: './template.json'
}
 
function enableCallback(data, cb) {
    console.log('Nginx AIC: deployment complete! Enable is called. data = ' + JSON.stringify(data, null, 2));
    //Do something... Call back success or error when complete
    cb(null); //success!
}
 
function run() {
    console.log('Nginx AIC: run()');
    var myAic = new Aic(opts);
   
    console.log('Nginx AIC: registering callbacks to listen to GUI/Administrator actions such as disabling node, disabling app, deleting app, etc...');
    //register callback for application enablement.
    myAic.registerApplicationEnableCallback(enableCallback);
 
    console.log('Nginx AIC: starting provision...');
    myAic.provision();
}
 
run();
