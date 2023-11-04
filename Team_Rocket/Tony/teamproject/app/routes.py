from flask import jsonify, request, render_template, flash, redirect, url_for, session, current_app
from flask_login import login_user, logout_user, login_required, UserMixin, current_user
from app import app, db
from app.models import User, Catalog, Orders, LineItems, SubscriptionTemplate, SubscriptionOrders
from app.forms import RegistrationForm
from .models import Address, Orders, Customer, LineItems, Catalog, OrderDetails
from decimal import Decimal
from datetime import datetime, timedelta
import json

# Import the required function for password hashing
from werkzeug.security import check_password_hash, generate_password_hash

# Add the requires_roles decorator here
from functools import wraps

def requires_roles(*roles):
    def wrapper(f):
        @wraps(f)
        def wrapped(*args, **kwargs):
            if current_user.role not in roles:
                return "Unauthorized", 403
            return f(*args, **kwargs)
        return wrapped
    return wrapper

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
        zipCode = request.form['zipCode']
        email = request.form['email']

        new_customer = Customer(userID=user.userID, name=name, creditCard=creditCard, city=city, state=state, address=address, zipCode=zipCode, email=email)
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
@login_required
def dashboard():
    if current_user.role == "admin":
        return render_template('admin_dashboard.html', user=current_user)
    else:
        return render_template('dashboard.html', user=current_user)

@app.route('/profile', methods=['GET', 'POST'])
@login_required  # Ensure that the user is logged in
def customer_profile():
    # Get the logged-in user's ID directly from Flask-Login's current_user
    user_id = current_user.userID

    user = User.query.get_or_404(user_id)
    customer = user.customers[0] if user.customers else None

    if request.method == 'POST':
        # Collect data from the form fields
        name = request.form['name']
        creditCard = request.form['creditCard']
        city = request.form['city']
        state = request.form['state']
        address = request.form['address']
        zipCode = request.form['zipCode']
        email = request.form['email']

        if not customer:
            # Create a new customer if none exists
            new_customer = Customer(
                userID=user_id, 
                name=name, 
                creditCard=creditCard, 
                city=city, 
                state=state, 
                address=address, 
                zipCode=zipCode, 
                email=email
            )
            db.session.add(new_customer)
        else:
            # Update existing customer
            customer.name = name
            customer.creditCard = creditCard
            customer.city = city
            customer.state = state
            customer.address = address
            customer.zipCode = zipCode
            customer.email = email

        db.session.commit()
        flash('Profile updated successfully.', 'success')
        return render_template('customer_profile.html', user=current_user, customer=customer)

    return render_template('customer_profile.html', user=current_user, customer=customer)

@app.route('/get_profile/<int:user_id>', methods=['GET'])
def get_profile(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify(error="User not found"), 404

    # Get related customer details
    if user.customers:
        customer = user.customers[0]
    else:
        return jsonify(error="Customer details not found for user"), 404

    # Get customer's orders
    orders_data = []
    orders = Orders.query.filter_by(customerID=customer.customerID).all()

    for order in orders:
        order_details = OrderDetails.query.filter_by(orderID=order.orderID).all()
        
        for detail in order_details:
            catalog_item = Catalog.query.get(detail.SKU)
            order_detail = {
                'orderID': detail.orderID,
                'itemName': detail.itemName,
                'itemDescription': detail.itemDescription,
                'pricePaid': float(detail.priceAtTimeOfOrder) + float(order.tax),  # Assuming price and tax are both floats
                'quantity': detail.quantity,
                'image': catalog_item.imageUrl,
                'orderStatus': order.orderStatus
            }
            orders_data.append(order_detail)

    profile_data = {
        'username': user.username,
        'email': customer.email,
        'address': customer.address,
        'orders': orders_data
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

    details = order.order_details
    items = [{"SKU": detail.SKU, "quantity": detail.quantity, "priceAtTimeOfOrder": str(detail.priceAtTimeOfOrder)} for detail in details]

    return jsonify({"orderID": order.orderID, "items": items})

@app.route('/submit_order', methods=['POST'])
@login_required
def submit_order():
    print("Received data:", json.dumps(request.json, indent=4))

    # Extract the SKUs of the selected products
    selected_products = request.json.get('selected_products', [])

    if isinstance(selected_products, str):
        selected_products = [selected_products]

    selected_products = [int(sku) for sku in selected_products]
    quantities = {sku: int(request.json.get('quantity-' + str(sku))) for sku in selected_products}

    addressLine1 = request.json['addressLine1']
    addressLine2 = request.json.get('addressLine2', '')
    city = request.json['city']
    state = request.json['state']
    zipCode = request.json['zipCode']
    country = request.json['country']

    try:
        products = Catalog.query.filter(Catalog.SKU.in_(selected_products)).all()

        customer = Customer.query.filter_by(userID=current_user.id).first()
        if not customer:
            return jsonify({"message": "Customer not found"}), 400

        for product in products:
            product.availableQuantity -= quantities[product.SKU]
            if product.availableQuantity < 0:
                db.session.rollback()
                return jsonify({"message": "Insufficient stock for product " + product.itemName}), 400

        total = sum([product.price * quantities[product.SKU] for product in products])
        tax = total * Decimal('0.1')

        order = Orders(customerID=customer.customerID, total=total, tax=tax, orderStatus='PENDING')
        db.session.add(order)
        db.session.flush() 

        for product in products:
            order_detail = OrderDetails(
                orderID=order.orderID,
                SKU=product.SKU,
                itemName=product.itemName,  # Fetching product name
                itemDescription=product.itemDescription,  # Fetching product description
                quantity=quantities[product.SKU],
                priceAtTimeOfOrder=product.price
            )
            db.session.add(order_detail)

        shipping_address = Address(
            customerID=customer.customerID,
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
        # Fetch all subscription templates
        subscriptions = SubscriptionTemplate.query.all()

        # Convert each subscription to a dictionary of its attributes
        subscriptions_data = [{
            'templateID': sub.templateID,
            'SKU': sub.SKU,
            'frequencyInMonths': sub.frequencyInMonths,
            'duration': sub.frequencyInMonths,
            'price': str(sub.price)  # Convert to string for JSON serialization
        } for sub in subscriptions]

        # Render the template and pass the subscriptions to it
        return render_template('subscription.html', subscriptions=subscriptions_data)

    elif request.method == 'POST':
        data = request.get_json()

        # Create a new SubscriptionTemplate object with data from the request
        sub = SubscriptionTemplate(
            SKU=data['sku'],
            frequencyInMonths=data['frequencyInMonths'],
            duration=data['duration'],
            price=data['price']
        )

        db.session.add(sub)
        db.session.commit()

        return jsonify({"message": "Subscription created successfully"})

@app.route('/subscribe', methods=['GET', 'POST'], endpoint='subscribe')
def subscribe():
    if request.method == 'GET':
        # Fetch all subscription templates
        subscriptions = SubscriptionTemplate.query.all()

        # Convert each subscription to a dictionary of its attributes
        subscriptions_data = [{
            'templateID': sub.templateID,
            'SKU': sub.SKU,
            'frequencyInMonths': sub.frequencyInMonths,
            'duration': sub.frequencyInMonths,
            'price': str(sub.price),
            'planName': sub.planName
        } for sub in subscriptions]

        # Render a new template for customers
        return render_template('subscribe.html', subscriptions=subscriptions_data)
    
    elif request.method == 'POST':
        # Receive the chosen subscription's templateID from the form
        chosen_template_id = request.form.get('templateID')

        # Find the corresponding subscription template
        chosen_subscription = SubscriptionTemplate.query.get(chosen_template_id)

        if not chosen_subscription:
            return jsonify({"error": "Subscription not found"}), 404

        # Link the subscription to the user
        # Here, I'm assuming you might have a model/table to link users with their subscriptions.
        # If not, you'll need to design this based on your requirements.
        user_subscription = UserSubscription(userID=current_user.id, templateID=chosen_template_id)
        db.session.add(user_subscription)

        # Process payment
        # TODO: Integrate with your payment gateway, handle the transaction.

        # Send a confirmation
        # TODO: Maybe send a confirmation email or show a message to the user.

        db.session.commit()

        return jsonify({"message": "Subscription successful!"}), 200

def add_months_to_date(start_date, months):
    month = start_date.month - 1 + months
    year = start_date.year + month // 12
    month = month % 12 + 1
    day = min(start_date.day, [31,
        29 if year % 4 == 0 and (year % 100 != 0 or year % 400 == 0) else 28,
        31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month-1])
    return start_date.replace(year=year, month=month, day=day)

@app.route('/subscribe_process', methods=['POST'])
@login_required  # Ensure user is logged in
def subscribe_process():
    try:
        current_app.logger.info('Starting subscription process...')

        # Retrieve the templateID from the form data
        template_id = request.form.get('templateID')
        current_app.logger.info(f'Received templateID: {template_id}')

        # Fetch the selected subscription template
        selected_template = SubscriptionTemplate.query.get(template_id)
        if not selected_template:
            flash('Invalid subscription template selected.', 'error')
            return redirect(url_for('subscribe'))

        # Calculate end time based on the subscription duration
        start_time = datetime.utcnow()
        end_time = start_time + timedelta(days=30*selected_template.duration)

        # Fetch the Customer object corresponding to the current_user's userID
        customer = Customer.query.filter_by(userID=current_user.id).first()
        if not customer:
            # Handle the case where the customer is not found
            flash('Customer not found.', 'error')
            return redirect(url_for('subscribe'))

        # Create an order for the subscription
        tax_rate = Decimal('0.10')  # Convert the float to a Decimal
        new_order = Orders(
            customerID=customer.customerID,
            total=selected_template.price,  # Assuming price is total before tax
            tax=selected_template.price * tax_rate,  # Use the Decimal value for multiplication
            orderStatus="SUBSCRIBED"  # Or any other default status
        )

        db.session.add(new_order)
        db.session.flush()  # This will generate an orderID without committing the transaction

        # Create a new subscription order with the associated orderID
        new_subscription = SubscriptionOrders(
            templateID=template_id,
            orderID=new_order.orderID,  # Set the orderID here
            start_time=start_time,
            end_time=end_time,
            planName=selected_template.planName
        )

        db.session.add(new_subscription)
        db.session.commit()

        current_app.logger.info('Subscription added to the database.')

        flash('Subscription successful!', 'success')
        return redirect(url_for('subscribe'))

    except Exception as e:
        current_app.logger.error(f'Error occurred: {e}')
        flash('An error occurred while processing your subscription. Please try again.', 'error')
        return redirect(url_for('subscribe'))

@app.errorhandler(404)
def not_found(e):
    return jsonify({"message": "Resource not found"}), 404

@app.errorhandler(500)
def server_error(e):
    return jsonify({"message": "Internal server error"}), 500
