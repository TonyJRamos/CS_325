// JavaScript for catalog page
document.addEventListener('DOMContentLoaded', async () => {
    try {
        const response = await fetch('/catalog', {
            method: 'GET',
        });

        if (response.ok) {
            const products = await response.json();
            displayCatalog(products); // Function to display catalog items
        } else {
            // Handle error response
            console.error('Failed to fetch catalog:', response.status);
        }
    } catch (error) {
        console.error('An error occurred:', error);
    }
});

function displayCatalog(products) {
    const catalogContainer = document.getElementById('catalog-container');
    catalogContainer.innerHTML = ''; // Clear previous content

    if (products.length === 0) {
        catalogContainer.innerHTML = '<p>No products available.</p>';
        return;
    }

    const productList = document.createElement('ul');
    productList.classList.add('product-list');

    products.forEach((product) => {
        const productItem = document.createElement('li');
        productItem.classList.add('product-item');
        productItem.innerHTML = `
            <div class="product-info">
                <h2>${product.productName}</h2>
                <p>${product.description}</p>
                <p>Price: $${product.price}</p>
                <p>Available Quantity: ${product.availableQuantity}</p>
            </div>
            <button class="add-to-cart" data-sku="${product.sku}">Add to Cart</button>
        `;

        // Add event listener to the "Add to Cart" button
        productItem.querySelector('.add-to-cart').addEventListener('click', addToCart);

        productList.appendChild(productItem);
    });

    catalogContainer.appendChild(productList);
}

function addToCart(event) {
    const sku = event.target.getAttribute('data-sku');

    // Create a data object to send in the request body
    const data = { sku };

    // Make a POST request to the '/cart/add' endpoint
    fetch('/cart/add', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json', // Specify JSON content type
        },
        body: JSON.stringify(data), // Convert data object to JSON string
    })
    .then((response) => {
        if (response.ok) {
            // Handle a successful response, such as updating the cart UI
            console.log('Product added to cart successfully.');
        } else {
            // Handle errors, such as displaying an error message
            console.error('Failed to add product to cart:', response.status);
        }
    })
    .catch((error) => {
        console.error('An error occurred:', error);
    });
}
