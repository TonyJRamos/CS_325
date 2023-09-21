// JavaScript for user registration form
const registrationForm = document.getElementById('registration-form');

registrationForm.addEventListener('submit', async (event) => {
    event.preventDefault();

    const formData = new FormData(registrationForm);
    
    // Fetch the action URL from the form's data-action-url attribute
    const actionURL = registrationForm.getAttribute('data-action-url');

    try {
        const response = await fetch(actionURL, {
            method: 'POST',
            body: formData,
        });

        if (response.ok) {
            // Registration successful
            window.location.href = '/profile'; // Redirect to the customer profile page
        } else {
            // Registration failed, display an error message
            const errorData = await response.json(); // Parse the error response
            alert(`Registration failed: ${errorData.message}`);
        }
    } catch (error) {
        console.error('An error occurred:', error);
    }
});
