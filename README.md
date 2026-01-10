# pawpal_project.
# Final Project


# Detail of Project
Pawpal is a web mobile programming final project using a Flutter as frontend, PHP as a backend and mySQL as a database. 
This application, allow user to view a list of pet of adoption, donation, lost or other.

# Features of Project

1.0 User Authentication
- Auto login features using a remember me
- Register user
- Login user

2.0 User Profile
at user profile has;
- detail about user include a profile picture.
- list of my pets.
- approve and approved adoption.
- my wallet & donation.

3.0 Submit a Pet
- User can submit a detail for pet and choice a category ( donation money , adoption or other ).

4.0 list all animals
- user can view a lsit of animals and detail of animals include a picture of pets.
- user can search and filter based on what user want.


# Project Setup
1.0 You has to download a zip file this project
2.0 install xampp to run this project to localhost
3.0 after download a zip file extract it and paste into a C:\xampp\htdocs
4.0 go to phpmyadmin and create a database pawpal_db and import a pawpal_db.sql
5.0 change the ipaddress in a ipaddress.dart. 
6.0 and run the project via vscode based on what device u want (web view or mobile view)


# API Usage
is a php file for backend which is bridge between frontend and database.

| PHP file | Method | Parameter Pass | Description |
|------|------|-------|-------|
| Connection with database | | | |
| dbconnect.php |  | servername, username, password, dbname | for connection with a database in my sql |

| User Management | | | |
| login_user.php  | POST | email, password | Login in a user to application and return the data of user |
| register_user.php  | POST | email, name, phone, password, user_pciture, user_wallet  | Register a new user |
| get_my_profile.php  | GET | user_id  | To get all data about the user id |
| update_profile.php  | POST | user_id, user_name, user_email, user_phone, image  | To update the detail about the user and to update the profile picture |
| update_payment.php  (mode topup) | POST | user_id, amount, mode | To update or topup a user_wallet and return succesful or not. |
| get_my_wallet.php  | GET | user_id | To get amount of wallet user have and return it. |
| get_my_donation.php  | GET | user_id | To get amount of wallet user have and return it. |
| get_my_pet.php  | GET | user_id | To get amount of wallet user have and return it. |

| Pet Management | | | |
| submit_pet.php  | POST | user_id, user_name, pet_name, pet_type, pet_gender, pet_age, pet_health, pet_category, description, latitude, longitude, image |To insert a new data about pet into tbl_pets and return succesful or not |
| load_pet.php  | GET | search | To get all data about pet based on query for search |
| get_my_pet.php  | GET | user_id | To get a detail about the owner of pet |
| delete_pet.php  | GET | user_id, pet_id | To delete the detail of selected pet |

| Pet Management - Adoption | | | |
| get_adopt.php  | GET | owner_id | To get the detail of pet adoption (owner pet) . |
| get_adopt_approved.php  | GET | user_id | To get the detail about thier request a adopt and a status is approve or rejected. |
| adopt_pet.php  | POST | user_id, oet_id, msg, status is Pending | to insert a data of adoption into tbl_adoption. |
| update_adopt.php  | POST | adopt_id, action | the owner of pet update the adoption is accepted or reject |

| Pet Management - Donation | | | |
| update_payment.php (mode: donate)  | POST | user_id, pet_id, amount, mode | To donate a amount. |
| update_donation_food.php  | POST | user_id, desc, pet_id | To insert data into tbl_doantion about a donation food or medical. |

# Flutter Dependencies 
- geolocator – Location detection
- geocoding – Convert coordinates to addresses
- http – API communication
- image_picker – Image selection
- shared_preferences – Local storage










# Midterm project
1.0 Introduction

the latest version is updated to mid-term
midterm - add more features; 
- submit pet form
- 3 image
- geolocator and geocoding
- database pet
- main screen

2.0 Setup steps

to use this system use must follow several step ;
  1. u must download all file and software right version.
  2. u must setup XAMP and create a table database which is tbl_pets
  3. u must copy all api server at folder project and paste at new folder in htdocs folder (xampp)
  4. u must install the geocoding and deolocator inside a flutter project for real time location
  5. u must install the shared prefrenece to make a remember me features
  6. u must install image picker to upload image on apps
  7. to store all image u must create new folder inside htdocs/lab_asg2/file_put_contents

3.0 API explanation

the fullname of API is application programming interface. it is a set rule to communication with different software.
for example HTTP to access over the internet. in this project, PHP is a brech between Flutter (dart) and Mysql(Database).
has several file of PHP
  1. load_pet.php - to get a list of all pets with details and images.
  2. submit_pet.php - to sumbit all information about pet into a database

4.0 sample JSON
  1. load_pet.php
<img width="782" height="544" alt="image" src="https://github.com/user-attachments/assets/5f48bb2d-5fbd-4f05-bc86-18c1f10a2e02" />


  2. submit_pet.php
<img width="983" height="711" alt="image" src="https://github.com/user-attachments/assets/529e12b2-b252-4aca-8825-cd59b6cac29e" />

<br>



