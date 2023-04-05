Here I had to create Entity Relationship Diagram and Relation Schema based on these requirements below using ERDPlus:

- For each designer, the database must keep track of a unique designer identifier, unique SSN,
and a name (which is composed of a first and a last name).
- For each customer, the database must keep track of a unique customer identifier, his/her
name (which is composed of a first and a last name), and multiple phone numbers.
- For each tailoring technician, the database must keep track of a unique SSN and a name
(which is composed of a first and a last name).
- For each outfit, the database must keep track of a unique outfit identifier, the outfit’s planned
date of completion, and its price.
- For each fashion show, the database must keep track of a unique show identifier, as well as
the date and location of the show.
- Each designer designs many outfits. Each outfit has only one designer.
- Each outfit is sold (in advance) to exactly one customer. Customers can buy one or many
outfits (Snooty Fashions will not keep track of customers who have not made any purchases
yet).
- Each tailoring technician must work on at least one outfit, but can work on many. Each
outfit has at least one tailoring technician working on it, but can have many tailoring
technicians working on it.
- Snooty Fashions will keep track of the date when a tailoring technician started working on a
particular outfit.
- Each designer can participate in a number of fashion shows, but does not have to participate
in any. Each fashion show can feature one or two Snooty Fashions designers (Snooty
Fashions will not keep track of fashion shows that do not feature Snooty Fashions
designers)

![aaa](https://user-images.githubusercontent.com/33390661/230184783-452a06ba-016d-458c-9353-97a8f45f6c74.jpg)

![bbb](https://user-images.githubusercontent.com/33390661/230184791-18ec7c06-53f8-4587-a7d6-b11f49c83e63.jpg)
