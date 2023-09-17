// JavaScript for user login form
const loginForm = document.getElementById('login-form');

loginForm.addEventListener('submit', async (event) => {
    event.preventDefault();

    const formData = new FormData(loginForm);

    try {
        const response = await fetch('/login', {
            method: 'POST',
            body: formData,
        });

        if (response.ok) {
            // Login successful, show a success message or redirect to another page
            window.location.href = '/dashboard'; // Redirect to the dashboard page after successful login
        } else {
            // Login failed, display an error message
            const errorData = await response.json();
            alert(`Login failed: ${errorData.message}`);
        }
    } catch (error) {
        console.error('An error occurred:', error);
    }
});
