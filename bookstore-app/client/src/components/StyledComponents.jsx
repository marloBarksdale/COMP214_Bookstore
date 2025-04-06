import styled from 'styled-components';
import { Link } from 'react-router-dom';

// App Container
export const AppContainer = styled.div`
  font-family: 'Arial', sans-serif;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
`;

// Header Components
export const HeaderContainer = styled.header`
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 0;
  border-bottom: 1px solid #e0e0e0;
`;

export const Logo = styled.div`
  font-size: 24px;
  font-weight: bold;
  color: #2c3e50;
`;

export const Nav = styled.nav`
  display: flex;
  gap: 20px;
`;

export const NavLink = styled(Link)`
  text-decoration: none;
  color: #2c3e50;
  font-weight: 500;
  transition: color 0.3s;

  &:hover {
    color: #3498db;
  }
`;

// Search Components
export const SearchContainer = styled.div`
  display: flex;
  padding: 20px 0;
`;

export const SearchInput = styled.input`
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  flex-grow: 1;
  margin-right: 10px;
`;

// Button Components
export const Button = styled.button`
  padding: 10px 15px;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;

  &:hover {
    background-color: #2980b9;
  }
`;

export const SubmitButton = styled(Button)`
  grid-column: span 2;
  margin-top: 10px;
`;

export const CartButton = styled(Button)`
  margin-top: 20px;
`;

// Category Filter Components
export const FilterContainer = styled.div`
  display: flex;
  gap: 10px;
  margin: 20px 0;
`;

export const CategoryBtn = styled.button`
  padding: 8px 12px;
  background-color: ${props => props.active ? '#3498db' : '#f9f9f9'};
  color: ${props => props.active ? 'white' : '#666'};
  border: 1px solid #ddd;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s;

  &:hover {
    background-color: ${props => props.active ? '#2980b9' : '#e9e9e9'};
  }
`;

// Book Grid Components
export const Grid = styled.div`
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 20px;
  margin-top: 20px;
`;

// Book Card Components
export const Card = styled.div`
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  overflow: hidden;
  transition: transform 0.3s;

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
  }
`;

export const BookCover = styled.div`
  height: 200px;
  background-color: #f9f9f9;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #666;
  font-weight: bold;
`;

export const BookInfo = styled.div`
  padding: 15px;
`;

export const BookTitle = styled.h3`
  margin: 0 0 10px;
  color: #2c3e50;
`;

export const BookMeta = styled.p`
  margin: 5px 0;
  color: #666;
  font-size: 14px;
`;

export const BookPrice = styled.p`
  margin: 10px 0;
  font-weight: bold;
  color: #2c3e50;
`;

// Book Detail Components
export const DetailContainer = styled.div`
  display: flex;
  gap: 30px;
  margin-top: 30px;
`;

export const DetailCover = styled.div`
  width: 300px;
  height: 400px;
  background-color: #f9f9f9;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #666;
  font-weight: bold;
`;

export const DetailInfo = styled.div`
  flex-grow: 1;
`;

export const DetailTitle = styled.h1`
  margin: 0 0 20px;
  color: #2c3e50;
`;

export const DetailMeta = styled.div`
  margin-bottom: 20px;
`;

export const DetailDescription = styled.p`
  line-height: 1.6;
  color: #666;
`;

// Cart Components
export const CheckoutContainer = styled.div`
  margin-top: 30px;
`;

export const CartItemContainer = styled.div`
  margin-bottom: 30px;
`;

export const CartItemWrapper = styled.div`
  display: flex;
  justify-content: space-between;
  padding: 15px 0;
  border-bottom: 1px solid #e0e0e0;
`;

export const CartItemInfo = styled.div`
  display: flex;
  gap: 20px;
`;

export const CartItemTitle = styled.h3`
  margin: 0;
`;

export const CartItemPrice = styled.p`
  margin: 5px 0;
  font-weight: bold;
`;

export const CartItemQuantity = styled.div`
  display: flex;
  align-items: center;
  gap: 10px;
`;

export const CartSummaryContainer = styled.div`
  margin-top: 20px;
  padding: 20px;
  background-color: #f9f9f9;
  border-radius: 8px;
`;

// Form Components
export const FormContainer = styled.form`
  margin-top: 30px;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
`;

export const FormGroup = styled.div`
  display: flex;
  flex-direction: column;
  gap: 5px;
`;

export const Label = styled.label`
  font-weight: 500;
`;

export const Input = styled.input`
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
`;

export const Select = styled.select`
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
`;

// Order History Components
export const OrderContainer = styled.div`
  margin-bottom: 20px;
  padding: 20px;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
`;

export const OrderHeader = styled.div`
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
`;

export const OrderItems = styled.div`
  margin-top: 10px;
`;

export const OrderItem = styled.div`
  display: flex;
  justify-content: space-between;
`;