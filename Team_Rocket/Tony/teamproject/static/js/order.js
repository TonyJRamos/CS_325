// Fetch catalog and populate the items
const orderForm = document.getElementById('order-form');

orderForm.addEventListener('submit', async (event) => {
    event.preventDefault();

    const formData = new FormData(orderForm);
    const data = {};

    formData.forEach((value, key) => {
        data[key] = value;
    });

    try {
        const response = await fetch('/submit_order', {  // Updated URL here
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });

        if (response.headers.get('Content-Type').includes('application/json')) {
            const responseData = await response.json();
            if (response.ok) {
                console.log('Order created successfully.', responseData.message);
                alert(responseData.message);
            } else {
                console.error('Failed to create the order:', responseData.message);
                alert('Failed to create the order: ' + responseData.message);
            }
        } else {
            console.error('Expected JSON, but received:', await response.text());
            alert('There was an error processing your order.');
        }
    } catch (error) {
        console.error('An error occurred:', error);
        alert('There was an error processing your order.');
    }
});



