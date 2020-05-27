# BisonFlex_BoringJeopardy
This repo holds all material relevant to the project of creating a BisonFlex compiler which takes as input any simple English sentence and produces a relevant question.

I call it "Boring Jeopardy" because it only asks questions to which we already know the answer.

The lexicon was built from Part-of-Speech lists found on the internet, so the program returns a
syntax error if your statement includes any words not found on those lists. Also, since English 
words can fall into multiple categories, but lex does not allow tokens to fall into multiple 
categories, I tried to choose the category I thought would most often come up for each of these
words, which might cause further syntax errors. The lexicon does not include any proper nouns.

The grammar allows for many English sentence compositions, but had to be limited to somewhat 
simple compositions to avoid shift/reduce errors that resulted in syntax errors during parsing.
Each sentence must end with a period or an exclamation mark.
Some example statements to get you started:

- The girl and the boy went to the store.

- She wanted to dance at her wedding.

- The day was long.

- The officer in the blue uniform wore a yellow hat.

- The gunpowder burned.

- The mother wept because she was sad.

- The donors who asked for receipts gave more money.

- I will stay here.

- The passengers sang when the bus arrived at the store.

- Her mother is doing well.

- The instructor knows if you know the material.

- Men drive like maniacs.

- The employees thanked their custodians for helping them.

- The soldier fought for her freedom.

- The students are learning quickly.

- The store will close tomorrow.

- It works!

