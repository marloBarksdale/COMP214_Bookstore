import React, { useState } from 'react';
import CartItem from '../components/CartItem';
import CartSummary from '../components/CartSummary';
import CheckoutForm from '../components/CheckoutForm';
import { CheckoutContainer, CartItemContainer } from '../components/StyledComponents';

const CartPage = () => {
  const [cartItems, setCartItems] = useState([
    {
      ISBN: 'B300',
      Title: 'THE FUTURE OF AI',
      Quantity: 2,
      Price: 39.95,
      Total: 79.90
    }
  ]);

  const removeItem = (isbn) => {
    setCartItems(prev => prev.filter(item => item.ISBN !== isbn));
  };

  const updateQuantity = (isbn, newQuantity) => {
    setCartItems(prev => prev.map(item => {
      if (item.ISBN === isbn) {
        return { ...item, Quantity: newQuantity, Total: item.Price * newQuantity };
      }
      return item;
    }));
  };

  const handleCheckout = (e) => {
    e.preventDefault();
    alert('Order placed successfully!');
    setCartItems([]);
    // In a real app, we would send the order to the backend
  };

  const subtotal = cartItems.reduce((sum, item) => sum + item.Total, 0);
  const shipping = 5.00;
  const total = subtotal + shipping;

  return (
    <CheckoutContainer>
      <h2>Your Shopping Cart</h2>
      
      {cartItems.length === 0 ? (
        <p>Your cart is empty.</p>
      ) : (
        <CartItemContainer>
          {cartItems.map(item => (
            <CartItem 
              key={item.ISBN} 
              item={item} 
              updateQuantity={updateQuantity} 
              removeItem={removeItem} 
            />
          ))}
        </CartItemContainer>
      )}
      
      {cartItems.length > 0 && (
        <>
          <CartSummary subtotal={subtotal} shipping={shipping} total={total} />
          
          <h3>Shipping Information</h3>
          <CheckoutForm onSubmit={handleCheckout} />
        </>
      )}
    </CheckoutContainer>
  );
};

export default CartPage;