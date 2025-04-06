import { useEffect, useState } from 'react';
import axios from 'axios';
import styled from 'styled-components';
import BookForm from '../components/BookForm';
import BookGrid from '../components/BookGrid';

const Container = styled.div`
  padding: 2rem;
  font-family: sans-serif;
`;

function AddBookPage() {
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
    <Container>
      <h1>Add a Book!</h1>
      <BookForm
        formData={formData}
        handleChange={handleChange}
        handleSubmit={handleSubmit}
      />
      <BookGrid books={books} />
    </Container>
  );
}

export default AddBookPage;
