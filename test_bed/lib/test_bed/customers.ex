defmodule TestBed.Customers do
  use Ash.Domain

  resources do
    resource TestBed.Customers.Customer do
      # Define an interface for calling resource actions.
      define :create_customer, action: :create
      define :list_customers, action: :read
      define :update_customer, action: :update
      define :destroy_customer, action: :destroy
      define :get_customer, args: [:id], action: :by_id
    end
  end
end
