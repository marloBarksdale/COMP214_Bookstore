import { useEffect, useState } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [books, setBooks] = useState([]);
  const [formData, setFormData] = useState({
    ISBN: '',
    Title: '',
    PubDate: '',
    PubID: '',
    Cost: '',
    Retail: '',
    Discount: '',
    Category: ''
  });

  useEffect(() => {
    fetchBooks();
  }, []);

  const fetchBooks = async () => {
    try {
      const res = await axios.get('http://localhost:5000/api/books');
      setBooks(res.data);
    } catch (err) {
      console.error(err);
    }
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post('http://localhost:5000/api/books', formData);
      fetchBooks();
      setFormData({
        ISBN: '', Title: '', PubDate: '', PubID: '',
        Cost: '', Retail: '', Discount: '', Category: ''
      });
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div className="container">
      <h1>Bookstore</h1>

      <form className="book-form" onSubmit={handleSubmit}>
        <input name="ISBN" placeholder="ISBN" value={formData.ISBN} onChange={handleChange} required />
        <input name="Title" placeholder="Title" value={formData.Title} onChange={handleChange} required />
        <input name="PubDate" placeholder="PubDate (YYYY-MM-DD)" value={formData.PubDate} onChange={handleChange} required />
        <input name="PubID" placeholder="PubID" value={formData.PubID} onChange={handleChange} required />
        <input name="Cost" placeholder="Cost" value={formData.Cost} onChange={handleChange} required />
        <input name="Retail" placeholder="Retail" value={formData.Retail} onChange={handleChange} required />
        <input name="Discount" placeholder="Discount" value={formData.Discount} onChange={handleChange} />
        <input name="Category" placeholder="Category" value={formData.Category} onChange={handleChange} required />
        <button type="submit">Add Book</button>
      </form>

      <div className="book-grid">
        {books.map(book => (
          <div key={book.ISBN} className="book-card">
            <div className="book-image-container">
              <img
                src={`https://picsum.photos/200/300?random=${book.ISBN}`}
                alt={book.Title}
                className="book-image"
              />
            </div>
            <div className="book-info">
              <h3>{book.Title}</h3>
              <p><strong>Category:</strong> {book.Category}</p>
              <p><strong>Price:</strong> ${book.Retail}</p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default App;
