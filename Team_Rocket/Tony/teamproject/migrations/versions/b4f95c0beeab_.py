"""empty message

Revision ID: b4f95c0beeab
Revises: 
Create Date: 2023-10-31 16:03:33.368901

"""
from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import mysql

# revision identifiers, used by Alembic.
revision = 'b4f95c0beeab'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('Customer',
    sa.Column('customerID', sa.Integer(), nullable=False),
    sa.Column('userID', sa.Integer(), nullable=False),
    sa.Column('name', sa.String(length=255), nullable=False),
    sa.Column('creditCard', sa.String(length=19), nullable=True),
    sa.Column('city', sa.String(length=255), nullable=True),
    sa.Column('state', sa.String(length=255), nullable=True),
    sa.Column('address', sa.String(length=255), nullable=True),
    sa.Column('zipCode', sa.String(length=10), nullable=True),
    sa.Column('email', sa.String(length=255), nullable=True),
    sa.ForeignKeyConstraint(['userID'], ['User.userID'], ),
    sa.PrimaryKeyConstraint('customerID'),
    sa.UniqueConstraint('email')
    )
    op.create_table('SubscriptionTemplate',
    sa.Column('templateID', sa.Integer(), nullable=False),
    sa.Column('planName', sa.String(length=255), nullable=False),
    sa.Column('SKU', sa.Integer(), nullable=False),
    sa.Column('frequencyInMonths', sa.Integer(), nullable=False),
    sa.Column('price', sa.Numeric(precision=10, scale=2), nullable=False),
    sa.Column('duration', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['SKU'], ['Catalog.SKU'], ),
    sa.PrimaryKeyConstraint('templateID')
    )
    op.create_table('Address',
    sa.Column('addressID', sa.Integer(), nullable=False),
    sa.Column('customerID', sa.Integer(), nullable=False),
    sa.Column('addressType', sa.Enum('Shipping', 'Billing'), nullable=False),
    sa.Column('addressLine1', sa.String(length=255), nullable=False),
    sa.Column('addressLine2', sa.String(length=255), nullable=True),
    sa.Column('city', sa.String(length=100), nullable=True),
    sa.Column('state', sa.String(length=100), nullable=True),
    sa.Column('zipCode', sa.String(length=10), nullable=True),
    sa.Column('country', sa.String(length=100), nullable=True),
    sa.ForeignKeyConstraint(['customerID'], ['Customer.customerID'], ),
    sa.PrimaryKeyConstraint('addressID')
    )
    op.create_table('Orders',
    sa.Column('orderID', sa.Integer(), nullable=False),
    sa.Column('customerID', sa.Integer(), nullable=False),
    sa.Column('total', sa.Numeric(precision=10, scale=2), nullable=True),
    sa.Column('tax', sa.Numeric(precision=10, scale=2), nullable=True),
    sa.Column('orderStatus', sa.Enum('PENDING', 'SHIPPED', 'INVOICED', 'RETURNED', 'SUBSCRIBED'), nullable=True),
    sa.ForeignKeyConstraint(['customerID'], ['Customer.customerID'], ),
    sa.PrimaryKeyConstraint('orderID')
    )
    op.create_table('LineItems',
    sa.Column('lineItemID', sa.Integer(), nullable=False),
    sa.Column('orderID', sa.Integer(), nullable=False),
    sa.Column('SKU', sa.Integer(), nullable=False),
    sa.Column('quantity', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['SKU'], ['Catalog.SKU'], ),
    sa.ForeignKeyConstraint(['orderID'], ['Orders.orderID'], ),
    sa.PrimaryKeyConstraint('lineItemID')
    )
    op.create_table('OrderDetails',
    sa.Column('orderDetailID', sa.Integer(), nullable=False),
    sa.Column('orderID', sa.Integer(), nullable=False),
    sa.Column('SKU', sa.Integer(), nullable=False),
    sa.Column('itemName', sa.String(length=255), nullable=False),
    sa.Column('itemDescription', sa.Text(), nullable=True),
    sa.Column('quantity', sa.Integer(), nullable=False),
    sa.Column('priceAtTimeOfOrder', sa.Numeric(precision=10, scale=2), nullable=False),
    sa.ForeignKeyConstraint(['SKU'], ['Catalog.SKU'], ),
    sa.ForeignKeyConstraint(['orderID'], ['Orders.orderID'], ),
    sa.PrimaryKeyConstraint('orderDetailID')
    )
    op.create_table('SubscriptionOrders',
    sa.Column('subscriptionOrderID', sa.Integer(), nullable=False),
    sa.Column('templateID', sa.Integer(), nullable=True),
    sa.Column('orderID', sa.Integer(), nullable=True),
    sa.Column('status', sa.String(length=100), nullable=True),
    sa.Column('start_time', sa.DateTime(), nullable=True),
    sa.Column('end_time', sa.DateTime(), nullable=True),
    sa.Column('planName', sa.String(length=255), nullable=True),
    sa.ForeignKeyConstraint(['orderID'], ['Orders.orderID'], ),
    sa.ForeignKeyConstraint(['templateID'], ['SubscriptionTemplate.templateID'], ),
    sa.PrimaryKeyConstraint('subscriptionOrderID')
    )
    op.create_table('Shipment',
    sa.Column('shipmentID', sa.Integer(), nullable=False),
    sa.Column('lineItemID', sa.Integer(), nullable=False),
    sa.Column('status', sa.Enum('PICK', 'PACK', 'SHIP'), nullable=True),
    sa.ForeignKeyConstraint(['lineItemID'], ['LineItems.lineItemID'], ),
    sa.PrimaryKeyConstraint('shipmentID')
    )
    op.drop_table('line_items')
    op.drop_table('shipment')
    op.drop_table('subscription_orders')
    op.drop_table('subscription_template')
    op.drop_table('catalog')
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.drop_index('username')

    op.drop_table('user')
    op.drop_table('address')
    op.drop_table('orders')
    op.drop_table('customer')
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('customer',
    sa.Column('customerID', mysql.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('userID', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('name', mysql.VARCHAR(length=255), nullable=False),
    sa.Column('creditCard', mysql.VARCHAR(length=255), nullable=True),
    sa.ForeignKeyConstraint(['userID'], ['user.userID'], name='customer_ibfk_1'),
    sa.PrimaryKeyConstraint('customerID'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )
    op.create_table('orders',
    sa.Column('orderID', mysql.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('customerID', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('total', mysql.DECIMAL(precision=10, scale=2), nullable=True),
    sa.Column('tax', mysql.DECIMAL(precision=10, scale=2), nullable=True),
    sa.Column('orderStatus', mysql.ENUM('PENDING', 'SHIPPED', 'INVOICED', 'RETURNED'), nullable=True),
    sa.ForeignKeyConstraint(['customerID'], ['customer.customerID'], name='orders_ibfk_1'),
    sa.PrimaryKeyConstraint('orderID'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )
    op.create_table('address',
    sa.Column('addressID', mysql.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('customerID', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('addressType', mysql.ENUM('Shipping', 'Billing'), nullable=False),
    sa.Column('addressLine1', mysql.VARCHAR(length=255), nullable=False),
    sa.Column('addressLine2', mysql.VARCHAR(length=255), nullable=True),
    sa.Column('city', mysql.VARCHAR(length=100), nullable=True),
    sa.Column('state', mysql.VARCHAR(length=100), nullable=True),
    sa.Column('zipCode', mysql.VARCHAR(length=20), nullable=True),
    sa.Column('country', mysql.VARCHAR(length=100), nullable=True),
    sa.ForeignKeyConstraint(['customerID'], ['customer.customerID'], name='address_ibfk_1'),
    sa.PrimaryKeyConstraint('addressID'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )
    op.create_table('user',
    sa.Column('userID', mysql.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('username', mysql.VARCHAR(length=255), nullable=False),
    sa.Column('password', mysql.VARCHAR(length=255), nullable=False),
    sa.PrimaryKeyConstraint('userID'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )
    with op.batch_alter_table('user', schema=None) as batch_op:
        batch_op.create_index('username', ['username'], unique=False)

    op.create_table('catalog',
    sa.Column('SKU', mysql.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('itemName', mysql.VARCHAR(length=255), nullable=False),
    sa.Column('itemDescription', mysql.TEXT(), nullable=True),
    sa.Column('price', mysql.DECIMAL(precision=10, scale=2), nullable=False),
    sa.Column('availableQuantity', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.PrimaryKeyConstraint('SKU'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )
    op.create_table('subscription_template',
    sa.Column('templateID', mysql.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('SKU', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('frequencyInMonths', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.ForeignKeyConstraint(['SKU'], ['catalog.SKU'], name='subscription_template_ibfk_1'),
    sa.PrimaryKeyConstraint('templateID'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )
    op.create_table('subscription_orders',
    sa.Column('subscriptionOrderID', mysql.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('templateID', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('orderID', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.ForeignKeyConstraint(['orderID'], ['orders.orderID'], name='subscription_orders_ibfk_1'),
    sa.ForeignKeyConstraint(['templateID'], ['subscription_template.templateID'], name='subscription_orders_ibfk_2'),
    sa.PrimaryKeyConstraint('subscriptionOrderID'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )
    op.create_table('shipment',
    sa.Column('shipmentID', mysql.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('lineItemID', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('status', mysql.ENUM('PICK', 'PACK', 'SHIP'), nullable=True),
    sa.ForeignKeyConstraint(['lineItemID'], ['line_items.lineItemID'], name='shipment_ibfk_1'),
    sa.PrimaryKeyConstraint('shipmentID'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )
    op.create_table('line_items',
    sa.Column('lineItemID', mysql.INTEGER(), autoincrement=True, nullable=False),
    sa.Column('orderID', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('SKU', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.Column('quantity', mysql.INTEGER(), autoincrement=False, nullable=False),
    sa.ForeignKeyConstraint(['SKU'], ['catalog.SKU'], name='line_items_ibfk_1'),
    sa.ForeignKeyConstraint(['orderID'], ['orders.orderID'], name='line_items_ibfk_2'),
    sa.PrimaryKeyConstraint('lineItemID'),
    mysql_collate='utf8mb4_0900_ai_ci',
    mysql_default_charset='utf8mb4',
    mysql_engine='InnoDB'
    )
    op.drop_table('Shipment')
    op.drop_table('SubscriptionOrders')
    op.drop_table('OrderDetails')
    op.drop_table('LineItems')
    op.drop_table('Orders')
    op.drop_table('Address')
    op.drop_table('SubscriptionTemplate')
    op.drop_table('Customer')
    # ### end Alembic commands ###
