import React from 'react';
import { CartSummaryContainer } from './StyledComponents';

const CartSummary = ({ subtotal, shipping, total }) => {
  return (
    <CartSummaryContainer>
      <h3>Order Summary</h3>
      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
        <p>Subtotal</p>
        <p>${subtotal.toFixed(2)}</p>
      </div>
      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
        <p>Shipping</p>
        <p>${shipping.toFixed(2)}</p>
      </div>
      <div style={{ display: 'flex', justifyContent: 'space-between', fontWeight: 'bold' }}>
        <p>Total</p>
        <p>${total.toFixed(2)}</p>
      </div>
    </CartSummaryContainer>
  );
};

export default CartSummary;