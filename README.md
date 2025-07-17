# 📚 Library Management System using MySQL

A full-featured Library Management System built entirely using **MySQL**. This project helps manage books, members, borrowing records, returns, and availability of books in a structured and automated way using triggers.

---

## 🚀 Features

- Add and manage books with genre, author, and stock information
- Register library members and track their joining date
- Issue books to members with automatic due date tracking
- Track book returns and calculate real-time availability
- Automatic update of available book count using SQL triggers
- Generate useful reports (currently issued books, overdue records, member history)

---

## 🗃️ Database Schema

### Tables:
- Books
- Members
- Issue_Records
- Returns

### Triggers:
- DecreaseAvailableCopies – triggered on book issue
- IncreaseAvailableCopies – triggered on book return

---

## 🛠️ Technologies Used

- **MySQL** (Database)
- **SQL Triggers**
- **Views and Joins**
- Designed to support integration with a PHP, Python, or Java-based frontend

---

## 🧱 Table Definitions

### Books
```sql
CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    TotalCopies INT,
    AvailableCopies INT
);
