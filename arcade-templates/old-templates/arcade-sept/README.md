# Arcade Sept 2024

## Topic: Paris Olympics

Add two questions specifically on the location.

 - [x] Paris

## Authoring

Update the `variables.tf` file to include the task questions to be shown.
Edit the following files:

- [x] variables.tf - add questions for the lab
- [x] output.tf - dynamic variables to be used in the lab

If additional questions are required, update `task_builder.tf` to include 
the new items. The default template supports two questions to be show to the 
student.

## Question Generation

Generate questions using `Generative AI` e.g. `Gemini` and add to the 
`variables.tf` file.

Example prompt engineering:

```
Can you generate 4 quiz questions in relation to swimming events held in Paris 
for the 2024 olympics. The questions should relate to the events located in 
Paris. Please include 4 answer options and the actual correct answer. 
Answers should be validated against the official olympic event list. Can you 
use this formatting per question:
    {
          # Index: 0
          "title" = "Which aquatic disciplines will be showcased at the Nice Stadium during the 2024 Olympics?"
          "answer" = "Artistic Swimming, Diving, Water Polo"
          "members" = [
            "Swimming, Diving, Water Polo",
            "Artistic Swimming, Diving, Water Polo",
            "Synchronized Swimming, Water Polo, Open Water Swimming",
            "Diving, Water Polo, Triathlon",
          ]
        },
```

## Question Dynamic Variables

Question output variables are defined in the `outputs.tf` file.
The template supports eight distinct questions and can be updated to include 
additional questions as desired. 

Questions are defined as per below and support interpolation:

#### Static question

Add a string as a question
```
output "question_1" {
    value = "Hello what is your name?" 
}
```


#### Dynamic question

Interpolation example
```
output "question_3" {
    value = "Who is ${local.lab_persona}?"
}
```

Randomised question based on the Arcade Wheel output
```
output "question_5" {
    value = local.lab_list[0]
}
```
