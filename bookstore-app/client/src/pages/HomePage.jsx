import React, { useState } from 'react';
import SearchBar from '../components/SearchBar';
import CategoryFilter from '../components/CategoryFilter';
import BookGrid from '../components/BookGrid';

// Mock data for the homepage
const mockBooks = [
  {
    ISBN: 'B300',
    Title: 'THE FUTURE OF AI',
    PubDate: '2024-03-05',
    PubID: 10,
    Cost: 25.50,
    Retail: 39.95,
    Discount: null,
    Category: 'TECHNOLOGY',
    Author: 'OLIVIA WILLIAMS',
    Publisher: 'GLOBAL PRINTS'
  },
  {
    ISBN: 'B301',
    Title: 'MODERN COOKING',
    PubDate: '2024-02-10',
    PubID: 11,
    Cost: 18.75,
    Retail: 29.95,
    Discount: null,
    Category: 'COOKING',
    Author: 'JACKSON TAYLOR',
    Publisher: 'BOOK HAVEN'
  },
  {
    ISBN: 'B302',
    Title: 'WEB DEVELOPMENT ESSENTIALS',
    PubDate: '2024-01-15',
    PubID: 10,
    Cost: 30.00,
    Retail: 49.95,
    Discount: 5.00,
    Category: 'TECHNOLOGY',
    Author: 'OLIVIA WILLIAMS',
    Publisher: 'GLOBAL PRINTS'
  },
  {
    ISBN: 'B303',
    Title: 'MYSTERY OF THE ANCIENT TEMPLE',
    PubDate: '2024-02-20',
    PubID: 11,
    Cost: 20.00,
    Retail: 34.95,
    Discount: null,
    Category: 'FICTION',
    Author: 'JACKSON TAYLOR',
    Publisher: 'BOOK HAVEN'
  }
];

const HomePage = () => {
  const [books, setBooks] = useState(mockBooks);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('ALL');
  
  const categories = ['ALL', ...new Set(mockBooks.map(book => book.Category))];

  const filteredBooks = books.filter(book => {
    const matchesSearch = book.Title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          book.Author.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = selectedCategory === 'ALL' || book.Category === selectedCategory;
    return matchesSearch && matchesCategory;
  });

  return (
    <div>
      <SearchBar searchTerm={searchTerm} setSearchTerm={setSearchTerm} />
      <CategoryFilter 
        categories={categories} 
        selectedCategory={selectedCategory} 
        setSelectedCategory={setSelectedCategory} 
      />
      <BookGrid books={filteredBooks} />
    </div>
  );
};

export default HomePage;