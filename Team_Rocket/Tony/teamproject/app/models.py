from app import db
from flask_login import UserMixin
from datetime import datetime

class User(db.Model, UserMixin):  # Inherit from UserMixin
    __tablename__ = 'User'
    
    userID = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(255), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    role = db.Column(db.String(10), default="standard")
    customers = db.relationship('Customer', backref='user', lazy=True)

    # Add an id attribute that returns the user's ID
    @property
    def id(self):
        return str(self.userID)

class Customer(db.Model):
    __tablename__ = 'Customer'
    
    customerID = db.Column(db.Integer, primary_key=True)
    userID = db.Column(db.Integer, db.ForeignKey('User.userID'), nullable=False)
    name = db.Column(db.String(255), nullable=False)
    creditCard = db.Column(db.String(19))
    city = db.Column(db.String(255))
    state = db.Column(db.String(255))
    address = db.Column(db.String(255))
    zipCode = db.Column(db.String(10), default=None)
    email = db.Column(db.String(255), unique=True, nullable=True)
    addresses = db.relationship('Address', backref='customer_ref', lazy=True)
    orders = db.relationship('Orders', backref='customer_ref', lazy=True)


class Address(db.Model):
    __tablename__ = 'Address'

    addressID = db.Column(db.Integer, primary_key=True)
    customerID = db.Column(db.Integer, db.ForeignKey('Customer.customerID'), nullable=False)
    addressType = db.Column(db.Enum('Shipping', 'Billing'), nullable=False)
    addressLine1 = db.Column(db.String(255), nullable=False)
    addressLine2 = db.Column(db.String(255))
    city = db.Column(db.String(100))
    state = db.Column(db.String(100))
    zipCode = db.Column(db.String(10))
    country = db.Column(db.String(100))

class Catalog(db.Model):
    __tablename__ = 'Catalog'

    SKU = db.Column(db.Integer, primary_key=True)
    itemName = db.Column(db.String(255), nullable=False)
    itemDescription = db.Column(db.Text)
    price = db.Column(db.Numeric(10,2), nullable=False)
    availableQuantity = db.Column(db.Integer, nullable=False)
    imageUrl = db.Column(db.String(512))
    line_items = db.relationship('LineItems', backref='catalog_ref', lazy=True)
    subscription_templates = db.relationship('SubscriptionTemplate', backref='catalog_ref', lazy=True)

class Orders(db.Model):
    __tablename__ = 'Orders'

    orderID = db.Column(db.Integer, primary_key=True)
    customerID = db.Column(db.Integer, db.ForeignKey('Customer.customerID'), nullable=False)
    total = db.Column(db.Numeric(10,2))
    tax = db.Column(db.Numeric(10,2))
    orderStatus = db.Column(db.Enum('PENDING', 'SHIPPED', 'INVOICED', 'RETURNED', 'SUBSCRIBED'))
    line_items = db.relationship('LineItems', backref='orders_ref', lazy=True)

class OrderDetails(db.Model):
    __tablename__ = 'OrderDetails'

    orderDetailID = db.Column(db.Integer, primary_key=True)  # Renamed from lineItemID for clarity
    orderID = db.Column(db.Integer, db.ForeignKey('Orders.orderID'), nullable=False)
    SKU = db.Column(db.Integer, db.ForeignKey('Catalog.SKU'), nullable=False)
    itemName = db.Column(db.String(255), nullable=False)
    itemDescription = db.Column(db.Text)
    quantity = db.Column(db.Integer, nullable=False)
    priceAtTimeOfOrder = db.Column(db.Numeric(10,2), nullable=False)

    # Relationships (if needed)
    catalog_item = db.relationship('Catalog', backref=db.backref('order_details', lazy=True))
    order = db.relationship('Orders', backref=db.backref('order_details', lazy=True))

class LineItems(db.Model):
    __tablename__ = 'LineItems'

    lineItemID = db.Column(db.Integer, primary_key=True)
    orderID = db.Column(db.Integer, db.ForeignKey('Orders.orderID'), nullable=False)
    SKU = db.Column(db.Integer, db.ForeignKey('Catalog.SKU'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    shipments = db.relationship('Shipment', backref='line_items_ref', lazy=True)

class Shipment(db.Model):
    __tablename__ = 'Shipment'

    shipmentID = db.Column(db.Integer, primary_key=True)
    lineItemID = db.Column(db.Integer, db.ForeignKey('LineItems.lineItemID'), nullable=False)
    status = db.Column(db.Enum('PICK', 'PACK', 'SHIP'))

class SubscriptionTemplate(db.Model):
    __tablename__ = 'SubscriptionTemplate'

    templateID = db.Column(db.Integer, primary_key=True)
    planName = db.Column(db.String(255), nullable=False)
    SKU = db.Column(db.Integer, db.ForeignKey('Catalog.SKU'), nullable=False)
    frequencyInMonths = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Numeric(10,2), nullable=False)  # Add the price column
    duration = db.Column(db.Integer, nullable=False)     # Add the duration column if needed
    subscription_orders = db.relationship('SubscriptionOrders', backref='subscription_template_ref', lazy=True)

class SubscriptionOrders(db.Model):
    __tablename__ = 'SubscriptionOrders'

    subscriptionOrderID = db.Column(db.Integer, primary_key=True)
    templateID = db.Column(db.Integer, db.ForeignKey('SubscriptionTemplate.templateID'))
    orderID = db.Column(db.Integer, db.ForeignKey('Orders.orderID'))

    status = db.Column(db.String(100), default="Active")
    start_time = db.Column(db.DateTime, default=datetime.utcnow)
    end_time = db.Column(db.DateTime)
    planName = db.Column(db.String(255))