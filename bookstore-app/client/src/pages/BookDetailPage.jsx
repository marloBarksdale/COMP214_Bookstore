import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  DetailContainer, 
  DetailCover, 
  DetailInfo, 
  DetailTitle,
  DetailMeta,
  DetailDescription,
  BookPrice,
  CartButton,
  Label,
  Input
} from '../components/StyledComponents';

// Mock data for book details
const mockBooks = [
  {
    ISBN: 'B300',
    Title: 'THE FUTURE OF AI',
    PubDate: '2024-03-05',
    PubID: 10,
    Cost: 25.50,
    Retail: 39.95,
    Discount: null,
    Category: 'TECHNOLOGY',
    Author: 'OLIVIA WILLIAMS',
    Publisher: 'GLOBAL PRINTS'
  },
  {
    ISBN: 'B301',
    Title: 'MODERN COOKING',
    PubDate: '2024-02-10',
    PubID: 11,
    Cost: 18.75,
    Retail: 29.95,
    Discount: null,
    Category: 'COOKING',
    Author: 'JACKSON TAYLOR',
    Publisher: 'BOOK HAVEN'
  },
  {
    ISBN: 'B302',
    Title: 'WEB DEVELOPMENT ESSENTIALS',
    PubDate: '2024-01-15',
    PubID: 10,
    Cost: 30.00,
    Retail: 49.95,
    Discount: 5.00,
    Category: 'TECHNOLOGY',
    Author: 'OLIVIA WILLIAMS',
    Publisher: 'GLOBAL PRINTS'
  },
  {
    ISBN: 'B303',
    Title: 'MYSTERY OF THE ANCIENT TEMPLE',
    PubDate: '2024-02-20',
    PubID: 11,
    Cost: 20.00,
    Retail: 34.95,
    Discount: null,
    Category: 'FICTION',
    Author: 'JACKSON TAYLOR',
    Publisher: 'BOOK HAVEN'
  }
];

const BookDetailPage = () => {
  const { isbn } = useParams();
  const navigate = useNavigate();
  const [book, setBook] = useState(null);
  const [quantity, setQuantity] = useState(1);

  useEffect(() => {
    // In a real app, fetch book details from API
    const bookData = mockBooks.find(b => b.ISBN === isbn);
    setBook(bookData);
  }, [isbn]);

  const addToCart = () => {
    if (!book) return;
    
    const cartItem = {
      ISBN: book.ISBN,
      Title: book.Title,
      Quantity: quantity,
      Price: book.Retail,
      Total: book.Retail * quantity
    };
    
    // In a real app, this would update cart state in a global context or store
    alert(`Added to cart: ${cartItem.Title} (${cartItem.Quantity})`);
    
    // Navigate to cart page
    navigate('/cart');
  };

  if (!book) {
    return <div>Loading...</div>;
  }

  return (
    <DetailContainer>
      <DetailCover>{book.Title.substring(0, 2)}</DetailCover>
      <DetailInfo>
        <DetailTitle>{book.Title}</DetailTitle>
        <DetailMeta>
          <p><strong>Author:</strong> {book.Author}</p>
          <p><strong>Publisher:</strong> {book.Publisher}</p>
          <p><strong>Category:</strong> {book.Category}</p>
          <p><strong>Publication Date:</strong> {new Date(book.PubDate).toLocaleDateString()}</p>
          <p><strong>ISBN:</strong> {book.ISBN}</p>
        </DetailMeta>
        <DetailDescription>
          This is a detailed description of the book. In a real application, this would contain actual book content summary.
        </DetailDescription>
        <BookPrice>${book.Retail.toFixed(2)}</BookPrice>
        
        <div style={{ display: 'flex', gap: '10px', alignItems: 'center', marginTop: '20px' }}>
          <Label>Quantity:</Label>
          <Input 
            type="number" 
            min="1" 
            value={quantity}
            onChange={(e) => setQuantity(parseInt(e.target.value))}
            style={{ width: '60px' }}
          />
          <CartButton onClick={addToCart}>Add to Cart</CartButton>
        </div>
      </DetailInfo>
    </DetailContainer>
  );
};

export default BookDetailPage;