# README

This is the development/test Rails app that implements the FlipToWordsChallenge, 
a UI challenge with intentional complicate codes, to challenge the user to 
flip the correct dots in the container to display the ASCII form of the letters.
Instead using Captcha service, the main goal is to enforce enough manual human interactions, 
so that scrapers and bots cannot pass easily; and underneath HTML, CSS, and 
Javascript codes are renamed and shuffled, so AI agents cannot easily understand and 
think of breaking techniques.

Code Complications:
* HTML field names are named in unknown words formed by random letters
* Javascript actions on each dot call different methods to flip the colors
* Javascript flip functions have encrypted logics are more complicated than simple rotation of colors


# Ruby on Rails Requirements

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

# Other Requirements Requirements

* How to run the test suite

* Deployment instructions
