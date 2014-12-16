#Unit Testing
1. Move to directory `voicerebulic/angular_test/`
2. Open a command prompt
4. Run `npm test`

   Make sure you have chrome installed, because karma uses chrome to run the tests.
   You don't have to care about dependencies, if your run `npm test` it will install the required modules for you.
   
   You can see the testresults in the command prompt.


#End 2 End Testing (Protractor)
To run the end-2-end tests against the application you use [Protractor](https://github.com/angular/protractor).


## Testing with Protractor
(Make sure the server is started)

As a one-time setup, download webdriver.
```
npm run update-webdriver
```

Start the Protractor test runner using the e2e configuration:

```
npm run protractor