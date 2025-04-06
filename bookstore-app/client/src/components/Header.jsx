import React from 'react';
import { HeaderContainer, Logo, Nav, NavLink } from './StyledComponents';

const Header = () => {
  return (
    <HeaderContainer>
      <Logo>BookStore</Logo>
      <Nav>
        <NavLink to="/">Home</NavLink>
        <NavLink to="/cart">Cart</NavLink>
        <NavLink to="/account">My Account</NavLink>
        <NavLink to="/addbook">Add a Book</NavLink>
      </Nav>
    </HeaderContainer>
  );
};

export default Header;