import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import { AppContainer } from './components/StyledComponents';
import Header from './components/Header';
import HomePage from './pages/HomePage';
import BookDetailPage from './pages/BookDetailPage';
import CartPage from './pages/CartPage';
import AccountPage from './pages/AccountPage';
import AddBookPage from './pages/AddBook';

const App = () => {
  return (
    <Router>
      <AppContainer>
        <Header />
        
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/book/:isbn" element={<BookDetailPage />} />
          <Route path="/cart" element={<CartPage />} />
          <Route path="/account" element={<AccountPage />} />
          <Route path="/addbook" element={<AddBookPage />} />
        </Routes>
      </AppContainer>
    </Router>
  );
};

export default App;