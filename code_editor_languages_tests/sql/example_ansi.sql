DROP TABLE books;
-- Create a table for books
CREATE TABLE books (
    person_id INTEGER PRIMARY KEY AUTO_INCREMENT,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    published_year INTEGER
);

-- Insert some sample data
INSERT INTO books (title, author, published_year) VALUES
(1, 'To Kill a Mockingbird', 'Harper Lee', 1960),
(2, '1984', 'George Orwell', 1949),
(3, 'Pride and Prejudice', 'Jane Austen', 1813);
