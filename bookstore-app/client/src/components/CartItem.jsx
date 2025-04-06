import React from 'react';
import { 
  CartItemWrapper, 
  CartItemInfo, 
  CartItemTitle, 
  CartItemPrice, 
  CartItemQuantity,
  Input,
  Button
} from './StyledComponents';

const CartItem = ({ item, updateQuantity, removeItem }) => {
  return (
    <CartItemWrapper>
      <CartItemInfo>
        <div>
          <CartItemTitle>{item.Title}</CartItemTitle>
          <CartItemPrice>${item.Price.toFixed(2)}</CartItemPrice>
        </div>
      </CartItemInfo>
      <CartItemQuantity>
        <Input
          type="number"
          min="1"
          value={item.Quantity}
          onChange={(e) => updateQuantity(item.ISBN, parseInt(e.target.value))}
          style={{ width: '60px' }}
        />
        <CartItemPrice>${item.Total.toFixed(2)}</CartItemPrice>
        <Button onClick={() => removeItem(item.ISBN)}>Remove</Button>
      </CartItemQuantity>
    </CartItemWrapper>
  );
};

export default CartItem;