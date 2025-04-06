import React from 'react';
import BookCard from './BookCard';
import { Grid } from './StyledComponents';

const BookGrid = ({ books }) => {
  return (
    <Grid>
      {books.map(book => (
        <BookCard key={book.ISBN} book={book} />
      ))}
    </Grid>
  );
};

export default BookGrid;