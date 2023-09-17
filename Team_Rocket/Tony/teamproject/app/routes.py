from flask import jsonify, request, render_template
from app import app, db
from app.models import User, Catalog, Orders, LineItems, SubscriptionTemplate

# Import the required function for password hashing
from werkzeug.security import check_password_hash

# Define a simple function to fetch a user by username (you should replace this with your database query)
def fetch_user_from_db(username):
    # Replace this with your database query to fetch a user by username
    user = User.query.filter_by(username=username).first()
    return user

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data['username']
    password = data['password']

    # Fetch user from the database using the defined function
    user = fetch_user_from_db(username)

    if not user or not check_password_hash(user.password, password):
        return jsonify({"message": "Invalid credentials"}), 401

    # For simplicity, returning a success message. Ideally, you'd return a JWT token or session ID.
    return jsonify({"message": "Logged in successfully"})

@app.route('/registration', methods=['GET', 'POST'])
def registration():
    # Your registration logic here
    return render_template('registration.html')

@app.route('/catalog', methods=['GET'])
def get_catalog():
    # Fetch products from the database
    products = Catalog.query.all()

    # Render the catalog.html template and pass the products to it
    return render_template('catalog.html', products=products)

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

@app.route('/order', methods=['POST'])
def create_order():
    data = request.get_json()
    customer_id = data['customer_id']
    
    # For simplicity, we're assuming the order total and tax are sent with the request. 
    # Ideally, this should be calculated based on the items being ordered.
    order = Orders(customer_id=customer_id, total=data['total'], tax=data['tax'], orderStatus='PENDING')
    db.session.add(order)
    db.session.commit()

    return jsonify({"message": "Order created successfully", "order_id": order.orderID})

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

@app.route('/subscriptions', methods=['GET', 'POST'])
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
