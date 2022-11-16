# CPSC 304 Project - Our Zoo 🐎🦄🦓🙉🦍🦁🦒🐨🐼🐢🦉

## Setting up the repo

> Important: these steps assume you're using the cs department servers

1. Clone the repo **inside** the `~/public_html` directory. This way we do not need to keep copy and pasting our PHP files back and forth between the repo and the public directory.
2. Create a copy of `environment.sample.php` and rename to `environment.php`. 
     - Fill in the environment variables with your correct CWL and student number
     - Note these are the exact same credentials used in tutorial 7 in the php file
2. Go to https://www.students.cs.ubc.ca/~(CWL_ID)/project_f0w2b_g4f2b_w2h3b/zoo.php to see the file
     - notice how it uses our repo directory in the URL

## Workflow for changes in the zoo.php file

1. Make sure there is sufficient data to express the query well enough, if not add insert statements
2. Once you are happy with the changes made, checkout to a new branch.
3. Add a screenshot of your query results to the PDF
4. Add description in PDF of the query you used
5. Commit and push your changes.
6. Create a PR (pull request) and tag all of us to review your PR