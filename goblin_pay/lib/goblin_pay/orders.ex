defmodule GoblinPay.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias GoblinPay.Repo

  alias GoblinPay.Orders.Order
  alias GoblinPay.Payments

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Gets a list of all orders for a given customer email.
  ##TODO CHECK ERROR
  Return an empty list if the customer does not exist.

  ## Examples

      iex> get_orders_for_customer("sam@goblinpay.com")
      [%Order{}, %Order{}, ...]

      iex> get_orders_for_customer("sam_with_no_orders@goblinpay.com")
      ** []

  """
  def get_orders_for_customer(customer_email_address) do
    Order
    |> where(email_address: ^customer_email_address)
    |> Repo.all()
  end

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a order with an initial payment.

  ## Examples

      iex> create_order_and_pay(%{email_address: "sam@goblinpay.com", original_order_value: 100, current_balance: 100}, 20)
      {:ok, %Order{email_address: "sam@goblinpay.com", original_order_value: 100, current_balance: 80}}

      iex> create_order_and_pay(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order_and_pay(order_attrs, paymount_amount) do
    with {:ok, order} <- create_order(order_attrs) do
      apply_payment_to_order(paymount_amount, order.id)
    end
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Applies a payment to an order.

  ## Examples

      iex> apply_payment_to_order(payment_amount, order_id)
      {:ok, %Order{}}

      ## TODO handle error for same payment duplicates
      iex> apply_payment_to_order(payment_amount, ?)

  """
  def apply_payment_to_order(payment_amount, order_id) do
    with order <- get_order!(order_id),
         {:ok, _payment} <-
           Payments.create_payment(%{amount_applied: payment_amount, order_id: order_id}),
         new_balance <- order.current_balance - payment_amount do
      update_order(order, %{current_balance: new_balance})
    end
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end
end
