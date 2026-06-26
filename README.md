# README

This is the development/test Rails app that implements the FlipToWordsChallenge, 
a UI challenge with intentional complicate codes, to challenge the user to 
flip the correct dots in the container to display the ASCII form of the letters.
Instead using Captcha service, the main goal is to enforce enough manual human interactions, 
so that scrapers and bots cannot pass easily; and underneath HTML, CSS, and 
Javascript codes are renamed and shuffled, so AI agents cannot easily understand and 
think of breaking techniques.

Code Complications:
* [x] HTML field names are encrypted so a peek at inner page source wouldn't leak
* [ ] Considerable: use CSS to allow different placements of checkboxes than the order of rendered HTML tags
* [ ] Considerable: split the letters into a sequence of individual follow-up requests, instead of rendering all at once
* [ ] Considerable: Javascript flip functions have encrypted logics are more complicated than simple rotation of colors

# Installation

## Initial Merge Into Existing Rails Project
Copy the structure of files in following Ruby on Rails Requirements section to your Rails project.

## Generation of Environment Variables
Since the rubygem 'dotenv' is used, environments variables local for the running stance of this RoR app 
can be set with file(s) /.env and /.env.test.

For encryption security key that encrypts certain data, for example, challenge answer's parameters.
The generation of that key can be done with command:
```
ruby -e "require 'securerandom'; puts SecureRandom.hex(32)"
```

## Ruby on Rails Requirements

Things you may want to cover:

* Ruby version: 3+

* Rails version: 6+ as only default Rails components and common, old-school browser technologies are used so would be most compatible.

* Structure of Important Files
```
app
  |
  + assets
       + images
           | flip_letter_demo.png - screenshot of how to have checkboxes represent the sample letters
       + stylesheets
           | application.css - the section "FlyToWords component styles" has CSS rules
  | 
  + controllers
  |----+ flip_to_words
       |---- challenge_controller.rb => includes the verification methods to review the user answers
  |
  + helpers
  |----+ flip_to_words
       |---- challenge_helper.rb => includes the helper methods to provide the status of challenge
  |
  + models
  |----+ flip_to_words
       |---- flip_letter_map.rb => the pack of multiple FlipLetter instances
       |---- flip_letter.rb => container of the letter and its position mapping of the strokes
  + views 
  |----+ flip_to_words
       |---- _challenge_canvas.html.erb => partial to include as the challenging gate
  |
config
  + locales
      | en.yml - has a group "flip_to_words_challenge" to customize wordings of messages; even if not copied over to new project's diction, default messages are used.
```

## Other Requirements Requirements

* How to run the test suite

* Deployment instructions


# Flow of Development Using AI Coding Agents

## Service and Agents In Use
CoPilot > Claude Sonnet 4.5, GPT-Codex 5.3

## Prompts and Results
---------------------------------
Write me another method to update the letters list.
Result:
  Simple question.  Able to add method to controller, update view script, and routes.

---------------------------------
Generate a secret key
Result:
  Nice that it uses Ruby's internal random key generator.  Could've used Unix/Linux system script.

---------------------------------
Create some algorithm that encrypts the parameter names like "P[0]" so they would become unrecognizable.  Then upon reception of the request, the algorithm can consistently decrypt the encrypted parameter names.

Result:
  Generated encryptor class; modified controller methods to encrypt and decrypt parameters; modified the form checkboxes to use encrypted field names & ids.
  In fact, too complicated or repeated methods that fail with inconsistency, so tests fail to encrypt then decrypt.
  The actual reason is that AI chose HMAC-SHA256, the one-way encoding of string, irreversible and totally wrong.

----------------------------------
Create an algorithm for reversable encryption: encrypt and later then decrypt.

Result:
  AI suggesteed AES algorithm.  It proceeds to check for already generated secure key in environment variables,
  which I have in /.env file
  In its concatenation of final encrypted string, the first segment of the string is a randomly generated code:
    iv = cipher.random_iv
    which would fail the consistency of encryption with the same input and same output value.

After redemption of inconsistent encryption, AI could fix the settings of encryption, and provide valid reversible encryption.

  