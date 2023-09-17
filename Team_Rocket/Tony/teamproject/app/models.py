from app import db

class User(db.Model):
    userID = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(255), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    customers = db.relationship('Customer', backref='user', lazy=True)

class Customer(db.Model):
    customerID = db.Column(db.Integer, primary_key=True)
    userID = db.Column(db.Integer, db.ForeignKey('user.userID'), nullable=False)
    name = db.Column(db.String(255), nullable=False)
    creditCard = db.Column(db.String(255))
    addresses = db.relationship('Address', backref='customer', lazy=True)
    orders = db.relationship('Orders', backref='customer', lazy=True)

class Address(db.Model):
    addressID = db.Column(db.Integer, primary_key=True)
    customerID = db.Column(db.Integer, db.ForeignKey('customer.customerID'), nullable=False)
    addressType = db.Column(db.Enum('Shipping', 'Billing'), nullable=False)
    addressLine1 = db.Column(db.String(255), nullable=False)
    addressLine2 = db.Column(db.String(255))
    city = db.Column(db.String(100))
    state = db.Column(db.String(100))
    zipCode = db.Column(db.String(20))
    country = db.Column(db.String(100))

class Catalog(db.Model):
    SKU = db.Column(db.Integer, primary_key=True)
    itemName = db.Column(db.String(255), nullable=False)
    itemDescription = db.Column(db.Text)
    price = db.Column(db.Numeric(10,2), nullable=False)
    availableQuantity = db.Column(db.Integer, nullable=False)
    imageUrl = db.Column(db.String(512))  # Assuming URLs won't be longer than 512 characters
    line_items = db.relationship('LineItems', backref='catalog', lazy=True)
    subscription_templates = db.relationship('SubscriptionTemplate', backref='catalog', lazy=True)

class Orders(db.Model):
    orderID = db.Column(db.Integer, primary_key=True)
    customerID = db.Column(db.Integer, db.ForeignKey('customer.customerID'), nullable=False)
    total = db.Column(db.Numeric(10,2))
    tax = db.Column(db.Numeric(10,2))
    orderStatus = db.Column(db.Enum('PENDING', 'SHIPPED', 'INVOICED', 'RETURNED'))
    line_items = db.relationship('LineItems', backref='orders', lazy=True)

class LineItems(db.Model):
    lineItemID = db.Column(db.Integer, primary_key=True)
    orderID = db.Column(db.Integer, db.ForeignKey('orders.orderID'), nullable=False)
    SKU = db.Column(db.Integer, db.ForeignKey('catalog.SKU'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    shipments = db.relationship('Shipment', backref='line_items', lazy=True)

class Shipment(db.Model):
    shipmentID = db.Column(db.Integer, primary_key=True)
    lineItemID = db.Column(db.Integer, db.ForeignKey('line_items.lineItemID'), nullable=False)
    status = db.Column(db.Enum('PICK', 'PACK', 'SHIP'))

class SubscriptionTemplate(db.Model):
    templateID = db.Column(db.Integer, primary_key=True)
    SKU = db.Column(db.Integer, db.ForeignKey('catalog.SKU'), nullable=False)
    frequencyInMonths = db.Column(db.Integer, nullable=False)
    subscription_orders = db.relationship('SubscriptionOrders', backref='subscription_template', lazy=True)

class SubscriptionOrders(db.Model):
    subscriptionOrderID = db.Column(db.Integer, primary_key=True)
    templateID = db.Column(db.Integer, db.ForeignKey('subscription_template.templateID'), nullable=False)
    orderID = db.Column(db.Integer, db.ForeignKey('orders.orderID'), nullable=False)
