import React, { useState } from 'react';
import { 
  Button, 
  OrderContainer,
  OrderHeader,
  OrderItems,
  OrderItem
} from '../components/StyledComponents';

const AccountPage = () => {
  const [user, setUser] = useState({
    Customer: 2001,
    LastName: 'JOHNSON',
    FirstName: 'EMILY',
    Address: '123 APPLE ST',
    City: 'NEW YORK',
    State: 'NY',
    Zip: '10001',
    Email: 'emilyj@gmail.com'
  });

  const [orders, setOrders] = useState([
    {
      Order: 2001,
      OrderDate: '2024-03-15',
      ShipDate: '2024-03-17',
      Items: [
        { Title: 'THE FUTURE OF AI', Quantity: 2, PaidEach: 39.95 }
      ],
      Total: 79.90 + 5.00
    }
  ]);

  return (
    <div>
      <h2>Account Information</h2>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '20px', marginBottom: '30px' }}>
        <div>
          <h3>Personal Information</h3>
          <p><strong>Name:</strong> {user.FirstName} {user.LastName}</p>
          <p><strong>Email:</strong> {user.Email}</p>
          <p><strong>Address:</strong> {user.Address}, {user.City}, {user.State} {user.Zip}</p>
        </div>
        <div>
          <h3>Account Actions</h3>
          <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
            <Button>Edit Profile</Button>
            <Button>Change Password</Button>
          </div>
        </div>
      </div>
      
      <h3>Order History</h3>
      {orders.map(order => (
        <OrderContainer key={order.Order}>
          <OrderHeader>
            <div>
              <p><strong>Order #:</strong> {order.Order}</p>
              <p><strong>Date:</strong> {new Date(order.OrderDate).toLocaleDateString()}</p>
            </div>
            <div>
              <p><strong>Total:</strong> ${order.Total.toFixed(2)}</p>
              <p><strong>Status:</strong> {order.ShipDate ? 'Shipped' : 'Processing'}</p>
            </div>
          </OrderHeader>
          <OrderItems>
            <h4>Items</h4>
            {order.Items.map((item, idx) => (
              <OrderItem key={idx}>
                <p>{item.Title} × {item.Quantity}</p>
                <p>${(item.PaidEach * item.Quantity).toFixed(2)}</p>
              </OrderItem>
            ))}
          </OrderItems>
        </OrderContainer>
      ))}
    </div>
  );
};

export default AccountPage;