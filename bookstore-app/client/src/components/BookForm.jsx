// src/components/BookForm.jsx
import styled from 'styled-components';

const Form = styled.form`
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 2rem;
`;

const Input = styled.input`
  padding: 0.5rem;
  flex: 1 1 200px;
`;

const Button = styled.button`
  padding: 0.5rem 1rem;
`;

function BookForm({ formData, handleChange, handleSubmit }) {
  return (
    <Form onSubmit={handleSubmit}>
      <Input name="ISBN" placeholder="ISBN" value={formData.ISBN} onChange={handleChange} required />
      <Input name="Title" placeholder="Title" value={formData.Title} onChange={handleChange} required />
      <Input name="PubDate" placeholder="PubDate (YYYY-MM-DD)" value={formData.PubDate} onChange={handleChange} required />
      <Input name="PubID" placeholder="PubID" value={formData.PubID} onChange={handleChange} required />
      <Input name="Cost" placeholder="Cost" value={formData.Cost} onChange={handleChange} required />
      <Input name="Retail" placeholder="Retail" value={formData.Retail} onChange={handleChange} required />
      <Input name="Discount" placeholder="Discount" value={formData.Discount} onChange={handleChange} />
      <Input name="Category" placeholder="Category" value={formData.Category} onChange={handleChange} required />
      <Button type="submit">Add Book</Button>
    </Form>
  );
}

export default BookForm;
