import React from 'react';
import { SearchContainer, SearchInput, Button } from './StyledComponents';

const SearchBar = ({ searchTerm, setSearchTerm }) => {
  return (
    <SearchContainer>
      <SearchInput 
        type="text" 
        placeholder="Search by title or author..." 
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
      />
      <Button>Search</Button>
    </SearchContainer>
  );
};

export default SearchBar;