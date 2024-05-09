# [PR-1] - Create Order/Payment Context Functionality

## Pull Request Description

This PR creates schemas, migrations, context modules/functions, and tests to support orders and payments for Goblin Pay. 

New functionality includes: 

`create_order/1` - Takes a map of order attributes and creates an order without an initial payment

`get_order!/1` - Takes an order id and returns the order and associated payments

`get_orders_for_customer/1` - Takes a customer email string and returns a list of orders for that customer

`apply_payment_to_order/2` - Takes an order_id or order, creates a new payment, and updates the orders current balance. A database lock is placed on orders to insure idempotency. An error will raise if payment exceeds current balance.

`create_order_and_pay/2` - Takes a map of order attributes and an initial payment, creates an order and payment, and updates order balance. An error will raise if capturing payment is not successful.

Other more basic context functions added: 

Orders:
`list_orders/0`, `update_order/1`, `delete_order/1`, and `change_order/1`

Payments:
`list_payments/0`, `get_payment!/1`, `create_payment/1`, `update_payment/2`, `delete_payment/1` and `change_payment/1`

## Testing
* adds `orders_test.exs`
* adds `payments_test.exs`
* adds `orders_fixures.ex`
* adds `payments_fixtures.ex`


## Type of change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [X] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)

## Checklist:

- [x] I have performed a self-review of my own code
- [x] I have made corresponding changes to the documentation
- [x] My changes generate no new warnings
- [x] I have added tests that prove my fix is effective or that my feature works
- [x] New and existing unit tests pass locally with my changes
- [x] I have checked my code and corrected any misspellings

## Notes for Reviewer

* This phoenix project was spun up for the express purpose of context functionality. No API or web layer implementation was added onto the initial boiler plate.
* The inclusion of helper function `capture_payment/0` will cause an orders test to fail sporadically. Ideally, for future implemention the failure of order creation with an initial payment would be tested with a mock to ensure expected error handling.