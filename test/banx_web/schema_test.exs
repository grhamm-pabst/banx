defmodule BanxWeb.SchemaTest do
  use BanxWeb.ConnCase, async: true

  alias Banx.Account
  alias Banx.Accounts.Create

  describe "account queries" do
    test "when a valid id is given, returns the account", %{conn: conn} do
      params = %{current_balance: "20.54"}

      {:ok, %Account{id: account_id}} = Create.call(params)

      query = """
      {
        getAccount(id: "#{account_id}"){
          id
          currentBalance
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "getAccount" => %{
                   "currentBalance" => "20.54",
                   "id" => _id
                 }
               }
             } = response
    end

    test "when a invalid id is given, returns an error", %{conn: conn} do
      account_id = "5ed8308c-689d-4bd7-b476-26e0aabab502"

      query = """
      {
        getAccount(id: "#{account_id}"){
          id
          currentBalance
        }
      }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      assert %{
               "data" => %{"getAccount" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 3, "line" => 2}],
                   "message" => "Account not found",
                   "path" => ["getAccount"]
                 }
               ]
             } = response
    end
  end

  describe "accounts mutations" do
    test "when all params are valid, creates the account", %{conn: conn} do
      mutation = """
        mutation {
          createAccount(input: {
            currentBalance: "25.54"
          }){
            id
            currentBalance
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "createAccount" => %{
                   "currentBalance" => "25.54",
                   "id" => _id
                 }
               }
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn} do
      mutation = """
        mutation {
          createAccount(input: {
            currentBalance: "-25.54"
          }){
            id
            currentBalance
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{"createAccount" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 5, "line" => 2}],
                   "message" => "current_balance must be greater than or equal to 0",
                   "path" => ["createAccount"]
                 }
               ]
             } = response
    end
  end

  describe "transaction mutations" do
    test "when all params are valid, returns the transaction", %{conn: conn} do
      params = %{current_balance: "20.54"}

      {:ok, %Account{id: sender_id}} = Create.call(params)
      {:ok, %Account{id: address_id}} = Create.call(params)

      mutation = """
        mutation {
          createTransaction(input: {
            senderId: "#{sender_id}",
            addressId: "#{address_id}",
            amount: "1.0"
          }) {
            id
            amount
            addressId
            senderId
            when
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{
                 "createTransaction" => %{
                   "addressId" => _address_id,
                   "amount" => "1.0",
                   "id" => _id,
                   "senderId" => _sender_id,
                   "when" => _when
                 }
               }
             } = response
    end

    test "when the amount is lower or equal to zero, returns an error", %{conn: conn} do
      params = %{current_balance: "20.54"}

      {:ok, %Account{id: sender_id}} = Create.call(params)
      {:ok, %Account{id: address_id}} = Create.call(params)

      mutation = """
        mutation {
          createTransaction(input: {
            senderId: "#{sender_id}",
            addressId: "#{address_id}",
            amount: "-1.0"
          }) {
            id
            amount
            addressId
            senderId
            when
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{"createTransaction" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 5, "line" => 2}],
                   "message" => "amount must be greater than 0",
                   "path" => ["createTransaction"]
                 }
               ]
             } = response
    end

    test "when the sender don't have enough money, returns an error", %{conn: conn} do
      params = %{current_balance: "1.00"}

      {:ok, %Account{id: sender_id}} = Create.call(params)
      {:ok, %Account{id: address_id}} = Create.call(params)

      mutation = """
        mutation {
          createTransaction(input: {
            senderId: "#{sender_id}",
            addressId: "#{address_id}",
            amount: "1.50"
          }) {
            id
            amount
            addressId
            senderId
            when
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{"createTransaction" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 5, "line" => 2}],
                   "message" => "Not enough money in sender's account",
                   "path" => ["createTransaction"]
                 }
               ]
             } = response
    end

    test "when one of the account doesn't exist, returns an error", %{conn: conn} do
      sender_id = "8aa18be8-3e28-4076-81bf-e0122461747d"
      address_id = "8aa18be8-3e28-4076-81bf-e0122461747c"

      mutation = """
        mutation {
          createTransaction(input: {
            senderId: "#{sender_id}",
            addressId: "#{address_id}",
            amount: "1.50"
          }) {
            id
            amount
            addressId
            senderId
            when
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{"createTransaction" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 5, "line" => 2}],
                   "message" => "One of the accounts doesn't exists",
                   "path" => ["createTransaction"]
                 }
               ]
             } = response
    end

    test "when the accounts are the same, returns an error", %{conn: conn} do
      sender_id = "8aa18be8-3e28-4076-81bf-e0122461747d"
      address_id = "8aa18be8-3e28-4076-81bf-e0122461747d"

      mutation = """
        mutation {
          createTransaction(input: {
            senderId: "#{sender_id}",
            addressId: "#{address_id}",
            amount: "1.50"
          }) {
            id
            amount
            addressId
            senderId
            when
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      assert %{
               "data" => %{"createTransaction" => nil},
               "errors" => [
                 %{
                   "locations" => [%{"column" => 5, "line" => 2}],
                   "message" => "sender_id Sender should not be the same as the Address",
                   "path" => ["createTransaction"]
                 }
               ]
             } = response
    end
  end
end
