# 1. Create Database:
 
CREATE DATABASE LibraryDB;
USE LibraryDB;

# 2. Create Tables:

#--Books table--
CREATE TABLE Books ( BookID INT PRIMARY KEY AUTO_INCREMENT, Title VARCHAR(255), Author VARCHAR(100), Genre VARCHAR(50), TotalCopies INT, AvailableCopies INT );

#-- Members Table--
CREATE TABLE Members ( MemberID INT PRIMARY KEY AUTO_INCREMENT, Name VARCHAR(100), Email VARCHAR(100), JoinDate DATE );

#--Issue Records Table--
CREATE TABLE Issue_Records ( IssueID INT PRIMARY KEY AUTO_INCREMENT, BookID INT, MemberID INT, IssueDate DATE, DueDate DATE, FOREIGN KEY (BookID) REFERENCES Books(BookID), FOREIGN KEY (MemberID) REFERENCES Members(MemberID) );

#--Returns Table--
CREATE TABLE Returns ( ReturnID INT PRIMARY KEY AUTO_INCREMENT, IssueID INT, ReturnDate DATE, FOREIGN KEY (IssueID) REFERENCES Issue_Records(IssueID) );

# 3. Insert Data:

#--Books--
INSERT INTO Books (Title, Author, Genre, TotalCopies, AvailableCopies) VALUES 
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classic', 5, 5), 
('1984', 'George Orwell', 'Dystopian', 4, 4), 
('To Kill a Mockingbird', 'Harper Lee', 'Classic', 6, 6), 
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', 3, 3), 
('The Alchemist', 'Paulo Coelho', 'Philosophy', 7, 7),
('Sapiens', 'Yuval Noah Harari', 'Non-fiction', 5, 5), 
('Atomic Habits', 'James Clear', 'Self-help', 8, 8),
('Rich Dad Poor Dad', 'Robert Kiyosaki', 'Finance', 4, 4), 
('Gone Girl', 'Gillian Flynn', 'Mystery', 2, 2), 
('The Shining', 'Stephen King', 'Horror', 3, 3);

#--Members--
INSERT INTO Members (Name, Email, JoinDate) VALUES 
('John Doe', 'john@example.com', '2024-01-10'), 
('Jane Smith', 'jane@example.com', '2024-02-15'), 
('Robert Brown', 'robert@example.com', '2024-03-20');

# 4. Triggers:

#--Reduce available copies when issuing a book--
DELIMITER //

CREATE TRIGGER DecreaseAvailableCopies
AFTER INSERT ON Issue_Records
FOR EACH ROW
BEGIN
  UPDATE Books
  SET AvailableCopies = AvailableCopies - 1
  WHERE BookID = NEW.BookID;
END;
//

DELIMITER ;

#--Increase available copies when returning a book--
DELIMITER //

CREATE TRIGGER IncreaseAvailableCopies
AFTER INSERT ON Returns
FOR EACH ROW
BEGIN
  UPDATE Books
  SET AvailableCopies = AvailableCopies + 1
  WHERE BookID = (SELECT BookID FROM Issue_Records WHERE IssueID = NEW.IssueID);
END;
//

DELIMITER ;

#5. Sample Queries:

#--View currently issued books--
SELECT IR.IssueID, M.Name AS Member, B.Title AS Book, IR.IssueDate, IR.DueDate
FROM Issue_Records IR
JOIN Members M ON IR.MemberID = M.MemberID
JOIN Books B ON IR.BookID = B.BookID
LEFT JOIN Returns R ON IR.IssueID = R.IssueID
WHERE R.IssueID IS NULL;

#--View overdue books--
SELECT M.Name, B.Title, IR.DueDate, DATEDIFF(CURDATE(), IR.DueDate) AS DaysOverdue
FROM Issue_Records IR
JOIN Members M ON IR.MemberID = M.MemberID
JOIN Books B ON IR.BookID = B.BookID
LEFT JOIN Returns R ON IR.IssueID = R.IssueID
WHERE R.IssueID IS NULL AND IR.DueDate < CURDATE();

#--View available books--
SELECT * FROM Books WHERE AvailableCopies > 0;

#--View member borrowing history--
SELECT M.Name, B.Title, IR.IssueDate, R.ReturnDate 
FROM Members M 
JOIN Issue_Records IR ON M.MemberID = IR.MemberID 
JOIN Books B ON IR.BookID = B.BookID 
LEFT JOIN Returns R ON IR.IssueID = R.IssueID 
ORDER BY M.Name, IR.IssueDate;







