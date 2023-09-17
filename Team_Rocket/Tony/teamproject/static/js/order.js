// JavaScript for order creation form
const orderForm = document.getElementById('order-form');

orderForm.addEventListener('submit', async (event) => {
    event.preventDefault();

    const formData = new FormData(orderForm);

    try {
        const response = await fetch('/order', {
            method: 'POST',
            body: formData,
        });

        if (response.ok) {
            // Order creation successful, show a success message or redirect
            console.log('Order created successfully.');
            // You can add code here to handle success, e.g., redirect to the order details page
        } else {
            // Order creation failed, display an error message
            console.error('Failed to create the order:', response.status);
            // You can add code here to display an error message to the user
        }
    } catch (error) {
        console.error('An error occurred:', error);
    }
});
