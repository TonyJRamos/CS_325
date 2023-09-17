// JavaScript for subscription management form
const subscriptionForm = document.getElementById('subscription-form');

subscriptionForm.addEventListener('submit', async (event) => {
    event.preventDefault();

    const formData = new FormData(subscriptionForm);

    try {
        const response = await fetch('/subscriptions', {
            method: 'POST',
            body: formData,
        });

        if (response.ok) {
            // Subscription creation successful, show a success message or redirect
            console.log('Subscription created successfully.');
            // You can add code here to handle success, e.g., refresh the subscription list
        } else {
            // Subscription creation failed, display an error message
            console.error('Failed to create the subscription:', response.status);
            // You can add code here to display an error message to the user
        }
    } catch (error) {
        console.error('An error occurred:', error);
    }
});
