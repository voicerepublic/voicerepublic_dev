#Unit Testing
1. Open a command prompt
2. Run `npm test`

   Make sure you have chrome installed, because karma uses chrome to run the tests.
   You don't have to care about dependencies, if you run `npm test` npm will install the required modules for you.
   
   The results are shown in the command prompt.


#End 2 End Testing (Protractor)
To run the end-2-end tests you use [Protractor](https://github.com/angular/protractor).


## Testing with Protractor
(Make sure the server is started)

As a one-time setup, download webdriver.
```
npm run update-webdriver
```

Start the Protractor test runner using the e2e configuration:

```
npm run protractor