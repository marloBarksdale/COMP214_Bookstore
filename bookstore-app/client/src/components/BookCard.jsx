import React from 'react';
import { Link } from 'react-router-dom';
import { Card, BookCover, BookInfo, BookTitle, BookMeta, BookPrice } from './StyledComponents';

const BookCard = ({ book }) => {
  return (
    <Card>
      <Link to={`/book/${book.ISBN}`} style={{ textDecoration: 'none' }}>
        <BookCover>{book.Title.substring(0, 2)}</BookCover>
        <BookInfo>
          <BookTitle>{book.Title}</BookTitle>
          <BookMeta>By {book.Author}</BookMeta>
          <BookMeta>Category: {book.Category}</BookMeta>
          <BookPrice>${book.Retail.toFixed(2)}</BookPrice>
        </BookInfo>
      </Link>
    </Card>
  );
};

export default BookCard;