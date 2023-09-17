// JavaScript for user registration form
const registrationForm = document.getElementById('registration-form');

registrationForm.addEventListener('submit', async (event) => {
    event.preventDefault();

    const formData = new FormData(registrationForm);

    try {
        const response = await fetch('/register', {
            method: 'POST',
            body: formData,
        });

        if (response.ok) {
            // Registration successful
            window.location.href = '/login'; // Redirect to the login page
        } else {
            // Registration failed, display an error message
            const errorData = await response.json(); // Parse the error response
            alert(`Registration failed: ${errorData.message}`);
        }
    } catch (error) {
        console.error('An error occurred:', error);
    }
});