"""Initial migration

Revision ID: 4b61fdbdfe89
Revises: 
Create Date: 2023-09-15 01:39:42.994650

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = '4b61fdbdfe89'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('catalog',
    sa.Column('SKU', sa.Integer(), nullable=False),
    sa.Column('itemName', sa.String(length=255), nullable=False),
    sa.Column('itemDescription', sa.Text(), nullable=True),
    sa.Column('price', sa.Numeric(precision=10, scale=2), nullable=False),
    sa.Column('availableQuantity', sa.Integer(), nullable=False),
    sa.PrimaryKeyConstraint('SKU')
    )
    op.create_table('user',
    sa.Column('userID', sa.Integer(), nullable=False),
    sa.Column('username', sa.String(length=255), nullable=False),
    sa.Column('password', sa.String(length=255), nullable=False),
    sa.PrimaryKeyConstraint('userID'),
    sa.UniqueConstraint('username')
    )
    op.create_table('customer',
    sa.Column('customerID', sa.Integer(), nullable=False),
    sa.Column('userID', sa.Integer(), nullable=False),
    sa.Column('name', sa.String(length=255), nullable=False),
    sa.Column('creditCard', sa.String(length=255), nullable=True),
    sa.ForeignKeyConstraint(['userID'], ['user.userID'], ),
    sa.PrimaryKeyConstraint('customerID')
    )
    op.create_table('subscription_template',
    sa.Column('templateID', sa.Integer(), nullable=False),
    sa.Column('SKU', sa.Integer(), nullable=False),
    sa.Column('frequencyInMonths', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['SKU'], ['catalog.SKU'], ),
    sa.PrimaryKeyConstraint('templateID')
    )
    op.create_table('address',
    sa.Column('addressID', sa.Integer(), nullable=False),
    sa.Column('customerID', sa.Integer(), nullable=False),
    sa.Column('addressType', sa.Enum('Shipping', 'Billing'), nullable=False),
    sa.Column('addressLine1', sa.String(length=255), nullable=False),
    sa.Column('addressLine2', sa.String(length=255), nullable=True),
    sa.Column('city', sa.String(length=100), nullable=True),
    sa.Column('state', sa.String(length=100), nullable=True),
    sa.Column('zipCode', sa.String(length=20), nullable=True),
    sa.Column('country', sa.String(length=100), nullable=True),
    sa.ForeignKeyConstraint(['customerID'], ['customer.customerID'], ),
    sa.PrimaryKeyConstraint('addressID')
    )
    op.create_table('orders',
    sa.Column('orderID', sa.Integer(), nullable=False),
    sa.Column('customerID', sa.Integer(), nullable=False),
    sa.Column('total', sa.Numeric(precision=10, scale=2), nullable=True),
    sa.Column('tax', sa.Numeric(precision=10, scale=2), nullable=True),
    sa.Column('orderStatus', sa.Enum('PENDING', 'SHIPPED', 'INVOICED', 'RETURNED'), nullable=True),
    sa.ForeignKeyConstraint(['customerID'], ['customer.customerID'], ),
    sa.PrimaryKeyConstraint('orderID')
    )
    op.create_table('line_items',
    sa.Column('lineItemID', sa.Integer(), nullable=False),
    sa.Column('orderID', sa.Integer(), nullable=False),
    sa.Column('SKU', sa.Integer(), nullable=False),
    sa.Column('quantity', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['SKU'], ['catalog.SKU'], ),
    sa.ForeignKeyConstraint(['orderID'], ['orders.orderID'], ),
    sa.PrimaryKeyConstraint('lineItemID')
    )
    op.create_table('subscription_orders',
    sa.Column('subscriptionOrderID', sa.Integer(), nullable=False),
    sa.Column('templateID', sa.Integer(), nullable=False),
    sa.Column('orderID', sa.Integer(), nullable=False),
    sa.ForeignKeyConstraint(['orderID'], ['orders.orderID'], ),
    sa.ForeignKeyConstraint(['templateID'], ['subscription_template.templateID'], ),
    sa.PrimaryKeyConstraint('subscriptionOrderID')
    )
    op.create_table('shipment',
    sa.Column('shipmentID', sa.Integer(), nullable=False),
    sa.Column('lineItemID', sa.Integer(), nullable=False),
    sa.Column('status', sa.Enum('PICK', 'PACK', 'SHIP'), nullable=True),
    sa.ForeignKeyConstraint(['lineItemID'], ['line_items.lineItemID'], ),
    sa.PrimaryKeyConstraint('shipmentID')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('shipment')
    op.drop_table('subscription_orders')
    op.drop_table('line_items')
    op.drop_table('orders')
    op.drop_table('address')
    op.drop_table('subscription_template')
    op.drop_table('customer')
    op.drop_table('user')
    op.drop_table('catalog')
    # ### end Alembic commands ###
