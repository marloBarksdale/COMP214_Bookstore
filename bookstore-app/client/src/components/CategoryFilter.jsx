import React from 'react';
import { FilterContainer, CategoryBtn } from './StyledComponents';

const CategoryFilter = ({ categories, selectedCategory, setSelectedCategory }) => {
  return (
    <FilterContainer>
      {categories.map(category => (
        <CategoryBtn 
          key={category}
          active={selectedCategory === category}
          onClick={() => setSelectedCategory(category)}
        >
          {category}
        </CategoryBtn>
      ))}
    </FilterContainer>
  );
};

export default CategoryFilter;