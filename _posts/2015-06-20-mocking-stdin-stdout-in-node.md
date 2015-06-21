---
layout: post
title: "Mocking STDIN STDOUT in node"
---

# Mocking STDIN and STDOUT for node CLI tools

Recently I started a project that involved a pretty simple concept, building a CLI tool using node to allow someone to play  a text based adventure game.
Like a good dev, I thought I should start with testing to get a little better feel for server side JS testing. I asked my colleagues what they think the best tools for the process would be since I was really only familiar with client side JS testing via Angular. I was told hands down to go for two key components

* [mocha](https://github.com/mochajs/mocha) testing framework. (has a sweet `-w` when running tests where it watches files on save. Bye bye `guard`)
* [chai](https://github.com/chaijs/chai) as the matcher library (lets you use `expect` and some other sweet matchers makes the transition from rspec smooth)

# Set up

Your standard steps

* `npm init`
* `npm install mocha chai`
* create a spec folder and folder for your code

I wont be using any test runners or build tools right here, I just have my npm test set up to run my tests with the watch flag `"test": "./node_modules/mocha/bin/mocha -w spec/gameSpec.js"`

At the top of my test file I require my packages and also require the `child_process` package.

The basic strategy is to have node run your code in a completely separate process write to STDIN and see what that code outputs to STDOUT.

~~~js
var expect = require('chai').expect;
var path = require('path');
var child = require('child_process');
~~~

Before each test, make sure to spawn a new process and set its stdio to `pipe`
~~~js
    exec = path.join(__dirname, '..', 'game.js');
    proc = child.spawn(exec, {stdio: 'pipe'});
~~~
** Make sure to set your code to executable**
* add this line to the top of the js file `#!/usr/bin/env node`
* and `chmod` the permissions to executable `chmod a+x game.js`

On to the fun stuff....

# Trial and Error
this code will run asynchronously so make sure to pass `done` into the function and call it after the assertion

The first test will look something like this
~~~js
  it('tests', function(done) {
    proc.stdout.once('data', function(output) {
      expect(output.toString('utf-8')).to.eq('Would you like to play?\n');
      done();
    });
  });
~~~

**remember the output is a chunk data stream so we have to convert it back into text**


## Bugs

I was using a package called `readline` to make my life a little easier but I started having problems with it
it was emitting new lines when I called `rl.write` and it was causing all sorts of weird bugs, to get around I ended up writing directly to `stdout` in my code and only using `readline` to process input

[This is a well documented bug that I hope gets fixed sooner rather than later](https://github.com/joyent/node/issues/4243)

# Callback Hell
The way that I wrote my code requires me to start from scratch every time, and since the data stream starts but only ends when the process finished I ended up nesting my call backs deeper and deeper.

~~~js
  it('the user can enter js that evals to 42 as a sum', function(done) {
    proc.stdout.once('data', function(){
      proc.stdin.write('yes\r');
      proc.stdout.once('data', function(){
        proc.stdout.once('data', function(){
          proc.stdin.write('1\r');
          proc.stdout.once('data', function() {
            proc.stdin.write('40 + 2\r');
              proc.stdout.on('data', function(data) {
                expect(helperConverter(data)).to.eq('Nice Job\nHow about another?\n Given an array arr = [1,2,3] how do you get the first element?\n');
                done();
              });
          })
        });
      });
    });
  });
~~~

As far as refactoring this I'm sure there has to be a way to convert it into streams, pipe it to my function and use a switch statement to enter the `yes\r` and `1\r` 

The amount of duplication in this is pretty ridiculous but thats the only way I can really see. I guess in that case you just have one switch statement that gets larger and larger. 
I guess one way is to refactor all the game functionality into methods on an object and run unit tests for everything. This exercise is meant for beginners however and I wanted the barrier of entry to be as low as possible. [The readline module](https://nodejs.org/api/readline.html) is actually great and easy to use and I want to expose them to callbacks early in their node career. 

The other option is [readline-sync](https://github.com/anseki/readline-sync) which looks easy to understand but I'm not sure of its use, callback seems more natural in the long run for tasks like this.
