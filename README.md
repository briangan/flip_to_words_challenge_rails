# README

This is the development/test Rails app that implements the FlipToWordsChallenge, 
a UI challenge with intentionally complicate codes, to challenge the user to 
flip the correct dots in the container to display the ASCII form of the letters.
The main goal is to enforce enough manual human interactions so that scrapers and bots 
cannot pass easily; and underneath HTML, CSS, and Javascript codes are randomized, so
AI agents cannot easily understand and think of breaking techniques.

Code Complications:
* HTML field names are named in unknown words formed by random letters
* Javascript actions on each dot call different methods to flip the colors
* Javascript flip functions have encrypted logics are more complicated than simple rotation of colors


# Ruby on Rails Requirements

Things you may want to cover:

* Ruby version

* Rails version: 6+ as only default Rails components and common, old-school browser technologies are used so would be most compatible.

* Structure of Important Files
```
app
  | _flip_2_words_challenge_convas.html.erb => partial to include as the challenging gate
controller
  | flip_2_words_challenge_controller.rb => includes the verification methods to review the user answers
helpers
  | flip_2_words_challenge_helper.rb => includes the helper methods to provide the status of challenge
```

* How to run the test suite

* Deployment instructions
