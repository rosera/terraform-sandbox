# Arcade Chatbot

Data driven labs based on Terraform input.

## Usage

Update the following:

- [ ] persona_builder.tf: Create chatbot persona(s). 
- [ ] personas.tf: Register the personas to be displayed in the chatbot.
- [ ] task_builder.tf: Create quiz questions.
- [ ] tasks.tf: Register the tasks for the quiz.
- [ ] variables.tf: Common values defined for the modules.

```
variable lab_persona
variable lab_topic
variable lab_context
variable lab_list
```

## Modules 

| File | Description | 
|------|-------------|
|  arcade_wheel.tf   | Generate dynamic data as a list |
|  cf                | Source code for Cloud Function |
|  cf.tf | Cloud Function module |
|  chatbot.tf | Chatbot module |
|  gcs.tf | Cloud Storage module |
|  outputs.tf | Terraform output values |
|  persona_builder.tf | Persona Creator module |
|  personas.tf | Persona module |
|  runtime.yaml | QL platform file |
|  scripts | Folder for bash scripts |
|  task_builder.tf | Task Build module |
|  tasks.tf | Task module |
|  variables.tf | Variables for configuration |
