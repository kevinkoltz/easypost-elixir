defmodule Easypost.Address do
  alias Easypost.Requester

  defstruct [
    id: "",
    object: "Address",
    street1: "",
    street2: "",
    city: "",
    state: "",
    zip: "",
    country: "",
    name: "",
    company: "",
    phone: "",
    email: "",
    residential: false,
    created_at: "",
    updated_at: ""
  ]

  @type t :: %__MODULE__{
    id: String.t,
    object: String.t,
    street1: String.t,
    street2: String.t,
    city: String.t,
    state: String.t,
    zip: String.t,
    country: String.t,
    name: String.t,
    company: String.t,
    phone: String.t,
    email: String.t,
    residential: boolean(),
    created_at: String.t,
    updated_at: String.t
  }

  @spec create_address(map(), t) :: {:ok, t} | {:error, Easypost.Error.t}
  def create_address(conf, address) do  
    params = %{"address" => address}
    case Requester.post("/addresses", params, conf) do
      {:ok, address} -> {:ok, struct(Easypost.Address, address)}
      {:error, _status, reason} -> {:error, struct(Easypost.Error, reason)}
    end
  end

  @spec create_and_verify_address(map(), t) :: {:ok, t, map()} | {:error, Easypost.Error.t}
  def create_and_verify_address(conf, address) do
    params = %{"address" => address, "verify[]" => "delivery"} 
    case Requester.post("/addresses", params, conf) do
      {:ok, response} ->
        if response[:verifications][:delivery][:success] do
          {:ok, struct(Easypost.Address, response), extract_details(response)}
        else
          reason = [
            code: "ADDRESS.VERIFY.FAILURE",
            errors: extract_errors(response),
            message: "Unable to verify address."
          ]
          {:error, struct(Easypost.Error, reason)}
        end
      {:error, _status, reason} -> {:error, struct(Easypost.Error, reason)}
    end
  end

  defp extract_details(response) do
    response[:verifications][:delivery][:details]
    |> Enum.into(%{})
  end

  defp extract_errors(response) do
    response[:verifications][:delivery][:errors]
  end
end
