DROP TABLE books;
-- Create a table for books
CREATE TABLE books (
    person_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    published_year INTEGER
);

-- Insert some sample data
INSERT INTO books (title, author, published_year) VALUES
('To Kill a Mockingbird', 'Harper Lee', 1960),
('1984', 'George Orwell', 1949),
('Pride and Prejudice', 'Jane Austen', 1813);
