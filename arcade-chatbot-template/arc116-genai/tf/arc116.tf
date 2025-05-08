# Define Persona + Question Bank

variable "lab_persona" {
  type        = list(string)
  description = "Person to interact with in the chatbot"
  default     = [ "Bill", "Mary" ]
}

## Lab Data List 
variable "lab_topic" {
  type        = string
  description = "The topic area to be covered"
  default     = "Google Cloud Professional Security Engineer"
}

variable "lab_context" {
  type        = string
  description = "Context of the lab"
  default     = "Google Cloud exam revision knowledge agent"
}

## lab_list: Questions to be shown in the lab
## Type: There are four options presented
## title: String representing the title of the List e.g. "History, Geography, Artists"
## answer: String representing the question answer
## members: List of Strings, separate each item with a comma e.g. "Paris", "Napoleon"

## Constraint: Members == 4

variable "lab_list" {
  type = list(object({
    title = string
    answer = string
    members = list(string)
  }))

  default = [
    {
      "title" = "Developers in an organization are prototyping a few applications on Google Cloud and are starting to store sensitive information on Google Cloud. The developers are using their personal/consumer Gmail accounts to set up and manage their projects within Google Cloud. A security engineer identifies this practice as a concern to the leadership team because of the lack of centralized project management and access to the data being stored in these accounts. Which solution should be used to resolve this concern?"
      "answer" = "Set up Cloud Identity and require the developers to use those accounts for Google Cloud work."
      "members" = [
        "Enforce the setup of Security Keys as the 2-Step Verification method for those Gmail accounts.",
        "Set up Cloud Identity and require the developers to use those accounts for Google Cloud work.",
        "Require the developers to log/store their Gmail passwords with the security team.",
        "Enable logging on all Google Cloud projects to track all developer activities.",
      ]
    },
    {
      "title" = "A customer wants to use Cloud Identity as their primary IdP. The customer wants to use other non-Google Cloud SaaS products for CRM, messaging, and customer ticketing management. The customer also wants to improve employee experience with Single Sign-On (SSO) capabilities to securely access Google Cloud and non-Google Cloud applications. Only authorized individuals should be able to access these third-party applications. What action should the customer take to meet these requirements?"
      "answer" = "Configure third-party applications to federate authentication and authorization to the Google Cloud IdP."
      "members" = [
        "Remove the employee from Cloud Identity, set the correct license for the individuals, and resync them to Cloud Identity for the changes to take effect.",
        "Configure third-party applications to federate authentication and authorization to the Google Cloud IdP.",
        "Remove the individuals from the third-party applications, add the license to Cloud Identity, and resync the individuals back to the third-party applications.",
        "Copy user personas from Cloud Identity to all third-party applications for the domain.",
      ]
    },
    {
      "title" = "A Cloud Development team needs to use service accounts extensively in their local development. You need to provide the team with the keys for these service accounts. You want to follow Google-recommended practices. What should you do?"
      "answer" = "Implement a daily key rotation process, and provide developers with a Cloud Storage bucket from which they can download the new key every day."
      "members" = [
        "Implement a daily key rotation process that generates a new key and commits it to the source code repository every day.",
        "Implement a daily key rotation process, and provide developers with a Cloud Storage bucket from which they can download the new key every day.",
        "Create a Google Group with all developers. Assign the group the IAM role of Service Account User, and have developers generate and download their own keys.",
        "Create a Google Group with all developers. Assign the group the IAM role of Service Account Admin, and have developers generate and download their own keys.",
      ]
    },
    {
      "title" = "A customer needs to rely on their existing user directory with the requirements of native authentication when developing solutions in Google Cloud. They want to leverage their existing tooling and functionality to gather insight on user activity from a familiar interface. Which action should you take to meet the customer's requirements?"
      "answer" = "Configure Cloud Identity as a SAML 2.0 Service Provider, using the customer's User Directory as the Identity Provider."
      "members" = [
        "Provision users into Cloud Identity using Just-in-Time SAML 2.0 user provisioning with the customer User Directory as source.",
        "Configure Cloud Identity as a SAML 2.0 Service Provider, using the customer's User Directory as the Identity Provider.",
        "Configure and enforce 2-Step Verification in Cloud Identity for all Super Admins.",
        "Configure a third-party IdP (Octa or Ping Federate) to manage authentication.",
      ]
    },
    {
      "title" = "A customer wants to grant access to their application running on Compute Engine to write only to a specific Cloud Storage bucket. How should you grant access?"
      "answer" = "Create a service account for the application, and grant the Storage Object Creator role at the bucket level."
      "members" = [
        "Create a service account for the application, and grant the Storage Object Creator role at the project level.",
        "Create a service account for the application, and grant the Storage Object Creator role at the bucket level.",
        "Create a user account, authenticate with the application, and grant the Storage Object Admin role at the bucket level.",
        "Create a user account, authenticate with the application, and grant the Storage Object Admin role at the project level.",
      ]
    }
  ]
}


## Task information 
## tasks: JSON format used by the lab 
variable tasks {
  type = list(object({
    tag      = string
    question = string
    option_a = string
    option_b = string
    option_c = string
    option_d = string
  }))
  
  default = [
    {
      tag      = "Add a Task and number"
      question = "Add a question"
      option_a = "Add an option"
      option_b = "Add an option"
      option_c = "Add an option"
      option_d = "Add an option"
    }
  ]
}
