from flask import jsonify, request, render_template, flash, redirect, url_for, session
from flask_login import login_user, logout_user, login_required, UserMixin, current_user
from app import app, db
from app.models import User, Catalog, Orders, LineItems, SubscriptionTemplate
from app.forms import RegistrationForm
from .models import Address, Orders, Customer, LineItems, Catalog
from decimal import Decimal
import json

# Import the required function for password hashing
from werkzeug.security import check_password_hash, generate_password_hash

# Define a simple function to fetch a user by username (you should replace this with your database query)
def fetch_user_from_db(username):
    # Replace this with your database query to fetch a user by username
    user = User.query.filter_by(username=username).first()
    return user

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        user = fetch_user_from_db(username)

        if not user:
            flash('Username not found', 'error')
            return redirect(url_for('login'))

        if not check_password_hash(user.password, password):
            flash('Incorrect password', 'error')
            return redirect(url_for('login'))

        # Login the user using Flask-Login's login_user function
        login_user(user)

        flash('Logged in successfully', 'success')
        return redirect(url_for('dashboard'))

    return render_template('login.html')

@app.route('/logout')
@login_required  # Use the login_required decorator to protect this route
def logout():
    # Logout the user using Flask-Login's logout_user function
    logout_user()
    
    flash('Logged out successfully', 'success')
    return redirect(url_for('index'))

@app.route('/registration', methods=['GET', 'POST'])
def registration():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # Check if the user already exists
        existing_user = User.query.filter_by(username=username).first()
        if existing_user:
            return "Username already taken", 400

        hashed_password = generate_password_hash(password)

        new_user = User(username=username, password=hashed_password)
        db.session.add(new_user)
        try:
            db.session.commit()
            print(f"Added user with ID: {new_user.userID}")
        except Exception as e:
            print(f"Error committing new user: {e}")
            db.session.rollback()
            return "Error registering user", 500

        # Redirect to the after_registration route after successfully registering the user
        return redirect(url_for('after_registration', user_id=new_user.userID))

    return render_template('registration.html')

@app.route('/after_registration/<int:user_id>', methods=['GET', 'POST'])
def after_registration(user_id):
    user = User.query.get_or_404(user_id)

    if request.method == 'POST':
        name = request.form['name']
        creditCard = request.form['creditCard']
        city = request.form['city']
        state = request.form['state']
        address = request.form['address']
        email = request.form['email']

        new_customer = Customer(userID=user.userID, name=name, creditCard=creditCard, city=city, state=state, address=address, email=email)
        db.session.add(new_customer)
        try:
            db.session.commit()
            print(f"Added customer with User ID: {user.userID}")
        except Exception as e:
            print(f"Error adding customer: {e}")
            db.session.rollback()
            return "Error adding customer details", 500

        # Render a template with a success message and a button to redirect to the login page
        return render_template('registration_success.html', user=user)

    return render_template('after_registration.html', user=user)

@app.route('/dashboard')
@login_required  # Use the login_required decorator to protect this route
def dashboard():
    return render_template('dashboard.html', user=current_user)  # Pass the 'user' variable to the template context

@app.route('/profile', methods=['GET', 'POST'])
def customer_profile():
    # Get the logged-in user's ID from the session
    user_id = session.get('user_id')
    if not user_id:
        flash('You need to log in first.', 'error')
        return redirect(url_for('login'))

    user = User.query.get_or_404(user_id)
    customer = user.customers.first()  # Assuming one-to-one relationship between User and Customer

    if request.method == 'POST':
        # Collect data from the form fields
        name = request.form['name']
        creditCard = request.form['creditCard']

        if not customer:
            # Create a new customer if none exists
            new_customer = Customer(userID=user_id, name=name, creditCard=creditCard)
            db.session.add(new_customer)
        else:
            # Update existing customer
            customer.name = name
            customer.creditCard = creditCard

        db.session.commit()
        flash('Profile updated successfully.', 'success')
        return redirect(url_for('index'))

    return render_template('customer_profile.html', user=user, customer=customer)

@app.route('/get_profile/<int:user_id>', methods=['GET'])
def get_profile(user_id):
    user = User.query.get(user_id)  # Assuming User is your model name
    if not user:
        return jsonify(error="User not found"), 404

    profile_data = {
        'username': user.username,
        'email': user.email,
        # Add other fields as needed
    }
    return jsonify(profile_data)

@app.route('/get_catalog', methods=['GET'])
def get_catalog():
    try:
        # Fetch products from the database
        products = Catalog.query.all()
        print("Number of products:", len(products))  # Add this line for debugging

        if request.accept_mimetypes.best == 'application/json':
            product_data = [{
                'id': product.SKU,  # Use the correct SKU or ID property
                'name': product.itemName
            } for product in products]

            print("Product data:", product_data)  # Add this line for debugging
            return jsonify(product_data)
        else:
            # Render the catalog.html template and pass the products to it
            return render_template('catalog.html', products=products)
    except Exception as e:
        print("Error fetching catalog:", str(e))
        return jsonify({'error': 'An error occurred while fetching the catalog'}), 500


# Define a function to fetch all products (you should replace this with your own logic)
def fetch_all_products():
    products = Catalog.query.all()
    product_data = []

    for product in products:
        product_data.append({
            'SKU': product.SKU,
            'itemName': product.itemName,
            'itemDescription': product.itemDescription,
            'price': str(product.price),  # Convert to string for JSON serialization
            'availableQuantity': product.availableQuantity
        })

    return product_data

@app.route('/order', methods=['GET', 'POST'])
def create_order():
    if request.method == 'GET':
        products = Catalog.query.all()
        return render_template('order.html', products=products)
    elif request.method == 'POST':
        item_id = request.form.get('item_id')
        shipping_address = request.form.get('shipping_address')
        
        if not item_id or not shipping_address:
            flash('Missing item selection or shipping address', 'danger')
            return redirect(url_for('create_order'))

        # Fetch the selected product's price
        product = Catalog.query.get(item_id)
        if not product:
            flash('Selected item not found', 'danger')
            return redirect(url_for('create_order'))

        total = product.price  # Using actual product price from database
        tax = 0.10 * total  # For example, applying a 10% tax

        try:
            order = Orders(customerID=current_user.id, itemID=item_id, shippingAddress=shipping_address, total=total, tax=tax, orderStatus='PENDING')
            db.session.add(order)
            db.session.commit()
            flash('Order created successfully!', 'success')
            return redirect(url_for('dashboard'))
        except Exception as e:
            print(str(e))
            db.session.rollback()
            flash('Error creating the order', 'danger')
            return redirect(url_for('create_order'))

    return render_template('order.html')  # This line is redundant but can be a safety net



@app.route('/order/<int:order_id>/items', methods=['POST'])
def add_item_to_order(order_id):
    data = request.get_json()
    sku = data['sku']
    quantity = data['quantity']

    # Check item availability
    item = Catalog.query.get(sku)
    if not item or item.availableQuantity < quantity:
        return jsonify({"message": "Item not available in the required quantity"}), 400

    # Reduce item quantity in catalog
    item.availableQuantity -= quantity

    # Add item to order
    line_item = LineItems(orderID=order_id, SKU=sku, quantity=quantity)
    db.session.add(line_item)
    db.session.commit()

    return jsonify({"message": "Item added successfully"})

@app.route('/order/<int:order_id>', methods=['GET'])
def get_order_details(order_id):
    order = Orders.query.get(order_id)
    if not order:
        return jsonify({"message": "Order not found"}), 404

    # Assuming you've set up a backref in LineItems to Orders in your models
    items = [item.SKU for item in order.items]

    return jsonify({"orderID": order.orderID, "items": items})

@app.route('/submit_order', methods=['POST'])
@login_required
def submit_order():
    # Debugging: Log the received data
    print("Received data:", json.dumps(request.json, indent=4))

    # Extract the SKUs of the selected products
    selected_products = request.json.get('selected_products', [])

    # Ensure selected_products is always a list
    if isinstance(selected_products, str):
        selected_products = [selected_products]

    # Convert the SKUs in selected_products to integers
    selected_products = [int(sku) for sku in selected_products]

    # Extract the quantities for each selected product
    quantities = {sku: int(request.json.get('quantity-' + str(sku))) for sku in selected_products}

    # Extract shipping address details
    addressLine1 = request.json['addressLine1']
    addressLine2 = request.json.get('addressLine2', '')
    city = request.json['city']
    state = request.json['state']
    zipCode = request.json['zipCode']
    country = request.json['country']

    try:
        products = Catalog.query.filter(Catalog.SKU.in_(selected_products)).all()

        # Decrement the available quantities
        for product in products:
            product.availableQuantity -= quantities[product.SKU]
            if product.availableQuantity < 0:
                db.session.rollback()
                return jsonify({"message": "Insufficient stock for product " + product.itemName}), 400

        total = sum([product.price * quantities[product.SKU] for product in products])
        tax = total * Decimal('0.1')  # Convert float to Decimal for the calculation

        order = Orders(customerID=current_user.id, total=total, tax=tax, orderStatus='PENDING')
        db.session.add(order)
        db.session.flush() 

        # Save each selected product as a line item for this order
        for product in products:
            line_item = LineItems(orderID=order.orderID, SKU=product.SKU, quantity=quantities[product.SKU])
            db.session.add(line_item)

        shipping_address = Address(
            customerID=current_user.id,
            addressType='Shipping',
            addressLine1=addressLine1,
            addressLine2=addressLine2,
            city=city,
            state=state,
            zipCode=zipCode,
            country=country
        )
        db.session.add(shipping_address)
        
        db.session.commit()
    except Exception as e:
        print(str(e))
        db.session.rollback()
        return jsonify({"message": "Error creating the order"}), 500

    return jsonify({"message": "Order created successfully", "order_id": order.orderID})

@app.route('/subscriptions', methods=['GET', 'POST'], endpoint='subscription')
def manage_subscriptions():
    if request.method == 'GET':
        # Fetch and return subscriptions
        subscriptions = SubscriptionTemplate.query.all()
        return jsonify([sub.SKU for sub in subscriptions])
    elif request.method == 'POST':
        data = request.get_json()
        sub = SubscriptionTemplate(SKU=data['sku'], frequencyInMonths=data['frequency'])
        db.session.add(sub)
        db.session.commit()

        return jsonify({"message": "Subscription created successfully"})

@app.errorhandler(404)
def not_found(e):
    return jsonify({"message": "Resource not found"}), 404

@app.errorhandler(500)
def server_error(e):
    return jsonify({"message": "Internal server error"}), 500
