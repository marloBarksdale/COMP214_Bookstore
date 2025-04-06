import React from 'react';
import { 
  FormContainer, 
  FormGroup, 
  Label, 
  Input, 
  Select, 
  SubmitButton 
} from './StyledComponents';

const CheckoutForm = ({ onSubmit }) => {
  return (
    <FormContainer onSubmit={onSubmit}>
      <FormGroup>
        <Label>First Name</Label>
        <Input type="text" required />
      </FormGroup>
      <FormGroup>
        <Label>Last Name</Label>
        <Input type="text" required />
      </FormGroup>
      <FormGroup>
        <Label>Email</Label>
        <Input type="email" required />
      </FormGroup>
      <FormGroup>
        <Label>Phone</Label>
        <Input type="tel" />
      </FormGroup>
      <FormGroup>
        <Label>Address</Label>
        <Input type="text" required />
      </FormGroup>
      <FormGroup>
        <Label>City</Label>
        <Input type="text" required />
      </FormGroup>
      <FormGroup>
        <Label>State</Label>
        <Select required>
          <option value="">Select State</option>
          <option value="CA">California</option>
          <option value="NY">New York</option>
          <option value="IL">Illinois</option>
        </Select>
      </FormGroup>
      <FormGroup>
        <Label>Zip Code</Label>
        <Input type="text" required />
      </FormGroup>
      <SubmitButton type="submit">Place Order</SubmitButton>
    </FormContainer>
  );
};

export default CheckoutForm;