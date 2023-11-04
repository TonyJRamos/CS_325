document.addEventListener('DOMContentLoaded', (event) => {
    const fetchProfileButton = document.getElementById('fetchProfileButton');
    const userId = fetchProfileButton.getAttribute('data-user-id');

    fetchProfileButton.addEventListener('click', function() {
        fetchUserProfile(userId);
    });
});

function fetchUserProfile(userId) {
    fetch(`/get_profile/${userId}`)
    .then(response => response.json())
    .then(data => {
        if (data.error) {
            console.error(data.error);
            alert('Error fetching profile.');
            return;
        }

        // Populate the orders table
        const ordersTableBody = document.querySelector("#ordersTable tbody");
        ordersTableBody.innerHTML = ""; // Clear existing rows
        data.orders.forEach(order => {
            const formattedPrice = `$${parseFloat(order.pricePaid).toFixed(2)}`;  // Format the price with dollar sign and two decimal places
            const row = `
                <tr>
                    <td>${order.orderID}</td>
                    <td>${order.itemName}</td>
                    <td>${order.itemDescription}</td>
                    <td>${formattedPrice}</td>
                    <td>${order.quantity}</td>
                    <td>${order.orderStatus}</td>
                    <td><img src="${order.image}" alt="${order.itemName}" width="50"></td>
                </tr>
            `;
            ordersTableBody.innerHTML += row;
        });
    })
    .catch(error => {
        console.error("There was an error fetching the profile data.", error);
    });
}